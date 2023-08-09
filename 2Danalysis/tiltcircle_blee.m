function err=tiltcircle_blee(x,calibrant)
%Function err=tiltcircle3(x,calibrant)
%
% when fitting with fminsearchcon(), at least four q values needed for
%  tilted image, otherwise, force the tilt/yaw angle in a relative narrow,
%  close to answer, range.
%
% Input Parameters:
%    x=[xc yc SSDrel yaw]
%    calibrant: struct data containing ring coordinates and corresponding q
%    values.
% 
% Example in using fminsearchcon() for minimization:
%   [xval, fval] = fminsearchcon(@(x)tiltcircle2(x,calibrant),x0,[0 0 600 -90],[2000 2000 inf 90]);
% the yaw angle can be narrowed from [-90 90] to [20 40], for instance.

% By Xiaobing Zuo, 3/2011

wavelength = calibrant.wavelength;
data = calibrant.data;

err=0.;
kMax=length(data);

for k=1:kMax
    q = data(k).q;
    xy=data(k).xy;
    %tg_2th_2 = (tan(2.*asin(q*wavelength/(4*pi))))^2;
    tg_2th = tan(2.*asin(q*wavelength/(4*pi)));
    xval=xy(1,:)'-x(1);
    yval=xy(2,:)'-x(2);
    y2 = real(sqrt((x(3)*tg_2th).^2-xval.^2));
    [nPx, delta_sdd] = detector_rotate([xval, y2], [x(4), 0, 0]);
    SDD = x(3)+delta_sdd;
    d0 = yval.*cos(x(4)*pi/180);
    %NewSDDratio = x(3) + delta_sdd;
    nd = y2/x(3).*SDD;
    err = sum((d0 - nd).^2);
    %err2 = (xval).^2 + (yval).^2 *(cos(x(4)*pi/180.))^2 - tg_2th_2*(x(3)+(yval)*sin(x(4)*pi/180.)).^2;
    %err = err + sum(err2.^2);
end    
%[ err x]