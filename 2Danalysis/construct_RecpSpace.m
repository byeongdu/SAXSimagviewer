function [Qv, DATA, imga] = construct_RecpSpace(files, saxs, ROIX, ROIY, qN, qmax)
% files.dirname
% files.maskfilename : including path.
% files.maskfillup : True or False
% files.backgroundfilename : array
% files.bodyfilename : string
% files.filetemplate : string
% files.index : array
% files.phi : array
% files.norm_factor : Form factor, the same size matrix with image.
% files.inversion = True or False
% files.int_lim = [0, 1E5]; % intensity discrimination range (above and
% below will be set 0)
% files.qmin: qminimum to remove...
% files.backsub
% HDF format of 12ID
phi_entry = '/entry/Metadata/phi';
BS_entry = '/entry/Metadata/SAXS_phd';

if isfield(files, 'dirname')
    inp_data.dirname = files.dirname;
else
    inp_data.dirname = '';
end

if isfield(files, 'gen_back')
    inp_data.gen_back = files.gen_back;
end

if isfield(files, 'maskfilename')
    mask_org = imread([inp_data.dirname, files.maskfilename]);
    mask_org(mask_org > 0) = 1;
    mask = double(mask_org(ROIY, ROIX));
    mask = logical(mask);
else
    mask = true(numel(ROIX), numel(ROIY));
end

if isfield(files, 'backgroundfilename')
    try
        BS = h5read([inp_data.dirname, files.backgroundfilename], BS_entry);
    catch
        BS = 1;
    end
    [~, ~, ext] = fileparts(files.backgroundfilename);
    [~, img] = openccdfile([inp_data.dirname, files.backgroundfilename], [], ext(2:end));
    inp_data.background = flipud(img)/BS;
end

inp_data.mask = mask;

N_img = length(files.index);

imga = zeros(size(mask, 1), size(mask, 2), length(files.index));

% data loading
for ind=1:1:N_img
    % Loading an image.
    if size(files.index, 2) == 2
        fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind, 1), files.index(ind, 2));
    else
        fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind));
    end
    try
        [~, ~, ext] = fileparts(fn);
        if contains(fn, '*')
            fname = dir(fullfile(inp_data.dirname, files.folder, fn));
            fname = fullfile(inp_data.dirname, fname.folder, fname.name);
        else
            fname = fullfile(inp_data.dirname, files.folder, fn);
        end
        [~, img] = openccdfile(fname, [], ext(2:end));
        img = flipud(img);
    catch
        fprintf('File %s does not exist. Skipping.\n', fn);
        continue;
    end
    try
        inp_data.norm_factor(ind) = h5read(fname, BS_entry);
    catch
        inp_data.norm_factor(ind) = files.norm_factor(ind);
    end
    try
        inp_data.phi(ind) = double(h5read(fname, phi_entry));
    catch
        inp_data.phi(ind) = files.phi(ind);
    end
    imga(:, :, ind) = img(ROIY, ROIX);
end
inp_data.img_mtrx = imga;
[Qv, DATA] = construct_RecpSpace_fromImgMtrx(inp_data, saxs, ROIX, ROIY, qN, qmax);

%% end of new
% 
% 
% %% Setup information
% center = saxs.center;
% waveln = saxs.waveln;
% psize = saxs.psize;
% SDD = saxs.SDD;
% saxs.edensity = 0;
% saxs.beta = 0;
% 
% % reset values..
% saxs.tthi = 0;
% saxs.ai = 0;
% saxs.center = [0, 0];
% px = q2pixel([-qmax, 0], waveln, center, psize, SDD, saxs.tiltangle);
% ROIxr = [ROIX(1), ROIX(end)];
% ROIyr = [ROIY(1), ROIY(end)];
% oldROIx = ROIxr;
% oldROIy = ROIyr;
% if px < ROIxr(1)
%     ROIxr(1) = round(px);
% end
% px2 = q2pixel([qmax, 0], waveln, center, psize, SDD, saxs.tiltangle);
% if px > ROIxr(2)
%     ROIxr(2) = round(px2);
% end
% [~, py] = q2pixel([0, qmax], waveln, center, psize, SDD, saxs.tiltangle);
% if py > ROIyr(2)
%     ROIyr = round(py);
% end
% NpixelX = round(px2) - round(px) + 1;
% NpixelY = round(py) - round(center(2)) + 1;
% oldqN = qN;
% if qN > NpixelX
%     qN = NpixelX;
% end
% if qN > NpixelY
%     qN = NpixelY;
% end
% 
% if sum((oldROIx - ROIxr).^2) ~= 0
%     ROIX = ROIxr(1):ROIxr(2);
%     fprintf('ROIX is changed from [%d, %d] to [%d, %d].\n', oldROIx, ROIX);
% end
% if sum((oldROIy - ROIyr).^2) ~= 0
%     ROIY = ROIyr(1):ROIyr(2);
%     fprintf('ROIX is changed from [%d, %d] to [%d, %d].\n', oldROIy, ROIY);
% end
% if qN ~=oldqN
%     fprintf('qN is changed from %d to %d.\n', oldqN, qN);
% end
% %% img ROI
% % ROIX = 250:1450;
% % ROIY = 200:900;
% % background = 35;
% 
% %% Coordinates of an image
% % xn = 1:numel(ROIX);
% % yn = 1:numel(ROIY);
% % laboratory coordinates
% [Y, Z] = meshgrid(ROIX, ROIY);
% Ym = Y - center(1);
% Zm = Z - center(2);
% Zm = Zm(:);
% Ym = Ym(:);
% 
% %% Contruct the volumetric data cell
% qxN = qN;
% 
% qxmin = -qmax;
% qxmax = qmax;
% deltaq = (qxmax - qxmin)/qxN;
% qymin = qxmin;
% qzmin = qxmin;
% 
% if deltaq < saxs.pxQ
%     deltaq = saxs.pxQ;
%     qxN = fix((qxmax - qxmin)/deltaq);
%     fprintf('Number of voxels reduced to %i due to the experimental resolution.\n', qxN);
% end
% 
% x = linspace(qxmin, qxmax, qxN);
% y = linspace(qxmin, qxmax, qxN);
% z = linspace(qxmin, qxmax, qxN);
% z(z<qzmin) = [];
% qzN = numel(z);
% 
% [qx0, qy0, qz0] = ndgrid(x, y, z);
% szdata = size(qx0);
% DATA = zeros(szdata);
% Npnt = zeros(szdata);
% clear x y z
% %% Process data
% if isfield(files, 'maskfilename')
%     mask_org = imread(files.maskfilename);
%     mask_org(mask_org > 0) = 1;
%     mask = double(mask_org(ROIY, ROIX));
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
%     mask = logical(mask);
% else
%     mask = true(numel(ROIX), numel(ROIY));
% end
%     
% if isfield(files, 'inversion')
%     isinversion = files.inversion;
% else
%     isinversion = 1;
% end
% 
% ismaskfillup = 0;
% if isfield(files, 'maskfillup')
%     if isfield(files, 'maskfilename')
%         ismaskfillup = files.maskfillup;
%     end
% end
% isgen_back = 0;
% if isfield(files, 'gen_back')
%     isgen_back = 1;
%     qmap = sqrt(Ym.^2+Zm.^2);
%     qindex = 0:1:(max(qmap(:))+1);
% end
% % Loading data
% img_sum = zeros(size(Y));
% [~, AreaFactor] = pixel2qv([Ym(:), Zm(:)], saxs);
% AreaFactor = reshape(AreaFactor, size(Y));
% DATA = DATA(:);
% Npnt = Npnt(:);
% for ind=1:1:length(files.index)
% %     if ind == 84
% %         files.phi(ind)
% %     end
%     saxs.tthi = files.phi(ind);
%     % Loading an image.
%     if size(files.index, 2) == 2
%         fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind, 1), files.index(ind, 2));
%     else
%         fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind));
%     end
%     try
%         [~, ~, ext] = fileparts(fn);
%         fname = dir(fullfile(files.folder, fn));
%         fname = fullfile(fname.folder, fname.name);
%         [~, img] = openccdfile(fname, [], ext(2:end));
%         img = flipud(img);
%         %img = double(flipud(imread(fn)));
%     catch
%         fprintf('File %s does not exist. Skipping.\n', fn);
%         continue;
%     end
%     img = img(ROIY, ROIX);
%     msk = mask;
%     msk(img < 0) = false; % Pilatus cannot have negative values;
%     % intensity discriminate....
%     if isfield(files, 'int_lim')
%         img(img<files.int_lim(1)) = NaN;
%         img(img>files.int_lim(2)) = NaN;
%     end
% 
%     if isfield(files, 'norm_factor')
%         img = img/files.norm_factor(ind);
%     end
% 
%     img = img - background;
%     if isgen_back
%         [qv, Iq] = azimavg(img, qmap, qindex, 1, [], [], mask);
%         back = interp1(qv, Iq, qmap(:));
%         back = reshape(back, size(img));
%         img = img - back;
%     end
%     img = img.*mask;
%     img = img.*AreaFactor;
%     % Normalize "img" for each phi
%     
%     if ismaskfillup
%     % Filling the Pilatus Mask Gaps
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
%     else
%         img(~msk) = nan;
%     end
%     
%     % Calculate q maps.
%     q = pixel2qv([Ym(:), Zm(:)], saxs);
%     qx = q.qx;
%     qy = q.qy;
%     qz = q.qz;
%     if isfield(files, 'qmin')
%         t = sqrt(sum(qx.^2+qy.^2+qz.^2,2)) < files.qmin;
%         img(t) = nan;
%     end
%     
%     img_sum = img_sum + img;
%     
%     %figure(1);
%     %imagesc(img, [1, 10000]);axis image;
%     
%     img = img(:);
%     % Convert q values into indices of qmap matrix.
%     qxI = round((qx-qxmin)/deltaq);
%     qyI = round((qy-qymin)/deltaq);
%     qzI = round((qz-qzmin)/deltaq);
%     if isinversion
%         qxI2 = round((-qx-qxmin)/deltaq);
%         qyI2 = round((-qy-qymin)/deltaq);
%         qzI2 = round((-qz-qzmin)/deltaq);
%     end
%     % Remove points that are out of the qmap matrix.
%     t = qxI>qxN | qxI < 1 | qyI > qxN | qyI < 1 | qzI > qzN | qzI < 1;
%     if isinversion
%         t =  t | qxI2>qxN | qxI2 < 1 | qyI2 > qxN | qyI2 < 1 | qzI2 > qzN | qzI2 < 1; 
%     end
%     t = t | ~isreal(qzI);
%     if isinversion
%         t = t | ~isreal(qzI2);
%     end
%     t = t | isnan(img); % have to be removed because nan+1 = nan...
%     img(t) = [];
%     qxI(t) = [];
%     qyI(t) = [];
%     qzI(t) = [];
%     if isinversion
%         qxI2(t) = [];
%         qyI2(t) = [];
%         qzI2(t) = [];
%     end
%     if ~isinversion
%         dt = accumarray([qxI, qyI, qzI], img, szdata, @mean, NaN);
%         dt = dt(:);
%     else
%         dt = accumarray([qxI, qyI, qzI;qxI2, qyI2, qzI2], [img;img], szdata, @mean, NaN);
%         dt = dt(:);
%         %dt = nanmean([dt, dt2(:)], 2);
%     end
%     nonNan = ~isnan(dt);
%     Npnt = Npnt + nonNan;
%     DATA(nonNan) = DATA(nonNan) + dt(nonNan);
% %     % Assigning values of img into q
% %     for k = 1:numel(img)
% %         DATA(qxI(k), qyI(k), qzI(k)) = DATA(qxI(k), qyI(k), qzI(k)) + img(k);
% %         Npnt(qxI(k), qyI(k), qzI(k)) = Npnt(qxI(k), qyI(k), qzI(k)) + 1;
% %         if isinversion
% %             DATA(qxI2(k), qyI2(k), qzI2(k)) = DATA(qxI2(k), qyI2(k), qzI2(k)) + img(k);
% %             Npnt(qxI2(k), qyI2(k), qzI2(k)) = Npnt(qxI2(k), qyI2(k), qzI2(k)) + 1;
% %         end
% %     end
%     fprintf('File %s is processed\n', fn);
% end
% DATA = DATA./Npnt;
% clear qxI qyI qzI qxI2 qyI2 qzI2 Npnt qx qy qz img
% %% Form factor removal and conditioning data.
% %figure;
% DATA = reshape(DATA, szdata);
% %DATA = DATA(:);
% qx0 = qx0(:);
% qy0 = qy0(:);
% qz0 = qz0(:);
% %q = sqrt(qx0.^2+qy0.^2+qz0.^2);
% %ff = SchultzsphereFun(q, 27, 2.7);
% %DATA = DATA./ff;
% 
% % t = q > 0.3;
% % q(t) = [];
% % qx0(t) = [];
% % qy0(t) = [];
% % qz0(t) = [];
% % DATA(t) = [];
% Qv = [qx0, qy0, qz0];