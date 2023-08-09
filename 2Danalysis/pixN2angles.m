function [tthf, af] = pixN2angles(pixN)
% function [tthf, af] = pixN2angles(pixN)
% return in degree.

% [tthf, af] = v2angle(pixN(:,1), pixN(:,2), pixN(:,3));
% The angles above are different from tthf and af defined in x-ray
% scattering.
% af is the angle between a vector to its projection on [X, Y] plane.
% plane = [X0 Y0 Z0  VX1 VY1 VZ1  VX2 VY2 VZ2]
% point = projPointOnPlane(pixN, [0, 0, 0, 1, 0, 0, 0, 1, 0]);
% Its projection is [pixN(:,1), pixN(:,2), 0];

normpixN = sqrt(sum(pixN .* pixN, 2));
projXY = [pixN(:,1), pixN(:,2), zeros(size(pixN(:,1)))];
normprojXY = sqrt(sum(projXY .* projXY, 2));
Cosaf = sum(pixN.*projXY, 2)./normpixN./normprojXY;
af = acos(Cosaf)*180/pi.*sign(pixN(:,3));

projXZ = [projXY(:,1), zeros(size(projXY(:,1))), projXY(:,3)];
Costthf = sum(projXY.*projXZ, 2)./normprojXY./sqrt(sum(projXY .* projXZ, 2));
tthf = acos(Costthf)*180/pi.*sign(pixN(:,2));
