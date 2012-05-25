function [rgbImage grayImage bwImage labelledImage props numComps] = PreProcessImage( fileName, con, edgeAlg, prop )

rgbImage = imread(fileName);
grayImage = rgb2gray(rgbImage);
OtsuThreshold = graythresh(grayImage); % otsu (mudar para blockOtsu)
bwImage = im2bw(grayImage,OtsuThreshold);
edgeImage = edge(grayImage,edgeAlg);

%imshow(imaEdge);

[labelledImage numComps] = bwlabel(edgeImage, con);
props = regionprops(labelledImage, prop);

end

