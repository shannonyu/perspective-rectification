function [horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage )

if nargin == 0 
    clear all;
    load workspaceWorkspace.mat
end

debugAllComponents = 0;
debugGoodComponents = 0;
debugGoodImage = 1;
debugoutputpath = 'C:\dev\perspective\svn\src\temp\';

% n de linhas e colunas
[nRows nCols] = size(bwImage);

% tamanho mínimo de altura de largura para uma componente entrar no fluxo
% (default 10%)
minHeight = nRows * 0.05;
minWidth = nCols * 0.05;

% inicializa array das componentes
goodComps = [];
debugImage = ones(nRows, nCols);

% Find long connected components
for comp = 1:numComps
    
    [x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox(props, comp, bwImage, grayImage, edgeImage);
    
    if debugAllComponents == 1
        imwrite(edgeComponent,[debugoutputpath int2str(comp) '.tif'] ,'tif');
    end
    
    if (width >= minWidth && height >= minHeight && props(comp).Eccentricity > .95)
        
        goodComps = [goodComps; comp];
        
        % mostra só os segmentos pertencentes a componente.. e zera os outros de interecção
        labelledComponent = labelledImage(y0:yf,x0:xf);
        edgeComponent(labelledComponent ~= comp) = 0;
        debugImage(y0:yf,x0:xf) = edgeComponent;
        
        if debugGoodComponents == 1
            imwrite(edgeComponent,[debugoutputpath int2str(comp) '_1.tif'] ,'tif');
        end
        
        if debugGoodImage == 1
            imwrite(debugImage,[debugoutputpath 'FilteredImage' int2str(comp) '.tif'] ,'tif');
        end
end
     end
    
end




