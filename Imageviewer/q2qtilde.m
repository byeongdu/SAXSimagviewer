function qtilde = q2qtilde(q, saxs, RorT)
% qtilde = q2qtilde(q, saxs, RorT)
% Not used anywhere.
% INPUT:
%   q is an apparent value
%   qtilde is a refraction corrected.
% needed...
% saxs.edensity
% saxs.beta
% saxs.ai
% saxs.waveln
Waveln = saxs.waveln;
beta = saxs.beta;
eDensity = saxs.edensity;
ai = saxs.ai * pi/180;

k0 = 2*pi/Waveln;
r0 = 2.82E-5;

n = 1-1/(2*pi)*r0*Waveln^2*eDensity + j*beta;

if nargin<3
    RorT = 'r';
else
    RorT = lower(RorT);
end

switch RorT
    case 'r'
        qtilde = real(2*k0*(sqrt(n.^2 -1 + (Waveln*q/4/pi + sin(ai)).^2) - sqrt(n.^2-cos(ai).^2)));
    case 't'
        qtilde = real(2*k0*(sqrt(n.^2 -1 + (Waveln*q/4/pi - sin(ai)).^2) + sqrt(n.^2-cos(ai).^2)));
    otherwise
        disp('third input should be either r or t')
end