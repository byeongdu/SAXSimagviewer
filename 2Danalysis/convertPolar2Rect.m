function [img, qn, ang] = convertPolar2Rect(imgin, saxs)
% function img = convertPolar2Rect(imgin, saxs)
% convert SAXS image, from polar to cartesian coordinate.
% Once you convert, plot the image as
%   imagesc(qxy, qz, img, [0,1000]); axis image; axis xy
% For samples whose c* is parallel to Z (rotation axis for 2D powder)
%   You can determine a, b and gamma using Indexing.m
%   Here set the structure triclinic and c = 0.001, alpha = 90, beta = 90.
%   because the inplane (h,k) position is only a function of a, b and gamma
%   It draw the qz projection lines of hkl peaks so that hk<l>. <l> means
%   the integration of l values.
% c can be obtained if there is a layer peak along the c* (or Z) axis
%   for instance c = 2*pi/qz*; qz* is the first order peak position along
%   the qz axis.
% Now, determine alpha and beta so that you can fit the all the peaks.
%% Convert a DETECTOR image measured with Tilted Geometry into qxy vs qz
psize = saxs.psize;
SDD = saxs.SDD;
BC = saxs.center;
ai = saxs.ai; % incident angle in radian.
tiltangle = saxs.tiltangle;
wl = saxs.waveln;
if numel(tiltangle)==1
    tiltangle = [0, 0, tiltangle];
end

sizeImg=size(imgin);
imgin = double(imgin);

y = 1:sizeImg(1);
x = 1:sizeImg(2);
[X, Y]= meshgrid(x,y);
X = X(:);Y=Y(:);
[q, ang] = pixel2q([X,Y], saxs);
qn = 0.001:saxs.pxQ/2:max(q)/2;
ang = 0:0.1:360;
[Q, azim] = meshgrid(qn, ang);
nc = [Q(:), zeros(size(Q(:))), azim(:)];
pxel = q2pixel(nc, wl, BC, psize, SDD, tiltangle);
t = pxel(:,1) <= 1 | pxel(:,2) <= 1;
pxel(t, 1) = 1;
pxel(t, 2) = 1;
t = pxel(:,1) >= max(x) | pxel(:,2) >= max(y);
pxel(t, 1) = 1;
pxel(t, 2) = 1;
%img = interp2(Y, X, imgin, pxel(:,2), pxel(:,1));
img = interp2d(imgin, pxel(:,1), pxel(:,2));
%img = imgin(round(pxel(:,1)), round(pxel(:,2)));
img(t, :) = NaN;
img = reshape(img, numel(ang), numel(qn));