clc;
clear all;

testImage = 'C:\Users\robson\Desktop\pi_prj\svn\base\iPhone4\IMG_1257.JPG';

con = 8;
edgeAlg = 'canny';
prop = 'BoundingBox';

[rgbImage grayImage bwImage labelledImage props numComps] = PreProcessImage(testImage, con, edgeAlg, prop);

[horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage );

%Vanishing Point Detections
HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);