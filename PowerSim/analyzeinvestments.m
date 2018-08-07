function analyzeinvestments(N,MW_ADD,bidprice,mc,priceforecast,loadforecast,year,baseMVA,bus,gen,branch,area,gencost)

% Temporary Variables
gencost_add   =         [2            0            0            3            0        bidprice            0];
bus_forecast = [];          % Initialize empty array

clc
fprintf('\n');
fprintf('\n');
fprintf('\n Forecasting Generating Investment Dispatch ');
fprintf('\n This may take 10 seconds - ~ minutes  ');
fprintf('\n depending on N, number of planning years ');
fprintf('\n');
fprintf('\n');
pause(3);
clc;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                    Forecast Generation Investment Dispatch
%--------------------------------------------------------------------------
% for each bus, choose to invest a generator. determine the locational
% marginal pricing effects and how much of that investment will get
% dispatched on the bus considered given a forecasted load growth. 



% For Bus1-9 Analyze the Investments
for k=1:9
    k;
clc
fprintf('\n');
fprintf('\n Working!.................................................');
fprintf('\n Working!.................................................');
fprintf('\n Working!.................................................');

clc;    
% initialize temporary variables 
bus_add = k;
gen_add = [bus_add          MW_ADD           50          50          -50        1.025          100            1          MW_ADD           10];
gen_temp = [];
gencost_temp = [];
bus_temp = [];
gen_forecast = [];

% Add Generation to Gen Matrix
gen_temp = [gen; gen_add];

% Add Gencost to gencost matrix
gencost_temp = [gencost; gencost_add];

% Change bus type except the slack
bus_temp = bus;
if bus_add == 1
    % do nothing
else
   bus_temp(bus_add,2) = 2; 
end;


% For Each Bus, Determine its dispatch based on a load growth
% this will be unit decommitment!

for p=1:N
    p;
fprintf('\n Working!.................................................');    
bus_temp(1:9,3) = loadforecast(1:9,p);
D = size(gen_temp);
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                                   Unit Decommitment Case
%--------------------------------------------------------------------------

options = mpoption('PF_ALG',1,'OPF_ALG',520,'OUT_GEN',1,'OUT_BRANCH',1,'VERBOSE',0);
[baseMVA_new, bus_new, gen_new, branch_new, success_new] = runuopfspecialnoprint(baseMVA, bus_temp, gen_temp, branch, area, gencost_temp,options);
branch_new = success_new;
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
gen_forecast = [gen_forecast gen_new(D(1),2)];

end;
bus_forecast = [bus_forecast; gen_forecast];

end;
price_forecast = bus_forecast;
bus_forecast = [year; bus_forecast];

clc
fprintf('\n');
fprintf('\n');
fprintf('\n Forecasting Investment Alternative Revenues ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;


%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                    Revenue Forecast
%--------------------------------------------------------------------------

for k=1:N
price_forecast(1:9,k) = (price_forecast(1:9,k)*priceforecast(k,1)*8760 - (mc(1,1)*price_forecast(1:9,k)+ mc(1,2)*price_forecast(1:9,k)*8760))/10^6;
end;
npv = price_forecast;
price_forecast = [year; priceforecast'; price_forecast];
profit_forecast = [[0; 0; bus(1:9,1)] price_forecast];

clc
fprintf('\n');
fprintf('\n');
fprintf('\n Net Present Value Analysis on Alternatives.... ');
fprintf('\n');
fprintf('\n');
pause(1);
clc;

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                    Net Present Value Analysis
%--------------------------------------------------------------------------
npv_sum = zeros(9,1);
r= 0.1; % discount rate
for k=1:N
npv_sum(1:9,1) = npv_sum(1:9,1) + npv(1:9,k).*(1/((1+r)^k));
end;

npv = [bus(1:9,1) npv_sum];

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%--------------------------------------------------------------------------
%                    Results
%--------------------------------------------------------------------------
fprintf('\n Unit Dispatch Forecast');
fprintf('\n ');
fprintf('\n Based on your bidding price of: %s',int2str(bidprice));
fprintf('\n Optimal Power Flow with Unit Decommitment Optimization was executed for the planning period. Based on a forecasted load');
fprintf('\n growth at each bus during the planning period, your bid, and your unit capacity, the following table shows a ');
fprintf('\n forecast of how your investment would be dispatched IF you invested a unit at the bus location at time t=0. ');
fprintf('\n  ');
fprintf('\n Invested at Bus          Year1    Year2  ....');
fprintf('\n       Bus1                 P1       P2   ....');
fprintf('\n       Bus2                 P1       P2   ....');
fprintf('\n       .                     .       .    ....');
fprintf('\n       .                     .       .    ....');
fprintf('\n  ');
fprintf('\n  P = active power in MW dispatched from YOUR invested unit');
fprintf('\n ');
fprintf('\n ');
bus_forecast = [[0; bus(1:9,1)] bus_forecast]  
fprintf('\n ');
fprintf('\n ');
fprintf('\n Unit Dispatch Profit Forecast');
fprintf('\n ');
fprintf('\n Based on your bidding price of: %s',int2str(bidprice));
fprintf('\n AND on your unit annual marginal cost of: %s',int2str(mc));
fprintf('\n Considering the unit dispatch forecast above with the market price forecast, ');
fprintf('\n an investment analysis table is shown below.  ');
fprintf('\n  ');
fprintf('\n                                   Year1    Year2   ....');
fprintf('\n  Market Price (Forecast)          $/MW     $/MW    ....');
fprintf('\n  Profit at Bus1 Investment         $ M      $ M    ....');
fprintf('\n  Profit at Bus2 Investment         $ M      $ M    ....');
fprintf('\n       .                             .        .     ....');
fprintf('\n       .                             .        .     ....');
fprintf('\n  ');
fprintf('\n ');
profit_forecast
fprintf('\n ');
fprintf('\n ');
fprintf('\n Net Present Value Analysis');
fprintf('\n ');
fprintf('\n ');
fprintf('\n Based on the above forecasts and estimates, a net present value table');
fprintf('\n of future profits discounted, r = 0.1, to present value is shown below.');
fprintf('\n You should invest in adding generation at the bus with the highest ');
fprintf('\n "expected" value (Net Present Value) of money ');
fprintf('\n ');
fprintf('\n ');

fprintf('\n            $ Profits for Entire Planning Period as NPV');
fprintf('\n  Bus1                          $ M Dollars       ');
fprintf('\n  Bus2                          $ M Dollars       ');
fprintf('\n   .                               .      ');
fprintf('\n   .                               .     ');
fprintf('\n  ');
fprintf('\n  **** Remember which bus that you would like to invest in (1-9) at this time');
fprintf('\n ');
npv



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
return;

