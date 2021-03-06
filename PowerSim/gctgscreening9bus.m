function [gctgCombinedMVAoverloads,gctgCombinedVoltageViolations] = gctgscreening9bus(baseMVA, bus, gen, branch)
%GCTGSCREENING - Screening routine to examine each generator unit outage in the 
% 9 bus system (total of 3 generators). Estimates all post-contingency voltage magnitudes 
% (total of 9 buses) and all post-contingency MVA branch flows (total of 6 lines).
%
% Inputs: Base case AC power flow solutions with baseMVA, bus, gen, and
% branch matrices for the 9 bus system
% Outputs: Condensed matrix with ONLY violated branch MVA overloads and bus voltage
% violations
%
% gctgCombinedMVAoverloads: (NX4 where N is the number of violations
% [<-generator contingency --->  <---branch overloaded-->  <---violation--->
% [     generator bus                from_bus         to_bus   percent_overload]
%
% gctgCombinedVoltageViolations: (NX8) where N is the number of violations
% [<---generator contingency --->  <---bus violated--><-----------------under voltage---------------><--------over voltage---------------------------> 
% [generator bus                        bus               current_value low_limit percent_undervoltage  current_value   high_limit  percent_overvoltage]


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Generator Contingency Case Screening
%==========================================================================
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

warning off MATLAB:singularMatrix;          % supresses error messages

%=========================================================================
% Global Variable Definitions
%=========================================================================

B = size(gen);                      % size of gen matrix
B1 = size(bus);                     % size of bus matrix
i = 1;                              % starts the contingency gen evaluation index
CombinedMVAoverloads = [];          % matrix to hold the gen contingency MVA overload list
CombinedVoltageViolations = [];     % matrix to hold the gen contingency voltage severity 
%Form Dynamic Generator Contingency List
gendone = zeros(B(1),2);
gendone(1:B(1),1) = gen(1:B(1),1);
gendone(1:B(1),2) = gen(1:B(1),2);
gendone;
temp = ones(1,B(1))';
for k=1:B(1)
    temp(k,1) = k;
end;
genctglist = [gendone temp];

% eliminate the swing generator (gen 1)
genctglist(1,:) = [];

%genctglist2 = gendone;
% Eliminate the slack bus from the contingency analysis
%D = size(genctglist);               % determines the size of the matrix    
%for k=1:D(1)
%    if bus(genctglist(k,1),2) == 3  
%       genctglist2(k,:) = []; 
%    else
%    end;
%end;
%genctglist = genctglist2;


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%   Begin Generator Contingency Analysis
%--------------------------------------------------------------------------

D = size(genctglist);               % determines the size of the matrix  

while i < D(1) + 1                  % Cycle through every contingency generator outage


%--------------------------------------------------------------------------
% Generator Outage - Eliminate generator
%--------------------------------------------------------------------------

gennew = gen;
genout1 = genctglist(i,1);
genout2 = genctglist(i,2);
busnew = bus;


% Eliminate the generator for post-contingency study

for k=1:B(1)
    if gen(k,1) == genctglist(i,1) && (gen(k,2) == genctglist(i,2)) && genctglist(i,3) == i;
    gennew(k,:) = [];
    else
    end
end;
% Change the bus type from a PV to a PQ bus
for k=1:B1(1)
    if (bus(k,1) == genctglist(i,1))
        busnew(k,2) = 1; 
    else
    end;
end;


%--------------------------------------------------------------------------
% Run first iteration of Fast-Decoupled
%--------------------------------------------------------------------------

options = mpoption('PF_ALG',2,'PF_MAX_IT_FD',1,'VERBOSE',0);
[baseMVA, busnew, gennew, branch, success] = gctgrunpf(gennew,busnew,'wscc9bus',options);

%--------------------------------------------------------------------------
% Setup Base Case Complex Voltage
%--------------------------------------------------------------------------

Vm = busnew(:,8);                  % This is the voltage magnitude column
Va = busnew(:,9);                  % This is the column of voltage angle values
Va = Va.*pi/180;                % Convert the bus angle to radians
V = Vm .* exp(sqrt(-1) * Va);   % This is the complex voltage

%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix, Sbus, Ybus 
%--------------------------------------------------------------------------
alg = 2; % BX Method
[Bp, Bpp] =  makeB(baseMVA, busnew, branch, alg);
Sbus = makeSbus(baseMVA, busnew, gennew);
[Ybus, Yf, Yt] = makeYbus(baseMVA, busnew, branch);

%-------------------------------------------------------------------------
% Compute Branch Flows
%-------------------------------------------------------------------------

[br, Sf, St] = ctgcomputebranchflows9bus(busnew,gennew,branch,V,Yf,Yt,baseMVA);

%-------------------------------------------------------------------------
% Calculate MVA Overloads
%-------------------------------------------------------------------------

[MVAoverloads] = gctgcalculateMVAoverloads9bus(genout1,branch,Sf,St);
CombinedMVAoverloads = [CombinedMVAoverloads; MVAoverloads];

%--------------------------------------------------------------------------
% Calculate Voltage Violations
%--------------------------------------------------------------------------

[VoltageViolations] = gctgcalculateVoltageViolations9bus(V,busnew,genout1);
CombinedVoltageViolations = [CombinedVoltageViolations; VoltageViolations];

i = i+1;                            % switch to next generator outage contingency

end;  % end of the while loop











% Saves the Ranking Lists for the branch contingency
gctgCombinedMVAoverloads = [];
gctgCombinedMVAoverloads = CombinedMVAoverloads;
gctgCombinedVoltageViolations = [];
gctgCombinedVoltageViolations = CombinedVoltageViolations;


gctgCombinedMVAoverloads;

%=========================================================================
% Ranking of Voltage Violations
%=========================================================================
% Rank by high voltage descending, then low voltage ascending

gctgCombinedVoltageViolations2 = gctgCombinedVoltageViolations;
D = size(gctgCombinedVoltageViolations);

for j=1:D(1)
for i=1:D(1)
    if i > 1 
        if gctgCombinedVoltageViolations2(i,5) < gctgCombinedVoltageViolations2(i-1,5)
            gctgCombinedVoltageViolationstemp1a = gctgCombinedVoltageViolations2(i,1);
            gctgCombinedVoltageViolationstemp1b = gctgCombinedVoltageViolations2(i,2);
            gctgCombinedVoltageViolationstemp1c = gctgCombinedVoltageViolations2(i,3);
            gctgCombinedVoltageViolationstemp1d = gctgCombinedVoltageViolations2(i,4);
            gctgCombinedVoltageViolationstemp1e = gctgCombinedVoltageViolations2(i,5);
            gctgCombinedVoltageViolationstemp1f = gctgCombinedVoltageViolations2(i,6);
            gctgCombinedVoltageViolationstemp1g = gctgCombinedVoltageViolations2(i,7);
            gctgCombinedVoltageViolationstemp1h = gctgCombinedVoltageViolations2(i,8);             
            gctgCombinedVoltageViolationstemp2a = gctgCombinedVoltageViolations2(i-1,1);
            gctgCombinedVoltageViolationstemp2b = gctgCombinedVoltageViolations2(i-1,2);
            gctgCombinedVoltageViolationstemp2c = gctgCombinedVoltageViolations2(i-1,3);
            gctgCombinedVoltageViolationstemp2d = gctgCombinedVoltageViolations2(i-1,4);
            gctgCombinedVoltageViolationstemp2e = gctgCombinedVoltageViolations2(i-1,5);   
            gctgCombinedVoltageViolationstemp2f = gctgCombinedVoltageViolations2(i-1,6);
            gctgCombinedVoltageViolationstemp2g = gctgCombinedVoltageViolations2(i-1,7);
            gctgCombinedVoltageViolationstemp2h = gctgCombinedVoltageViolations2(i-1,8);             
            gctgCombinedVoltageViolations2(i-1,1) = gctgCombinedVoltageViolationstemp1a;
            gctgCombinedVoltageViolations2(i-1,2) = gctgCombinedVoltageViolationstemp1b;
            gctgCombinedVoltageViolations2(i-1,3) = gctgCombinedVoltageViolationstemp1c;
            gctgCombinedVoltageViolations2(i-1,4) = gctgCombinedVoltageViolationstemp1d;
            gctgCombinedVoltageViolations2(i-1,5) = gctgCombinedVoltageViolationstemp1e; 
            gctgCombinedVoltageViolations2(i-1,6) = gctgCombinedVoltageViolationstemp1f;
            gctgCombinedVoltageViolations2(i-1,7) = gctgCombinedVoltageViolationstemp1g;
            gctgCombinedVoltageViolations2(i-1,8) = gctgCombinedVoltageViolationstemp1h;             
            gctgCombinedVoltageViolations2(i,1) = gctgCombinedVoltageViolationstemp2a;
            gctgCombinedVoltageViolations2(i,2) = gctgCombinedVoltageViolationstemp2b;
            gctgCombinedVoltageViolations2(i,3) = gctgCombinedVoltageViolationstemp2c;
            gctgCombinedVoltageViolations2(i,4) = gctgCombinedVoltageViolationstemp2d;
            gctgCombinedVoltageViolations2(i,5) = gctgCombinedVoltageViolationstemp2e; 
            gctgCombinedVoltageViolations2(i,6) = gctgCombinedVoltageViolationstemp2f;
            gctgCombinedVoltageViolations2(i,7) = gctgCombinedVoltageViolationstemp2g;
            gctgCombinedVoltageViolations2(i,8) = gctgCombinedVoltageViolationstemp2h;              
        else
        end;
    else
    end;    
end;
end;

for j=1:D(1)
for i=1:D(1)
    if i > 1 
        if gctgCombinedVoltageViolations2(i,8) > gctgCombinedVoltageViolations2(i-1,8)
            gctgCombinedVoltageViolationstemp1a = gctgCombinedVoltageViolations2(i,1);
            gctgCombinedVoltageViolationstemp1b = gctgCombinedVoltageViolations2(i,2);
            gctgCombinedVoltageViolationstemp1c = gctgCombinedVoltageViolations2(i,3);
            gctgCombinedVoltageViolationstemp1d = gctgCombinedVoltageViolations2(i,4);
            gctgCombinedVoltageViolationstemp1e = gctgCombinedVoltageViolations2(i,5);
            gctgCombinedVoltageViolationstemp1f = gctgCombinedVoltageViolations2(i,6);
            gctgCombinedVoltageViolationstemp1g = gctgCombinedVoltageViolations2(i,7);
            gctgCombinedVoltageViolationstemp1h = gctgCombinedVoltageViolations2(i,8);             
            gctgCombinedVoltageViolationstemp2a = gctgCombinedVoltageViolations2(i-1,1);
            gctgCombinedVoltageViolationstemp2b = gctgCombinedVoltageViolations2(i-1,2);
            gctgCombinedVoltageViolationstemp2c = gctgCombinedVoltageViolations2(i-1,3);
            gctgCombinedVoltageViolationstemp2d = gctgCombinedVoltageViolations2(i-1,4);
            gctgCombinedVoltageViolationstemp2e = gctgCombinedVoltageViolations2(i-1,5);   
            gctgCombinedVoltageViolationstemp2f = gctgCombinedVoltageViolations2(i-1,6);
            gctgCombinedVoltageViolationstemp2g = gctgCombinedVoltageViolations2(i-1,7);
            gctgCombinedVoltageViolationstemp2h = gctgCombinedVoltageViolations2(i-1,8);             
            gctgCombinedVoltageViolations2(i-1,1) = gctgCombinedVoltageViolationstemp1a;
            gctgCombinedVoltageViolations2(i-1,2) = gctgCombinedVoltageViolationstemp1b;
            gctgCombinedVoltageViolations2(i-1,3) = gctgCombinedVoltageViolationstemp1c;
            gctgCombinedVoltageViolations2(i-1,4) = gctgCombinedVoltageViolationstemp1d;
            gctgCombinedVoltageViolations2(i-1,5) = gctgCombinedVoltageViolationstemp1e; 
            gctgCombinedVoltageViolations2(i-1,6) = gctgCombinedVoltageViolationstemp1f;
            gctgCombinedVoltageViolations2(i-1,7) = gctgCombinedVoltageViolationstemp1g;
            gctgCombinedVoltageViolations2(i-1,8) = gctgCombinedVoltageViolationstemp1h;             
            gctgCombinedVoltageViolations2(i,1) = gctgCombinedVoltageViolationstemp2a;
            gctgCombinedVoltageViolations2(i,2) = gctgCombinedVoltageViolationstemp2b;
            gctgCombinedVoltageViolations2(i,3) = gctgCombinedVoltageViolationstemp2c;
            gctgCombinedVoltageViolations2(i,4) = gctgCombinedVoltageViolationstemp2d;
            gctgCombinedVoltageViolations2(i,5) = gctgCombinedVoltageViolationstemp2e; 
            gctgCombinedVoltageViolations2(i,6) = gctgCombinedVoltageViolationstemp2f;
            gctgCombinedVoltageViolations2(i,7) = gctgCombinedVoltageViolationstemp2g;
            gctgCombinedVoltageViolations2(i,8) = gctgCombinedVoltageViolationstemp2h;              
        else
        end;
    else
    end;    
end;
end;

gctgCombinedVoltageViolations = gctgCombinedVoltageViolations2;

%-------------------------------------------------------------------------
% End Generator Contingency Analysis
%-------------------------------------------------------------------------
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

return;