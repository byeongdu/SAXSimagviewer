function pixN = pixel2pixN(Pixel, center, sdd, psize, detangle)
% function pixN = pixel2pixN(Pixel, sdd, psize, detangle)
% Convert a detector pixel into 3D laboratory pixN coordinate.
if ~isempty(center)
    Pixel = bsxfun(@minus, Pixel, center);
end
if numel(detangle) == 1
    pitch = 0;
    yaw = 0;
    roll = detangle*pi/180;
else
    pitch = detangle(1)*pi/180;
    yaw = detangle(2)*pi/180;
    roll = detangle(3)*pi/180;
end
% Rotation matrix
Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
M = Mp*My*Mr;
%NV = [-1, 0, 0]*M';
% coordinate, [x, Y, Z] is on the detector.
% therefore,
% NV(1)(x-sdd/psize) + NV(2)*Y + NV(3)*Z = 0;
Pixelx = zeros(size(Pixel, 1), 1);
Pixel = [Pixelx, Pixel]*M'; % Detected image into pixN
%x = sdd/psize - (NV(2)*Pixel(:,2) + NV(3)*Pixel(:,3))/NV(1);
Pixel(:,1) = Pixel(:,1)+sdd/psize;
pixN = Pixel;
%pixN = [x, Pixel];
