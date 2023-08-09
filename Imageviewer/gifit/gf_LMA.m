function y = gf_LMA(particle, cut, varargin)
% y = [chi2, y] = gf_LMA(particle, cut, varargin)
%
%Written by Byeongdu Lee
if nargin ==0
    y=[];
    return;
end

if strcmp(particle.Fq.name, 'none')
    yfq = 1;
else
    yfq = feval(particle.Fq.name, cut, particle.Fq.param, varargin);
end

if strcmp(particle.Sq.name, 'none')
    ysq = 1;
else
    ysq = feval(particle.Sq.name, cut, particle.Sq.param, varargin);
end
y = yfq(:).*ysq(:);