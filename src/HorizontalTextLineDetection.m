function [horizontalLines verticalLines] =...
    HorizontalTextLineDetection( labelledImage, props, numComps,...
    bwImage, verticalLines)
    %% Common
    [nRows nCols] = size(bwImage);
    totalPixelCount = nRows * nCols;

    %% Smear Segmentation
    BLANK_RATIO = 0.045;
    GRAPHICS_RATIO = 0.444;
    
    blockSize = floor(max([nRows nCols])*0.0455);

    vBlocksCount = floor(nRows / blockSize);
    hBlocksCount = floor(nCols / blockSize);

    vRest = nRows - vBlocksCount * blockSize;
    hRest = nCols - hBlocksCount * blockSize;

    resultImage = zeros(nRows, nCols);

    for vBlockIndex=1:vBlocksCount
        for hBlockIndex=1:hBlocksCount
            vStart = (vBlockIndex * blockSize)...
                - blockSize + 1;
            vEnd = vStart + blockSize;

            hStart = (hBlockIndex * blockSize)...
                - blockSize + 1;
            hEnd = hStart + blockSize;

            if(vBlockIndex == vBlocksCount)
                vEnd = vEnd + vRest - 1;
            end

            if(hBlockIndex == hBlocksCount)
                hEnd = hEnd + hRest - 1;
            end

            currentBlock = bwImage(vStart:vEnd,...
                    hStart:hEnd);
                
            [blockRows blockCols] = size(currentBlock);
            
            blockPixelCount = blockRows * blockCols;
            
            blackPixelCount =...
                length(find(bwImage(vStart:vEnd,hStart:hEnd) == 0));
            blackPixelRatio = blackPixelCount/blockPixelCount;
            if(blackPixelRatio > BLANK_RATIO...
                    && blackPixelRatio < GRAPHICS_RATIO) 
                resultImage(vStart:vEnd,...
                    hStart:hEnd) = ...
                    currentBlock;
            end
        end
    end

    imshow(resultImage);
end

