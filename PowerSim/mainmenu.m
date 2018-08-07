clear;
clc
player = 'Coal Company';
competition = 'Low';
loadgrowth = 'Low';
N=5;

fprintf('\n');
fprintf('\n');

    fprintf('\n=====================================================================');
    fprintf('\n|               Power Sim Investor v1.1                             |');
    fprintf('\n=====================================================================');
    fprintf('\n Description: A 9-bus system needs power planning. Play as an investor');
    fprintf('\n and try to maximize your profits before your competitors beat you to ');
    fprintf('\n meeting the load growth, or play as an RTO to deliver power at       ');
    fprintf('\n minimal cost and minimal lost with N-1 contingency planning.         ');

    
choice = 1;
while ~isequal(choice,-1)
fprintf('\n');
fprintf('\n');
    fprintf('\n_____________________________________________________________________');
    fprintf('\n');
    fprintf('\n                Main Menu                                             ');
fprintf('\n');
fprintf('\n');
    fprintf('\n 1. How to Play - First time users select this option         ');
    fprintf('\n 2. Change Settings - Choose Player, Select Difficulty          ');
    fprintf('\n 3. Play Simulation          ');
    fprintf('\n 4. Exit          ');
 fprintf('\n');   
fprintf('\n');      
    
    
choice = input('Enter Choice Number:');
fprintf('\n');
    if choice == 1
      howtoplay
    else
    end;
    if choice == 2
      [player,competition,loadgrowth,N] = changesettings(player,competition,loadgrowth,N);
      clc
    else
    end;
    if choice == 3
      playsimulation(player,competition,loadgrowth,N);
    else
    end;
    if choice == 4
      choice = -1;
    else
    clc    
    end;

end;   
clc
clear