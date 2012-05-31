function profitHisto = VPDirect(clusters, lines, bwImage, edgeImage)

if nargin == 0 
    clc;
    clear all;
    load workspaceWorkspace.mat
end

% inters = [];

% len = length(lines);
 [nRows nCols] = size(bwImage);
% 
% for i=1:len
%     for j=1:len
%         if i ~= j
%             a = lines(i).alpha;
%             b = lines(i).beta;
%             c = lines(j).alpha;
%             d = lines(j).beta;
%             
%             if(a ~= c)
%                 x = (d - b)/(a - c);
%                 y = a*x + b;
% 
%                 if(~isinf(x) && ~isinf(y) && ~isnan(x) && ~isnan(y))
%                     if( ~(x > 0 && x < nCols && y > 0 && y < nRows) ) %aceito pontos apenas fora da página
%                         inter = struct('x',x,'y',y,'i',i,'j',j);
%                         inters = [inters; inter];
%                     end
%                     
%                 end
%             end
%         end
%     end
% end

%drawlines(inters, lines, nRows, nCols);

len = length(clusters);

centroX = nCols / 2;
centroY = nRows / 2;
N = 200;

profitHisto = zeros(len,1);


for w = 1:len

    histo = zeros(N,1);
    x = clusters(w,1);
    y = clusters(w,2);
    
   delta_theta = FindAngleOnBoudingCircle(x,y,centroX, centroY, nRows, nCols);   
   %disp(['w = ' int2str(w) ' ' num2str(x) ' ' num2str(y) ' ' num2str(delta_theta)]);

   for i = 1:nRows
       for j = 1:nCols
           if(edgeImage(i,j) == 1)
                theta = CalculateThetaPixel(x,y,i,j, centroX, centroY);
                
                  if(i > centroY)
                     index = round(0.5*N + N * (theta/delta_theta));
                  elseif (i < centroY)
                     index = round(0.5*N - N * (theta/delta_theta));
                  else
                      index = 0.5*N;
                  end
                
                %disp(['point = ' int2str(i) ' ' int2str(j) ' ' int2str(index)]);
                index = min(N, index);
                index = max(1, index);
                
                if( isreal(index) )
                    histo(index) = histo(index) + 1;
                end
                
                
           end
       end
   end
  
	%saveHisto(histo, w, N);
    
    % Avalia Histograma
    profitHisto(w) = evaluateHisto(histo);
   
end

end

function profit = evaluateHisto(h)

    len = length(h);
    profit = 0;
    
    for i = 1:len - 1
        profit = profit + (h(i + 1) - h(i))^2;
    end

end

function saveHisto(histo, w, N)

m = max(histo);
histo = round(histo/m * 100);

image = ones(100, N);

for i = 1:N
    for j = 1:histo(i)
        image(101 - j, i) = 0;
    end
end

imwrite(image, ['C:\dev\perspective\svn\src\temp\temp2\' int2str(w) '.tif'],'tif');

end

function theta = CalculateThetaPixel(x,y,i,j, centroX, centroY)

    a = euclideanDist(i,j,centroX,centroY);
    b = euclideanDist(x,y,centroX,centroY);
    c = euclideanDist(x,y,i,j);
    
    theta = acosd( - (a^2 - b^2 - c^2)/(2*b*c) );

end

function d = euclideanDist(x1,y1,x2,y2)

    d = sqrt( (x1-x2)^2 + (y1-y2)^2 );

end

function delta_theta = FindAngleOnBoudingCircle(x,y,centroX, centroY, nRows, nCols)

   
    d = sqrt( (centroX - x)^2 + (centroY - y)^2 );
    r = sqrt( (nCols/2)^2 + (nRows/2)^2 );
    
    delta_theta = asind(r/d) * 2;   
    

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



















