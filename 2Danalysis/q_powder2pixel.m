function [pixN2D, pixNx] = q_powder2pixel(q, wl, sdd, psize, detangle)
% For a given modulus q, this function generate a powder ring for a tilted
% detector. 2D pixel coordinates are returned.

qv = q_powder2qv(q, wl);
pixN = qv2pixel(qv, wl, sdd, psize, detangle);
[pixN2D, pixNx] = pixN2Pixel(pixN, sdd, psize, detangle);
%pixN2D(:,1) = [];

% pixN2D = pixN(:, 2:3); % only Y and Z coordinates are returned.
%pixNx = pixN(:,1);