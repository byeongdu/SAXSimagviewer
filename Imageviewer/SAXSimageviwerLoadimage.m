function [saxs, handles] = SAXSimageviwerLoadimage(filename, saxs, handles)
% [saxs, handles] = SAXSimageviwerLoadimage(filename, saxs, handles)
% saxs = SAXSimageviwerLoadimage(filename, saxs)
% saxs = SAXSimageviwerLoadimage(filename)
if nargin < 3
    handles = [];
end
if nargin < 2
    saxs = [];
end
%if ~isfield(saxs, 'CCD')
ext = 'img';
try
    f = imfinfo(filename);
catch
    [pth, fn, ext] = fileparts(filename);
    ext = ext(2:end);
end

switch lower(ext)
    case 'img'
        [handles.ImX, handles.iminfo] = readImageFileFcn(filename);
    %[a, b] = readImageFileFcn(filename);
    case {'edf', 'h5'}
        [saxs, handles.ImX] = openccdfile(filename, saxs, ext); %% need iminfo.....
    case {'hdf5'}
        saxs.h5entry = '/dp';
        [saxs, handles.ImX] = openccdfile(filename, saxs, ext); %% need iminfo.....
    otherwise
        saxs.imgfigurehandle = handles.SAXSImageViewer;
        saxs.imgaxeshandle = handles.ImageAxes;
        [~, handles.ImX] = openccdfile(filename, [], ext); %% need iminfo.....
%    [saxs, handles.ImX] = openccdfile(filename, [], ext); %% need iminfo.....
%    setColor
end

handles.ImX = double(flipud(handles.ImX));
saxs.image = handles.ImX;
[ph, file, ext] = fileparts(filename);
saxs.imgname = file;
saxs.imagename = [file, ext];
saxs.dir = ph;
saxs.imgsize = size(handles.ImX);
%saxs.image = flipud(saxs.image);

shallIloadparameter = 0;
if isfield(saxs, 'isAutoSetupUpdate')
    if saxs.isAutoSetupUpdate == 1
        shallIloadparameter = 1;
    end
end

if ~shallIloadparameter
    return
end

% check the existence of spec datafile....
% First, find specfile automatically....
isSpecfileAssigned = 0;
if isfield(saxs, 'specfile')
    isSpecfileAssigned = exist(saxs.specfile, 'file');
    if isSpecfileAssigned
        lpos = ffind(saxs.specfile, file);
        if isempty(lpos)
            isSpecfileAssigned = 0;
        end
    end
    specfiledir = '';
end

% now image loading is done....
%% Search the specfile associated to the image loaded. If available, return
% the parameters associated with it.

if ~isSpecfileAssigned
    t = find(saxs.dir == filesep);
    whereSAXS = strfind(saxs.dir, [filesep, 'SAXS']);
    if isempty(whereSAXS)
        % If the image loaded is not in 'SAXS' directory,
        % assumes that the directory structure has been distorted and
        % the specfile not exists any more.
        return
    end
    if (t(end) == max(whereSAXS)) && (length(saxs.dir) == t(end)+4)
        specfiledir = saxs.dir(1:t(end)-1);
    else
        % If the image loaded is not in 'SAXS' directory,
        % assumes that the directory structure has been distorted and
        % the specfile not exists any more.
        return
    end
    
        a = dir(specfiledir);
        a([a.isdir]==1) = [];
        for i=1:numel(a)
            maybe_specfile = fullfile(specfiledir, a(i).name);
            if strfind(maybe_specfile, '.tmp')
                % .tmp cannot be a specfilename.
                continue
            end
            if strfind(maybe_specfile, '.')
                % specfile does not have . in its filename.
                continue
            end
            k = ffind(maybe_specfile, file);
            if ~isempty(k)
                saxs.specfile = maybe_specfile;
                break
            end
        end
        % if specfile is not found.... just return
        return
end
% Once there is a specfile field in SAXS
c = specSAXSn2(saxs.specfile, file);
if isempty(c)
    saxs = rmfield(saxs,'specfile');
else
    saxs.ai = c.th;
    saxs.xeng = c.Energy;
    saxs.waveln = eng2wl(c.Energy);
    %sampleinfo = c;
    assignin('base', 'sampleinfo', c)
    disp('% Measurement Parameters:')
    c
end
%end

%UpDown = 0;
%if isfield(saxs, 'imgoperation')
%  if isfield(saxs.imgoperation, 'UpDown')
%      UpDown = saxs.imgoperation.UpDown;
%  end
%end

%switch UpDown
%case 0
%end
end
%--------------------------------------------------------------------------
% readImageFileFcn
%   This function reads in the image file and converts to TRUECOLOR
%--------------------------------------------------------------------------
  function [x, info] = readImageFileFcn(filename)
    %try
    [~, ~, ext] = fileparts(filename);
    if strfind(ext, '.mar3450')
        info.ColorType = 'mar345';
        x = readmar345(filename);
        x = double(x);
        return
    end
            
      x = imread(filename);
      try
        info = imfinfo(filename);
        info = info(1);
      catch
        info.ColorType = 'marCCD'; % for marccd data... % Byeongdu added.
      end

      switch info.ColorType
        case 'grayscale'
          switch class(x)
            case 'logical'
              x = uint8(x);
%              mp = [0 0 0;1 1 1];

            case 'uint8'
%              mp = gray(256);

            case 'uint16'
%              mp = gray(2^16);

            case {'double','single'}
%              cmapsz = size(get(handles.SAXSImageViewer, 'Colormap'), 1);
%              mp = gray(cmapsz);

            case 'int16'
              x = double(x); %+2^15;
%              x = uint16((x-min(x(:)))/(max(x(:))-min(x(:)))*(2^16));
%              mp = gray(2^16);
            case 'int32'
                  x = double(x);
%                  mp = gray(2^32);
            otherwise
%              cmapsz = size(get(handles.SAXSImageViewer, 'Colormap'), 1);
%              mp = gray(cmapsz);
          end
%          x = ind2rgb(x, mp);

        case 'indexed'
          %if isempty(mp)
          %  mp = info.Colormap;
          %end
          %x = ind2rgb(x, mp);
          x = double(x);

        case 'marCCD'
%            disp('what is problem?')
%            mp = gray(2^16);
        case 'truecolor'
            disp('This is ture color image')
            disp('response from imageviewer2.m')
        otherwise
      end

    %catch
    %  x = NaN;
    %  info = [];

    end
  %end