function [loadforecast] = forecastload(bus,level)
%forecastload - Given an input bus matrix, common in the program and a user
%defined setting level (low, medium, high, off) creates a matrix with the
%forecasted load for one time increment. loadforecast will be returned with
%a NX1 matrix where N is the number of busses in the system and the value
%is the previous MW load on the bus plus a random new MW number. A random
%matrix for N busses is formed and the numbers generate form a "weight" of
%the total load growth on the system. If the load growth is 3%, the total
%load of the system is summed. The random numbers at each bus is summed and
%then made a a percentage that ad up to one. Each bus then has that
%percentage multipled by the 3% times system MW times percentage at that
%bus. Only MW or active power is forecasted.
%
%

%--------------------------------------------------------------------------
% Determine Current Load
%--------------------------------------------------------------------------
D = size(bus);
mw = 0;
for k=1:D(1)
    mw = mw + bus(k,1);
end;

%--------------------------------------------------------------------------
% Randomize Load Growth Shares at each bus
%--------------------------------------------------------------------------
growthr = rand(9,1);
growth = 0;
for k=1:D(1)
    growth = growth + growthr(k,1);
end;
growth = (growthr/growth);

%--------------------------------------------------------------------------
% Determine Forecast Load @ Each Bus
%--------------------------------------------------------------------------

% Low 5%
if strcmp(level,'Low') == 1 
loadforecast = bus(1:D(1),1) + growth*mw*0.05;
else
end;

% Medium 10%
if strcmp(level,'Medium') == 1 
loadforecast = bus(1:D(1),1) + growth*mw*0.10;
else
end;

% High 20%
if strcmp(level,'High') == 1 
loadforecast = bus(1:D(1),1) + growth*mw*0.20;
else
end;

% Default
if strcmp(level,'Off') == 1 
loadforecast = bus(1:D(1),1);   
else
end;

return;

