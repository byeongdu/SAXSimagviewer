function rtn = qimg2pixel(varargin)
% This is a function to convert q in image coordinae qimg(qXY,qZ) into pixel.
% This does not check whether the qimg is in Laue condition or not.
%
% for transmission SAXS
%    [px, py] = q2pixel(q, waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
%    [px, py] = q2pixel([q, 0, azim], waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
%    [px, py] = q2pixel([qx, qy], waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
%    [px, py] = q2pixel([qx, qy, qz, 0], waveln, [beamx, beamy], pixelsize, sdd, tiltangle*)
% for GISAXS
%    [px, py] = q2pixel(q, waveln, [beamx, beamy], pixelsize, sdd, edensity, beta, ai, tiltangle*)
%    [px, py] = q2pixel([q, 0, azim], waveln, [beamx, beamy], pixelsize, sdd, edensity, beta, ai, tiltangle*)
%    [px, py] = q2pixel([qy, qz], waveln, [beamx, beamy], pixelsize, sdd, edensity, beta, ai, tiltangle*)
%    [px, py] = q2pixel([qx, qy, qz, 0], waveln, [beamx, beamy], pixelsize, sdd, edensity, beta, ai, tiltangle*)
%
% see also qhkl2pixel_tiltdetector, which can be used for many other cases.
% See also q2pixel.m and qv2pixel.m
%
% Byeongdu Lee

waveln = varargin{2};
center = varargin{3};
pixelsize =varargin{4};
sdd =varargin{5};
k0 = 2*pi/waveln;

if size(varargin{1},2)==2
    qp = varargin{1}(:,1);
    qz = varargin{1}(:,2);
    azim = [];
elseif size(varargin{1},2)==1
    q = varargin{1}(:,1);
    azim = 0:1:360;
    qz = [];
elseif size(varargin{1},2) == 3
    q = varargin{1}(:,1);
    azim = varargin{1}(:,3);
    qz = [];
elseif size(varargin{1},2) == 4
    qx = varargin{1}(:,1);
    qy = varargin{1}(:,2);
    qz = varargin{1}(:,3);
    q = sqrt(qx.^2+qy.^2+qz.^2);
    qp = sqrt(qx.^2+qy.^2);
    q0 = k0.*sin(pi-2*acos(q/(2*k0)));
    azim = azimang(qp, qz, 0, 0);
    %qy = q0*cos(azim);
    qz = q0*sin(azim);
    qp = q0*cos(azim);
end

%q2pixel_tiltdetector(q_modulus, azimangle, detector_angle, SDD, psize, wl, edensity, beta, ai)
if numel(varargin) < 8
    isSAXS = 1;
else
    isSAXS = 0;
end

if isSAXS
    if ~isempty(varargin{6})
        tiltang = varargin{6};
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
   
    tthf = rad2deg(asin(qp/k0));
    af = rad2deg(asin(qz/k0));
    a = angles2pixel(tthf, af, waveln, sdd, pixelsize, detector_tiltangle);

%    [a, tthf, af] = qhkl2pixel_tiltdetector(q, th, detector_tiltangle, sdd, pixelsize, waveln);
    rtn = a(:,1:2)+repmat(center, numel(a(:,1)), 1);
    
else

    edensity = varargin{6};
    %beta = varargin{7};
    ai = varargin{8};
    [af1, af2, tth1, tth2] = qz2af(qz, qp, ai, edensity, 1E-6, waveln);
    m = angles2pixel(tth1, af1+ai, waveln, sdd, pixelsize, detector_tiltangle);
    a{1} = m;
    m = angles2pixel(tth2, af2+ai, waveln, sdd, pixelsize, detector_tiltangle);
    a{2} = m;
    if iscell(a)
        rtn{1} = real(a{1}(:,1:2)) + repmat(center, numel(a{1}(:,1)), 1);
        rtn{2} = real(a{2}(:,1:2)) + repmat(center, numel(a{2}(:,1)), 1);
    else
        rtn{1} = real(a(:,1:2)) + repmat(center, numel(a(:,1)), 1);
        rtn{2} = real(a(:,1:2));
    end
end