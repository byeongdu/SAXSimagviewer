function [img,area] = convertGI2cart(imgin, saxs)
%% 
psize = saxs.psize;
SDD = saxs.SDD;
BC = saxs.center;
ai = saxs.ai*pi/180; % incident angle in radian.
if numel(saxs.tiltangle)>1
    tiltang = saxs.tiltangle(3);
else
    tiltang = saxs.tiltangle;
end

if numel(psize)==1
    psizeX = psize;
    psizeY = psize;
else
    psizeX = psize(1);
    psizeY = psize(2);
end
%%
sizeImg=size(imgin);
imgin = double(imgin);
img = zeros(size(imgin));

ang = tiltang*pi/180;
R = [cos(ang), sin(ang); -sin(ang), cos(ang)];

y = 1:sizeImg(1);
x = 1:sizeImg(2);
% Perform coordinate conversion.
convertP2P % convert x(new pixel) to xx (old pixel) and y to yy
res = interp2d(double(imgin), yy, xx);
%res = interpolate2d(double(imgin), yy, xx);
img(realindx) = res;
img = reshape(img, size(imgin));

% Area correction. % area of pixel changed due to the transform.
xo = x; yo = y;
x = xo-1/2;y=yo-1/2; 
convertP2P; P1 = Pixel; P1realindx = realindx;
x = xo-1/2;y=yo+1/2; 
convertP2P; P2 = Pixel; P2realindx = realindx;
x = xo+1/2;y=yo+1/2; 
convertP2P; P3 = Pixel; P3realindx = realindx;
x = xo+1/2;y=yo-1/2; 
convertP2P; P4 = Pixel; P4realindx = realindx;
area = ones(size(img));
realindx = logical(P1realindx.*P2realindx.*P3realindx.*P4realindx);
%realindx = intersect(P1realindx, P2realindx);
%realindx = intersect(realindx, P3realindx);
%realindx = intersect(realindx, P4realindx);
X = [P1(1, realindx);P2(1, realindx);P3(1, realindx);P4(1, realindx)];
Y = [P1(2, realindx);P2(2, realindx);P3(2, realindx);P4(2, realindx)];
area(realindx) = polyarea(X, Y);

img = img.*area;

function convertP2P
%% Strategy of conversion.
[X, Y]= meshgrid(x,y); % X and Y are the coodinates of new image.
% In the image X, put X pixel coordinate of old image.
% In the image Y, put Y pixel coordinate of old image.
% Then calculate the angles for X and Y.
a = atan((Y-BC(2))*psize/SDD);
af = a-ai; % exit angle in radian
% Using the following Bragg equation, calculate tan(tthf).
% By multiplying SDD/psize to tan(tthf), we can get Pixel positions.
% Therefore for instance X(1,1)'s value will be corresponding X coordinate
% of the original image.
% For new image, qxy = 2 k0 sin(tthf/2) and qz = k0 * (sin(af) + sin(ai)).

% Note that, for the old image, qxy =
% k0*sqrt((cos(af)*cos(tthf)-cos(ai))^2+(cos(af)*sin(tthf))^2),
% which is essentially the Bragg equation in GI configuration.

%% Derivation.
% qx/k0 = cos(af)*cos(tthf)-cos(ai) ---------- (1)
% qy/k0 = cos(af)*sin(tthf)         ---------- (2)  
% qz/k0 = sin(af)+sin(ai)           ---------- (3)
% Therefore, 
% (qxy/k0)^2 = cos(ai)^2+cos(af)^2-2*cos(ai)cos(af)*cos(tthf) ---- (4)
caiafp = cos(ai)^2+cos(af).^2;
caiaf = 2*cos(ai)*cos(af);
% (qxy/k0)^2 = caiafp-caiaf*cos(tthf)

% sin2af2 = sin(1/2*tthf)^2 = (qxy*wl/(4*pi))^2 = (qxy/(2k0))^2 ---- (5)
% Therefore, 4*sin2af2 = (qxy/k0)^2; ------------------------------- (6)
sin2af2 = sin(1/2*atan((X-BC(1))/SDD*psizeX)).^2;

c = caiafp-4*sin2af2;
% from (4) and (6), c = 2*cos(ai)cos(af)*cos(tthf)------------------ (7)
Px = caiaf.*sqrt(1-(c./caiaf).^2)./c;
% from (7) and definition of caiaf
% Px = 2*cos(ai)*cos(af)*sqrt(1-cos(tthf)^2)/(2*cos(ai)cos(af)*cos(tthf))
%    = sin(tthf)/cos(tthf)
%    = tan(tthf)    ------------------------------------------------ (8)
realindx = 1>=(c./caiaf).^2;
sX = sign(X-BC(1));
Px = sX(:).*Px(:)*SDD/psizeX + BC(1);
% Now the Px contains X pixel coordinates of original image.

Py = Y(:);
Pixel = R*[Px'-BC(1); Py'-BC(2)];
Pixel(1,:) = Pixel(1,:) + BC(1);
Pixel(2,:) = Pixel(2,:) + BC(2);

xx = Pixel(1, realindx);
yy = Pixel(2, realindx);
end
end