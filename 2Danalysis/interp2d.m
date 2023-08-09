function ret = interp2d(img, x, y)
% function ret = interp2d(img, x, y)
% x is a column number and y is a row number.
if numel(x) ~= numel(y)
    error('number of the elements of x and y should be the same')
end

img = double(img);
[X, Y] = meshgrid(1:size(img,2), 1:size(img, 1));

ret = interp2(X, Y, img, x, y);