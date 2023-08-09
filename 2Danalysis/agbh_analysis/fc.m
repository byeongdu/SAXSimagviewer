tic
[xdim, ydim] = size(a);
x = 1:size(a,2);
peak = [];
step = 25;
for i=1:step:size(a,1)
    dt = a(i,:);
    if sum(dt)>0
    t = fpeak(x, dt, 40);
    peak = [peak;[t(:,1), ones(size(t(:,1)))*i, t(:,2)]];
    end
end
k = find(peak(:,3)>100);
peak = peak(k, :);
peak(:,3) = [];





p = [];
allpeak = peak;
p{1} = peak(1,:);peak(1,:) = [];
while ~isempty(peak)
    removep = [];    
    for i=1:numel(peak(:,1))
        pd = peak(i,:);
        tt = [];isPartofP = 0;
        for j=1:numel(p)
            t = p{j};
            d = sqrt((t(:,1)-pd(1)).^2+(t(:,2)-pd(2)).^2);
            tt = find((d >=step) & (d < 3*step));
            if ~isempty(tt)
                p{j} = [t;pd];
                removep = [removep, i];
                isPartofP = 1;
            end
        end
        if isPartofP == 0
            p{j+1} = pd;
            removep = [removep, i];
        end
    end
    peak(removep,:) = [];
end

nump = [];
for i=1:numel(p)
    nump(i) = numel(p{i});
end
[~, ind] = max(nump);
dp = p{ind};
[xc,yc] = circfit(dp(:,1), dp(:,2));
fprintf('First Guess: xc = %0.2f, yc = %0.2f\n', xc, yc);


R = sqrt((dp(:,1)-xc).^2+(dp(:,2)-yc).^2);
stdR = std(R);
stdN = -100;
while 1
    numofoutlier = fix(numel(R)*0.05);
    if numofoutlier ~= 0
        index = outlier2(R, 1, numofoutlier);
        dp(index,:) = [];
    end
    R = sqrt((dp(:,1)-xc).^2+(dp(:,2)-yc).^2);
    nstdR = std(R);
    if nstdR > stdR
        break
    end
    if (nstdR>0.9*stdR) && (nstdR <= stdR)
        break
    end
    stdR = nstdR;
    [xc,yc] = circfit(dp(:,1), dp(:,2));
    fprintf('Refining xc = %0.2f, yc = %0.2f, std of R = %0.2f\n', xc, yc, stdR);
end
stdR = nstdR;

allR = sqrt((allpeak(:,1)-xc).^2+(allpeak(:,2)-yc).^2);
%[n,x]=hist(allR,fix(max(allR)/2));
[n,x]=hist(allR,fix(max(allR)/step));
%n(n<10) = 0;
m = fpeak(x,n, 10);

figure;
xv = 1:numel(m)/2;
%plot(xv, m(:,1), 'ro');hold on;
eqn = polyfit(xv, m(1:end,1)', 1);
%plot(xv, eqn(1)*xv+eqn(2), 'b');
orderof1stPeak = round(eqn(2)/eqn(1));
if orderof1stPeak < 0
    m(1:abs(orderof1stPeak), :) = [];
    xv = 1:numel(m)/2;
    eqn = polyfit(xv, m(1:end,1)', 1);
end
plot(xv, m(:,1), 'ro');hold on;
%eqn = polyfit(xv, m(1:end,1)', 1);
plot(xv, eqn(1)*xv+eqn(2), 'b');
orderof1stPeak = round(eqn(2)/eqn(1))+1;

fprintf('The first peak is %i order peak\n', orderof1stPeak);

%m = peakdet(n, 5, x);
peak = [];
mstep = diff(m(:,1));
meanmstep = mean(mstep);
if meanmstep < step
    error('meanmstep should be larger than step')
end
%Rrange = fix(meanmstep/10);
Rrange = 50*stdR;
if (Rrange < step/5) && (Rrange < meanmstep/10)
    Rrange = meanmstep/10;
end
xxc = []; yyc = [];ind = 1;
for i=1:numel(m(:,1))
    minR = m(i,1)-Rrange;
    maxR = m(i,1)+Rrange;
    indx = find((allR>=minR)&(allR<=maxR));
    peak{i} = allpeak(indx, :);
    if numel(peak{i})>0
        [xxc(ind),yyc(ind),Rd(ind)] = circfit(peak{i}(:,1), peak{i}(:,2));  
        ind = ind+1;
    end
end
xc = mean(xxc); yc = mean(yyc);
fprintf('Finally, xc = %0.2f, yc = %0.2f\n', xc, yc);
toc