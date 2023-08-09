function [q, Iq] = azimavg(img, qmap, qarray, SF, thmap, thrange, mask)
% function azimavg(img, qmap, qarray, SF, thmap, thrange, mask)
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
qmap(goodpix == 0) = qarray(1)-1;
%[h, bin] = histc(qmap.*goodpix, qarray);
[h, bin] = histc(qmap, qarray);
%bin = bin.*goodpix;
t = bin == 0;
bin(t) = [];
img(t) = [];
c=accumarray(bin,img);
if numel(h)>numel(c)
    h(end) = [];
end
Iq = c./max(1, h);

dq = diff(qarray);
q = qarray(1:end-1) + dq;


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
c = c./max(1,h);
if numel(c) > numel(q)
    c(end) = [];
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
