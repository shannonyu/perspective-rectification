function [ verticalLines horizontalLines lines debugImage] = DetectLinesHough(bwImage)

verticalLines = [];
horizontalLines = [];

if nargin == 0
    bwImage = imread('C:\dev\perspective\svn\src\temp1\IMG_1271_bw.tif');
end

debugHoughSpace = 0;
debugLines = 1;

% Calcula bwImage no espaço de Hough - H
[H, T, R] = hough(bwImage);
[nRows nCols] = size(H);

if debugHoughSpace == 1 % plotar espaço de Hough
    forShow = imresize(H, [nRows nCols*10]);
    imshow(imadjust(mat2gray(forShow)));
end

%lines = {};
it = 1;
globalMax = 0;
lines = [];
w = 1;
while w > 0.2 && it < 20 
    [value index] = max(H(:));
    
    if it == 1
        globalMax = value;
    end
    
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
    w = value/globalMax;
    a = -(cosd(theta) / sind(theta));
    b = rho/sind(theta);
    s = struct('alpha',a,'beta', b,'weight',w);
    
    lines = [lines; s];

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

