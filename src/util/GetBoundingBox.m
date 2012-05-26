function [ x0 xf y0 yf width height bwComponent grayComponent] = GetBoundingBox( props, comp, bwImage, grayImage)

if nargin > 1
    x0 = props(comp).BoundingBox(1) + 0.5;
    y0 = props(comp).BoundingBox(2) + 0.5;
    width = props(comp).BoundingBox(3);
    height = props(comp).BoundingBox(4);
    xf = x0 + width;
    yf = y0 + height;
end

if(nargin > 2)
    bwComponent = bwImage(x0:xf, y0:yf);
end

if(nargin > 3)
    grayComponent = grayImage(x0:xf, y0:yf);
end

end

