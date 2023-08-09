function [th, Iq] = azimavgazim(img, qmap, tharray, SF, thmap, qrange, mask)
% function azimavgazim(img, qmap, qarray, SF, thmap, thrange, mask)
% azimuthal averaging with qmap, thmap and SF(solid angle correction
% factor), these can be obtained from pixel2q.m
% 
% example:
%   azimavg(img, qmap, qarray, SF, [], [], [])
%   azimavg(img, qmap, qarray, SF, thmap, [pi/3, pi/2], [])
%   azimavg(img, qmap, qarray, SF, thmap, [pi/3, pi/2], mask)
%
% Byeongdu Lee
% 12/14/2014

if isempty(SF)
    SF = ones(size(qmap));
end
img = img(:).*SF(:);
if ~isempty(mask)
    mask = mask(:);
end

goodpix = ones(size(img));
% masking...
if ~isempty(mask)
    goodpix = goodpix & (mask == 1);
end

% sector averaing..
if ~isempty(qrange)
    [~, binq] = histc(qmap, qrange);
else
    binq = [];
end
if ~isempty(binq)
    goodpix = goodpix & (binq==1);
end
%w = find(goodpix == 1);
% % averaging..
thmap(goodpix == 0) = -1000;
% In thmap th is -pi<0<pi
% Therefore, th>pi should be converted.
t = tharray>pi; tharray(t) = tharray(t) - 2*pi;
tharray = tharray(:);
tharray = [tharray(t); tharray(~t)];

[h, bin] = histc(thmap, tharray);
%bin = bin.*goodpix;
t = bin == 0;
bin(t) = [];
img(t) = [];
c=accumarray(bin,img);
Ngooddata = numel(c);
if numel(h)>numel(c)
    c = [c(:);zeros(numel(h)-Ngooddata, 1)];
end
Iq = c(:)./max(1, h(:));
t = h == 0;
Iq(t) = nan;
Iq(end) = [];
dth = diff(tharray);
th = tharray(1:end-1) + dth;
