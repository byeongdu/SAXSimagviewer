function Qv = construct_RCPs_from_peakpositions(files, saxs)
% files.maskfilename : including path.
% files.maskfillup : True or False
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
%% Setup information
   
if isfield(files, 'inversion')
    isinversion = files.inversion;
else
    isinversion = 1;
end

ismaskfillup = 0;
if isfield(files, 'maskfillup')
    if isfield(files, 'maskfilename')
        ismaskfillup = files.maskfillup;
    end
end

Qv = [];
for ind=1:1:length(files.index)

%    saxs.tthi = files.phi(ind);
    % Loading an image.
    if size(files.index, 2) == 2
        fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind, 1), files.index(ind, 2));
    else
        fn = sprintf(files.filetemplate, files.bodyfilename, files.index(ind));
    end
    try
        [~, fb, ext] = fileparts(fn);
        fname = dir(fullfile(files.folder, [fb, '.txt']));
        po_ = findstr(fname.name, '_');
        saxs.tthi = str2double(fname.name((po_(1)+1):(po_(2)-1)));
        fname = fullfile(fname.folder, fname.name);
        pos = load(fname);
        Ym = pos(:,2);
        Zm = pos(:,1);
%         Ym = pos(:,2)-1;
%         Zm = pos(:,1)-0.65;
    catch
        fprintf('File %s does not exist. Skipping.\n', fn);
        continue;
    end
    % Calculate q maps.
    q = pixel2qv([-Ym(:), Zm(:)], saxs);
    qx = q.qx;
    qy = q.qy;
    qz = q.qz;
    Qv = [Qv; qx qy qz];
    fprintf('File %s is processed\n', fn);
end
