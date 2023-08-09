function varargout = gisaxsleenew(varargin)
% SAXSLee Application M-file for untitled.fig
%    FIG = SAXSLee launch untitled GUI.
%    UNTITLED('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 03-May-2020 23:32:35

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
    %fig = openfig(mfilename,'reuse');
    %pos = get(fig, 'position');
    if (numel(varargin) < 2)
%        get(varargin{2})
        if strcmp(varargin{1}, 'SetSAXSValues')
            varargin{2} = gisaxsleenew;
            varargin{2} = guihandles(varargin{2});  % 
        else
            varargin{2} = gisaxsleenew;
            varargin{4} = guihandles(varargin{2});  % 
            varargin{2} = [];
            varargin{3} = [];
        end
    elseif (numel(varargin) == 2)
        invar = varargin;
        fig = openfig(mfilename,'reuse');
        handles = guihandles(fig);
        varargin{5} = invar{2};
        varargin{4} = handles;
        varargin{3} = [];
        varargin{2} = [];
        varargin{1} = invar{1};
    end
%saxs=getgihandle
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
a = findobj('Tag', 'imgFigure');
figure(a);
point = ginput(2);

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
center = handles.center;
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
center = handles.center;
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
ReadandSetValues(handles)

[filename, pathname] = uiputfile( ...
       {'*.mat;*.fig;*.mdl', 'All Setup Files (*.mat)'}, ...
        'Save as');
saxs = getgihandle;
if isfield(saxs, 'imgfigurehandle')
    saxs = rmfield(saxs, 'imgfigurehandle');
end
if isfield(saxs, 'mask')
    saxs = rmfield(saxs, 'mask');
end
if isfield(saxs, 'image')
    saxs = rmfield(saxs, 'image');
end
save([pathname, filename], 'saxs');

if isunix
    fid = fopen('~/.SAXSsetup');
    fprintf(fid, '# Pixel Size: %0.3f', saxs.psize);
    fprintf(fid, '# Center X: %0.3f', saxs.center(1));
    fprintf(fid, '# Center Y: %0.3f', saxs.center(2));
    fprintf(fid, '# SDD: %0.3f', saxs.SDD);
    fprintf(fid, '# pitch: %0.3f', saxs.pitch);
    fprintf(fid, '# roll: %0.3f', saxs.roll);
    fprintf(fid, '# yaw: %0.3f', saxs.yaw);
    fclose(fid);
end
%if ~isfield(handles, 'Fname')
    %ImgInfo.Fname = handles.Fname;
%    ImgInfo.Fname = 'Unkown';
%end

%set(gcf, 'UserData', ImgInfo); % handle 'visibility' of main body program figure should be 'off' 

function varargout = ReadandSetValues(varargin)
if numel(varargin) == 1
    handles = varargin{1};
else
    handles = varargin{3};
end
center(1) = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
center(2) = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
px = str2num(char(cellstr(get(handles.ed_STDp, 'string'))));
Q = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
xeng = str2num(char(cellstr(get(handles.ed_Xenergy, 'string'))));
psize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
%offset = str2num(char(cellstr(get(handles.edit23, 'string'))));
waveln = eng2wl(xeng);
SDD = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
ai = str2num(char(cellstr(get(handles.ed_ai, 'string'))));
tthi = str2num(char(cellstr(get(handles.ed_tthi, 'string'))));
offset = str2num(char(cellstr(get(handles.ed_Offset, 'string'))));
edensity = str2num(char(cellstr(get(handles.ed_Edensity, 'string'))));
beta = str2num(char(cellstr(get(handles.ed_Beta, 'string'))));
try
    %tiltangle = str2num(char(cellstr(get(handles.ed_tiltangle, 'string'))));
    tiltangle = eval(char(cellstr(get(handles.ed_tiltangle, 'string'))));
catch
    tiltangle = 0;
end
%saxs = get(handles.gisaxsleenew,'userdata');
saxs = getgihandle;
saxs.waveln = waveln;
%saxs = setfield(saxs, 'offset', offset);
saxs.center= center;
saxs.SDD= SDD;
saxs.xeng= xeng;
saxs.psize= psize;
saxs.pxQ= Q/px;
saxs.px= px;
saxs.Q= Q;
saxs.ai= ai;
saxs.tthi = tthi;
saxs.offset= offset;
saxs.edensity= edensity;
saxs.beta= beta;
saxs.tiltangle = tiltangle;
%set(handles.gisaxsleenew,'userdata', saxs);
setgihandle(saxs);

function varargout = SetSAXSValues(handles)
saxs = getgihandle;
%center(1) = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
if isfield(saxs, 'center')
    set(handles.ed_Cx, 'string', saxs.center(1));
    set(handles.ed_Cy, 'string', saxs.center(2));
end
if isfield(saxs, 'xeng')
    set(handles.ed_Xenergy, 'string', saxs.xeng);
end
%psize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
if isfield(saxs, 'psize')
    set(handles.ed_pSize, 'string', saxs.psize);
end
%offset = str2num(char(cellstr(get(handles.edit23, 'string'))));
%waveln = eng2wl(xeng);
%SDD = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
if isfield(saxs, 'SDD')
    set(handles.ed_SDD, 'string', saxs.SDD);
end
if isfield(saxs, 'tiltangle')
    if numel(saxs.tiltangle)>1
        str = strcat('[',num2str(saxs.tiltangle),']');
    else
        str = num2str(saxs.tiltangle);
    end
    set(handles.ed_tiltangle, 'string', str);
end
if isfield(saxs, 'ai')
    set(handles.ed_ai, 'string', saxs.ai);
end
if isfield(saxs, 'Q')
    set(handles.ed_STDq, 'string', saxs.Q);
end
if isfield(saxs, 'px')
    if saxs.px ~= get(handles.ed_STDp, 'string')
        set(handles.ed_STDp, 'string', num2str(saxs.px));
        Q = str2double(get(handles.ed_STDq, 'string'));
        psize = str2double(get(handles.ed_pSize, 'string'));
        waveln = eng2wl(str2double(get(handles.ed_Xenergy, 'string')));
        SDD = SDDcal(saxs.px, Q, psize, waveln);
        saxs.pxQ = Q/saxs.px;
        set(handles.ed_SDD, 'string', num2str(SDD));
    end
end
%ai = str2num(char(cellstr(get(handles.ed_ai, 'string'))));
% set(handles.ed_ai, 'string', saxs.ai);
%offset = str2num(char(cellstr(get(handles.ed_Offset, 'string'))));
if isfield(saxs, 'offset')
    set(handles.ed_Offset, 'string', saxs.offset);
end
%edensity = str2num(char(cellstr(get(handles.ed_Edensity, 'string'))));
%beta = str2num(char(cellstr(get(handles.ed_Beta, 'string'))));
%set(handles.ed_Edensity, 'string', saxs.edensity);
%set(handles.ed_Beta, 'string', saxs.beta);
imgh = evalin('base', 'SAXSimageviewerhandle');
setgihandle(saxs)
figure(imgh);


% --------------------------------------------------------------------
function varargout = savebtn_Callback(h, eventdata, handles, varargin)
if ~exist('file')
	[file, datadir]=uiputfile('*.dat','Select data file');
	if file==0 return; end
    file = [datadir, file];
end
[x, y, z] = getlinefig(gcf);
if prod(size(x)) == prod(size(z.qp))
    k = [z.qp', y];
elseif prod(size(x)) ~= prod(size(z.qp)) & (isfield(z, 'af') == 1)
    k = [z.af', y];
elseif prod(size(x)) ~= prod(size(z.qp)) & (isfield(z, 'af') ~= 1) & (isfield(z, 'QperP') == 1)
    k = [x*z.QperP, y];
elseif prod(size(x)) ~= prod(size(z.qp)) & (isfield(z, 'af') ~= 1) & (isfield(z, 'QperP') ~= 1)
    k = [x, y];
end
strsave = ['save ', file, ' k -ascii'];
eval(strsave);


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
function varargout = pbload_Callback(h, eventdata, handles, varargin)
%saxs=getgihandle;
saxs = getgihandle;
eventdata = varargin{1};
if isempty(eventdata)
    saxs = openccdfile({},saxs);
else
    saxs = openccdfile(eventdata, saxs);
end
setgihandle(saxs);

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
    %b = findobj(handles.ImgNew, 'Type', 'axes');
    b = findobj(gcf, 'Type', 'axes');
    axes(b);
    Cx = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
    Cy = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
    
    temp = -100:100;X = zeros(1,201);Y=zeros(1,201);
    Xt = X + Cx*ones(1,201);Yt = Y + Cy*ones(1,201) + temp;
    ah = line(Xt, Yt);set(ah, 'Color', [1 0 0]);
    Xt = X + Cx*ones(1,201) + temp;Yt = Y + Cy*ones(1,201);
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
    %b = findobj(handles.ImgNew, 'Type', 'axes');
    b = findobj(gcf, 'Type', 'axes');
    axes(b);
    STDq = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
    STDp = str2num(char(cellstr(get(handles.ed_STDp, 'string'))));
    pSize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
    SDD = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
    ai = str2num(char(cellstr(get(handles.ed_ai, 'string'))));
    Cx = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
    Cy = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
    %Xt = X + center(1)*ones(1,201);Yt = Y + center(2)*ones(1,201) + temp;
    %ah = line(Xt, Yt);set(ah, 'Color', [1 0 0]);
    Xt = (Cx-100):(Cx+100);Yt = (Cy - fix(tan(deg2rad(ai))*SDD/pSize))*ones(1,201);
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
imgsize = size(dataimg);
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
% --- Executes on button press in rd_MarCCD.
function rd_PrinceCCD_Callback(hObject, eventdata, handles)
% hObject    handle to rd_MarCCD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_MarCCD
if (get(hObject, 'Value') == 1)
%    hSAXSlee=findobj('Tag','gisaxsleenew');
    saxs=getgihandle;
    saxs = setfield(saxs, 'CCD', 'princeton');
    saxs = setfield(saxs, 'frame', 1);
    setgihandle(saxs);
end





% --------------------------------------------------------------------
function varargout = edit31_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit32_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit33_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit34_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit35_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_SDD_Callback(h, eventdata, handles, varargin)
center(1) = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
center(2) = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
px = str2num(char(cellstr(get(handles.ed_STDp, 'string'))));
Q = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
xeng = str2num(char(cellstr(get(handles.ed_Xenergy, 'string'))));
psize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
%offset = str2num(char(cellstr(get(handles.edit23, 'string'))));
waveln = eng2wl(xeng);
SDD = SDDcal(px, Q, psize, waveln);
set(handles.ed_SDD, 'string', num2str(SDD));
%saxs = get(handles.gisaxsleenew,'userdata');
saxs = getgihandle;
saxs = setfield(saxs, 'waveln', waveln);
%saxs = setfield(saxs, 'offset', offset);
saxs = setfield(saxs, 'center', center);
saxs = setfield(saxs, 'SDD', SDD);
saxs = setfield(saxs, 'xeng', xeng);
saxs = setfield(saxs, 'psize', psize);
saxs = setfield(saxs, 'pxQ', Q/px);
%set(handles.gisaxsleenew,'userdata', saxs);
setgihandle(saxs);

% --------------------------------------------------------------------
function varargout = radiobutton7_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_SDD_ButtonDownFcn(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = af2aiLine_Callback(hObject, eventdata, handles)

if get(hObject, 'Value') == 1
    %b = findobj(handles.ImgNew, 'Type', 'axes');
    b = findobj(gcf, 'Type', 'axes');
    axes(b);
    STDq = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
    STDp = str2num(char(cellstr(get(handles.ed_STDp, 'string'))));
    pSize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
    SDD = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
    ai = str2num(char(cellstr(get(handles.ed_ai, 'string'))));
    Cx = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
    Cy = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
    %Xt = X + center(1)*ones(1,201);Yt = Y + center(2)*ones(1,201) + temp;
    %ah = line(Xt, Yt);set(ah, 'Color', [1 0 0]);
    Xt = (Cx-100):(Cx+100);Yt = (Cy - 2*fix(tan(deg2rad(ai))*SDD/pSize))*ones(1,201);
    bh = line(Xt, Yt);set(bh, 'Color', [1 0 0]);
    handles.af2aline = [bh];
    guidata(hObject, handles);
else
    if isfield(handles, 'af2aline')
        if ~isempty(handles.af2aline)
            delete(handles.af2aline);
        end
    end
end


% --- Executes on button press in pb_Expload.
function pb_Expload_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Expload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Expfilename = char(cellstr(get(handles.ed_ExpFilename, 'string')));
Expfilename = '';
if isempty(Expfilename)
	[filen, datadir]=uigetfile({'*.GSP','GISAXS Exp Par(*.gsp)';'*.*','All format(*.*)'});
	if filen==0 return; end
    file = [datadir, filen];
end

fid = fopen(file,'r');
if (fid == -1)
  error('File not found or permission denied.');
end

firstline = '';
firstline = fgetl(fid);

while ~prod(double(firstline(1:4) == '*End'))
   if (firstline(1) ~= '%')
       divPar = find(firstline == ':');
       linevalue = sscanf(firstline(divPar+1:end), '%f');
       switch firstline(1:4)
           case 'X-ra'
               set(handles.ed_Xenergy, 'string', linevalue);
           case 'XCen'
               set(handles.ed_Cx, 'string', linevalue);
           case 'YCen'
               set(handles.ed_Cy, 'string', linevalue);
           case 'Pixe'
               set(handles.ed_STDp, 'string', linevalue);
           case 'Psiz'
               set(handles.ed_pSize, 'string', linevalue);
           case 'q va'
               set(handles.ed_STDq, 'string', linevalue);
           case 'SDD('
               set(handles.ed_SDD, 'string', linevalue);
           end
    end
    firstline = fgetl(fid);
end
fclose(fid);
set(handles.ed_ExpFilename, 'string', filen);

% --- Executes on button press in pb_Expsave.
function pb_Expsave_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Expsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirF = pwd;
filen = get(handles.ed_ExpFilename, 'string');

fid = fopen(filen,'w');
S(1) = {'X-ray Energy(keV) : '};
S(2) = {'Wavelength(A) : '};
S(3) = {'Psize(Pixel size, mm) : '};
S(4) = {'XCenter : '};
S(5) = {'YCenter : '};
S(6) = {'Pixel Distance(Standard) : '};
S(7) = {'q value(A-1, Standard) : '};
S(8) = {'SDD(mm) : '};
S(9) = {'*End'};
data(1) = str2num(char(cellstr(get(handles.ed_Xenergy, 'string'))));
data(2) = 12.398/data(1);
data(3) = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
data(4) = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
data(5) = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
data(6) = str2num(char(cellstr(get(handles.ed_STDp, 'string'))));
data(7) = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
data(8) = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
for i=1:8
    strsave = [S{i}, num2str(data(i)), '\n'];
    fprintf(fid, strsave);
end
fprintf(fid, S{9});
fclose(fid);
        
% --- Executes on button press in pb_Expedit.
function pb_Expedit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Expedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filen = get(handles.ed_ExpFilename, 'string');
edit(filen);

% --- Executes during object creation, after setting all properties.
function ed_ExpFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ExpFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ed_ExpFilename_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ExpFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ExpFilename as text
%        str2double(get(hObject,'String')) returns contents of ed_ExpFilename as a double


% --- Executes on button press in pb_imganalysis.
function pb_imganalysis_Callback(hObject, eventdata, handles)
% hObject    handle to pb_imganalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imganalysis


% --- Executes on button press in pbSave1DasIS.
function pbSave1DasIS_Callback(hObject, eventdata, handles)
if ~exist('file')
	[file, datadir]=uiputfile('*.dat','Select data file');
	if file==0 return; end
    if isempty(findstr(file, '.dat')); file = [file, '.dat']; end
    file = [datadir, file];
end
[x, y, z] = getlinefig(gcf);
% x = 0:.1:1; y = [x; exp(x)];
fieldN = fieldnames(z);
sizez = numel(fieldN);
fid = fopen(file,'w');
for i=1:sizez
    fdata = getfield(z, fieldN{i});
    if length(fdata) == 1
        if isnumeric(fdata)
            tempStr = [fieldN{i}, ' : ', num2str(fdata)];
            fprintf(fid, '%s\n', tempStr);
        end
    end
end

if isfield(z, 'xaxisname')
    tempStr = [z.xaxisname, '    ' , 'I(', z.xaxisname, ')'];
    fprintf(fid, '%s\n', tempStr);
    k = [x'; y'];
    fprintf(fid, '%6.5f    %8.3f\n', k);
    fclose(fid);
else
    tempStr = ['Angle', '    ' , 'I(', 'angle', ')'];
    fprintf(fid, '%s\n', tempStr);
    k = [x'; y'];
    fprintf(fid, '%6.5f    %8.3f\n', k);
    fclose(fid);
end    

% hObject    handle to pbSave1DasIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------



% --------------------------------------------------------------------
function varargout = ed_GB_sb_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_GB_byte_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_GB_dimX_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_GB_dimY_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = rd_UpDown_Callback(h, eventdata, handles, varargin)
imgoperation(handles)

% saxs=getgihandle;
% %imgopr = getfield(saxs, 'imgoperation');
% imgopr.UpDown = get(h, 'Value');
% saxs.imgoperation = imgopr;
% setgihandle(saxs);




% --------------------------------------------------------------------
function varargout = rd_LeftRight_Callback(h, eventdata, handles, varargin)
imgoperation(handles)
% 
% saxs=getgihandle;
% %imgopr = getfield(saxs, 'imgoperation');
% imgopr.LeftRight = get(h, 'Value');
% saxs.imgoperation = imgopr;
% setgihandle(saxs);





% --------------------------------------------------------------------
function varargout = rd_Transpose_Callback(h, eventdata, handles, varargin)
imgoperation(handles)
% saxs=getgihandle;
% %imgopr = getfield(saxs, 'imgoperation');
% imgopr.transpose = get(h, 'Value');
% saxs.imgoperation = imgopr;
% setgihandle(saxs);

function imgoperation(handles)
saxs=getgihandle;
%imgopr = getfield(saxs, 'imgoperation');
imgopr.Transpose = get(handles.rd_Transpose, 'Value');
imgopr.UpDown = get(handles.rd_UpDown, 'Value');
imgopr.LeftRight = get(handles.rd_LeftRight, 'Value');
saxs.imgoperation = imgopr;
setgihandle(saxs);



% --------------------------------------------------------------------
function varargout = pushbutton24_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbSaveBinary_Callback(h, eventdata, handles, varargin)
if ~exist('file')
	[filen, datadir]=uigetfile({'*.*','All format(*.*)';'*.spe','CCD data(*.spe)';'*.dat','GAS data(*.dat)'});
	if filen==0 return; end
    file = [datadir, filen];
end
if get(findobj(handles.gisaxsleenew, 'Tag', 'rd_GoldD'), 'Value') == 1
    disp('Program was not available now, request to the author')
elseif get(findobj(handles.gisaxsleenew, 'Tag', 'rd_MarCCD'), 'Value') == 1
    disp('Program was not available now, request to the author')
elseif get(findobj(handles.gisaxsleenew, 'Tag', 'rd_PrinceCCD'), 'Value') == 1
    disp('Program was not available now, request to the author')
elseif get(findobj(handles.gisaxsleenew, 'Tag', 'rd_Gbinary'), 'Value') == 1
    GB_dataFormat = get(handles.ed_GB_byte, 'string');
    GB_dimX = str2num(get(handles.ed_GB_dimX, 'string'));
    GB_dimY = str2num(get(handles.ed_GB_dimY, 'string'));
    GB_Startbyte = str2num(get(handles.ed_GB_sb, 'string'));
    fid = fopen(filename, 'r+', 'n');
    fseek(fid, startbyte, -1);
    R = fwrite(fid, get(findobj(gcf, 'type', 'image'), 'Cdata'), dataFormat)';
    fclose(fid);    
else
    disp('Please select one of file format')
    return
end


% --- Executes on button press in pbSAXS.
function pbSAXS_Callback(hObject, eventdata, handles)
% hObject    handle to pbSAXS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxsaverage2


% --- Executes on button press in pbfilelist.

function pbfilelist_Callback(hObject, eventdata, handles)
% hObject    handle to pbfilelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = SAXSfilelist;
hlbl = findobj(h, 'tag', 'lbfile');
set(hlbl, 'callback', {@lblistcallback, h});

function lblistcallback(hObject, eventdata, varargin)
if ~isempty(varargin)
    handles = getappdata(varargin{1}, 'handle');
else
    return
end
if strcmp(get(handles.SAXSfileList,'SelectionType'),'open') % If double click
    index_selected = get(handles.lbfile,'Value');
    file_list = get(handles.lbfile,'String');
    filename = file_list{index_selected}; % Item selected in list box
    wildcard = char(cellstr(get(handles.ed_wild, 'string')));
    if handles.is_dir(handles.sorted_index(index_selected))
        cd (filename);
        load_listbox(pwd, wildcard, handles);
        set(handles.ed_dir,'String',pwd);
    else
        [path,name,ext,ver] = fileparts(filename);
%        hSAXSlee=findobj('Tag','gisaxsleenew');
%        if isempty(hSAXSlee)==1
%            disp('An empty structure in Userdata')
%        else
            saxs=getgihandle;
            saxs=openccdfile({path, [name,ext]},saxs);
            setgihandle(saxs);
%        end
    end
end

% --- Executes on button press in rd_GoldD.
function rd_GoldD_Callback(hObject, eventdata, handles)
% hObject    handle to rd_GoldD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_GoldD
if (get(hObject, 'Value') == 1)
%    hSAXSlee=findobj('Tag','gisaxsleenew');
    saxs=getgihandle;
    saxs.CCD = 'goldccd';
    setgihandle(saxs);
end


% --- Executes on button press in rd_MarCCD.
function rd_MarCCD_Callback(hObject, eventdata, handles)
% hObject    handle to rd_MarCCD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_MarCCD
if (get(hObject, 'Value') == 1)
%    hSAXSlee=findobj('Tag','gisaxsleenew');
    saxs=getgihandle;
    saxs.CCD = 'mar165';
    setgihandle(saxs);
end


% --- Executes on button press in pbLoadSpecFile.
function pbLoadSpecFile_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadSpecFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, datadir]=uigetfile({'*.*','All format(*.*)'});
if file==0 return; end
file = [datadir, file];
%set(handles.ed_histfile, 'string', file);
%hSAXSlee = findobj('Tag', 'gisaxsleenew');
%saxs = get(hSAXSlee, 'Userdata');
saxs = getgihandle;

% EngCol = str2num(char(cellstr(get(handles.ed_EngCol, 'string'))));
% NormCol = str2num(char(cellstr(get(handles.ed_NormCol, 'string'))));
% aiCol = str2num(char(cellstr(get(handles.ed_aiCol, 'string'))));
% norminfo.xengcol = EngCol;
% norminfo.normcol = NormCol;
% norminfo.aicol = aiCol;
% 
% norminfo.ai = get(handles.rbai_column, 'value');
% norminfo.norm = get(handles.radiobutton13, 'value');
% norminfo.xeng = get(handles.radiobutton12, 'value');
% norminfo.histfile = file;
% 
% if isfield(saxs, 'imgname')
%     [~,n,e] = fileparts(saxs.imgname);
%     cnt = specSAXSn2(norminfo.histfile, sprintf('%s%s*', n, e), 1);    
%     for kk=1:numel(cnt)
%         disp(sprintf('Data of column %d: %f', kk, cnt(kk)));
%     end
%     EngCol = input('What is the number of the energy column?:  ');
%     if EngCol == 0
%         set(handles.radiobutton12, 'value', 0);
%     else
%         set(handles.ed_EngCol, 'string', EngCol);
%     end
%     NormCol = input('What is the number of the column for normalization?:  ');
%     if NormCol == 0
%         set(handles.radiobutton13, 'value', 0);
%     else
%         set(handles.ed_NormCol, 'string', NormCol);
%     end
%     aiCol = input('What is the number of the ai column?:  ');
%     if aiCol == 0
%         set(handles.rbai_column, 'value', 0);
%     else
%         set(handles.ed_aiCol, 'string', aiCol);
%     end
% end    
% norminfo.xengcol = EngCol;
% norminfo.normcol = NormCol;
% norminfo.aicol = aiCol;
% norminfo.histfile = file;
% saxs.norminfo = norminfo;
saxs.specfile = file;
%set(hSAXSlee, 'Userdata', saxs);
setgihandle(saxs);

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_Gbinary.
function rd_Gbinary_Callback(hObject, eventdata, handles)
% hObject    handle to rd_Gbinary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_Gbinary

startbyte = str2num(char(cellstr(get(handles.ed_GB_sb, 'string'))));
dimX = str2num(char(cellstr(get(handles.ed_GB_dimX, 'string'))));
dimY = str2num(char(cellstr(get(handles.ed_GB_dimY, 'string'))));
byte = char(cellstr(get(handles.ed_GB_byte, 'string')));
GB.startbyte = startbyte;
GB.dimX = dimX;
GB.dimY = dimY;
GB.byte = byte;
if (get(hObject, 'Value') == 1)
%    hSAXSlee=findobj('Tag','gisaxsleenew');
    saxs=getgihandle;
    saxs = setfield(saxs, 'CCD', 'GBinary');
    saxs = setfield(saxs, 'GB', GB);
    setgihandle(saxs);
end


% --- Executes during object creation, after setting all properties.
function gisaxsleenew_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gisaxsleenew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%hSAXSlee=findobj('Tag','gisaxsleenew');
%saxs=getgihandle;

saxs = [];
%setgihandle(saxs);
imgopr.UpDown = 0;
imgopr.LeftRight = 0;
imgopr.transpose = 0;

saxs.imgoperation = imgopr;
setgihandle(saxs);
disp(handles)
%saxs=getgihandle


% --- Executes just before qCalibration2 is made visible.
function gisaxsleenew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qCalibration2 (see VARARGIN)

% Choose default command line output for qCalibration2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
ReadandSetValues(handles)
disp(handles)


% --- Executes on button press in pbt_loadsetup.
function pbt_loadsetup_Callback(hObject, eventdata, handles)
% hObject    handle to pbt_loadsetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

si = getgihandle;
[filename, pathname] = uigetfile( ...
       {'*.m;*.fig;*.mat;*.mdl', 'All Setup Files (*.mat)'}, ...
        'Open as');
load([pathname, filename], 'saxs');

if isfield(saxs, 'center')
    set(handles.ed_Cx, 'string', num2str(saxs.center(1)));
    set(handles.ed_Cy, 'string', num2str(saxs.center(2)));
elseif isfield(saxs, 'BeamXY')
    set(handles.ed_Cx, 'string', num2str(saxs.BeamXY(1)));
    set(handles.ed_Cy, 'string', num2str(saxs.BeamXY(2)));
    saxs.center = saxs.BeamXY;
    saxs = rmfield(saxs, 'BeamXY');
end

if isfield(saxs, 'xeng')
    set(handles.ed_Xenergy, 'string', num2str(saxs.xeng));
elseif isfield(saxs, 'eng')
    set(handles.ed_Xenergy, 'string', num2str(saxs.eng));
    saxs.xeng = saxs.eng;
    saxs = rmfield(saxs, 'eng');
end

if isfield(saxs, 'psize')
    set(handles.ed_pSize, 'string', num2str(saxs.psize));
elseif isfield(saxs, 'pSize')
    set(handles.ed_pSize, 'string', num2str(saxs.pSize));
    saxs.psize = saxs.pSize;
    saxs = rmfield(saxs, 'pSize');
end
if isfield(saxs, 'SDD')
    set(handles.ed_SDD, 'string', num2str(saxs.SDD));
else
    set(handles.ed_SDD, 'string', '2000');
    saxs.SDD = 2000;
end

if isfield(saxs, 'ai')
    set(handles.ed_ai, 'string', num2str(saxs.ai));
else
    set(handles.ed_ai, 'string', '0');
    saxs.ai = 0;
end

if isfield(saxs, 'px')
    set(handles.ed_STDp, 'string', num2str(saxs.px));
    set(handles.ed_STDq, 'string', num2str(saxs.Q));
else
    set(handles.ed_STDq, 'string', '0.10765');
%    set(handles.ed_STDp, 'string', num2str(saxs.px));
    saxs.px = 0.10765;
end
if isfield(saxs, 'offset')
    set(handles.ed_Offset, 'string', num2str(saxs.offset));
else
    set(handles.ed_Offset, 'string', '0');
    saxs.offset = 0;
end
if isfield(saxs, 'edensity')
    set(handles.ed_Edensity, 'string', saxs.edensity);
else
    set(handles.ed_Edensity, 'string', '0');
    saxs.edensity = 0;
end
if isfield(saxs, 'beta')
    set(handles.ed_Beta, 'string', saxs.beta);
else
    set(handles.ed_Beta, 'string', '0');
    saxs.beta = 0;
end
saxs.dir = pathname;
saxs.specfile = '';
if isfield(saxs, 'qMap')
    saxs = rmfield(saxs, 'qMap');
end
if isfield(saxs, 'qCMap')
    saxs = rmfield(saxs, 'qCMap');
end
if isfield(saxs, 'qRMap')
    saxs = rmfield(saxs, 'qRMap');
end
if isfield(saxs, 'mask')
    saxs = rmfield(saxs, 'mask');
end
if isfield(saxs, 'qArray')
    saxs = rmfield(saxs, 'qArray');
end

try
    tilt = sprintf('%0.2f', saxs.tiltangle(1));
    if numel(saxs.tiltangle) > 1
        for i=2:numel(saxs.tiltangle)
            tilt = sprintf('%s %0.2f', tilt, saxs.tiltangle(i));
        end
        tilt = ['[', tilt, ']'];
    end
    set(handles.ed_tiltangle, 'string', tilt);
catch
    saxs.tiltangle = 0;
end
if isfield(saxs, 'imgoperation')
    try
        set(handles.rd_UpDown, 'value',     saxs.imgoperation.UpDown);
    catch
        set(handles.rd_UpDown, 'value',     0);
    end
    try
        set(handles.rd_LeftRight, 'value',  saxs.imgoperation.LeftRight);
    catch
        set(handles.rd_LeftRight, 'value',  0);
    end
    try
        set(handles.rd_Transpose, 'value',  saxs.imgoperation.transpose);
    catch
        set(handles.rd_Transpose, 'value',  0);
    end
end

if isfield(si, 'image')
    saxs.image = si.image;
    saxs.imgname = si.imgname;
    saxs.imagename = si.imagename;
    saxs.imgsize = si.imgsize;
end
setgihandle(saxs);
ed_SDD_Callback([], [], handles)

% --- Executes on button press in pbloglin.
function pbloglin_Callback(hObject, eventdata, handles)
% hObject    handle to pbloglin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loglin

function GetSAXS(hObject, eventdata, handles, varargin)
% hObject    handle to pbloglin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = get(handles.gisaxsleenew, 'userdata');
imageviewer2(varargin{1}, saxs)



function ed_ai_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ai as text
%        str2double(get(hObject,'String')) returns contents of ed_ai as a double
ReadandSetValues(handles)



function ed_SDD_Callback(hObject, eventdata, handles)
% hObject    handle to ed_SDD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_SDD as text
%        str2double(get(hObject,'String')) returns contents of ed_SDD as a double
center(1) = str2num(char(cellstr(get(handles.ed_Cx, 'string'))));
center(2) = str2num(char(cellstr(get(handles.ed_Cy, 'string'))));
Q = str2num(char(cellstr(get(handles.ed_STDq, 'string'))));
xeng = str2num(char(cellstr(get(handles.ed_Xenergy, 'string'))));
psize = str2num(char(cellstr(get(handles.ed_pSize, 'string'))));
SDD = str2num(char(cellstr(get(handles.ed_SDD, 'string'))));
%offset = str2num(char(cellstr(get(handles.edit23, 'string'))));
waveln = eng2wl(xeng);
px = SDDcal(SDD, Q, psize, waveln, 'sdd');
set(handles.ed_STDp, 'string', sprintf('%0.3f', px));
%saxs = get(handles.gisaxsleenew,'userdata');
saxs = getgihandle;
%saxs = setfield(saxs, 'waveln', waveln);
%saxs = setfield(saxs, 'offset', offset);
%saxs = setfield(saxs, 'center', center);
%saxs = setfield(saxs, 'xeng', xeng);
%saxs = setfield(saxs, 'psize', psize);
%saxs = setfield(saxs, 'pxQ', Q/px);
%set(handles.gisaxsleenew,'userdata', saxs);
setgihandle(saxs);
ReadandSetValues(handles)



function ed_STDq_Callback(hObject, eventdata, handles)
% hObject    handle to ed_STDq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_STDq as text
%        str2double(get(hObject,'String')) returns contents of ed_STDq as a double
ReadandSetValues(handles)



function ed_STDp_Callback(hObject, eventdata, handles)
% hObject    handle to ed_STDp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_STDp as text
%        str2double(get(hObject,'String')) returns contents of ed_STDp as a double
ReadandSetValues(handles)



function ed_Cx_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Cx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Cx as text
%        str2double(get(hObject,'String')) returns contents of ed_Cx as a double
ReadandSetValues(handles)



function ed_Cy_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Cy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Cy as text
%        str2double(get(hObject,'String')) returns contents of ed_Cy as a double
ReadandSetValues(handles)



function ed_pSize_Callback(hObject, eventdata, handles)
% hObject    handle to ed_pSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_pSize as text
%        str2double(get(hObject,'String')) returns contents of ed_pSize as a double
ReadandSetValues(handles)



function ed_Xenergy_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Xenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Xenergy as text
%        str2double(get(hObject,'String')) returns contents of ed_Xenergy as a double
ReadandSetValues(handles)


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
saxs = getgihandle;
if isfield(saxs, 'norminfo')
    saxs.norminfo.xeng = get(hObject, 'value');
    saxs.norminfo.xengcol = str2double(get(handles.ed_EngCol,'string'));
    setgihandle(saxs);
else
    disp('norminfo is not created yet, see radiobutton12_callback function')
end
setgihandle(saxs)


function ed_EngCol_Callback(hObject, eventdata, handles)
% hObject    handle to ed_EngCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_EngCol as text
%        str2double(get(hObject,'String')) returns contents of ed_EngCol as a double
radiobutton12_Callback(handles.radiobutton12, [], handles)

% --- Executes during object creation, after setting all properties.
function ed_EngCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_EngCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
saxs = getgihandle;
if isfield(saxs, 'norminfo')
    saxs.norminfo.norm = get(hObject,'Value');
    saxs.norminfo.normcol = str2double(get(handles.ed_NormCol,'string'));
    setgihandle(saxs);
else
    disp('norminfo is not created yet, see radiobutton12_callback function')
end
setgihandle(saxs)



function ed_NormCol_Callback(hObject, eventdata, handles)
% hObject    handle to ed_NormCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_NormCol as text
%        str2double(get(hObject,'String')) returns contents of ed_NormCol as a double
radiobutton13_Callback(handles.radiobutton13, [], handles)

% --- Executes during object creation, after setting all properties.
function ed_NormCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_NormCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rbai_column.
function rbai_column_Callback(hObject, eventdata, handles)
% hObject    handle to rbai_column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbai_column
saxs = getgihandle;
if isfield(saxs, 'norminfo')
    saxs.norminfo.ai= get(hObject,'Value');
    saxs.norminfo.aicol = str2double(get(handles.ed_aiCol,'string'));
    setgihandle(saxs);
else
    disp('norminfo is not created yet, see rbai_column_Callback function')
end
setgihandle(saxs)


function ed_aiCol_Callback(hObject, eventdata, handles)
% hObject    handle to ed_aiCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_aiCol as text
%        str2double(get(hObject,'String')) returns contents of ed_aiCol as a double
rbai_column_Callback(handles.rbai_column, [], handles)

% --- Executes during object creation, after setting all properties.
function ed_aiCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_aiCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_Offset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Offset as text
%        str2double(get(hObject,'String')) returns contents of ed_Offset as a double
ReadandSetValues(handles)

% --- Executes during object creation, after setting all properties.
function ed_Offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_Edensity_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Edensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Edensity as text
%        str2double(get(hObject,'String')) returns contents of ed_Edensity as a double
ReadandSetValues(handles)

% --- Executes during object creation, after setting all properties.
function ed_Edensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Edensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_Beta_Callback(hObject, eventdata, handles)
% hObject    handle to ed_Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_Beta as text
%        str2double(get(hObject,'String')) returns contents of ed_Beta as a double
ReadandSetValues(handles)

% --- Executes during object creation, after setting all properties.
function ed_Beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function gisaxsleenew_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gisaxsleenew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
if isfield(saxs, 'ai')
    set(handles.ed_ai, 'string', saxs.ai);
    set(handles.ed_Xenergy, 'string', saxs.xeng);
end


% --- Executes on button press in pbloadEPICS.
function pbloadEPICS_Callback(hObject, eventdata, handles)
% hObject    handle to pbloadEPICS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ret, val] = system('hostname');
if strcmp(strtrim(val), 'purple.xor.aps.anl.gov');
   psize = str2num(strtrim(epics_get('12idb:saxs:det:pixelSize')));
   SDD = str2num(strtrim(epics_get('12idb:saxs:det:SDD')));
   offset = str2num(strtrim(epics_get('12idb:saxs:det:offset')));
   beamX = str2num(strtrim(epics_get('12idb:saxs:beamX')));
   beamY = str2num(strtrim(epics_get('12idb:saxs:beamY')));
   xeng = str2num(strtrim(epics_get('12ida1:DCM:EnRBV')));
   edensity = 0;
   saxs.center(1) = beamX;
   saxs.center(2) = beamY;
   saxs.psize = psize;
   saxs.SDD = SDD;
   saxs.offset = offset;
   saxs.edensity = edensity;
   saxs.xeng = xeng;
%   waveln = eng2wl(xeng);
%   set(handles.ed_Cx, num2str(beamX));
%   set(handles.ed_Cy, num2str(beamY));
%   set(handles.ed_Xenergy, num2str(xeng));
%   set(handles.ed_pSize, num2str(psize));
%   set(handles.ed_SDD, num2str(SDD));
%   set(handles.ed_Offset, num2str(offset));
%   set(handles.ed_Edensity, num2str(edensity));
else
   saxs = getgihandle;
end

setgihandle(saxs)
SetSAXSValues(handles)



function ed_tiltangle_Callback(hObject, eventdata, handles)
% hObject    handle to ed_tiltangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_tiltangle as text
%        str2double(get(hObject,'String')) returns contents of ed_tiltangle as a double
ReadandSetValues(handles)

% --- Executes during object creation, after setting all properties.
function ed_tiltangle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_tiltangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
saxs = getgihandle;
saxs.ScaleFactor = str2double(get(handles.ed_ScaleFactor, 'string'));
setgihandle(saxs);


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



function ed_I0Ref_Callback(hObject, eventdata, handles)
% hObject    handle to ed_I0Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_I0Ref as text
%        str2double(get(hObject,'String')) returns contents of ed_I0Ref as a double

saxs = getgihandle; 
saxs.ScaleI0 = str2double(get(handles.ed_I0Ref, 'string'));
setgihandle(saxs);


% --- Executes during object creation, after setting all properties.
function ed_I0Ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_I0Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CB_ApplyScale.
function CB_ApplyScale_Callback(hObject, eventdata, handles)
% hObject    handle to CB_ApplyScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_ApplyScale
saxs = getgihandle;
if get(hObject, 'value');
    saxs.qScaleFactor = 1;
else
    saxs.qScaleFactor = 0;
end
setgihandle(saxs);
ed_ScaleFactor_Callback(handles.ed_ScaleFactor);

% --- Executes on button press in CB_ScaleI0.
function CB_ScaleI0_Callback(hObject, eventdata, handles)
% hObject    handle to CB_ScaleI0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_ScaleI0
saxs = getgihandle;
file = saxs.specfile;
c = specSAXSn2(file);
%saxs = getgihandle;
%saxs.specfile = file;
set(handles.ed_ScaleField, 'string', c);
%setgihandle(saxs);

if get(hObject, 'value');
    saxs.qScaleI0 = 1;
else
    saxs.qScaleI0 = 0;
end
setgihandle(saxs);
ed_I0Ref_Callback(handles.ed_I0Ref);



function ed_ScaleField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ScaleField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CB_SetupAutoUpdate.
function CB_SetupAutoUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to CB_SetupAutoUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_SetupAutoUpdate
saxs = getgihandle;
saxs.isAutoSetupUpdate = get(hObject, 'value');
setgihandle(saxs);


% --- Executes when selected object is changed in uipanel_AxisType.
function uipanel_AxisType_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_AxisType 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
saxs.axistype = get(hObject, 'string');
setgihandle(saxs);


% --- Executes on button press in pb_OpenDrawingTool.
function pb_OpenDrawingTool_Callback(hObject, eventdata, handles)
% hObject    handle to pb_OpenDrawingTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GISAXSLee_drawingtool



function ed_BackScaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to ed_BackScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_BackScaleFactor as text
%        str2double(get(hObject,'String')) returns contents of ed_BackScaleFactor as a double
saxs = getgihandle;
saxs.BackScaleFactor = str2double(get(hObject, 'string'));
setgihandle(saxs);

% --- Executes during object creation, after setting all properties.
function ed_BackScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_BackScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CB_SubtractBackground.
function CB_SubtractBackground_Callback(hObject, eventdata, handles)
% hObject    handle to CB_SubtractBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_SubtractBackground
saxs = getgihandle;
if get(hObject, 'value');
    saxs.qBackSubtract = 1;
else
    saxs.qBackSubtract = 0;
end
setgihandle(saxs);
ed_BackScaleFactor_Callback(handles.ed_BackScaleFactor);


% --- Executes on button press in pb_GI2nonGI.
function pb_GI2nonGI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_GI2nonGI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GISAXSLee_convertGI2nonGI


% --- Executes on button press in pb_qCalibration2.
function pb_qCalibration2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_qCalibration2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qCalibration2



function ed_tthi_Callback(hObject, eventdata, handles)
% hObject    handle to ed_tthi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_tthi as text
%        str2double(get(hObject,'String')) returns contents of ed_tthi as a double
ReadandSetValues(handles)

% --- Executes during object creation, after setting all properties.
function ed_tthi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_tthi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ed_ScaleField.
function ed_ScaleField_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ScaleField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ed_ScaleField contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ed_ScaleField
saxs = getgihandle;
contents = cellstr(get(hObject,'String'));
FN = contents{get(hObject,'Value')};
if get(hObject, 'value');
    saxs.ScaleI0Fieldname = FN;
else
    saxs = rmfield(saxs, 'ScaleI0Fieldname');
end
setgihandle(saxs);


% --- Executes on button press in CB_exptimenormalize.
function CB_exptimenormalize_Callback(hObject, eventdata, handles)
% hObject    handle to CB_exptimenormalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_exptimenormalize
saxs = getgihandle;
if get(hObject, 'value');
    if ~isfield(saxs, 'specfile');
        error('Spec file is not specified, thus cannot determine time.');
    end
    saxs.qtime_normalize = 1;
else
    saxs.qtime_normalize = 0;
end
setgihandle(saxs);


% --- Executes on button press in rd_AxisStyle_qr.
function rd_AxisStyle_qr_Callback(hObject, eventdata, handles)
% hObject    handle to rd_AxisStyle_qr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_AxisStyle_qr
uipanel_AxisType_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes on button press in rd_AxisStyle_q.
function rd_AxisStyle_q_Callback(hObject, eventdata, handles)
% hObject    handle to rd_AxisStyle_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_AxisStyle_q
uipanel_AxisType_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes on button press in rd_AxisStyle_af.
function rd_AxisStyle_af_Callback(hObject, eventdata, handles)
% hObject    handle to rd_AxisStyle_af (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_AxisStyle_af
uipanel_AxisType_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes on button press in rd_AxisStyle_dX.
function rd_AxisStyle_dX_Callback(hObject, eventdata, handles)
% hObject    handle to rd_AxisStyle_dX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_AxisStyle_dX
uipanel_AxisType_SelectionChangeFcn(hObject, eventdata, handles)


% --- Executes on button press in cb_transmittance.
function cb_transmittance_Callback(hObject, eventdata, handles)
% hObject    handle to cb_transmittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_transmittance
saxs = getgihandle;
if get(hObject, 'value');
    saxs.qTrans4BSF = 1;
else
    saxs.qTrans4BSF = 0;
end
setgihandle(saxs);


% --- Executes on button press in cb_samplethickness.
function cb_samplethickness_Callback(hObject, eventdata, handles)
% hObject    handle to cb_samplethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_samplethickness
saxs = getgihandle;
if get(hObject, 'value');
    saxs.qSampleThickness = 1;
%    saxs.SampleThickness = str2double(get(handles.ed_samplethickness,'String'));
else
    saxs.qSampleThickness = 0;
end
setgihandle(saxs);
ed_samplethickness_Callback(handles.ed_samplethickness)


function ed_samplethickness_Callback(hObject, eventdata, handles)
% hObject    handle to ed_samplethickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_samplethickness as text
%        str2double(get(hObject,'String')) returns contents of ed_samplethickness as a double
saxs = getgihandle;
saxs.SampleThickness = str2double(get(hObject,'String'))*0.1;% convert mm to cm
setgihandle(saxs);


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


% --- Executes on button press in pb_agbhfindcent.
function pb_agbhfindcent_Callback(hObject, eventdata, handles)
% hObject    handle to pb_agbhfindcent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
agbh_findcenter


% --- Executes on button press in cb_airpathcorrection.
function cb_airpathcorrection_Callback(hObject, eventdata, handles)
% hObject    handle to cb_airpathcorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_airpathcorrection
saxs = getgihandle;
if get(hObject,'Value')
    ang = det_geometry(saxs);
    tthspace = reshape(ang(:,3), saxs.imgsize); 
    saxs.airpath = correctfactor_pathabsorption(tthspace, saxs.SDD);
else
    if isfield(saxs, 'airpath')
        saxs = rmfield(saxs, 'airpath');
    end
end
setgihandle(saxs);


% --- Executes on button press in cb_detSensorPathCorrection.
function cb_detSensorPathCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to cb_detSensorPathCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_detSensorPathCorrection
saxs = getgihandle;
if get(hObject,'Value')
    ang = det_geometry(saxs);
    tthspace = reshape(ang(:,3), saxs.imgsize); 
    saxs.detpath = correctfactor_detSensor(tthspace, saxs.xeng);
else
    if isfield(saxs, 'detpath')
        saxs = rmfield(saxs, 'detpath');
    end
end
setgihandle(saxs);


% --- Executes on button press in cb_polarizationCorrection.
function cb_polarizationCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to cb_polarizationCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_polarizationCorrection
saxs = getgihandle;
if get(hObject,'Value')
    ang = det_geometry(saxs);
    saxs.polarization = reshape(correctfactor_polarization(ang), saxs.imgsize);
else
    if isfield(saxs, 'polarization')
        saxs = rmfield(saxs, 'polarization');
    end
end
setgihandle(saxs);


% --- Executes on button press in pb_2dindexing.
function pb_2dindexing_Callback(hObject, eventdata, handles)
% hObject    handle to pb_2dindexing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
indexing2dpowder
