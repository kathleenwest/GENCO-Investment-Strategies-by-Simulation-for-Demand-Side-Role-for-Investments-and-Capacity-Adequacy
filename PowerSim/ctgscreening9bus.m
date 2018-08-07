%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Contingency Case Screening
%==========================================================================
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

warning off MATLAB:singularMatrix;          % supresses error messages

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Base Case
%--------------------------------------------------------------------------
[baseMVA, bus, gen, branch, success] = runpf('wscc9bus');
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                         Branch Contingency Screening
%--------------------------------------------------------------------------
[bctgCombinedMVAoverloads,bctgCombinedVoltageViolations] = bctgscreening9bus(baseMVA, bus, gen, branch)
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                         Generator Contingency Screening
%--------------------------------------------------------------------------
[gctgCombinedMVAoverloads,gctgCombinedVoltageViolations] = gctgscreening9bus(baseMVA, bus, gen, branch)
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

















