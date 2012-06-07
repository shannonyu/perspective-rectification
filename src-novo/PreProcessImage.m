function [rgbImage grayImage bwImage edgeImage labelledImage props numComps] = PreProcessImage( fileName, con, edgeAlg, prop1, prop2, scale )

rgbImageOriginalSize = imread(fileName);
rgbImage = imresize(rgbImageOriginalSize, scale);
grayImage = rgb2gray(rgbImage);
bwImage = BlockOtsu(grayImage);
edgeImage = edge(grayImage,edgeAlg);
[labelledImage numComps] = bwlabel(edgeImage, con);
props = regionprops(labelledImage, prop1, prop2);

end

