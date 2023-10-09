function [cut, P] = linecut_q(img, pnt, mode, saxs, bw)
% linecut from Image to q (With solid angle correction)
% either qxy, qz, or q
% for Bandwith        
wl = saxs.waveln;
    m = 1;
    for k=-bw:bw    
        switch mode
            case 'q'
                saxs.axisofinterest = 'phi';
                [cut0, P0] = linecut_singleline(img, pnt, mode, saxs);
            case {'azim1', 'azim2'} % azimuthal cuts;
                cnt = mean(pnt, 1);
                pix = [pnt(:,1)-cnt(1), pnt(:,2)-cnt(2)];
                R = max(abs(pix(:)));
                pix = pix/R*(R+k)+repmat(cnt, length(pix), 1);
                mode = 'q';
                saxs.axisofinterest = 'phi';
                [cut0, P0] = linecut_singleline(img, pix, mode, saxs);
            case {'qxy', 'h', 'tth'} % Horizontal cuts
                pix = [pnt(1), pnt(2)+k];
                [cut0, P0] = linecut_singleline(img, pix, mode, saxs);
                if mode == 'h'
                    cut0.axisofinterest = 'q';
                    cut0.qxy = sign(cut0.qy).*sqrt(cut0.qx.^2+cut0.qy.^2);
                end
            otherwise         % Vertical cuts
                pix = [pnt(1)+k, pnt(2)];
                [cut0, P0] = linecut_singleline(img, pix, mode, saxs);
                switch mode
                    case 'qz1'
                        cut0.axisofinterest = 'qz';
                    case 'qz2'
                        cut0.axisofinterest = 'qz';
                    case 'v'
                        cut0.axisofinterest = 'q';
                    %cut0.qxy = sign(cut0.qy).*sqrt(cut0.qx.^2+cut0.qy.^2);
                end
        end
        
        xval{m} = cut0.(cut0.axisofinterest);
        yval{m} = cut0.Iq;
        if k == 0
            cut = cut0;
            P = P0;
        end
        m = m+1;
    end
    Nofbw = 2*bw+1;
    Iq = zeros(size(cut.(cut.axisofinterest)));
%    figure(3); hold on;
    for m=1:Nofbw
        xv = real(xval{m});
        yv = real(yval{m});
        try
            ny = interp1(xv, yv, real(cut.(cut.axisofinterest)));
        catch
            [xv, ind] = unique(xv);
            yv = yv(ind);
            ny = interp1(xv, yv, real(cut.(cut.axisofinterest)));
        end
        nanIq = isnan(Iq);
        nanny = isnan(ny);
        if m>1
            bothnan = nanIq & nanny;
            nanIqnonny = nanIq & ~nanny;
            nonIqnanny = ~nanIq & nanny;
            Iq(nanIqnonny) = ny(nanIqnonny)*m;
            ny(nonIqnanny) = Iq(nonIqnanny)/m;
            Iq(bothnan) = NaN;
        end
        Iq = Iq + ny;
%        loglog(cut.(cut.axisofinterest), Iq)
    end
    Iq = Iq/Nofbw;
    cut.Iq = Iq;
    cut.cutResolution = bw;
% --------------------------------------------    

function [cut, P] = readpnts(img, pnt, saxs)
cnt = saxs.center;
sdd = saxs.SDD;
psize = saxs.psize;
ta = saxs.tiltangle;

if numel(ta) == 1
    ta = [0,0,ta];
end
if isfield(saxs, 'edensity')
    ed = saxs.edensity;
else
    ed = 0;
end

cut.X = pnt(:,1);
cut.Y = pnt(:,2);
if isfield(saxs, 'axisofinterest')
    cut.axisofinterest = saxs.axisofinterest;
end
%Iq = interpolate2d(double(img), cut.Y, cut.X);
img = double(img);
if isfield(saxs, 'mask')
    if isfield(saxs, 'qmask')
        if saxs.qmask
            %mask = interpolate2d(double(saxs.mask), cut.Y, cut.X);
%            mask = interp2d(double(saxs.mask), cut.X, cut.Y);
%            Iq = Iq.*mask;
            img = img.*double(saxs.mask);
        end
    end
end
Iq = interp2d(img, cut.X, cut.Y);
%cut.Iq = Iq;


%% solid angle correction (q convertion)
% the following code is from convertCart2q(imgin, saxs)
px = cut.X-cnt(1);
py = cut.Y-cnt(2);
[pixN, delta_sdd] = detector_rotate([px, py], ta);
pixN = [delta_sdd, pixN];
pixN = pixN * psize;
P = sqrt(pixN(:,2).^2+pixN(:,3).^2+(pixN(:,1)+sdd).^2);% distance between sample and a pixel.
psizeX = psize;psizeY = psize;
area = P.^3/sdd/psizeX/psizeY;
area = area/(sdd^2/psizeX/psizeY);
cut.Iq = Iq.*area;

function [cut, P] = linecut_singleline(img, pnt, mode, saxs)
cnt = saxs.center;
sdd = saxs.SDD;
psize = saxs.psize;
ta = saxs.tiltangle;
wl = saxs.waveln;
ai = saxs.ai;
if numel(ta) == 1
    ta = [0,0,ta];
end
if isfield(saxs, 'edensity')
    ed = saxs.edensity;
else
    ed = 0;
end
switch mode
    case 'q'
        pnt = pnt;
    case {'azim1', 'azim2', 'h', 'tth', 'qxy'}
        pnt = [1, pnt(2);saxs.imgsize(2), pnt(2);pnt;[pnt(1)+1, pnt(2)]];
    case {'v', 'qz1', 'qz2', 'v1', 'v2', 'af'}
        pnt = [pnt(1), 1;pnt(1), saxs.imgsize(1);pnt;[pnt(1), pnt(2)+1]];
    otherwise
end
%[ang, pixN] = pixel2angle2(pnt, cnt, sdd, psize, ta);
Pixel = bsxfun(@minus, pnt, cnt);
[tthf, af] = pixel2angles(Pixel, sdd, psize, ta);
ang = [tthf(:), af(:)];

tth = ang(:,1);
alpha = ang(:,2);
af = alpha - ai;

[qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2] = giangle2q(tth, af, 0, ai, saxs);
qxy = sign(qy).*qxy;

%RorT = 2; % 1 for the reflected beam, 2 for the transmitted.
RorT = 1; % 1 for the reflected beam, 2 for the transmitted.
axisofinterest = '';

cutResol = 0;
if isfield(saxs, 'cutResolution')
    cutResol = saxs.cutResolution;
end

switch mode
    case 'q'
        axisofinterest = 'phi';
        cut.phi = 0:1:360;
    case 'azim1'
        q_modulus = q1(3);
        axisofinterest = 'phi';
        cut.phi = 0:1:360;
    case 'azim2'
        q_modulus = q2(3);
        axisofinterest = 'phi';
        cut.phi = 0:1:360;
    case 'qxy'
        if ~cutResol
            cutResol = (qxy(end)-qxy(end-1));
        end
            
        qp = qxy(1):cutResol:qxy(2);qp = qp';
        qz = q1z(3)*ones(size(qp));
        axisofinterest = 'qxy';
    case 'qz1'
        if ~cutResol
            cutResol = (q1z(end)-q1z(end-1));
        end
        qz = q1z(1):cutResol:q1z(2);qz = qz';
        qp = qxy(3)*ones(size(qz));
        axisofinterest = 'qz';
    case 'qz2'
        if ~cutResol
            cutResol = (q3z(end)-q3z(end-1));
        end
        qz = q3z(1):cutResol:q3z(2);qz = qz';
        qp = qxy(3)*ones(size(qz));
        axisofinterest = 'qz';
        %RorT = 1;
    case 'tth'
        if ~cutResol
            cutResol = (tth(end)-tth(end-1));
        end
        qp = tth(1):cutResol:tth(2);qp = qp';
        qz = alpha(3)*ones(size(qp));
        axisofinterest = 'tth';
    case 'af'
        if ~cutResol
            cutResol = (alpha(end)-alpha(end-1));
        end
        qz = alpha(1):cutResol:alpha(2);qz = qz';
        qp = tth(3)*ones(size(qz));
        axisofinterest = 'af';
    case 'h'
        if ~cutResol
            cutResol = (tth(end)-tth(end-1));
        end
        qp = tth(1):cutResol:tth(2);qp = qp';
        qz = alpha(3)*ones(size(qp));
        axisofinterest = 'qxy';
    case 'v'
        if ~cutResol
            cutResol = (alpha(end)-alpha(end-1));
        end
        qz = alpha(1):cutResol:alpha(2);qz = qz';
        qp = tth(3)*ones(size(qz));
        axisofinterest = 'qz';
    otherwise
end

if ~isempty(strfind(mode, '1'))
%    RorT = 2;
    RorT = 1;
elseif ~isempty(strfind(mode, '2'))
%    RorT = 1;
    RorT = 2;
end
tthf = [];
af = [];
switch mode
    case 'q'
        P = pnt;
    case 'azim1'
        cut.qt = q_modulus;
        P = q2pixel(q_modulus, wl, cnt, psize, sdd, ed, [], ai, ta);
    case 'azim2'
        cut.qr = q_modulus;
        P = q2pixel(q_modulus, wl, cnt, psize, sdd, ed, [], ai, ta);
    case {'qxy', 'qz1', 'qz2'}
        [P, tthf, af, q] = q2pixel([qp, qz], wl, cnt, psize, sdd, ed, [], ai, ta);
        if size(q, 2) == 3
            cut.qx = q(:,1);
            cut.qy = q(:,2);
            cut.qz = q(:,3);
        else
            cut.qxy = qp;
            cut.qz = qz;
        end
        cut.qxy = qp;
        cut.tth = tthf;
        cut.af = af;
%         cut.qz = qz;
    case {'tth', 'af'}
        %[P, tthf, af, q] = q2pixel([qp, qz], wl, cnt, psize, sdd, ed, [], ai, ta);
        P = pixel2angle([qp, qz], cnt, wl, sdd, psize, ta, 1);
        %P = P + cnt;
        P = bsxfun(@plus, P, cnt);
        q = pixel2qv(P, cnt,sdd,psize,ta,ai,0,saxs);
        tthf = qp;
        af = qz-ai;
        cut.qx = q.qx;
        cut.qy = q.qy;
        cut.qz = real(q.qz);
        cut.tth = tthf;
        cut.af = af;
        qp = q.qxy;
        qz = q.q1z;
    case {'h', 'v'}
        %[P, tthf, af, q] = q2pixel([qp, qz], wl, cnt, psize, sdd, ed, [], ai, ta);
        P = pixel2angle([qp, qz], cnt, wl, sdd, psize, ta, 1);
        %P = P + cnt;
        P = bsxfun(@plus, P, cnt);
        q = pixel2qv(P, cnt,sdd,psize,ta,ai,0,saxs);
        tthf = qp;
        af = qz-ai;
        cut.qx = q.qx;
        cut.qy = q.qy;
        cut.qz = real(q.qz);
        cut.tth = tthf;
        cut.af = af;
        qp = q.qxy;
        qz = q.q1z;
        cut.q = sqrt(qp.^2+qz.^2);
end
if iscell(P)
    cut.X = P{RorT}(:,1); % transmitted beam X
    cut.Y = P{RorT}(:,2); % transmitted beam Y
    if ~isempty(tthf)
        if iscell(tthf)
            cut.tthf = tthf{RorT};
        else
            cut.tthf = tthf;
        end
        if iscell(af)
            cut.af = af{RorT};
        else
            cut.af = af;
        end
    end
else
    cut.X = P(:,1);
    cut.Y = P(:,2);
    if ~isempty(tthf)
        cut.tthf = tthf;
        cut.af = af;
    end
end

cutResol = 0;
if isfield(saxs, 'cutResolution')
    cutResol = saxs.cutResolution;
end
cut.cutResolution = cutResol;
cut.axisofinterest = axisofinterest;

cut.P = P;
saxs.cutResolution = cutResol;

[cut0, P] = readpnts(img, [cut.X, cut.Y], saxs);
cut.Iq = cut0.Iq;
%cut.P = P;