function [q, Iq, c, npixel, qc] = azimavg(img, qmap, qarray, SF, thmap, thrange, mask, intrange)
% function azimavg(img, qmap, qarray, SF, thmap, thrange, mask, cutoff_intensity_low_high_limit)
% azimuthal averaging with qmap, thmap and SF(solid angle correction
% factor), these can be obtained from pixel2q.m
% cutoff_intensity_low_high_limit : cut off intensity reange; [low limit, high limit];
%
% example:
%   azimavg(img, qmap, qarray, SF)
%   azimavg(img, qmap, qarray, SF, thmap, [pi/3, pi/2])
%   azimavg(img, qmap, qarray, SF, thmap, [pi/3, pi/2], mask, [0, 1000])
%
% Byeongdu Lee
% 12/14/2014
if nargin < 5
    thmap = [];
end
if nargin < 6
    thrange = [];
end
if nargin < 7
    mask = [];
end
if nargin < 8
    intrange = [];
end


qmap = qmap(:);
qarray = qarray(:);
if isempty(SF)
    SF = ones(size(qmap));
end
if ~isempty(mask)
    mask = mask(:);
end

img = img(:);

if ~isempty(intrange)
    t = img > intrange(2);
    mask(t) = 0;
    t = img < intrange(1);
    mask(t) = 0;
end

img = img.*SF(:);

goodpix = ones(size(img));
% masking...
if ~isempty(mask)
    goodpix = goodpix & (mask == 1);
end

% sector averaing..
if ~isempty(thrange)
    binth = zeros(size(goodpix));
    for k=1:size(thrange)
        [~, binth0] = histc(thmap, thrange(k, :));
        binth = binth0(:)==1 | binth;
    end
else
    binth = [];
end
if ~isempty(binth)
    goodpix = goodpix & (binth==1);
end
w = find(goodpix == 1);
% averaging..
qmap(goodpix == 0) = qarray(1)-1;
%[h, bin] = histc(qmap.*goodpix, qarray);
[h, bin] = histc(qmap, qarray);
%bin = bin.*goodpix;
t = bin == 0;
bin(t) = [];
img(t) = [];
qmap(t) = [];


c = accumarray(bin,img);
qc = accumarray(bin,qmap);
Ngooddata = numel(c);
if numel(h)>numel(c)
    c = [c(:);zeros(numel(h)-Ngooddata, 1)];
    qc = [qc(:);zeros(numel(h)-Ngooddata, 1)];
end
%npixel = max(1, h(:));
npixel = h(:);
Iq = c(:)./npixel;
qc = qc(:)./npixel;
Iq(end) = [];
c(end) = [];
qc(end) = [];
dq = diff(qarray);
q = qarray(1:end-1) + dq/2;

return

%% old 
binarray = unique(bin);
binmin = binarray(1);
binmax = binarray(end);
if binmin ==0
    binmin = 1;
    w = w & (bin ~= 0);
end
qarray = qarray(binmin:binmax);
h = h(binmin:binmax);

dq = diff(qarray);
q = qarray(1:end-1) + dq;


% New addition =================
% qmap = qmap(w);
img = img(w);
t = bin == 0;
bin(t) = [];
%t = h == 0;
%h(t) = [];
c=accumarray(bin,img);
if binmin > 0
    c(1:binmin-1) = [];
end
if numel(h)>numel(c)
    h(end) = [];
end
sumIq = c;
c = c./max(1,h);
t = h == 0;
c(t) = nan;

if numel(c) > numel(q)
    c(end) = [];
    sumIq(end) = [];
end
Iq = c;
%qv = qv./max(1,h);
%Iq = interp1(qv, Iqv, q);
% =====================================

% Old code.============================
% h2 = cumsum(h);lastv = find(h2==h2(end));
% if numel(lastv)>1
%     h(lastv(2:end)) = [];
% end
% c=accumarray(bin+1,img(w));
% qv=accumarray(bin+1,qmap(w)); % q values in a bin will also be averaged.. 
%     % If not, agbh peak positions may vary with q array size.
% qv(1) = [];
% c(1) = [];
% t = qv == 0; qv(t) = [];c(t) = [];h(t) = [];
% if numel(c)==numel(h)
%     Iqv = c./max(1,h);
%     qv = qv./max(1,h);
% elseif numel(c)==(numel(h)-1)
%     Iqv = c./max(1,h(1:end-1));
%     qv = qv./max(1,h(1:end-1));
% elseif numel(c)<(numel(h)-1)
%     error('Use "Q based" instead of "Pixel based"');
% end
% Iq = interp1(qv, Iqv, q);
% ========================================
return


t = unique(bin);
if t(1) ==0; 
    t(1) = []; 
end
Iq(t) = c(t);
if numel(Iq)>(numel(h)-1)
    Iq(end) = [];
end
%, where c(1) is the sum of all out of ROI..
Iq=Iq./max(1,h(1:end-1));
