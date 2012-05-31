function transformedImage = TransformImage(Hx, Hy, Vx, Vy, bwImage)

load workspaceWorkspace.mat


[nRows  nCols] = size(bwImage);

centroX = nCols / 2;
centroY = nRows / 2;

[delta_theta r] = FindAngleOnBoudingCircle(Hx,Hy,centroX, centroY, nRows, nCols);  


theta = delta_theta/2;

% achar b

b2  = Hy  - Hx * tand(-theta);
b1  = Hy  - Hx * tand(theta);


V1 = centroX - r;
V2 = centroX + r;

ax = V1;
ay = ax * tand(-theta)  + b2;

bx = V2;
by = bx * tand(-theta)  + b2;

cx = V1;
cy = cx * tand(theta)  + b1;

dx = V2;
dy = dx * tand(theta)  + b1;

drawquadrilate(ax, ay, bx, by, cx, cy, dx, dy);

end

function drawquadrilate(ax, ay, bx, by, cx, cy, dx, dy)

minX = norm(min([ax, bx, cx, dx]));
minY = norm(min([ay, by, cy, dy]));

maxX = norm(max([ax, bx, cx, dx]));
maxY = norm(max([ax, bx, cx, dx]));



ax = round(ax + minX) + 1; 
bx = round(bx + minX) + 1; 
cx = round(cx + minX) + 1; 
dx = round(dx + minX) + 1; 

ay = round(ay + minY) + 1; 
by = round(by + minY) + 1; 
cy = round(cy + minY) + 1; 
dy = round(dy + minY) + 1; 

maxX = norm(max([ax, bx, cx, dx]));
maxY = norm(max([ay, by, cy, dy]));
debugImage = zeros(maxY*1.1, maxX*1.1);

debugImage(ay, ax) = 1;
debugImage(by, bx) = 1;
debugImage(cy, cx) = 1;
debugImage(dy, dx) = 1;

se = ones(20);
debugImage = imdilate(debugImage,se);

end

function debugImage = drawLine(debugImage, ax, ay, bx, by)


end


function [delta_theta r] = FindAngleOnBoudingCircle(x,y,centroX, centroY, nRows, nCols)

   
    d = sqrt( (centroX - x)^2 + (centroY - y)^2 );
    r = sqrt( (nCols/2)^2 + (nRows/2)^2 );
    
    delta_theta = asind(r/d) * 2;   
    

end