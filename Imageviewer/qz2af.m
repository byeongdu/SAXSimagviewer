function [af1, af2, tth1, tth2] = qz2af(qz, qp, ai, edensity, beta, Waveln)
% When a given q*z and q*xy value of a peak qhkl is given, this code 1)
% first correct the refraction and 2) find position of a peak on the Ewald
% sphere.
% [af1, af2, tth1, tth2] = qz2af(qz, qp, ai, edensity, beta, Waveln)
% qz convert to af;
% see qhkl2pixel_tiltdetector

afe1 = [];
afe2 = [];
r0 = 2.82E-5;

ac = criticalang(edensity, Waveln);
ai = deg2rad(ai);
ac = deg2rad(ac);
k0 = 2*pi/Waveln;

% q2z to af
d1 = 1/(2*pi)*r0*Waveln^2*edensity;
nx = 1-d1; %+j*beta;
%nx = real(nx);
kiterm2 = (qz/k0 + real(sqrt(nx^2 - cos(ai).^2)));
cos_af2 = real(sqrt(nx.^2 - kiterm2.^2));
%af2 = rad2deg(acos(cos_af2));
t = kiterm2 > 0;
af2(t) = rad2deg(acos(cos_af2(t)));
af2(~t) = -rad2deg(acos(cos_af2(~t)));
af2 = reshape(af2, size(cos_af2));
% q1z to af
kiterm1 = (qz/k0 - real(sqrt(nx^2 - cos(ai).^2)));
cos_af1 = real(sqrt(nx.^2 - kiterm1.^2));
af1 = cos_af1;
t = kiterm1 > 0;
af1(t) = rad2deg(acos(cos_af1(t)));
af1(~t) = -rad2deg(acos(cos_af1(~t)));
%af1 = asin(sqrt((qz/k0+sqrt(sin(ai).^2 - sin(ac).^2)).^2 - sin(ac)^2))*180/pi;
%af2 = asin(sqrt((qz/k0-sqrt(sin(ai).^2 - sin(ac).^2)).^2 + sin(ac)^2))*180/pi;
tth1 = sign(qp).*rad2deg(real(acos((cos(ai).^2 + cos(deg2rad(af1)).^2 - (qp/k0).^2)./(2*cos(deg2rad(af1)).*cos(ai)))));
tth2 = sign(qp).*rad2deg(real(acos((cos(ai).^2 + cos(deg2rad(af2)).^2 - (qp/k0).^2)./(2*cos(deg2rad(af2)).*cos(ai)))));