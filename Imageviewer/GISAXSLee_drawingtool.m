function varargout = GISAXSLee_drawingtool(varargin)
% GISAXSLEE_DRAWINGTOOL MATLAB code for GISAXSLee_drawingtool.fig
%      GISAXSLEE_DRAWINGTOOL, by itself, creates a new GISAXSLEE_DRAWINGTOOL or raises the existing
%      singleton*.
%
%      H = GISAXSLEE_DRAWINGTOOL returns the handle to a new GISAXSLEE_DRAWINGTOOL or the handle to
%      the existing singleton*.
%
%      GISAXSLEE_DRAWINGTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GISAXSLEE_DRAWINGTOOL.M with the given input arguments.
%
%      GISAXSLEE_DRAWINGTOOL('Property','Value',...) creates a new GISAXSLEE_DRAWINGTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GISAXSLee_drawingtool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GISAXSLee_drawingtool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GISAXSLee_drawingtool

% Last Modified by GUIDE v2.5 13-Jun-2019 15:25:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GISAXSLee_drawingtool_OpeningFcn, ...
                   'gui_OutputFcn',  @GISAXSLee_drawingtool_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before GISAXSLee_drawingtool is made visible.
function GISAXSLee_drawingtool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GISAXSLee_drawingtool (see VARARGIN)

% Choose default command line output for GISAXSLee_drawingtool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GISAXSLee_drawingtool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GISAXSLee_drawingtool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rd_drawalpha0line.
function rd_drawalpha0line_Callback(hObject, eventdata, handles)
% hObject    handle to rd_drawalpha0line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_drawalpha0line
    saxs = getgihandle;
    wl = saxs.waveln;
    %ed = saxs.edensity;
    ai = saxs.ai;

    ang = [0, 0];
    drawangleline(hObject, ang)


% --- Executes on button press in rd_drawaf0line.
function rd_drawaf0line_Callback(hObject, eventdata, handles)
% hObject    handle to rd_drawaf0line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_drawaf0line
    saxs = getgihandle;
    wl = saxs.waveln;
    %ed = saxs.edensity;
    ai = saxs.ai;

    ang = [0, ai];
    drawangleline(hObject, ang)


% --- Executes on button press in rd_drawaf2ailine.
function rd_drawaf2ailine_Callback(hObject, eventdata, handles)
% hObject    handle to rd_drawaf2ailine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_drawaf2ailine
    saxs = getgihandle;
    %ed = saxs.edensity;
    ai = saxs.ai;

    ang = [0, 2*ai];
    drawangleline(hObject, ang)


% --- Executes on button press in rd_drawcriticalangle.
function rd_drawcriticalangle_Callback(hObject, eventdata, handles)
% hObject    handle to rd_drawcriticalangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_drawcriticalangle

%ang = [0, af];
    ed = str2double(get(handles.ed_edensity, 'string'));
    saxs = getgihandle;
    wl = saxs.waveln;
    %ed = saxs.edensity;
    ai = saxs.ai;

    ac = criticalang(ed, wl);
    fprintf('The critical angle for e-density %0.3f/%s^3 is %0.3f deg at wavelength %0.4f%s.\n', ed, char(197), ac, wl, char(197))
    ang = [0, ac+ai];
    drawangleline(hObject, ang)

function drawangleline(hObject, ang)
if get(hObject,'Value')
    saxs = getgihandle;
    wl = saxs.waveln;
    psize = saxs.psize;
    sdd = saxs.SDD;
    %ed = saxs.edensity;
    %ai = saxs.ai;
    ta = saxs.tiltangle;
    if numel(ta) == 1
        ta = [0,0,ta];
    end

%    ac = criticalang(ed, wl);
%    fprintf('The critical angle for e-density %0.3f/%s^3 is %0.3f deg at wavelength %0.4f%s.\n', ed, char(197), ac, wl, char(197))
%    ang = [0, ac+ai];
    P = pixel2angle(ang, saxs.center, wl, sdd, psize, ta, 1);
    if iscell(P)
        P = P{2}; % 2 for transmitted beam...
    end
    % ----------------------------------------------------------
    % draw linecut
    % ----------------------------------------------------------
    cut = linecut_q(saxs.image, P, 'tth', saxs, 0);
    % ----------------------------------------------------------
    % draw line on SAXSimageviewer...........
    % ----------------------------------------------------------
    hSAXSimageview = evalin('base', 'SAXSimagehandle');
%    h = line(cut.P(:,1), cut.P(:,2)+saxs.center(2), 'parent', hSAXSimageview);
    h = line(cut.X+saxs.center(1), cut.Y+saxs.center(2), 'parent', hSAXSimageview);
    set(h, 'color', 'w', 'linestyle', ':');
    set(hObject, 'userdata', h)
else
    h = get(hObject, 'userdata');
    set(hObject, 'userdata', [])
    delete(h);
end
    %set(hLL, 'color', 'm', 'linestyle', ':');
    %set(hHL, 'color', 'm', 'linestyle', ':');
    %assignin('base', 'cut', cut);

function clearlines(hobject)
SAXSimagehandle = evalin('base', 'SAXSimagehandle');
if nargin < 1
    delete(findobj(get(SAXSimagehandle, 'children'), 'type', 'line'));
else
    delete(get(hobject, 'userdata'));
    set(hobject, 'userdata', []);
end


function ed_edensity_Callback(hObject, eventdata, handles)
% hObject    handle to ed_edensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_edensity as text
%        str2double(get(hObject,'String')) returns contents of ed_edensity as a double


% --- Executes during object creation, after setting all properties.
function ed_edensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_edensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_drawtth0.
function rd_drawtth0_Callback(hObject, eventdata, handles)
% hObject    handle to rd_drawtth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_drawtth0
if get(hObject,'Value')
    saxs = getgihandle;
    %ed = saxs.edensity;
    psize = saxs.psize;
    sdd = saxs.SDD;
    %ed = saxs.edensity;
    %ai = saxs.ai;
    ta = saxs.tiltangle;
    if numel(ta) == 1
        ta = [0,0,ta];
    end
    ang = [0, 0];
    
    P = pixel2angle(ang, saxs.center, saxs.waveln, sdd, psize, ta, 1);
    if iscell(P)
        P = P{2}; % 2 for transmitted beam...
    end
    % ----------------------------------------------------------
    % draw linecut
    % ----------------------------------------------------------
    cut = linecut_q(saxs.image, P, 'af', saxs, 0);
    % ----------------------------------------------------------
    % draw line on SAXSimageviewer...........
    % ----------------------------------------------------------
    hSAXSimageview = evalin('base', 'SAXSimagehandle');
    h = line(cut.X+saxs.center(1), cut.Y+saxs.center(2), 'parent', hSAXSimageview);
    set(h, 'color', 'w', 'linestyle', ':');
    set(hObject, 'userdata', h)
else
    clearlines
end

% --- Executes on button press in rd_qtz.
function rd_qtz_Callback(hObject, eventdata, handles)
% hObject    handle to rd_qtz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_qtz
q_draw(hObject, eventdata, handles)

function q_draw(hObject, eventdata, handles)
if get(hObject,'Value')
    saxs = getgihandle;
    %ed = saxs.edensity;
    psize = saxs.psize;
    sdd = saxs.SDD;
    wl = saxs.waveln;
    ed = saxs.edensity;
    ai = saxs.ai;
    ta = saxs.tiltangle;
    cnt = saxs.center;
    if numel(ta) == 1
        ta = [0,0,ta];
    end
    ang = [0, 0];
    switch hObject.Tag
        case 'rd_qtz'
            q_modulus = str2double(get(handles.ed_qtz, 'string'));
%            P = P{2}; % 2 for transmitted beam...
            P = q2pixel(q_modulus, wl, cnt, psize, sdd, ed, [], ai, ta);
        case 'rb_qrz'
            q_modulus = str2double(get(handles.ed_qrz, 'string'));
            %P = P{1}; % 1 for reflected beam...
            P = q2pixel(q_modulus, wl, cnt, psize, sdd, ed, [], ai, ta);
    end
    
    if iscell(P)
        switch hObject.Tag
            case 'rd_qtz'
                P = P{2}; % 2 for transmitted beam...
            case 'rb_qrz'
                P = P{1}; % 1 for reflected beam...
        end
    end
    hSAXSimageview = evalin('base', 'SAXSimagehandle');
    h = line(P(:,1), P(:,2), 'parent', hSAXSimageview);
    set(h, 'color', 'w', 'linestyle', '-');
    set(hObject, 'userdata', h)
else
    clearlines(hObject)
end

function q_radial_draw(hObject, eventdata, handles)
if get(hObject,'Value')
    saxs = getgihandle;
    %ed = saxs.edensity;
    psize = saxs.psize;
    sdd = saxs.SDD;
    wl = saxs.waveln;
    ed = saxs.edensity;
    ai = saxs.ai;
    ta = saxs.tiltangle;
    cnt = saxs.center;
    if numel(ta) == 1
        ta = [0,0,ta];
    end
    hSAXSimageview = evalin('base', 'SAXSimagehandle');
    allh = [];
    switch hObject.Tag
        case 'rb_qradial'
            q = str2double(get(handles.ed_qradialq, 'string'));
            th0 = str2double(get(handles.ed_qradialth0, 'string'));
            dth = str2double(get(handles.ed_qradialdth, 'string'));
            %P = P{1}; % 1 for reflected beam...
            k = 0;
            while 1
                th = th0+k*dth;
                if th > 360
                    break
                end
                P = q2pixel([[0; q], [0;0], [th;th]], wl, cnt, psize, sdd);
                k = k + 1;
                h = line(P(:,1), P(:,2), 'parent', hSAXSimageview);
                set(h, 'color', 'w', 'linestyle', '-');            
                allh = [allh, h];
            end
    end
    
    set(hObject, 'userdata', allh)
else
    clearlines(hObject)
end


function ed_qtz_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qtz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qtz as text
%        str2double(get(hObject,'String')) returns contents of ed_qtz as a double


% --- Executes during object creation, after setting all properties.
function ed_qtz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qtz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_qrz.
function rb_qrz_Callback(hObject, eventdata, handles)
% hObject    handle to rb_qrz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_qrz
q_draw(hObject, eventdata, handles)



function ed_qrz_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qrz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qrz as text
%        str2double(get(hObject,'String')) returns contents of ed_qrz as a double


% --- Executes during object creation, after setting all properties.
function ed_qrz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qrz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_contour.
function rb_contour_Callback(hObject, eventdata, handles)
% hObject    handle to rb_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_contour
if get(hObject,'Value')
    qmap = evalin('base', 'qmap');
    saxs = getgihandle;
    contents = cellstr(get(handles.pm_qmap,'String'));
    fn = contents{get(handles.pm_qmap,'Value')};
    sqmap = qmap.(fn);
    hSAXSimageview = evalin('base', 'SAXSimagehandle');
    hSAXSimageviewhandle = evalin('base', 'SAXSimageviewerhandle');
    t = axes('position', get(hSAXSimageview, 'position'), 'parent', hSAXSimageviewhandle);
    %set(t, 'outerposition', get(hSAXSimageview, 'outerposition'));
    h = contour(reshape(real(sqmap), saxs.imgsize), 'parent', t);
    set(t, 'color', 'none')
    set(t, 'xtick', []);
    set(t, 'ytick', []);
    set(t, 'position',get(hSAXSimageview, 'position')); 
    set(t, 'PlotBoxAspectRatio', get(hSAXSimageview, 'PlotBoxAspectRatio'));
    set(t, 'xlim', get(hSAXSimageview, 'xlim'));
    set(t, 'ylim', get(hSAXSimageview, 'ylim'));

    %set(h, 'color', 'w', 'linestyle', '-');
    set(hObject, 'userdata', t)
else
    t = get(hObject, 'userdata');
    delete(t);
end

% --- Executes on button press in pb_qmap.
function pb_qmap_Callback(hObject, eventdata, handles)
% hObject    handle to pb_qmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
%ed = saxs.edensity;
psize = saxs.psize;
sdd = saxs.SDD;
wl = saxs.waveln;
ed = saxs.edensity;
ai = saxs.ai;
ta = saxs.tiltangle;
cnt = saxs.center;
if numel(ta) == 1
    ta = [0,0,ta];
end
%P = pixel2angle(ang, saxs.center, sdd, psize, ta, 1);
[X, Y] = meshgrid(1:saxs.imgsize(2), 1:saxs.imgsize(1));
qmap = pixel2qv([X(:), Y(:)], cnt, sdd, psize, ta, ai, 0, saxs);
fn = fieldnames(qmap);
set(handles.pm_qmap, 'string', fn);
set(handles.pm_qmap, 'enable', 'on');
assignin('base','qmap', qmap);
set(handles.rb_contour, 'enable', 'on');

% --- Executes on selection change in pm_qmap.
function pm_qmap_Callback(hObject, eventdata, handles)
% hObject    handle to pm_qmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_qmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_qmap


% --- Executes during object creation, after setting all properties.
function pm_qmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_qmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_qradial.
function rb_qradial_Callback(hObject, eventdata, handles)
% hObject    handle to rb_qradial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_qradial

q_radial_draw(hObject, eventdata, handles)

function ed_qradialq_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qradialq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qradialq as text
%        str2double(get(hObject,'String')) returns contents of ed_qradialq as a double


% --- Executes during object creation, after setting all properties.
function ed_qradialq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qradialq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_qradialth0_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qradialth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qradialth0 as text
%        str2double(get(hObject,'String')) returns contents of ed_qradialth0 as a double


% --- Executes during object creation, after setting all properties.
function ed_qradialth0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qradialth0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_qradialdth_Callback(hObject, eventdata, handles)
% hObject    handle to ed_qradialdth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_qradialdth as text
%        str2double(get(hObject,'String')) returns contents of ed_qradialdth as a double


% --- Executes during object creation, after setting all properties.
function ed_qradialdth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_qradialdth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
