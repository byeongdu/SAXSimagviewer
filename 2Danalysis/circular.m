function C = circular(img, cent, pixeltoq, mu_start, mu_final, end_select)
% the function 'circular' is for azimuthal averaging
% img : 2 dim data, should be matrix form
% 		If you are using winspec(Roper scientific), then, use the 'speopen' to load the data
% cent : center of image. if you do not input, program will find maximum intensity position.
% pixeltoq : after averge, if you want to convert pixel to q please type as [pixel(1d), qvalue(1d)]
% averaging will be peformed cell by cell base, then, reduced X axis can not be smaller than pixel interval
% mu_final should be larger than mu_start: mu = 0 is + x axis direction.
%
% img(matrix)를 그림으로 그렸을때..
% X축은 column, Y축은 row
% 그림에서 좌표 (4, 3)은 그 matrix의 (3, 4)의 데이터에 해당함.
draw = 'NO';
if nargin <= 3
   mu_start = 0;
   mu_final = 359;
end
   
if nargin >=3
    p1d = pixeltoq(1);
    q1d = pixeltoq(2);
end

[row, col] = size(img);

timecheck = 1;

[row, col] = size(img);
cent_Y = cent(2);
cent_X = cent(1);

edge = [cent_X, col-cent_X+1, cent_Y, row - cent_Y+1];

if ((nargin == 6) & (end_select == -1)) 
    end_point = ginput(1);
    d = sqrt((cent_X - end_point(1))^2 + (cent_Y - end_point(2))^2);
    if d > edge 
        d = edge;
    end
elseif ((nargin == 6) & (end_select > 0))
    d = end_select;
else
    d = min(edge);
    d = d-1;
end

d = fix(d)

for i =1:d
   sum_theta=0;
   countTheta = 0;
   
% ==========================
   if timecheck == 1
      tic
  elseif i == fix(d/2)
      tic
      timecheck = 2;
  end
%===========================   

theta = mu_start:1:mu_final;
theta = theta';
posi = [i* cos(theta * pi /180)+cent_X,  i*sin(theta * pi /180)+cent_Y];

for j=1:(mu_final-mu_start +1)   
   sum_theta(j) = intens(img, posi(j,:));
   numPixel = mu_final-mu_start;
end

if nargin == 6
   if (draw == 'y') %& (rem(d, 10) == 0)
      line(posi(:,1), posi(:,2));
   end
end
  
  total_theta(i) = mean(sum_theta);
  Yerr(i) = sqrt((numPixel*sum(sum_theta.^2) - total_theta(i)^2)/(numPixel^2*(numPixel-1)));
%==============================
  if timecheck == 1
     a = toc;
     disp(['calculating time will be ', num2str(a*d) ,' seconds'])
     timecheck = 0;
elseif timecheck ==2
     a = toc;
     disp(['you need to wait more ', num2str(a*(d-i)), ' seconds'])
     timecheck = 0;
end
% ==============================  
end

Xaxis = 1:d;
if nargin >=3
    Xaxis = Xaxis*q1d/p1d;
end
C = [Xaxis', total_theta', Yerr'];