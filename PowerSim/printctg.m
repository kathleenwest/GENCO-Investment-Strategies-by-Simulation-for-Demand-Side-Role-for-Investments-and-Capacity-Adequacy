function printctg(bctgCombinedMVAoverloads,bctgCombinedVoltageViolations,gctgCombinedMVAoverloads,gctgCombinedVoltageViolations)

fprintf('\n');
fprintf('\n');
fprintf('\n_____________________________________________________________________');
fprintf('\n');
fprintf('\n                N-1 Branch Contingency Results                       ');
fprintf('\n');
fprintf('\n');
fprintf('\n Screening routine to examine each non-islanding branch outage in the 9 bus system. ');
fprintf('\n Estimates all post-contingency voltage magnitudes and all'); 
fprintf('\n post-contingency MVA branch flows.');
fprintf('\n')
fprintf('\n Inputs: Base case AC power flow solutions with baseMVA, bus, gen, and');
fprintf('\n branch matrices for the 9 bus system');
fprintf('\n Outputs: Condensed matrix with ONLY violated branch MVA overloads and bus voltage');
fprintf('\n violations');
fprintf('\n');
fprintf('\n');
fprintf('\n');
fprintf('\n');
fprintf('\n MVA Overloads Due to Any Branch Outage');
fprintf('\n');
fprintf('\n bctgCombinedMVAoverloads: (NX5) where N is the number of violations');
fprintf('\n [<---branch contingency --->  <---branch overloaded-->  <---violation--->');
fprintf('\n [from_bus             to_bus  from_bus         to_bus   percent_overload]');
fprintf('\n');
fprintf('\n');
bctgCombinedMVAoverloads
fprintf('\n');
fprintf('\n');
fprintf('\n Voltage Violations Due to Any Branch Outage');
fprintf('\n');
fprintf('\n bctgCombinedVoltageViolations: (NX9) where N is the number of violations');
fprintf('\n');
fprintf('\n [<---branch contingency --->  <---bus violated--><-----------------under voltage---------------><--------over voltage---------------------------> ');
fprintf('\n [from_bus             to_bus       bus             current_value low_limit percent_undervoltage  current_value   high_limit  percent_overvoltage]');
fprintf('\n');
fprintf('\n');
bctgCombinedVoltageViolations


fprintf('\n');
fprintf('\n');
fprintf('\n_____________________________________________________________________');
fprintf('\n');
fprintf('\n                N-1 Generator Contingency Results                       ');
fprintf('\n');
fprintf('\n');
fprintf('\n Screening routine to examine each generator unit outage (except the swing) in the  ');
fprintf('\n 9 bus system. Estimates all post-contingency voltage magnitudes'); 
fprintf('\n and all post-contingency MVA branch flows.');
fprintf('\n')
fprintf('\n Inputs: Base case AC power flow solutions with baseMVA, bus, gen, and');
fprintf('\n branch matrices for the 9 bus system');
fprintf('\n Outputs: Condensed matrix with ONLY violated branch MVA overloads and bus voltage');
fprintf('\n violations');
fprintf('\n');
fprintf('\n');
fprintf('\n');
fprintf('\n');



fprintf('\n MVA Overloads Due to Any Generator Outage');
fprintf('\n');
fprintf('\n gctgCombinedMVAoverloads: (NX4 where N is the number of violations');
fprintf('\n [<-generator contingency --->  <---branch overloaded-->  <---violation--->');
fprintf('\n [     generator bus             from_bus         to_bus   percent_overload]');
fprintf('\n');
fprintf('\n');
gctgCombinedMVAoverloads
fprintf('\n');
fprintf('\n');
fprintf('\n Voltage Violations Due to Any Generator Outage');
fprintf('\n');
fprintf('\n gctgCombinedVoltageViolations: (NX8) where N is the number of violations');
fprintf('\n');
fprintf('\n [<---generator contingency --->  <---bus violated--><-----------------under voltage---------------><--------over voltage--------------------------->  ');
fprintf('\n [       generator bus                        bus      current_value low_limit percent_undervoltage  current_value   high_limit  percent_overvoltage]');
fprintf('\n');
fprintf('\n');
gctgCombinedVoltageViolations





return;
