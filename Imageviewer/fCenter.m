function varargout = fcenter(varargin)
% fcenter Application M-file for fcenter.fig
%    FIG = fcenter launch fcenter GUI.
%    fcenter('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 06-Jul-2007 18:29:46

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
function varargout = txtX_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = txtY_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbCenter_Callback(h, eventdata, handles, varargin)
if isfield(handles, 'newLine')
    delete(handles.newLine)
end
l = str2double(get(handles.edit3, 'string'));
center = [str2double(get(handles.txtX, 'string')), str2double(get(handles.txtY, 'string'))];
handFigure = gcf;
T = double(get_imgFigure);
newLine = drawC(center, l);
handles.newLine(1) = newLine;
guidata(h, handles);

oneDline = figure;
handles.oneD = oneDline;
[a, ah] = lineplot3(T, center, 0, 1, [], handFigure);set(ah, 'Color', [1 0 0]);
[b, bh] = lineplot3(T, center, 90, 1, [], handFigure);set(bh, 'Color', [0 0 1]);
[c, ch] = lineplot3(T, center, 180, 1, [], handFigure);set(ch, 'Color', [0 0 0]);
[d, dh] = lineplot3(T, center, 270, 1, [], handFigure);set(dh, 'Color', [0 1 0]);
handles.newLine(2:5) = [ah bh ch dh];
figure(oneDline);
plot(a(:,1), a(:,2), 'r');hold on;plot(b(:,1), b(:,2),'b');plot(c(:,1), c(:,2),'k');plot(d(:,1), d(:,2),'g');
legend('mu = 0', 'mu = 90', 'mu = 180', 'mu = 270');
plot([l, l], [0, max(get(gca, 'YLim'))], '-r');
guidata(h, handles);

% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbLoad_Callback(h, eventdata, handles, varargin)


imghandle = figure(10);
image(double(R));axis image;colorbar;

handles.data = R;
%handles.imgh = imghandle;
guidata(h, handles);

a = get(imghandle, 'Children');
b = get(a(2));
lim = b.YLim;
set(handles.sldMin, 'Min', lim(1));
set(handles.sldMin, 'Max', lim(2));
set(handles.sldMin, 'Value', lim(1));
set(handles.sldMax, 'Min', lim(1));
set(handles.sldMax, 'Max', max(max(R)));
set(handles.sldMax, 'Value', lim(2));

set(handles.txtMin, 'String', num2str(lim(1)));set(handles.txtMax, 'String', num2str(lim(2)));
handles.newLine = [];
guidata(h, handles);




% --------------------------------------------------------------------
function varargout = sldMin_Callback(h, eventdata, handles, varargin)

handFigure = gcf;
R = double(get_imgFigure);
imagesc(R, [get(handles.sldMin, 'Value'), get(handles.sldMax, 'Value')]);axis image;colorbar;
set(handles.txtMin, 'string', num2str(get(handles.sldMin, 'Value')));

% --------------------------------------------------------------------
function varargout = sldMax_Callback(h, eventdata, handles, varargin)
handFigure = gcf;
R = double(get_imgFigure);
imagesc(R, [get(handles.sldMin, 'Value'), get(handles.sldMax, 'Value')]);axis image;colorbar;
set(handles.txtMax, 'string', num2str(get(handles.sldMax, 'Value')));




% --------------------------------------------------------------------
function varargout = rd_goldD_Callback(h, eventdata, handles, varargin)
hSAXSlee=findobj('Name','SAXSLee Matlab version');
f1 = findobj(hSAXSlee,  'Tag', 'figure1');
saxs = get(f1, 'userdata');
saxs = setfield(saxs, 'CCD', 'goldccd');
set(f1, 'userdata', saxs);


% --------------------------------------------------------------------
function varargout = rd_MarCCD_Callback(h, eventdata, handles, varargin)
hSAXSlee=findobj('Name','SAXSLee Matlab version');
f1 = findobj(hSAXSlee,  'Tag', 'figure1');
saxs = get(f1, 'userdata');
saxs = setfield(saxs, 'CCD', 'mar165');
set(f1, 'userdata', saxs);


% --------------------------------------------------------------------
function varargout = rd_PrinceCCD_Callback(h, eventdata, handles, varargin)
hSAXSlee=findobj('Name','SAXSLee Matlab version');
f1 = findobj(hSAXSlee,  'Tag', 'figure1');
saxs = get(f1, 'userdata');
saxs = setfield(saxs, 'CCD', 'princeton');
set(f1, 'userdata', saxs);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%a = get(gca, 'Children');
img = get(get(gca, 'Children'), 'CData')
if isempty(img)
    error('Image Figure should be on top!!!!!')
end
b = get(a(2));
lim = b.YLim;
set(handles.sldMin, 'Min', lim(1));
set(handles.sldMin, 'Max', lim(2));
set(handles.sldMin, 'Value', lim(1));
set(handles.sldMax, 'Min', lim(1));
set(handles.sldMax, 'Max', max(max(R)));
set(handles.sldMax, 'Value', lim(2));

set(handles.txtMin, 'String', num2str(lim(1)));set(handles.txtMax, 'String', num2str(lim(2)));
handles.newLine = [];
guidata(h, handles);