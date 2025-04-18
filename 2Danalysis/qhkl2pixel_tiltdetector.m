function [P, TTHF, AF, qv] = qhkl2pixel_tiltdetector(q_modulus, azimangle, detector_angle, SDD, psize, wl, edensity, ai)
% [P, tthf, af, q] = q2pixel_tiltdetector(q*, azimangle, detector_angle, SDD, 
%   psize, wl, [edensity, beta, ai])
% where q* is the q values of hkl(s).
%
% This software will find Bragg angles, with which q* will be on the Ewald
% sphere and calculate the pixel positions on 2D detector.
% q*y and q*z are the y and z components of q*, when q*y and q*z are given, 
% software assumes that it is 2D powder and find q*x to get them on the 
% Ewald sphere. 
% Input:
%   q2pixel(q*, azimangle, ...) : Only for 3D powder.
%   q2pixel([q*y, q*z], [], ...)
%   q2pixel([q*xy, q*z], 'qxy', ...)
%   q2pixel([q*x, q*y, q*z], [], ...) : If not on Ewald sphere, will rotate
%   around Z axis to find the corresponding qvector on Ewaldsphere.
%   q2pixel([tthf, af, tthi, ai], [],...): if ai not zero, two sets returns.
%   q2pixel([q*y, q*z], [], ..., edensity, beta, ai, tthi): refraction will be
% corrected.
%
% output
%   P : [pixelX, pixelY] for T and/or R
%   TTHF : tthf angle
%   af : af angle
%   qv : [qx, qy, qz] vector.
%
% When the electron density is given with [q*xy and q*z], it will assume
% that 2D powder diffraction with refraction.
%


% When q is given, this will find a peak position on a detector that may be
% tilted.
% First, for a given q*, one should check whether it is on a Ewald sphere or
% not. In other word, the q* should be in the Bragg condition.
% When 3D powder is given, no need to check the Bragg condition.
% When 2D powder is given, for instance, q* = [q*xy, q*z],
% Don't get confused by the notation q*, which should have been written as
% qHKL that is the qvalue of the HKL peak.
% When the scattering vector q=(qx, qy, qz) is concerned, q vector is
% always on the Ewald sphere.
% 
% In order to bring q* onto the Ewald sphere, the reciprocal space needs to
% be rotated, which requires to know how to rotate the reciprocal space.
% This software deals with 3D powder, 2D powder, and single crystal
% orientation.
% For 3D powder, q of q* will be calculated with [q* and azimuthal angle].
%   This will give kf vector (kf = q+ki). 
% The position of a diffraction peak on a detector is essentially the point
% where a line (whose vector is kf and passing [-SDD, 0, 0]) meets a plane
% (of which normal vector is [1,0,0] for nontilted and passing [0,0,0]).
% So it becomes purely geometry problem.
%   So this software will try to find the kf vector for a given q* peak.
%
% For 2D powder, 
%   (qx + k0)^2+qy^2+qz^2=k0^2
%   qx^2+qy^2=q*xy^2
%   qz = q*z
%   From these, qx = -1/(2k0)*(q*xy^2+q*z^2), qy=+-sqrt(q*xy^2-qx^2);
%   qz=q*z;
% For a single crystal,
%   When a q vector(q* = (q*x, q*y, q*z)), is given, the software will not
%   rotate the crystal, but checking whether q* is on the Ewald sphere. It
%   will return the pixel position of peaks that are only on the Ewald
%   sphere.
% If a given q is not on the Bragg condition, [NaN,NaN,NaN] will be returned.
% 
% In addition, [tthf, af, tthi, ai] can be given.
%   , where all these angles are assumed refraction corrected if any.
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
        if (edensity>0) || (ai>0)
            isrefraction = 1;
        end
    end
    if nargin < 7
        edensity = 0;
        ai = 0;
    end

    if (edensity==0) && (ai==0)
        is3dpowder = 1;
    else
        is3dpowder = 0;
    end

    if isangle2pixel
        %elseif size(q_modulus, 2) == 4 % for cartesian angles
        % if q_modulus = [tthf, af, tthi, ai]
        tthf = q_modulus(:,1)*pi/180;
        af = q_modulus(:,2)*pi/180;
        tthi = q_modulus(:,3)*pi/180;
        ai = q_modulus(:,4)*pi/180;% because typically ai's sign is opposite
            % for instance GISAXS, ai is mostly negative, but it is
            % presented positive in most of case. Or at lease the sign of
            % ai and af should be opposite because one goes up and the
            % other goes down. However, normally ai and af are presented
            % with the same sign.
        for k=1:2
            ai = abs(ai)*(-1)^(k);
            %pixel = angle2pixel(tthf, af, tthi, ai, detector_angle, SDD, psize, wl);
            pixN = angles2pixN(tthf+tthi, af+ai, wl, SDD, psize, detector_angle);
            pixel = pixN2Pixel(pixN, detector_angle);
            if ai==0
                P = pixel;
                TTHF = tthf;
                AF = af;
                return
            else
                P{k}=pixel;
                TTHF{k}=tthf;
                AF{k} = af;
            end
        end        
        %
        return;
    end

%else % for either 2D powder or single crystals.
%if is3dpowder
is3Dpowder = 0;
    if ~isempty(azimangle)  % for 3D powder
        if ~ischar(azimangle)
            is3Dpowder = 1;
        end
    end
    if is3Dpowder
        qv = q_powder2qv(q_modulus, wl, azimangle);
%         tth = 2*asin(q_modulus(:)*wl/4/pi);
%         phi = azimangle(:)*pi/180;
%         v1 = -abs(1-cos(tth));
%         if numel(v1) == 1
%             v1 = v1*ones(size(phi));
%         end
%         v3 = -sin(tth).*sin(phi);
%         v2 = sin(tth).*cos(phi);
%         q = k0*[v1, v2, v3];
% 
%         % find kf vector. v = kf/k0, of which length should be 1 in order to be
%         % at the Bragg condition. Otherwise v may be longer or shorter than 1.
%         v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
%         % calculate kf/|kf| == v
%         %v = v./repmat(vectorNorm(v), 1, 3);
%         v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);
    else
        if size(q_modulus,2)==3 % for a single crystal.
            % The input, q_modulus should be [qx, qy, qz] and phi = [];
            qv = q_modulus;
            
%             q = q_modulus;
%             %checking the Bragg condition
%             t = q(:,1)^2+2*k0*q(:,1)+q(:,2).^2+q(:,3).^2 ~=0;
%             q(t,1) = NaN;
        elseif size(q_modulus,2)==2 % for a 2D powder
            % the input, q_modulus should be [qy, qz] and phi = []; 
            if ~isempty(azimangle)
                qxy = q_modulus(:,1); qz = q_modulus(:,2);
                qx = -1*(qz.^2+qxy.^2)/(2*k0);
                sgn = sign(qxy);sgn(sgn==0) = 1;
                qy = sgn.*sqrt(qxy.^2-qx.^2); 
            % Check the Bragg condition
                t = qxy.^2<qx.^2;qy=real(qy);
                qy(t)=NaN;% If not, on the Bragg condition, qy<-NaN
            else
                qy = q_modulus(:,1); qz = q_modulus(:,2);
                qx = -1*(qz.^2-qy.^2)/(2*k0);
            end
            qv = [qx, qy, qz];
%             qxy = sign(qy).*sqrt(qx.^2 + qy.^2);
% %             qxy_ = sign(qy).*sqrt(qx.^2 + qy.^2);
% %             t = abs(qxy_)-abs(qxy)>0.0001;
% %             if numel(t) > 0
% %                 qx(t) = NaN;
% %                 qy(t) = NaN;
% %                 qz(t) = NaN;
% %                 q = [qx, qy, qz];
% %                 cprintf('err', 'q values that are not in the detector plane are found\n');
% %             end
        end
        % find kf vector. v = kf/k0, of which length should be 1 in order to be
        % at the Bragg condition. Otherwise v may be longer or shorter than 1.
%         v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
%         % calculate kf/|kf| == v
%         %v = v./repmat(vectorNorm(v), 1, 3);
%         v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);
    end

    % refraction needs to be corrected...
    if ~isrefraction %convert q to pixel
        pixN = qv2pixel(qv, wl, SDD, psize, detector_angle);
        P = pixN2Pixel(pixN, SDD, psize, detector_angle);
        %P(:,1) = [];
        [TTHF, AF] = pixN2angles(pixN);
% %         P = v2P(v1,v2,v3, detector_angle, SDD, psize);
% %         [tthf, af] = v2angle(v1, v2, v3);
        return
    else
        if ~isempty(azimangle)
            qxy = sign(qv(:,2)).*sqrt(qv(:,1).^2+qv(:,2).^2); 
            qz = qv(:,3);
            % these are q*xy and q*z or tilde_q*xy and tilde q*z for film.
        elseif size(q_modulus,2)==2 % for a 2D powder
                    % if q_modulus = [qxy, qz] and phi = []; 
            qxy = q_modulus(:,1); 
            qz = q_modulus(:,2);
        end
        % qz2af will correct 1) the refraction for q*z and 2) find the qxy
        % value of q*xy. Therefore returns tthf and af values on a point in the
        % Ewald sphere.
        ai = ai*pi/180;
        r0 = 2.82E-5;
        n = 1-1/(2*pi)*r0*wl^2*edensity;
% snell's law
%         ai_ref = asin(1/n*sin(ai));
%         pixN = qv2pixel(qv, wl, sdd, psize, detector_angle);
%         [TTHF, AF] = pixN2angles(pixN);
%          refract AF
%         alpha = AF_ref - ai_ref;
%         alpha = AF_ref + ai_ref;
%            pixN = angles2pixel(tthf, af, wl, sdd, psize, detector_angle);
        for i=1:2
            q = qrefracted((-1)^(i+1), qxy, qz, k0, n, ai);
%             v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
%                 % calculate kf/|kf| == v
%                 %v = v./repmat(vectorNorm(v), 1, 3);
%             v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);    
%             P{i} = v2P(v1,v2,v3, detector_angle, SDD, psize);
            pixN = qv2pixel(q, wl, SDD, psize, detector_angle);
            Pix = pixN2Pixel(pixN, SDD, psize, detector_angle);
            [tthf, af] = pixN2angles(pixN);
%            [tthf, af] = v2angle(v1, v2, v3);
            TTHF{i}=tthf;
            AF{i} = af;
            P{i} = Pix;
        end
    end
end

%     function P = angle2pixel(tthf, af, tthi, ai, detangle, SDD, psize, wl)
%         pixN = angles2pixel(tthf+tthi, af+ai, wl, SDD, psize, detangle);
%         P = pixN(:,2:3);
% %         vi = [cos(ai).*cos(tthi), cos(ai).*sin(tthi), sin(ai)];
% %         vf = [cos(af).*cos(tthf), cos(af).*sin(tthf), sin(af)];
% %         %q = (vf-repmat(vi, numel(vf(:,1)), 1))*k0;
% %         q = (vf-vi)*k0;
% %         %end
% %         % find kf vector. v = kf/k0, of which length should be 1 in order to be
% %         % at the Bragg condition. Otherwise v may be longer or shorter than 1.
% %         v = q/k0 + repmat([1, 0, 0], size(q,1), 1);
% %         % calculate kf/|kf| == v
% %         %v = v./repmat(vectorNorm(v), 1, 3);
% %         v1 = v(:,1);v2 = v(:,2);v3 = v(:,3);
% %         P = v2P(v1,v2,v3, detector_angle, SDD, psize);
%     end    
% 
%     function P = v2P(v1,v2,v3, detector_angle, SDD, psize)
%         % Center of rotation of the detector plane is at [0, 0, 0];
%         %   The detector plane includes [0, 0, 0]
%         % The vector of the x-ray beam (kf vector) is k0*[v1, v2, v3]
%         %   The ray passes [-SDD, 0, 0]
%         % P is the pixel position (not real scale distance)
%         pitch = detector_angle(1)*pi/180;
%         yaw = detector_angle(2)*pi/180;
%         roll = detector_angle(3)*pi/180;
%         % Rotation matrix
%         Mp = [cos(pitch), 0, sin(pitch); 0, 1, 0; -sin(pitch), 0, cos(pitch)];
%         My = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0, 0, 1];
%         Mr = [1, 0, 0; 0, cos(roll), -sin(roll);0, sin(roll), cos(roll)];
%         M = Mp*My*Mr;
% 
%         t = cos(pitch)*cos(yaw)./(cos(pitch)*cos(yaw)*v1+sin(yaw)*v2-sin(pitch)*cos(yaw)*v3);
% 
%         % x = 1 + t.*cos(tth);
%         % y = s2th.*sphi.*t;
%         % z = s2th.*cphi.*t;
%         x = 1 - t.*v1;
%         y = v2.*t;
%         z = v3.*t;
%         P = [x, y, z]*M*SDD/psize; % Rotating (x, y, z) onto [0, Y, Z] plane.
%         res = 1E5;
%         P = round(P*res)/res;
%     end

    function qnew = qrefracted(signofki, qxy, qz, k0, n, ai)
        % sigofki = -1 for the reflected beam for ai>0
        % sigofki = 1 for the transmitted beam for ai>0
        qx = -1/(2*k0)*(qxy.^2+qz.^2);
        qy = sign(qxy).*sqrt(qxy.^2-qx.^2);
        m = n^2-cos(ai)^2;
        if m<0 % when the incident angle is below the critical angle
            % x-ray beam cannot penerate to the film.
            % Then, it follow the surface. Therefore tilde_alpha_i = 0.
            m = 0;
        end
        vtildef = qz/k0+signofki*sqrt(m);
        % vtildef = k_tilde_f/k0;
        af = sign(vtildef).*acos(sqrt(n^2-vtildef.^2)); % in radian
        qnz = k0*(sin(af)+sin(ai));
         qnx = -1/(2*k0)*(qxy.^2+qz.^2); %wrong
%        qnx = sqrt(k0^2-qnz.^2)-k0; % qnx will change according to qnz so that it can cut the ewald sphere.
        % for 2D powder.... So that there will be qy having NaN.
        % qxy^2=qx^2+qy^2
        qny = sign(qxy).*sqrt(qxy.^2 - qnx.^2); %this is wrong.
%        qny = qy;   % qy is free from refraction.
%        qny = real(qny);
        qnew = [qnx, qny, qnz];
    end

%     function [tthf, af] = v2angle(v1, v2, v3)
%         % unit vector into two cartesian angles.
%         tthf = atan(v2./v1);
%         af = atan(v3./sqrt(v1.^2+v2.^2));
%     end
%     function v = angle2v(tthf, af)
%         % Two cartensian angles to a unit vector.
%         v1 = cos(af).*cos(tthf);
%         v2 = cos(af).*sin(tthf);
%         v3 = sin(af);
%         v = [v1, v2, v3];
%     end
% end