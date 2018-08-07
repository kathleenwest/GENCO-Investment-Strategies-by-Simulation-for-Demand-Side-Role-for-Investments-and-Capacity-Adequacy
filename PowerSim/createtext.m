function [name2] = createtext(name,x1,x2,y1,y2)
%createline - given 2 xcoordinates, 2 ycoordinates, color, width, and line
%name, create a new line in the figure
name2 = strcat(name,'t');
name2 = text([x1+20 x2],[y1 y2],name,'Color','w');
return;