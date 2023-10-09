function [Qv, DATA] = construct_RecpSpace_fromImgMtrx(inp_data, saxs, ROIX, ROIY, qN, qmax)
% inp_data.img_mtrx
% inp_data.phi
% inp_data.norm_factor
% inp_data.mask
% inp_data.isfliped
% inp_data.background
% inp_data.gen_back
%
% mask = double(mask_org(ROIY, ROIX));
% img_mtrx(:,:,n) = img(ROIY, ROIX);
if nargin < 5
    qN = [];
end
if nargin < 6
    qmax = [];
end
if isempty(qN)
    qN = 400;
end

% Loading data
dim_img_mtrx = size(inp_data.img_mtrx);
N_img = dim_img_mtrx(3);

if isfield(inp_data, 'phi')
    phi = inp_data.phi;
else
    phi = 0:N_img-1;
end
if isfield(inp_data, 'norm_factor')
    norm_factor = inp_data.norm_factor;
else
    norm_factor = ones(1, N_img);
end
if isfield(inp_data, 'isfliped')
    isfliped = inp_data.isfliped;
else
    isfliped = false;
end
if isfield(inp_data, 'background')
    background = inp_data.background;
    if isfliped
        background = flipud(background);
    end
else
    background = [];
end

%% Setup information
center = saxs.center;
waveln = saxs.waveln;
psize = saxs.psize;
SDD = saxs.SDD;
saxs.edensity = 0;
saxs.beta = 0;

% reset values..
saxs.tthi = 0;
saxs.ai = 0;
saxs.center = [0, 0];

%% img ROI
% ROIX = 250:1450;
% ROIY = 200:900;
% background = 35;

%% Coordinates of an image
% laboratory coordinates
[Y, Z] = meshgrid(ROIX, ROIY);
if isfliped
    Z = flipud(Z);
end

Ym = Y - center(1);
Zm = Z - center(2);
Zm = Zm(:);
Ym = -Ym(:);  % for the right hand coordination system. 
% in the right hand coordination system, phi direction is counter clockwise
% direction when viewed from top.

img_sum = zeros(size(Y));


% default q max.
if isempty(qmax)
    saxs.tthi = 0;
    q = pixel2qv([Ym(:), Zm(:)], saxs);
    qx = q.qx;
    qy = q.qy;
    qp = sqrt(qx.^2 + qy.^2);
    qp = qp(:);
    qmax = max(qp);
end

%% Contruct the volumetric data cell
qxN = qN;

qxmin = -qmax;
qxmax = qmax;
deltaq = (qxmax - qxmin)/qxN;
qymin = qxmin;
qzmin = qxmin;
if ~isfield(saxs, 'pxQ')
    saxs.pxQ = 4*pi/saxs.waveln*sin(1/2*atan(saxs.psize/saxs.SDD));
end
if ~isfield(saxs, 'tiltangle')
    saxs.tiltangle = 0;
end
if deltaq < saxs.pxQ
    deltaq = saxs.pxQ;
    qxN = fix((qxmax - qxmin)/deltaq);
    fprintf('Number of voxels reduced to %i due to the experimental resolution.\n', qxN);
end
if rem(qxN, 2)==0
    qxN = qxN+1;
end

x = linspace(qxmin, qxmax, qxN);
y = linspace(qxmin, qxmax, qxN);
z = linspace(qxmin, qxmax, qxN);
z(z<qzmin) = [];
qzN = numel(z);

[qx0, qy0, qz0] = ndgrid(x, y, z);
DATA = zeros(size(qx0));
Npnt = DATA;
clear x y z
%% Process data
if isfield(inp_data, 'mask')
    mask = inp_data.mask;
    if isfliped
        mask = flipud(mask);
    end
%     m = diff(mask(:, 1));
%     up = find(m == 1);
%     down = find(m == -1);
%     if (down(1)-up(1))>18
%         up(1) = [];
%     end
%     m = diff(mask(down(1)-1, :));
%     h_up = find(m == 1);
%     h_down = find(m == -1);
%     if (h_down(1)-h_up(1))>18
%         h_up(1) = [];
%     end
else
    mask = [];
end
    
isgen_back = 0;
if isfield(inp_data, 'gen_back')
    isgen_back = inp_data.gen_back;
end
if isgen_back
    qmap = sqrt(Ym.^2+Zm.^2);
    qindex = 0:1:(max(qmap(:))+1);
end
DATA = DATA(:);
DATA_num = numel(DATA);
for ind=1:1:N_img
    saxs.tthi = phi(ind);
    % Loading an image.
    img = inp_data.img_mtrx(:,:,ind);
    if isfliped
        img = flipud(img);
    end
    img = double(img);

    if ~isempty(background)
        img = img - background;
    end
    if isgen_back
        [qv, Iq] = azimavg(img, qmap, qindex, 1, [], [], mask);
        back = interp1(qv, Iq, qmap(:));
        back = reshape(back, size(img));
        img = img - back;
    end

    % Calculate q maps.
    [q, AreaFactor] = pixel2qv([Ym(:), Zm(:)], saxs);
    qx = q.qx;
    qy = q.qy;
    qz = q.qz;
    
    
    % Normalize "img" for each phi
    img = img/norm_factor(ind);
    img = img./reshape(AreaFactor, size(img));
    
%     % Filling the Pilatus Mask Gaps by interpolating along Z direction. 
%     if ~isempty(mask)
%         for i=1:numel(up)
%             for j=(down(i)+1):(up(i))
%                 f = abs((j-down(i))/(up(i)-down(i)));
%                 img(j, :) = f*img(up(i)+1, :) + (1-f)*img(down(i)-1, :);
%             end
%         end
%         for i=1:numel(h_up)
%             for j=(h_down(i)+1):(h_up(i))
%                 f = abs((j-h_down(i))/(h_up(i)-h_down(i)));
%                 img(:,j) = f*img(:, h_up(i)+1) + (1-f)*img(:, h_down(i)-1);
%             end
%         end    
%     end
%     
%     img_sum = img_sum + img;
   

    % Convert q values into indices of qmap matrix.
    qxI = fix((qx-qxmin)/deltaq)+1;
    qyI = fix((qy-qymin)/deltaq)+1;
    qzI = fix((qz-qzmin)/deltaq)+1;
    qxI2 = fix((-qx-qxmin)/deltaq)+1;
    qyI2 = fix((-qy-qymin)/deltaq)+1;
    qzI2 = fix((-qz-qzmin)/deltaq)+1;
    % Remove points that are out of the qmap matrix.
    t = qxI>qxN | qxI < 1 | qyI > qxN | qyI < 1 | qzI > qzN | qzI < 1;
    t =  t | qxI2>qxN | qxI2 < 1 | qyI2 > qxN | qyI2 < 1 | qzI2 > qzN | qzI2 < 1; 
    t = t | ~isreal(qzI);
    t = t | ~isreal(qzI2);
    t = t | (mask(:) < 1);
    img(t) = [];
    qxI(t) = [];
    qyI(t) = [];
    qzI(t) = [];
    qxI2(t) = [];
    qyI2(t) = [];
    qzI2(t) = [];

    % Assigning values of img into q
    ind1 = sub2ind([qxN, qxN, qxN], qxI, qyI, qzI);
    ind2 = sub2ind([qxN, qxN, qxN], qxI2, qyI2, qzI2);
    % sum for each bin
    imgsum1 = accumarray(ind1, img(:));
    imgsum2 = accumarray(ind2, img(:));
    imgsum1  = padarray(imgsum1, DATA_num-numel(imgsum1), 'post');
    imgsum2  = padarray(imgsum2, DATA_num-numel(imgsum2), 'post');
    % add binned sum to each bin.
    DATA = DATA + imgsum1 + imgsum2;
    %DATA(ind1) = DATA(ind1) + imgsum1;
    %DATA(ind2) = DATA(ind2) + imgsum2;
%    DATA(ind1) = DATA(ind1) + img(:);
%    DATA(ind2) = DATA(ind2) + img(:);
    Npnt(ind1) = Npnt(ind1) + 1;
    Npnt(ind2) = Npnt(ind2) + 1;
    
%     tic
%     % Assigning values of img into q
%     for k = 1:numel(img)
%         DATA(qxI(k), qyI(k), qzI(k)) = DATA(qxI(k), qyI(k), qzI(k)) + img(k);
%         DATA(qxI2(k), qyI2(k), qzI2(k)) = DATA(qxI2(k), qyI2(k), qzI2(k)) + img(k);
%         Npnt(qxI(k), qyI(k), qzI(k)) = Npnt(qxI(k), qyI(k), qzI(k)) + 1;
%         Npnt(qxI2(k), qyI2(k), qzI2(k)) = Npnt(qxI2(k), qyI2(k), qzI2(k)) + 1;
%     end
%     toc
    fprintf('File %i is processed\n', ind);
end
DATA(DATA<=0) = NaN;
DATA = reshape(DATA, size(qx0));
DATA = DATA./Npnt;
clear qxI qyI qzI qxI2 qyI2 qzI2 Npnt qx qy qz img
%% Form factor removal and conditioning data.
%figure;
%DATA = DATA(:);
qx0 = qx0(:);
qy0 = qy0(:);
qz0 = qz0(:);
%q = sqrt(qx0.^2+qy0.^2+qz0.^2);
%ff = SchultzsphereFun(q, 27, 2.7);
%DATA = DATA./ff;

% t = q > 0.3;
% q(t) = [];
% qx0(t) = [];
% qy0(t) = [];
% qz0(t) = [];
% DATA(t) = [];
Qv = [qx0, qy0, qz0];