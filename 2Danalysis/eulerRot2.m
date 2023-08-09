function [N, rot] = eulerRot2(n, u, angle)
% N = eulerRot2(n, u, angle)
% n vector to be rotated
% u vector is a reference vector. 
% n vector will be rotated around u vector by 'angle'.
%
% this program is coded based on "Rotate.m" in the original matlab.
% Byeongdu Lee

alph = deg2rad(angle);
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = u(1)/norm(u);
y = u(2)/norm(u);
z = u(3)/norm(u);
rot = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
       x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
       x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera]';
N = n*rot;