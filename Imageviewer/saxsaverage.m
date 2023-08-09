function varargout = saxsaverage(varargin)
% SAXSLee Application M-file for untitled.fig
%    FIG = SAXSLee launch untitled GUI.
%    UNTITLED('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 03-Jun-2015 11:26:28
%
% How to use this macro............. on command line....
% saxsaverage('doaverage', {}, {}, {}, ar)

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
%| tags as fieldnames, e.g. handles.SAXSavg, handles.slider2. This
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

N_thrange = numel(mu)/2;
if N_thrange == 0
    N_thrange = 1;
    thrange = [];
else
    thrange = mu(1, 1:2);
end

if N_thrange > 1
    data = cell(size(N_thrange));
else
    data = [];
end

for i=1:N_thrange
    if N_thrange>1
        thrange = mu(i, 1:2);
    end
    [q, Iq] = azimavg(img, avg.qmap, avg.qarray, avg.SF, avg.thmap, thrange, mk);
    if N_thrange>1
        data{i} = [q(:), Iq(:)];
    else
        data = [q(:), Iq(:)];
    end
end
varargout{1} = data;


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
[row, col] = size(D);
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
if strcmp(get(handles.SAXSavg,'SelectionType'),'open') % If double click
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
%guidata(handles.SAXSavg,handles)
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
saxs = getgihandle;

ImgFigHandle = evalin('base', 'SAXSimageviewerhandle');
saxs.imgfigurehandle = ImgFigHandle;


mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
t = numel(mu)/2;
if isfield(saxs, 'center')
    center=getfield(saxs,'center');
else
    error('Set the coordinates of an image center on SAXSLee panel')
end
imgsize=getfield(saxs,'imgsize');
imgFigurehandle=getfield(saxs,'imgfigurehandle');
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
saxs=setfield(saxs, 'azimlinehandle', azimhandle);
%set(hSAXSlee, 'userdata', saxs);
setgihandle(saxs)


% --- Executes on button press in pbazimclear.
function pbazimclear_Callback(hObject, eventdata, handles)
% hObject    handle to pbazimclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hSAXSlee=findobj('Tag','GISAXSLee');
%saxs=get(hSAXSlee, 'Userdata');
saxs = getgihandle;
azimh = getfield(saxs, 'azimlinehandle');
saxs = setfield(saxs,'azimlinehandle',[]);
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);
delete(azimh);



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
file = [datadir, file];
set(handles.ed_histfile, 'string', file);
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
saxs = getgihandle;
if ~isfield(saxs, 'norminfo')
    saxs = setfield(saxs, 'norminfo', []);
end
norminfo = getfield(saxs, 'norminfo');
norminfo.histfile = file;
saxs = setfield(saxs, 'norminfo', norminfo);
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);

% --- Executes on button press in rb_XEng.
function rb_XEng_Callback(hObject, eventdata, handles)
% hObject    handle to rb_XEng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_XEng
%hSAXSlee = findobj('Tag', 'GISAXSLee');
%saxs = get(hSAXSlee, 'Userdata');
saxs = getgihandle;
if ~isfield(saxs, 'norminfo')
    saxs = setfield(saxs, 'norminfo',[]);
end
norminfo = getfield(saxs, 'norminfo');
if get(hObject, 'Value')
    histc = str2num(char(cellstr(get(handles.ed_xengcol, 'string'))));
    norminfo.xengcol = histc;
else
    norminfo.xengcol = 0;
end
saxs = setfield(saxs, 'norminfo', norminfo);
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);




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
saxs = getgihandle;
if ~isfield(saxs, 'norminfo')
    saxs = setfield(saxs, 'norminfo',[]);
end
norminfo = getfield(saxs, 'norminfo');
if get(hObject, 'Value') == 1
    normc = str2num(char(cellstr(get(handles.ed_normcol, 'string'))));
    norminfo.normcol = normc;
else
    norminfo.normcol = 0;
end
saxs = setfield(saxs, 'norminfo', norminfo);
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);


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

saxs = getgihandle;
imgh = evalin('base', 'SAXSimageviewerhandle');
t = findobj(get(imgh, 'children'), 'Tag', 'FileListBox');
filelist = get(t, 'string');
path = getfield(saxs, 'dir');
ar{1} = path;tic;
waveln = getfield(saxs, 'waveln');
normval = 1;
isnorm = 0;

if ~isfield(saxs, 'norminfo')
    norminfo.avgdir = '';
    norminfo.histfile = '';
    norminfo.xengcol = 0;
    norminfo.normcol = 0;
else
    norminfo = getfield(saxs, 'norminfo');
    if ~isfield(norminfo, 'histfile')
        norminfo.histfile = '';
    end
    if ~isfield(norminfo, 'xengcol')
        norminfo.xengcol = 0;
    else
        norminfo.xengcol = str2num(get(handles.ed_xengcol, 'string'));
    end
    if ~isfield(norminfo, 'avgdir')
        norminfo.avgdir = '';
    end
    if ~isfield(norminfo, 'normcol')
        norminfo.normcol = 0;
    else
        norminfo.normcol = str2num(get(handles.ed_normcol, 'string'));
    end
    histfile = norminfo.histfile;
    xengcol = norminfo.xengcol;
    normcol = norminfo.normcol;

    %if isfield(saxs, 'wildcard')
%        searchstr = saxs.wildcard;
    %    nor = specSAXSn2(histfile, filelist, 0);
    %else
    %    nor = [];
    %end
    
    %if numel(nor)>0
    %    isnorm = 1;
    %end
end

for i=1:length(filelist);
    fid = fopen(fullfile(saxs.dir, filelist{i}));
    if fid > 0
        fclose(fid);
        ar{2} = filelist{i};
        fid2 = fopen(histfile);
        if fid2 > 0
            nor = specSAXSn2(histfile, filelist{i}, 1);
        else
            nor = [];
        end
        %if isnorm
            if (xengcol ~=0); 
                waveln = eng2wl(nor(xengcol)); 
            else
                waveln = saxs.waveln;
            end
            if (normcol ~=0); 
                normval = nor(normcol); 
            else
                normval = 1;
            end
        %end
%        if isnorm
%            if (xengcol ~=0); waveln = eng2wl(nor(i,xengcol)); end
%            if (normcol ~=0); normval = nor(i,normcol); end
%        end
        
        ar{3} = waveln;
        ar{4} = normval;
        pushbutton4_Callback(hObject, eventdata, handles, ar);
    end
%    fclose(fid);
end
toc



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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(varargin)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
handles = varargin{3};
mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
out = doaverage2(double(saxs.image), saxs, deg2rad(mu));
assignin('base', 'out', out)
plotandsavecut(out, saxs, handles)

return

if numel(varargin) > 3
    doaverage(varargin{1}, varargin{2}, varargin{3}, varargin{4});
else
    doaverage(varargin{1}, varargin{2}, varargin{3})
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
function SAXSavg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SAXSavg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_qmap.
function pb_qmap_Callback(hObject, eventdata, handles)
% hObject    handle to pb_qmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
x = 1:saxs.imgsize(1);
y = 1:saxs.imgsize(2);
[X, Y] = meshgrid(x, y);
[qmap, thmap, SF] = pixel2q([X(:),Y(:)], saxs);
avgmap.qmap = qmap;
avgmap.thmap = thmap;
avgmap.SF = SF;

if get(handles.rd_Qoption2, 'value')
    avgmap.qarray = linspace(0, str2double(get(handles.ed_qmax, 'string')), ...
        str2double(get(handles.ed_qN, 'string')));
else
    avgmap.qarray = linspace(0, max(qmap(:)), saxs.imgsize(1));
end

set(gcbf, 'userdata', avgmap);
cprintf(-[1,0,1], 'qmap and thmap are ready.\n')



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
mu = eval(char(cellstr(get(handles.Selectmu, 'string'))));
mustr = '';
if numel(mu)>0
    for i=1:numel(mu);
        mustr = sprintf('%s_%s', mustr, num2str(mu(i)));
    end
end
if numel(mustr) == 0
    cutname = sprintf('%s', FN);
else
    cutname = sprintf('%s-azim_%s', FN, mustr);
end

op = plotoption;

% When you select to plot....
if get(handles.CB_add2plot, 'value')
    % ----------------------------------------------------------
    % plot data
    % ----------------------------------------------------------
    figN = str2double(get(handles.ed_figureNum, 'string'));
    figure(figN);
    leg = get(figN, 'userdata');
    CNT = numel(leg);
    leg{CNT+1} = cutname;
    %ax = findobj(figN, 'type', 'axes');
    set(gca, 'nextplot', 'add')

    if (CNT>numel(op)-1)
        CNT = 0;
    end
    t = semilogy(out(:,1), out(:,2), [op{CNT+1}{1}, op{CNT+1}{2}, '-']);
    set(t, 'tag', cutname);
    legend(leg);
    set(figN, 'userdata', leg);
    pm_plotscale_Callback([], [], handles)
end

% ----------------------------------------------------------
% file save...........................
% ----------------------------------------------------------

fid = fopen(sprintf('%s.dat', cutname),'w');
%titlestr = sprintf('%% %s %s', cut.axisofinterest, 'Iq');
formatSpec = '%0.8f %0.8f';
formatSpec = sprintf('%s\n', formatSpec);
%fprintf(fid, '%s\n', titlestr);
%for row = 1:nrows
fprintf(fid,formatSpec,out');
%end
fclose(fid);
%end


% --- Executes on button press in pb_qmap2workspace.
function pb_qmap2workspace_Callback(hObject, eventdata, handles)
% hObject    handle to pb_qmap2workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)avg = get(gcbf, 'userdata');
qmap = get(gcbf, 'userdata');
if isempty(qmap)
    cprintf('err', 'qmap and thmap are not ready.\n');
    return
else
    assignin('base', 'qmap', qmap)
end
