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

    textBlockCount = 0;
    textBlockArray = nan(1, blockSize + vRest, blockSize + hRest);
    
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

            currentBlock = 1-bwImage(vStart:vEnd,...
                    hStart:hEnd);
            %debug    
            imshow(currentBlock);
                
            [blockRows blockCols] = size(currentBlock);
            
            blockPixelCount = blockRows * blockCols;
            
            blackPixelCount =...
                length(find(bwImage(vStart:vEnd,hStart:hEnd) == 0));
            blackPixelRatio = blackPixelCount/blockPixelCount;
            if(blackPixelRatio > BLANK_RATIO...
                    && blackPixelRatio < GRAPHICS_RATIO) 
                textBlockCount = textBlockCount + 1;
                textBlockArray(textBlockCount, 1:blockRows, 1:blockCols) =...
                    currentBlock;
                
                %debug
                resultImage(vStart:vEnd,...
                    hStart:hEnd) = ...
                    currentBlock;
            end
        end
    end
    
    for i=1:textBlockCount
        extractCharacteristics(textBlockArray);        
    end

    imshow(resultImage);
end

function [ascenderHeight characterHeight characterLeading wordSpacing] =...
    extractCharacteristics (textBlockArray)

    initialHArray = extractHeight(textBlockArray, 0);
    bMax = max(initialHArray(:,3));
    finalHArray = extractHeight(textBlockArray, bMax);
    hMiddle = median(finalHArray(:,3));
end

function hArray = extractHeight(textBlockArray, bMax)
    textBlockCount = length(textBlockArray);
    hArray = [];
    hCount = 1;
    for currentBlockIndex=1:textBlockCount
        textBlock(:, :) = textBlockArray(currentBlockIndex, :, :);
        currentBlock = textBlock(~isnan(textBlock(:,1)),~isnan(textBlock(1,:)));
        projection = sum(currentBlock, 2);
        minFontSize = 3;
        maxFontSize = 18;

        projectionLength = length(projection);
        projectionThreshold = floor(projectionLength / 9);
        hTop = 0;
        hBottom = 0;
        for i=1:projectionLength
            if (projection(i) > projectionThreshold)
                if (hTop < 1)
                    hTop = i;
                end
            else
                if (hTop > 0 && hBottom < 1)
                    hBottom = i - 1;
                end
            end

            if (hBottom == 0 && i == projectionLength)
                hBottom = projectionLength;
            end

            if (hBottom > 0 && hTop > 0)
                fontSize = hBottom - hTop + 1;
                if (fontSize >= minFontSize && fontSize <= maxFontSize...
                        && fontSize >= floor(bMax/2))
                    hArray(hCount,:) = [hTop hBottom fontSize];
                    %rever conceitos de htop e hbottom.
                    hCount = hCount + 1;
                end
                hTop = 0;
                hBottom = 0;
            end
        end
    end
end

