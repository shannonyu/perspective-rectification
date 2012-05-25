clc;
clear all;

testImage = '..\base\iPhone4\IMG_1255.JPG';

con = 8;
edgeAlg = 'canny';
prop = 'BoundingBox';
scale = 0.5;

[rgbImage grayImage bwImage labelledImage props numComps] = PreProcessImage(testImage, con, edgeAlg, prop, scale);

[horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage );

%Vanishing Point Detections
HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);