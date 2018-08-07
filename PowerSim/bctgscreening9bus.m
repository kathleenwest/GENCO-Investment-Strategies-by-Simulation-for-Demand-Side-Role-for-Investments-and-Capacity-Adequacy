function [bctgCombinedMVAoverloads,bctgCombinedVoltageViolations] = bctgscreening9bus(baseMVA, bus, gen, branch)
%BCTGSCREENING - Screening routine to examine each non-islanding branch outage in the 9 bus system 
% (total of 49 branches). Estimates all post-contingency voltage magnitudes (total of 64 buses) and all 
% post-contingency MVA branch flows (total of 77 branches)
%
% Inputs: Base case AC power flow solutions with baseMVA, bus, gen, and
% branch matrices for the ESCA 64 bus system
% Outputs: Condensed matrix with ONLY violated branch MVA overloads and bus voltage
% violations
%
% bctgCombinedMVAoverloads: (NX5) where N is the number of violations
% [<---branch contingency --->  <---branch overloaded-->  <---violation--->
% [from_bus             to_bus  from_bus         to_bus   percent_overload]
%
% bctgCombinedVoltageViolations: (NX9) where N is the number of violations
% [<---branch contingency --->  <---bus violated--><-----------------under voltage---------------><--------over voltage---------------------------> 
% [from_bus             to_bus       bus             current_value low_limit percent_undervoltage  current_value   high_limit  percent_overvoltage]


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Branch Contingency Case Screening
%==========================================================================
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

warning off MATLAB:singularMatrix;          % supresses error messages

%=========================================================================
% Global Variable Definitions
%=========================================================================

branchctglist = [     
   4 5; 
   4 6; 
   5 7; 
   6 9;  
   7 8;  
   8 9;      
];

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%   Begin Branch Contingency Analysis
%--------------------------------------------------------------------------

D = size(branchctglist);            % determines the size of the matrix    
B = size(branch);                   % size of branch matrix
i = 1;                              % starts the contingency branch evaluation index
f=0;                                % from bus variable, initially at zero
t=0;                                % to bus variable, initially at zero
CombinedMVAoverloads = [];          % matrix to hold the branch contingency MVA overload list
CombinedVoltageViolations = [];     % matrix to hold the branch contingency voltage severity 

while i < D(1) + 1                  % Cycle through every contingency branch outage

%--------------------------------------------------------------------------
% Branch Outage - Eliminate branch
%--------------------------------------------------------------------------

branchnew = branch;

% Eliminate the branch for post-contingency study

for k=1:B(1)
    if (branch(k,1) == branchctglist(i,1)) && (branch(k,2) == branchctglist(i,2))
    branchnew(k,:) = [];
    f = branchctglist(i,1);
    t = branchctglist(i,2);
    else
    end
end;

%--------------------------------------------------------------------------
% Run first iteration of Fast-Decoupled (1P1Q)
%--------------------------------------------------------------------------

options = mpoption('PF_ALG',2,'PF_MAX_IT_FD',1,'VERBOSE',0);
[baseMVA, bus, gen, branchnew, success] = bctgrunpf(branchnew,'wscc9bus',options);


%--------------------------------------------------------------------------
% See the Complex Voltage without Branch Outage
%--------------------------------------------------------------------------

Vm = bus(:,8);                  % This is the voltage magnitude column
Va = bus(:,9);                  % This is the column of voltage angle values
Va = Va.*pi/180;                % Convert the bus angle to radians
V = Vm .* exp(sqrt(-1) * Va);   % This is the complex voltage

%--------------------------------------------------------------------------
% Set-Up B-Prime Matrix, Sbus, Ybus 
%--------------------------------------------------------------------------
alg = 2; % BX Method
[Bp, Bpp] =  makeB(baseMVA, bus, branchnew, alg);
Sbus = makeSbus(baseMVA, bus, gen);
[Ybus, Yf, Yt] = makeYbus(baseMVA, bus, branchnew);


%-------------------------------------------------------------------------
% Compute Branch Flows
%-------------------------------------------------------------------------

[br, Sf, St] = ctgcomputebranchflows9bus(bus,gen,branchnew,V,Yf,Yt,baseMVA);

%-------------------------------------------------------------------------
% Calculate MVA Overloads
%-------------------------------------------------------------------------

[MVAoverloads] = bctgcalculateMVAoverloads9bus(branchnew,Sf,St,f,t);
CombinedMVAoverloads = [CombinedMVAoverloads; MVAoverloads];

%--------------------------------------------------------------------------
% Calculate Voltage Violations
%--------------------------------------------------------------------------

[VoltageViolations] = bctgcalculateVoltageViolations9bus(V,bus,f,t);
CombinedVoltageViolations = [CombinedVoltageViolations; VoltageViolations];

i = i+1;                            % switch to next branch outage contingency

end;  % end of the while loop


% Saves the Lists for the branch contingency
bctgCombinedMVAoverloads = [];
bctgCombinedMVAoverloads = CombinedMVAoverloads;
bctgCombinedVoltageViolations = [];
bctgCombinedVoltageViolations = CombinedVoltageViolations;




%=========================================================================
% Ranking of Voltage Violations
%=========================================================================
% Rank by high voltage descending, then low voltage ascending

bctgCombinedVoltageViolations2 = bctgCombinedVoltageViolations;
D = size(bctgCombinedVoltageViolations);

for j=1:D(1)
for i=1:D(1)
    if i > 1 
        if bctgCombinedVoltageViolations2(i,6) < bctgCombinedVoltageViolations2(i-1,6)
            bctgCombinedVoltageViolationstemp1a = bctgCombinedVoltageViolations2(i,1);
            bctgCombinedVoltageViolationstemp1b = bctgCombinedVoltageViolations2(i,2);
            bctgCombinedVoltageViolationstemp1c = bctgCombinedVoltageViolations2(i,3);
            bctgCombinedVoltageViolationstemp1d = bctgCombinedVoltageViolations2(i,4);
            bctgCombinedVoltageViolationstemp1e = bctgCombinedVoltageViolations2(i,5);
            bctgCombinedVoltageViolationstemp1f = bctgCombinedVoltageViolations2(i,6);
            bctgCombinedVoltageViolationstemp1g = bctgCombinedVoltageViolations2(i,7);
            bctgCombinedVoltageViolationstemp1h = bctgCombinedVoltageViolations2(i,8);   
            bctgCombinedVoltageViolationstemp1i = bctgCombinedVoltageViolations2(i,9);             
            bctgCombinedVoltageViolationstemp2a = bctgCombinedVoltageViolations2(i-1,1);
            bctgCombinedVoltageViolationstemp2b = bctgCombinedVoltageViolations2(i-1,2);
            bctgCombinedVoltageViolationstemp2c = bctgCombinedVoltageViolations2(i-1,3);
            bctgCombinedVoltageViolationstemp2d = bctgCombinedVoltageViolations2(i-1,4);
            bctgCombinedVoltageViolationstemp2e = bctgCombinedVoltageViolations2(i-1,5);   
            bctgCombinedVoltageViolationstemp2f = bctgCombinedVoltageViolations2(i-1,6);
            bctgCombinedVoltageViolationstemp2g = bctgCombinedVoltageViolations2(i-1,7);
            bctgCombinedVoltageViolationstemp2h = bctgCombinedVoltageViolations2(i-1,8);   
            bctgCombinedVoltageViolationstemp2i = bctgCombinedVoltageViolations2(i-1,9);             
            bctgCombinedVoltageViolations2(i-1,1) = bctgCombinedVoltageViolationstemp1a;
            bctgCombinedVoltageViolations2(i-1,2) = bctgCombinedVoltageViolationstemp1b;
            bctgCombinedVoltageViolations2(i-1,3) = bctgCombinedVoltageViolationstemp1c;
            bctgCombinedVoltageViolations2(i-1,4) = bctgCombinedVoltageViolationstemp1d;
            bctgCombinedVoltageViolations2(i-1,5) = bctgCombinedVoltageViolationstemp1e; 
            bctgCombinedVoltageViolations2(i-1,6) = bctgCombinedVoltageViolationstemp1f;
            bctgCombinedVoltageViolations2(i-1,7) = bctgCombinedVoltageViolationstemp1g;
            bctgCombinedVoltageViolations2(i-1,8) = bctgCombinedVoltageViolationstemp1h;  
            bctgCombinedVoltageViolations2(i-1,9) = bctgCombinedVoltageViolationstemp1i;             
            bctgCombinedVoltageViolations2(i,1) = bctgCombinedVoltageViolationstemp2a;
            bctgCombinedVoltageViolations2(i,2) = bctgCombinedVoltageViolationstemp2b;
            bctgCombinedVoltageViolations2(i,3) = bctgCombinedVoltageViolationstemp2c;
            bctgCombinedVoltageViolations2(i,4) = bctgCombinedVoltageViolationstemp2d;
            bctgCombinedVoltageViolations2(i,5) = bctgCombinedVoltageViolationstemp2e; 
            bctgCombinedVoltageViolations2(i,6) = bctgCombinedVoltageViolationstemp2f;
            bctgCombinedVoltageViolations2(i,7) = bctgCombinedVoltageViolationstemp2g;
            bctgCombinedVoltageViolations2(i,8) = bctgCombinedVoltageViolationstemp2h; 
            bctgCombinedVoltageViolations2(i,9) = bctgCombinedVoltageViolationstemp2i;             
        else
        end;
    else
    end;    
end;
end;

for j=1:D(1)
for i=1:D(1)
    if i > 1 
        if bctgCombinedVoltageViolations2(i,9) > bctgCombinedVoltageViolations2(i-1,9)
            bctgCombinedVoltageViolationstemp1a = bctgCombinedVoltageViolations2(i,1);
            bctgCombinedVoltageViolationstemp1b = bctgCombinedVoltageViolations2(i,2);
            bctgCombinedVoltageViolationstemp1c = bctgCombinedVoltageViolations2(i,3);
            bctgCombinedVoltageViolationstemp1d = bctgCombinedVoltageViolations2(i,4);
            bctgCombinedVoltageViolationstemp1e = bctgCombinedVoltageViolations2(i,5);
            bctgCombinedVoltageViolationstemp1f = bctgCombinedVoltageViolations2(i,6);
            bctgCombinedVoltageViolationstemp1g = bctgCombinedVoltageViolations2(i,7);
            bctgCombinedVoltageViolationstemp1h = bctgCombinedVoltageViolations2(i,8);   
            bctgCombinedVoltageViolationstemp1i = bctgCombinedVoltageViolations2(i,9);             
            bctgCombinedVoltageViolationstemp2a = bctgCombinedVoltageViolations2(i-1,1);
            bctgCombinedVoltageViolationstemp2b = bctgCombinedVoltageViolations2(i-1,2);
            bctgCombinedVoltageViolationstemp2c = bctgCombinedVoltageViolations2(i-1,3);
            bctgCombinedVoltageViolationstemp2d = bctgCombinedVoltageViolations2(i-1,4);
            bctgCombinedVoltageViolationstemp2e = bctgCombinedVoltageViolations2(i-1,5);   
            bctgCombinedVoltageViolationstemp2f = bctgCombinedVoltageViolations2(i-1,6);
            bctgCombinedVoltageViolationstemp2g = bctgCombinedVoltageViolations2(i-1,7);
            bctgCombinedVoltageViolationstemp2h = bctgCombinedVoltageViolations2(i-1,8);   
            bctgCombinedVoltageViolationstemp2i = bctgCombinedVoltageViolations2(i-1,9);             
            bctgCombinedVoltageViolations2(i-1,1) = bctgCombinedVoltageViolationstemp1a;
            bctgCombinedVoltageViolations2(i-1,2) = bctgCombinedVoltageViolationstemp1b;
            bctgCombinedVoltageViolations2(i-1,3) = bctgCombinedVoltageViolationstemp1c;
            bctgCombinedVoltageViolations2(i-1,4) = bctgCombinedVoltageViolationstemp1d;
            bctgCombinedVoltageViolations2(i-1,5) = bctgCombinedVoltageViolationstemp1e; 
            bctgCombinedVoltageViolations2(i-1,6) = bctgCombinedVoltageViolationstemp1f;
            bctgCombinedVoltageViolations2(i-1,7) = bctgCombinedVoltageViolationstemp1g;
            bctgCombinedVoltageViolations2(i-1,8) = bctgCombinedVoltageViolationstemp1h;  
            bctgCombinedVoltageViolations2(i-1,9) = bctgCombinedVoltageViolationstemp1i;             
            bctgCombinedVoltageViolations2(i,1) = bctgCombinedVoltageViolationstemp2a;
            bctgCombinedVoltageViolations2(i,2) = bctgCombinedVoltageViolationstemp2b;
            bctgCombinedVoltageViolations2(i,3) = bctgCombinedVoltageViolationstemp2c;
            bctgCombinedVoltageViolations2(i,4) = bctgCombinedVoltageViolationstemp2d;
            bctgCombinedVoltageViolations2(i,5) = bctgCombinedVoltageViolationstemp2e; 
            bctgCombinedVoltageViolations2(i,6) = bctgCombinedVoltageViolationstemp2f;
            bctgCombinedVoltageViolations2(i,7) = bctgCombinedVoltageViolationstemp2g;
            bctgCombinedVoltageViolations2(i,8) = bctgCombinedVoltageViolationstemp2h; 
            bctgCombinedVoltageViolations2(i,9) = bctgCombinedVoltageViolationstemp2i;               
        else
        end;
    else
    end;    
end;
end;

bctgCombinedVoltageViolations = bctgCombinedVoltageViolations2;


%-------------------------------------------------------------------------
% End Branch Contingency Analysis
%-------------------------------------------------------------------------
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

return;
