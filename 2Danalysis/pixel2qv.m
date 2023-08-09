function [q, AreaFactor] = pixel2qv(varargin)
% [q, AreaFactor] = pixel2qv(pix, center, sdd, pixelsize, detector_tiltangle, ai, tthi, saxs)
% When tthi is not 0, detector is assumed to be perpendicular to (ki_x,
% ki_y, ki_z projection on to xy plan). Thus if a_i =0, detector is
% perpendicular to the k_i vector.
% 
% convert pixel(x, y) to q vector (q.x, q.y, q.z1, q.z2, q.z3, q.z4)
% Byeongdu lee
% 2013/12/13
saxs = [];
if numel(varargin) == 2
    pix = varargin{1};
    saxs = varargin{2};
    center = saxs.center;
    sdd = saxs.SDD;
    pixelsize = saxs.psize;
    detector_tiltangle = saxs.tiltangle;
%    lambda = saxs.waveln;
    ai = saxs.ai;
    tthi = saxs.tthi;
else
    pix = varargin{1};
    center = varargin{2};
    sdd = varargin{3};
    pixelsize = varargin{4};
    detector_tiltangle = varargin{5};
    ai = varargin{6};
    tthi = varargin{7};
end
if numel(varargin) == 8
    saxs = varargin{8};
end

%[ang, pixN] = pixel2angle2(pix, center, sdd, pixelsize, detector_tiltangle);
Pixel = bsxfun(@minus, pix, center);
[tthf, af, pixN] = pixel2angles(Pixel, sdd, pixelsize, detector_tiltangle);
ang = [tthf(:), af(:)];

P = sqrt(pixN(:,2).^2+pixN(:,3).^2+pixN(:,1).^2);% distance between sample and a pixel.
psizeX = pixelsize;psizeY = pixelsize;
area = P.^3/sdd/psizeX/psizeY;
AreaFactor = area/(sdd^2/psizeX/psizeY); % multiply the AreaFactor to I(q) for solid angle correction.

tthf = ang(:,1) + tthi;
af = ang(:,2) - ai;
if ~isfield(saxs, 'edensity')
    saxs.edensity = 0;
end
if ~isfield(saxs, 'beta')
    saxs.beta = 0;
end

[qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2] = giangle2q(tthf, af, tthi, ai, saxs);
q.qx = qx;
q.qy = qy;
q.qz = q1z;
q.q_x = qx;
q.q_y = qy;
q.q_z = q1z;

q.qxy = qxy;
q.q1z = q1z;
q.q2z = q2z;
q.q3z = q3z;
q.q4z = q4z;
q.qt = q1;
q.qr = q2;