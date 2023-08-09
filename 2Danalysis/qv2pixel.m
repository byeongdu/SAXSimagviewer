function [pixN, phi, pixN2, phi2] = qv2pixel(qv, wl, sdd, psize, detangle)
% [pixN, phi, pixN2, phi2] = qv2pixel(qv, wl, sdd, psize, detangle)
% qv is a q vector on the Ewald sphere.
% For a given tilted detector defined by angle 'detangle',
% this function calculates pixel position
% If qv is not on the Ewald sphere, this software calculates phi angle to
% bring the qv vector on the Ewald sphere. phi angle is the angle around Z
% axis.
% The origin of the Ewald sphere is [-k0, 0, 0].
% thus ki = [k0, 0, 0];
% The origin of the reciprocal space is [0, 0, 0]

k0 = 2*pi/wl;
qx = qv(:,1);
qy = qv(:,2);
qz = qv(:,3);
% Line = [zeros(length(qx), 3), k0-qx, qy, qz];
if numel(detangle)==3
    pitch = detangle(1)*pi/180;
    yaw = detangle(2)*pi/180;
    roll = detangle(3)*pi/180;
else
    pitch = 0;
    yaw = 0;
    if numel(detangle) == 1
        roll = detangle*pi/180;
    else
        roll = 0 ;
    end
end
% Rotation matrix
Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
M = Mp*My*Mr;
% % qv and NV intersection.
% % Line equation : x=qx*t; y=qy*t; z=qz*t;
% % The equation of the detector
% % dot(NV, [x-sdd/psize, y, z])=0
% kf = qv;
% kf(:,1) = k0 + qv(:,1); % This way, qv becomes kf vector.
% % Now calculate a coordinate where kf crosses the detector plane.
% len_kf = sqrt(sum(kf.^2, 2));
% NonLaue = abs(len_kf - k0) > 0.0001;
% 
% if qv is not on Ewald sphere, we need to find phi angle (rotation around
% Z axis) to bring qv to Ewald sphere.
% Let's say a (qr cosphi, qr sinphi, qz) is on Ewald sphere.
% distance from [-k0, 0, 0] to a is k0.
% distance from [0, 0, 0] to a is q.
% (qrcosphi+k0)^2+(qrsinphi)^2+qz^2 = k0^2 and qr^2+qz^2 = q^2.
% from this, we got cosphi = -q^2/(2k0qr)
ki = [k0, 0, 0];
ki_array = repmat(ki, size(qv, 1), 1);
qr = sqrt(qx.^2+qy.^2);
if nargout < 2
    kf = qv+ki_array;
%    kf = qv+ki;
    iL = isLaue(kf, k0);
    pixN = kf2pixN(kf, sdd, psize, M);
    pixN(~iL, :) = NaN*pixN(~iL, :);
    return
end

cosphi = -(qx.^2+qy.^2+qz.^2)./(2*k0*qr);
cosphi(cosphi<-1) = NaN;
cosphi(cosphi>1) = NaN;
ph = acos(cosphi);
qz0 = zeros(size(qz));

if nargout < 3
    imax = 1;
else
    imax = -1;
end

for i=1:-2:imax
    qv_onEwald = [qr.*cosphi, i*qr.*sin(ph), qz];
    %Calculate phi angle that rotates qv to qv_onEwald.
    kf = qv_onEwald+ki; %
    qx = real(qx);
    qy = real(qy);
    th1 = cart2pol(qx, qy);
    th2 = cart2pol(qv_onEwald(:,1), qv_onEwald(:,2));
    % right hand coordinate.. phi increase with right hand rotation.
    % phi0 = -1*(th2-th1);
    phi0 = -(th2-th1);
    t = phi0 < -pi;
    phi0(t) = phi0(t) + 2*pi;
%     t = phi0 > pi;
%     phi0(t) = 2*pi - phi0(t);
    phi0 = rad2deg(phi0);
%    phi0 = -angle2vect2([qx, qy, qz0], [qv_onEwald(:, 1:2), qz0])*180/pi;

    pixN0 = kf2pixN(kf, sdd, psize, M);
    if i>0
        pixN = pixN0;
        phi = phi0;
    else
        pixN2 = pixN0;
        phi2 = phi0;
    end
    
end


function pixN0 = kf2pixN(kf, sdd, psize, M)
    % Now define a line of which vector is kf and passing [0, 0, 0].
    % Put a detector at [sdd/psize, 0, 0] of which normal vector is NV.
    % See equation: https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection

    la = [0, 0, 0];
    lab = kf;
    detPos = [sdd/psize, 0, 0];
    P0 = [0, 0, 0]*M';
    P1 = [0, 1, 0]*M';
    P2 = [0, 0, 1]*M';
    P0 = P0 + detPos;
    P1 = P1 + detPos;
    P2 = P2 + detPos;
    P01 = P1 - P0;
    P02 = P2 - P0;
    cP12 = cross(P01, P02);
    t = -repmat(dot(cP12, (la - P0)), size(lab, 1), 1)./dot(lab, repmat(cP12, size(lab, 1), 1), 2);
    pixN0 = la+bsxfun(@times, lab, t);