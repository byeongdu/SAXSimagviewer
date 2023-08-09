function [ang, pixN] = det_geometry(saxs)
% when saxs is given,
% this generate image arrays of angles and 3D pixel coordinates.
% 3/5/2017
% Byeongdu Lee

psize = saxs.psize;
SDD = saxs.SDD;
BC = saxs.center;
tiltangle = saxs.tiltangle;
%imgin = saxs.image;

if numel(tiltangle)==1
    tiltangle = [0, 0, tiltangle];
end

sizeImg = saxs.imgsize;

y = 1:sizeImg(1);
x = 1:sizeImg(2);
[X, Y]= meshgrid(x,y);
X = X(:);Y=Y(:);
%[ang, pixN] = pixel2angle2([X,Y], BC, SDD, psize, tiltangle); rewritten as
%below, 3/31/2018. pixel2angle2 may not be correct.
Pixel = bsxfun(@minus, [X, Y], BC);
[tthf, af, pixN] = pixel2angles(Pixel, SDD, psize, tiltangle);
ang = [tthf(:), af(:)];
ang(:,3) = sqrt(ang(:,1).^2+ang(:,2).^2);
