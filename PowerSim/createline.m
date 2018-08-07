function createline(x1,x2,y1,y2,color,width)
%createline - given 2 xcoordinates, 2 ycoordinates, color, width, and line
%name, create a new line in the figure

line([x1 x2],[y1 y2],'Color',color,'LineWidth',width,'Clipping','off');
return;