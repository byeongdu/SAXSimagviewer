function f = HermansOrientationFactor(th, Iq, thrange)
% function HermansOrientationFactor(th, Iq)
% function HermansOrientationFactor(th, Iq, thrange)
% thrange = [th_start, th_end]
% th should be given as radian
th = th(:);
Iq = Iq(:);
if nargin>2
    t = (th >= thrange(1)) & (th <= thrange(2));
    th = th(t);
    Iq = Iq(t);
end
mean_sqr_cos = trapz(th, Iq.*cos(th).^2.*sin(th))/trapz(th, Iq.*sin(th));
f = (3*mean_sqr_cos-1)/2;
mean_sqr_cos = trapz(th, Iq.*cos(th).^2)/trapz(th, Iq);
f = (2*mean_sqr_cos-1);
%mean_sqr_sin = trapz(th, Iq.*sin(th).^2.*cos(th))/trapz(th, Iq.*cos(th));
%f = 1-3*mean_sqr_sin;