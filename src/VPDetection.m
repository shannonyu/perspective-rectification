function [H V] = VPDetection(lines, bwImage)

%% Clustering for vanishing point detection
[nP intersections] = CalculateLineIntersections(lines);
if (nP > 0)
    nClusters = max(ceil(log(nP)),10);
    [idx, clusters] = kmeans(intersections, nClusters);
end

%% Vanishing point detection and selection
indirectProfit = VPIndirect(idx, clusters);

%[Hdirect Vdirect] = VPDetectionIndirect(clusters, lines, bwImage);

%H = 0.5 * Hindirect + 0.5 * Hdirect;
%V = 0.5 * Vindirect + 0.5 * Vdirect;


end