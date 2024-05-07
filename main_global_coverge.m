%% GLOBAL COVERAGE VERIFYING TOOL: 
% "Global coverage is understood as the condition where for any time
% instant, any terrestrial terminal, independent of its location, is 
% able to spot and establish a link under the defined minimum elevation 
% angle requirement, with at least one satellite within the constellation."

clc;
clear;
close all;

global h_sat;
global el_min;
global reduced;

% Constelation to be evaluated:
h_sat=350; % Satellite's altitude [km].
el_min=20; % Minimum elevation angle [°] criteria.

% Verification type:
reduced=1; % 1) Reduced complexity verification, the evaluation is solely performed in the equator as this is the critical region. 0) Verification performed along the entire globe.
N_sats=1; % Global coverage: with one satellite under view is enough.

% Orbital configurations to be tested:
T_P=24:1:28; % Number of satellites per orbital plane.
P=26:1:29; % Number of orbital planes.

for i=P
    for j=T_P
        fprintf("\nTesting... T_P= "+j+" ; P= " + i+"\n")
        gsAccess=0;
        for idx = 1:i*j
            [gs,gsAccesst]=gs_sat_viewing(j,i,idx); % Determine the access between satellite idx within the T/P configuration with all the ground stations. 
            gsAccess = gsAccess + gsAccesst; % Accumulate the access, for the rest of the satellites.
        end

       % Ensure that the access is mantained for all the GS in all the time instants.
       if length(find(gsAccess<N_sats))>0
            fprintf("\n T_P= "+j+" ; P= " + i+" configuration N\n")
       else
           fprintf("\n T_P= "+j+" ; P= " + i+" configuration Y\n")
       end

       % SAVE access results for T/P config.:
       writematrix(gsAccess,"T_P="+j+";P=" + i + ".txt") 

       % PLOT access map results for T/P config.:
       gsAccess_alltimes=ones(size(gsAccess,1),1);
       for idi=1:size(gsAccess,2)
            gsAccess_alltimes=gsAccess_alltimes.*gsAccess(:,idi); % If one of the accesses is 0, then the continous global coverage condition can't be assured.
       end

       for idy = 1:length(gs)
           if (gsAccess_alltimes(idy) > 0)
               geoscatter(gs(idy).Latitude, gs(idy).Longitude,15, "green", "filled"); % Access.
           else
               geoscatter(gs(idy).Latitude, gs(idy).Longitude,15, "red", "filled");
           end
           hold on 
       end
       geolimits([-90 90], [-180 180])
       title("T_P= "+j+" ; P= " + i)
       hold off

       % % PLOT access map results for T/P config. per time instant:
       % for idt=1:size(gsAccess,2) 
       %     figure(idt)
       %     for idy = 1:length(gs)
       %         if (gsAccess(idy,idt) > 0)
       %             geoscatter(gs(idy).Latitude, gs(idy).Longitude,15, "green", "filled"); % Access.
       %         else
       %             geoscatter(gs(idy).Latitude, gs(idy).Longitude,15, "red", "filled");
       %         end
       %         hold on 
       %     end
       %     geolimits([-90 90], [-180 180])
       %     title("T_P= "+j+" ; P= " + i + " ; t= " + idt)
       %     hold off
       %  end
    end
end
   

