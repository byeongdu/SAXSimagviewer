function [img, area, saxs] = convertCart2q(imgin, saxs)
% [img, area, saxs] = convertCart2q(imgin, saxs)
% Convert 2D image generated from convertGI2cart.m into q
% by simply using q = 4*pi/lambda * sin(angle/2).
% It also do the solid angle correction.
psize = saxs.psize;
if numel(psize)==1
    psizeX = psize;
    psizeY = psize;
else
    psizeX = psize(1);
    psizeY = psize(2);
end

%ai = saxs.ai*pi/180; % incident angle in radian.
SDD = saxs.SDD;
BC = saxs.center;
waveln = saxs.waveln;
sizeImg=size(imgin);
imgin = double(imgin);
%img = zeros(size(imgin));
y = 1:sizeImg(1);
x = 1:sizeImg(2);
x = x-BC(1);
y = y-BC(2);

%x = x*saxs.pxQ;
%y = y*saxs.pxQ;
saxs.qp = x*saxs.pxQ;
saxs.qz = y*saxs.pxQ;
[x, y]= meshgrid(x,y);
saxs.tth = atan(sqrt(psizeX^2*x.^2+psizeY^2*y.^2)/SDD);

x = x*saxs.pxQ;
y = y*saxs.pxQ;

%q = sqrt(x.^2+y.^2);
    %pix = asin(qp/4/pi*waveln)*2*180/pi; % need to calculate 2theta.
    %piy = asin(qz/4/pi*waveln)*2*180/pi; % need to calculate 2theta.
%    [th,q] = cart2pol(qp,qz);
    %ang = q2angle([q, th], waveln, 1);
angle = asin(x*waveln/4/pi)*2;
pix = tan(angle)*SDD/psizeX;
angle = asin(y*waveln/4/pi)*2;
piy = tan(angle)*SDD/psizeY;
P = sqrt(pix.^2+piy.^2+SDD^2);% distance between sample and a pixel.
area = P.^3/SDD/psizeX/psizeY;
area = area/(SDD^2/psizeX/psizeY);
pix = pix + BC(1);
piy = piy + BC(2);
img = interp2d(double(imgin), piy, pix);
%img = interpolate2d(double(imgin), piy, pix);
img = reshape(img, size(imgin));
img = img.*area;