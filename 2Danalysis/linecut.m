function [R, xn, yn, cut] = linecut(img, pnt, tiltang, mode, gisaxs)
% [R, xn, yn, cut] = linecut(img, pnt, tiltang, mode, gisaxs)
% gisaxs should have
% .tiltang and .waveln

if nargin < 4
%[xn, yn] = rot(pnt(1), pnt(2), tiltang);
%[xn, yn] = fitlineonGraph(xn, yn, xmin, ymin, xmax, ymax);
    if numel(pnt) == 2
        %[R, xn, yn] = lineplot3(img, pnt, tiltang, 1);
        [R, xn, yn] = lineplot3(img, pnt, tiltang, 1);
    else
        xn = pnt(:,1);
        yn = pnt(:,2);
        R = interp2(img, xn(:), yn(:));
    end   
        cut.X = xn;
        cut.Y = yn;
        %xn = xn - pnt(1);
        %yn = yn - pnt(2);
    return
end

gisaxs.tiltang = tiltang;

t = size(img);
switch lower(mode)
    case {'h', 'horizontal'}
        [R, xn, yn, cut] = linecut(img, pnt, tiltang);
    case {'v', 'vertical'}
        [R, xn, yn, cut] = linecut(img, pnt, tiltang+90);
    case {'f', 'freehand'}
    otherwise
end
[tthf, af, xp, yp] = giangle(xn, yn, gisaxs);
if ~isfield(gisaxs, 'ai')
    gisaxs.ai = 0;
end
if ~isfield(gisaxs, 'tthi')
    gisaxs.tthi = 0;
end
if ~isfield(gisaxs, 'waveln')
    gisaxs.waveln = 1;
end
ai = gisaxs.ai;
tthi = gisaxs.tthi;
lambda = gisaxs.waveln;
[qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2, q3, q4] = giangle2q(tthf, af, tthi, ai, gisaxs);

%dist = sqrt((xn-center(1)).^2 + (yn-center(2)).^2);
%mininx = find(dist == min(dist));

cut.X = xn;   % pixel value in image
cut.Y = yn;                 % pixel vaule in image
cut.Xpixel = xp;   % pixel value in image
cut.Ypixel = yp;                 % pixel vaule in image
cut.Waveln = gisaxs.waveln;
%cut.Eden = str2num(get(handles.ed_nR, 'string'));
%cut.Beta = str2num(get(handles.ed_nI, 'string'));
cut.LCx = pnt(1);          % line cut position
cut.LCy = pnt(2);              % line cut position
cut.tthf = tthf;
cut.af = af;
cut.qxy = sign(tthf).*qxy;
cut.qxya = qxy;
cut.q1z = real(q1z);
cut.q2z = real(q2z);
cut.Intensity = R;


function [C, h] = linecut_obsolete(xx, yy, h)
% linecut from image
% input xx and yy should be the same scale with the image figure
% h should be handle of axis(gca) otherwise, h will be h = gca;
if nargin < 3
    h = gca;
end
dd = get(findobj(gca, 'Type', 'image'), 'cdata');
xd = get(findobj(gca, 'Type', 'image'), 'xdata');
yd = get(findobj(gca, 'Type', 'image'), 'ydata');
%xx(find(xx > max(xd))) = [];
%xx(find(xx < min(xd))) = [];
%yy(find(yy > max(yd))) = [];
%yy(find(yy < min(yd))) = [];

xl = length(xd);
xn = 1:xl;
xp = interp1(xd, xn, xx);

yl = length(yd);
yn = 1:yl;
yp = interp1(yd, yn, yy);
C = improfile(dd,xp,yp, length(xp), 'bicubic');
hold on
h = line(xx, yy);