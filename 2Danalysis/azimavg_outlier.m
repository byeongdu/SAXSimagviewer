function [q, Iq, goodpix, sumIq] = azimavg_outlier(img, qmap, qarray, SF, thmap, thrange, mask, method)
% function [q, Iq, goodpix, sumIq] = azimavg_outlier(img, qmap, qarray, SF, thmap, thrange, mask, method)
% idential to azimavg.m except that this code reject the outlier.
% A pixel will be considered as an outlier if its intensity is higher than
% mean+std*3 of pixels associated to the same q.
% sumIq is the integrated intensity but not normalized by the number of
% pixels.
%
% Return: goodpix is the updated mask excluding the outlier pixels..
%
% example:
%   azimavg_outlier(img, qmap, qarray, SF, [], [], [])
%   azimavg_outlier(img, qmap, qarray, SF, thmap, [pi/3, pi/2], [])
%   azimavg_outlier(img, qmap, qarray, SF, thmap, [pi/3, pi/2], mask)
%
% Byeongdu Lee
% 3/14/2015

dq = diff(qarray);
q = qarray(1:end-1) + dq;

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
if ~isempty(thrange)
    [~, binth] = histc(thmap, thrange);
else
    binth = [];
end
if ~isempty(binth)
    goodpix = goodpix & (binth==1);
end
w = find(goodpix == 1);
% averaging..
[h, bin] = histc(qmap, qarray);
iq = zeros(max(bin), 1);
qv = zeros(max(bin), 1);
sumIq = iq;
%dt = img(w);
%bin(~w) = [];
dt = img;

minbin=min(bin);if minbin<1; minbin = 1;end
k = [];cnt = 1;
for i=minbin:max(bin)
    bindx = (bin==i) & goodpix;
    t = dt(bindx);t_indx = find(bindx == 1); % read values of goodpixels in the bin.
    qt = qmap(bindx);
    mean_t = nanmean(t);
    std_t = nanstd(t);
%     if numel(qt) > 0
%     if qt(1) > 0.032
%         qt(1)
%     end
%     end
    k = [];
    switch method
        case 1
            k = find(t>(mean_t+std_t*3)); % find upper outlier
        case 2
            k = find((t>(mean_t+std_t*3)) | (t<(mean_t-std_t*3))); % find both up and down outlier
        case 3
            k = find(t<(mean_t-std_t*3));
        case 4
            k = find(t<(mean_t-std_t));
        case 5
            k = find(t<(mean_t+std_t));
    end
    outlierindx = t_indx(k);
    goodpix(outlierindx) = 0; % put the outlier into mask. update the mask.
    h(i) = h(i) - numel(outlierindx); 
    %cnt = cnt+1;
    %tmp = t;tmp(k) = [];
    %t2 = t;
    %t2(k) = mean(tmp);
    t(k) = [];qt(k) = [];
    iq(i) = mean(t);
    qv(i) = mean(qt);
    sumIq(i) = sum(t);
end
    
%Iq = zeros(numel(qarray)-1, 1);
%c=accumarray(bin+1,img(w));
c = iq;
%qv=accumarray(bin+1,qmap(w)); % q values in a bin will also be averaged.. 
    % If not, agbh peak positions may vary with q array size.
%qv(1) = [];
% c(1) is the data out of the range.
%c(1) = [];
t = isnan(iq);qv(t) = []; iq(t) = []; sumIq(t) = [];
t = isnan(qv);qv(t) = []; iq(t) = []; sumIq(t) = [];
t = qv == 0;  qv(t) = []; iq(t) = []; sumIq(t) = [];
% if numel(c)==numel(h)
%     Iqv = c./max(1,h);
%     qv = qv./max(1,h);
% elseif numel(c)==(numel(h)-1)
%     Iqv = c./max(1,h(1:end-1));
%     qv = qv./max(1,h(1:end-1));
% end
Iq = interp1(qv, iq, q);
if nargout > 3
    sumIq = interp1(qv, sumIq, q);
end
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
