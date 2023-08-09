function y = testCT(particle, cut, varargin)
% y = [chi2, y] = gf_LMA(particle, cut, varargin)
%
%Written by Byeongdu Lee
if nargin<2
    y = [];
    return
end
if strcmp(particle.Fq.name, 'none')
    yfq = 1;
else
    yfq = feval(particle.Fq.name, particle.Fq.param, cut, varargin);
end
if strcmp(particle.Sq.name, 'none')
    ysq = 1;
else
    ysq = feval(particle.Sq.name, particle.Sq.param, cut, varargin);
end
y = 1*ysq(:);

% Calculate optical parameters
%[Ti, Tf, Ri, Rf, kiz, kfz, ai, af, tthi, tthf, qx, qy, qp, qz, D] = gf_modelefield(md, cut, n);