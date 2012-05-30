function [H V] = VPDetection(lines, bwImage)

clusters = METODO_PEGAR_CLUSTERS();

[Hindirect Vindirect] = PEGAR_VP_METODO_DIRETO();

[Hdirect Vdirect] = VPDetectionIndirect(clusters, lines, bwImage);

H = 0.5 * Hindirect + 0.5 * Hdirect;
V = 0.5 * Vindirect + 0.5 * Vdirect;


end

