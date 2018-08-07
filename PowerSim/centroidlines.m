function [centroidbxy] = centroidlines(bxy)
%centroidlines - given an NX5 matrix with bus bars and coordinates,
%determines and returns the centroid or middle of the line.
%[bus xcoordinate1 xcoordinate2 ycoordinate1 ycoordinate2]

D = size(bxy);
centroidbxy = zeros(9,3);
for k=1:D(1)
centroidbxy(k,1) = bxy(k,1);
centroidbxy(k,2) = (bxy(k,2) + bxy(k,3))/2;
centroidbxy(k,3) = (bxy(k,4) + bxy(k,5))/2;
end

return;