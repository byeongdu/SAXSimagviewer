function qv = pixel2qv0(Pixel, wl, sdd, psize, detangle)
% q calculation for pixels on a detector that may be tilted.
% The pixel position is in the detector coordinates.
% 
% Since the tilt angle is known, rotate the detector, meaning converting
% the detector coordinates to the laboratory coordinate.
% Then, calculate scattering angles and q vectors.

[tthf, af] = pixel2angles(Pixel, sdd, psize, detangle);
[qx, qy, qz] = angle2vq2(zeros(size(af)), af, zeros(size(af)), tthf, wl);
qv = [qx, qy, qz];