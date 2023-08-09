function [q1z, q2z, qxy] = af2qz(af, ai, eDensity, beta, Waveln, tth)
% function [q1z, q2z, qxy] = af2qz(af, ai, eDensity, beta, waveln, tth)
% geometry to q
% beta : complex part of refractive index
% if you input tth value, it will calculate qxy

k0 = 2*pi/Waveln;
r0 = 2.82E-5;
%t = find(af <=0);

if nargin > 5
    kix = k0.*(cos(deg2rad(ai))); 
    kiy = k0.*(deg2rad(0)); % incidence tth = 0
    kfx = k0.*(cos(deg2rad(tth)).*cos(deg2rad(af)));
    kfy = k0.*(sin(deg2rad(tth)).*cos(deg2rad(af)));
    qx = kfx-kix;
    qy = kfy-kiy;
    qxy = sqrt(qx.^2 + qy.^2);
end
n = length(eDensity);
nx = 1-1/(2*pi)*r0*Waveln^2*eDensity;% + j*beta;
if n == 1
    %ki = k0*sqrt(sin(deg2rad(ai)).^2-2*(1-real(nx))+2*j*imag(nx))
    ki = k0*real(sqrt(nx.^2 - cos(deg2rad(ai)).^2));
    %kf = k0*sqrt(sin(deg2rad(af)).^2-2*(1-real(nx))+2*j*imag(nx));
    kf = k0*sqrt(nx.^2 - cos(deg2rad(af)).^2);
    kf = sign(af).*kf;
elseif n > 1
    z = [-100 0];
    [xx, yy] = size(af);
    if xx < yy;
        af = af';
        ai = ai';
    end
    n = n-1;
    [Ria, Tia, ki] = dwbaxr_old(ai, nx,  z, n, Waveln);ki = -ki;   %because, incident beam will go down
    [Rfa, Tfa, kf] = dwbaxr_old(af, nx,  z, n, Waveln);%kfz = kfz;
end
q = k0*(sin(deg2rad(ai)) + sin(deg2rad(af)));
q1z = kf+ki;
q2z = kf-ki;
%q1z(t) = 0;
%q2z(t) = 0;