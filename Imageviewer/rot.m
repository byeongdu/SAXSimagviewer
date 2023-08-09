function [xn, yn] = rot(xn, yn, tiltang, x0, y0, Isinverse)
% [xn, yn] = rot(xn, yn, tiltang, x0, y0, Isinverse)
% x0, y0 : center of rotation
if nargin <6
    Isinverse = 0;
end    
    tiltang = tiltang*pi/180;
    Rot = [cos(tiltang), sin(tiltang); -sin(tiltang), cos(tiltang)];
    if Isinverse > 0
        Rot = inv(Rot);
    end
    Nc = Rot * [xn(:)'-x0; yn(:)'-y0];
    xn = Nc(1,:) + x0; yn = Nc(2,:) + y0;
end