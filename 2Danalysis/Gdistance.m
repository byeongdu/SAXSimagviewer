function distance = Gdistance(scale)
% distance calculate from the image...
% 2 input points are obtained from the ginput function
% scale is the real scale of a pixel(should be square and each x and y distances should be same)

tt = ginput(2);
distance = sqrt((tt(3)-tt(4)).^2 + (tt(1)-tt(2)).^2);
distance = scale*distance;