function [Hx Hy Vx Vy] = VPDetection(lines, bwImage, edgeImage)

% if(nargin == 0)
%     load workspaceWorkspace.mat;
% end

Vx = Inf;
Vy = Inf;

[nRows nCols] = size(bwImage);
%% Clustering for vanishing point detection
[nP intersections] = CalculateLineIntersections(lines, nRows, nCols);
if (nP > 0)
    clear clusters;
    clear idx;
    
    if(nP >= 10)
        
    nClusters = max(ceil(log(nP)),10);
    nClusters = min(nClusters, nP);
    [idx, clusters] = kmeans(intersections, nClusters, 'Replicates',...
        ceil(nP/2), 'EmptyAction', 'drop');
    
        indirectProfit = VPIndirect(idx, clusters);
    else
        clusters = intersections;
        indirectProfit = ones(nP, 1);
    end
    
    %% Vanishing point detection and selection

    directProfit = VPDirect(clusters, lines, bwImage, edgeImage); % menor eh melhor

    [value index] = max(indirectProfit);

    HxIndirect = clusters(index,1);
    HyIndirect = clusters(index,2);

    [value index] = min(directProfit);

    HxDirect = clusters(index,1);
    HyDirect = clusters(index,2);

    % d = euclideanDist(HxIndirect, HyIndirect, HxDirect, HyDirect);
  
else
    Hx = [];
    Hy = [];    
end



end

function d = euclideanDist(x1,y1,x2,y2)

    d = sqrt( (x1-x2)^2 + (y1-y2)^2 );

end