function mask = Pilatus2mBad
% mask = Pilatus2mBad
% pnt is a point by coordinate.
% If pnt is on a nonactive area, return 1 else 0.
% Example:
%   mask = Pilatus2mBad
%
mask = ones(1679, 1475);
[x, y] = ndgrid(1:1679, 1:1475);

Pilatus2m.Xactive = 195;
Pilatus2m.Xnonactive = 17;
Pilatus2m.Xnum = 7;
Pilatus2m.Xperiod = Pilatus2m.Xactive+Pilatus2m.Xnonactive;

Pilatus2m.Yactive = 485;
Pilatus2m.Ynonactive = 9;
Pilatus2m.Ynum = 2;
Pilatus2m.Yperiod = Pilatus2m.Yactive+Pilatus2m.Ynonactive;

X2i = -2;
X2ip = 98;
X2ib = 5;
X2iN = 2;

Y2i = -2;
Y2ip = 61;
Y2ib = 3;
Y2iN = 7;

for i=1:Pilatus2m.Xnum+1
    x0 = Pilatus2m.Xperiod*(i-1) + Pilatus2m.Xactive+1;
    x1 = Pilatus2m.Xperiod*i;
    mask((x>=x0) & (x<=x1)) = 0;
    xi = x0 - Pilatus2m.Xactive-1;
    for j=1:X2iN+1
        x0 = xi + X2ip*(j-1)+X2i;
        x1 = x0+X2ib-1;
        mask((x>=x0) & (x<=x1)) = 0;
    end
end

for i=1:Pilatus2m.Ynum+1
    y0 = Pilatus2m.Yperiod*(i-1) + Pilatus2m.Yactive+1;
    y1 = Pilatus2m.Yperiod*i-1;
    mask((y>=y0) & (y<=y1)) = 0;
    yi = y0 - Pilatus2m.Yactive;
    for j=1:Y2iN+1
        y2 = yi + Y2ip*(j-1)+Y2i;
        y3 = y2+Y2ib-1;
        mask((y>=y2) & (y<=y3)) = 0;
    end
end