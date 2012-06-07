function [ bwImage ] = BlockOtsu( grayImage )

perc = 0.1;
w = 1/perc;

[nRows nCols] = size(grayImage);

verticalWindow = floor(nRows * perc);
horizontalWindow = floor(nCols * perc);

restinhoVertical = nRows - verticalWindow/perc;  
restinhoHorizontal = nCols - horizontalWindow/perc;

bwImage = zeros(nRows, nCols);

for v=1:w
    for h=1:w
        
        x0 = (v - 1) * verticalWindow + 1;
        xf = v * verticalWindow;
        y0 = (h - 1) * horizontalWindow + 1;
        yf = h * horizontalWindow;
        
        if(v == w)
            xf = xf + restinhoVertical;
        end
        
        if(h == w)
            yf = yf + restinhoHorizontal;
        end
        
        ima = grayImage(x0:xf,y0:yf);
        T = graythresh(ima);
        bwImage(x0:xf,y0:yf) = im2bw(ima,T);
    end
end

end

