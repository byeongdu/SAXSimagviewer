function visualFCC(R, b1, b2, b3)
% hexagonal ABC
figure
hold on
if nargin < 2
    b1=[1 1 1];
    b2 = [-1 2 -1];
    b3 = [1 0 -1];
end
%visualsphere(R, [1/2 1/2 1/2], 'k');
t = fccoperation2(0);
[a,b,c,mat] = cubicorient(b1, b2, b3);
t = t*mat';
lent =round(sqrt(t(:,2).^2+t(:,3).^2)*100);
vect = t;
vect(find(lent == max(lent)), :) = [];
lent =round(sqrt(vect(:,2).^2+vect(:,3).^2)*100);
vect(find(lent == 0), :) = [];
%k = find(round(t(:,1)*100)/100 == round(t(5,1)*100)/100)
%t(k,1) = max(t(:,1))/3*2
k = find(round(t(:,1)*100)/100 == round(t(2,1)*100)/100);
%t(k,1) = max(t(:,1))/3
%t = [t;p;q];
for i=1:length(vect(:,1))
    vect(i,2:3)= vect(i,2:3)*[cos(pi+pi/6), -sin(pi+pi/6);sin(pi+pi/6), cos(pi+pi/6)]';
end

for x=1:1
for y=1:1
for z=1:1
    a=vect(:,1)*x;
    b=vect(:,2)*y;
    c=vect(:,3)*z;
    visualsphere(R, [a,b,c], 'r', 40);
%    visualsphere(R, [0, 0, 0], 'y');
%    visualsphere(R, b1, 'y');
%    visualsphere(R, b2, 'y');
%    visualsphere(R, b3, 'y');
%    visualsphere(R, b1+b2, 'y');
%    visualsphere(R, b1+b3, 'y');
%    visualsphere(R, b2+b3, 'y');
%    visualsphere(R, (b1+b2+b3), 'y');
%    visualsphere(R, 1/2*(b1+b2), 'y');
%    visualsphere(R, 1/2*(b1+b3), 'y');
%    visualsphere(R, 1/2*(b3+b2), 'y');
%    visualsphere(R, b1+1/2*(b2+b3), 'y');
%    visualsphere(R, b2+1/2*(b1+b3), 'y');
%    visualsphere(R, b3+1/2*(b1+b2), 'y');
end
end
end

p = t(k,:);p(:,1) = min(t(:,1));
q = t(k,:);q(:,1) = max(t(:,1));
p = [min(t(:,1)), 0, 0;p];
q = [max(t(:,1)), 0, 0;q];
pb = p(find(p(:,2) == max(p(:,2))), :);
for i=0:5
    p(i+2,2:3)= pb(2:3)*[cos(pi/3*i), -sin(pi/3*i);sin(pi/3*i), cos(pi/3*i)]';
    q(i+2,2:3)= pb(2:3)*[cos(pi/3*i), -sin(pi/3*i);sin(pi/3*i), cos(pi/3*i)]';
end
lent =round(sqrt(vect(:,2).^2+vect(:,3).^2)*100);
lent =round(sqrt(p(:,2).^2+p(:,3).^2)*100);
lent =round(sqrt(q(:,2).^2+q(:,3).^2)*100);

visualsphere(R, p, 'y',40);
visualsphere(R, q, 'b',40);

%xc = 0:1:1;xc = 1.732*xc;
%yc = -1:2:1;yc = yc*0.816;
%[X,Y]=meshgrid(xc,yc);
%Z = zeros(size(X));
%k=surf(X,Y,Z);

% =================
xc = 0:1:1;xc = 1.732*xc;
yc = 0:1:1;yc = yc*0.816;
[X,Y]=meshgrid(xc,yc);
Z = zeros(size(X));
k=surf(X,Y,Z);

xc = 0:1:1;xc = 1.732*xc;
zc = -0.5:0.5:0;zc = 1.732*zc;
yc = -0.5:0.5:0;yc = yc*0.816;
xc = [1.732, 0; 1.732, 0];
yc = [-0.4, -0.4;0, 0];
zc = [-0.7, -0.7; 0, 0];
k = surf(xc,yc,zc)
%[X,Y,Z]=ndgrid(xc,yc,zc)
%Z = zeros(size(X));
%k=surf(X,Y,Z);
% ========================
%t = line([0 b1(1)], [0 b1(2)], [0, b1(3)]);set(t, 'color', [1 0 0]); % Red
%t = line([0 b2(1)], [0 b2(2)], [0, b2(3)]);set(t, 'color', [0 1 0]); % Green
%t = line([0 b3(1)], [0 b3(2)], [0, b3(3)]);set(t, 'color', [0 0 1]); % Blue
set(k, 'facealpha', 0.5);
view([90, 0, 0]);lightangle(180,-120);