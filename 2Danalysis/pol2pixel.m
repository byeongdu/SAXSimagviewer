function [X, Y] = pol2pixel(th, q)
% polar coordinate to cartesian coordinate
% This turns right hand polar coordinates to left hand cart coordinate.
% In matlab, X-ray q definition is left handed, but image is right handed.
% To convert, cart to right handed cartesian, use pixel2pol.m
%
% See pol2cart.m
%
% Byeongdu Lee
% Nov. 2018

[X, Y] = pol2cart(th, q);
%X = -X;