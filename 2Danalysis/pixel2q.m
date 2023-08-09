function [q, th, AreaFactor, ang] = pixel2q(varargin)
% [q, th] = pixel2q(pix, center, sdd, pixelsize, detector_tiltangle, lambda)
% [q, th] = pixel2q(pix, saxs)
% convert pixel(x, y) to q in polar coordinate (q, th)
% Byeongdu lee
% 2013/12/13

if numel(varargin) == 2
    pix = varargin{1};
    saxs = varargin{2};
    center = saxs.center;
    sdd = saxs.SDD;
    pixelsize = saxs.psize;
    detector_tiltangle = saxs.tiltangle;
    lambda = saxs.waveln;
else
    pix = varargin{1};
    center = varargin{2};
    sdd = varargin{3};
    pixelsize = varargin{4};
    detector_tiltangle = varargin{5};
    lambda = varargin{6};
end

%[ang, pixN] = pixel2angle2(pix, center, sdd, pixelsize, detector_tiltangle);
Pixel = bsxfun(@minus, pix, center);
[tthf, af, pixN] = pixel2angles(Pixel, sdd, pixelsize, detector_tiltangle);
ang = [tthf(:), af(:)];
Pixel = pixN2Pixel(pixN, sdd, pixelsize, detector_tiltangle);

R = angle2vect(repmat([1, 0, 0], length(pixN), 1), pixN);
q = angle2q(R*180/pi, lambda);
th = cart2pol(Pixel(:,1), Pixel(:,2));

if nargout > 2
% In case, det_angles are all 0
omegaref = 4*asin(sin(0.172/(2*2000))^2); % pixel size 0.172mm and sdd=2m.
if sum(detector_tiltangle.^2) ==0
    omega = 4*asin(sin(pixelsize/(2*sdd))^2);
    omegafactor = omegaref/omega;
    L0 = sdd/pixelsize;
    P = sqrt(Pixel(:,1).^2+Pixel(:,2).^2+L0^2);% distance between sample and a pixel.
    AreaFactor = omegafactor*P.^3/L0^3;
else
    if length(detector_tiltangle)==1
        pitch = 0;
        yaw = 0;
    else
        pitch = detector_tiltangle(1);
        yaw = detector_tiltangle(2);
%        roll = detector_tiltangle(3);
    end
    P = sqrt(sum(pixN.^2, 2));% distance between sample and a pixel.
    alpha = atan(pixelsize*cos(deg2rad(tthf+yaw))./(2*P*pixelsize));
    beta = atan(pixelsize*cos(deg2rad(af+pitch))./(2*P*pixelsize));
    omega = 4*asin(sin(alpha).*sin(beta));
    AreaFactor = omegaref./omega;
end
end
% When, det_angles are not 0.

%P = sqrt(pixN(:,2).^2+pixN(:,3).^2+pixN(:,1).^2);% distance between sample and a pixel.
% psizeX = pixelsize;psizeY = pixelsize;
% area = P.^3/sdd/psizeX/psizeY;
% AreaFactor = area/(sdd^2/psizeX/psizeY); % multiply the AreaFactor to I(q) for solid angle correction.

%AreaFactor = reshape(AreaFactor, size(pix));
%[th, R] = cart2pol(ang(:,1), ang(:,2));


