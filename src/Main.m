%% Clear all

clc;
clear all;
close all;

%% Attributes

testImage = '..\base\iPhone4\IMG_1255.JPG';
debug = 1;
con = 8;
edgeAlg = 'canny';
prop = 'BoundingBox';
scale = 0.5;

%% Flow

% Preprocessamento
[rgbImage grayImage bwImage labelledImage props numComps] = PreProcessImage(testImage, con, edgeAlg, prop, scale);

% Descomentar para salvar as variáveis e dá o load dentro da função para economizar tempo
%save workspaceWorkspace.mat

% Debug
if debug == 1
    subplot(1,2,1), imshow(grayImage);
    subplot(1,2,2), imshow(bwImage);
end

% First Stage
[horizontalLines verticalLines] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage );

%Vanishing Point Detections

%Second Stage
HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);