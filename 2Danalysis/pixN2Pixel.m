function [Pixel, Pixelx] = pixN2Pixel(pixN, sdd, psize, detangle)
% [Pixel, Pixelx] = pixN2Pixel(pixN, sdd, psize, detangle)
% pixN : pixel position in the laboratory coordinate.
% Pixel : pixel position in the detector coordinate.
%
% To convert pixN to Pixel,
% 1) translate pixN to [0, 0, 0] and 2) then rotate inversely.
%

% Rotate pixN to YZ plane.
pitch = 0;
yaw = 0;
switch length(detangle)
    case 0
        roll = 0;
    case 1
        roll = detangle(1);
    case 3
        pitch = detangle(1)*pi/180;
        yaw = detangle(2)*pi/180;
        roll = detangle(3)*pi/180;
end

% Rotation matrix
Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
M = Mp*My*Mr;
pixN = bsxfun(@minus, pixN, [sdd/psize, 0, 0]);
Pixel = pixN*M;
Pixelx = Pixel(:,1);
Pixel(:,1) = [];
