function [rgbImage grayImage bwImage bwImageOriginalSize edgeImage labelledImage props numComps] = PreProcessImage( fileName, con, edgeAlg, prop1, prop2, scale )

rgbImage = imread(fileName);
grayImage = rgb2gray(rgbImage);
bwImageOriginalSize = BlockOtsu( grayImage );

rgbImage = imresize(rgbImage, scale);
grayImage = rgb2gray(rgbImage);
bwImage = BlockOtsu( grayImage );
edgeImage = edge(grayImage./2,edgeAlg, [0.01 0.15], 2);

[labelledImage numComps] = bwlabel(edgeImage, con);
props = regionprops(labelledImage, prop1, prop2);

end

