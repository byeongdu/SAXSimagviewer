function [phi, th] = qv2azim_phi(qv, varargin)
% convert q vector into phi and azim angle th.
if numel(varargin)==1
    saxs = varargin{1};
    psize = saxs.psize;
    wl = saxs.waveln;
    sdd = saxs.SDD;
    detangle = [0, 0, 0];
else
    wl = varargin{1};
    sdd = varargin{2};
    psize = varargin{3};
    detangle = varargin{4};
end
[pixN, phi, pixN2, phi2] = qv2pixel(qv, wl, sdd, psize, detangle);
% th = cart2pol(pixN(:,2), pixN(:,3));
% th2 = cart2pol(pixN2(:,2), pixN2(:,3));
th = azimang(pixN(:,2), pixN(:,3));
th2 = azimang(pixN2(:,2), pixN2(:,3));
t = phi < 0;
phi(t) = phi2(t);
th(t) = th2(t);
t = phi2 < 0;
phi2(t) = phi(t);
th2(t) = th(t);
[phi, ind] = min([phi(:), phi2(:)], [], 2);
%th0 = [th(:), th2(:)];
t = ind == 2;
th(t) = th2(t);
%th = th0(:,ind);
th = rad2deg(th);