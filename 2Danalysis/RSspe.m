function R = RSspe(data)
% this program for the contrast change to make bright image.

R = [];
[sizeX, sizeY] = size(data);
[I, J] = find(data == max(max(data)));
[I2,J2]= find(data == min(min(data)));

maxI = data(I(1),J(1));
minI = data(I2(1),J2(1));

p95 = (maxI-minI)*0.65 + minI;
p05 = (maxI-minI)*0.0 + minI;

X = find(data > p95);
Y = find(data < p05);
data = reshape(data, sizeX*sizeY, 1);

data(X) = fix(p95);
data(Y) = fix(minI);

data = reshape(data, sizeX, sizeY);
data = data - minI;

D = mat2gray(data);
imshow(D)
R = data;