function varargout = gifit(varargin)
% gifit M-file for gifit.fig
%      gifit, by itself, creates a new gifit or raises the existing
%      singleton*.
%
%      H = gifit returns the handle to a new gifit or the handle to
%      the existing singleton*.
%
%      gifit('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gifit.M with the given input arguments.
%
%      gifit('Property','Value',...) creates a new gifit or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gifit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gifit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gifit

% Last Modified by GUIDE v2.5 20-Jul-2013 12:16:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gifit_OpeningFcn, ...
                   'gui_OutputFcn',  @gifit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
warning('off','MATLAB:dispatcher:InexactMatch')
% End initialization code - DO NOT EDIT


% --- Executes just before gifit is made visible.
function gifit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gifit (see VARARGIN)

% Choose default command line output for gifit
warning off all;

handles.output = hObject;
%handles.particle = [handles.pbAdd, handles.pbremove, handles.pbset, handles.pmParticle ];
handles.particle = handles.pnParticle;
handles.layer = handles.pnlayer;
handles.data = handles.pnData;
handles.fit = handles.pnFit;
handles.panels = [handles.pnParticle, handles.pnlayer, handles.pnData, handles.pnFit];
set(handles.layer, 'Visible', 'off');
set(handles.particle, 'Visible', 'off');
set(handles.data, 'Visible', 'off');
set(handles.fit, 'Visible', 'off');

% ----------------------------
% window positioning
% ----------------------------
% set(hObject, 'position', [520, 405, 303, 320]);

% ----------------------------
% model initialize
% ----------------------------
model = gf_model([], 'ini');

layer_update(model, 1, handles);
md = gf_model(model, 'cell2struct', 'layer');
md = md.layer;
%num = numel(md.edensity);
t = numlist2cellstr(md.number);
set(handles.pmlayer, 'string', t);
set(handles.pmLayerofparticle, 'string', t);
%pos = get(handles.pnParticle, 'position')
set(handles.pnlayer, 'position', get(handles.pnParticle, 'position'));
set(handles.pnData, 'position', get(handles.pnParticle, 'position'));
set(handles.pnFit, 'position', get(handles.pnParticle, 'position'));
set(hObject, 'userdata', model);
get(hObject, 'userdata');


% initialize Data panel
set(handles.pmData, 'callback', @gf_data);
set(handles.eddatatag, 'callback', {@gf_data, 'tag'});
set(handles.edNpntsfit, 'callback', {@gf_data, 'pntfit'});
set(handles.edSAXSmode, 'callback', {@gf_data, 'SAXSmode'});
set(handles.rdFitorNot, 'callback', {@gf_data, 'optfit'});
set(handles.rdPlotorNot, 'callback', {@gf_data, 'optplot'});
set(handles.pmxcol, 'callback', {@gf_data, 'optxcol'});
set(handles.pmycol, 'callback', {@gf_data, 'optycol'});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gifit wait for user response (see UIRESUME)
% uiwait(handles.gifit);


% --- Outputs from this function are returned to the command line.
function varargout = gifit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbmodel.
function pbmodel_Callback(hObject, eventdata, handles)
% hObject    handle to pbmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pbfilm.
function pbfilm_Callback(hObject, eventdata, handles)
% hObject    handle to pbfilm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switchPanel('layer', handles)


% --- Executes on button press in pbparticle.
function pbparticle_Callback(hObject, eventdata, handles)
% hObject    handle to pbparticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switchPanel('particle', handles);

function switchPanel(nameforon, handles)
panels = handles.panels;
for i=1:numel(panels)
    set(panels(i), 'visible', 'off');
end
set(handles.(nameforon), 'visible', 'on');

% --- Executes on selection change in pmParticle.
function pmParticle_Callback(hObject, eventdata, handles)
% hObject    handle to pmParticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmParticle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmParticle
%num = numel(md.edensity);
model = get(gcbf, 'userdata');
num = get(hObject, 'value');
t = numel(model.particle);
if (t<num)
    return;
end

if isfield(model.particle{num}, 'layer');
    fstring = model.particle{num}.layer;
    ret = pmfind(handles.pmLayerofparticle, fstring);
    set(handles.pmLayerofparticle, 'value', ret);
end

if ~isfield(model.particle{num}, 'Fq');
    return;
end

fstring = model.particle{num}.Fq.name;
ret = pmfind(handles.pmFq, fstring);
set(handles.pmFq, 'value', ret);

fstring = model.particle{num}.Sq.name;
ret = pmfind(handles.pmSq, fstring);
set(handles.pmSq, 'value', ret);

fstring = model.particle{num}.CT.name;
ret = pmfind(handles.pmCT, fstring);
set(handles.pmCT, 'value', ret);





function ret = pmfind(pmhandle, fstring)

cont = get(pmhandle, 'String');
ret = findcellstr(cont, fstring);
        


% --- Executes during object creation, after setting all properties.
function pmParticle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmParticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbremove.
function pbremove_Callback(hObject, eventdata, handles)
% hObject    handle to pbremove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = numel(get(handles.pmParticle, 'string'));
if t<2
    return;
end
sellayer = get(handles.pmParticle, 'value');
model = get(gcbf, 'userdata');
model = gf_model(model, 'remove', 'particle', sellayer);
%particle_update(model, sellayer, handles);
%t = numel(model.particle);
%num = numel(md.edensity);
num = numlist2cellstr((1:t-1));
set(handles.pmParticle, 'string', num);
set(gcbf, 'userdata', model);


% --- Executes on button press in pbset.
function pbset_Callback(hObject, eventdata, handles)
% hObject    handle to pbset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = numel(get(handles.pmParticle, 'string'));
if t<2
    return;
end
sellayer = get(handles.pmParticle, 'value');
model = get(gcbf, 'userdata');
model = gf_model(model, 'remove', 'particle', sellayer);
if ~isfield(model.particle{sellayer}, 'Fq')
    disp('Select Fq function and click set button next to popupmenu')
end
if ~isfield(model.particle{sellayer}, 'Sq')
    disp('Select Sq function and click set button next to popupmenu')
end
if ~isfield(model.particle{sellayer}, 'CT')
    disp('Select CT function and click set button next to popupmenu')
end

t = numel(get(handles.pmLayerofparticle, 'string'));
if t<2
    return;
end
p = get(handles.pmLayerofparticle, 'value');
model.particle{sellayer}.layer = t(p);

%pbFq_Callback(hObject, eventdata, handles);
%pbSq_Callback(hObject, eventdata, handles);
%pbCT_Callback(hObject, eventdata, handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pbfilm.
function pbfilm_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pbfilm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pmlayer.
function pmlayer_Callback(hObject, eventdata, handles)
% hObject    handle to pmlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmlayer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmlayer
model = get(gcbf, 'userdata');
layer_update(model, get(hObject,'Value'), handles);


% --- Executes during object creation, after setting all properties.
function pmlayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbremovelayer.
function pbremovelayer_Callback(hObject, eventdata, handles)
% hObject    handle to pbremovelayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sellayer = get(handles.pmlayer, 'value');
t = get(handles.pmlayer, 'string');
if numel(t) < 2
    return
end
model = get(gcbf, 'userdata');
model = gf_model(model, 'remove', 'layer', sellayer);
layer_update(model, sellayer, handles);
%t(end) = [];
md = gf_model(model, 'cell2struct', 'layer');md = md.layer;
t = numlist2cellstr(md.number);
set(handles.pmlayer, 'string', t);
set(handles.pmLayerofparticle, 'string', t);
set(gcbf, 'userdata', model);




% --- Executes on button press in pbshowxr.
function pbshowxr_Callback(hObject, eventdata, handles)
% hObject    handle to pbshowxr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
md = gf_model(get(gcbf, 'userdata'), 'cell2struct', 'layer');md = md.layer;
x = eval(get(handles.edxrX, 'string'));
%x = x*pi/180;

[Ti, Tf, Ri, Rf, kiz, kfz] = GISAXS_wave_Amp_Vector(x, x, 0, 12.576/md.xEng, md.edensity, md.beta, md.interface(2:end), md.roughness(2:end));
figure;semilogy(x, abs(Ri(:,1)).^2);




% --- Executes on button press in pbaddlayer.
function pbaddlayer_Callback(hObject, eventdata, handles)
% hObject    handle to pbaddlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = get(handles.pmlayer, 'string');
sellayer = get(handles.pmlayer, 'value');

model = get(gcbf, 'userdata');
model = gf_model(model, 'add', 'layer', sellayer);
layer_update(model, sellayer, handles);
md = gf_model(model, 'cell2struct', 'layer');md = md.layer;
t = numlist2cellstr(md.number);
%num = num2str(numel(t) + 1); t = [t(:); num];
set(handles.pmlayer, 'string', t);
set(handles.pmLayerofparticle, 'string', t);
set(gcbf, 'userdata', model);



function edEden_Callback(hObject, eventdata, handles)
% hObject    handle to edEden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edEden as text
%        str2double(get(hObject,'String')) returns contents of edEden as a double
model = get(gcbf, 'userdata');
sellayer = get(handles.pmlayer, 'value');
model.layer{1,2}(sellayer) = str2num(get(hObject, 'string'));
set(gcbf, 'userdata', model);


% --- Executes during object creation, after setting all properties.
function edEden_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edEden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edBeta_Callback(hObject, eventdata, handles)
% hObject    handle to edBeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edBeta as text
%        str2double(get(hObject,'String')) returns contents of edBeta as a double
model = get(gcbf, 'userdata');
sellayer = get(handles.pmlayer, 'value');
model.layer{2,2}(sellayer) = str2num(get(hObject, 'string'));
set(gcbf, 'userdata', model);


% --- Executes during object creation, after setting all properties.
function edBeta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edBeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edThick_Callback(hObject, eventdata, handles)
% hObject    handle to edThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edThick as text
%        str2double(get(hObject,'String')) returns contents of edThick as a double
model = get(gcbf, 'userdata');
sellayer = get(handles.pmlayer, 'value');
model.layer{3,2}(sellayer) = str2num(get(hObject, 'string'));
set(gcbf, 'userdata', model);


% --- Executes during object creation, after setting all properties.
function edThick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edThick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edRough_Callback(hObject, eventdata, handles)
% hObject    handle to edRough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edRough as text
%        str2double(get(hObject,'String')) returns contents of edRough as a double
model = get(gcbf, 'userdata');
sellayer = get(handles.pmlayer, 'value');
model.layer{4,2}(sellayer) = str2num(get(hObject, 'string'));
set(gcbf, 'userdata', model);


% --- Executes during object creation, after setting all properties.
function edRough_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edRough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edEnergy_Callback(hObject, eventdata, handles)
% hObject    handle to edEnergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edEnergy as text
%        str2double(get(hObject,'String')) returns contents of edEnergy as a double
model = get(gcbf, 'userdata');
%sellayer = get(handles.pmlayer, 'value');
model = gf_model(model, 'set', 'layer', 'xEng', str2num(get(hObject, 'string')));
%gf_model(model, 'get', 'layer', 'xEng');
set(gcbf, 'userdata', model);


% --- Executes during object creation, after setting all properties.
function edEnergy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edEnergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function layer_update(model, sellayer, handles)
md = gf_model(model, 'cell2struct', 'layer');lay = md.layer;
set(handles.edEden, 'string', lay.edensity(sellayer));
set(handles.edBeta, 'string', lay.beta(sellayer));
set(handles.edThick, 'string', lay.interface(sellayer));
set(handles.edRough, 'string', lay.roughness(sellayer));
set(handles.edEnergy, 'string', lay.xEng);


function edxrX_Callback(hObject, eventdata, handles)
% hObject    handle to edxrX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edxrX as text
%        str2double(get(hObject,'String')) returns contents of edxrX as a double


% --- Executes during object creation, after setting all properties.
function edxrX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edxrX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function pnlayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pnlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in pmFq.
function pmFq_Callback(hObject, eventdata, handles)
% hObject    handle to pmFq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmFq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmFq


% --- Executes during object creation, after setting all properties.
function pmFq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmFq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmSq.
function pmSq_Callback(hObject, eventdata, handles)
% hObject    handle to pmSq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmSq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmSq


% --- Executes during object creation, after setting all properties.
function pmSq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmSq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmCT.
function pmCT_Callback(hObject, eventdata, handles)
% hObject    handle to pmCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmCT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmCT


% --- Executes during object creation, after setting all properties.
function pmCT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --------------------------------------------------------------------
function umFile_Callback(hObject, eventdata, handles)
% hObject    handle to umFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function umOpen_Callback(hObject, eventdata, handles)
% hObject    handle to umOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.ini', 'Pick an ini file');
filen = strcat(pathname, filename);
ininfo = gf_readini(filen);
set(handles.pmSq, 'string', ininfo.SqFile);
set(handles.pmFq, 'string', ininfo.FqFile);
set(handles.pmCT, 'string', ininfo.CTFile);



% --- Executes on button press in pbAdd.
function pbAdd_Callback(hObject, eventdata, handles)
% hObject    handle to pbAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = get(gcbf, 'userdata');
%t = numel(model.particle);
t = numel(get(handles.pmParticle, 'string'));
%num = numel(md.edensity);
num = numlist2cellstr((1:t+1));
set(handles.pmParticle, 'string', num);


% --- Executes during object creation, after setting all properties.
function gifit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gifit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pbFq.
function pbFq_Callback(hObject, eventdata, handles)
% hObject    handle to pbFq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = get(gcbf, 'userdata');
sellayer = get(handles.pmParticle, 'value');
conts = get(handles.pmFq, 'string');
if sellayer > numel(model.particle)
    model.particle{sellayer} = '';
end
if isempty(model.particle)
    model.particle{1}.Fq = '';
    model.particle{1}.Fq.name = '';
    model.particle{1}.Fq.param = '';
elseif ~isfield(model.particle{sellayer}, 'Fq')
    model.particle{sellayer}.Fq = '';
    model.particle{sellayer}.Fq.name = '';
    model.particle{sellayer}.Fq.param = '';
end
if ~strcmp(model.particle{sellayer}.Fq.name, conts{get(handles.pmFq, 'value')})
    model.particle{sellayer}.Fq.name = conts{get(handles.pmFq, 'value')};
    model.particle{sellayer}.Fq.param = feval(model.particle{sellayer}.Fq.name);
end
%model.particle{sellayer}.param
gf_parameter(model.particle{sellayer}.Fq.param, gcbf, sellayer, 'Fq');
set(gcbf, 'userdata', model);

% --- Executes on button press in pbSq.
function pbSq_Callback(hObject, eventdata, handles)
% hObject    handle to pbSq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = get(gcbf, 'userdata');
sellayer = get(handles.pmParticle, 'value');
conts = get(handles.pmSq, 'string');
if ~isfield(model.particle{sellayer}, 'Sq')         % check whether field named 'Sq' exist or not.
    model.particle{sellayer}.Sq = '';
    model.particle{sellayer}.Sq.name = '';
    model.particle{sellayer}.Sq.param = '';
end
if ~strcmp(model.particle{sellayer}.Sq.name, conts{get(handles.pmSq, 'value')})
    model.particle{sellayer}.Sq.name = conts{get(handles.pmSq, 'value')};      % put selected string as a name of Fq.
    model.particle{sellayer}.Sq.param = feval(model.particle{sellayer}.Sq.name);  % initialize parameters;
end
%model.particle{sellayer}.param
gf_parameter(model.particle{sellayer}.Sq.param, gcbf, sellayer, 'Sq');
set(gcbf, 'userdata', model);

% --- Executes on button press in pbCT.
function pbCT_Callback(hObject, eventdata, handles)
% hObject    handle to pbCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model = get(gcbf, 'userdata');
sellayer = get(handles.pmParticle, 'value');
conts = get(handles.pmCT, 'string');
if ~isfield(model.particle{sellayer}, 'CT')         % check whether field named 'Fq' exist or not.
    model.particle{sellayer}.CT = '';
end

model.particle{sellayer}.CT.name = conts{get(handles.pmCT, 'value')};

if strcmp(conts{get(handles.pmCT, 'value')}, 'none')
    model.particle{sellayer}.CT.param = {};
else
    if ~strcmp(model.particle{sellayer}.CT, conts{get(handles.pmCT, 'value')})
              % put selected string as a name of Fq.
        model.particle{sellayer}.CT.param = feval(model.particle{sellayer}.CT.name);  % initialize parameters;
    end
    if ~isempty(model.particle{sellayer}.CT.param)
        gf_parameter(model.particle{sellayer}.CT.param, gcbf, sellayer, 'CT');
    end
end
set(gcbf, 'userdata', model);


% --------------------------------------------------------------------
function mnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to mnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle = gcbf;
h = SAXSfilelist;
hlbl = findobj(h, 'tag', 'pushbutton1');
set(hlbl, 'string', 'Load cut');
set(hlbl, 'callback', {@cutload_Callback, h, handle, handles});

function cutload_Callback(hObject, eventdata, varargin)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(varargin)
    handles = getappdata(varargin{1}, 'handle');
    h = varargin{2};
    handlesgifit = varargin{3};
else
    return
end

constr = get(handles.lbfile, 'string');
t = get(handles.lbfile, 'value');
%cut = {1, numel(t)};
cut = getappdata(h, 'cut');
for i=1:numel(t)
    m = numel(cut);
    cut{m+1} = gf_load(constr{t(i)});
end
setappdata(h, 'cut', cut);
pbdata_Callback([], [], [], handlesgifit);



% --- Executes on selection change in pmData.
function pmData_Callback(hObject, eventdata, handles)
% hObject    handle to pmData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmData


% --- Executes during object creation, after setting all properties.
function pmData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbremovedata.
function pbremovedata_Callback(hObject, eventdata, handles)
% hObject    handle to pbremovedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = get(handles.pmData, 'string');
sellayer = get(handles.pmData, 'value');
if isempty(sellayer)
    return;
end
num = str2num(t{sellayer});
cut = getappdata(gcbf, 'cut');
cut(num) = [];
setappdata(gcbf, 'cut', cut);
dn = 1:numel(cut);
t = numlist2cellstr(dn(:));
set(handles.pmData, 'string', t);
if sellayer>numel(cut)
    set(handles.pmData, 'value', sellayer-1);
end

% refresh list of pmData (popupmenu)
gf_data(handles.pmData)

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%t = get(handles.pmData, 'string');
%sellayer = get(handles.pmdata, 'value');
mnLoad_Callback([],[],handles);

%cut = get(gcbf, 'cut');


% --- Executes during object creation, after setting all properties.
function eddatatag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eddatatag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edNpntsfit_Callback(hObject, eventdata, handles)
% hObject    handle to edNpntsfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edNpntsfit as text
%        str2double(get(hObject,'String')) returns contents of edNpntsfit as a double


% --- Executes during object creation, after setting all properties.
function edNpntsfit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edNpntsfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rdFitorNot.
function rdFitorNot_Callback(hObject, eventdata, handles)
% hObject    handle to rdFitorNot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdFitorNot


% --- Executes on button press in rdPlotorNot.
function rdPlotorNot_Callback(hObject, eventdata, handles)
% hObject    handle to rdPlotorNot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdPlotorNot


% --- Executes on selection change in pmxcol.
function pmxcol_Callback(hObject, eventdata, handles)
% hObject    handle to pmxcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmxcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmxcol


% --- Executes during object creation, after setting all properties.
function pmxcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmxcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmycol.
function pmycol_Callback(hObject, eventdata, handles)
% hObject    handle to pmycol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pmycol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmycol


% --- Executes during object creation, after setting all properties.
function pmycol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmycol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbdata.
function pbdata_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to pbdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(varargin)
    h = handles;
else
    h = varargin{1};
end

switchPanel('data', h);
gifitobj = findobj(0, 'tag', 'gifit');
data = getappdata(gifitobj, 'cut');
dn = 1:numel(data);
t = numlist2cellstr(dn(:));
set(h.pmData, 'string', t);


% --- Executes on button press in pbfit.
function pbfit_Callback(hObject, eventdata, handles)
% hObject    handle to pbfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switchPanel('fit', handles)

% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes on button press in pbfitstart.
function pbfitstart_Callback(hObject, eventdata, handles)
% hObject    handle to pbfitstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ===================================
% transfer data from gf_uplot to gifit....
% ===================================
gf_setselectedcut

md = get(gcbf, 'userdata');
cut = getappdata(gcbf, 'cut');

% ==================================
% Coordinate conversion
% ==================================
for i=1:numel(cut)
    if isfield(cut{i}, 'SAXSmode')
        if strcmp(cut{i}.SAXSmode, 'GISAXS')
            cut{i} = gf_Qcal(cut{i}, md);
        else
            if isempty(cut{i}.column)
                cut{i}.ai = cut{i}.data(:,1);
                cut{i}.af = cut{i}.data(:,2);
                cut{i}.tthf = cut{i}.data(:,3);
                cut{i}.intensity = cut{i}.data(:,4);
                cut{i}.err = cut{i}.data(:,5);
                cut{i} = gf_Qcal(cut{i}, md);
            end
        end
    end
end


% Fitting preparation
fitd = {};
linehandle = [];
for i=1:numel(cut)
    if cut{i}.optfit
        if isfield(cut{i}, 'selectpnts')
            linehandle = [linehandle, cut{i}.datahandle];
        end
    end
end

if isempty(linehandle)
    sprintf('Error, No data to be fitted, see gifit.m pbfitstart\n')
    return
end

for i=1:numel(linehandle)
    tag = get(linehandle(i), 'DisplayName');

    % pick up a cut, which is plotted on a gf_uplot
    num = gf_findcut(tag, cut);
    if num == 0
        disp('Error on pbfitstart button')
        return
    end

    % ==============================
    % Reducing the number of data point to fit
    % ==============================
    fitd{i} = gf_reducepnts(cut{num});
    
    xcol = cut{num}.optxcol;
    ycol = cut{num}.optycol;

    % ====================================
    % check whether 'fit' curve is plotted
    % ====================================
    ploth = findobj(0, 'tag', 'gf_uplot');
%    fitd{i};

    hfit = findobj(ploth, 'tag', 'fit', 'DisplayName', fitd{i}.fn);
    figure(ploth);
    delete(hfit);
    fitd{i}.fithandle = gf_plotcut(fitd{i},'g-');
    set(fitd{i}.fithandle, 'tag', 'fit');
    set(fitd{i}.fithandle, 'DisplayName', fitd{i}.fn);
    set(fitd{i}.fithandle, 'LineWidth', 2);
%    hfit = findobj(ploth, 'tag', 'fit', 'DisplayName', fitd{i}.fn);
%    if isempty(hfit)
%        figure(ploth);
%        fitd{i}.fithandle = gf_plotcut(fitd{i},'g-');
%        set(fitd{i}.fithandle, 'tag', 'fit');
%        set(fitd{i}.fithandle, 'DisplayName', fitd{i}.fn);
%        set(fitd{i}.fithandle, 'LineWidth', 2);
%    else
%        fitd{i}.fithandle = hfit;
%        set(hfit, 'xdata', fitd{i}.data(:,xcol), 'ydata', fitd{i}.data(:,ycol));
%        set(hfit, 'color', [0,1,0]);
%    end
end


setappdata(gcbf, 'cut', cut);
setappdata(gcbf, 'oldmodel', md);
%md.particle{1}.Sq.param
md.options = optimset('MaxIter', 250);
md = gf_fit(md, fitd);
set(gcbf, 'userdata', md);
setappdata(gcbf, 'cut', cut);

%evaluate the function
%[err, cut] = gf_calc(md, [], cut);
%setappdata(gcbf, 'cut', cut);


% --- Executes on button press in pbresetfit.
function pbresetfit_Callback(hObject, eventdata, handles)
% hObject    handle to pbresetfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model = getappdata(gcbf, 'oldmodel');
setappdata(gcbf, 'model', model);


% --- Executes on button press in pbsavefit.
function pbsavefit_Callback(hObject, eventdata, handles)
% hObject    handle to pbsavefit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mnsave_Callback

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnsave_Callback(hObject, eventdata, handles)
% hObject    handle to mnsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filen = getappdata(gcbf, 'savefn');
if isempty(filen)
    mnsaveas_Callback
else
    model = get(gcbf, 'userdata');
    cut = getappdata(gcbf, 'cut');
    gf_save(filen, model, cut);
end    

% --------------------------------------------------------------------
function mnsaveas_Callback(hObject, eventdata, handles)
% hObject    handle to mnsaveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.ini', 'put filename to save');
filen = strcat(pathname, filename);
setappdata(gcbf, 'savefn', filen);
model = get(gcbf, 'userdata');
cut = getappdata(gcbf, 'cut');
gf_save(filen, model, cut);


% --- Executes on selection change in pmLayerofparticle.
function pmLayerofparticle_Callback(hObject, eventdata, handles)
% hObject    handle to pmLayerofparticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns pmLayerofparticle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmLayerofparticle
    model = get(gcbf, 'userdata');
    disp('AAAAAAAAAAAAAAAA')
    selparticle = get(handles.pmParticle, 'value');
    contents = get(hObject,'String');
    model.particle{selparticle}.layer = contents{get(hObject,'Value')};
    set(gcbf, 'userdata', model);

% --- Executes during object creation, after setting all properties.
function pmLayerofparticle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pmLayerofparticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edSAXSmode_Callback(hObject, eventdata, handles)
% hObject    handle to edSAXSmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSAXSmode as text
%        str2double(get(hObject,'String')) returns contents of edSAXSmode as a double


% --- Executes during object creation, after setting all properties.
function edSAXSmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSAXSmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when gifit is resized.
function gifit_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to gifit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_simulimage.
function pb_simulimage_Callback(hObject, eventdata, handles)
% hObject    handle to pb_simulimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ===================================
% transfer data from gf_uplot to gifit....
% ===================================
global sim ai af tthf calint
[af_sim, tthf_sim] = meshgrid(af, tthf);
af_sim = af_sim(:);
tthf_sim = tthf_sim(:);
ai_sim = ai*ones(size(af_sim));
%gf_setselectedcut

md = get(gcbf, 'userdata');
cut = getappdata(gcbf, 'cut');
sim = cut;sim(2:end)=[];
sim{1}.ai = ai_sim;
sim{1}.af = af_sim;
sim{1}.tthf = tthf_sim;
sim{1}.intensity = zeros(size(sim{1}.tthf));
sim{1}.err = ones(size(sim{1}.tthf));
inten = zeros(size(sim{1}.tthf));
calint = inten;
sim{1}  = gf_Qcal(sim{1}, md, 1);
% ==================================
% Coordinate conversion
% ==================================
[err, sim, inten] = gf_calc(md, 1, sim);
calint = reshape(sim{1}.fit, length(tthf), length(af));
figure;
imagesc(log(calint'));axis xy
[E,ang,zz] = gf_modelefield(md, sim, 0.1, af);
figure;
imagesc(zz,ang,E');axis xy;colorbar
%sim = getappdata(gcbf, 'sim');
