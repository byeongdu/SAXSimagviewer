function [pixel, pixN] = angles2pixel(tthf, af, wl, sdd, psize, detangle)
% converting tthf and af angles to pixN and then to pixel.
% pixN is the laboratory coordinate of the detector.
% pixel is the detector coordinate.

pixN = angles2pixN(tthf, af, wl, sdd, psize, detangle);
pixel = pixN2Pixel(pixN, sdd, psize, detangle);
%pixel = pixN2Pixel(pixN);