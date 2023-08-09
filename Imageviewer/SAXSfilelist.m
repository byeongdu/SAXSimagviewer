function varargout = SAXSfilelist(varargin)
% SAXSFILELIST M-file for SAXSfilelist.fig
%      SAXSFILELIST, by itself, creates a new SAXSFILELIST or raises the existing
%      singleton*.
%
%      H = SAXSFILELIST returns the handle to a new SAXSFILELIST or the handle to
%      the existing singleton*.
%
%      SAXSFILELIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAXSFILELIST.M with the given input arguments.
%
%      SAXSFILELIST('Property','Value',...) creates a new SAXSFILELIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAXSfilelist_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAXSfilelist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help SAXSfilelist

% Last Modified by GUIDE v2.5 06-Jul-2007 15:31:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAXSfilelist_OpeningFcn, ...
                   'gui_OutputFcn',  @SAXSfilelist_OutputFcn, ...
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


% --- Executes just before SAXSfilelist is made visible.
function SAXSfilelist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAXSfilelist (see VARARGIN)
% Choose default command line output for SAXSfilelist
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.ed_wild, 'string', '*');
ed_wild_Callback(hObject, eventdata, handles);



% UIWAIT makes SAXSfilelist wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAXSfilelist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lbfile.
function lbfile_Callback(hObject, eventdata, handles)
% hObject    handle to lbfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lbfile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbfile
%if strcmp(get(handles.SAXSfileList,'SelectionType'),'open') % If double click
%    index_selected = get(handles.lbfile,'Value');
%    file_list = get(handles.lbfile,'String');
%    filename = file_list{index_selected}; % Item selected in list box
%    wildcard = char(cellstr(get(handles.ed_wild, 'string')));
%    if handles.is_dir(handles.sorted_index(index_selected))
%        cd (filename);
%        load_listbox(pwd, wildcard, handles);
%        set(handles.ed_dir,'String',pwd);
%    else
%        [path,name,ext,ver] = fileparts(filename);
%        hSAXSlee=findobj('Tag','GISAXSLee');
%        if isempty(hSAXSlee)==1
%            disp('An empty structure in Userdata')
%        else
%            saxs=get(hSAXSlee, 'Userdata');
%            saxs=openccdfile({path, [name,ext]},saxs);
%            set(hSAXSlee, 'Userdata', saxs);
%        end
%    end
%end


% --- Executes during object creation, after setting all properties.
function lbfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_wild_Callback(hObject, eventdata, handles)
% hObject    handle to ed_wild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_wild as text
%        str2double(get(hObject,'String')) returns contents of ed_wild as a double
dirname = char(cellstr(get(handles.ed_dir, 'string')));
wildcard = char(cellstr(get(handles.ed_wild, 'string')));
if isempty(dirname)
    dir_path = pwd;
else
    dir_path = dirname;
end
load_listbox(dir_path, wildcard, handles)

% --- Executes during object creation, after setting all properties.
function ed_wild_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_wild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
constr = get(handles.lbfile, 'string');
t = get(handles.lbfile, 'value');
constr{t}

function ed_dir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dir as text
%        str2double(get(hObject,'String')) returns contents of ed_dir as a double


% --- Executes during object creation, after setting all properties.
function ed_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function load_listbox(dir_path, wildcard, handles)
cd (dir_path);
dir_struct = dir(wildcard);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = [sorted_index];
guidata(handles.SAXSfileList,handles);
set(handles.lbfile,'String',handles.file_names,'Value',1);
set(handles.ed_dir,'String',pwd);
setappdata(handles.SAXSfileList, 'handle', handles);
hSAXSlee = findobj('Tag', 'GISAXSLee');
saxs = get(hSAXSlee, 'Userdata');
saxs = setfield(saxs, 'macrolist', sorted_names);
saxs = setfield(saxs, 'wildcard', wildcard);
saxs = setfield(saxs, 'dir', pwd);
set(hSAXSlee, 'Userdata', saxs);