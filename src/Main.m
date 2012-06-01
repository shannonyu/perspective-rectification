%% Clear all

clc;
clear all;
close all;

addpath('./util');

disp('Limpando memória..');


%% Attributes
dirImage = '..\base\Selected\';
output = 'C:\dev\perspective\svn\src\temp\';
debug = 0;
con = 8;
saveImages = 1;
edgeAlg = 'canny';
prop1 = 'BoundingBox'; 
prop2 = 'Eccentricity';
scale = 0.25;

%% Flow
disp(['Configuração de execução corrente:']);
disp(['Diretorio de imagens: '  dirImage]);
disp(['Diretorio de saída: '  output]);
disp(['Debug mode: '  int2str(debug)]);
disp(['Conectividade: '  int2str(con)]);
disp(['Salvar Imagens: '  int2str(saveImages)]);
disp(['Algoritmo de Detecção de Bordas: '  edgeAlg]);
disp(['Propriedade 1: '  prop1]);
disp(['Propriedade 2: '  prop2]);
disp(['Escala para down-sample: ' num2str(scale)]);
disp([' ']);
disp(['Lendo imagens de ' dirImage]);

tifffiles = dir([dirImage '/*.JPG']);

len = length(tifffiles);

disp(['Achou ' int2str(len) ' imagens']);

for k = 1:len

disp(' ');
disp(['Iniciando processamento de ' tifffiles(k).name '...']);
 
filename = [dirImage '/' tifffiles(k).name];
%filename = [dirImage '\IMG_1257.JPG'];

% Preprocessamento
disp(['Iniciando Preprocessamento']);
[rgbImage rgbImageOriginalSize grayImage bwImage bwImageOriginalSize edgeImage labelledImage props numComps] = PreProcessImage(filename, con, edgeAlg, prop1, prop2, scale);
disp(['Preprocessamento ok']);

% Debug
if debug == 1
    subplot(2,2,1), imshow(grayImage);
    subplot(2,2,2), imshow(bwImage);
    subplot(2,2,3), imshow(edgeImage);
end

% First Stage
disp(['Iniciando Detecção de Linhas retas']);
[horizontalLines verticalLines newEdgeImage lines linesImage] = StraightLineDetection( labelledImage, props, numComps, grayImage, bwImage, edgeImage);
qtd = length(lines);
disp(['Detecção ok: ' int2str(qtd) ' linhas encontradas']);
if saveImages 
    disp(['Salvando Imagens:']);
    
    out0 = regexprep([output tifffiles(k).name], '.JPG', '_l.tif') ;
    out1 = regexprep([output tifffiles(k).name], '.JPG', '_bw.tif') ;
    out2 = regexprep([output tifffiles(k).name], '.JPG', '_g.JPG') ;

    imwrite(linesImage, out0, 'tif');
    disp([out0 ' ok']);
    imwrite(newEdgeImage, out1, 'tif');
    disp([out1 ' ok']);
    imwrite(grayImage, out2,'jpg');
    disp([out2 ' ok']);
end

% Descomentar para salvar as variáveis e dá o load dentro da função para economizar tempo
% save workspaceWorkspace.mat

%Vanishing Point Detection
[Hx Hy Vx Vy] = VPDetection(lines, bwImage, edgeImage);
%save workspaceWorkspace.mat

if ~isempty(Hx) && ~isempty(Hy)
    [transformedImage transformedImageRGB croppedImageRGB] = TransformImage(Hx, Hy, Vx, Vy, bwImage, bwImageOriginalSize, rgbImage, scale);

    if(~isempty(croppedImageRGB))
        disp(['Salvando Saída:']);
%         out3 = regexprep([output tifffiles(k).name], '.JPG', '_t.tif') ;
%         imwrite(transformedImage, out3,'tif');

        out4 = regexprep([output tifffiles(k).name], '.JPG', '_rgb.tif') ;
        imwrite(croppedImageRGB, out4,'jpg');

        disp([out2 ' ok']);
    else
        disp(['VPs inválidos']);
    end
else
     disp(['Não achou VP']);
end

%Second Stage
%HorizontalTextLineDetection(LabelledImage, Props, numComps, GrayImage, verticalLines);
end