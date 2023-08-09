function [q, th, Iq, px, py] = linecut_polar(img, ang, saxs)
% linecut for a polar coordination system.
% linecut.m is for the 2d fiber symmetry.
if isfield(saxs, 'tiltangle')
    ang = ang + saxs.tiltangle(end);
end
p = 0:10000;

px = p*cos(ang*pi/180);
py = p*sin(ang*pi/180);
px = px + saxs.center(1);
py = py + saxs.center(2);
imgsize = size(img);
k = (px<1) | (px> imgsize(2));
px(k) = [];
py(k) = [];
k = (py<1) | (py> imgsize(1));
px(k) = [];
py(k) = [];
Iq = interp2(img, px, py);
[q, th, AreaFactor] = pixel2q([px(:), py(:)], saxs);

Iq = Iq(:);
q = q(:);
th = th(:);
AreaFactor = AreaFactor(:);
Iq = Iq./AreaFactor;

