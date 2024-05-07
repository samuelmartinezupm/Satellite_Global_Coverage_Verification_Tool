function [gs,gsAccess] = gs_satviewing(T_P,P,idx)

global h_sat;
global el_min;
global reduced;

% Orbital Period:
G= 6.6743*10^-11; % Gravitational Constant [m3kg-1s-2]
M= 5.9722*10^24; % Earth mass [kg]
Re= 6371; % Earth Radious [km]
T_orbital=2*pi*sqrt((Re*10^3+h_sat*10^3)^3/(G*M)); % Orbital Period [s]

%tic

% Create a Satellite (Sat) Scenario: Nearly polar orbit WALKER STAR constellation.
mission.StartDate = datetime(2022,10,10,15,0,0);
dur=10; % Define number of sampling units: dur+1.
samplin=T_orbital/dur; % Sample time [s].
mission.Duration = seconds(dur*samplin); %[s];
T = T_P*P; % Total number of satellites.
Re = 6370; % [km].
a = h_sat + Re;
PhAng = 360/T_P/P; % == 360/(T)
F = PhAng*T/180; % Relative spacing between satellites in adjacent planes.
inclination = 87; % [°].

t = []; % True anomaly [°].
for i = 1:P
    t = [t,linspace(PhAng*(i-1),360-PhAng*(P-i+1),T_P)];
end

mission.ConstellationDefinition = table( ...
    a*10^3 * ones(T,1), ... % Semi-major axis [m].
    0    * ones(T,1), ... % Eccentricity.
    inclination        * ones(T,1), ... % Inclination [°].
    sort(repmat(linspace(0, 180*(1-1/P), P), 1,T_P))', ... % Right ascension of the ascending node [°].
    270       * ones(T,1), ... % Argument of periapsis [°].
    t', ... % True anomaly [°].
    'VariableNames', ["a [m]", "e", "i [°]", "Ω [°]", "ω [°]", "ν [°]"]);

mission.ConstellationDefinition;

scenario = satelliteScenario(mission.StartDate, mission.StartDate + mission.Duration, samplin);

sat_walker = satellite(scenario, mission.ConstellationDefinition.("a [m]"), mission.ConstellationDefinition.e, ...
    mission.ConstellationDefinition.("i [°]"), mission.ConstellationDefinition.("Ω [°]"), ...
    mission.ConstellationDefinition.("ω [°]"), mission.ConstellationDefinition.("ν [°]"), "OrbitPropagator","two-body-keplerian");

% Create a Ground Station (GS) Scenario: global/reduced
if reduced==0
    % Pseudo Ground Station (GS) set:
    sepgs=10; % Angular granularity [°] between GS.
    [Lat, Long]=meshgrid(90:sepgs:270,-180:sepgs:175);
    [aux1, aux2]=size(Long);
    for g= 1:1:aux1*aux2
        groundStation(scenario, mod(Lat(g),180)-90,Long(g), "MinElevationAngle", el_min, "Name", "a"+num2str(Lat(g))+num2str(Long(g)));
    end
else
    % Reduced Pseudo Ground Station (GS) set centered around the equator (CRITICAL REGION):
    sepgs=20; % Angular granularity [°] between GS.
    [Lat, Long]=meshgrid(-30:sepgs:30,-180:sepgs:175);
    [aux1, aux2]=size(Long);
    for g= 1:1:aux1*aux2
        groundStation(scenario, Lat(g),Long(g), "MinElevationAngle", el_min, "Name", "a"+num2str(Lat(g))+num2str(Long(g)));
    end
end
% % PLOT defined GS position:
% figure 
% geoscatter(scenario.GroundStations.Latitude, scenario.GroundStations.Longitude,5, "black", "filled")
% geolimits([-90 90], [-180 180])
% title("Ground Stations")

% Determine the access between Sat(idx) <-> GS
gsAccess = zeros(size(scenario.GroundStations,1)*size(scenario.GroundStations,2),dur+1); 
access(scenario.GroundStations, sat_walker(idx));
%fprintf('\n\tsat%03d\n', idx);
gsAccess = accessStatus(scenario.GroundStations.Accesses);

% Output the entire GS set when the last satelltie is being tested: idx==T_P*P.
if (idx==T_P*P)
    if reduced==0
        for g= 1:1:aux1*aux2
            gs(g)=groundStation(scenario, mod(Lat(g),180)-90,Long(g), "MinElevationAngle", el_min, "Name", "a"+num2str(Lat(g))+num2str(Long(g)));
        end
    else
        for g= 1:1:aux1*aux2
            gs(g)=groundStation(scenario, Lat(g),Long(g), "MinElevationAngle", el_min, "Name", "a"+num2str(Lat(g))+num2str(Long(g)));
        end
    end
else
    gs=1;
end

%toc

end