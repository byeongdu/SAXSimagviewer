function [pixN, delta_sdd] = detector_rotate(pixel, detector_tiltangle, direction)
% function [pixN, delta_sdd] = detector_rotate(pixel, detector_tiltangle, direction)
% pixel = [ypixel, zpixel] should be Mx2 matrix. M is the number of points.
% use the left hand coordinate
%
% detector_tiltangle = [pitch (around y), yaw (around z), roll (around x)]
%   Coordinate: Left handed coordinate
%   [] means [0, 0, 0]  
%   NOTE: This will be taken into account only for 2D..
% direction = 0 or 1 for rotation of a point and for coordinate transform
% (rotation of the coordinate)
% 
if nargin<3
    direction = 0;
end
len_pix = numel(pixel(:,1));
    p = detector_tiltangle(1)*pi/180;
    y = detector_tiltangle(2)*pi/180;
    r = detector_tiltangle(3)*pi/180;
    Mp = [cos(p), 0, sin(p); 0, 1, 0; -sin(p), 0, cos(p)];
    My = [cos(y), -sin(y), 0; sin(y), cos(y), 0; 0, 0, 1];
    Mr = [1, 0, 0; 0, cos(r), -sin(r);0, sin(r), cos(r)];
    M = Mp*My*Mr;
    
    switch direction
        case 0 
            % Rotating [x, y, z] in the Lab coordinate into [0,Y,Z] in the
            % Lab.
        pixD = [zeros(len_pix, 1), pixel];
        pixN = pixD*M;
        delta_sdd = pixN(:,1);
        pixN = pixN(:,2:3);
        case 1
            % Rotating [0, Y, Z] in the Lab into [x,y,z] in the Lab.
        pixD = [zeros(len_pix, 1), pixel];
        pixN = pixD*M';
        delta_sdd = pixN(:,1);
        pixN = pixN(:,2:3);
    end        
