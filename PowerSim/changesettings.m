function [player,competition,loadgrowth,N] = changesettings(player,competition,loadgrowth,N)
%changesettings - Changes player, competition level, loadgrowth level, and
%the planning period
format short g;

clc;
choice = 1;
while ~isequal(choice,-1)
fprintf('\n');
fprintf('\n');
    fprintf('\n_____________________________________________________________________');
    fprintf('\n');
    fprintf('\n                Change Settings                                      ');
fprintf('\n');
fprintf('\n');
    fprintf('\n 1. Players         ');
    fprintf('\n 2. Competition Amongst Companies    ');
    fprintf('\n 3. Load Growth    ');
    fprintf('\n 4. N - Number of Years Planning  ');     
    fprintf('\n 5. Exit to Main Menu        ');
fprintf('\n');
fprintf('\n');   
    
choice = input('Enter Choice Number:');
fprintf('\n');
    if choice == 1
      clc  
      fprintf('\n Players         ');
      fprintf('\n 1. Coal Company   ');
      fprintf('\n 2. Gas Company         ');
      fprintf('\n');
      fprintf('\n Current Player is the %s',player);
      fprintf('\n');
      pchoice = input(' Would you like to change Players? (Y/N)','s');
      fprintf('\n');
      if strcmp('Y',pchoice) || strcmp('y',pchoice)
        pchoice = input(' Choose the Player Number:');
        fprintf('\n');
            if pchoice == 1
                player = 'Coal Company';
            else
            end;
            if pchoice == 2
                player = 'Gas Company';
            else
            end;   
      else
      end;
    fprintf('\n');
    fprintf('\n Current Player is the %s',player); 
    pause(2)
    clc
    else
    end;
    if choice == 2
      clc  
      fprintf('\n Competition         ');
      fprintf('\n 1. Off   ');
      fprintf('\n 2. Low         ');
      fprintf('\n 3. Medium         ');
      fprintf('\n 4. High         ');
      fprintf('\n');
      fprintf('\n Current Competition is set to %s',competition);
      fprintf('\n');
      pchoice = input(' Would you like to change the Competition setting (Y/N)','s');
      fprintf('\n');  
      if strcmp('Y',pchoice) || strcmp('y',pchoice)
        pchoice = input(' Choose the Setting Number:');
        fprintf('\n');
            if pchoice == 1
                competition = 'Off';
            else
            end;
            if pchoice == 2
                competition = 'Low';
            else
            end;
            if pchoice == 3
                competition = 'Medium';
            else
            end;
            if pchoice == 4
                competition = 'High';
            else
            end;          
        else
        end;
          fprintf('\n');
          fprintf('\n Current Competition Setting is on %s',competition);
          pause(2)
          clc
    else
    end;
    if choice == 3
      clc  
      fprintf('\n Load Grwoth         ');
      fprintf('\n 1. Off   ');
      fprintf('\n 2. Low         ');
      fprintf('\n 3. Medium         ');
      fprintf('\n 4. High         ');
      fprintf('\n');
      fprintf('\n Current Growth is set to %s',loadgrowth);
      fprintf('\n');
      pchoice = input(' Would you like to change the Load Growth (Y/N)','s');
      fprintf('\n');  
      if strcmp('Y',pchoice) || strcmp('y',pchoice)
        pchoice = input(' Choose the Setting Number:');
        fprintf('\n');
            if pchoice == 1
                loadgrowth = 'Off';
            else
            end;
            if pchoice == 2
                loadgrowth = 'Low';
            else
            end;
            if pchoice == 3
                loadgrowth = 'Medium';
            else
            end;
            if pchoice == 4
                loadgrowth = 'High';
            else
            end;          
        else
        end;
          fprintf('\n');
          fprintf('\n Current Load Growth Setting is on %s',loadgrowth);
          pause(2)
          clc   
    else
    end;
    if choice == 4
     clc
     fprintf('\n The Current Planning Period N is %s years',int2str(N));
     fprintf('\n');
     pchoice = input(' Would you like to change the Planning Period (Y/N)','s');
     if strcmp('Y',pchoice) || strcmp('y',pchoice)
       pchoice = input(' Enter the number of years (integer):'); 
       N = pchoice;
     else
     end;
       fprintf('\n');
       fprintf('\n The Current Planning Period N is %s years',int2str(N));
       pause(2)
       clc   
    else     
    end;
    if choice == 5
      choice = -1;
      clc
    else
    end;
 
end;   
return;