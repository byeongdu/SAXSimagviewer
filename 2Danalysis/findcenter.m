function [center, KK, TT] = findcenter(img, initial_center, select_area)
% [center, KK, TT] = findcenter(img, initial_center, select_area, oned_plot)
% block copolymer를 이용하여 center를 찾음.
% 단, 노이즈가 거의 없어서 그대로 max를 찾기만 해도 될때.
% select_area = [Xi, Xf, Yi, Yf]로 입력할 것.
% select_area는 원형패턴이 있을때 그 원 안쪽의 영역을 잡을 것.
% 계산이 끝난후 0, 90, 180, 270도의 one dimensional_plot을 보고 싶으면 
% oned_plot에 아무값을 입력할 것.

X = fix(initial_center(1)); 
Y = fix(initial_center(2));
[row, col] = size(img)

if nargin == 3
   select_Xi = select_area(1);
   select_Xf = select_area(2);
   select_Yi = select_area(3);
   select_Yf = select_area(4);
else
   select_Xi = 1;
   select_Xf = row;
   select_Yi = 1;
   select_Yf = col;
end

left = img(:, 1:X);
right = img(:, (X+1):end);
down = img(1:Y, :);
up = img((Y+1):end, :);

for i = select_Xi:1:select_Xf
   left_X = find(left(i, :) == max(left(i, :), [], 2));
   right_X = find(right(i, :) == max(right(i, :), [], 2));
   cen_X(i-select_Xi+1) = left_X(1) + (X + right_X(1) - left_X(1))/2;
end

for i = select_Yi:1:select_Yf
   down_X = find(down(:, i) == max(down(:, i), [], 1));
   up_X = find(up(:, i) == max(up(:, i), [], 1));
   cen_Y(i-select_Yi+1) = down_X(1) + (Y + up_X(1) - down_X(1))/2;
end

KK = cen_X';
TT = cen_Y';
cen_X(find(cen_X > (mean(cen_X)+std(cen_X)) |cen_X < (mean(cen_X)-std(cen_X)))) = [];
cen_Y(find(cen_Y > (mean(cen_Y)+std(cen_Y)) |cen_Y < (mean(cen_Y)-std(cen_Y)))) = [];

center(1) = mean(cen_X);
center(2) = mean(cen_Y);
rectangle('position', [center(1)-1, center(2)-1, 2, 2], 'curvature', [1, 1])

if nargin == 3
   A0 = lineplot3(img, center, 0, 1);
   A90 = lineplot3(img, center, 90, 1);
   A180 = lineplot3(img, center, 180, 1);
   A270 = lineplot3(img, center, 270, 1);
   figure
   hold on
   plot(A0(:,1), A0(:,2),'r')
   plot(A90(:,1), A90(:,2),'b')
   plot(A180(:,1), A180(:,2),'g')
   plot(A270(:,1), A270(:,2),'m')
   legend('mu = 0', 'mu = 90', 'mu = 180', 'mu = 270')
end