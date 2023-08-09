function varargout = draw2dgrid(varargin)
% DRAW2DGRID MATLAB code for draw2dgrid.fig
%      DRAW2DGRID, by itself, creates a new DRAW2DGRID or raises the existing
%      singleton*.
%
%      H = DRAW2DGRID returns the handle to a new DRAW2DGRID or the handle to
%      the existing singleton*.
%
%      DRAW2DGRID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAW2DGRID.M with the given input arguments.
%
%      DRAW2DGRID('Property','Value',...) creates a new DRAW2DGRID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before draw2dgrid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to draw2dgrid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help draw2dgrid

% Last Modified by GUIDE v2.5 11-Nov-2020 10:08:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @draw2dgrid_OpeningFcn, ...
                   'gui_OutputFcn',  @draw2dgrid_OutputFcn, ...
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


% --- Executes just before draw2dgrid is made visible.
function draw2dgrid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to draw2dgrid (see VARARGIN)

% Choose default command line output for draw2dgrid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes draw2dgrid wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = draw2dgrid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edpos1_Callback(hObject, eventdata, handles)
% hObject    handle to edpos1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edpos1 as text
%        str2double(get(hObject,'String')) returns contents of edpos1 as a double


% --- Executes during object creation, after setting all properties.
function edpos1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edpos1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edang_Callback(hObject, eventdata, handles)
% hObject    handle to edang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edang as text
%        str2double(get(hObject,'String')) returns contents of edang as a double


% --- Executes during object creation, after setting all properties.
function edang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edlenRatio_Callback(hObject, eventdata, handles)
% hObject    handle to edlenRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edlenRatio as text
%        str2double(get(hObject,'String')) returns contents of edlenRatio as a double


% --- Executes during object creation, after setting all properties.
function edlenRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edlenRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbdaw.
function pbdaw_Callback(hObject, eventdata, handles)
% hObject    handle to pbdaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax = evalin('base', 'SAXSimagehandle');
pos1 = eval(handles.edpos1.String);
ang = eval(handles.edang.String);
lenratio = eval(handles.edlenRatio.String);
saxs = getgihandle;
pos1 = pos1 - saxs.center;
len1 = sqrt(sum(pos1.^2));
len2 = lenratio * len1;
ang = deg2rad(ang);
M = [cos(ang), -sin(ang); sin(ang), cos(ang)];
pos2 = lenratio*pos1*M;
np = [];
for i=-5:5
    for j=-5:5
        np = [np; i*pos1 + j*pos2];
    end
end
np = np + saxs.center;
%h = line(ax, 'xdata', np(:,1), 'ydata', np(:,2));
set(ax, 'nextplot', 'add')
h = plot(ax, np(:,1), np(:,2), 'ro');
set(h, 'color', 'r')
set(h, 'marker', 'o')
%set(h, 'linewidth', 0);
set(h, 'tag', '2Dgridpattern')

% --- Executes on button press in pbclear.
function pbclear_Callback(hObject, eventdata, handles)
% hObject    handle to pbclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax = evalin('base', 'SAXSimagehandle');
delete(findobj(ax, 'tag', '2Dgridpattern'));
