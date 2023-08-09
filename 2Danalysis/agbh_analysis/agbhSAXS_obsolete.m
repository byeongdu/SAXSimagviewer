function [center, pixeldistance] = agbhSAXS(img)
% When a good guess is provided..
%[iniy, inix] = ginput(1);
%imgfilename = 'Sagbh_003_001.tif';
LowerCntLimit = 250;
UpperCntLimit = 500;

%a = imread(imgfilename);
a = img;
a = double(a);
%tic
[xdim, ydim] = size(a);
if xdim==1679
    a = a(1:800, :);
    xdim = 800;
end
findcircle
if isempty(ress)
    LowerCntLimit = LowerCntLimit/3;
    UpperCntLimit = UpperCntLimit/3;
    findcircle
end

x = mod(t, xdim);
y = (t-x)/xdim + 1;
peak = [x, y];
R = sqrt((peak(:,1)-inix).^2 + (peak(:,2)-iniy).^2);

[n,x]=hist(R,fix(max(R)));
m = fpeak(x,n, 20);
m(m(:,2) < 50, :) = [];
%n(n<50) = 0;
%m = fpeak(x,n, 40);
Rpop = m(end, 1);
indx = find(x==Rpop);
indp = indx;
indm = indx;
peakindex = find(m(:,2)==max(m(:,2)));
possibleR = m(peakindex, 1);
while 1
    indp = indp + 1;
    if indp > numel(n)
        indp = indp - 1;
        break
    end
    if n(indp) == 0
        break
    end
    if (indp-indx > 200)
        disp('Move the lower discriminator up 1')
        break
    end
end
while 1
    indm = indm - 1;
    if n(indm) == 0
        break
    end
    if (indx-indm > 200)
        disp('Move the lower discriminator up 2')
        break
    end
end
ind = find((R>x(indm)) & (R<x(indp)));
pn = peak(ind, :);
[xc,yc] = circfit(pn(:,1), pn(:,2));
fprintf('First Guess: xc = %0.2f, yc = %0.2f\n', (iniy), (inix));
fprintf('First Fit: xc = %0.2f, yc = %0.2f, R=%0.2f\n', (yc), (xc), possibleR);
%toc

% horizontal.
BeamstopRadius = 30;
ang = [0, 180];
Xpos = [];    
figure;%subplot(1,2,1)

for i=1:numel(ang)
    [R, Iq, xp, yp] = radialcut(a, [yc,xc], ang(i));
    indexout = R>possibleR*1.2;
    R(indexout) = [];
    Iq(indexout) = [];
    
    Iq = Iq.*R(:).^2;
    maxIq = max(Iq);
    k = find(Iq < maxIq*0.10);
    Iq(k) = []; R(k) = [];
    
    m = fpeak(R, Iq, 10);
    m(m(:,1) < BeamstopRadius, :) = [];

    meanm = mean(m(:,2));
    m(m(:,2)<meanm, :) = [];
    % check whether peak is on nonactive area or not
    inornot = [];
    for l=1:numel(m(:,1))
        if Pilatus2mMask(m(l,1)+yc, [])
            inornot = [inornot; l];
        end
    end
    m(inornot, :) = [];
    % ============================================
    
    mx=1:numel(m(:,1));
    eqn = polyfit(mx(:), m(:,1), 1);
    kind = m(:,1) < eqn(1)*0.5;
    m(kind, :) = [];
    
    plot(R, Iq, 'b', m(:,1), m(:,2), 'ro'); hold on;
    title('Fit along the horizontal')
    ppos = [];
    ypos = [];
    for j=1:numel(m(:,1))
        f = ezfit(R, Iq, sprintf('y = a*exp(-1/2*(x-c)^2/b^2); a=%f; b=5; c=%f', m(j,2), m(j,1)));
        ppos = [ppos, f.m(3)];
        ypos = [ypos, f.m(1)];
    end
    Xpos{i} = ppos;
    Ypos{i} = ypos;
end

diffX = [];minXvalue = [];j=1;
for i=1:numel(Xpos{1})
    t1 = Xpos{1}(i);
    k = find((Xpos{2}>t1*0.9) & (Xpos{2}<t1*1.1));
    if numel(k)>1
        yk = Ypos{2}(k);
        maxyk = find(yk==max(yk));
        k = k(maxyk);
    end
    if ~isempty(k)
        t2 = Xpos{2}(k);
        diffX(j) = t1-t2;
        minXvalue(j) = mean([t1,t2]);
        j = j + 1;
    end
end
yc = yc + mean(diffX)/2;

if numel(minXvalue)>1
    if rem(round(minXvalue(2)/minXvalue(1)*10)/10,1) == 0
        p1st = minXvalue(1);
    end
end


% Vertical.
if xc < 1000 % When beam is in the middle of detector.
    ang = 90; 
else        % When beam is at the bottom of detector.
    ang = 270;
end

[R, Iq, xp, yp] = radialcut(a, [yc,xc], ang);
    indexout = R>possibleR*1.2;
    R(indexout) = [];
    Iq(indexout) = [];

Iq = Iq.*R(:).^2;
maxIq = max(Iq);
k = find(Iq < maxIq*0.10);
Iq(k) = []; R(k) = [];
m = fpeak(R, Iq, 10);
m(m(:,1) < BeamstopRadius, :) = [];
m(m(:,1) < min(minXvalue)*0.9, :) = [];
    meanm = mean(m(:,2));
    m(m(:,2)<meanm, :) = [];

% check whether peak is on nonactive area or not
inornot = [];
for l=1:numel(m(:,1))
    if Pilatus2mMask([], m(l,1)+xc)
        inornot = [inornot; l];
    end
end
if ~isempty(inornot)
    disp('Peak is on nonactive area')
end
m(inornot, :) = [];

% ===============================================

mx=1:numel(m(:,1));
%eqn = polyfit(mx(:), m(:,1), 1);
%kind = m(:,1) < eqn(1)*0.5;
%m(kind, :) = [];
    
%plot(R, Iq, 'b', m(:,1), m(:,2), 'ro')
ppos = [];
for j=1:numel(m(:,1))
    f = ezfit(R, Iq, sprintf('y = a*exp(-1/2*(x-c)^2/b^2); a=%f; b=5; c=%f', m(j,2), m(j,1)));
    ppos = [ppos, f.m(3)];
end

Yval = [];
for i=1:numel(minXvalue)
    k = find((ppos>minXvalue(i)*0.9) & (ppos<minXvalue(i)*1.1));
    if isempty(k)
       Yval(i) = NaN;
    else
        Yval(i) = ppos(k);
    end
end
Ymeandiff = nanmean(Yval - minXvalue);
xc = xc + Ymeandiff;
ppos = ppos - Ymeandiff;
relPos = ppos/minXvalue(1);
res = 1000;
str = [];
for i=1:numel(relPos);
    str = sprintf('%s, %0.3f', str, round(relPos(i)*res)/res);
end
fprintf('Relative peak positions along the vertical direction: %s\n', str);

center = [xc, yc];
pixeldistance = ppos(1);
fprintf('Refining xc = %0.2f, yc = %0.2f, 1st peak at %0.2f\n', yc, xc, pixeldistance);

function findcircle
    b=ones(size(a));
    b(a<LowerCntLimit) = 0; b(a>=UpperCntLimit) = 0;
    t = find(b==1);

    test = t;
    while 1
        if numel(test)<1
            disp('change high and low limit')
            break
        end
        pn = maskfindpeak(b, test(1),10);
        if numel(pn) > 2000
            x = mod(pn, xdim);
            y = (pn-x)/xdim + 1;
            p = [x, y];
            [inix,iniy] = circfit(p(:,1), p(:,2));
            break
        end
        test = setdiff(test, pn);
    end
    ress=test;
end



end
