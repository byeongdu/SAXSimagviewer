function [tthf, af] = q_powder2angles(q, wl)
% For a given modulus q, this function generate a powder ring with
% polar angle coordinates(tth, af)
% See also q_powder2qv.m
% Return Radian angles.

k0 = 2*pi/wl;
% kfx = k0*cos(af).*cos(tthf);
% kix = k0;
% kfy = k0*(sin(tthf).*cos(af));
% kiy = 0;
% qx = kfx - kix;
% qy = kfy - kiy;
% kiz = k0*sin(ai); ai = 0
% kfz = k0*sin(af);

% qy = kfy
% qz = kfz

% qx calculation
qv = q_powder2qv(q);
qy = qv(:,2);
qz = qv(:,3);
af = asin(qz/k0);
% sin(tthf) = qy/k0/cos(af)
tthf = asin(qy/k0./cos(af));
