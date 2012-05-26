clc;
clear all;
close all;

testImage = '..\base\iPhone4\IMG_1255.JPG';

debug = 1;
con = 8;
edgeAlg = 'canny';
prop = 'BoundingBox';
scale = 0.5;

[rgbImage grayImage bwImage labelledImage props numComps] = PreProcessImage(testImage, con, edgeAlg, prop, scale);

subplot(1,2,1), imshow(grayImage);
subplot(1,2,2), imshow(bwImage);

[horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage );

%Vanishing Point Detections
HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);