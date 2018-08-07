function [VoltageViolations] = gctgcalculateVoltageViolations9bus(V,bus,genout)
%GCTGCALCULATEVOLTAGEVIOLATIONS - Calculates voltage violations for
%generator outage
%
% Inputs: 1P1Q estimated voltage V, bus data, from bus, to bus
% Outputs: Condensed matrix with ONLY violated bus voltage
% violations
%
% gctgCombinedVoltageViolations: (NX8) where N is the number of violations
% [<---branch contingency --->  <---bus violated--><-----------------under voltage---------------><--------over voltage---------------------------> 
% [generator                         bus             current_value low_limit percent_undervoltage  current_value   high_limit  percent_overvoltage]

Vm = abs(V);
%-------------------------------------------------------------------------
% Compute Buses Overvoltage
%-------------------------------------------------------------------------
VoltageViolations = zeros(9,7);

% Undervoltage Violations
for i=1:9
    if Vm(i,1) < bus(i,13)
            VoltageViolations(i,1) = i;
            VoltageViolations(i,2) = Vm(i,1);
            VoltageViolations(i,3) = bus(i,13);
            VoltageViolations(i,4) = Vm(i,1)./bus(i,13);        
    else
    end;
end;

%OverVoltage Violations
for i=1:9
    if Vm(i,1) > bus(i,12)
      VoltageViolations(i,1) = i;
      VoltageViolations(i,5) = Vm(i,1);
      VoltageViolations(i,6) = bus(i,12);      
      VoltageViolations(i,7) = Vm(i,1)./bus(i,12);
    else
    end;
end;

% Because MATLAB math is not so correct this is needed to correct it at limits 
for i=1:9
    if abs(Vm(i,1) - bus(i,12)) < 0.00000005
      VoltageViolations(i,1) = 0;
    else
    end;
end;

%Eliminate zero rows
n=9;
while n >0
    if VoltageViolations(n,1) == 0
        VoltageViolations(n,:) = [];
    else
    end;      
    n = n-1;
end;

VoltageViolations;

D = size(VoltageViolations);
VoltageViolations2 = zeros(D(1),8);
for i=1:D(1)
    VoltageViolations2(i,1) = genout;
    VoltageViolations2(i,2) = VoltageViolations(i,1);
    VoltageViolations2(i,3) = VoltageViolations(i,2);
    VoltageViolations2(i,4) = VoltageViolations(i,3);
    VoltageViolations2(i,5) = VoltageViolations(i,4);
    VoltageViolations2(i,6) = VoltageViolations(i,5);
    VoltageViolations2(i,7) = VoltageViolations(i,6);    
    VoltageViolations2(i,8) = VoltageViolations(i,7); 
end;

VoltageViolations = VoltageViolations2;
clear VoltageViolations2;
return;

