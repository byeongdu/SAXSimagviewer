function visualcylinder(R, L, Dsp, angle)

% ======================== circle
xo = -1:0.01:1;xo=xo*R;
yo = sqrt(R^2-xo.^2);yo=[yo;-yo];
xo=[xo;xo];
zo=0*xo;
zo2=zo+L;
% ======================== cylinder
[ao, bo, co] = cylinder(R, 50);co(2, :) = co(2, :)*L;

a1vector = [Dsp, 1/sqrt(3)*Dsp, 0];
a2vector = [0, 2/sqrt(3)*Dsp, 0];
Cdirection = [0 0 1];

minz = 0;maxx = 0;minx = 0;maxy = 0;miny = 0;

figure
hold on

% ======================== Hexagonal
for i=1:7
    switch i
        case 1
            x = xo; y = yo; z = zo; z2 = zo2;
            a = ao; b = bo; c=co;
        case 2
            x = xo; y = yo+2/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao; b = bo+2/sqrt(3)*Dsp; c=co;
        case 3
            x = xo; y = yo-2/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao; b = bo-2/sqrt(3)*Dsp; c=co;
        case 4
            x = xo+Dsp; y = yo+1/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao+Dsp; b = bo+1/sqrt(3)*Dsp; c=co;
        case 5
            x = xo-Dsp; y = yo+1/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao-Dsp; b = bo+1/sqrt(3)*Dsp; c=co;
        case 6
            x = xo+Dsp; y = yo-1/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao+Dsp; b = bo-1/sqrt(3)*Dsp; c=co;
        case 7
            x = xo-Dsp; y = yo-1/sqrt(3)*Dsp; z = zo; z2 = zo2;
            a = ao-Dsp; b = bo-1/sqrt(3)*Dsp; c=co;
        otherwise
            disp('Oh!!! no!!')
    end
xr = reshape(x, 1, prod(size(x)));yr = reshape(y, 1, prod(size(y)));
zr = reshape(z, 1, prod(size(z)));zr2 = reshape(z2, 1, prod(size(z2)));
n1 = [xr;yr;zr];n2 = [xr;yr;zr2];
%n1 = eulerrot(n1, angle);n2 = eulerrot(n2, angle);
n1 = rotatevector(angle(1), angle(2), n1)';n2 = rotatevector(angle(1), angle(2), n2)';
x1 = n1(1, :);x1 = reshape(x1, 2, prod(size(n1))/6);
x2 = n2(1, :);x2 = reshape(x2, 2, prod(size(n1))/6);
y1 = n1(2, :);y1 = reshape(y1, 2, prod(size(n1))/6);
y2 = n2(2, :);y2 = reshape(y2, 2, prod(size(n1))/6);
z1 = n1(3, :);z1 = reshape(z1, 2, prod(size(n1))/6);
z2 = n2(3, :);z2 = reshape(z2, 2, prod(size(n1))/6);

ar = reshape(a, 1, prod(size(a)));br = reshape(b, 1, prod(size(b)));cr = reshape(c, 1, prod(size(c)));
nc = [ar;br;cr];
%nc = eulerrot(nc, angle);
nc = rotatevector(angle(1), angle(2), nc)';

a = nc(1, :);a = reshape(a, 2, prod(size(nc))/6);
b = nc(2, :);b = reshape(b, 2, prod(size(nc))/6);
c = nc(3, :);c = reshape(c, 2, prod(size(nc))/6);

minz = [minz, min(min(z1)), min(min(z2)), min(min(c))];minz = min(minz);
maxx = [maxx, max(max(x1)), max(max(x2)), max(max(a))];maxx = max(maxx);
minx = [minx, min(min(x1)), min(min(x2)), min(min(a))];minx = min(minx);
maxy = [maxy, max(max(y1)), max(max(y2)), max(max(b))];maxx = max(maxy);
miny = [miny, min(min(y1)), min(min(y2)), min(min(b))];minx = min(miny);
%z1 = z1-minz;   z2 = z2- minz;   c = c-minz;
% ======================================
surf(x1, y1, z1, 'edgecolor', 'g', 'facecolor', 'g', 'facelighting','phong')
surf(x2, y2, z2, 'edgecolor', 'g', 'facecolor', 'g', 'facelighting','phong')
surf(a, b, c, 'edgecolor', 'g', 'facecolor', 'g', 'facelighting','phong')
end

% =========================== substrate draw.......
minz = min(minz);
maxx = max(maxx);
minx = min(minx);
maxy = max(maxy);
miny = min(miny);

x = [minx maxx;
    minx maxx];
y = [miny miny;
    maxy maxy];
z = [minz minz;
    minz minz];
surf(x, y, z, 'edgecolor', 'r', 'facecolor', 'r', 'facelighting','phong')

xlabel('X axis ; Beam direction','fontsize', 12)
ylabel('Y axis','fontsize', 12)
title(['Angle of cylinder to the Z axis is  ', num2str(angle)]);

axis tight;axis square;
view(-50,30)

axis vis3d
h = camlight('left');
for i = 1:20;
    camorbit(10,0)
    camlight(h,'left')
    drawnow;
end