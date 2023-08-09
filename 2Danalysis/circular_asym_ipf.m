function C = circular_asym_ipf(img, cent, D, end_select, draw)
% the function 'circular' is for azimuthal averaging for asymmetric detector plane(Image plate : square edge).
% img : 2 dim data, should be matrix form
% 		If you are using winspec(Roper scientific), then, use the 'speopen' to load the data
% cent : direct beam position.
% cen_CCD : center of CCD.
% offs : offset of mu angle. 계산된 것보다 얼마나 적은 범위에서 mu 를 하는 가 하는 것임.
% averaging will be peformed cell by cell base, then, reduced X axis can not be smaller than pixel interval
% mu_final should be larger than mu_start: mu = 0 is + x axis direction.
%
% img(matrix)를 그림으로 그렸을때..
% X축은 column, Y축은 row
% 그림에서 좌표 (4, 3)은 그 matrix의 (3, 4)의 데이터에 해당함.
% 이 프로그램은 direct beam을 CCD의 가운데에 두지 않았을 경우를 위한것.
% 이때는 CCD의 원의 가운데 점의 위치와  direct빔의 위치를 알 경우
% azimuthal angle을 d에 따라 달리 해가기 위한 것이다.
% mu_all은 d에 따른 mu start와 final 그리고, cos제2법칙을 사용해 계산한 중간각을 나타낸다.

mu1 = [];
mu2 = [];
mu_cal = [];

if nargin <= 2
   mu_start = 0;
   mu_final = 359;
end
   
[row, col] = size(img);

timecheck = 1;

[row, col] = size(img);
cent_Y = cent(2);
cent_X = cent(1);

edge = [cent_X, col-cent_X+1, cent_Y, row - cent_Y+1];

if nargin >=4 & isempty(end_select) == 1
    end_point = ginput(1);
    d = sqrt((cent_X - end_point(1))^2 + (cent_Y - end_point(2))^2);
elseif nargin >=4 & isempty(end_select) == 0
    d = end_select;
else
    d = min(edge);
    d = d-1;
end


for i =1:d
   sum_theta=0;
   countTheta = 0;
   
   if i <= D
      mu_start = 0;
      mu_final = 90;
   elseif i>D
      mu_start = rad2deg(acos(D/i));
      mu_final = 90;
   end
   
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
KK = find(posi(:,2) > 4000);
TT = find(posi(:,1) > 2000);
if (isempty(KK) ~= 1) | (isempty(TT) ~= 1) 
    i
    posi
    break
end 
    
for j=1:(mu_final-mu_start +1)   
   sum_theta(j) = intens(img, posi(j,:));
end

if nargin == 5
   if (draw == 'y') %& (rem(d, 10) == 0)
      line(posi(:,1), posi(:,2));
   end
end
  
  total_theta(i) = mean(sum_theta);
  
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

C = [total_theta'];