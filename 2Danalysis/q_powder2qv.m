function qv = q_powder2qv(q, wl, phi)
% qv = q_powder2qv(q, wl, phi)
% phi should be degree.
% For a given modulus q, this function generate a powder ring with
% polar angle coordinates(tth, af)
% See also q_powder2angles.m
k0 = 2*pi/wl;
q = q(:);
% if numel(q) > 1
%     q = q(1);
% end
if nargin<3
    phi = linspace(0, 359, 360);
else
    phi = phi(:);
end
phi = phi*pi/180;
% qx calculation
% % q = 2*k0*sin(tthf/2)
% afmax = 2*asin(q/(2*k0));
% qx = k0 - k0*cos(afmax);

% qx calculation.
% Let's think of a q vector a(qx, 0, qz).
% Distance from [-k0, 0, 0] to a should be k0.
% Distance from [0, 0, 0] to a should be q.
% From this we obtained the relation below:
qx = -q.^2/(2*k0);
%qx = -cos(pi/2-afmax)*q;
%afmax = q2angle(q, wl)/2;
%qx = k0*cos(afmax*pi/180).*cos(0)-k0;
qp = sqrt(q.^2-qx.^2);
if (numel(qp) > 1)
    [qy, qz] = pol2pixel(phi, qp);
    %qy = sin(phi*pi/180).*qp;
    %qz = cos(phi*pi/180).*qp;
    qv = [qx(:), qy(:), qz(:)];
else
    %[qy, qz] = pol2cart(phi*pi/180, qp);
    [qy, qz] = pol2pixel(phi, qp);
    qv = [qx.*ones(length(phi), 1), qy(:), qz(:)];
end
