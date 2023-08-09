function [tthf, af, pixN] = pixel2angles(Pixel, sdd, psize, detangle)
% [tthf, af, pixN] = pixel2angles(Pixel, sdd, psize, detangle)
% Pixel: nx2 array of pixel positions on a detector that may be tilted.
% The pixel position is in the detector coordinates.
% tthf and af are in degree.
% Since the tilt angle is known, rotate the detector, meaning converting
% the detector coordinates to the laboratory coordinate.
% pixN : position in the laboratory coordinates.
%
% Then, calculate scattering angles tthf and af.

% default direction: tthf increase from left to right (left hand
% coordination system)
% In the right hand coordination system,
% tthf increases from the right to left (as the pixel number decreases).
% This direction is due to the definition of qy to be positive to the left
% and qx is along the beam direction (right handed coordinate system).
% af increases from bottom to up (as the number of pixel increases)
% For the right hand coordination system, either
% Pixel(:,1)=-Pixel(:,1);
% or flip image in lr direction.

pixN = pixel2pixN(Pixel, [], sdd, psize, detangle);

[tthf, af] = pixN2angles(pixN);
%absa = sqrt(pixN(:,1).^2+pixN(:,2).^2+pixN(:,3).^2);
%af = dot(pixN, repmat([1,1,0], length(pixN(:,1)), 1))/absa/sqrt(2);

%tthf=tthf*180/pi; % return degree
%af = af*180/pi;
