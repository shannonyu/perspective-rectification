%% Clear all
disp('Limpando memória');
clc;
clear all;
close all;

%% Import
addpath('./util');

%% Setup
dirImage = '..\base\imgs\';
imageExt = '/*.JPG';
output = './output/';
debugDirectory = './debug/';
debugMode = 2; % 0 - Disable 1 - Show Window Image 2 - Save Debug Images
con = 8;
edgeAlg = 'canny';
prop1 = 'BoundingBox'; 
prop2 = 'Eccentricity';
scale = 0.25;

disp('Configuração de execução corrente:');
disp(['Diretorio de imagens: '  dirImage]);
disp(['Extensão: '  imageExt]);
disp(['Diretorio de saída: '  output]);
disp(['Diretorio de debug: '  debugDirectory]);
disp(['Debug mode: '  int2str(debugMode)]);
disp(['Conectividade: '  int2str(con)]);
disp(['Algoritmo de Detecção de Bordas: '  edgeAlg]);
disp(['Propriedade 1: '  prop1]);
disp(['Propriedade 2: '  prop2]);
disp(['Escala para down-sample: ' num2str(scale)]);
disp(' ');
disp(['Lendo imagens de ' dirImage]);

imageFiles = dir([dirImage imageExt]);

len = length(imageFiles);

disp([int2str(len) ' imagens achadas']);

%% Flow
for it = 1:len

    close all;

    filename = [dirImage '/' imageFiles(it).name];

    disp(' ');
    name = imageFiles(it).name(1:end-4);
    disp(['Iteração ' int2str(it) '. Iniciando processamento de ' name ]);

%% PreProcess

    stat = 'PREPROC';
    disp(['[' stat ']' 'Iniciando preprocessamento']);
    [rgbImage grayImage bwImage edgeImage labelledImage props numComps] = PreProcessImage(filename, con, edgeAlg, prop1, prop2, scale);

    if debugMode > 0

        if debugMode == 1
            subplot(2,2,1), imshow(grayImage);
            subplot(2,2,2), imshow(bwImage);
            subplot(2,2,3), imshow(edgeImage);
        end

        if debugMode == 2
            preprocess_rgb = [debugDirectory name '_rgb.jpg'];
            preprocess_gray = [debugDirectory name '_gray.jpg'];
            preprocess_bw = [debugDirectory name '_bw.tif'];
            preprocess_edge = [debugDirectory name '_edge.tif'];

            imwrite(rgbImage, preprocess_rgb ,'jpg');
            imwrite(grayImage, preprocess_gray,'jpg');
            imwrite(bwImage, preprocess_bw,'tif');
            imwrite(edgeImage, preprocess_edge,'tif');

            disp(['[' stat ']' 'RGB:' preprocess_rgb]);
            disp(['[' stat ']' 'GRAY:' preprocess_gray]);
            disp(['[' stat ']' 'BW:' preprocess_bw]);
            disp(['[' stat ']' 'EDGE:' preprocess_edge]);
        end
    end
%% First Step - Detect Vanishing Points using Document Boundaries

    stat = 'VP DETECT 1ST';
    
    disp(['[' stat ']' 'Iniciando Detecção de Linhas retas']);
    [newEdgeImage lines linesImage] = StraightLineDetection( stat, labelledImage, props, numComps, grayImage, bwImage, edgeImage );
    disp(['[' stat ']' 'Detecção ok: ' int2str(length(lines)) ' linhas encontradas']);
    
     if debugMode > 0
        if debugMode == 1
            subplot(2,2,1), imshow(newEdgeImage);
            subplot(2,2,2), imshow(linesImage);
        end
          
        if debugMode == 2
            straight_lines_newEdgeImage = [debugDirectory name '_newedge.tif'];
            stright_lines_image = [debugDirectory name '_lines.tif'];
            
            imwrite(newEdgeImage, straight_lines_newEdgeImage,'tif');
            imwrite(linesImage, stright_lines_image,'tif');
        end
     end
    

%% Second Step - Not Implemented

%% Third Step - Not Implemented

%% VP Detection

[Hx Hy Vx Vy] = VPDetection(lines, bwImage, edgeImage);

%% Image Transform 

if ~isempty(Hx) && ~isempty(Hy)
    [transformedImage transformedImageRGB croppedImageRGB] = TransformImage(Hx, Hy, Vx, Vy, bwImage, bwImageOriginalSize, rgbImage, scale);

    if(~isempty(croppedImageRGB))
        disp(['Salvando Saída:']);
        out4 = regexprep([output tifffiles(k).name], '.JPG', '_rgb.tif') ;
        imwrite(croppedImageRGB, out4,'jpg');

        disp([out2 ' ok']);
    else
        disp(['VPs inválidos']);
    end
else
     disp(['Não achou VP']);
end
    
end