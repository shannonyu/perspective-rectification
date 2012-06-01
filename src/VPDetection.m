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

%[Hdirect Vdirect] = VPDetectionIndirect(clusters, lines, bwImage);
    %H = 0.5 * Hindirect + 0.5 * Hdirect;
    %V = 0.5 * Vindirect + 0.5 * Vdirect;

%     H = 0.5 * Hindirect + 0.5 * Hdirect;
%     V = 0.5 * Vindirect + 0.5 * Vdirect;

    [value index] = max(indirectProfit);

    HxIndirect = clusters(index,1);
    HyIndirect = clusters(index,2);

    [value index] = min(directProfit);

    HxDirect = clusters(index,1);
    HyDirect = clusters(index,2);

    d = euclideanDist(HxIndirect, HyIndirect, HxDirect, HyDirect);
    
    if(d > 1000)
        Hx = HxIndirect;
        Hy = HyIndirect;
    else
        Hx = (HxIndirect + HxDirect)/2;
        Hy = (HyIndirect + HyDirect)/2;
        
        if(abs(Hx) < 1000)
            if(Hx < 0)
                Hx = Hx - 5000;
            else
                Hx = Hx + 2000;
            end
        end
    end
else
    Hx = [];
    Hy = [];    
end



end

function d = euclideanDist(x1,y1,x2,y2)

    d = sqrt( (x1-x2)^2 + (y1-y2)^2 );

end