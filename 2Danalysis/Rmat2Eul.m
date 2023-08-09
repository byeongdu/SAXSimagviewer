function [phi, theta, gamma] = Rmat2Eul(mat)
% [phi, theta, gamma] = Rmat2Eul(mat)
% This function converts a rotation matrix to Euler angles(Traditional).
% phi : angle between Z and Z'
% theta : Rotation angle around Z
% gamma : Rotation angle around Z'
z = [0,0,1];
zp = z*mat';
theta = anglePoints3d(z, zp)*180/pi;
phi = atan(zp(2)/zp(1))*180/pi;
x = [1,0,0];
m = eulerAnglesToRotation3d(phi, theta, 0);
xptemp = x * m(1:3, 1:3)';
xp = x*mat';
gamma = sign(xp(3))*anglePoints3d(xptemp, xp)*180/pi;