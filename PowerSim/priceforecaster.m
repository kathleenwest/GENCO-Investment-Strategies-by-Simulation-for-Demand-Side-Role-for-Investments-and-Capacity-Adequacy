function [priceforecast] = priceforecaster(currentprice,loadforecast,bus,gen)

%--------------------------------------------------------------------------
% Determine Yearly MW Load
%--------------------------------------------------------------------------
D = size(loadforecast);
lfyear = zeros(1,D(2));
for k=1:D(2)
    sum = 0;
    for j=1:D(1)
     sum = sum + loadforecast(j,k);    
    end;
    lfyear(1,k) = sum;
end;


%--------------------------------------------------------------------------
% Determine Scarcity Factors
%--------------------------------------------------------------------------
D = size(gen);
sum = 0;
for k=1:D(1)
   sum = sum + gen(k,2); 
end;
totalgen = sum;
lfyear;
sf = lfyear/totalgen;
sf = sf';
price = currentprice;

%--------------------------------------------------------------------------
% Determine Price
%--------------------------------------------------------------------------

D = size(sf);
priceforecast = zeros(D(1),1);
for k=1:D(1)

% Increase Price if Demand exceeds Supply    
if sf(k,1) >= 0.9 && sf(k,1) <= 0.95
    priceforecast(k,1) = price*1.1;
else
    if sf(k,1) > 0.95 && sf(k,1) <= 1.0
     priceforecast(k,1) = price*1.2;    
    else
        if sf(k,1) > 1.0
            priceforecast(k,1) = price*1.5;
        else
            % Decrease Price if Surplus in Generation
            priceforecast(k,1) = price*0.95;
        end;
    end;
end;
price = priceforecast(k,1);
end;
return;

