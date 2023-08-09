function [LabelNewPosition, TickP] = TickScaleCal(AllLabel, AllNewLabel, limPixel, numberTick, stepIn)
% making Tick!!!!!!!!!
% May 27, 2004.
% AllLabel : current axis all label : all pixel values, ex 1:1:200 (when size of one axis is 200)
% AllNewLabel : new current axis label : if you want to change pixel to q, then, this means q values(it should be same size vector)
% limPixel : lim of current image or plot as pixel values, you can get it such as, limPixel = get(findobj(gcf, 'Type', 'axes'), 'XLim');
% numberTick : number of Tick you want to draw...

limPixel = fix(limPixel);
if limPixel(1) < AllLabel(1)
    limPixel(1) = limPixel(1) + 1;
end
if limPixel(2) > AllLabel(end)
    limPixel(2) = limPixel(2) - 1;
end
limPixel;
limOri = AllNewLabel(limPixel);
MaxLim = AllNewLabel;

if limOri(2) < limOri(1)
    lim = [limOri(2), limOri(1)];
else
    lim = limOri;
end

step = (lim(2) - lim(1))/numberTick;

% ============================ Step selection
% ============================= which is like...25 or 0.0015
if step > 1
    stepP = 0;i=-1;
    while stepP ~= 1
        i=i+1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step/5)*5, ceil(step/5-1)*5];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
    if stepP == 0
        stepP = 1;
    end
else
    stepP = 1;i=1;
    while stepP == 1
        i=i-1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step*10^(-i)/5)*5*10^i, ceil((step*10^(-i))/5-1)*5*10^i];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
end
% =================================================================
if ~isempty(stepIn)
    stepP = stepIn;
end

% ============================= closest starting point selection
t = [1, 2];j=0;
while t(1) ~= t(2)
    t = [floor((fix(lim(1)*10^(1-i))+j)/5), ceil((fix(lim(1)*10^(1-i))+j)/5)];
    j=j+1;
end    
stP = t(1)*5*10^(i-1);
% ===============================================================

% ================================================  Tick generation
% ================================================= always Reference point is 0
if stepP > 0
    TickP = 0:-stepP:MaxLim(1);
    TickP = [fliplr(TickP), stepP:stepP:MaxLim(end)];
else
    TickP = 0:stepP:MaxLim(1);
    TickP = [fliplr(TickP), stepP:-stepP:MaxLim(end)];
end    
%if limOri(2) < limOri(1)
%    TickP = stP:stepP:lim(2);
%    TickP = fliplr(TickP);
%else
%    TickP = stP:stepP:max(lim);

%end

LabelNewPosition = spline(AllNewLabel, AllLabel, TickP);
LabelNewPosition = fix(LabelNewPosition);