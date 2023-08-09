function varargout = GISAXSLee_autoimageloader(varargin)
% GISAXSLEE_AUTOIMAGELOADER MATLAB code for GISAXSLee_autoimageloader.fig
%      GISAXSLEE_AUTOIMAGELOADER, by itself, creates a new GISAXSLEE_AUTOIMAGELOADER or raises the existing
%      singleton*.
%
%      H = GISAXSLEE_AUTOIMAGELOADER returns the handle to a new GISAXSLEE_AUTOIMAGELOADER or the handle to
%      the existing singleton*.
%
%      GISAXSLEE_AUTOIMAGELOADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GISAXSLEE_AUTOIMAGELOADER.M with the given input arguments.
%
%      GISAXSLEE_AUTOIMAGELOADER('Property','Value',...) creates a new GISAXSLEE_AUTOIMAGELOADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GISAXSLee_autoimageloader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GISAXSLee_autoimageloader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GISAXSLee_autoimageloader

% Last Modified by GUIDE v2.5 05-May-2014 21:33:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GISAXSLee_autoimageloader_OpeningFcn, ...
                   'gui_OutputFcn',  @GISAXSLee_autoimageloader_OutputFcn, ...
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


% --- Executes just before GISAXSLee_autoimageloader is made visible.
function GISAXSLee_autoimageloader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GISAXSLee_autoimageloader (see VARARGIN)

% Choose default command line output for GISAXSLee_autoimageloader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GISAXSLee_autoimageloader wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GISAXSLee_autoimageloader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_TimerRun.
function pb_TimerRun_Callback(hObject, eventdata, handles)
% hObject    handle to pb_TimerRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global loadertimer
global specfile
if strcmp(get(hObject, 'string'), 'Execute')
    set(hOjbect, 'string', 'stop')
    loadertimer = timer;
    specfile.name = get(handles.ed_Source, 'string');
    specfile.path = fileparts(specfile.name);
    t = dir(specfile.name);
    specfile.oldsize = t.bytes;
    specfile.newimage = [];
    set(loadertimer, 'executionmode', 'fixedrate')
    set(loadertimer, 'period', str2double(get(handles.ed_timeinterval, 'string')));
    set(loadertimer, 'TimerFcn', 'timerfun_spec')
    start(loadertimer)
else
    stop(loadertimer)
    delete(loadertimer)
    set(hOjbect, 'string', 'Execute')
end

function timerfun_spec(varargin)
global specfile
if ~isempty(specfile.newimage)
    specfile = run_spec(specfile);
    return
end
spec = dir(specfile.name);
if spec.bytes > specfile.oldsize
    specfile = run_spec(specfile);
end

function specfile = run_spec(specfile)
    try
        % Extract image filename
        %str = fileread(specfile.name);
        %str = str((specfile.oldsize+1):end);
        specfile = check_specfile(specfile);
        % imgname = image to load
        %specfile.newimage = imgname;
        if ~isempty(specfile.newimage)
            SAXSimageviewer(specfile.newimage)
        end
        specfile.oldsize = spec.bytes;
        specfile.newimage = [];
    catch
        
    end

function specfile = check_specfile(specfile)
% --- check dynamically if there are more scans added to spec file
    fid = fopen(specfile.name);
    fseek(fid,specfile.fidPos,'bof');  % move fid to end of the last stored scan
%    scanline = fgetl(fid);      % skip the currentline (head of the last stored scan);

    while feof(fid) == 0
        tempfid = ftell(fid);
        scanline = fgetl(fid);
        fl = sscanf(scanline, '#Z %s', 1);
        if ~isempty(fl)
%            [~, RR] = strtok(scanline, '#Z ');
%            kk = findstr(RR, ' '); 
%            date = RR(kk(end-5):kk(end-1)); % read date
            specfile.fidPos = tempfid;
            specfile.newimage = fl;
            fclose(fid);
            break
        end
    end
    fclose(fid);


function timerfun_epics(varargin)


function ed_timeinterval_Callback(hObject, eventdata, handles)
% hObject    handle to ed_timeinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_timeinterval as text
%        str2double(get(hObject,'String')) returns contents of ed_timeinterval as a double


% --- Executes during object creation, after setting all properties.
function ed_timeinterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_timeinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_Source_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Source as text
%        str2double(get(hObject,'String')) returns contents of ed_Source as a double


% --- Executes during object creation, after setting all properties.
function ed_Source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
