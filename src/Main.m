
clc;

imaRGB = imread('C:\Users\robson\Desktop\pi_prj\svn\base\iPhone4\IMG_1257.JPG');

I = rgb2gray(imaRGB);
level = graythresh(I); %otsu
imaBW = im2bw(I,level);
imaEdge = edge(I,'canny');
imshow(imaEdge);

[imaRotulada numComps] = bwlabel(imaEdge, 8);
props = regionprops(imaRotulada, 'BoundingBox');

for i = 1:numComps
   
end