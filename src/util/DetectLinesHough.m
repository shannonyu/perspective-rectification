function [ verticalLines horizontalLines ] = DetectLinesHough( bwImage )

if nargin == 0
    bwImage = imread('C:\dev\perspective\svn\src\temp\IMG_1271_bw.tif');
end

debug = 0;

% Calcula bwImage no espaço de Hough - H
[H, T, R] = hough(bwImage);
[nRows nCols] = size(H);

if debug == 1 % plotar espaço de Hough
    forShow = imresize(H, [nRows nCols*10]);
    imshow(imadjust(mat2gray(forShow)));
end

%lines = {};
it = 1;
globalMax = 0;
lines = [];
w = 1;
while w < 0.5 || it > 10 
    [value index] = max(H(:));
    
    if it == 1
        globalMax = value;
    end
    
    col = floor(index/nRows + 1);
    row = mod(index,nRows);

    for i = -2:2
        for j = -2:2
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
    s = struct('alpha', a, 'beta', b, 'weight', value/globalMax);
    
    if isempty(lines)
        lines = [lines; s];
    end
    it = it + 1;
end

end

