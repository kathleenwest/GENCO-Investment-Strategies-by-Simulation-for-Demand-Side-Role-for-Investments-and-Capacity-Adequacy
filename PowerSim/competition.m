function [bus,gen,gencost] = competition(currentprice,comp,bus,gen,gencost,player,bidprice,loadforecast);
capacity = 20;
compinvest = 0;

if currentprice >= bidprice

if strcmp(comp,'Off') == 1 
    % There is not competition competition
else
end;

if strcmp(comp,'Low') == 1

       % < 25 percent or less chance there will be competiting activity
       num1 = rand;
       num2 = rand;
       
       if num1*num2 >=0.50
        % competition invests
        compinvest = 1;     
       else
        % competition does not invest   
       end;
else
end;

if strcmp(comp,'Medium') == 1
        
       % 50 percent or less chance there will be competiting activity
       num1 = rand;
       num2 = rand;
       
       if num1*num2 >=0.20
        % competition invests
        compinvest = 1;       
       else
        % competition does not invest   
       end;
else
end;

if strcmp(comp,'High') == 1
 
        % 80 percent or less chance there will be competiting activity
       num1 = rand;
       num2 = rand;
       
       if num1*num2 >=0.05
        % competition invests
        compinvest = 1;       
       else
        % competition does not invest   
       end;          
        
 else
 end;
       

if compinvest == 1 
    % Randomly determine on which bus the investment will be
    num1 = rand;
    num1 = floor(num1*10);
    if num1 == 0
        businvest = 9;   
    else
        businvest = num1;   
    end;
    fprintf('\n');  
    fprintf('\n !!!! Attention, one of your competitors invested in new generation !!!!!');  
    fprintf('\n');  
    fprintf('\n Competitor will be investing 20 MW at bus: %s', int2str(businvest));  
    fprintf('\n');  
    fprintf('\n');  
    pause(3);
    gen_add = [businvest          capacity           50          50          -50        1.025          100            1          capacity           10];
    gen = [gen; gen_add];
    % Add New Investment Generator Cost Information
    gencost_add   =         [2            0            0            3            0        bidprice            0];
    gencost = [gencost; gencost_add];
    % Change bus type except the slack
      if businvest == 1
      % do nothing
      else
       bus(businvest,2) = 2; 
      end;
else
end;


else
end;
      
return;
