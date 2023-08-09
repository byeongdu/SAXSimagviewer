function pixN = angles2pixN(tthf, af, wl, sdd, psize, detangle)
% converting tthf and af angles to pixN 
[qx, qy, qz] = angle2vq2(zeros(size(af)), af, zeros(size(af)), tthf, wl);
pixN = qv2pixel([qx(:), qy(:), qz(:)], wl, sdd, psize, detangle);