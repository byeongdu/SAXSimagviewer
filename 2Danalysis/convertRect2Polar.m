function img = convertRect2Polar(imgin)
% function img = convertPolar2Rect(imgin, saxs)
% convert cartesian coordinate image (th x r) into polar coordinate image.
% X axis of the input image should represent azimuthal angle th.
% Y axis of the input image should represent radial component.
% then, this program produce an circular output image.
%% 
angN = size(imgin, 2);
deltaTH = angN/360;
rmax = size(imgin,1);
%r = 1:rmax;
x = linspace(-rmax, rmax, 2*rmax+1);
y = x;
[x0, y0] = meshgrid(x, y);
%center = [rmax+1, rmax+1];
%[q, ang] = pixel2q([x0(:),y0(:)], center, sdd, pixelsize, detector_tiltangle, lambda));
%x0 = x0 - center(1);
%y0 = y0 - center(2);
[TH,R] = cart2pol(x0,y0);
X = (TH(:)+pi)*180/pi*deltaTH;
img = interp2d(imgin, X(:), R(:));
t = R(:)>rmax;
img(t) = nan;
img = reshape(img, size(x0));