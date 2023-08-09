function changeimgTickLabel(currentFig, XNewAxis, YNewAxis, XnumberTick, YnumberTick, xStep, yStep)
% this is for change tick lables of image as thos of new axis;
% changeimgTickLabel(currentFig, XNewAxis, YNewAxis, XnumberTick, YnumberTick)
if nargin < 6
    xStep = [];
    yStep = [];
end

xLim = get(findobj(currentFig, 'Type', 'axes'), 'XLim');
yLim = get(findobj(currentFig, 'Type', 'axes'), 'YLim');
[tx, ty] = size(get(findobj(currentFig, 'type', 'image'), 'cdata'));
if (length(XNewAxis) ~= tx) & (length(XNewAxis) == ty)
    temp = tx;
    tx = ty;
    ty = temp;
end
tx = 1:tx;
ty = 1:ty;
[xTick, xTickLabel] = TickScaleCal(tx, XNewAxis, xLim, XnumberTick, xStep);
[yTick, yTickLabel] = TickScaleCal(ty, YNewAxis, yLim, YnumberTick, yStep);
set(findobj(currentFig, 'Type', 'axes'), 'XTick', xTick);
set(findobj(currentFig, 'Type', 'axes'), 'XTickLabel', xTickLabel);
set(findobj(currentFig, 'Type', 'axes'), 'YTick', yTick);
set(findobj(currentFig, 'Type', 'axes'), 'YTickLabel', yTickLabel);