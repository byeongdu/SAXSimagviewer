function [xn, yn] = fitlineonGraph(xn, yn, xmin, ymin, xmax, ymax, newline)

%A = (yn(end)-yn(1))/(xn(end)-xn(1));
%A = 1/A;


%tx = (xn(end)+xn(1))/2;
%ty = (yn(end)+yn(1))/2;
xnstep = (xn(end)-xn(1))/(numel(xn)-1);
ynstep = (yn(end)-yn(1))/(numel(yn)-1);

if (ynstep == 0)
    x0 = xmin;
    x3 = xmax;
    xn = x0:1:x3;
    yn = yn(1)*ones(size(xn));
    return
end

if (xnstep == 0)
    y0 = ymin;
    y3 = ymax;
    yn = y0:1:y3;
    xn = xn(1)*ones(size(yn));
    return
end

res = polyfit(xn, yn, 1);
A = res(1); y0=res(2);
y0;
y3 = A*xmax + y0;

if (A > 0)
    if y0 < ymin
        x0 = (ymin-y0)/A;
    else
        x0 = xmin;
    end

%    ym = A*xmax + y0;
    
    if y3 < ymax
        x3 = xmax;
    else
        x3 = (ymax - y0)/A;
    end
elseif (A < 0)
    if y0 < ymax
        x0 = xmin;
    else
        x0 = (ymin - y0)/A;
    end
    if y3 > ymin
        x3 = xmax;
    else
        x3 = (ymin - y0)/A;
    end
end

if nargin > 6
    xn = linspace(x0, x3, xmax-xmin+1)
else
    xn = x0:xnstep:x3;
end
    yn = A*xn+y0;