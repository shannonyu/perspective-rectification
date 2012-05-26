function [horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage )

if nargin == 0 
    clear all;
    load workspaceWorkspace.mat
end

debugAllComponents = 0;
debugGoodComponents = 1;
debugoutputpath = 'C:\dev\perspective\svn\src\temp\';

% n de linhas e colunas
[nRows nCols] = size(bwImage);

% tamanho mínimo de altura de largura para uma componente entrar no fluxo
% (default 10%)
minHeight = nRows * 0.05;
minWidth = nCols * 0.051;

% inicializa array das componentes
goodComps = [];

% Find long connected components
for comp = 1:numComps
    
    [x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox(props, comp, bwImage, grayImage, edgeImage);
    
    if debugAllComponents == 1
        imshow(edgeComponent);
        edgeComponent(labelledImage(y0:yf,x0:xf) ~= comp) = 0; % mostra só os segmentos pertencentes a componente.. e zera os outros de interecção
        imwrite(edgeComponent,[debugoutputpath int2str(comp) '.tif'] ,'tif');
    end
    
    if(width >= minWidth && height >= minHeight)
        goodComps = [goodComps; comp];
        
        if debugGoodComponents == 1
            imshow(edgeComponent);
            edgeComponent(labelledImage(y0:yf,x0:xf) ~= comp) = 0; % mostra só os segmentos pertencentes a componente.. e zera os outros de interecção
            imwrite(edgeComponent,[debugoutputpath int2str(comp) '.tif'] ,'tif');
        end
    end
    
end

end

