function playsimulationNEXT(profits,startyear,player,comp,loadgrowth,N,bus_old,gen_old,gencost_old,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,branch_old,area)
format short g;
clc
fprintf('\n');
fprintf('\n');
fprintf('\n Initializing Variables.... ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Setup 
%--------------------------------------------------------------------------
warning off MATLAB:singularMatrix;          % supresses error messages
clc;
% bus coordinates: bus x1 x2 y1 y2  used for making figure
bxy = [
1 -20 0 70 70;
2 90 110 30 30;
3 150 170 150 150;
4 10 30 140 140;
5 40 60 50 50;
6 80 100 160 160;
7 80 100 100 100;
8 150 170 40 40;
9 150 170 100 100;
];


% Update current price
currentprice = priceforecast(1,1);

% Update Year
startyear = startyear+1;
year = startyear;


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Year Matrix
%--------------------------------------------------------------------------
startyear2 = zeros(1,N);
startyear2(1,1) = startyear;
for k=2:N
    startyear2(1,k) = startyear + k-1;
end;
year = startyear2;
clear startyear2;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


fprintf('\n');
fprintf('\n');
fprintf('\n Running Base Case and Unit Commitment Optimal Power Flow.... ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Unit Decommitment Case
%--------------------------------------------------------------------------

options = mpoption('PF_ALG',1,'OPF_ALG',520,'OUT_GEN',1,'OUT_BRANCH',1,'VERBOSE',0);
[baseMVA, bus, gen, branch, success] = runuopfspecial(baseMVA, bus_old, gen_old, branch_old, area, gencost_old,options);
branch = success;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


fprintf('\n');
fprintf('\n');
fprintf('\n  Determining Annual and Total Profits.... ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Determining Yearly Profits
%--------------------------------------------------------------------------
% Coal Steam will have 50 MW generator
% Gas generators will be 51 MW 
% Determine Total Profits on all generators own by company
profits2 = determineprofits(player,mc,gen_old,gen,currentprice);
profits = profits + profits2;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

clc
fprintf('\n');
fprintf('\n');
fprintf('\n Generating Random Load Growth Profile.... ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;



%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Forecast Load
%--------------------------------------------------------------------------

loadforecast = [];
D = size(bus_old);
busf = bus_old(1:D(1),3);
for k=1:N
 loadforecast2 = forecastload(busf,loadgrowth);
 busf = loadforecast2;
 loadforecast = [loadforecast loadforecast2];
end;
clear D, clear loadforecast2, clear busf, clear k;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
clc
fprintf('\n');
fprintf('\n');
fprintf('\n Forecasting Price without Generation Investments........ ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Forecast Price
%--------------------------------------------------------------------------

[priceforecast] =  priceforecaster(currentprice,loadforecast,bus_old,gen_old);
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


clc
fprintf('\n');
fprintf('\n');
fprintf('\n Running Contingency Screening and Analysis........ ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%==========================================================================
% Contingency Case Screening
%==========================================================================
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
clc
fprintf('\n');
fprintf('\n');
fprintf('\n N-1 Branch Outage Analysis ........ ');
fprintf('\n');
fprintf('\n');
pause(1);
clc

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                         Branch Contingency Screening
%--------------------------------------------------------------------------
[bctgCombinedMVAoverloads,bctgCombinedVoltageViolations] = bctgscreening9bus(baseMVA, bus, gen, branch)
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
clc
fprintf('\n');
fprintf('\n');
fprintf('\n N-1 Generator Outage Analysis ........ ');
fprintf('\n');
fprintf('\n');
pause(1);
clc

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                         Generator Contingency Screening
%--------------------------------------------------------------------------
[gctgCombinedMVAoverloads,gctgCombinedVoltageViolations] = gctgscreening9bus(baseMVA, bus, gen, branch)
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

clc
fprintf('\n');
fprintf('\n');
fprintf('\n Done Simulating!  ........ ');
fprintf('\n');
fprintf('\n');
pause(2);
clc

if N <=0 
    % go to final display
    playsimulationFINAL(profits,startyear,player,comp,loadgrowth,N,bus_old,gen_old,gencost_old,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,branch_old,area)
    choice = -1;
else
    % continue
end;


choice = 1;
while ~isequal(choice,-1) && N >0
fprintf('\n');
fprintf('\n');
fprintf('\n_____________________________________________________________________');
fprintf('\n');
fprintf('\n                Simulation                                           ');
fprintf('\n');
fprintf('\n   Player:  %s',player);
fprintf('\n                            Total Profits $ M: %s',num2str(profits,4));
fprintf('\n                                         Year: %s',int2str(startyear));
fprintf('\n');
fprintf('\n');
fprintf('\n 1.  View Current System Topology (Figure)                  ');
fprintf('\n 2.  View Current Load Growth Forecast (Figure)          ');
fprintf('\n 3.  View Current Annual Price Forecast (Figure)          ');
fprintf('\n 4.  View Current System Topology with N-1 Contingency Analysis (Figure)         ');
fprintf('\n 5.  View Base Case and Unit Commitment Optimal Power Flow        ');
fprintf('\n 6.  View Investment Alternatives Analysis          ');
fprintf('\n 7.  Invest Generation and Move to Next Year       ');
fprintf('\n 8.  Do Not Invest Generation and Move to Next Year  ');
fprintf('\n 9.  Quit Simulation         ');
fprintf('\n');   
fprintf('\n');      
    
    
choice = input('Enter Choice Number:');
fprintf('\n');


fprintf('\n');
    if choice == 1
    % View System Topology (Figure)
    clc
    clf
    cla
    createnormal(bxy,branch,bus,gen)
    clc
    else
    end;
    if choice == 2
    % Plot Load Forecast
    clc
    clf
    cla
    plotloadforecast(year,loadforecast);
    clc
    else
    end;
    if choice == 3
    % Plot Price Forecast
    clf
    cla
    plotpriceforecast(year,priceforecast);
    clc
    else
    end;
    if choice == 4
    % Plot N-1 Contingency
    clc
    clf
    cla
    printctg(bctgCombinedMVAoverloads,bctgCombinedVoltageViolations,gctgCombinedMVAoverloads,gctgCombinedVoltageViolations);
    createctg(bxy,branch,bus,gen,bctgCombinedMVAoverloads,bctgCombinedVoltageViolations,gctgCombinedMVAoverloads,gctgCombinedVoltageViolations)
    else
    end;
    if choice == 5
     % Execute Unit Commitment Optimal Power Flow   
     runuopfspecial(baseMVA, bus_old, gen_old, branch_old, area, gencost_old,options);
    else
    end;
    if choice == 6
     % Analyze and View Investment Alternatives   
     analyzeinvestments(N,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,bus_old,gen_old,branch_old,area,gencost_old);
    else
    end;
    if choice == 7
      % Invest in New Generation
      [bus_old,gen_old,gencost_old,N] = invest(bus_old,gen_old,gencost_old,player,MW_ADD,bidprice,N,loadforecast);
      
      % Competition
      [bus_old,gen_old,gencost_old] = competition(currentprice,comp,bus_old,gen_old,gencost_old,player,bidprice,loadforecast);
      
      % Go to Next Time Period
      playsimulationNEXT(profits,startyear,player,comp,loadgrowth,N,bus_old,gen_old,gencost_old,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,branch_old,area)
      
      % Exit
      choice = -1; 
      clc
    else
    end;
    if choice == 8
      % Do not Invest and Move to N = N-1;
      N = N-1;
     
      % Competition
      [bus_old,gen_old,gencost_old] = competition(currentprice,comp,bus_old,gen_old,gencost_old,player,bidprice,loadforecast);
      
      % Update the bus load for next year only
      bus_old(1:9,3) = loadforecast(1:9,1);
      
      % Go to Next Time Period
      playsimulationNEXT(profits,startyear,player,comp,loadgrowth,N,bus_old,gen_old,gencost_old,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,branch_old,area)
      
      % Exit
      choice = -1; 
      clc
    else 
    end;
    if choice == 9
      choice = -1;
      clc
    else 
    end;
end;


return;