function mu = calMu(center, X, Y)
% this will calculate mu
% mu = calMu(center, X, Y)

   if ((X-center(1))>=0)&((Y-center(2))>=0)
      mu = atan((Y-center(2))./(X-center(1)))*180/pi;
   elseif ((X-center(1))<0)&((Y-center(2))>=0)
      mu = atan((Y-center(2))./(X-center(1)))*180/pi+180;
   elseif ((X-center(1))<0)&((Y-center(2))<0)
      mu = atan((Y-center(2))./(X-center(1)))*180/pi+180;
   elseif ((X-center(1))>=0)&((Y-center(2))<0)
      mu = atan((Y-center(2))./(X-center(1)))*180/pi+360;
   end