function P = q2pixel_tiltdetector(q_modulus, azimangle, detector_angle, SDD, psize, wl, edensity, beta, ai)
% P=q2pixel_tiltdetector(q_modulus, azimangle, detector_angle, SDD, psize, wl)
% q2pixel(q, azimangle, ...)
% q2pixel([qxy, qz], [], ...)
% q2pixel([qx, qy, qz], [], ...)
% q2pixel([tthf, af, tthi, ai], [],...): if ai not zero, two sets returns.
% q2pixel([qxy, qz], [], ..., edensity, beta, ai, tthi): refraction will be
% corrected.

% When q is given, this will find a peak position on a detector that may be
% tilted.
% First, for a given q, one should check whether it is on a Ewald sphere or
% not. In other word, the q should be in the Bragg condition.
% When 3D powder is given, no need to check the Bragg condition.
% When 2D powder is given, for instance, q* = [q*xy, q*z],
%   q=(qx, qy, qz) that meet(s) the Bragg condition and also on q* (q -> q*
%   ; qis an element of q*) should fit the following condition.
%   (qx + k0)^2+qy^2+qz^2=k0^2
%   qx^2+qy^2=q*xy^2
%   qz = q*z
%   From these, qx = -1/(2k0)*(q*xy^2+q*z^2), qy=+-sqrt(q*xy^2-qx^2);
%   qz=q*z;
% When a q vector(q* = (q*x, q*y, q*z)), is given, it may not be on a Ewald
% sphere. This program is not a program to calculate how to rotate the
% crystal to the Bragg condtion, but to calculate whether q* is on the
% Ewald sphere or not.
%
% If a given q is not on the Bragg condition, [NaN,NaN,NaN] will be returned.
% 
% In addition, [tthf, af, tthi, ai] can be given.
%   , where all these angles are refraction corrected if any.
%   q = kf-ki = k0[cosaf*costthf-; cosaf*sintthf-;sinaf+-sinai];
%   In this case, new kf should be defined for ki=k0*[1,0,0];
%   kfnew or v = q/k0-[1,0,0];
%
% Byeongdu Lee
% 04/30/2014


k0 = 2*pi/wl;


% find the point(s) where kf vector (starting from [-1,0,0]*SDD) hit(s) 
% the detector plane at [0,0,0]
% The equation of kf line: (x-SDD)/v1 = (y-0)/v2 = (z-0)/v3
%   (x/SDD-1)/v1 = (y/SDD)/v2 = (z/SDD)/v3 == t;
%   v = [cos(tth), -sin(tth)*sin(phi), sin(tth)*cos(phi)]
% The equation of the detector plane: n1x+n2y+n3z = 0
%   n = M*[1,0,0]'=[cos(p)*cos(y),sin(y),-sin(p)*cos(y)]'
isangle2pixel = 0;
isrefraction = 0;

if size(q_modulus,2)==4
    isangle2pixel = 1;
end
if nargin > 6
    isrefraction = 1;
end

if isangle2pixel
    %elseif size(q_modulus, 2) == 4 % for cartesian angles
    % if q_modulus = [tthf, af, tthi, ai]
    tthf = q_modulus(1)*pi/180;
    af = q_modulus(2)*pi/180;
    tthi = q_modulus(3)*pi/180;
    ai = q_modulus(4)*pi/180;% because typically ai's sign is opposite
        % for instance GISAXS, ai is mostly negative, but it is
        % presented positive in most of case. Or at lease the sign of
        % ai and af should be opposite because one goes up and the
        % other goes down. However, normally ai and af are presented
        % with the same sign.
    for k=1:2
        ai = abs(ai)*(-1)^(k);
        pixel = angle2pixel(tthf, af, tthi, ai, detector_angle, SDD, psize);
        if ai==0
            P = pixel;
            return
        else
            P{k}=pixel;
        end
    end        
    %
    return;
end

if ~isrefraction %convert q to pixel
%else % for either 2D powder or single crystals.
    if ~isempty(azimangle)  % for 3D powder
        tth = 2*asin(q_modulus(:)*wl/4/pi);
        phi = azimangle(:)*pi/180;
        v1 = cos(tth);
        v2 = -sin(tth).*sin(phi);
        v3 = sin(tth).*cos(phi);
    else
        if size(q_modulus,2)==3 % for a single crystal.
            % if q_modulus = [qx, qy, qz] and phi = [];
            q = q_modulus;
            %checking the Bragg condition
            t = q(:,1)^2+2*k0*q(:,1)+q(:,2).^2+q(:,3).^2 ~=0;
            q(t,1) = NaN;
        elseif size(q_modulus,2)==2 % for a 2D powder
            % if q_modulus = [qxy, qz] and phi = []; 
            qxy = q_modulus(:,1); qz = q_modulus(:,2);
            qx = -1/(2*k0)*(qxy.^2+qz.^2);
            qy = sqrt(qxy.^2-qx.^2); 
            % Check the Bragg condition
            t = qxy.^2<qx.^2;qy=real(qy);
            qy(t)=NaN;% If not, on the Bragg condition, qy<-NaN
            q = [qx, qy, qz; qx, -qy, qz];
        end
        % find kf vector. v = kf/k0, of which length should be 1 in order to be
        % at the Bragg condition. Otherwise v may be longer or shorter than 1.
        v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
        % calculate kf/|kf| == v
        %v = v./repmat(vectorNorm(v), 1, 3);
        v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);
    end
    
    P = v2P(v1,v2,v3, detector_angle, SDD, psize);
    return
end

% refraction needs to be corrected...
if size(q_modulus,2)==2 % for a 2D powder
            % if q_modulus = [qxy, qz] and phi = []; 
    qxy = q_modulus(:,1); qz = q_modulus(:,2);
    [atf, arf, tthtf, tthrf] = qz2af(qz, qxy, ai, edensity, beta, wl);
    atf = -deg2rad(atf); arf = deg2rad(arf); 
    tthtf=deg2rad(tthtf);tthrf=deg2rad(tthrf);
    ai = deg2rad(ai);
    P{2} = angle2pixel(tthtf, atf, 0, ai, detector_angle, SDD, psize);
    P{1} = angle2pixel(tthrf, arf, 0, -ai, detector_angle, SDD, psize);
    % Check the Bragg condition
end

function P = angle2pixel(tthf, af, tthi, ai, detector_angle, SDD, psize)
    vi = [cos(ai).*cos(tthi), cos(ai).*sin(tthi), sin(ai)];
    vf = [cos(af).*cos(tthf), cos(af).*sin(tthf), sin(af)];
    q = (vf-repmat(vi, numel(vf(:,1)), 1))*k0;
    %end
    % find kf vector. v = kf/k0, of which length should be 1 in order to be
    % at the Bragg condition. Otherwise v may be longer or shorter than 1.
    v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
    % calculate kf/|kf| == v
    %v = v./repmat(vectorNorm(v), 1, 3);
    v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);
    P = v2P(v1,v2,v3, detector_angle, SDD, psize);
end    

function P = v2P(v1,v2,v3, detector_angle, SDD, psize)
pitch = detector_angle(1)*pi/180;
yaw = detector_angle(2)*pi/180;
roll = detector_angle(3)*pi/180;
% Rotation matrix
Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
M = Mp*My*Mr;

t = cos(pitch)*cos(yaw)./(cos(pitch)*cos(yaw)*v1+sin(yaw)*v2-sin(pitch)*cos(yaw)*v3);

% x = 1 + t.*cos(tth);
% y = s2th.*sphi.*t;
% z = s2th.*cphi.*t;
x = 1 - t.*v1;
y = -v2.*t;
z = v3.*t;
P = [x, y, z]*M*SDD/psize; % Rotating (x, y, z) onto [0, Y, Z] plane.
res = 1E5;
P = round(P*res)/res;
end
end