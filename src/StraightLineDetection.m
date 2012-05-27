function [horizontalLines verticalLines newEdgeImage] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage )

horizontalLines = [];
verticalLines = [];

if nargin == 0 
    clear all;
    load workspaceWorkspace.mat
end

debugAllComponents = 0;
debugGoodComponents = 0;
debugGoodImage = 0;
debugCleanedImage  = 0;
debugoutputpath = 'C:\dev\perspective\svn\src\temp\';

% n de linhas e colunas
[nRows nCols] = size(bwImage);

% tamanho mínimo de altura de largura para uma componente entrar no fluxo
% (default 10%)
minHeightWithEccentricity = nRows * 0.05;
minWidthWithEccentricity = nCols * 0.05;
BestEccentricity = 0.95;

minHeight = nRows * 0.1;
minWidth = nCols * 0.1;
WorseEccentricity = 0.80;

% inicializa array das componentes
goodComps = [];
badComps = [];
newEdgeImage = zeros(nRows, nCols);

% Find long connected components
for comp = 1:numComps
    
    [x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox(props, comp, bwImage, grayImage, edgeImage);
    
    if debugAllComponents == 1
        imwrite(edgeComponent,[debugoutputpath int2str(comp) '.tif'] ,'tif');
    end
        
    if ((width >= minWidthWithEccentricity && height >= minHeightWithEccentricity && props(comp).Eccentricity > BestEccentricity) || (width >= minWidth && height >= minHeight))
        
        goodComps = [goodComps; comp];
        
        % mostra só os segmentos pertencentes a componente.. e zera os outros de interecção
         labelledComponent = labelledImage(y0:yf,x0:xf);
%         edgeComponent(labelledComponent ~= comp) = 0;
        newEdgeImage(y0:yf,x0:xf) = labelledComponent;
        
        if debugGoodComponents == 1
            imwrite(edgeComponent,[debugoutputpath int2str(comp) '_1.tif'] ,'tif');
        end
        
        if debugGoodImage == 1
            imwrite(newEdgeImage,[debugoutputpath 'FilteredImage' int2str(comp) '.tif'] ,'tif');
        end
    else 
        badComps = [badComps; comp];
    end
    
end 

for i = 1:length(badComps)
    comp = badComps(i);
    newEdgeImage(newEdgeImage == comp) = 0;
end

if debugCleanedImage == 1
    imwrite(newEdgeImage,[debugoutputpath 'CleanedImage.tif'] ,'tif');
end

end




