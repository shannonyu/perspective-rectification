function [ verticalLines horizontalLines lines debugImage] = DetectLinesHough(bwImage)

verticalLines = [];
horizontalLines = [];

if nargin == 0
    bwImage = imread('C:\dev\perspective\svn\src\temp1\IMG_1271_bw.tif');
end

debugHoughSpace = 0;
debugLines = 1;


[imH imW] = size(bwImage);

% Calcula bwImage no espaço de Hough - H
[H, T, R] = hough(bwImage);
[nRows nCols] = size(H);

if debugHoughSpace == 1 % plotar espaço de Hough
    forShow = imresize(H, [nRows nCols*10]);
    imshow(imadjust(mat2gray(forShow)));
end

%lines = {};
it = 1;
lines = [];
insertH = 1;
insertV = 1;
wThreshold = 0.1;
while (insertH || insertV) && it < 50 
    [value index] = max(H(:));
    
    
    col = floor(index/nRows + 1);
    row = mod(index,nRows);

    for i = -5:5
        for j = -5:5
            index = ((col+i) - 1)*nRows + (row+j);
            if index > 0 && index < nRows*nCols
                H(index) = 0;
            end
        end
    end
    rho = R(row);
    theta = T(col);
    a = -(cosd(theta) / sind(theta));
    b = rho/sind(theta);
    lineAng = normalizeAngle(atan(a))*180/pi;
    
    
    insertH = 0;
    insertV = 0;
    isHorizontal = abs(lineAng) <= 45;
    if isHorizontal
        w = value/imW;
        if (w > wThreshold)
            insertH = 1;
        end
    else
        w = value/imH;
        if (w > wThreshold)
            insertV = 1;
        end
    end
    
    if insertV || insertH
        s = struct('alpha',a,'beta', b,'weight',w, 'lineLen',value);
        lines = [lines; s];
    end
    it = it + 1;
end

if debugLines == 1
    [nRows nCols] = size(bwImage);
    debugImage = zeros(nRows, nCols);
    
    len = length(lines);
    
    for i = 1:len
        line = lines(i);
        a = line.alpha;
        b = line.beta;
        w = line.weight;
        
        for x = 1:nCols
            y = floor(a*x + b);
            if(y > 0 && y <= nRows)
                debugImage(y,x) = 1;
            end
        end
    end
    
    %imwrite(debugImage, ['C:\dev\perspective\svn\src\temp\test.tif'],'tif');
end

end

function normalizedAngle = normalizeAngle (angle)
    normalizedAngle = angle;
    if (mod(2*pi,angle) >= 0)
        if (~(angle < pi))
            normalizedAngle = angle - 2*pi;
        end
    else
        if (angle < (-1)*pi)
            normalizedAngle = angle + 2*pi;
        end
    end
end

