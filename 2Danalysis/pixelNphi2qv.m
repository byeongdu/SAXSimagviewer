function [qx, qy, qz] = pixelNphi2qv(Z, Y, phi, psize, lambda, SDD)
% Convert Pixel(Z, Y) and Phi to q vector.
% Z is the vertical direction pixel index - center.
% Y is the horizontal direction pixel index - center.
% SDD in mm unit.
% phi in degree
%
% This is for a single crystal that is measured on 2D detector while
% rotating phi.
% q vector is defined in the laboratory coordinate.
% From the constructed 3D volumetric data, one should find the sample
% coordinates unless one knows the crystal orientation matrix
%
% See pixelNphi2qv2.m 
%
% 2016/8/1
% Byeongdu Lee

saxs.edensity = 0;
saxs.beta = 0;
saxs.ai = 0;
saxs.waveln = lambda;
saxs.psize = psize;
saxs.center = [0, 0];
saxs.SDD = SDD;
saxs.tiltangle = 0;
%qv = pixel2qv([Y, Z], [0, 0], SDD, psize, 0, 0, 0, saxs);
saxs.tthi = phi;
saxs.ai = 0;
saxs.center = [0, 0];
q = pixel2qv([Y(:), Z(:)], saxs);
qx = q.qx;
qy = q.qy;
qz = q.qz;
