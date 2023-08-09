function [th, L] = pixel2pol(X, Y)
% cartesian coordinate to polar coordinate..
% This turns left hand cart coordinates to right hand polar coordinate.
% In matlab, X-ray q definition is left handed, but image is right handed.
% To convert, polar to left handed cartesian, use pol2pixel.m
%
% See cart2pol.m
%
% Byeongdu Lee
% Nov. 2018

%th = atan2(X, Y)+pi/2;
th = cart2pol(X, Y);
L = sqrt(X.^2+Y.^2);