function ang = pixel2angle(pix, center, wl, sdd, pixelsize, detector_tiltangle, Isinverse)
% This function converts cartesian pixel coordinate to cartesian angles 
% coordiante (tthf vs alpha)
%
% ang = pixel2angle(pix, center, sdd, pixelsize, detector_tiltangle, Isinverse)
% pix can be 2D or 1D. when pix is 2D, for example [x, y], center should be
% 2D too.
% 
% detector_tiltangle = [pitch (around y), yaw (around z), roll (around x)]
%   Coordinate: Left handed coordinate
%   [] means [0, 0, 0]  
%   NOTE: This will be taken into account only for 2D..
%
% When Isinverse is 1, this will convert angle to pix
% detector_tiltangle is added. 4/29/2014

if nargin < 7
    Isinverse = 0;
end 

if Isinverse
    [~, pixN] = angles2pixel(pix(:,1), pix(:,2), wl, sdd, pixelsize, detector_tiltangle);
    %convert = @a2p;
    %ang = pixN(:,2:3);
    ang = pixN2Pixel(pixN, sdd, pixelsize, detector_tiltangle);
else
    pix = bsxfun(@minus, pix, center);
    [tthf, af] = pixel2angles(pix, sdd, pixelsize, detector_tiltangle);
    ang = [tthf(:), af(:)];
    %convert = @p2a;
end

% if nargin < 5
%     detector_tiltangle = [];
% end
% 
% % if isempty(detector_tiltangle)
% %     M = [1,0,0;0,1,0;0,0,1];
% % else
% %     p = detector_tiltangle(1)*pi/180;
% %     y = detector_tiltangle(2)*pi/180;
% %     r = detector_tiltangle(3)*pi/180;
% %     Mp = [cos(p), 0, sin(p); 0, 1, 0; -sin(p), 0, cos(p)];
% %     My = [cos(y), -sin(y), 0; sin(y), cos(y), 0; 0, 0, 1];
% %     Mr = [1, 0, 0; 0, cos(r), -sin(r);0, sin(r), cos(r)];
% %     M = Mp*My*Mr;
% % end
% 
% sizepix = size(pix);
% if (sizepix(1) > 1) & (sizepix(2)>2)
%     pix = pix';
%     len_pix = sizepix(2);
%     sizepix(2) = sizepix(1);
%     sizepix(1) = len_pix;
% else
%     len_pix = sizepix(1);
% end
% if sizepix(2) == 2
%     dimpix = 2;
% else
%     dimpix = 1;
% end
%     
% t = size(pix);
% if numel(t) < 2  % 1D array
%     if (numel(center) ~= 1)
%         disp('dimension of center should be the same with pix');
%         return
%     end
% else
%     dir = find(t == 2);
%     if isempty(dir)
%         disp('pix need to have either 2 columns or 2 rows');
%         return
%     end
%     center = center(:);
%     if dir(1) == 1
%         center = repmat(center, 1, t(2));
%     else
%         center = repmat(center', t(1), 1);
%     end
% end
% %p2a
% convert(t);
% %    ang = atan((pix-center)*pixelsize/sdd)*180/pi;
% 
%     function p2a(t)
%         pixN = pix - center;
%         if dimpix == 2
%             if ~isempty(detector_tiltangle)
%                 % On Lab coord, rotating [0,Y,Z] to [x,y,z]
%                 [pixN, D_SDD] = detector_rotate(pixN, detector_tiltangle, 1);
%                 pixN = pixN*pixelsize;
%                 D_SDD = D_SDD*pixelsize;
%             end
%         end
%         % When detector tilted, SDD of each data point changes..
%         ang = atan(pixN./repmat(sdd+D_SDD, 1, size(pixN,2)))*180/pi;
%     end
% 
%     function a2p(t)
%         ang = tan(pix*pi/180)*sdd/pixelsize;% + center;
%         if dimpix == 2
% %             pixD = [zeros(len_pix, 1), ang];
% %             pixN = pixD*M';
% %             ang = pixN(:,2:3);
%             if ~isempty(detector_tiltangle)
%                 ang = detector_rotate(ang, detector_tiltangle, 0);
%             end
%         end
%         ang = ang + center;
%             
%     end
%     function [tthf, af] = P2Angle
%         % cartesian pixel to cartesian angle (degree)
%         pixN = (pix - center)*pixelsize;
%         pixN = [zeros(size(pixN, 1),1), pixN];
%         M = rotationmatrix;
%         pixN = pixN*M';
%         pixN(:,1) = sdd+pixN(:,1);
%         [tthf, af] = v2angle(pixN(:,1), pixN(:,2), pixN(:,3));
%         tthf=tthf*180/pi; % return degree
%         af = af*180/pi;
%     end
%     function P = angle2P(tthf, af, SDD, psize, center)
%         % cartesian angle (degree) to cartesian pixel
%         v = angle2v(tthf*pi/180, af*pi/180);
%         P = v2P(v(:,1), v(:,2), v(:,3), SDD, psize);
%         P = P + repmat(center, numel(P(:,1)), 1);
%     end
%     function P = v2P(v1,v2,v3, SDD, psize)
%         M = rotationmatrix;
% 
%         t = cos(pitch)*cos(yaw)./(cos(pitch)*cos(yaw)*v1+sin(yaw)*v2-sin(pitch)*cos(yaw)*v3);
% 
%         % x = 1 + t.*cos(tth);
%         % y = s2th.*sphi.*t;
%         % z = s2th.*cphi.*t;
%         x = 1 - t.*v1;
%         y = -v2.*t;
%         z = v3.*t;
%         P = [x, y, z]*M*SDD/psize; % Rotating (x, y, z) onto [0, Y, Z] plane.
%         res = 1E5;
%         P = round(P(:,2:3)*res)/res;
%     end
%     function v = angle2v(tthf, af)
%         % Two cartensian angles to a unit vector.
%         v1 = cos(af).*cos(tthf);
%         v2 = cos(af).*sin(tthf);
%         v3 = sin(af);
%         v = [v1, v2, v3];
%     end
%     function [tthf, af] = v2angle(v1, v2, v3)
%         % unit vector into two cartesian angles.
%         tthf = atan(v2./v1);
%         af = atan(v3./sqrt(v1.^2+v2.^2));
%     end
%     function M = rotationmatrix
%         pitch = detector_tiltangle(1)*pi/180;
%         yaw = detector_tiltangle(2)*pi/180;
%         roll = detector_tiltangle(3)*pi/180;
%         % Rotation matrix
%         Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
%         My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
%         Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
%         M = Mp*My*Mr;
%     end
% end