function varargout = saxsaverage2(varargin)
% SAXSLee Application M-file for untitled.fig
%    FIG = SAXSLee launch untitled GUI.
%    UNTITLED('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 30-Nov-2019 10:43:30
%
% How to use this macro............. on command line....
% saxsaverage2('doaverage', {}, {}, {}, ar)

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
    end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

% --------------------------------------------------------------------
function varargout = doaverage2(varargin)

img = varargin{1};
saxs = varargin{2};
mu = varargin{3};
if numel(varargin) < 4
    method = 0;
else
    method = varargin{4};
end

avg = get(gcbf, 'userdata');
if isempty(avg)
    cprintf('err', 'qmap and thmap are not ready.\n');
    return
end
if isfield(saxs, 'mask')
    mk = saxs.mask;
    mk(mk>0) = 1;
else
    mk = [];
end
if ndims(img)==3
    img = img(:, :, saxs.frame);
end

if isfield(avg, 'polarization')
    pol = reshape(avg.polarization, size(img));
    img = img./pol;
end

if isfield(saxs, 'ceilingintensity')
    ci = saxs.ceilingintensity;
    if numel(ci) == 2 % [low, higher than]
        t = (img < ci(1)) | (img > ci(2));
    else % ci = maxcut;
        t = img>ci;
    end
    if isempty(mk)
        mk = ones(size(img));
    end
    mk(t) = 0;
end

if isfield(saxs, 'flatfield')
    S = saxs.flatfield;
else
    S = [];
end

if ~isempty(S)
    img = img./S;
end

N_thrange = numel(mu)/2;
if N_thrange == 0
    N_thrange = 1;
    thrange = [];
else
    thrange = mu;
end

% if N_thrange > 1
%     data = cell(size(N_thrange));
% else
data = [];
% end
mask = [];
t = mu > pi;
mu(t) = mu(t)-2*pi; 
azimA = [];
for i=1:size(mu)
    if mu(i, 1) > mu(i, 2)
        azimA = [azimA; mu(i,1), pi; -pi, mu(i, 2)];
    else
        azimA = [azimA; mu(i, :)];
    end
end

if method == 0
    [q, Iq, sumIq, ~, qc] = azimavg(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, azimA, mk);
    %[q, Iq] = azimavg_temporary(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
else
    [q, Iq, mask, sumIq] = azimavg_outlier(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, azimA, mk, method);
    qc = [];
end
data = [q(:), Iq(:), sumIq(:), qc(:)];

% for i=1:N_thrange
%     if N_thrange>1
%         thrange = mu(i, 1:2);
%     end
%     if method == 0
%         [q, Iq, sumIq, ~, qc] = azimavg(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
%         %[q, Iq] = azimavg_temporary(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
%     else
%         [q, Iq, mask, sumIq] = azimavg_outlier(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk, method);
%     end
%     if N_thrange>1
%         data{i} = [q(:), Iq(:), sumIq];
%     else
%         if numel(sumIq)>numel(q)
%             sumIq(1) = [];
%         end
%         data = [q(:), Iq(:), sumIq(:), qc(:)];
%     end
% end

% if N_thrange > 1
%     Iq = [];
%     for i=1:numel(data)
%         Iq = [Iq, data{i}(:,2)];
%     end
%     Iq = nanmean(Iq, 2);
%     q = data{i}(:,1);
%     data = [q, Iq];
% end

%setgihandle(saxs);
varargout{1} = data;
if ~isempty(mask)
    saxs.maskwithoutlier = mask;
    varargout{2} = saxs;
else
    varargout{2} = [];
end

function varargout = Xcorr(varargin)
    img = varargin{1};
    img = img(:);
    saxs = varargin{2};
    q1 = varargin{3};
    q2 = varargin{4};
    dq = varargin{5};
    dth = varargin{6};
    avg = get(gcbf, 'userdata');
    t = avg.qmap>=q1-dq/2 & avg.qmap<=q1+dq/2;
    Iq1 = img(t);
    th1 = avg.thmap(t);
    t = avg.qmap>=q2-dq/2 & avg.qmap<=q2+dq/2;
    Iq2 = img(t);
    th2 = avg.thmap(t);
    
    tharray = -pi:(deg2rad(dth)):pi;
    
[h, bin] = histc(th1, tharray);
%bin = bin.*goodpix;
t = bin == 0;
bin(t) = [];
Iq1(t) = [];
c=accumarray(bin,Iq1);
Ngooddata = numel(c);
if numel(h)>numel(c)
    c = [c(:);zeros(numel(h)-Ngooddata, 1)];
end
%npixel = max(1, h(:));
Iq1 = c(:)./h;

First_half_Array = 1:((numel(Iq1)-1)/2+1);
Second_half_Array = ((numel(Iq1)-1)/2+1):numel(Iq1);
Nan_array = 1./zeros(size(Iq1));
NA = Nan_array;
NA(First_half_Array) = Iq1(Second_half_Array);
Iq1 = nanmean([NA, Iq1], 2);
NA = Nan_array;
NA(Second_half_Array) = Iq1(First_half_Array);
Iq1 = nanmean([NA, Iq1], 2);

[h, bin] = histc(th2, tharray);
%bin = bin.*goodpix;
t = bin == 0;
bin(t) = [];
Iq2(t) = [];
c=accumarray(bin,Iq2);
Ngooddata = numel(c);
if numel(h)>numel(c)
    c = [c(:);zeros(numel(h)-Ngooddata, 1)];
end
%npixel = max(1, h(:));
Iq2 = c(:)./h;

First_half_Array = 1:((numel(Iq2)-1)/2+1);
Second_half_Array = ((numel(Iq2)-1)/2+1):numel(Iq2);
Nan_array = 1./zeros(size(Iq2));
NA = Nan_array;
NA(First_half_Array) = Iq2(Second_half_Array);
Iq2 = nanmean([NA, Iq2], 2);
NA = Nan_array;
NA(Second_half_Array) = Iq2(First_half_Array);
Iq2 = nanmean([NA, Iq2], 2);

ddth = 0:dth:359;
phi = tharray;
phi(end) = [];
Iq1(end) = [];
Iq2(end) = [];
%Nphi = numel(phi);
%i0 = 0;
C = zeros(size(ddth));
nIq2 = Iq2;
for i=1:numel(ddth)
    if i>1
        nIq2 = circshift(nIq2, 1);
    end
    xc = Iq1.*nIq2;
    
    % only choose the region that has non-Nan values for 180 degrees
    % continuously.
    nanxc = isnan(xc);
    d_nanxc = diff(nanxc);
    chxc = find(abs(d_nanxc) == 1);
    non_nanval_range = [];
    if isempty(chxc)
        non_nanval_range = 1:numel(xc);
    else
        if d_nanxc(chxc(1))>0 & (chxc(1) > 180/dth)
            non_nanval_range = 1:fix(180/dth);
        else
            for k=2:numel(chxc)
                if (d_nanxc(chxc(k-1))== -1) & (d_nanxc(chxc(k))== 1) & (chxc(k)-chxc(k-1)>180/dth)
                    non_nanval_range = (chxc(k-1)+1):(chxc(k-1)+fix(180/dth));
                end
            end
        end
    end
    if ~isempty(non_nanval_range)
        C(i) = mean(xc);
    else
        error('Angular range of either q1 or q2 is less than 180 degree.')
    end
end
% for k = 1:numel(phi)
%     i0 = 0;
%     for i=1:numel(ddth)
%         ni = rem(k+i-1+i0, Nphi);
%         if ni==0
%             ni = Nphi;
%         end
%         if k+i0>Nphi
%             fprintf('A1\n')
%             break
%         end
%         if ni>Nphi
%             fprintf('A2\n')
%             break
%         end
%         crossv = Iq1(k+i0)*Iq2(ni);
%         if isnan(crossv)
%             i0 = i0+1;
%             if i0 > Nphi/2
%                 error('Data is filled with NaN')
%             else
%                 i = 1;
%             end
%         else
%             C(k) = C(k) + crossv;
%         end
%     end
% end
varargout{1} = [ddth(:), C(:)/nanmean(C)];
    

function varargout = doaverage3(varargin)

img = varargin{1};
saxs = varargin{2};
thRange = varargin{3};
qRange = varargin{4};
if numel(varargin) < 5
    inversion = 0;
else
    inversion = varargin{5};
end

avg = get(gcbf, 'userdata');
if isempty(avg)
    cprintf('err', 'qmap and thmap are not ready.\n');
    return
end
if isfield(saxs, 'mask')
    mk = saxs.mask;
else
    mk = [];
end

if isfield(avg, 'polarization')
    pol = reshape(avg.polarization, size(img));
    img = img./pol;
end

if isfield(saxs, 'ceilingintensity')
    ci = saxs.ceilingintensity;
    if numel(ci) == 2 % [low, higher than]
        t = (img < ci(1)) | (img > ci(2));
    else % ci = maxcut;
        t = img>ci;
    end
    if isempty(mk)
        mk = ones(size(img));
    end
    mk(t) = 0;
end

N_qrange = numel(qRange)/2;
if N_qrange == 0
    N_qrange = 1;
    qrange = [];
else
    qrange = qRange(1, 1:2);
end

if N_qrange > 1
    data = cell(size(N_qrange));
else
    data = [];
end
mask = [];
%thrange = -180:1:179;
thrange = thRange*pi/180;
for i=1:N_qrange
    if N_qrange>1
        qrng = qrange(i, 1:2);
    else
        qrng = qrange;
    end
    [th, Iq] = azimavgazim(img, avg.qmap, thrange, avg.SF, avg.thmap, qrng, mk);
%     if    
%         %[q, Iq] = azimavg_temporary(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
%     else
% %        [q, Iq, mask] = azimavg_outlier(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk, method);
%     end
    if inversion
        for k=1:numel(th)
            if isnan(Iq(k))
                t = abs(th - [th(k)-pi, th(k)+pi])<1E-5;
                mv = [Iq(t(:,1)), Iq(t(:,2))];
                if ~isempty(mv)
                    Iq(k) = mean(mv);
                end
            end
        end
    end
    if N_qrange>1
        data{i} = [th(:), Iq(:)];
    else
        data = [th(:), Iq(:)];
    end
end

%setgihandle(saxs);
varargout{1} = data;
if ~isempty(mask)
    saxs.maskwithoutlier = mask;
    varargout{2} = saxs;
else
    varargout{2} = [];
end

function varargout = doaverage(varargin)

h = varargin{1};
eventdata = varargin{2};
handles = varargin{3};

if numel(varargin) > 3
 varargin = varargin(4);
else
    varargin = [];
end

saxs = getgihandle;
try
    saxs.mask = double(evalin('base', 'mask'));
    saxs.maskon = 1;
catch
end

ImgFigHandle = evalin('base', 'SAXSimageviewerhandle');
saxs.imgfigurehandle = ImgFigHandle;
saxs.imgaxeshandle = evalin('base', 'SAXSimagehandle');


if isfield(saxs, 'imgfigurehandle')
    ImgFigHandle = getfield(saxs, 'imgfigurehandle');
else
    ImgFigHandle = [];
end

if isfield(saxs, 'offset')
    offset = 0; % because openccdfile.m will subtract the offset
else
    offset = eval(char(cellstr(get(handles.ed_offset, 'string'))));
    saxs.offset = offset;
end

if (numel(varargin) < 1)
    %data = double(get_imgFigure(ImgFigHandle));
    if isfield(saxs, 'image')
        data = saxs.image;
    else
        disp('No image on saxs')
    end
%    disp('select A')
    
%elseif numel(varargin) == 1
%    disp('A')
%    varargin{1}
%    if isstruct(varargin{1})
%        disp('F')
%    end
else
    inputdata = varargin{1};
    openfile{1} = inputdata{1};
    openfile{2} = inputdata{2};
%    inputdata{1}, inputdata{2}, inputdata{3}
    crd = pwd;
    timeout = 1;
    while (timeout < 10)
        try
            [saxs, data]=openccdfile(openfile, saxs);
            timeout = 10;
        catch
            timeout = timeout + 1;
                cd ..
                pause(0.5);
                eval(sprintf('cd %s', crd));
            pause(0.5)
            %cd SAXS
            disp('No file yet')
        end
    end
    
%    set(hSAXSlee, 'Userdata', saxs);
    if numel(varargin) > 2
        saxs.waveln = 3;
        saxs.norm = 4;
    end
    setgihandle(saxs)
%    disp('select B')
end
f = findall(0, 'tag', 'edit21');
qmax = str2double(char(cellstr(get(f, 'string'))));
f = findall(0, 'tag', 'edit22');
qnum = str2double(char(cellstr(get(f, 'string'))));
f = findall(0, 'tag', 'rd_Qoption2');
Qoption = get(f, 'Value');
f = findall(0, 'tag', 'Selectmu');
mu = eval(char(cellstr(get(f, 'string'))));
Bp = saxs.center;
waveln = saxs.waveln;
SDD = saxs.SDD;
psize = saxs.psize;

Qscale= [qmax,qnum];
Limit = [-1, 2000000];

if isfield(saxs, 'maskon')
    if saxs.maskon
        if ~isfield(saxs,'mask')
            disp('You must load mask image')
        else
            if isempty(saxs.mask)
                disp('You must load mask image')
            end
            mask = saxs.mask;
        end
    else
        mask = [];
    end
else
    mask = [];
end
saxs.Qscale = Qscale;
saxs.Limit = Limit;
%saxs = setfield(saxs, 'maskName', maskname);
f = findall(0, 'tag', 'ed_avgdir');
avgdir = get(f, 'string');
%saxs.offset = offset;
imgname = saxs.imgname;

% normalization info =================
normval = 1;
if ~isfield(saxs, 'norminfo')
    norminfo.avgdir = '';
    norminfo.histfile = '';
    norminfo.xengcol = 0;
    norminfo.normcol = 0;
else
    norminfo = saxs.norminfo;
    
    if ~isfield(norminfo, 'histfile')
        norminfo.histfile = '';
    end
    if ~isfield(norminfo, 'xengcol')
        norminfo.xengcol = 0;
    else
        if norminfo.xengcol
            f = findall(0, 'tag', 'ed_xengcol');
            norminfo.xengcol = str2num(get(f, 'string'));
        end
    end
    if ~isfield(norminfo, 'avgdir')
        norminfo.avgdir = '';
    end
    if ~isfield(norminfo, 'normcol')
        norminfo.normcol = 0;
    else
        if norminfo.normcol
            f = findall(0, 'tag', 'ed_normcol');
            norminfo.normcol = str2num(get(f, 'string'));
        end
    end
end
norminfo.avgdir = avgdir;
histfile = norminfo.histfile;
xengcol = norminfo.xengcol;
normcol = norminfo.normcol;
saxs.norminfo = norminfo;


energycorrection = 0.114;
photodiodecorrection = 10;
% disp(sprintf('energy correction factor: -%0.3f', energycorrection))
if (numel(varargin) < 3)
    if (bitor((xengcol ~= 0), (normcol ~= 0)))
        [~, searchstr, searchext]=fileparts(imgname);
%        if strcmp(tmppah, filesep)
%            tmppah = '';
%        end
        searchstr = [searchstr, searchext];
        nor = specSAXSn2(histfile, searchstr, 1);
        if (xengcol ~=0); 
            waveln = eng2wl(nor(xengcol)-energycorrection);
        end
        if (normcol ~=0); 
            normval = nor(normcol)-photodiodecorrection;
        end
    else
        normval = 1;
    end
    
else    
    if bitor((xengcol ~= 0), (normcol ~= 0))
        inputdata = varargin{1};
        if (xengcol ~=0); waveln = inputdata{3}; end
        if (normcol ~=0); normval = inputdata{4}; end
    end
    
end    
% =======================================

if isfield(saxs, 'CCDradius')
    CCDradius = saxs.CCDradius;
else
    CCDradius = 0;
end

mask = double(mask);
data = flipud(data);
%mask = flipud(mask);
%y = circavg(image, waveln, psize, SDD, Bp, offset, Qoption, Qscale, Limit, mu, mask, CCDradius)
D=circavg(data, waveln, psize, SDD, Bp, offset, 0, Qscale, Limit, mu, mask, CCDradius, 1, 10);
%D=circavg(data, waveln, psize, SDD, Bp, offset, Qoption, Qscale, Limit, mu, mask, CCDradius, 1, 10);
%D = cic(data, [Bp(2), Bp(1)], waveln, psize, SDD, offset, mu); % pilatus detector

D(:,2:3) = D(:,2:3)/normval;
t=sprintf('%s is averaged.\n', imgname);disp(t)
% save ==========================

[path, fn, ext] = fileparts(imgname);
    
%path = saxs.dir;
if isempty(ext)
    ext = 'dat';
end
saxs.dir = path;

if strcmp(path, filesep)
    dirforavg = [avgdir];
else
    if isempty(path)
        dirforavg = avgdir;
    else
        dirforavg = [path, filesep, avgdir];
    end
end

%dirforavg = [path, filesep, avgdir];
if isdir(dirforavg) ~= 1
    tmpstr = ['mkdir ', dirforavg];
    eval(tmpstr);
end

filename = [dirforavg, filesep, fn, '.', ext];
%fid = fopen(filename, 'w');
%[row, col] = size(D);
save(filename, 'D', '-ascii');
%fprintf(fid, '%12.9f %15.9f %15.9f\n', D);
%for i=1:row
%    if (D(i, 2) < 0)
%        D(i,2) = NaN;
%    end
%    if (D(i,1)>0)
%        fprintf(fid, '%12.9f %15.9f %15.9f\n', D(i,1:3));
%    end
%end
%fclose(fid);

% display =========================================
%set(hSAXSlee, 'userdata', saxs);
setgihandle(saxs);
f = findall(0, 'tag', 'chk1dHoldon');
holdon = get(f, 'Value');
if holdon == 0
    return
end
hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');
%figure(hd20);
%lineh=semilogy(D(:,1), D(:,2));
[pt, filen, ext] = fileparts(saxs.imgname);
if strcmp(path, filesep)
    pt = '';
end
kk = findstr(filen, '_');
if ~isempty(kk)
    filen(kk) = ' ';
end

%han = get(hd20, 'children');
lineh=semilogy(D(:,1), D(:,2));
%handles.imgh1d = hd20;
%handles.data1d = D;
%guidata(h, handles);

% --------------------------------------------------------------------
function varargout = savebtn_Callback(h, eventdata, handles, varargin)
if ~exist('file')
	[file, datadir]=uiputfile('*.*','Name for a macro');
	if file==0 return; end
    file = [datadir, file];
end

%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
saxs = getgihandle;
if isfield(saxs, 'norminfo')
    avgdir = saxs.norminfo.avgdir;
    xengcol = saxs.norminfo.xengcol;
    normcol = saxs.norminfo.normcol;
else
    avgdir = 'Averaged';
    xengcol = 8;
    normcol = 5;
end

fid = fopen(file, 'w');
fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '\n');
fprintf(fid, 'logname=$1\n');
fprintf(fid, '\n');
fprintf(fid, 'while test $# -ge 2 ; do\n');
fprintf(fid, 'filename=$2\n');
fprintf(fid, '\n');
fprintf(fid, 'fileline=\''grep -F $filename $logname''\n');
fprintf(fid, 'normval=\''echo $fileline | gawk \''{ print $%d }''''\n', normcol);
fprintf(fid, 'energyval=\''echo $fileline | gawk \''{ print $%d }''''\n', xengcol);
fprintf(fid, '\n');
fprintf(fid, 'echo FILENAME $filename $normval $energyval\n');
strprint = 'goldaverage -o %s -y -d %5.1f -Z %5.1f -k $normval -e $energyval -r 0,0,%d,%d -C %d@%d,%d -c %d@%5.1f,%5.1f %5.1f %5.1f $filename\n';
Bp = saxs.center;
fprintf(fid, strprint, avgdir, saxs.SDD, saxs.offset, 1024,1024,500,512,512,13,Bp(1),Bp(2),Bp(1),Bp(2));
fprintf(fid, 'shift\n');
fprintf(fid, 'done\n');
fclose(fid);

% --------------------------------------------------------------------
function varargout = axes2_ButtonDownFcn(h, eventdata, handles, varargin)
get(h, 'CurrentPoint')




% --------------------------------------------------------------------
function varargout = chk1dHoldon_Callback(h, eventdata, handles, varargin)
if isfield(handles, 'imgh1d')
    figure(handles.imgh1d);
end
if get(h, 'Value') == 1
    set(gca, 'nextplot','add');
else
    set(gca, 'nextplot','replace');
end



function Selectmu_Callback(hObject, eventdata, handles)
% hObject    handle to Selectmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Selectmu as text
%        str2double(get(hObject,'String')) returns contents of Selectmu as a double


% --- Executes during object creation, after setting all properties.
function txtai_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtai_Callback(hObject, eventdata, handles)
% hObject    handle to txtai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtai as text
%        str2double(get(hObject,'String')) returns contents of txtai as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function txtqx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtqx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtqx_Callback(hObject, eventdata, handles)
% hObject    handle to txtqx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtqx as text
%        str2double(get(hObject,'String')) returns contents of txtqx as a double


% --- Executes during object creation, after setting all properties.
function txtqy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtqy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtqy_Callback(hObject, eventdata, handles)
% hObject    handle to txtqy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtqy as text
%        str2double(get(hObject,'String')) returns contents of txtqy as a double


% --- Executes during object creation, after setting all properties.
function txtqz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtqz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtqz_Callback(hObject, eventdata, handles)
% hObject    handle to txtqz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtqz as text
%        str2double(get(hObject,'String')) returns contents of txtqz as a double


% --- Executes during object creation, after setting all properties.
function txtaf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtaf_Callback(hObject, eventdata, handles)
% hObject    handle to txtaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtaf as text
%        str2double(get(hObject,'String')) returns contents of txtaf as a double


% --- Executes during object creation, after setting all properties.
function txtthf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtthf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtthf_Callback(hObject, eventdata, handles)
% hObject    handle to txtthf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtthf as text
%        str2double(get(hObject,'String')) returns contents of txtthf as a double


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
if strcmp(get(handles.figure1,'SelectionType'),'open') % If double click
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected}; % Item selected in list box
    [path,name,ext,ver] = fileparts(filename);
%    path = get(handles.dir, 'String');
    pbload_Callback(hObject, eventdata, handles, {path, [name,ext]})
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbRefresh.
function pbRefresh_Callback(hObject, eventdata, handles)
% hObject    handle to pbRefresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wildstr = char(cellstr(get(handles.edit18, 'string')));
dir_struct = dir(wildstr);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
%handles.file_names = sorted_names;
%handles.is_dir = [dir_struct.isdir];
%handles.sorted_index = [sorted_index];
%guidata(handles.figure1,handles)
set(handles.listbox1,'String',sorted_names,'Value',1)
%handles.dir=pwd;
%set(handles.dir,'String',pwd)
guidata(hObject, handles)



function ed_qmax_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qmax as text
%        str2double(get(hObject,'String')) returns contents of ed_qmax as a double


% --- Executes during object creation, after setting all properties.
function ed_qmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_qN_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qN as text
%        str2double(get(hObject,'String')) returns contents of ed_qN as a double


% --- Executes during object creation, after setting all properties.
function ed_qN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes on button press in pbAzim.
function pbAzim_Callback(hObject, eventdata, handles)
% hObject    handle to pbAzim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
set(handles.Selectmu, 'string', '[-10 10; 170, 190]');

function show_sectoravg_azim(handles)

saxs = getgihandle;

ImgFigHandle = evalin('base', 'SAXSimageviewerhandle');
saxs.imgfigurehandle = ImgFigHandle;


mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
t = numel(mu)/2;
if isfield(saxs, 'center')
    center = saxs.center;
else
    error('Set the coordinates of an image center on SAXSLee panel')
end
imgsize = saxs.imgsize;
imgFigurehandle = saxs.imgfigurehandle;
azimhandle = [];
for i=1:1:t
    for j=1:2
        azimangle = mu(i,j); %:mu(i,2)
        %azimangle = j;
        figure(imgFigurehandle);hold on;
        [x, y] = azimang2coord(imgsize(1), imgsize(2), center(1), center(2), azimangle);
        tt=plot(x,y);
        azimhandle = [azimhandle,tt];
    end
end
saxs.azimlinehandle = azimhandle;
%set(hSAXSlee, 'userdata', saxs);
setgihandle(saxs)

function clear_sectoravg_azim(varargin)
saxs = getgihandle;
azimh = saxs.azimlinehandle;
saxs.azimlinehandle =[];
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);
delete(azimh);

% --- Executes on button press in pbazimclear.
function pbazimclear_Callback(hObject, eventdata, handles)
% hObject    handle to pbazimclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
set(handles.Selectmu, 'string', '[80 100; 260, 280]');

function ed_histfile_Callback(hObject, eventdata, handles)
% hObject    handle to ed_histfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_histfile as text
%        str2double(get(hObject,'String')) returns contents of ed_histfile as a double



% --- Executes on button press in pb_selhistfile.
function pb_selhistfile_Callback(hObject, eventdata, handles)
% hObject    handle to pb_selhistfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, datadir]=uigetfile({'*.*','All format(*.*)'});
if file==0 return; end

set(handles.ed_histfile, 'string', file);

file = [datadir, file];
SF = getappdata(gcbf, 'SF');
SF.ishist = 1;
c = specSAXSn2(file);
saxs = getgihandle;
saxs.specfile = file;
set(handles.pm_Norm, 'string', c);
set(handles.pm_I0, 'string', c);
setgihandle(saxs);
setappdata(gcbf, 'SF', SF);


% --- Executes on button press in rb_XEng.
function rb_XEng_Callback(hObject, eventdata, handles)
% hObject    handle to rb_XEng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_XEng
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
SF = getappdata(gcbf, 'SF');
SF.qEnergy = get(hObject,'Value');
setappdata(gcbf, 'SF', SF);



function ed_xengcol_Callback(hObject, eventdata, handles)
% hObject    handle to ed_xengcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_xengcol as text
%        str2double(get(hObject,'String')) returns contents of ed_xengcol as a double



% --- Executes on button press in rb_norm.
function rb_norm_Callback(hObject, eventdata, handles)
% hObject    handle to rb_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_norm
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
SF = getappdata(gcbf, 'SF');
contents = cellstr(get(handles.pm_Norm,'String'));
FN = contents{get(handles.pm_Norm,'Value')};
SF.qPHD = get(handles.rb_norm,'Value');
SF.PHDfieldname = FN;
setappdata(gcbf, 'SF', SF);



function ed_normcol_Callback(hObject, eventdata, handles)
% hObject    handle to ed_normcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_normcol as text
%        str2double(get(hObject,'String')) returns contents of ed_normcol as a double



function ed_avgdir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_avgdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_avgdir as text
%        str2double(get(hObject,'String')) returns contents of ed_avgdir as a double


% --- Executes during object creation, after setting all properties.
function ed_avgdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_avgdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_macro.
function pb_macro_Callback(hObject, eventdata, handles)
% hObject    handle to pb_macro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
%filelist = getfield(saxs, 'macrolist');
global avgmode
if isempty(avgmode)
    avgmode = 0;
end
saxs = getgihandle;
dirname = saxs.dir;
% load image
SAXSimageviewerhandle = evalin('base', 'SAXSimageviewerhandle');
h = guihandles(SAXSimageviewerhandle);
listoffile = get(h.FileListBox, 'string');
% run function
Nf =numel(listoffile);
for i=1:Nf
    filename = fullfile(dirname, listoffile{i});
    t = dir(filename);
    if ~isempty(t)
        if ~t.isdir
            %SAXSimageviewer(filename);
            saxs = loadimage(filename, saxs);
            handles.saxs = saxs;
            if avgmode == 0
                pb_SinglefileAverage_Callback([],[], handles)
            elseif avgmode == 1
                pb_SinglefileAverage_Callback([],[], handles, 1)
            end
            fprintf('Azim average done for %s, %i of %i\n', listoffile{i}, i, Nf)
        end
    end
end

function saxs = loadimage(filename, saxs)
    saxs = SAXSimageviwerLoadimage(filename, saxs);

    if isfield(saxs, 'imgoperation')
        if isfield(saxs.imgoperation, 'LeftRight')
            if saxs.imgoperation.LeftRight
                saxs.image = fliplr(saxs.image);
            end
        end
        if isfield(saxs.imgoperation, 'Transpose')
            if saxs.imgoperation.Transpose
                saxs.image = transpose(saxs.image);
            end
        end
        if isfield(saxs.imgoperation, 'UpDown')
            if saxs.imgoperation.UpDown
                saxs.image = flipud(saxs.image);
            end
        end
    end


% --- Executes on button press in pbmask.
function pbmask_Callback(hObject, eventdata, handles)
% hObject    handle to pbmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
saxs = getgihandle;
%if isfield(saxs, 'imgfigurehandle')
%    ImgFigHandle = getfield(saxs, 'imgfigurehandle');
%    ImgFigHandle = saxs.imgfigurehandle;
%else
%    ImgFigHandle = [];
%end

%data = double(get_imgFigure(ImgFigHandle))+10;
data = abs(double(saxs.image));
maskmake(log(data));


% --- Executes on button press in rbusemask.
function rbusemask_Callback(hObject, eventdata, handles)
% hObject    handle to rbusemask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbusemask
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
saxs = getgihandle;
%maskon = getfield(saxs, 'norminfo');
if get(hObject, 'Value') == 1
    saxs.maskon = 1;
else
    saxs.maskon = 0;
end
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);


% --- Executes on button press in pbloadmask.
function pbloadmask_Callback(hObject, eventdata, handles)
% hObject    handle to pbloadmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, datadir]=uigetfile({'*.*','All format(*.*)'});
if file==0 return; end
file = [datadir, file];

%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
saxs = getgihandle;
maskname = file;
saxs = setfield(saxs, 'maskname', maskname);


mask = imread(maskname);
saxs.mask = mask;
assignin('base', 'mask', mask);
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);


% --- Executes on button press in rd_Qoption1.
function rd_Qoption1_Callback(hObject, eventdata, handles)
% hObject    handle to rd_Qoption1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_Qoption1


% --- Executes on button press in rd_Qoption2.
function rd_Qoption2_Callback(hObject, eventdata, handles)
% hObject    handle to rd_Qoption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_Qoption2



function ed_offset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_offset as text
%        str2double(get(hObject,'String')) returns contents of ed_offset as a double


% --- Executes on button press in pb_SinglefileAverage.
function pb_SinglefileAverage_Callback(varargin)
% hObject    handle to pb_SinglefileAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global avgmode
handles = varargin{3};
if isfield(handles, 'saxs')
    saxs = handles.saxs;
    handles = rmfield(handles, 'saxs');
else
    saxs = getgihandle;
end

offset = str2double(get(handles.ed_offset, 'string'));
%saxs.ceilingintensity = eval(char(cellstr(get(handles.ed_maxcut, 'string'))));
saxs.ceilingintensity = [str2double(get(handles.ed_mincut, 'string')), str2double(get(handles.ed_maxcut, 'string'))];

switch handles.uibuttongroup1.SelectedObject.Tag
    case 'rb_AvgModeQ'
%if get(handles.rb_AvgModeQ, 'value')
        mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
        if numel(varargin) < 4
            avgmode = 0;
            out = doaverage2(double(saxs.image)-offset, saxs, deg2rad(mu));
        else
            avgmode = varargin{4};
            [out, ss] = doaverage2(double(saxs.image)-offset, saxs, deg2rad(mu), avgmode);
            if ~isempty(ss)
                setgihandle(ss);
            end
        end
%else
    case 'rb_AvgModeTh'
        avgmode = 0;
        thRange = eval(char(cellstr(get(handles.ed_thrange, 'string'))));
        qRange = getqrange(handles);
        inversion = get(handles.cb_inversion, 'value');
        out = doaverage3(double(saxs.image)-offset, saxs, thRange, qRange, inversion);
    case 'rb_AvgModeXcorr'
        avgmode = 0;
        if get(handles.cb_applyqdq, 'value')
            qrange = getqrange(handles);
            dq = qrange(2) - qrange(1);
            q = qrange(1) + dq;
            set(handles.ed_XCq1, 'string', num2str(q));
            set(handles.ed_XCq2, 'string', num2str(q));
            set(handles.ed_XCdq, 'string', num2str(dq));
        end
        q1 = str2double(get(handles.ed_XCq1, 'string'));
        q2 = str2double(get(handles.ed_XCq2, 'string'));
        dq = str2double(get(handles.ed_XCdq, 'string'));
        dth = str2double(get(handles.ed_XCdth, 'string'));
        out = Xcorr(double(saxs.image)-offset, saxs, q1, q2, dq, dth);
end
% Normalize and Energy correction and so on....
ishist = 0;
SF = getappdata(gcbf, 'SF');
if isfield(SF, 'ishist')
    if SF.ishist
        ishist = 1;
    end
end

qNorm = 0;

try
    sampleinfo = evalin('base', 'sampleinfo');
catch
    sampleinfo = [];
end

if ~isempty(sampleinfo)
    if strfind(sampleinfo.Filename{1}, saxs.imgname)
        qNorm = 1;
    end
else
    if ishist
        imgn = saxs.imgname;
        if imgn(1) == 'W'
            imgn(1) = 'S';
        end
        sampleinfo = specSAXSn2(saxs.specfile, imgn);
        qNorm = 1;
    end
end

if qNorm % normalization will be performed.
    if isfield(SF, 'qEnergy')
        if SF.qEnergy
            E0 = SF.Energy0;
            E = sampleinfo.Energy;
            out(:,1) = out(:,1)*E0/E;
        end
    end
    PHD = 1;
    if isfield(SF, 'qPHD')
        if SF.qPHD
            PHDFN = SF.PHDfieldname;
            PHD = sampleinfo.(PHDFN);
        end
    end
    I0 = 1;
    if isfield(SF, 'qI0')
        if SF.qPHD
            if ~isempty(SF.I0fieldname)
                I0FN = SF.I0fieldname;
                I0 = sampleinfo.(I0FN);
            end
        end
    end
    SFactor = 1;
    I0Ref = 1;
    t = 1;
    if isfield(SF, 'qSF')
        if SF.qSF
            SFactor = SF.SF;
        end
    end
    if isfield(SF, 'qI0Ref')
        if SF.qI0Ref
            I0Ref = SF.I0Ref;
        end
    end
    if isfield(SF, 'qSampleThickness')
        if SF.qSampleThickness
            t = SF.SampleThickness;
        end
    end
    
    out(:,2) = out(:,2)/PHD*SFactor*I0/I0Ref*t;
    cprintf('blue', 'Azim average and normalization are successfully done!\n');
else
    cprintf('blue', 'Azim average is successfully done!\n');
end

% plot and save...
assignin('base', 'out', out)
plotandsavecut(out, saxs, handles)

return

if numel(varargin) > 3
    doaverage(varargin{1}, varargin{2}, varargin{3}, varargin{4});
else
    doaverage(varargin{1}, varargin{2}, varargin{3})
end

function qRange = getqrange(handles)
    qRangestr = char(cellstr(get(handles.SelectqRange, 'string')));
    k = strfind(qRangestr, '/');
    if isempty(k)
        qRange = eval(qRangestr);
    else
        q = str2double(qRangestr(1:k-1));
        dq = str2double(qRangestr(k+1:end));
        qRange = [q-dq/2, q+dq/2];
    end

% --- Executes during object creation, after setting all properties.
function ed_xengcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_xengcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
saxs = getgihandle;
if ~isempty(saxs)
    if isfield(saxs, 'norminfo')
        set(hObject, 'string', num2str(saxs.norminfo.xengcol));
    end
end


% --- Executes during object creation, after setting all properties.
function ed_histfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_histfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
saxs = getgihandle;
if ~isempty(saxs)
    if isfield(saxs, 'norminfo')
    set(hObject, 'string', saxs.norminfo.histfile);
    end
end


% --- Executes during object creation, after setting all properties.
function ed_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
saxs = getgihandle;
if ~isempty(saxs)
    set(hObject, 'string', num2str(saxs.offset));
end


% --- Executes during object creation, after setting all properties.
function ed_normcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_normcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
saxs = getgihandle;
if ~isempty(saxs)
    if isfield(saxs, 'norminfo')
        set(hObject, 'string',num2str(saxs.norminfo.normcol));
    end
end

% --- Executes during object creation, after setting all properties.
function Selectmu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_qmap.
function pb_qmap_Callback(hObject, eventdata, handles)
% hObject    handle to pb_qmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
if isfield(saxs, 'image')
    imgsize = size(saxs.image);
    saxs.imgsize = imgsize;
end
x = 1:saxs.imgsize(2);
y = 1:saxs.imgsize(1);
[X, Y] = meshgrid(x, y);
[qmap, thmap, SF, ang] = pixel2q([X(:),Y(:)], saxs);
avgmap.qmap = qmap;
avgmap.thmap = thmap;
avgmap.SF = SF;
avgmap.polarization = sin((pi/2-ang(:,1)*pi/180));

if get(handles.rd_Qoption2, 'value')
    avgmap.qarray = linspace(0, str2double(get(handles.ed_qmax, 'string')), ...
        str2double(get(handles.ed_qN, 'string')));
else
    det_corner = [1, 1; 
        1, saxs.imgsize(1); 
        saxs.imgsize(2), 1;
        saxs.imgsize(2), saxs.imgsize(1)];
    det_corner = det_corner - repmat(saxs.center, 4, 1);
    dist = sqrt(det_corner(:,1).^2+det_corner(:,2).^2);
    maxdist = fix(max(dist));
    avgmap.qarray = linspace(0, max(qmap(:)), maxdist);
end

set(gcbf, 'userdata', avgmap);
assignin('base', 'azimavgmap', avgmap);
cprintf(-[1,0,1], 'qmap and thmap are ready.\n')

SF = getappdata(gcbf, 'SF');
SF.Energy0 = saxs.xeng;
setappdata(gcbf, 'SF', SF);




function ed_figureNum_Callback(hObject, eventdata, handles)
% hObject    handle to ed_figureNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_figureNum as text
%        str2double(get(hObject,'String')) returns contents of ed_figureNum as a double


% --- Executes during object creation, after setting all properties.
function ed_figureNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_figureNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_plotscale.
function pm_plotscale_Callback(hObject, eventdata, handles)
% hObject    handle to pm_plotscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_plotscale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_plotscale
fn = str2double(get(handles.ed_figureNum, 'string'));
ax = findobj(fn, 'type', 'axes');
if numel(ax)>1
    axN = findcellstr(get(ax, 'tag'), '');
    ax = ax(axN);
end
contents = get(handles.pm_plotscale, 'string');
str = contents{get(handles.pm_plotscale,'Value')};
%indbar = find(str, '-');
xs = str(1:3);
ys = str(5:7);
%switch get(hObject, 'string')
%    case 'lin-lin'
%    case 'lin-log'
%    case 'log-lin'
%    case 'log-log'
%end
set(ax, 'xscale', xs, 'yscale', ys)

% --- Executes during object creation, after setting all properties.
function pm_plotscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_plotscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CB_add2plot.
function CB_add2plot_Callback(hObject, eventdata, handles)
% hObject    handle to CB_add2plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_add2plot

function plotandsavecut(out, saxs, handles)
FN = saxs.imgname;
if isfield(saxs, 'h5entry')
    h5entry = saxs.h5entry;
    h5entry = replace(h5entry, '//', '');
    h5entry = replace(h5entry, '/', '_');
    FN = sprintf('%s_%s', FN, h5entry);
end
if isfield(saxs, 'frame')
    FN = sprintf('%s_%i', FN, saxs.frame);
end
switch handles.uibuttongroup1.SelectedObject.Tag
    case 'rb_AvgModeQ'
        mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
        mustr = '';
        if numel(mu)>0
            mustr = 'sector';
            for i=1:size(mu, 1)
                for j=1:size(mu, 2)
                    mustr = sprintf('%s_%s', mustr, num2str(mu(i, j)));
                end
            end
        end
    case 'rb_AvgModeTh'
        mu = eval(char(cellstr(get(handles.SelectqRange, 'string'))));
        mustr = 'azim';
        if numel(mu)>0
            for i=1:numel(mu)
                mustr = sprintf('%s_%s', mustr, num2str(mu(i)));
            end
        end
    case 'rb_AvgModeXcorr'
        q1 = (get(handles.ed_XCq1, 'string'));
        q2 = (get(handles.ed_XCq2, 'string'));
        dq = (get(handles.ed_XCdq, 'string'));
        %dth = (get(handles.ed_XCdth, 'string'));
        mustr = sprintf('XC_q%s-q%s-dq%s', strtrim(q1),strtrim(q2),strtrim(dq));
end

if numel(mustr) == 0
    cutname = sprintf('%s', FN);
else
    cutname = sprintf('%s-%s', FN, mustr);
end

op = plotoption;

% When you select to plot....
if get(handles.CB_add2plot, 'value')
    % ----------------------------------------------------------
    % plot data
    % ----------------------------------------------------------
    figN = str2double(get(handles.ed_figureNum, 'string'));
    try
        figure(figN);
        leg = get(figN, 'userdata');
        CNT = numel(leg);
        leg{CNT+1} = cutname;
    catch
        figN = figN+10;
        figure(figN);
        set(handles.ed_figureNum, 'string', num2str(figN));
        leg = get(figN, 'userdata');
        CNT = numel(leg);
        leg{CNT+1} = cutname;
    end
    %ax = findobj(figN, 'type', 'axes');
    set(gca, 'nextplot', 'add')

    if (CNT>numel(op)-1)
        CNT = 0;
    end
    if iscell(out)
        for k=1:numel(out)
            t = semilogy(out{k}(:,1), out{k}(:,2), [op{CNT+1}{1}, op{CNT+1}{2}, '-']);
            set(t, 'tag', cutname);
        end
    else
        t = semilogy(out(:,1), out(:,2), [op{CNT+1}{1}, op{CNT+1}{2}, '-']);
        set(t, 'tag', cutname);
    end
    legend(leg);
    set(figN, 'userdata', leg);
    pm_plotscale_Callback([], [], handles)
end

switch handles.uibuttongroup1.SelectedObject.Tag
    case 'rb_AvgModeQ'
        xlabel(sprintf('q [%c^{-1}]', char(197)), 'fontsize', 14)
        ylabel(sprintf('I(q) [cm^{-1}]', char(197)), 'fontsize', 14)
    case 'rb_AvgModeTh'
        xlabel('\theta [rad.]', 'fontsize', 14)
        ylabel(sprintf('I(q) [cm^{-1}]', char(197)), 'fontsize', 14)
    case 'rb_AvgModeXcorr'
        xlabel('\theta [deg.]', 'fontsize', 14)
        ylabel('XCorr(\theta)', 'fontsize', 14)
end

% ----------------------------------------------------------
% file save...........................
% ----------------------------------------------------------
savdir = saxs.dir;
subdir = get(handles.ed_avgdir, 'string');
directory = fullfile(savdir, subdir);
if ~isdir(directory)
    mkdir(directory)
end
FN = fullfile(savdir, subdir, sprintf('%s.dat', cutname));
fid = fopen(FN,'w');
%titlestr = sprintf('%% %s %s', cut.axisofinterest, 'Iq');
if size(out, 2) == 2
    formatSpec = '%0.8f %0.8f';
elseif size(out, 2) == 3
    formatSpec = '%0.8f %0.8f %0.8f';
elseif size(out, 2) == 4
    formatSpec = '%0.8f %0.8f %0.8f %0.8f';
end
formatSpec = sprintf('%s\n', formatSpec);
%fprintf(fid, '%s\n', titlestr);
%for row = 1:nrows
fprintf(fid,formatSpec,out');
%end
fclose(fid);
%end


% --- Executes on selection change in pm_Norm.
function pm_Norm_Callback(hObject, eventdata, handles)
% hObject    handle to pm_Norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_Norm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_Norm
SF = getappdata(gcbf, 'SF');
contents = cellstr(get(handles.pm_Norm,'String'));
FN = contents{get(handles.pm_Norm,'Value')};
SF.qPHD = get(handles.rb_norm,'Value');
SF.PHDfieldname = FN;
setappdata(gcbf, 'SF', SF);

% --- Executes during object creation, after setting all properties.
function pm_Norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_Norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_I0.
function rb_I0_Callback(hObject, eventdata, handles)
% hObject    handle to rb_I0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_I0
SF = getappdata(gcbf, 'SF');
contents = cellstr(get(handles.pm_I0,'String'));
FN = contents{get(handles.pm_I0,'Value')};
SF.qI0 = get(handles.rb_I0,'Value');
SF.I0fieldname = FN;
setappdata(gcbf, 'SF', SF);


% --- Executes on selection change in pm_I0.
function pm_I0_Callback(hObject, eventdata, handles)
% hObject    handle to pm_I0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_I0 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_I0


% --- Executes during object creation, after setting all properties.
function pm_I0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_I0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_ScaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ScaleFactor as text
%        str2double(get(hObject,'String')) returns contents of ed_ScaleFactor as a double
SF = getappdata(gcbf, 'SF');
SF.qSF = 1;
SF.SF = str2double(get(hObject,'string'));
setappdata(gcbf, 'SF', SF);


% --- Executes during object creation, after setting all properties.
function ed_ScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_I0ref_Callback(hObject, eventdata, handles)
% hObject    handle to ed_I0ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_I0ref as text
%        str2double(get(hObject,'String')) returns contents of ed_I0ref as a double
SF = getappdata(gcbf, 'SF');
SF.qI0Ref = 1;
SF.I0Ref = str2double(get(hObject,'string'));
setappdata(gcbf, 'SF', SF);


% --- Executes during object creation, after setting all properties.
function ed_I0ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_I0ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_samplethickness_Callback(hObject, eventdata, handles)
% hObject    handle to ed_samplethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_samplethickness as text
%        str2double(get(hObject,'String')) returns contents of ed_samplethickness as a double
SF = getappdata(gcbf, 'SF');
SF.qSampleThickness = 1;
SF.SampleThickness = str2double(get(hObject,'string'));
setappdata(gcbf, 'SF', SF);


% --- Executes during object creation, after setting all properties.
function ed_samplethickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_samplethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_SinglefileAverage_rmoutlier.
function pb_SinglefileAverage_rmoutlier_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SinglefileAverage_rmoutlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns pm_outlier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_outlier
choice = get(handles.pm_outlier,'Value');
pb_SinglefileAverage_Callback(hObject, eventdata, handles, choice);



function ed_maxcut_Callback(hObject, eventdata, handles)
% hObject    handle to ed_maxcut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_maxcut as text
%        str2double(get(hObject,'String')) returns contents of ed_maxcut as a double


% --- Executes during object creation, after setting all properties.
function ed_maxcut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_maxcut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_exportqmap.
function pb_exportqmap_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exportqmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qmap = get(gcbf, 'userdata');
if isempty(qmap)
    cprintf('err', 'qmap and thmap are not ready.\n');
    return
else
    assignin('base', 'qmap', qmap)
end

[filename, pathname] = uiputfile( ...
   '*.mat', ...
    'Save as');

% This code checks if the user pressed cancel on the dialog.

if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
   return
else
   disp(['User selected ', fullfile(pathname, filename)])
end

fn = fullfile(pathname, filename);
save(fn, 'qmap');


% --- Executes on selection change in pm_outlier.
function pm_outlier_Callback(hObject, eventdata, handles)
% hObject    handle to pm_outlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_outlier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_outlier


% --- Executes during object creation, after setting all properties.
function pm_outlier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_outlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_AvgModeQ.
function rb_AvgModeQ_Callback(hObject, eventdata, handles)
% hObject    handle to rb_AvgModeQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_AvgModeQ


% --- Executes on button press in rb_AvgModeTh.
function rb_AvgModeTh_Callback(hObject, eventdata, handles)
% hObject    handle to rb_AvgModeTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_AvgModeTh



function SelectqRange_Callback(hObject, eventdata, handles)
% hObject    handle to SelectqRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SelectqRange as text
%        str2double(get(hObject,'String')) returns contents of SelectqRange as a double


% --- Executes during object creation, after setting all properties.
function SelectqRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectqRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function showqrange(handles)
saxs = getgihandle;

ImgFigHandle = evalin('base', 'SAXSimageviewerhandle');
saxs.imgfigurehandle = ImgFigHandle;


%qrange = eval(char(cellstr(get(handles.SelectqRange, 'string'))));
qrange = getqrange(handles);
t = numel(qrange)/2;
if isfield(saxs, 'center')
    center = saxs.center;
else
    error('Set the coordinates of an image center on SAXSLee panel')
end
imgsize = saxs.imgsize;
imgFigurehandle = saxs.imgfigurehandle;
azimhandle = [];
azim = 0:1:360;
for i=1:1:t
    for j=1:2
        q = qrange(i,j); %:mu(i,2)
        %azimangle = j;
        figure(imgFigurehandle);hold on;
        %[x, y] = azimang2coord(imgsize(1), imgsize(2), center(1), center(2), azimangle);
        p = q2pixel([q*ones(length(azim), 1), zeros(length(azim), 1), azim(:)], saxs.waveln, saxs.center, saxs.psize, saxs.SDD);
        tt=plot(p(:,1),p(:,2));
        azimhandle = [azimhandle,tt];
    end
end
saxs.azimlinehandle = azimhandle;
%set(hSAXSlee, 'userdata', saxs);
setgihandle(saxs)


% --- Executes on button press in pbShowqRange.
function pbShowqRange_Callback(hObject, eventdata, handles)
% hObject    handle to pbShowqRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showqrange(handles)

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pbazimclear_Callback(hObject, eventdata, handles)


function ed_thrange_Callback(hObject, eventdata, handles)
% hObject    handle to ed_thrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_thrange as text
%        str2double(get(hObject,'String')) returns contents of ed_thrange as a double


% --- Executes during object creation, after setting all properties.
function ed_thrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_thrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_loadqmap.
function pb_loadqmap_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadqmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
   {'*.mat','mat file (*.dat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a file', ...
    'MultiSelect', 'off');

% This code checks if the user pressed cancel on the dialog.

if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
   return
else
   disp(['User selected ', fullfile(pathname, filename)])
end

temp = load(fullfile(pathname, filename));
% evalin('base', temp.qmap);
set(gcbf, 'userdata', temp.qmap);



function ed_XCq2_Callback(hObject, eventdata, handles)
% hObject    handle to ed_XCq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_XCq2 as text
%        str2double(get(hObject,'String')) returns contents of ed_XCq2 as a double


% --- Executes during object creation, after setting all properties.
function ed_XCq2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_XCq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_XCq1_Callback(hObject, eventdata, handles)
% hObject    handle to ed_XCq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_XCq1 as text
%        str2double(get(hObject,'String')) returns contents of ed_XCq1 as a double


% --- Executes during object creation, after setting all properties.
function ed_XCq1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_XCq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_XCdq_Callback(hObject, eventdata, handles)
% hObject    handle to ed_XCdq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_XCdq as text
%        str2double(get(hObject,'String')) returns contents of ed_XCdq as a double


% --- Executes during object creation, after setting all properties.
function ed_XCdq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_XCdq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function showqrangeXC(handles)
saxs = getgihandle;

ImgFigHandle = evalin('base', 'SAXSimageviewerhandle');
saxs.imgfigurehandle = ImgFigHandle;


%qrange = eval(char(cellstr(get(handles.SelectqRange, 'string'))));
q1 = str2double(get(handles.ed_XCq1, 'string'));
q2 = str2double(get(handles.ed_XCq2, 'string'));
dq = str2double(get(handles.ed_XCdq, 'string'));
dth = str2double(get(handles.ed_XCdth, 'string'));

qrange = [q1-dq/2, q1+dq/2; q2-dq/2, q2+dq/2];
%t = numel(qrange)/2;
if isfield(saxs, 'center')
    center = saxs.center;
else
    error('Set the coordinates of an image center on SAXSLee panel')
end
imgsize = saxs.imgsize;
imgFigurehandle = saxs.imgfigurehandle;
azimhandle = [];
azim = 0:1:360;
col = {'r', 'b'};
for i=1:2
    for j=1:2
        q = qrange(i,j); %:mu(i,2)
        %azimangle = j;
        figure(imgFigurehandle);hold on;
        %[x, y] = azimang2coord(imgsize(1), imgsize(2), center(1), center(2), azimangle);
        p = q2pixel([q*ones(length(azim), 1), zeros(length(azim), 1), azim(:)], saxs.waveln, saxs.center, saxs.psize, saxs.SDD);
        tt = plot(p(:,1),p(:,2), col{i});
        azimhandle = [azimhandle,tt];
    end
end
saxs.azimlinehandle = azimhandle;
%set(hSAXSlee, 'userdata', saxs);
setgihandle(saxs)


% --- Executes on button press in pbShowqRangeXC.
function pbShowqRangeXC_Callback(hObject, eventdata, handles)
% hObject    handle to pbShowqRangeXC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showqrangeXC(handles)

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pbazimclear_Callback(hObject, eventdata, handles)


function ed_XCdth_Callback(hObject, eventdata, handles)
% hObject    handle to ed_XCdth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_XCdth as text
%        str2double(get(hObject,'String')) returns contents of ed_XCdth as a double


% --- Executes during object creation, after setting all properties.
function ed_XCdth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_XCdth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_showazim.
function cb_showazim_Callback(hObject, eventdata, handles)
% hObject    handle to cb_showazim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_showazim
if get(hObject, 'Value')
    show_sectoravg_azim(handles);
else
    clear_sectoravg_azim
end

% --- Executes on button press in cb_showqrange.
function cb_showqrange_Callback(hObject, eventdata, handles)
% hObject    handle to cb_showqrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_showqrange
if get(hObject,'Value')
    showqrange(handles)
else
    clear_sectoravg_azim
end


% --- Executes on button press in cb_inversion.
function cb_inversion_Callback(hObject, eventdata, handles)
% hObject    handle to cb_inversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_inversion


% --- Executes on button press in cb_showqrangeXC.
function cb_showqrangeXC_Callback(hObject, eventdata, handles)
% hObject    handle to cb_showqrangeXC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_showqrangeXC

if get(hObject,'Value')
    showqrangeXC(handles)
else
    clear_sectoravg_azim
end


% --- Executes on button press in cb_applyqdq.
function cb_applyqdq_Callback(hObject, eventdata, handles)
% hObject    handle to cb_applyqdq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_applyqdq
handlelist = [handles.ed_XCq1, handles.ed_XCq2, handles.ed_XCdq];

if get(hObject,'Value')
    qrange = getqrange(handles);
    set(handles.ed_XCq1, 'string', num2str(qrange(1)));
    set(handles.ed_XCq2, 'string', num2str(qrange(2)));
    set(handles.ed_XCdq, 'string', num2str(qrange(2)-qrange(1)));
    
    for i=1:numel(handlelist)
        set(handlelist(i), 'enable', 'off')
    end
else
    for i=1:numel(handlelist)
        set(handlelist(i), 'enable', 'on')
    end
end



function ed_mincut_Callback(hObject, eventdata, handles)
% hObject    handle to ed_mincut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_mincut as text
%        str2double(get(hObject,'String')) returns contents of ed_mincut as a double


% --- Executes during object creation, after setting all properties.
function ed_mincut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_mincut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
