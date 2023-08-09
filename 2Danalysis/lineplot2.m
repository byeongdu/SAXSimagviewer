function R = lineplot2(img, start, step, final)
% R = lineplot2(img, start, step, final)
% img is image 
% start = starting point   [X, Y]
% step = 1
% final = d_max
%
% img(matrix)를 그림으로 그렸을때..
% X축은 column, Y축은 row
% 그림에서 좌표 (4, 3)은 그 matrix의 (3, 4)의 데이터에 해당함.

slope = (418 - 413.6)./(411 - 430);  % CCD의 경우 Grid의 기울기..
slope = (418 - 413.63)./(411 - 430);  % Gas의 경우 Grid의 기울기..

slope = -1/slope; % 수직인 선을 긋고 싶을 때.
theta = atan(slope);

d_max = final;

for i = 0:step:d_max
   R(i+1,1) = i;
   Xposi(i+1) = i*cos(theta)+start(1);
   Yposi(i+1) = i*sin(theta)+start(2);
   R(i+1,2) = intens(img, [Xposi(i+1), Yposi(i+1)]);
end

%contour(img)
%contour(img(321:880, 201:560))
%Xposi = Xposi - 200;
%Yposi = Yposi - 320;
line(Xposi, Yposi)