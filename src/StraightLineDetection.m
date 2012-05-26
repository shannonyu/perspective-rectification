function [horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage )

debug = 0;
debugoutputpath = 'C:\dev\perspective\svn\src\temp\';

if nargin == 0 
    clear all;
    load workspaceWorkspace.mat
end

[nRows nCols] = size(bwImage);

% Find long connected components
for comp = 1:numComps
    
    [x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox(props, comp, bwImage, grayImage, edgeImage);
    
    if debug == 1
        imshow(edgeComponent);
        edgeComponent(labelledImage(y0:yf,x0:xf) ~= comp) = 0; % mostra só os segmentos pertencentes a componente.. e zera os outros de interecção
        imwrite(edgeComponent,[debugoutputpath int2str(comp) '.tif'] ,'tif');
    end
end

end

