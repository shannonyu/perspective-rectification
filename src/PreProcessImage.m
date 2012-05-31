function [rgbImage rgbImageOriginalSize grayImage bwImage bwImageOriginalSize edgeImage labelledImage props numComps] = PreProcessImage( fileName, con, edgeAlg, prop1, prop2, scale )

rgbImageOriginalSize = imread(fileName);
grayImage = rgb2gray(rgbImageOriginalSize);
bwImageOriginalSize = BlockOtsu( grayImage );

rgbImage = imresize(rgbImageOriginalSize, scale);
grayImage = rgb2gray(rgbImage);
bwImage = BlockOtsu( grayImage );
%edgeImage = edge(grayImage./2,edgeAlg, [0.01 0.15], 2);
edgeImage = edge(grayImage,edgeAlg);


[labelledImage numComps] = bwlabel(edgeImage, con);
props = regionprops(labelledImage, prop1, prop2);

end

