function [R, x, y, handleLine] = lineplot3(img, center, azimangle, step, draw)
% R = lineplot3(img, center, azimangle, step, endposition)
handleLine = [];
[row, col] = size(img);
cent_Y = center(2);
cent_X = center(1);

[x_, y_] = azimang2coord(row, col, cent_X, cent_Y, azimangle);
[x2_, y2_] = azimang2coord(row, col, cent_X, cent_Y, azimangle+180);

x2_(1) = [];
y2_(1) = [];
%x = [x_; flipud(x2_)];
%y = [y_; flipud(y2_)];
x = [flipud(x2_); x_];
y = [flipud(y2_); y_];
%[x, y] = fitlineonGraph(x_, y_, 1, 1, row, col, 1);
%d_max = length(x)-1

%R = zeros(d_max, 2);

%global x y img
R = interp2(double(img), double(x), double(y));

tx = find(x < 1 | x > col);
x(tx) = [];y(tx) = [];R(tx) = [];
ty = find(y < 1 | y > row);
x(ty) = [];y(ty) = [];R(ty) = [];


if nargin > 4 
   figure(draw);hold on
   handleLine = line(x, y);
end