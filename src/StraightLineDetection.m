function [horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage )

if nargin == 0 
    clear all;
    load workspaceWorkspace.mat
end

[nRows nCols] = size(bwImage);

% Find long connected components
for comp = 1:numComps
    
    [x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox(props, comp, bwImage, grayImage, edgeImage);
%     imshow(edgeComponent);
%     figure; imshow(edgeImage);
    imwrite(edgeComponent,'' ,'tif');
end

end

