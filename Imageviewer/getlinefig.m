function [xdata, ydata, zdata] = getlinefig(fig)
% function [xdata, ydata, zdata] = getlinefig(fig)
% get line data from the figure
% zdata is Userdata set on the line
% fig : figure handle
% this is only for the result 1-d patterns of 'imganalysis.m'
% and all the lines displayed on fig should have same format of Userdata
x = get(findobj(fig, 'Tag', 'data'), 'xdata'); % imganalysis make Tag of 1-d line as 'data'
y = get(findobj(fig, 'Tag', 'data'), 'ydata');
if isempty(x) ~= 1
    linePr = get(findobj(fig, 'Tag', 'data'), 'Userdata');
    dimx = prod(size(x));
    if iscell(x)
            for i=1:dimx
                        xdata(:, i) = x{i}';
                        ydata(:, i) = y{i}';
                         zdata(i) = linePr{i};
            end
    else
            xdata = x';
            ydata = y';
            zdata = linePr;
    end
else
    xdata = get(findobj(gcf, 'type', 'line'), 'XData');
    ydata = get(findobj(gcf, 'type', 'line'), 'YData');
    zdata = [];
end
    