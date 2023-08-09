function [saxsstruct, R] = openccdfile(filecell, saxsstruct, fformat)
if nargin < 3
    fformat = '';
end
if isempty(filecell)
	[file, datadir]=uigetfile({'*.*','All format(*.*)';'*.spe','CCD data(*.spe)';'*.dat','GAS data(*.dat)'});
	if file==0 
        return; end
    file = [datadir, file];
else
    if iscell(filecell) % when you use like openccdfile({'testimage.tif'}, saxs)
        if (numel(filecell) == 1)
            file = filecell{1};
        elseif (numel(filecell) == 2)
            path = filecell{1};
            file = filecell{2}; %% when it is called from listbox..
            file = [path, filesep,file];
        end
    else % when you use like openccdfile('testimage.tif', saxs)
        file = filecell;
    end
end

% if isempty(saxsstruct)
%     saxsstruct = getgihandle;
% end
CCDradius = [];
switch fformat
    case {'h5', 'hdf5'}
        if isfield(saxsstruct, 'h5entry')
            entry = saxsstruct.h5entry;
        else
            entry = '/entry/data/data';
        end
        R = h5read(file, entry);
        if ismatrix(R)
            R = R';
        else
            R = permute(R, [2,1,3]);
        end
    case 'goldccd'
        R = GoldOpen(file);
    case {'mar165', 'ccd'}
        R = imread(file);
%        R = double(R)-10;  %% oftset = 10;
%        R = double(R)-200;
        [row, col]=size(R);
        CCDradius = row/2-2;
    case {'princeton', 'spe'}
        if isfield(saxsstruct, 'frame')
            R = speopen(file, saxsstruct.frame);
        else
            R = speopen(file, 1);
        end
    case 'GBinary'
        GB = saxsstruct.GB;
        GB_dataFormat = GB.byte;
        GB_dimX = GB.dimX;
        GB_dimY = GB.dimY;
        GB_Startbyte = GB.startbyte;
        R = binopen(file, GB_Startbyte, GB_dataFormat, GB_dimX, GB_dimY);
    case 'mar3450'
        R = readmar345(file, 3450);
    case 'edf'
        [R, ~, hd] = read_edf33(file);
        saxsstruct.center = [str2double(hd.center_1),...
            str2double(hd.dim_2) - str2double(hd.center_2)];
        saxsstruct.psize = str2double(hd.psize_1)*1000;
        saxsstruct.SDD = str2double(hd.sampledistance)*1000;
        saxsstruct.waveln = str2double(hd.wavelength)*1E10; % Angstrom
        saxsstruct.xeng = 12.398/saxsstruct.waveln;
        saxsstruct.tiltangle = 0;
        q = pixel2q([1,0]+saxsstruct.center, saxsstruct);
        saxsstruct.Q = 0.10763;
        px = SDDcal(saxsstruct.SDD, saxsstruct.Q, ...
            saxsstruct.psize, saxsstruct.waveln, 'sdd');
        saxsstruct.px = px;
        saxsstruct.edensity = 0;
        saxsstruct.pxQ = q(1);
        saxsstruct.beta = 0;
        R = R';
    otherwise
        R = imread(file);
        [row,col] =size(R);
        CCDradius = row/2-2;
        %disp('ERROR: fileformat is uncertain.')
end
R = double(R);

if isempty(saxsstruct)
    return
end

if ~isempty(CCDradius)
    saxsstruct.CCDradius = CCDradius;
end

if isfield(saxsstruct, 'offset');
    R = R - saxsstruct.offset;
end

if isfield(saxsstruct, 'imgoperation')
    imgopr = saxsstruct.imgoperation;
    if ~isfield(imgopr, 'UpDown');
        imgopr.UpDown = 0;
    end
    if ~isfield(imgopr, 'LeftRight');
        imgopr.LeftRight = 0;
    end
    if ~isfield(imgopr, 'transpose');
        imgopr.transpose = 0;
    end
    
    if imgopr.UpDown == 1
        R = flipud(R);
    end
    if imgopr.LeftRight == 1
        R = fliplr(R);
    end
    if imgopr.transpose == 1
        R = R';
    end
end

%if isfield(saxsstruct, 'norminfo')
%    norminfo = saxsstruct.norminfo;
%    if isfield(norminfo, 'norm')
%        if norminfo.norm == 1
%            [p,n,e,v] = fileparts(saxsstruct.imgname);
%            cnt = specSAXSn2(norminfo.histfile, sprintf('%s%s*', n, e), 1);
%            R = R/cnt(norminfo.normcol);
%            disp(sprintf('The loaded image is normalized by %f', cnt(norminfo.normcol)));
%        end
%    end
%end
            
% ==========================================================
saxsstruct.image = R;
saxsstruct.imgname = file;
saxsstruct.dir = pwd;
saxsstruct.imgsize = size(R);
setgihandle(saxsstruct)
%[han, saxsstruct] = gishow(R, saxsstruct);