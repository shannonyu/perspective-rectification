
function [rgbImage grayImage bwImage edgeImage labelledImage props numComps] = PreProcessImage( fileName, con, edgeAlg, prop, scale )

rgbImage = imread(fileName);
rgbImage = imresize(rgbImage, scale);
grayImage = rgb2gray(rgbImage);
% OtsuThreshold = graythresh(grayImage); % otsu (mudar para blockOtsu)
% bwImage = im2bw(grayImage,OtsuThreshold);
bwImage = BlockOtsu( grayImage );
edgeImage = edge(grayImage,edgeAlg);
%imshow(imaEdge);

[labelledImage numComps] = bwlabel(edgeImage, con);
props = regionprops(labelledImage, prop);

end

