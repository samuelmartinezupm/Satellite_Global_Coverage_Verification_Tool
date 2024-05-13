# Global Coverage Verification Tool

This code is © Samuel M. Zamacola, 2024, and it is made available under the GPL license enclosed with the software.

Over and above the legal restrictions imposed by this license, if you use this software for an academic publication then you are obliged to provide proper attribution to the paper that describes it:
+ Samuel Martínez Zamacola, Ramón Martínez Rodríguez-Osorio, Miguel A. Salas-Natera, "Joint Satellite Platform and Constellation Sizing for Fast Beam-Hopping in 5G/6G Non-Terrestrial Networks",

Def.: "Global coverage is defined as the condition where for any time instant, any terrestrial terminal, independent of its location, is able to establish a link with at least one satellite of the constellation under the defined minimum elevation angle."

* INPUT: Satellite's orbital height (h_sat) and minimum elevation angle (el_min).

* OUTPUT: Required constellation size -> number of orbital planes (P) and satellites per plane (T_P). 

Included Files:
+ main_global_coverge.m -> Through the primary script the simulation is configured. Once satellite's orbital height (h_sat) and minimum elevation angle are defined (el_min), together with the range of orbital planes (P) and satellites per plane (T_P) intented to be tested, the global coverage verification is initiaed. Each T_P/P combination produces a console output each time it evaluates a potential complete constellation, by saving the results in a txt file, and ploting the boolean results per pseudo ground station location stating the accesss. To reduce the computational complexity a reduced ground station set is also available for the testing, by placing ground stations just in the equator, as the critical region for global coverage. The option can be activated by setting to 1 the "reduced" variable.

+ gs_sat_viewing.m -> An auxiliary function for propagating a given satellite by determining its accesses with all the GSs. For computational relaxation reasons, a single satellite is just propagated at each function execution, by determining the access with all the ground stations for all the time samples.
