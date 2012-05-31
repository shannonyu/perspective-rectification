function indirectProfit = VPIndirect(idx, clusters)
%VPINDIRECT
%    indirectProfit = VPDetectionDirect(idx, clusters)

    nClusters = length(clusters);
    nPoints = length(idx);
    indirectProfit = zeros(nClusters,1);
    for cIndex=1:nClusters
        indirectProfit(cIndex) = length(find(idx == cIndex)) / nPoints;
    end
end