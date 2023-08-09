function P = correctfactor_polarization(ang, dp)
%function f = correctfactor_polarization(ang, deg_polarization)
% X of Detector is assumed to be parallel to the polarization direction.
% In synchrotron, mostly X-ray is polarized horizontally.
% in this case, P = 1-cos(alpha)^2*sin(2theta)^2
% In syncrotron, degree of polarization is about 98%.
if nargin < 2
    dp = 0.98;
end
Ph = 1-cos(ang(:,2)*pi/180).^2.*sin(ang(:,1)*pi/180).^2;
Pv = cos(ang(:,2)*pi/180).^2;
P = dp*Ph+(1-dp)*Pv;