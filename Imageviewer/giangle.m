function [tthf, af, xn, yn] = giangle(xn, yn, gisaxs)
% function [tthf, af] = giangle(xn, yn, gisaxs)
% gisaxs is a structure having
% .center, pixelsize, sdd, ai, tthi, tiltangle
%
% here, input xn and yn are the coordinate of pixels
% , which haven't been corrected for the image tilt...
% This function will first inversely rotate xn and yn, and the convert them
% to angles.
% Xsign = 1; Ysign = -1;

    Xsign = 1; Ysign = 1;
    
    if ~isfield(gisaxs, 'tthi')
        gisaxs.tthi = 0;
    end
    if ~isfield(gisaxs, 'psize')
        gisaxs.psize = 1;
    end
    if ~isfield(gisaxs, 'tiltangle')
        gisaxs.tiltangle = 0;
    end

    if isfield(gisaxs, 'Xsign')
        Xsign = gisaxs.Xsign;
    end
    if isfield(gisaxs, 'Ysign')
        Ysign = gisaxs.Ysign;
    end

    nfield = {'center', 'psize', 'SDD', 'ai', 'tthi', 'tiltangle'};
    qfield = isfield(gisaxs, nfield);
    for kk = 1:numel(nfield)
        if ~qfield(kk)
            tthf = [];
            af = [];
            return
            
%            strtmp = sprintf('field : "%s" does not exist in gisaxs, see giangle.m', nfield{kk});
%        	error(strtmp)
        end
    end
            
    xn = xn(:);
    yn = yn(:);
%    if ~isfield(gisaxs, 'center')
%        tthf = [];
%        af = [];
%        return
%    end

if isfield(gisaxs, 'det_angle')
    det_angle = gisaxs.det_angle;% [pitch, yaw, roll]
elseif numel(gisaxs.tiltangle) == 3
    det_angle = gisaxs.tiltangle;
elseif numel(gisaxs.tiltangle) == 1
    det_angle = [0,0,gisaxs.tiltangle];
end
% if gisaxs.tiltangle ~=0
%     det_angle(3) = gisaxs.tiltangle;
% end

%     if gisaxs.tiltangle ~= 0
%         %xold = [xn, yn];
%         [xn, yn] = rot(xn, yn, -gisaxs.tiltangle, gisaxs.center(1), gisaxs.center(2), 1);
%         %sprintf('xn from %i to %i, yn from %i to %i', xold(1), xn, xold(2), yn)
%     end
%    imgs = gisaxs.imgsize;
%    k = find(xn < 1 | xn > imgs(1));xn(k) = [];yn(k) = [];
%    k = find(yn < 1 | yn > imgs(2));xn(k) = [];yn(k) = [];
    t = size(xn);
    ang = pixel2angle([xn(:), yn(:)], gisaxs.center, gisaxs.waveln, gisaxs.SDD, gisaxs.psize, det_angle);
    Xang = ang(:,1);
    Yang = ang(:,2);
    xn = Xsign * (xn - gisaxs.center(1));
    yn = Ysign * (yn - gisaxs.center(2));
    tthf = Xsign * reshape(Xang, t)-gisaxs.tthi;
    af = Ysign * reshape(Yang, t)-gisaxs.ai;
end