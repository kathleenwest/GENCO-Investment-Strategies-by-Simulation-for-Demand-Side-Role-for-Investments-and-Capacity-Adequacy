function createnormal(bxy,branch,bus,gen)
%createnormal    Creates Display of Normal System Topology
%   Dynamically color codes based on bus voltage being too high, or too low
%   or MVA rating of line at either end of line being exceeded
%   Generation and Load is displayed on each bus per the input matrix
%   bxy holds the location of the bus bars (bus x1 x2 y1 y2) and is NX4
%   branch,bus,gen is an output as a result of the power flow solution 

%--------------------------------------------------------------------------
% Variables
state = ' Normal'; %current game state 

% Sorts and Sums the Generation
gen = sortrows(gen,[1 2])

D = size(gen);
gen2 = gen;
n = 2;
for k=2:D(1)
    if (gen(k,1) == gen(k-1,1))
       gen2(n,2) = gen2(n,2) + gen2(n-1,2); 
       gen2(n,3) = gen2(n,3) + gen2(n-1,3);
       gen2(n-1,:) = [];
       n = n-1;
    else
    end;
    n = n+1;
end;

gen = gen2;

% Creates a general data matrx used in this procedure
D = size(bus);
G = size(gen);
busdata = zeros(D(1),7);
for k=1:D(1)
    busdata(k,1) = bus(k,1);
    busdata(k,2) = bus(k,8);
    busdata(k,3) = bus(k,9);
    busdata(k,4) = 0;
    busdata(k,5) = 0;
    for j =1:G(1)
        if bus(k,1) == gen(j,1)
            busdata(k,4) = gen(j,2);
            busdata(k,5) = gen(j,3);
        else
        end;
    end;
    busdata(k,6) = bus(k,3);
    busdata(k,7) = bus(k,4);
end;

% Creates a Matrix of Bus Labels
D = size(bus);
for k=1:D(1)
bustext(k,1:4) = strcat('Bus',int2str(bus(k,1)));    
end;

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Set the GRID
cla; % clear Figure Axis
clf; % clear Figure
set(0,'Units','normalized'); % normalizes the screen coordinate system to 0,0,1,1
axis([0 200 0 200])
axis off; %hides the axis
set(gcf,'Color','k') % sets the background of the figure to black
rect = [100,100,600,600];
set(gcf,'Position',rect) % sets the position of the figure
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Print Current States and Scores
title1 = text(40,210,'Current System Topology','FontSize',17,'Color','w'); % Title
title1 = text(-30,190,strcat('State = ',state),'FontSize',12,'Color','w'); %Game State
title1 = text(-30,180,'Red Values = Over Voltage Limits','FontSize',8,'Color','r'); %info
title1 = text(-30,170,'Red Lines = Over MVA Rating','FontSize',8,'Color','r'); %info
title1 = text(-30,160,'Blue Values = Under Voltage Limit','FontSize',8,'Color','b'); %info
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Prints Bus Bars and Adds IDs
D=size(bxy);
% prints the bus bars
for k=1:D(1)
createline(bxy(k,2),bxy(k,3),bxy(k,4),bxy(k,5),'w',4);
end;
% prints the bus bar text
for k=1:D(1)
createtext(bustext(k,1:4),bxy(k,2),bxy(k,3),bxy(k,4),bxy(k,5));
end;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Create Transmission Lines -  Dynamically color coded based on MVA overload
% Determine the Centroid of the bus bars
[branches] = centroidlines(bxy);
D=size(branch);
for k=1:D(1)
if sqrt(branch(k,12)*branch(k,12) + branch(k,13)*branch(k,13)) > branch(k,6) || sqrt(branch(k,14)*branch(k,14) + branch(k,15)*branch(k,15)) > branch(k,6)
  createline(branches(branch(k,1),2),branches(branch(k,2),2),branches(branch(k,1),3),branches(branch(k,2),3),'r',1);
else
  createline(branches(branch(k,1),2),branches(branch(k,2),2),branches(branch(k,1),3),branches(branch(k,2),3),'w',1);
end;        
end;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Print Voltages on Bus Bars - Dynamically Color Codes Values
% Blue = Undervoltage Limit, Red = Overvoltage Limit 
D=size(bxy);
busvoltages = zeros(0,0);
for k=1:D(1)
if busdata(k,2) > bus(k,12)   
 text([branches(k,2)-5 branches(k,2)-5],[branches(k,3)+4 branches(k,3)+4],num2str(busdata(k,2)),'Color','r');
else
    if busdata(k,2) < bus(k,13)
        text([branches(k,2)-5 branches(k,2)-5],[branches(k,3)+4 branches(k,3)+4],num2str(busdata(k,2)),'Color','b');
    else 
        text([branches(k,2)-5 branches(k,2)-5],[branches(k,3)+4 branches(k,3)+4],num2str(busdata(k,2)),'Color','w');
    end;
end;
end;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Print Generation and Load
D = size(busdata);
for k=1:D(1)
if busdata(k,4) > 0
text([branches(k,2)-20 branches(k,2)-20],[branches(k,3)-5 branches(k,3)-5],'Generation','Color','y');    
text([branches(k,2)-20 branches(k,2)-20],[branches(k,3)-10 branches(k,3)-10],strcat(num2str(busdata(k,4),4),'W'),'Color','y');
text([branches(k,2)-20 branches(k,2)-20],[branches(k,3)-15 branches(k,3)-15],strcat(num2str(busdata(k,5),4),'V'),'Color','y'); 
else
end;
if busdata(k,6) > 0
text([branches(k,2)+10 branches(k,2)+10],[branches(k,3)-5 branches(k,3)-5],'Load','Color','m');    
text([branches(k,2)+10 branches(k,2)+10],[branches(k,3)-10 branches(k,3)-10],strcat(num2str(busdata(k,6),4),'W'),'Color','m');
text([branches(k,2)+10 branches(k,2)+10],[branches(k,3)-15 branches(k,3)-15],strcat(num2str(busdata(k,7),4),'V'),'Color','m'); 
else
end;
end;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Clean Up Workspace
%clear;
%--------------------------------------------------------------------------

return;