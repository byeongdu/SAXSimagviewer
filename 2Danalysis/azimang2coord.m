function [x, y] = azimang2coord(row, col, cent_X, cent_Y, azimangle)
% reprogrammed 6/30/2008
%dmax = floor(sqrt((row-cent_X).^2 + (col-cent_Y).^2));
%dmax = floor(sqrt((row).^2 + (col).^2));
dmax = round(sqrt((row).^2 + (col).^2));
azim = azimangle*pi/180;
x = zeros(dmax,1);
y = x;
for d=0:dmax
    x(d+1) = d*cos(azim)+cent_X;
    y(d+1) = d*sin(azim)+cent_Y;
    if ((x < 0) | (x>row))
        break
    end
    if ((x < 0) | (x>row))
        break
    end
end
x(d:end) = [];
y(d:end) = [];
return

obsolete_function azimang2coord
if ((azimangle>90)&&(azimangle<270))
    x=row:-1:1;
    x = x - cent_X;
    y=tan(azimangle*pi/180)*x;
    k=find(x>0);
    x(k)=[];y(k)=[];
elseif (azimangle==90)
    y = 0:1:(row-cent_Y-1);
    x = zeros(size(y));
elseif (azimangle==270)
    y = 0:-1:-(cent_Y-1);
    x = zeros(size(y));
else
    x = 1:row;
    x = x - cent_X;
    y=tan(azimangle*pi/180)*x;
    k=find(x<0);
    x(k)=[];y(k)=[];
end
x=x+cent_X;y=y+cent_Y;
t = find(y<0 | y>col);
x(t) = [];y(t)=[];
