function [Hdirect Vdirect] = VPDetectionDirect(clusters, lines, bwImage)

if nargin == 0 
    clc;
    clear all;
    load workspaceWorkspace.mat
end

inters = [];

len = length(lines);
[nRows nCols] = size(bwImage);

for i=1:len
    for j=1:len
        if i ~= j
            a = lines(i).alpha;
            b = lines(i).beta;
            c = lines(j).alpha;
            d = lines(j).beta;
            
            if(a ~= c)
                x = (d - b)/(a - c);
                y = a*x + b;

                if(~isinf(x) && ~isinf(y) && ~isnan(x) && ~isnan(y))
                    if( ~(x > 0 && x < nCols && y > 0 && y < nRows) ) %aceito pontos apenas fora da página
                        inter = struct('x',x,'y',y,'i',i,'j',j);
                        inters = [inters; inter];
                    end
                    
                end
            end
        end
    end
end

%drawlines(inters, lines, nRows, nCols);

len = length(inters);

for i = 1:len
	inter = inters(109);
    x = inter.x;
    y = inter.y;
    
    delta_theta = FindAngleOnBoudingCircle(x,y,bwImage);   
    
end

end

function theta = FindAngleOnBoudingCircle(x,y,bwImage)

    [nRows nCols] = size(bwImage);
    
    centroX = nCols / 2;
    centroY = nRows / 2;
    
    d = sqrt( (centroX - x)^2 + (centroY - y)^2 );
    r = sqrt( (nCols/2)^2 + (nRows/2)^2 );
    
    theta = asind(r/d) * 2;

end

function drawlines(inters, lines, nRows, nCols)

len = length(inters);



for w = 1:len
    debugImage = zeros(nRows, nCols);
    inter = inters(w);

    line = lines(inter.i);
    a = line.alpha;
    b = line.beta;

    for x = 1:nCols
        y = floor(a*x + b);
        if(y > 0 && y <= nRows)
            debugImage(y,x) = 1;
        end
    end
    
    line = lines(inter.j);
    a = line.alpha;
    b = line.beta;

    for x = 1:nCols
        y = floor(a*x + b);
        if(y > 0 && y <= nRows)
            debugImage(y,x) = 1;
        end
    end
    
    imwrite(debugImage,['C:\dev\perspective\svn\src\temp\temp\'  int2str(w) '.tif'],'tif');

end

end



















