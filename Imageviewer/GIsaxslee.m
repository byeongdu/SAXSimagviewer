function varargout = GIsaxslee(varargin)
% SAXSLee Application M-file for untitled.fig
%    FIG = SAXSLee launch untitled GUI.
%    UNTITLED('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 28-Jan-2004 13:54:46

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
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
a = findobj('Tag', 'imgFigure')
figure(a)
point = ginput(2)

center(1) = handles.center(1);
center(2) = handles.center(2);

for i=1:1:2
   X = point(i, 1);
   Y = point(i, 2);
   mu(i) = calmu(center, X, Y);
end

guidata(h, handles);
set(handles.edit1, 'string', mu(1));
set(handles.edit2, 'string', mu(2));


% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
center = handles.center
px = str2num(char(cellstr(get(handles.edit5, 'string'))));
Q = str2num(char(cellstr(get(handles.edit6, 'string'))));

D = circular(double(get_imgFigure), center, [px Q]);
hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');
plot(D(:,1), D(:,2));
size(D)
handles.imgh1d = hd20;
handles.data1d = D;
guidata(h, handles);





% --------------------------------------------------------------------
function varargout = pushbutton4_Callback(h, eventdata, handles, varargin)
center = handles.center
px = str2num(char(cellstr(get(handles.edit5, 'string'))));
Q = str2num(char(cellstr(get(handles.edit6, 'string'))));
mu(1) = str2num(char(cellstr(get(handles.edit1, 'string'))));
mu(2) = str2num(char(cellstr(get(handles.edit2, 'string'))));
if mu(1) > mu(2)
    mu = double(mu);
    mu(1) = mu(1) - 360;
end

D = circular(double(get_imgFigure), center, [px Q], mu(1), mu(2), 0);
hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');

plot(D(:,1), D(:,2));
handles.imgh1d = hd20;
handles.data1d = D;
guidata(h, handles);


% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
set(h, 'value', handles.mu(1))



% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)
set(h, 'value', handles.mu(2))



% --------------------------------------------------------------------
function varargout = pbt_PutCenter_Callback(h, eventdata, handles, varargin)
center(1) = str2num(char(cellstr(get(handles.centX, 'string'))));
center(2) = str2num(char(cellstr(get(handles.centY, 'string'))));
afrefpixel = str2num(char(cellstr(get(handles.afrefpixel, 'string'))));
th2frefpixel = str2num(char(cellstr(get(handles.th2frefpixel, 'string'))));
%rotphi = atan((center(1) - afrefpixel)/(center(2) - th2frefpixel));
sdd = str2num(char(cellstr(get(handles.sdd, 'string'))))
ai = str2num(char(cellstr(get(handles.ai, 'string'))));
pixel_size = str2num(char(cellstr(get(handles.pixel_size, 'string'))));
handles.hSDD = sdd;
handles.hai = ai;
handles.hpixel_size = pixel_size;
handles.center = center;
handles.pxQ = angle2q(rad2deg(pixel_size/sdd));
guidata(h, handles);


% --------------------------------------------------------------------
function varargout = savebtn_Callback(h, eventdata, handles, varargin)
if ~exist('file')
	[file, datadir]=uiputfile('*.dat','Select data file');
	if file==0 return; end
    file = [datadir, file];
end

save1d(file, 20)


% --------------------------------------------------------------------
function varargout = resbtn_Callback(h, eventdata, handles, varargin)
rescale(1) = str2num(char(cellstr(get(handles.rstxt1, 'string'))));
rescale(2) = str2num(char(cellstr(get(handles.rstxt2, 'string'))));

imghandle = figure(handles.imgh);
imagesc(double(get_imgFigure), rescale);axis image;



% --------------------------------------------------------------------
function varargout = axes2_ButtonDownFcn(h, eventdata, handles, varargin)
get(h, 'CurrentPoint')




% --------------------------------------------------------------------
function varargout = pbCenter_Callback(h, eventdata, handles, varargin)
newhandles = guihandles(fCenter);




% --------------------------------------------------------------------
function varargout = pbload_Callback(h, eventdata, handles, varargin)

if ~exist('file')
	[file, datadir]=uigetfile({'*.*','All format(*.*)';'*.spe','CCD data(*.spe)';'*.dat','GAS data(*.dat)'});
	if file==0 return; end
    file = [datadir, file];
end
% ======================== changing at BESSRC in Jan 27, 2004
%ext = find(file == '.')+1;fformat = file(ext:end);
%switch fformat
%case 'spe'
%    R = speopen(file);
%case 'SPE'
%    R = speopen(file);
%case 'dat'
%    R = hciopen(file);
%case 'DAT'
%    R = hciopen(file);
%otherwise
%    R = imread(file);
%end
if get(findobj('Tag', 'rd_GoldD'), 'Value') == 1
    R = goldopen(file);
elseif get(findobj('Tag', 'rd_MarCCD'), 'Value') == 1
    R = imread(file);
elseif get(findobj('Tag', 'rd_PrinceCCD'), 'Value') == 1
    R = speopen(file);
end
% ==========================================================

newfig = imgFigure;
set(newfig, 'Name', file);
newhandles = guihandles(newfig);
handles.new = newhandles;
guidata(h, handles);

axes(newhandles.axis_img);

%phandle = imshow(get_imgFigure);
phandle = image(R, 'CData', newhandles.axis_img);axis image;
set(phandle, 'Parent', newhandles.axis_img);

axes(newhandles.axis_Cmap);
%phandle = imshow(get_imgFigure);
temp = figure(100);
pbarhandle = colorbar;
b = get(pbarhandle);
lim = double(b.YLim);
close(temp);
%lim = [min(min(R)), max(max(R))];
set(findobj('Tag', 'sldMin'), 'Min', lim(1));
set(findobj('Tag', 'sldMin'), 'Max', lim(2));
set(findobj('Tag', 'sldMin'), 'Value', lim(1));

set(findobj('Tag', 'sldMax'), 'Min', lim(1));
set(findobj('Tag', 'sldMax'), 'Max', max(max(R)));
set(findobj('Tag', 'sldMax'), 'Value', lim(2));


set(findobj('Tag', 'txtMin'), 'String', num2str(lim(1)));set(findobj('Tag', 'txtMax'), 'String', num2str(lim(2)));



% --------------------------------------------------------------------
function varargout = MuScan_Callback(h, eventdata, handles, varargin)
%center = handles.center;
center(1) = str2double(get(findobj('Tag', 'NewCenterX'), 'string'));
center(2) = str2double(get(findobj('Tag', 'NewCenterY'), 'string'));
theta = 1:1:359;theta = theta';
factor = str2double(get(findobj('Tag', 'NewPixel'), 'string'));
posi = [factor* cos(theta * pi /180)+center(1),  factor*sin(theta * pi /180)+center(2)];
R = double(get_imgFigure);
for i=1:359
    D(i) = intens(R, posi(i, :));
end
%D = intens(double(get_imgFigure), posi);
D = [theta D'];

hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');

plot(D(:,1), D(:,2));
handles.imgh1d = hd20;
handles.data1d = D;
guidata(h, handles);




% --------------------------------------------------------------------
function varargout = selectQ_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = chk1dHoldon_Callback(h, eventdata, handles, varargin)
figure(handles.imgh1d);
if get(findobj('Tag', 'chk1dHoldon'), 'Value') == 1
    set(gca, 'nextplot','add');
else
    set(gca, 'nextplot','replace');
end


% --- Executes on button press in rb_markCenter.
function rb_markCenter_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') == 1
    b = findobj('Tag', 'axis_img');
    axes(b);
    center = handles.center;
    temp = -100:100;X = zeros(1,201);Y=zeros(1,201);
    Xt = X + center(1)*ones(1,201);Yt = Y + center(2)*ones(1,201) + temp;
    ah = line(Xt, Yt);set(ah, 'Color', [1 0 0]);
    Xt = X + center(1)*ones(1,201) + temp;Yt = Y + center(2)*ones(1,201);
    bh = line(Xt, Yt);set(bh, 'Color', [1 0 0]);
    handles.cross = [ah, bh];
    guidata(hObject, handles);
else
    if isfield(handles, 'cross')
        if ~isempty(handles.cross)
            delete(handles.cross);
        end
    end
end

% hObject    handle to rb_markCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_markCenter


% --- Executes during object creation, after setting all properties.
function Selectmu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Selectmu_Callback(hObject, eventdata, handles)
% hObject    handle to Selectmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Selectmu as text
%        str2double(get(hObject,'String')) returns contents of Selectmu as a double


% --- Executes during object creation, after setting all properties.
function txt_ai_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txt_ai_Callback(hObject, eventdata, handles)
% hObject    handle to txt_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_ai as text
%        str2double(get(hObject,'String')) returns contents of txt_ai as a double


% --- Executes during object creation, after setting all properties.
function SDD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SDD_Callback(hObject, eventdata, handles)
% hObject    handle to SDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SDD as text
%        str2double(get(hObject,'String')) returns contents of SDD as a double


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


% --- Executes during object creation, after setting all properties.
function af_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to af_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function af_ref_Callback(hObject, eventdata, handles)
% hObject    handle to af_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of af_ref as text
%        str2double(get(hObject,'String')) returns contents of af_ref as a double


% --- Executes during object creation, after setting all properties.
function th2f_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th2f_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function th2f_ref_Callback(hObject, eventdata, handles)
% hObject    handle to th2f_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of th2f_ref as text
%        str2double(get(hObject,'String')) returns contents of th2f_ref as a double


% --- Executes during object creation, after setting all properties.
function afrefpixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to afrefpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function afrefpixel_Callback(hObject, eventdata, handles)
% hObject    handle to afrefpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of afrefpixel as text
%        str2double(get(hObject,'String')) returns contents of afrefpixel as a double


% --- Executes during object creation, after setting all properties.
function th2frefpixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th2frefpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function th2frefpixel_Callback(hObject, eventdata, handles)
% hObject    handle to th2frefpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of th2frefpixel as text
%        str2double(get(hObject,'String')) returns contents of th2frefpixel as a double


% --- Executes during object creation, after setting all properties.
function txt_2thi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_2thi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txt_2thi_Callback(hObject, eventdata, handles)
% hObject    handle to txt_2thi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_2thi as text
%        str2double(get(hObject,'String')) returns contents of txt_2thi as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function pixel_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pixel_size_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_size as text
%        str2double(get(hObject,'String')) returns contents of pixel_size as a double



function centY_Callback(hObject, eventdata, handles)
% hObject    handle to centY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centY as text
%        str2double(get(hObject,'String')) returns contents of centY as a double


% --- Executes on button press in af0lineDraw.
function af0lineDraw_Callback(hObject, eventdata, handles)
% hObject    handle to af0lineDraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of af0lineDraw
if get(hObject, 'Value') == 1
    b = findobj('Tag', 'axis_img');
    axes(b);
    center = handles.center;
    ai = handles.hai;
    SDD = handles.hSDD;
    pixelsize = handles.hpixel_size;
    temp = -100:100;X = zeros(1,201);Y=zeros(1,201);
    %Xt = X + center(1)*ones(1,201);Yt = Y + center(2)*ones(1,201) + temp;
    %ah = line(Xt, Yt);set(ah, 'Color', [1 0 0]);
    SDD
    ai
    
    tan(deg2rad(ai))*SDD
    Xt = X + center(1)*ones(1,201) + temp;Yt = Y + (center(2) - fix(tan(deg2rad(ai))*SDD/pixelsize))*ones(1,201);
    bh = line(Xt, Yt);set(bh, 'Color', [1 0 0]);
    handles.af0line = [bh];
    guidata(hObject, handles);
else
    if isfield(handles, 'af0line')
        if ~isempty(handles.af0line)
            delete(handles.af0line);
        end
    end
end


% --- Executes during object creation, after setting all properties.
function ai_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ai_Callback(hObject, eventdata, handles)
% hObject    handle to ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ai as text
%        str2double(get(hObject,'String')) returns contents of ai as a double



function centX_Callback(hObject, eventdata, handles)
% hObject    handle to centX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centX as text
%        str2double(get(hObject,'String')) returns contents of centX as a double


% --- Executes during object creation, after setting all properties.
function sdd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function sdd_Callback(hObject, eventdata, handles)
% hObject    handle to sdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdd as text
%        str2double(get(hObject,'String')) returns contents of sdd as a double


% --- Executes during object creation, after setting all properties.
function pX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pX_Callback(hObject, eventdata, handles)
% hObject    handle to pX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pX as text
%        str2double(get(hObject,'String')) returns contents of pX as a double


% --- Executes during object creation, after setting all properties.
function pY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pY_Callback(hObject, eventdata, handles)
% hObject    handle to pY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pY as text
%        str2double(get(hObject,'String')) returns contents of pY as a double


% --- Executes on button press in pbAngCal.
function pbAngCal_Callback(hObject, eventdata, handles)
% hObject    handle to pbAngCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    b = findobj('Tag', 'axis_img');
    axes(b);
    pX = str2num(char(cellstr(get(handles.pX, 'string'))));
    pY = str2num(char(cellstr(get(handles.pY, 'string'))));
    center = handles.center;
    ai = handles.hai;
    SDD = handles.hSDD;
    pixelsize = handles.hpixel_size;
    thf = rad2deg(atan((pX - center(1))/SDD*pixelsize));
    af = rad2deg(atan((-pY + center(2))./sqrt((SDD/pixelsize)^2 + (pX-center(1))^2))) - ai;
    set(findobj('Tag', 'txtthf'), 'String', num2str(thf));
    set(findobj('Tag', 'txtaf'), 'String', num2str(af));
    q = angle2vq([ai, af], [0, thf]);
    set(findobj('Tag', 'txtqx'), 'String', num2str(q(1)));
    set(findobj('Tag', 'txtqy'), 'String', num2str(q(2)));
    set(findobj('Tag', 'txtqz'), 'String', num2str(q(3)));


% --- Executes during object creation, after setting all properties.
function txtHorzline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtHorzline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtHorzline_Callback(hObject, eventdata, handles)
% hObject    handle to txtHorzline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtHorzline as text
%        str2double(get(hObject,'String')) returns contents of txtHorzline as a double


% --- Executes during object creation, after setting all properties.
function txtVertline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVertline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function txtVertline_Callback(hObject, eventdata, handles)
% hObject    handle to txtVertline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVertline as text
%        str2double(get(hObject,'String')) returns contents of txtVertline as a double


% --- Executes on button press in pbvertline.
function pbvertline_Callback(hObject, eventdata, handles)
% hObject    handle to pbvertline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b = findobj('Tag', 'axis_img');
axes(b);
%pX = str2num(char(cellstr(get(handles.pX, 'string'))));
pY = str2num(char(cellstr(get(handles.txtHorzline, 'string'))));
center = handles.center;
ai = handles.hai;
SDD = handles.hSDD;
pixelsize = handles.hpixel_size;
dataimg = double(get_imgFigure);
imgsize = size(dataimg)
pX = 1:imgsize(1);
%thf = rad2deg(atan((pX - center(1))/SDD*pixelsize));
af = rad2deg(atan((-pX + center(2))./sqrt((SDD/pixelsize)^2 + (pY-center(1))^2))) - ai;

hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');
plot(af, dataimg(:, pY));D = [reshape(af, length(af), 1), reshape(dataimg(:, pY), length(af), 1)];
size(D);
handles.imgh1d = hd20;
handles.data1d = D;
guidata(hObject, handles);


% --- Executes on button press in phHorzline.
function phHorzline_Callback(hObject, eventdata, handles)
% hObject    handle to phHorzline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b = findobj('Tag', 'axis_img');
axes(b);
%pX = str2num(char(cellstr(get(handles.pX, 'string'))));
pX = str2num(char(cellstr(get(handles.txtVertline, 'string'))));
center = handles.center;
ai = handles.hai;
SDD = handles.hSDD;
pixelsize = handles.hpixel_size;
dataimg = double(get_imgFigure);
imgsize = size(dataimg);pY = 1:imgsize(2);
thf = rad2deg(atan((pY - center(1))/SDD*pixelsize));

hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');
plot(thf, dataimg(pX, :));D = [reshape(thf, length(thf), 1), reshape(dataimg(pX, :), length(thf), 1)];
size(D)
handles.imgh1d = hd20;
handles.data1d = D;
guidata(hObject, handles);


% --- Executes on button press in pbArbline.
function pbArbline_Callback(hObject, eventdata, handles)
% hObject    handle to pbArbline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b = findobj('Tag', 'axis_img');
axes(b);
%pX = str2num(char(cellstr(get(handles.pX, 'string'))));
pX = str2num(char(cellstr(get(handles.txtVertline, 'string'))));
center(1) = str2num(char(cellstr(get(handles.txt_AbStX, 'string'))));
center(2) = str2num(char(cellstr(get(handles.txt_AbStY, 'string'))));
%center = handles.center;
ai = handles.hai;
SDD = handles.hSDD;
pixelsize = handles.hpixel_size;
dataimg = double(get_imgFigure);
imgsize = size(dataimg);pY = 1:imgsize(2);
t = lineplot(dataimg, center, ginput(1));

hd20 = figure(20);
set(hd20, 'Tag', '1D_Data_Display');
set(hd20, 'Name', '1D plotter');
plot(t(:,1), t(:,2));
size(t)
handles.imgh1d = hd20;
handles.data1d = t;
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pbt_PutCenter.
function pbt_PutCenter_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pbt_PutCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pbArbline.
function pbArbline_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pbArbline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rb_ringMark.
function rb_ringMark_Callback(hObject, eventdata, handles)
% hObject    handle to rb_ringMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value') == 1
    b = findobj('Tag', 'axis_img');
    axes(b);

    %center = handles.center;
    center(1) = str2double(get(findobj('Tag', 'NewCenterX'), 'string'));
    center(2) = str2double(get(findobj('Tag', 'NewCenterY'), 'string'));
    ai = handles.hai;
    SDD = handles.hSDD;
    pixelsize = handles.hpixel_size;

    %l = str2double(get(findobj('Tag', 'selectQ'), 'string'))/handles.pxQ;
    l = str2double(get(findobj('Tag', 'NewPixel'), 'string'));
    newLine = drawC(center, l);
    handles.newLine = newLine;
    guidata(hObject, handles);
else
    if isfield(handles, 'newLine')
        if ~isempty(handles.newLine)
            delete(handles.newLine);
        end
    end
end

% Hint: get(hObject,'Value') returns toggle state of rb_ringMark


% --- Executes during object creation, after setting all properties.
function NewCenterX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewCenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NewCenterX_Callback(hObject, eventdata, handles)
% hObject    handle to NewCenterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewCenterX as text
%        str2double(get(hObject,'String')) returns contents of NewCenterX as a double


% --- Executes during object creation, after setting all properties.
function NewCenterY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewCenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NewCenterY_Callback(hObject, eventdata, handles)
% hObject    handle to NewCenterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewCenterY as text
%        str2double(get(hObject,'String')) returns contents of NewCenterY as a double


% --- Executes during object creation, after setting all properties.
function NewPixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NewPixel_Callback(hObject, eventdata, handles)
% hObject    handle to NewPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewPixel as text
%        str2double(get(hObject,'String')) returns contents of NewPixel as a double





% --------------------------------------------------------------------
function varargout = radiobutton4_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = radiobutton5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = radiobutton6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = checkbox3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = rd_PrinceCCD_Callback(h, eventdata, handles, varargin)

