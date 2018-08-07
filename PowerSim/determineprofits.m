function [profits] = determineprofits(player,mc,gen_old,gen,currentprice)

if strcmp(player,'Coal Company') == 1
D = size(gen)
sum = 0;
for k=1:D(1)
    if gen_old(k,2) == 50
       sum = sum + (gen(k,2)*currentprice*8760 - (mc(1,1)*gen_old(k,2)+ mc(1,2)*gen(k,2)*8760))/10^6 
    else        
    end;
end;

profits = sum;
else
D = size(gen)
sum = 0;
for k=1:D(1)
    if gen_old(k,2) == 51
       sum = sum + (gen(k,2)*currentprice*8760 - (mc(1,1)*gen(k,2)+ mc(1,2)*gen(k,2)*8760))/10^6 
    else        
    end;
end;

profits = sum;
    
    
    
    
end;
return;