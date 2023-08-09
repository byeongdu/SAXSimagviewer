function varargout = GISAXSLee_convertGI2nonGI(varargin)
% GISAXSLEE_CONVERTGI2NONGI MATLAB code for GISAXSLee_convertGI2nonGI.fig
%      GISAXSLEE_CONVERTGI2NONGI, by itself, creates a new GISAXSLEE_CONVERTGI2NONGI or raises the existing
%      singleton*.
%
%      H = GISAXSLEE_CONVERTGI2NONGI returns the handle to a new GISAXSLEE_CONVERTGI2NONGI or the handle to
%      the existing singleton*.
%
%      GISAXSLEE_CONVERTGI2NONGI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GISAXSLEE_CONVERTGI2NONGI.M with the given input arguments.
%
%      GISAXSLEE_CONVERTGI2NONGI('Property','Value',...) creates a new GISAXSLEE_CONVERTGI2NONGI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GISAXSLee_convertGI2nonGI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GISAXSLee_convertGI2nonGI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GISAXSLee_convertGI2nonGI

% Last Modified by GUIDE v2.5 30-Dec-2020 16:24:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GISAXSLee_convertGI2nonGI_OpeningFcn, ...
                   'gui_OutputFcn',  @GISAXSLee_convertGI2nonGI_OutputFcn, ...
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


% --- Executes just before GISAXSLee_convertGI2nonGI is made visible.
function GISAXSLee_convertGI2nonGI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GISAXSLee_convertGI2nonGI (see VARARGIN)

% Choose default command line output for GISAXSLee_convertGI2nonGI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GISAXSLee_convertGI2nonGI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GISAXSLee_convertGI2nonGI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   saxs = getgihandle;
   img = convertGI2cart(saxs.image, saxs);
   fn = fullfile(saxs.dir, ['C', saxs.imgname, '.tif']);
   if max(max(max(max(saxs.image)))) < 2^16
       bit = 16;
   else
       bit = 32;
   end
   imwritetiff(flipud(img), fn, bit)
   fprintf('Data %s is converted to \n', saxs.imgname);
   fprintf('%s and saved\n', fn);
   add_imagemenu;


% --- Executes on button press in pb_convertq1.
function pb_convertq1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_convertq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   saxs = getgihandle;
   img = convertGI2cart(saxs.image, saxs);
   img = convertCart2q(img, saxs);
   fn = fullfile(saxs.dir, ['C', saxs.imgname, '.tif']);
   if max(max(max(max(saxs.image)))) < 2^16
       bit = 16;
   else
       bit = 32;
   end
   imwritetiff(flipud(img), fn, bit)
   fprintf('Data %s is converted to \n', saxs.imgname);
   fprintf('%s and saved\n', fn);
   add_imagemenu;
   set(gcf, 'tag', 'tobeindexed');



% --- Executes on button press in pb_convertq2.
function pb_convertq2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_convertq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

   saxs = getgihandle;
   [img, qxy, qz] = convertGI2cart2(saxs.image, saxs);
   figure;
   minv = min(img(:));
   maxv = max(img(:));
   imagesc(qxy, qz, img, [minv*1.2, maxv*0.8]); axis image; axis xy;
   xlabel(sprintf('q_{xy} [1/%s]',char(197)), 'fontsize', 14);
   ylabel(sprintf('q_{z} [1/%s]',char(197)), 'fontsize', 14);
   set(gca, 'fontsize', 12);
   %img = convertGI2cart(saxs.image, saxs);
   %img = convertcart2q(img, saxs);
   fn = fullfile(saxs.dir, ['C', saxs.imgname, '.tif']);
   if max(max(max(max(saxs.image)))) < 2^16
       bit = 16;
   else
       bit = 32;
   end
   imwritetiff(flipud(img), fn, bit)
   disp('Change color scale, set(gca, "caxis", [0, 10])')
   fprintf('Data %s is converted to \n', saxs.imgname);
   fprintf('%s and saved\n', fn);
   add_imagemenu;
   set(gcf, 'tag', 'tobeindexed');
   indexingFiber;
   disp('Choose Fig to analyze from File>Choose')


% --- Executes on button press in pb_convertPolar2Cart.
function pb_convertPolar2Cart_Callback(hObject, eventdata, handles)
% hObject    handle to pb_convertPolar2Cart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   saxs = getgihandle;
   [img, q, ang] = convertPolar2Rect(saxs.image, saxs);
   q = q(:);
   ang = ang(:);
   figure;
   imagesc(q, ang, img, [0, max(max(img))*0.8]);
   xlabel(sprintf('q [1/%s]',char(197)), 'fontsize', 14);
   ylabel(sprintf('th [deg.]',char(197)), 'fontsize', 14);
   set(gca, 'fontsize', 12);
   %img = convertGI2cart(saxs.image, saxs);
   %img = convertcart2q(img, saxs);
   fn = fullfile(saxs.dir, ['C', saxs.imgname, '.tif']);
   if max(max(max(max(saxs.image)))) < 2^16
       bit = 16;
   else
       bit = 32;
   end
   imwritetiff(flipud(img), fn, bit)
   disp('Change color scale, set(gca, "caxis", [0, 10])')
   fprintf('Data %s is converted to \n', saxs.imgname);
   fprintf('%s and saved\n', fn);
   add_imagemenu;


% --- Executes on button press in pb_applyinversion.
function pb_applyinversion_Callback(hObject, eventdata, handles)
% hObject    handle to pb_applyinversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SAXSimageviewerhandle = evalin('base', 'SAXSimageviewerhandle');
imgviewer = guihandles(SAXSimageviewerhandle);
xh = round(str2double(imgviewer.XHighLim.String));
yh = round(str2double(imgviewer.YHighLim.String));
xl = round(str2double(imgviewer.XLowLim.String));
yl = round(str2double(imgviewer.YLowLim.String));
saxs = evalin('base', 'saxs');
s = getgihandle;
row = s.imgsize(1);
col = s.imgsize(2);

if yl<0
    yl = 1;
end
if yh > row
    yh = row;
end
if xl < 0
    xl = 1;
end
if xh > col
    xh = col;
end

xroi = xl:xh;
yroi = yl:yh;
if isfield(saxs, 'BeamXY')
    center = saxs.BeamXY;
end
if isfield(saxs, 'center')
    center = saxs.center;
end
%center = [734.7000 224.9250];
xp = xroi-center(1);
yp = yroi-center(2);
%center = [740 217];
[X, Y] = meshgrid(xp, yp);
%load qmap.mat

mask = saxs.mask;
%mask = imread('SAXSmask.bmp');
mask = mask(yroi, xroi);
%tindx = (mask < 1) | (Y < -20);
img = s.image(yroi, xroi);
tindx = (mask < 1) | (img < 0);
%[X, Y] = pol2cart(th, q);
nX = -X(tindx);
nY = -Y(tindx);
nV = interp2(X, Y, img, nX, nY);
img(tindx) = nV;
imwritetiff(flipud(img), sprintf('M%s', s.imagename(2:end)), 32)
% fdata = dir('S*.tif');
% for i=1:numel(fdata)
%     fn = fdata(i).name;
%     img = flipud(imread(fn));
%     img = img(yroi, xroi);
%     img = double(img);
%     nV = interp2(X, Y, img, nX, nY);
%     img(tindx) = nV;
% %    figure(3);
% %    imagesc(xroi-center(1), yroi-center(2), log10(abs(img)));
%     imwritetiff(img, sprintf('M%s', fn(2:end)), 32)
% end

% --- Executes on button press in pb_pickmask.
function pb_pickmask_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pickmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [fname, pname] = uigetfile({'*.bmp', 'bitmap Files (*.bmp)'; '*.*', 'All Files (*.*)'}, 'Pick a mask file');
    if isequal(fname,0) || isequal(pname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pname, fname)])
    end
    mask = imread(fullfile(pname, fname));
    saxs = evalin('base', 'saxs');
    saxs.mask = mask;
    assignin('base', 'saxs', saxs)
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
