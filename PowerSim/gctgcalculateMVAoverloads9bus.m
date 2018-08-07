function [MVAoverloads] = gctgcalculateMVAoverloads9bus(genout,branchnew,Sf,St)
%GCTGCALCULATEMVAOVERLOADS - Calculates MVA violations for generator
% outage
%
% Inputs: 1P1Q estimated voltage V, bus data, from bus, to bus
% Outputs: Condensed matrix with ONLY violated MVA
% violations
%
% gctgCombinedMVAoverloads: (NX4 where N is the number of violations
% [<-generator contingency --->  <---branch overloaded-->  <---violation--->
% [     generator                 from_bus         to_bus   percent_overload]


%-------------------------------------------------------------------------
% Compute MVA Overloads
%-------------------------------------------------------------------------

MVAoverloads = zeros(8,4);

for i=1:8
    if abs(Sf(i,1)) > branchnew(i,6)
        MVAoverloads(i,1) = branchnew(i,1);
        MVAoverloads(i,2) = branchnew(i,2);
        MVAoverloads(i,3) = 100*abs(Sf(i,1))./branchnew(i,6);
    else
    end;
    if abs(St(i,1)) > branchnew(i,6)
        MVAoverloads(i,1) = branchnew(i,1);
        MVAoverloads(i,2) = branchnew(i,2);      
        MVAoverloads(i,4) = 100*abs(St(i,1))./branchnew(i,6);
    else
    end
end;

%Eliminate zero rows
n=8;
while n >0
    if MVAoverloads(n,1) == 0
        MVAoverloads(n,:) = [];
    else
    end
    n = n-1;
end;

% Determines the Max overload between the from and to end of the branch

D = size(MVAoverloads);
MVAoverloads2 = zeros(D(1),3);
for i =1:D(1)
    MVAoverloads2(i,1) = MVAoverloads(i,1);
    MVAoverloads2(i,2) = MVAoverloads(i,2);
    if MVAoverloads(i,3) > MVAoverloads(i,4)
        MVAoverloads2(i,3) = MVAoverloads(i,3);    
    else
        MVAoverloads2(i,3) = MVAoverloads(i,4);
    end
end;

MVAoverloads = MVAoverloads2;
D = size(MVAoverloads);
MVAoverloads2 = zeros(D(1),4);
for i=1:D(1)
    MVAoverloads2(i,1) = genout;
    MVAoverloads2(i,2) = MVAoverloads(i,1);
    MVAoverloads2(i,3) = MVAoverloads(i,2);
    MVAoverloads2(i,4) = MVAoverloads(i,3);
end;
MVAoverloads = MVAoverloads2;
return;

