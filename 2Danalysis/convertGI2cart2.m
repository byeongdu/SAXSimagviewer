function [img, qxy, qz] = convertGI2cart2(imgin, saxs)
% function [img, qxy, qz] = convertGI2cart2(imgin, saxs)
% convert GIWAXS(or GISAXS) image of 2D fiber into q space.
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
%[ang, pixN] = pixel2angle2([X,Y], BC, SDD, psize, tiltangle);
Pixel = bsxfun(@minus, [X,Y], BC);
[tthf, af, pixN] = pixel2angles(Pixel, SDD, psize, tiltangle);
ang = [tthf(:), af(:)];



tth = ang(:,1); af = ang(:,2)-ai;
[qx, qy, qz] = angle2vq2(ai, af, 0, tth, wl);
qxy = sign(qy).*sqrt(qx.^2+qy.^2);
%qzm = reshape(qz, sizeImg);
%indqz0 = find(abs(qzm(:,1))==min(abs(qzm(:,1))));
%qzax = qz
%Notpossible = abs(qxy)<=qz;
expFactor = 2;

min_qxy = min(qxy);min_qxy = min_qxy(1);
max_qxy = max(qxy);max_qxy = max_qxy(1);
min_qz = min(qz);min_qz = min_qz(1);
max_qz = max(qz);max_qz = max_qz(1);
del_q = (max_qxy-min_qxy)/sizeImg(2)*expFactor;
del_qxy = del_q; del_qz = del_q;
%del_qz = (max_qz-min_qz)/sizeImg(1)*expFactor;
% To make the resolution of both qxy and qz the same, only now define del_q
% instead of del_qxy and del_qz;

qxy = round((qxy-min_qxy)/del_qxy); % make it an integer matrix
qz = round((qz-min_qz)/del_qz);
Xt = (qxy<1) | (qxy>sizeImg(2));qxy(Xt) = 1;
Yt = (qz<1) | (qz>sizeImg(1));qz(Yt) = 1;

img = zeros(size(imgin));
%% solid angle correction (q convertion)
% the following code is from convertCart2q(imgin, saxs)
pixN = pixN * psize;
P = sqrt(pixN(:,2).^2+pixN(:,2).^2+(pixN(:,1)+SDD).^2);% distance between sample and a pixel.
psizeX = psize;psizeY = psize;
area = P.^3/SDD/psizeX/psizeY;
area = area/(SDD^2/psizeX/psizeY);
imgin = imgin.*reshape(area, sizeImg);
%% This method works fast, but cannot deal with interpolation.
ind = sub2ind(size(imgin), qz, qxy);
img(ind) = imgin(:);

%% 
% img = interpolate2d(double(imgin), qz, qxy);

qxy(Xt) = NaN;
qz(Yt) = NaN;
img(Xt) = NaN;
img(Yt) = NaN;
img = reshape(img, size(imgin));
% prepare image according to the expansion factor.
qxy = min_qxy:del_qxy:max_qxy; qxy = qxy + 1/2*del_qxy;
qz = min_qz:del_qz:max_qz; qz = qz + 1/2* del_qz;
X = 1:(numel(qxy));
Y = 1:(numel(qz));
img = img(Y, X);
