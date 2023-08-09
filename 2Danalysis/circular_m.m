function C = circular(img, cent)
% the function 'circular' is for azimuthal averaging
% img : 2 dim data, should be matrix form
% 		If you are using winspec(Roper scientific), then, use the 'speopen' to load the data
% cent : center of image. if you do not input, program will find maximum intensity position.
%
% averaging will be peformed cell by cell base, then, reduced X axis can not be smaller than pixel interval

[row, col] = size(img);

timecheck = 1;

if nargin < 2
   center = find(img == max(max(img)));
   [row, col] = size(img);
   
   % center of img : maximum intensity position
   c_col = fix(center / row) +1;
   c_row = center - (c_col-1) * row ;
else
   [row, col] = size(img);
   c_col = cent(2);
   c_row = cent(1);
end

edge = [c_col, col-c_col+1, c_row, row - c_row+1];
d = min(edge);
d = d-1;

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

theta = 0:1:359;
theta = theta';
posi = [ i* sin(theta * pi /180)+c_row, i * cos(theta * pi /180)+c_col];

sum_theta = intens_m(img, posi);
  
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

Xaxis = 1:d;

C = [Xaxis', total_theta'];