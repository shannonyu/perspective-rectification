function [ x0 xf y0 yf width height bwComponent grayComponent edgeComponent] = GetBoundingBox( props, comp, bwImage, grayImage, edgeImage)

if nargin > 1
    x0 = props(comp).BoundingBox(1) + 0.5;
    y0 = props(comp).BoundingBox(2) + 0.5;
    width = props(comp).BoundingBox(3) - 1;
    height = props(comp).BoundingBox(4) - 1;
    xf = x0 + width;
    yf = y0 + height;
end

if(nargin > 2)
    bwComponent = bwImage(y0:yf, x0:xf);
end

if(nargin > 3)
    grayComponent = grayImage(y0:yf, x0:xf);
end

if(nargin > 4)
    edgeComponent = edgeImage(y0:yf, x0:xf);
end

end

