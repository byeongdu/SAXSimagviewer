function [qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2, q3, q4] = giangle2q(tthf, af, tthi, ai, saxs, kiz, kfz)
% function [qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2, q3, q4] = giangle2q(tthf, af, tthi, ai, saxs, kiz, kfz)
% [qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2, q3, q4] = giangle2q(tthf, af,
% tthi, ai, waveln)
if ~isstruct(saxs)
    lambda = saxs;
    eDensity = 0;
    beta = 0;
else
    if isfield(saxs, 'edensity')
        eDensity = saxs.edensity;
    else
        disp('There is no edensity field in the input to giangle2q.m')
    end
    if isfield(saxs, 'waveln');
        lambda = saxs.waveln;
    else
        disp('There is no waveln field in the input to giangle2q.m')
    end
    if isfield(saxs, 'beta')
        beta = saxs.beta;
    else
        beta = 1E-9;
    end
end

if numel(ai) < numel(af)
    if numel(ai) ~= 1
        disp('numel of ai should be 1 in this case');
        return
    end
    ai = ai(1).*ones(size(af));
elseif numel(ai) > numel(af)
    if numel(af) ~= 1
        disp('numel of af should be 1 in this case');
        return
    end
    af = af(1).*ones(size(ai));
end
if numel(tthi) < numel(tthf)
    if numel(tthi) ~= 1
        disp('numel of tthi should be 1 in this case');
        return
    end
    tthi = tthi(1).*ones(size(tthf));
elseif numel(tthi) > numel(tthf)
    if numel(tthf) ~= 1
        disp('numel of af should be 1 in this case');
        return
    end
    tthf = tthf(1).*ones(size(tthi));
end
[q1z, q2z, qxy] = af2qz(af, ai, eDensity, 0, lambda, tthf);
q2z = -q2z;
if nargin > 5 % kiz and kfz are not provided...
    q1z = kfz - kiz;
    q2z = kfz + kiz;
end

q1=abs(sqrt(qxy.^2 + real(q1z).^2));
q2=abs(sqrt(qxy.^2 + real(q2z).^2));
q3z = -q2z; q3=abs(sqrt(qxy.^2 + real(q3z).^2));
q4z = -q1z; q4=abs(sqrt(qxy.^2 + real(q4z).^2));


ai = deg2rad(ai);
af = deg2rad(af);
tthi = deg2rad(tthi);
tthf = deg2rad(tthf);
k0 = 2*pi/lambda;
kfx = k0*cos(af).*cos(tthf);
kix = k0*cos(ai).*cos(tthi);
kfy = k0*(sin(tthf).*cos(af));
kiy = k0*cos(ai).*sin(tthi);
qx = kfx - kix;
qy = kfy - kiy;

%qxy = sign(qy).*sqrt(qx.^2+qy.^2);
%if nargin < 6 % kiz and kfz are not provided...
%    kiz = k0*sin(ai);
%    kfz = k0*sin(af);
%end

%q1z = kfz-kiz; q1=abs(sqrt(qxy.^2 + real(q1z).^2));
%q2z = -kfz-kiz; q2=abs(sqrt(qxy.^2 + real(q2z).^2));
%q3z = kfz+kiz; q3=abs(sqrt(qxy.^2 + real(q3z).^2));
%q4z = -kfz+kiz; q4=abs(sqrt(qxy.^2 + real(q4z).^2));