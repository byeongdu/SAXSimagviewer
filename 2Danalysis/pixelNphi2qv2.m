function [qx, qy, qz] = pixelNphi2qv2(Z, Y, phi, psize, lambda, SDD)
% Convert Pixel(Z, Y) and Phi to q vector.
% Z and Y in mm unit.
% SDD in mm unit.
% phi in degree
%
% This is for a single crystal that is measured on 2D detector while
% rotating phi.
% q vector is defined in the laboratory coordinate.
% From the constructed 3D volumetric data, one should find the sample
% coordinates unless one knows the crystal orientation matrix
% Z = Z*psize;
% Y = Y*psize;
%
% This function calculate angles first and convert them to q values.
% See pixelNphi2qv.m 
%
% 2016/8/1
% Byeongdu Lee
%ang = pixel2angle2([Y, Z], [0, 0], SDD, psize, [0, 0, 0]);
[tthf, af] = pixel2angles([Y, Z], SDD, psize, [0,0,0]);
ang = [tthf(:), af(:)];

ang(:,1) = phi+ang(:,1);
[qx, qy, qz] = angle2vq2(0, ang(:,2), -phi, ang(:,1), lambda);
