function varargout = gf_uplot(varargin)
% GF_UPLOT M-file for gf_uplot.fig
%      GF_UPLOT, by itself, creates a new GF_UPLOT or raises the existing
%      singleton*.
%
%      H = GF_UPLOT returns the handle to a new GF_UPLOT or the handle to
%      the existing singleton*.
%
%      GF_UPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GF_UPLOT.M with the given input arguments.
%
%      GF_UPLOT('Property','Value',...) creates a new GF_UPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gf_uplot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gf_uplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gf_uplot

% Last Modified by GUIDE v2.5 28-Dec-2009 23:04:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gf_uplot_OpeningFcn, ...
                   'gui_OutputFcn',  @gf_uplot_OutputFcn, ...
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


% --- Executes just before gf_uplot is made visible.
function gf_uplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gf_uplot (see VARARGIN)

% Choose default command line output for gf_uplot
handles.output = hObject;
warning off MATLAB:Axes:NegativeDataInLogAxis;
% Update handles structure

try
    icon_arrow = imread('accept-icon.png');
catch
    mn = fullfile(matlabroot,'toolbox','mytool','GiSAXS', 'GUI2', 'gifit', 'accept-icon.png');
    icon_arrow = imread(mn);
end
t = find(icon_arrow == 0);icon_arrow=double(icon_arrow)/255;
icon_arrow(t)= NaN;
set(handles.utselectline, 'cdata', icon_arrow);

try
    icon_arrow = imread('Rubber-icon.png');
catch
    mn = fullfile(matlabroot,'toolbox','mytool','GiSAXS', 'GUI2', 'gifit', 'Rubber-icon.png');
    icon_arrow = imread(mn);
end
%icon_arrow = icon_arrow/36*255;
icon_arrow = ind2rgb(icon_arrow, jet(128));
t = find(icon_arrow == 0);%icon_arrow=double(icon_arrow)/255;
icon_arrow(t)= NaN;
set(handles.upremoveselected, 'cdata', icon_arrow);

try
    icon_arrow = imread('arrow.png');
catch
    mn = fullfile(matlabroot,'toolbox','mytool','1DSAXS', 'GUI', 'arrow.png');
    icon_arrow = imread(mn);
   
end
t = find(icon_arrow == 0);icon_arrow=double(icon_arrow)/255;
icon_arrow(t)= NaN;

hToolbarFitsaxslee = uipushtool(handles.uitoolbar2,...
    'CData',icon_arrow,...%icons.iconrocking,...
    'TooltipString','fit data in the selected region',...
    'ClickedCallback',@fitdt);

guidata(hObject, handles);

% UIWAIT makes gf_uplot wait for user response (see UIRESUME)
% uiwait(handles.gf_uplot);


% --- Outputs from this function are returned to the command line.
function varargout = gf_uplot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --------------------------------------------------------------------
function utselectline_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to utselectline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function utselectline_OnCallback(hObject, eventdata, handles)
% hObject    handle to utselectline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off
%set(gcbf, 'KeyPressFcn', @selectline);
set(gcbf, 'Windowbuttondownfcn', @selectline);

function selectline(src, evnt, varargin)
%    ch = getappdata(src, 'currentline');
    Lw = 3;
    dLw = 0.5;

    if ~isempty(varargin)
        Lw = varargin{1};
        dLw = varargin{2};
%        evnt.Character == 'a';
    end
    if ~strcmp(get(gco, 'type'), 'line')
        return
    else
         
    end
    if strcmp(get(gcbf, 'selectiontype'), 'normal')
        unselectline
        set(gco, 'Selected', 'on', 'linewidth', 3);
        title(get(gco, 'tag'));
    else
        unselectline
        %set(gco, 'Selected', 'off', 'linewidth', 1);
        %title('');
    end
    
function unselectline
    t = findobj(gcbf, 'type', 'line', 'selected', 'on');
    set(t, 'selected', 'off', 'linewidth', 1);
    title(gca, '');


% --------------------------------------------------------------------
function utselectline_OffCallback(hObject, eventdata, handles)
% hObject    handle to utselectline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off
unselectline
%t = findobj(gca, 'type', 'line') ;
%findSelected(t);
%set(gcbf, 'KeyPressFcn', '');
set(gcbf, 'windowbuttondownFcn', '');

% --------------------------------------------------------------------
function upswapX_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to upswapX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = findobj(gca, 'selected', 'on');
xd = get(t, 'xdata');
xd = -xd;
set(t, 'xdata', xd);

% --------------------------------------------------------------------
function utselectpnt_OffCallback(hObject, eventdata, handles)
% hObject    handle to utselectpnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectdata('removeflag');
selectdata('clearButtonFcn');

datah = findobj(gca, 'tag', 'flag');
if isempty(datah)
    disp('No data is found on gf_uplot')
    return
end

flagh = findobj(gca, 'tag', 'flag');
xdata = [];ydata = [];
for i=1:numel(flagh)
    xd = get(flagh(i), 'xdata');xd = xd(:);
    yd = get(flagh(i), 'ydata');yd = yd(:);
    xdata = [xdata; xd];
    ydata = [ydata; yd];
end
[xd, id] = unique(xdata);
yd = ydata(id);
    %if ~isempty(ind)
    %    setappdata(flagh, 'flagindex', ind);
    %end

function indA = data2pnts(data, flag)
    [comm, indA] = intersect(data, flag);

%selectionflag = false;
%set(gcbf, 'selectiontype', 'alt');

% --------------------------------------------------------------------
function utselectpnt_OnCallback(hObject, eventdata, handles)
% hObject    handle to utselectpnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(gca, 'type', 'line');
t = findobj(h, 'Selected', 'off');
selectdata('selectionmode', 'rect', 'verify', 'on', 'identify', 'on', 'removeflagged', 'off', 'Ignore', t);


% --------------------------------------------------------------------
function utshowselectall_OnCallback(hObject, eventdata, handles)
% hObject    handle to utshowselectall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(gca, 'type', 'line');
num = numel(h);
hold on
for i=1:num
%    t = getappdata(h(i), 'selectpnts');
%    if ~isempty(t)
%        flag = plot(t.xdata, t.ydata, 'ro');
%        set(flag, 'tag', 'flag');
%    end
    if strcmp(get(h(i), 'tag'), 'data')
        set(h(i), 'linestyle', '-.');
        set(h(i), 'marker', 'none');
    end
    if strcmp(get(h(i), 'tag'), 'flag')
        set(h(i), 'Visible', 'on');
%        set(h(i), 'marker', 'none');
    end
end
    


% --------------------------------------------------------------------
function utshowselectall_OffCallback(hObject, eventdata, handles)
% hObject    handle to utshowselectall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = findobj(gca, 'tag', 'flag');
set(h, 'Visible', 'off');
%delete(h);


% --------------------------------------------------------------------
function uilogY_OnCallback(hObject, eventdata, handles)
% hObject    handle to uilogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca, 'Yscale', 'log')


% --------------------------------------------------------------------
function uilogY_OffCallback(hObject, eventdata, handles)
% hObject    handle to uilogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca, 'Yscale', 'linear')


% --------------------------------------------------------------------
function uitoggletool5_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca, 'Xscale', 'log')


% --------------------------------------------------------------------
function uitoggletool5_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gca, 'Xscale', 'linear')


% --------------------------------------------------------------------
function utswapX_OnCallback(hObject, eventdata, handles)
% hObject    handle to utswapX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function gf_uplot_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to gf_uplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close gf_uplot.
function gf_uplot_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to gf_uplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%gf_setselectedcut;
warning on MATLAB:Axes:NegativeDataInLogAxis;

delete(hObject);


% --------------------------------------------------------------------
function utdeselectpnt_OnCallback(hObject, eventdata, handles)
% hObject    handle to utdeselectpnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on


% --------------------------------------------------------------------
function utdeselectpnt_OffCallback(hObject, eventdata, handles)
% hObject    handle to utdeselectpnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off


% --------------------------------------------------------------------
function utdeselectpnt_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to utdeselectpnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function upremoveselected_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to upremoveselected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findobj(gca, 'tag', 'flag'));


% --------------------------------------------------------------------
function uppolyfit_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uppolyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flagh = findobj(gca, 'tag', 'flag');
xdata = [];ydata = [];
for i=1:numel(flagh)
    xd = get(flagh(i), 'xdata');xd = xd(:);
    yd = get(flagh(i), 'ydata');yd = yd(:);
    xdata = [xdata; xd];
    ydata = [ydata; yd];
end
[xd, id] = unique(xdata);
yd = ydata(id);
%p = polyfit(xd, yd, 25);
x = get(findobj(gca, 'tag', '', 'type', 'line', 'selected', 'on'), 'xdata');x = x(:);
y = interp1(xd, yd, x);
%y = polyval(p, x);
tt = line('xdata', x, 'ydata', y, 'color', 'r', 'tag', 'back');


% --------------------------------------------------------------------
function updrawbackground_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to updrawbackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawContinousBack('start')


% --------------------------------------------------------------------
function upsubtractbackground_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to upsubtractbackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Hfig = gcf;
selecteddata = findobj(gcbf, 'type', 'line', 'selected', 'on');
if numel(selecteddata) < 1
    disp('Please select a line of data')
    return
end

yd = get(selecteddata, 'ydata');
yd = yd(:);

selectedback = findobj(gcbf, 'type', 'line', 'tag', 'back');
if numel(selectedback) < 1
    disp('There is no line that has back as a tag')
    return
end

bkg = get(selectedback, 'ydata');
bkg = bkg(:);

ydata = yd-bkg;
np = isnan(ydata);
ydata(np) = 0;
set(selecteddata, 'ydata', ydata);
% ======================== remove the selection of bkg
Hbkg = get(gcbf, 'userdata');
try
    lnHline = length(Hbkg.Hline);
    if length(Hbkg.Hline) > 1
        for i=1:lnHline
            delete(Hbkg.Hline(i));
        end
    end
    Hbkg.Hline = [];
    Hbkg.oldposi = [];
    set(Hfig, 'userdata', Hbkg);
catch
    t = findobj(gcbf, 'tag', 'lnbkg');
    delete(t)
end
% ========================================================


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mndataopen_Callback(hObject, eventdata, handles)
% hObject    handle to mndataopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnloaddata_Callback(hObject, eventdata, handles)
% hObject    handle to mnloaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath] = uigetfile( ...
    {'*.dat','dat Files (*.dat)';'*.txt','txt Files (*.txt)';...
    '*00*.*','SAXS data (*00*.*)';'*.*','All Files (*.*)'}, ...
    'Load data File');
% If "Cancel" is selected then return
if isequal([filename,filepath],[0,0])
%    restorePath(prePath);
    return
end
% Otherwise construct the fullfilename and Check and load the file.
datafile = fullfile(filepath,filename);
[fid,message] = fopen(datafile,'r');        % open file
if fid == -1                % return if open fails
    uiwait(msgbox(message,'File Open Error','error','modal'));
    % fclose(fid);
    %restorePath(prePath);
    return;
end

a = load(datafile);
line('xdata', a(:,1), 'ydata', a(:,2), 'color', 'b', 'displayname', filename);

% --------------------------------------------------------------------
function mnloadback_Callback(hObject, eventdata, handles)
% hObject    handle to mnloadback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath] = uigetfile( ...
    {'*.dat','dat Files (*.dat)';'*.txt','txt Files (*.txt)';...
    '*00*.*','SAXS data (*00*.*)';'*.*','All Files (*.*)'}, ...
    'Load data File');
% If "Cancel" is selected then return
if isequal([filename,filepath],[0,0])
%    restorePath(prePath);
    return
end
% Otherwise construct the fullfilename and Check and load the file.
datafile = fullfile(filepath,filename);
[fid,message] = fopen(datafile,'r');        % open file
if fid == -1                % return if open fails
    uiwait(msgbox(message,'File Open Error','error','modal'));
    % fclose(fid);
    %restorePath(prePath);
    return;
end

a = load(datafile);
line('xdata', a(:,1), 'ydata', a(:,2), 'color', 'r', 'tag', 'back', 'displayname', filename);


% --------------------------------------------------------------------
function mnsave_Callback(hObject, eventdata, handles)
% hObject    handle to mnsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnsavedata_Callback(hObject, eventdata, handles)
% hObject    handle to mnsavedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = findobj(gcbf, 'type', 'line', 'tag', '');
if numel(t) > 1
    for i=1:numel(t)
        fn = get(t, 'displayname');
        if ~isempty(fn)
            if ischar(fn)
                break
            end
        end
    end
else
    fn = get(t, 'displayname');i=1;
end
xd = get(t(i), 'xdata');xd = xd(:);
yd = get(t(i), 'ydata');yd = yd(:);
dt = [xd, yd];

[filename, filepath] = uiputfile( ...
    {'*.dat','dat Files (*.dat)';'*.txt','txt Files (*.txt)';...
    '*00*.*','SAXS data (*00*.*)';'*.*','All Files (*.*)'}, ...
    'Save data File', fn);
% If "Cancel" is selected then return
if isequal([filename,filepath],[0,0])
%    restorePath(prePath);
    return
end
% Otherwise construct the fullfilename and Check and load the file.
datafile = fullfile(filepath,filename);
fid = fopen(datafile,'wt');        % open file
fprintf(fid, '%2.8f %10.8f\n', dt');
fclose(fid);
% --------------------------------------------------------------------
function mnsaveback_Callback(hObject, eventdata, handles)
% hObject    handle to mnsaveback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = findobj(gcbf, 'type', 'line', 'tag', 'back');
if numel(t) > 1
    for i=1:numel(t)
        fn = get(t, 'displayname');
        if ~isempty(fn)
            if ischar(fn)
                break
            end
        end
    end
else
    fn = get(t, 'displayname');i=1;
end

xd = get(t(i), 'xdata');xd = xd(:);
yd = get(t(i), 'ydata');yd = yd(:);
dt = [xd, yd];

[filename, filepath] = uiputfile( ...
    {'*.dat','dat Files (*.dat)';'*.txt','txt Files (*.txt)';...
    '*00*.*','SAXS data (*00*.*)';'*.*','All Files (*.*)'}, ...
    'Save data File', fn);
% If "Cancel" is selected then return
if isequal([filename,filepath],[0,0])
%    restorePath(prePath);
    return
end
% Otherwise construct the fullfilename and Check and load the file.
datafile = fullfile(filepath,filename);
fid = fopen(datafile,'wt');        % open file
fprintf(fid, '%2.8f %10.8f\n', dt');
fclose(fid);

function fitdt(varargin)
    % when it is call from gf_uplot.m
    flagh = findobj(gca, 'tag', 'flag');
    xdata = [];ydata = [];
    for i=1:numel(flagh)
        xd = get(flagh(i), 'xdata');xd = xd(:);
        yd = get(flagh(i), 'ydata');yd = yd(:);
        xdata = [xdata; xd];
        ydata = [ydata; yd];
    end
    [xd, id] = unique(xdata);
    yd = ydata(id);
    fitsaxslee(xd, yd)
