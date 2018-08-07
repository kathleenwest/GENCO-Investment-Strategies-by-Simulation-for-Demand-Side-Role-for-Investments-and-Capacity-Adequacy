function [mc] = coalsteam(N,capacity)

N;              % Economic lifetime (planning period) in years
ahr = 9800;     % Average heate rate BTU/kWh
ic = 1400;      % Investment cost $/kW
fc = 2.0;       % $/MBtu
FOM = 15;       % Fixed O&M Cost $/kW/Year
VOM = 5;        % Variable O&M Cost $/MWh
a = 0.05;        % Fuel Cost and O&M Escalation %/year
r = 0.10;       % Discount rate
FCR = 0.18;     % Fixed charge rate
capacity; % capacity in MW
capacityfactor = 0.9;
fprintf('\n   Coal Steam Plant:  ');
fprintf('\n'   );
fprintf('\n'   );
fprintf('\n   Economic lifetime (planning period) in years:  %s',int2str(N));
fprintf('\n   Average heate rate BTU per kWh:  %s',int2str(ahr));
fprintf('\n   Investment cost $ per kW:  %s',int2str(ic));
fprintf('\n   $/MBtu:  %s',num2str(fc,3));
fprintf('\n   Fixed O&M Cost $ per kW per Year:  %s',num2str(FOM,2));
fprintf('\n   Variable O&M Cost $ per MWh:  %s',int2str(VOM));
fprintf('\n   Fuel Cost and O&M Escalation percent per year:  %s',num2str(a,2));
fprintf('\n   Discount Rate:  %s',num2str(r,2));
fprintf('\n   Fixed Charge Rate:  %s',num2str(FCR,2));
fprintf('\n   Capacity in MW:  %s',int2str(capacity));
fprintf('\n   Capacity Factor:  %s',num2str(capacityfactor,2));


% Capital Recovery Factor
CRF = r*((1+r)^N)/((1+r)^N-1);
fprintf('\n   Capital Recovery Factor:  %s',num2str(CRF,6));
% Levelizing Factor for uniform inflation
LF = CRF*[1-(((1+a)/(1+r))^N)]/(r-a);
fprintf('\n   Levelizing Factor for uniform inflation:  %s',num2str(LF,6));
% Fixed Levelized Annual Costs
investment = ic*FCR*1000;               % Investment $/MW/YEAR
fixedom = FOM*LF*1000;                  % Fixed O&M $/MW/YEAR
k1 = investment + fixedom;              % Total $/MW/YEAR
fprintf('\n   Fixed Levelized Annual Costs $ per MW per YEAR:  %s',num2str(k1,7));
% Variable Levelized Annual Costs
fuel = ahr*fc*LF/1000;                  % Fuel $/MWh
VOMc = VOM*LF;                          % Var. O&M $/MWH
c1 = fuel + VOMc;                       % Total $/MWH
fprintf('\n   Variable Levelized Annual Costs $ per MWH :  %s',num2str(c1,4));
% Total Investment Cost
tic = (capacity*ic*10^3)/10^6;  % $ Millions
fprintf('\n   Total Investment Cost $ Millions:  %s',num2str(tic,3));
% Operating Costs
% Yearly Operating Cost
c1a = ((ahr*fc*1000)/10^6) +VOM;   % $/MWH
fprintf('\n   Yearly Operating Cost $ per MWH :  %s',num2str(c1,3));
% Per Year
yoc = capacity*capacityfactor*8760*c1a/10^6;   % $ M/yr
fprintf('\n   Yearly Operating Cost $ M per yr:  %s',num2str(yoc,3));
fprintf('\n');

mc = [k1 c1]; % Returns fixed and variable levelized annual costs
return;