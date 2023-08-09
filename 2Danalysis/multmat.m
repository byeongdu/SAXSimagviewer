function R = multmat(data, data2, arg)
% this function is for processing matrix by array
% R = multmat(data, data2)
% data : matrix
% data2 : should be column vector(length should be same with raw of 'data')
% arg : +, -, *, /
%
% usage :
% 	if your 'data' is
%                     q(1)   Intensity(1, 1)     Intensity(1, 2)
%                     q(2)   Intensity(2, 1)     Intensity(2, 2)
%                                      .  .  .  .
%                     q(n)   Intensity(n, 1)     Intensity(n, 2)
%
%	and you have 'data2' for dark current data.
%                     value(1)
%                     value(2)
%                        . . .
%                     value(n)
%
% you can subtract dark current from all the Intensity data.
%
%  R = multmat(data(:, 2:3), data2, '-');
%
%

[x, y] = size(data);

if x == length(data2)
	if arg == '+'
	   for i = 1:y
      	data(:,i) = data(:,i) + data2(:,1);
	   end
	elseif arg =='-'
	   for i = 1:y
	      data(:,i) = data(:,i) - data2(:,1);
	   end
	elseif arg == '*'
	      for i = 1:y
	      data(:,i) = data(:,i).*data2(:,1);
	   end
	elseif arg == '/'
	   for i = 1:y
	      data(:,i) = data(:,i)./data2(:,1);
	   end
	end
   
      R = data;
   
else
   disp('length of data2 is not the same with the row in data')
end