function [transformedImage transformedImageRGB croppedImageRGB] = TransformImage(Hx, Hy, Vx, Vy, bwImage, bwImageOriginalSize, rgbImageOriginalSize, scale)
%load workspaceWorkspace.mat


[nRows  nCols] = size(bwImage);

centroX = nCols / 2;
centroY = nRows / 2;

[delta_theta r] = FindAngleOnBoudingCircle(Hx,Hy,centroX, centroY, nRows, nCols);  


theta = delta_theta/2;

% achar b

b2  = Hy  - Hx * tand(-theta);
b1  = Hy  - Hx * tand(theta);


V1 = centroX - r;
V2 = (centroX + r);

ax = V1;
ay = ax * tand(-theta)  + b2;

bx = V2;
by = bx * tand(-theta)  + b2;

cx = V1;
cy = cx * tand(theta)  + b1;

dx = V2;
dy = dx * tand(theta)  + b1;

ab =  euclideanDist(ax,ay,bx,by);
ac =  euclideanDist(ax,ay,cx,cy);
bd =  euclideanDist(bx,by,dx,dy);
dc =  euclideanDist(dx,dy,cx,cy);

% if(ab > 2000 || ac > 2000 || bd > 2000 || dc > 2000 && 0)
%     transformedImage = [];
%     transformedImageRGB = [];
% else

    %drawquadrilate(ax, ay, bx, by, cx, cy, dx, dy);

    Xmin = min([ax, bx, cx, dx]);
    Ymin = min([ay, by, cy, dy]);

    Xmax = max([ax, bx, cx, dx]);
    Ymax = max([ay, by, cy, dy]);

    [transformedImage transformedImageRGB croppedImageRGB] = transform(Xmin, Ymin, Xmax,  Ymax, ax, ay, bx, by, cx, cy, dx, dy, bwImage, rgbImageOriginalSize);
% end
end


function d = euclideanDist(x1,y1,x2,y2)

    d = sqrt( (x1-x2)^2 + (y1-y2)^2 );

end

function [transformedImage transformedImageRGB croppedImageRGB] = transform(Xmin, Ymin, Xmax,  Ymax, ax, ay, bx, by, cx, cy, dx, dy, bwImage, rgbImageOriginalSize)

% hold off
% axis([Ymin*1.5 Ymax*1.5 Xmin*1.5 Xmax*1.5]);
nRows = size(rgbImageOriginalSize, 1);
nCols = size(rgbImageOriginalSize, 2);

X = [ay; cy; dy; by;];
Y = [ax; cx; dx; bx];

% plot([X;X(1)],[Y;Y(1)],'r')
% hold
% plot([0 0 640 640 0], [0 480 480 0 0],'b')
%axis([ -100 900 -100 580 ])
Yp=[Xmin;   Xmin; Xmax; Xmax];
Xp=[Ymin; Ymax; Ymax;  Ymin];
B = [ X Y ones(size(X)) zeros(4,3)        -X.*Xp -Y.*Xp ...
      zeros(4,3)        X Y ones(size(X)) -X.*Yp -Y.*Yp ];
B = reshape (B', 8 , 8 )';
D = [ Xp , Yp ];
D = reshape (D', 8 , 1 );
l = inv(B' * B) * B' * D;
%l = (B' * B) \ B * D;
A = reshape([l(1:6)' 0 0 1 ],3,3)';
C = [l(7:8)' 1];

transformedImage = ones(nRows * 3, nCols*3);
transformedImageRGB = zeros(nRows * 3, nCols*3, 3);

minimoi = Inf;
minimoj = Inf;

for x = 1:(nRows/10)
    for y = 1:(nCols/10)
            t= A*[x;y;1]/(C*[x;y;1]);
            minimoi =  min(floor(t(1)), minimoi);
            minimoj = min(floor(t(2)), minimoj);
%             if i + minimoi <= 0 || j + minimoj <= 0
%                 transformedImage = [];
%                 transformedImageRGB = [];
%                 return; 
%             else
%                 transformedImage(i + minimoi, j + minimoj) = 0;
%                 transformedImageRGB(i + minimoi, j + minimoj,1) = rgbImageOriginalSize(x,y,1);
%                 transformedImageRGB(i + minimoi, j + minimoj,2) = rgbImageOriginalSize(x,y,2);
%                 transformedImageRGB(i + minimoi, j + minimoj,3) = rgbImageOriginalSize(x,y,3);
%             end
    end
end
if minimoi <= 0
    minimoi = norm(minimoi) + 1;
else
    minimoi = 0;
end

if minimoj <= 0
    minimoj = norm(minimoj) + 1;
else
    minimoj = 0;
end

for x = 1:0.5:nRows
    for y = 1:0.5:nCols
            t= A*[x;y;1]/(C*[x;y;1]);
            i =  max(floor(t(1)),1);
            j = max(floor(t(2)),1);
		
		xt = i + minimoi;
		yt = j + minimoj;
        if (bwImage(round(x),round(y)) == 0 )
            transformedImage(xt, yt) = 0;
        end
		
		transformedImageRGB(xt, yt,1) =  rgbImageOriginalSize(round(x),round(y),1);
		transformedImageRGB(xt, yt,2) =  rgbImageOriginalSize(round(x),round(y),2);
		transformedImageRGB(xt, yt,3) =  rgbImageOriginalSize(round(x),round(y),3);
		
		if x == 1 && y == 1
                corner_tl = [xt yt];
		else
			if x == 1 && y == nCols
				corner_bl = [xt yt];
			else
				if x == nRows && y == 1
					corner_tr = [xt yt];
				else
					if x == nRows && y == nCols
						corner_br = [xt yt];
					end
				end
			end
		end
    end
end

topLimit = max(corner_tl(2), corner_tr(2));
bottomLimit = min(corner_bl(2), corner_br(2));
leftLimit = max(corner_tl(1), corner_bl(1));
rightLimit = min(corner_tr(1), corner_br(1));

croppedWidth = rightLimit - leftLimit;
croppedHeight = bottomLimit - topLimit;

croppedImageRGB = zeros(croppedWidth,croppedHeight,3);
croppedImageRGB = transformedImageRGB(leftLimit:rightLimit, topLimit:bottomLimit,:);
croppedImageRGB = uint8(croppedImageRGB);

transformedImageRGB = uint8(transformedImageRGB);
% transformedImage = [];
% imshow(image);
% imwrite(image, 'C:\dev\perspective\svn\src\temp\nasceu.tif','tif');
% imwrite(bwImage, 'C:\dev\perspective\svn\src\temp\isto.tif','tif');

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