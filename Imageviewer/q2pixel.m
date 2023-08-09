function [rtn, tthf, af, q] = q2pixel(varargin)
% This is a function to find pixel position of a diffraction peak qhkl
% If a peak cannot be on Laue condition, it will spit out NaN.
%
% for 2D powder, provide [qy, qz] components of qhkl. Then this software
% will calculate the kf vector and q vector for the condition that qhkl is
% on the Ewald sphere and returns associated angles and pixel positions.
% 
% for transmission SAXS
%    [px, py] = q2pixel(q, waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
%    [px, py] = q2pixel([q, 0, azim], waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
%    [px, py] = q2pixel([qy, qz], waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
% for GISAXS
%    [px, py] = q2pixel([qy, qz], waveln, [beamx, beamy], pixelsize, sdd, edensity, beta, ai, tiltangle*)
% see also qhkl2pixel_tiltdetector, which can be used for many other cases.

if size(varargin{1},2)==2
    qp = varargin{1}(:,1);
    qz = varargin{1}(:,2);
    azim = [];
elseif size(varargin{1},2)==1
    q = varargin{1}(:,1);
    %azim = 0:pi/100:2*pi;
    %azim = azim*180/pi;
    azim = 0:1:360;
    qz = [];
elseif size(varargin{1},2) == 3
    q = varargin{1}(:,1);
    azim = varargin{1}(:,3);
    qz = [];
end
waveln = varargin{2};
center = varargin{3};
pixelsize =varargin{4};
sdd =varargin{5};

%q2pixel_tiltdetector(q_modulus, azimangle, detector_angle, SDD, pixelsize, wl, edensity, beta, ai)
if numel(varargin) < 8
    isSAXS = 1;
else
    isSAXS = 0;
end

if isSAXS
    if numel(varargin) < 6
        tiltang = [0 0 0];
    else
        if ~isempty(varargin{6})
            tiltang = varargin{6};
        end
    end
else
    if ~isempty(varargin{9})
        tiltang = varargin{9};
    end
end

if numel(tiltang) == 1
    detector_tiltangle = [0,0,tiltang];
else
    detector_tiltangle = tiltang;
end

if isempty(qz)
    qp = q.*cos(deg2rad(azim));
    qz = q.*sin(deg2rad(azim));
end

if isSAXS
    if isempty(azim)
        [af, ~, tthf, ~] = qz2af(qz, qp, 0, 0, 0, waveln);
        t = isLaue([qp(:), qz(:)], [2*pi/waveln, 0, 0]);
        af(~t) = NaN;
        tthf(~t) = NaN;
        a = angles2pixel(tthf, af, waveln, sdd, pixelsize, detector_tiltangle);
    else
        [a, tthf, af, q] = qhkl2pixel_tiltdetector(q, azim, detector_tiltangle, sdd, pixelsize, waveln);
    end
    
%    [a, tthf, af] = qhkl2pixel_tiltdetector([qp, qz], [], detector_tiltangle, sdd, pixelsize, waveln);
    rtn = a(:,1:2)+repmat(center, numel(a(:,1)), 1);
else

    edensity = varargin{6};
    %beta = varargin{7};
    ai = varargin{8};
    if isempty(azim)
        [af1, af2, tth1, tth2] = qz2af(qz, qp, ai, edensity, 0, waveln);
        t = isLaue([qp(:), qz(:)], [2*pi/waveln, 0, 0]);
        af1(~t) = NaN;
        tth1(~t) = NaN;
        af2(~t) = NaN;
        tth2(~t) = NaN;
        a{1} = angles2pixel(tth1, af1+ai, waveln, sdd, pixelsize, detector_tiltangle);
        a{2} = angles2pixel(tth2, af2+ai, waveln, sdd, pixelsize, detector_tiltangle);
        tthf{1} = tth1;
        tthf{2} = tth2;
        af{1} = af1;
        af{2} = af2;
        q = [qp(:), qz(:)];
%        [a, tthf, af, q] = qhkl2pixel_tiltdetector([qp, qz], [], detector_tiltangle, sdd, pixelsize, waveln, edensity, ai);
    else
        [a, tthf, af, q] = qhkl2pixel_tiltdetector(q, azim, detector_tiltangle, sdd, pixelsize, waveln, edensity, ai);
    end
%     t = isLaue([qp(:), qz(:)], [2*pi/waveln, 0, 0]);
%     af(~t) = NaN;
%     tthf(~t) = NaN;
   
    if iscell(a)
        rtn{1} = real(a{1}(:,1:2)) + repmat(center, numel(a{1}(:,1)), 1);
        rtn{2} = real(a{2}(:,1:2)) + repmat(center, numel(a{2}(:,1)), 1);
    else
        rtn{1} = real(a(:,1:2)) + repmat(center, numel(a(:,1)), 1);
        rtn{2} = real(a(:,1:2));
    end

end