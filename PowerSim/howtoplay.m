function howtoplay(r)

clc;
choice = 1;
while ~isequal(choice,-1)

fprintf('\n');
fprintf('\n');
    fprintf('\n_____________________________________________________________________');
    fprintf('\n');
    fprintf('\n                How to Play                                          ');
fprintf('\n');
fprintf('\n');
    fprintf('\n The default player is the Coal Company, but may choose to be a Gas Company.       ');
    fprintf('\n As a genco, your objective is to maximize your profit earning potential by investing          ');
    fprintf('\n and knowing where and when to invest your generation. The Power Sim Investor program         ');
    fprintf('\n will forecast the load growth at each bus on the system. A demand-side price response ');
    fprintf('\n algorithm will forecast a price that depends on the adequacy of the entire system. ');
    fprintf('\n Excess generation that does not serve load will bring the market price down and vice versa. ');
    fprintf('\n The Unit Decommitment Optimal power flow algorithm will determine which generators and how ');
    fprintf('\n much generation to dispatch based on price and location of the generation in order to meet ');
    fprintf('\n the load growth on each bus.');
    fprintf('\n');
fprintf('\n');
fprintf('\n Game Hints: The existing generators are coal plants (three) and will be bidding the same price as the Coal  ');
fprintf('\n Company. However, if you are playing the Gas company, beware that your investment may not be dispatched');
    fprintf('\n because it expensive and coal generation may be in excess. When looking at investment alternatives, it is ');
fprintf('\n more profitable to consider short term if competition is high and long-term if competition is low.');
fprintf('\n To maximize profit: Player = Coal Company, Competition = OFF, Load Growth = HIGH');
fprintf('\n ');
fprintf('\n Good luck and try to get positive profits!');
fprintf('\n');

fprintf('\n');
fprintf('\n');   
    
      pchoice = input(' Exit to Main Menu (Y/N)','s');
      fprintf('\n'); 
      fprintf('\n');
fprintf('\n');
      if strcmp('Y',pchoice) || strcmp('y',pchoice)
        choice = -1;
      else
      end;
      clc;
end;


return;