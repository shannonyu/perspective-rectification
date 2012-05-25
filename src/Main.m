clc;
clear all;

testImage = 'C:\Users\robson\Desktop\pi_prj\svn\base\iPhone4\IMG_1257.JPG';

con = 8;
RGBImage = imread(testImage);
GrayImage = rgb2gray(RGBImage);
OtsuThreshold = graythresh(GrayImage); % otsu (mudar para blockOtsu)
BitonalImage = im2bw(GrayImage,OtsuThreshold);
EdgeImage = edge(GrayImage,'canny');

%imshow(imaEdge);

[LabelledImage numComps] = bwlabel(EdgeImage, con);
Props = regionprops(LabelledImage, 'BoundingBox');

[horizontalLines verticalLines] = StraightLineDetection( LabelledImage, Props, numComps, GrayImage);
%Vanishing Point Detections
HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);