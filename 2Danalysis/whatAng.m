function [X, Y, d, mu, Intensity] = whatAng(center, img, N)
% [X, Y, q, mu, intensity] = whatAng(center, image, Number)
% 'center' is retangular coordinate of image

[XX, YY] = Ginput(N);

d = sqrt((XX-center(1)).^2 + (YY-center(2)).^2);

for i=1:1:length(XX)
   X = XX(i);
   Y = YY(i);
   if ((X-center(1))>=0)&((Y-center(2))>=0)
      mu(i) = atan((Y-center(2))./(X-center(1)))*180/pi;
   elseif ((X-center(1))<0)&((Y-center(2))>=0)
      mu(i) = atan((Y-center(2))./(X-center(1)))*180/pi+180;
   elseif ((X-center(1))<0)&((Y-center(2))<0)
      mu(i) = atan((Y-center(2))./(X-center(1)))*180/pi+180;
   elseif ((X-center(1))>=0)&((Y-center(2))<0)
      mu(i) = atan((Y-center(2))./(X-center(1)))*180/pi+360;
   end
Intensity(i) = intens(img, [XX(i), YY(i)]);
end

%mu = atan2((Y-center(2)), (X-center(1)))*180/pi+180;
