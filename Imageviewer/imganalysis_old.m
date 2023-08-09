function varargout = imganalysis_old(varargin)
% imganalysis_old Application M-file for imganalysis_old.fig
%    FIG = imganalysis_old launch imganalysis_old GUI.
%    imganalysis_old('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 06-May-2014 13:53:07

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
    
    % on command line, you can do like below..
    % imganalysis_old('pb_H_Callback', handleof_imganalysis)
    if (numel(varargin) < 2)
%        get(varargin{2})
        varargin{2} = imganalysis;
        varargin{4} = guihandles(varargin{2});  % 
        varargin{2} = [];
        varargin{3} = [];
    elseif (numel(varargin) == 3)
        varargin{4} = varargin{3};
        varargin{3} = varargin{2};
        varargin{2} = guihandles(imganalysis);  % 
        %varargin{2}
        %varargin{3}
    end
    
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
%| tags as fieldnames, e.g. handles.GIimganalysis, handles.slider2. This
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
function varargout = ls_filename_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = popup_filename_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_H_Callback(h, eventdata, handles, varargin)
determine_ai(handles)
handles = linecut_Callback(handles, 'h');

% --------------------------------------------------------------------
function varargout = pb_V_Callback(h, eventdata, handles, varargin)
determine_ai(handles)
handles = linecut_Callback(handles, 'v');

% --------------------------------------------------------------------
function varargout = pb_Arbline_Callback(h, eventdata, handles, varargin)
set(gcf, 'WindowButtonDownFcn',...
         'mypixval(''Arbline'')')

% --------------------------------------------------------------------
function varargout = edit4_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit5_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edit6_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_AzimScan_Callback(h, eventdata, handles, varargin)
%global X
%global Y

%currentFig = gcf;
%saxs = getgihandle;
currentAxes = evalin('base', 'SAXSimagehandle');
saxs = getgihandle;
azimX = str2num(char(cellstr(get(handles.ed_azimX, 'string'))));
azimY = str2num(char(cellstr(get(handles.ed_azimY, 'string'))));
azimD = str2num(char(cellstr(get(handles.ed_azimD, 'string'))));
t = double(saxs.image);
Ang = 0:0.1:359.9;
if isempty(azimX) % to put q into azimD, make azimX empty.
    P = q2pixel(azimD, saxs.waveln, saxs.center, saxs.psize, ...
        saxs.SDD, saxs.tiltangle);
    X = P(:,1); Y = P(:,2);
    Ang = 0:pi/100:2*pi;
else %when azimD is pixel,
    X = azimD*cos(deg2rad(Ang)) + azimX;
    Y = azimD*sin(deg2rad(Ang)) + azimY;
end    
Data = interp2(double(t), X, Y);
cut.X = X;   % pixel value in image
cut.Y = Y;                 % pixel vaule in image
cut.azim = Ang;
cut.Intensity = Data;
cut.q = azimD;
handles.Lineh = line(X, Y, 'parent', currentAxes);
set(handles.Lineh, 'color', 'w');
handles.currentFig = currentAxes;
guidata(h, handles);
assignin('base', 'cut', cut)
%handles = plotcut(handles, saxs, Data, X, Y, cut);
% 
% figure(currentFig);
% if isfield(handles, 'Lineh')
%     handles.Lineh = [handles.Lineh, line(X, Y)];
% else
%     handles.Lineh = line(X, Y);
% end
% handles.currentFig = currentFig;
% guidata(h, handles);
% 
% NewfigH = str2num(char(cellstr(get(handles.ed_newFig, 'string'))));
% oldlegend = [];
% if isempty(NewfigH)
%     NewfigH = 0;
%     figure
% end
% if (NewfigH ~= 0)
%     figure(NewfigH)
%     if get(handles.rb_holdon, 'value')
%         hold on
%         lineuserdata = get(findobj(NewfigH, 'tag', 'legend'), 'Userdata');
%         if isfield(lineuserdata, 'lstrings')
%             oldlegend = lineuserdata.lstrings;
%         end
%     else
%         hold off
%     end
% end
% 
% tt = plot(Ang, Data);
% 
% % set line property and userdata
% lineuser.X = X;   % pixel value in image
% lineuser.Y = Y;                 % pixel vaule in image
% lineuser.azimX = azimX;          % line cut position
% lineuser.azimY = azimY;              % line cut position
% lineuser.azimD = azimD;
% 
% set(tt, 'Tag', 'data');
% set(tt, 'userdata', lineuser);
% % ==========================================
% 
% if isempty(char(cellstr(get(handles.ed_legend, 'string'))))
%     tempstr = sprintf('AZim Cut of %s at x :%s, y : %s, r : %s', ImgUser.Fname, num2str(azimX), num2str(azimY), num2str(azimD));
%     legend([oldlegend, {tempstr}])
% else
%     legend([oldlegend, cellstr(get(handles.ed_legend, 'string'))]);
% end




% --------------------------------------------------------------------
function varargout = pb_ClearLine_Callback(h, eventdata, handles, varargin)
SAXSimagehandle = evalin('base', 'SAXSimagehandle');
delete(findobj(get(SAXSimagehandle, 'children'), 'type', 'line'));


% --------------------------------------------------------------------
function varargout = ed_Clim_min_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Clim_max_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_SetClim_Callback(h, eventdata, handles, varargin)
curFig = gcf;
%Clim = [str2num(handles.ed_Clim_min), str2num(handles.ed_Clim_max)];
Clim_min = str2num(char(cellstr(get(handles.ed_Clim_min, 'string'))));
Clim_max = str2num(char(cellstr(get(handles.ed_Clim_max, 'string'))));
Clim = [Clim_min, Clim_max];
if isempty(findobj(curFig, 'Type', 'image'))
    return
end
if ~strcmp(get(findobj(curFig, 'Type', 'image'), 'CdataMapping'), 'scaled')
    set(findobj(curFig, 'Type', 'image'), 'CdataMapping', 'scaled')
end
set(findobj(curFig, 'Type', 'axes'), 'Clim', Clim)



% --------------------------------------------------------------------
function varargout = pb_GetClim_Callback(h, eventdata, handles, varargin)
curFig = gcf;
if isempty(findobj(curFig, 'Type', 'image'))
    return
end
if ~strcmp(get(findobj(curFig, 'Type', 'image'), 'CdataMapping'), 'scaled')
    set(findobj(curFig, 'Type', 'image'), 'CdataMapping', 'scaled')
end
Clim = get(findobj(curFig, 'Type', 'axes'), 'Clim');
set(handles.ed_Clim_min, 'string', num2str(Clim(1)));
set(handles.ed_Clim_max, 'string', num2str(Clim(2)));


function varargout = ed_MathNum_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pb_ImgMath_Callback(h, eventdata, handles, varargin)
curFig = gcf;
%Clim = [str2num(handles.ed_Clim_min), str2num(handles.ed_Clim_max)];
MathNum = char(cellstr(get(handles.ed_MathNum, 'string')));
MathFig = char(cellstr(get(handles.ed_MathFig, 'string')));
if (str2num(MathNum) == 0) & (str2num(MathFig) == 0)
    return
end

if isempty(findobj(curFig, 'Type', 'image'))
    return
end
ImgUser = get(curFig, 'Userdata');
if ~isfield(ImgUser, 'Lindata')
    Cdata = get(findobj(curFig, 'Type', 'image'), 'Cdata');
    ImgUser.Lindata = Cdata;
    set(curFig, 'Userdata', ImgUser)
end

ImgUser = get(curFig, 'Userdata');

if ~strcmp(class(ImgUser.Lindata), 'double')
    ImgUser.Lindata = double(ImgUser.Lindata);
end

if str2num(MathNum) ~=0
    strcmd = ['ImgUser.Lindata = ImgUser.Lindata ', MathNum];
    eval(strcmd)
    set(curFig, 'Userdata', ImgUser)
elseif str2num(MathFig) ~= 0
    k = MathFig;
    strSignindex = find((k == '+')|(k == '-')|(k == '*')|(k == '/'));%
    k(strSignindex) = [];
    Cdata = get(findobj(str2num(k), 'Type', 'image'), 'Cdata');
    
    if ~strcmp(class(Cdata), 'double')
        Cdata = double(Cdata);
    end
    strcmd = ['ImgUser.Lindata = ImgUser.Lindata ', MathFig(strSignindex), ' Cdata'];
    eval(strcmd);
    set(curFig, 'Userdata', ImgUser);
end
    
if strcmp(get(h, 'String'), 'Linear')
    if strcmp(class(ImgUser.Lindata), 'double')
        set(findobj(curFig, 'Type', 'image'), 'Cdata', log(ImgUser.Lindata));
    else
        set(findobj(curFig, 'Type', 'image'), 'Cdata', log(double(ImgUser.Lindata)));
    end
else
    set(h, 'String', 'Log')
    set(findobj(curFig, 'Type', 'image'), 'Cdata', ImgUser.Lindata);
end

% --------------------------------------------------------------------
function varargout = ed_MathFig_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------


% --------------------------------------------------------------------
function varargout = ed_curX_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_curY_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_newFig_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_legend_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = rb_holdon_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Px_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Py_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Ax_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Az_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Qx_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_Qz_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ed_LCx_Callback(h, eventdata, handles, varargin)
disp('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF')



% --------------------------------------------------------------------
function varargout = ed_LCx_ButtonDownFcn(h, eventdata, handles, varargin)





% --------------------------------------------------------------------
function varargout = pb_coordDown_Callback(h, eventdata, handles, varargin)
%currentFig = gcf;

gisaxs = getgihandle;

xn = str2num(char(cellstr(get(handles.ed_LCx, 'string'))));
yn = str2num(char(cellstr(get(handles.ed_LCy, 'string'))));

[tthf, af, xp, yp] = giangle(xn, yn, gisaxs);

if ~isfield(gisaxs, 'ai')
    gisaxs.ai = 0;
end
if ~isfield(gisaxs, 'tthi')
    gisaxs.tthi = 0;
end
if ~isfield(gisaxs, 'waveln')
    gisaxs.waveln = 1;
end

ai = gisaxs.ai;
tthi = gisaxs.tthi;
%lambda = gisaxs.waveln;

[qx, qy, qxy, q1z, q2z, q3z, q4z, q1, q2, q3, q4] = giangle2q(tthf, af, tthi, ai, gisaxs);

set(handles.ed_Px, 'string', sprintf('%0.1f',xp));
set(handles.ed_Py, 'string', sprintf('%0.1f',yp));
set(handles.ed_Ax, 'string', sprintf('%0.3f',tthf));
set(handles.ed_Az, 'string', sprintf('%0.3f',af));
set(handles.ed_Qx, 'string', sprintf('%0.5f',qxy));
set(handles.ed_Qz, 'string', sprintf('%0.5f',q1z));

set(handles.ed_qqx, 'string', sprintf('%0.5f',qx));
set(handles.ed_qqy, 'string', sprintf('%0.5f',qy));
set(handles.ed_qxy, 'string', sprintf('%0.5f',q1));
set(handles.ed_q1z, 'string', sprintf('%0.5f', real(q1z)));
set(handles.ed_q2z, 'string', sprintf('%0.5f', real(q3z)));

% --------------------------------------------------------------------
function varargout = pb_coordUp_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
Px = str2num(char(cellstr(get(handles.ed_Px, 'string'))));
Py = str2num(char(cellstr(get(handles.ed_Py, 'string'))));
DAng = str2num(char(cellstr(get(handles.ed_DAng, 'string'))));
ImgUser = get(currentFig, 'Userdata');
xc = ImgUser.center(1);
yc = ImgUser.center(2);
Cen = [xc;yc];
th = deg2rad(DAng); 
P = [Px;-Py];
R = [cos(th), -sin(th);sin(th), cos(th)];
P = R*P;
P = P+Cen;
set(handles.ed_LCx, 'string', fix(P(1)*1000)/1000);
set(handles.ed_LCy, 'string', fix(P(2)*1000)/1000);


% --------------------------------------------------------------------
function varargout = ed_Ax_ButtonDownFcn(h, eventdata, handles, varargin)
ImgUser = get(currentFig, 'Userdata');
Ax = str2num(char(cellstr(get(handles.ed_Ax, 'string'))));
set(handles.ed_Px, 'string', Ax/ImgUser.AperP);


% --------------------------------------------------------------------
function varargout = ed_Az_ButtonDownFcn(h, eventdata, handles, varargin)
ImgUser = get(currentFig, 'Userdata');
Az = str2num(char(cellstr(get(handles.ed_Az, 'string'))));
set(handles.ed_Py, 'string', (Az+ImgUser.ai)/ImgUser.AperP);

% --------------------------------------------------------------------
function varargout = ed_Qx_ButtonDownFcn(h, eventdata, handles, varargin)
ImgUser = get(currentFig, 'Userdata');
Qx = str2num(char(cellstr(get(handles.ed_Ax, 'string'))));
set(handles.ed_Px, 'string', Qx/ImgUser.QperP);


% --------------------------------------------------------------------
function varargout = ed_Qz_ButtonDownFcn(h, eventdata, handles, varargin)
ImgUser = get(currentFig, 'Userdata');
Qz = str2num(char(cellstr(get(handles.ed_Az, 'string'))));
set(handles.ed_Py, 'string', (Qz)/ImgUser.QperP);




% --------------------------------------------------------------------
function varargout = pb_coordDown_ButtonDownFcn(h, eventdata, handles, varargin)




% --------------------------------------------------------------------





% --------------------------------------------------------------------
function varargout = pb_Q2P_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
Qx = str2num(char(cellstr(get(handles.ed_Qx, 'string'))));
Qz = str2num(char(cellstr(get(handles.ed_Qz, 'string'))));
ImgUser = get(currentFig, 'Userdata');

Px = Qx/ImgUser.QperP;  % q parallel component
Py = Qz/ImgUser.QperP;    % q perpendicular component
set(handles.ed_Px, 'string', fix(Px*1000)/1000);
set(handles.ed_Py, 'string', fix(Py*1000)/1000);



% --------------------------------------------------------------------
function varargout = pb_A2P_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
Ax = str2num(char(cellstr(get(handles.ed_Ax, 'string'))));
Az = str2num(char(cellstr(get(handles.ed_Az, 'string'))));
ImgUser = get(currentFig, 'Userdata');

Px = Ax/ImgUser.AperP;  % q parallel component
Py = (Az+ImgUser.ai)/ImgUser.AperP;    % q perpendicular component
set(handles.ed_Px, 'string', fix(Px*1000)/1000);
set(handles.ed_Py, 'string', fix(Py*1000)/1000);


% --- Executes on button press in rbIP.
function rbIP_Callback(hObject, eventdata, handles)
if get(hObject, 'value') == 1
    set(handles.rbIA, 'value', 0);
    set(handles.rbIQ, 'value', 0);
    set(handles.rbIQ1, 'value', 0);
    set(handles.rbIQ2, 'value', 0);
    
    [x, y, z] = getlinefig(gcf);
    if isempty(z)
        return
    end

    [xnum, ynum] = size(x);
    lenQP = length(z.qp);
    if lenQP > 1 
        for i=1:ynum
            tt = plot(z.X-z.LCx, y(:,i));
        end
    else
        for i=1:ynum
            tt = plot(z.Y-z.LCy, y(:,i));
        end
    end
    z.xaxisname = 'p';
    set(tt, 'Tag', 'data');
    set(tt, 'userdata', z);
end
        
% hObject    handle to rbIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbIP


% --- Executes on button press in rbIA.
function rbIA_Callback(hObject, eventdata, handles)
if get(hObject, 'value') == 1
    set(handles.rbIP, 'value', 0);
    set(handles.rbIQ, 'value', 0);
    set(handles.rbIQ1, 'value', 0);
    set(handles.rbIQ2, 'value', 0);
    
    [x, y, z] = getlinefig(gcf);
    if isempty(z)
        return
    end

    [xnum, ynum] = size(x);
    lenQP = length(z.qxy);
    if lenQP > 1 
        for i=1:ynum
            tt = plot(z.tthf, y(:,i));
        end
    else
        for i=1:ynum
            tt = plot(z.af, y(:,i));
        end
    end
    z.xaxisname = 'a';    
    set(tt, 'Tag', 'data');
    set(tt, 'userdata', z);
end

% hObject    handle to rbIA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbIA


% --- Executes on button press in rbIQ.
function rbIQ_Callback(hObject, eventdata, handles)
if get(hObject, 'value') == 1
    set(handles.rbIP, 'value', 0);
    set(handles.rbIA, 'value', 0);
    set(handles.rbIQ1, 'value', 0);
    set(handles.rbIQ2, 'value', 0);
    
    [x, y, z] = getlinefig(gcf);
    if isempty(z)
        return
    end
    [xnum, ynum] = size(x);
    lenQP = length(zqxy);
    if lenQP > 1 
        for i=1:ynum
            tt = plot(zqxy, y(:,i));
        end
    else
        for i=1:ynum
            tt = plot(z.qz, y(:,i));
        end
    end
    z.xaxisname = 'q';    
    set(tt, 'Tag', 'data');
    set(tt, 'userdata', z);
end
% hObject    handle to rbIQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbIQ





% --------------------------------------------------------------------
function varargout = pbImgAxis_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
%ImgUser = get(currentFig, 'Userdata');
ImgUser = getgihandle;

if isempty(ImgUser)
    disp('Wrong Figure Selection or Put the center value')
    return
end

%tx = get(findobj(gcf, 'Type', 'axes'), 'XTick');
%ty = get(findobj(gcf, 'Type', 'axes'), 'YTick');
xlim = get(findobj(gcf, 'Type', 'axes'), 'XLim');
ylim = get(findobj(gcf, 'Type', 'axes'), 'YLim');
img = get(findobj(gcf, 'type', 'image'), 'cdata');
pnt = ImgUser.center;
[R, xn, yn, cuth] = linecut(img, pnt, 0, 'h', ImgUser);
[R, xn, yn, cutv] = linecut(img, pnt, 0, 'v', ImgUser);

if get(handles.rbIP, 'Value') == 1
    X = cuth.Xpixel;
    Y = cutv.Ypixel;
elseif get(handles.rbIA, 'Value') == 1
    X = cuth.tthf;
    Y = cutv.af;
elseif get(handles.rbIQ, 'Value') == 1
    X = cuth.qxy;
    Y = cutv.qxy;
elseif get(handles.rbIQ1, 'Value') == 1
    X = cuth.qxy;
    Y = cutv.q1z;
elseif get(handles.rbIQ2, 'Value') == 1
    X = cuth.qxy;
    Y = cutv.q2z;
end

%imagesc(X, Y, img);
ImgUser.imgxaxis = X;
ImgUser.imgyaxis = Y;
setgihandle(ImgUser)
gishow(img, ImgUser);
% ===========================



function varargout = obsolete_pbImgAxis_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
%ImgUser = get(currentFig, 'Userdata');
ImgUser = getgihandle;

if isempty(ImgUser)
    disp('Wrong Figure Selection or Put the center value')
    return
end

%tx = get(findobj(gcf, 'Type', 'axes'), 'XTick');
%ty = get(findobj(gcf, 'Type', 'axes'), 'YTick');
xlim = get(findobj(gcf, 'Type', 'axes'), 'XLim');
ylim = get(findobj(gcf, 'Type', 'axes'), 'YLim');
img = get(findobj(gcf, 'type', 'image'), 'cdata');
[tx, ty] = size(img);
tx = [1, tx];
ty = [1, ty];
%x = x-ImgUser.center(1);
%y = y-ImgUser.center(2);
%temp = abs(tx - ImgUser.center(1))
%tempy = abs(ty - ImgUser.center(2))
%shiftx = -tx(find(temp == min(temp))) + ImgUser.center(1)
%shifty = -ty(find(tempy == min(tempy))) + ImgUser.center(2)
%tickx = tx + shiftx;
%ticky = ty + shifty;
%set(findobj(gcf, 'Type', 'axes'), 'XTick', tx);
%set(findobj(gcf, 'Type', 'axes'), 'YTick', ty);
%tx = tx - shiftx;
%ty = ty - shifty;
[R, xn, yn, cut] = linecut(img, pnt, tiltang, mode, gisaxs);
% ================== selection of x axis.
if get(handles.rbIP, 'Value') == 1
%    xlim = (xlim - ImgUser.center(1));
%    ylim = (ylim - ImgUser.center(2));
    tx = tx - ImgUser.center(1);
    ty = ty - ImgUser.center(2);
    
    xTickAng = TickScaleCal(xlim, tx, 6); % make 6 ticks
    xTickRec = fix(xTickAng + ImgUser.center(1));
    yTickAng = TickScaleCal(ylim, ty, 6); % make 6 ticks
    yTickRec = fix(yTickAng + ImgUser.center(2));
    
    set(findobj(gcf, 'Type', 'axes'), 'XTick', xTickRec);
    set(findobj(gcf, 'Type', 'axes'), 'YTick', yTickRec);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', xTickAng);

    s = cell(size(xTickAng));
    for i=1:length(xTickAng)
        [t,errmsg] = sprintf('%5.1f ',xTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', s);
    
    s = cell(size(yTickAng));
    for i=1:length(yTickAng)
        t = sprintf('%5.1f ',-yTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', s);

%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', tx);
%    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', -ty);
elseif get(handles.rbIA, 'Value') == 1
    xlim = (xlim - ImgUser.center(1))*ImgUser.AperP;
    ylim = (ylim - ImgUser.center(2))*(ImgUser.AperP)+ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);
    tx = (tx - ImgUser.center(1))*(ImgUser.AperP);%ylim(2) = 0;ylim=abs(ylim);;
    ty = (ty - ImgUser.center(2))*(ImgUser.AperP)+ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);;

    xTickAng = TickScaleCal(xlim, tx, 6); % make 6 ticks
    xTickRec = fix(xTickAng/ImgUser.AperP + ImgUser.center(1));
    yTickAng = TickScaleCal(ylim, ty, 6); % make 6 ticks
    yTickRec = fix((yTickAng - ImgUser.ai)/ImgUser.AperP + ImgUser.center(2));
    
    set(findobj(gcf, 'Type', 'axes'), 'XTick', xTickRec);
    set(findobj(gcf, 'Type', 'axes'), 'YTick', yTickRec);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', xTickAng);

    s = cell(size(xTickAng));
    for i=1:length(xTickAng)
        [t,errmsg] = sprintf('%5.2f ',xTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', s);
    
    s = cell(size(yTickAng));
    for i=1:length(yTickAng)
        t = sprintf('%5.2f ',-yTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', s);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', fix(tx*ImgUser.AperP*100)/100);
%    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', fix(-(ty*ImgUser.AperP - ImgUser.ai)*100)/100);
elseif get(handles.rbIQ, 'Value') == 1
    xlim = (xlim - ImgUser.center(1))*ImgUserqxyerP;
    ylim = (ylim - ImgUser.center(2))*(ImgUserqxyerP);
    tx = (tx - ImgUser.center(1))*ImgUserqxyerP;
    ty = (ty - ImgUser.center(2))*ImgUserqxyerP;

    xTickAng = TickScaleCal(xlim, tx, 6); % make 6 ticks
    xTickRec = fix(xTickAng/ImgUserqxyerP + ImgUser.center(1));
    yTickAng = TickScaleCal(ylim, ty, 6); % make 6 ticks
    yTickRec = fix(yTickAng/ImgUserqxyerP + ImgUser.center(2));
    
    set(findobj(gcf, 'Type', 'axes'), 'XTick', xTickRec);
    set(findobj(gcf, 'Type', 'axes'), 'YTick', yTickRec);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', xTickAng);
    s = cell(size(xTickAng));
    for i=1:length(xTickAng)
        [t,errmsg] = sprintf('%5.3f ',xTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', s);
    
    s = cell(size(yTickAng));
    for i=1:length(yTickAng)
        [t,errmsg] = sprintf('%5.3f ',-yTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', s);

%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', fix(tx*ImgUserqxyerP*1000)/1000);
%    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', fix(-ty*ImgUserqxyerP*1000)/1000);
elseif get(handles.rbIQ1, 'Value') == 1
    %xlim = xlim(1):xlim(2);
    ylim = ylim(1):ylim(2);
    %tx = tx(1):tx(2);
    ty = ty(1):ty(2);
    
    xlim = (xlim - ImgUser.center(1))*ImgUserqxyerP;
    ylimaf = -(ylim - ImgUser.center(2))*(ImgUser.AperP) - ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);
    tx = (tx - ImgUser.center(1))*ImgUserqxyerP;
    tyOri = ty-ImgUser.center(2);
    tyaf = -(ty - ImgUser.center(2))*(ImgUser.AperP) - ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);;

    Waveln = ImgUser.Waveln;
    Eden = str2num(get(handles.ed_nR, 'string'));
    Beta = str2num(get(handles.ed_nI, 'string'));
    [ylim, q2z] = af2qz(ylimaf, ImgUser.ai, Eden, Beta, Waveln);ylim = real(ylim);
    [ty, q2z] = af2qz(tyaf, ImgUser.ai, Eden, Beta, Waveln);ty = real(ty);

    xTickAng = TickScaleCal(xlim, tx, 6); % make 6 ticks
    xTickRec = fix(xTickAng/ImgUserqxyerP + ImgUser.center(1));

    yTickAng = TickScaleCal2(ylim, ty, 6); % make 6 ticks
    k = find(ty == 0);ty(k) = [];tyOri(k) = [];tyOri = tyOri + ImgUser.center(2);
    
%    figure;plot(ty, tyOri

    Pixy = spline(ty, tyOri, yTickAng);
    yTickRec = fix(Pixy);
    
    if yTickRec(2) < yTickRec(1)
        yTickRec = fliplr(yTickRec);
        yTickAng = fliplr(yTickAng);
    end
        
    set(findobj(gcf, 'Type', 'axes'), 'XTick', xTickRec);
    set(findobj(gcf, 'Type', 'axes'), 'YTick', yTickRec);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', xTickAng);
    s = cell(size(xTickAng));
    for i=1:length(xTickAng)
        [t,errmsg] = sprintf('%5.3f ',xTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', s);
    
    s = cell(size(yTickAng));
    for i=1:length(yTickAng)
        [t,errmsg] = sprintf('%5.3f ', yTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', s);

%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', fix(tx*ImgUserqxyerP*1000)/1000);
%    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', fix(-ty*ImgUserqxyerP*1000)/1000);
elseif get(handles.rbIQ2, 'Value') == 1
    %xlim = xlim(1):xlim(2);
    ylim = ylim(1):ylim(2);
    %tx = tx(1):tx(2);
    ty = ty(1):ty(2);
    
    xlim = (xlim - ImgUser.center(1))*ImgUserqxyerP;
    ylimaf = -(ylim - ImgUser.center(2))*(ImgUser.AperP) - ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);
    tx = (tx - ImgUser.center(1))*ImgUserqxyerP;
    tyOri = ty-ImgUser.center(2);
    tyaf = -(ty - ImgUser.center(2))*(ImgUser.AperP) - ImgUser.ai;%ylim(2) = 0;ylim=abs(ylim);;

    Waveln = ImgUser.Waveln;
    Eden = str2num(get(handles.ed_nR, 'string'));
    Beta = str2num(get(handles.ed_nI, 'string'));
    [q1z, ylim] = af2qz(ylimaf, ImgUser.ai, Eden, Beta, Waveln);ylim = real(ylim);
    [q1z, ty] = af2qz(tyaf, ImgUser.ai, Eden, Beta, Waveln);ty = real(ty);

    xTickAng = TickScaleCal(xlim, tx, 6); % make 6 ticks
    xTickRec = fix(xTickAng/ImgUserqxyerP + ImgUser.center(1));

    yTickAng = TickScaleCal2(ylim, ty, 6); % make 6 ticks
    k = find(ty == 0);ty(k) = [];tyOri(k) = [];tyOri = tyOri + ImgUser.center(2);
    
%    figure;plot(ty, tyOri

    Pixy = spline(ty, tyOri, yTickAng);
    yTickRec = fix(Pixy);
    
    if yTickRec(2) < yTickRec(1)
        yTickRec = fliplr(yTickRec);
        yTickAng = fliplr(yTickAng);
    end
        
    set(findobj(gcf, 'Type', 'axes'), 'XTick', xTickRec);
    set(findobj(gcf, 'Type', 'axes'), 'YTick', yTickRec);
%    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', xTickAng);
    s = cell(size(xTickAng));
    for i=1:length(xTickAng)
        [t,errmsg] = sprintf('%5.3f ',xTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'XTickLabel', s);
    
    s = cell(size(yTickAng));
    for i=1:length(yTickAng)
        [t,errmsg] = sprintf('%5.3f ', yTickAng(i));
        s{i} = t;
    end
    set(findobj(gcf, 'Type', 'axes'), 'YTickLabel', s);
end
% ===========================

set(findobj(gcf, 'Type', 'axes'), 'FontName', 'Times New Roman');
set(findobj(gcf, 'Type', 'axes'), 'FontSize', 16);
set(findobj(gcf, 'Type', 'axes'), 'Tickdir', 'out');
set(findobj(gcf, 'Type', 'axes'), 'xcolor', [0 0 0]);
set(findobj(gcf, 'Type', 'axes'), 'ycolor', [0 0 0]);



function [TickP, stP, stepP] = TickScaleCal(limOri, MaxLim, numberTick)
% making Tick!!!!!!!!!
% May 27, 2004.

if limOri(2) < limOri(1)
    lim = [limOri(2), limOri(1)];
else
    lim = limOri;
end

step = (lim(2) - lim(1))/numberTick;

% ============================ Step selection
% ============================= which is like...25 or 0.0015
if step > 1
    stepP = 0;i=-1;
    while stepP ~= 1
        i=i+1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step/5)*5, ceil(step/5-1)*5];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
    if stepP == 0
        stepP = 1;
    end
else
    stepP = 1;i=1;
    while stepP == 1
        i=i-1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step*10^(-i)/5)*5*10^i, ceil((step*10^(-i))/5-1)*5*10^i];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
end
% =================================================================

% ============================= closest starting point selection
t = [1, 2];j=0;
while t(1) ~= t(2)
    t = [floor((fix(lim(1)*10^(1-i))+j)/5), ceil((fix(lim(1)*10^(1-i))+j)/5)];
    j=j+1;
end    
stP = t(1)*5*10^(i-1);
% ===============================================================

% ================================================  Tick generation
% ================================================= always Reference point is 0
if stepP > 0
    TickP = 0:-stepP:MaxLim(1);
    TickP = [fliplr(TickP), stepP:stepP:MaxLim(2)];
else
    TickP = 0:stepP:MaxLim(1);
    TickP = [fliplr(TickP), stepP:-stepP:MaxLim(2)];
end    
%if limOri(2) < limOri(1)
%    TickP = stP:stepP:lim(2);
%    TickP = fliplr(TickP);
%else
%    TickP = stP:stepP:max(lim);
%end


function [TickP, stP, stepP] = TickScaleCal2(limOri, MaxLim, numberTick)
% making Tick!!!!!!!!!
% May 27, 2004.
zeroq = find(limOri == 0);
zeroqmx = find(MaxLim == 0);
lim = limOri;
lim(zeroq) = [];MaxLim(zeroqmx) = [];
if lim(1) > lim(end);
    lim = fliplr(lim);
end
if MaxLim(1) > MaxLim(end)
    MaxLim = fliplr(MaxLim);
end

minindex = find(lim == min(lim));

if minindex <= length(lim)*0.6
    [step, t] = polyfit(minindex:length(lim), lim(minindex:end), 1);
    step = step(1)*length(lim)/numberTick;
else 
    [step, t] = polyfit(1:minindex, lim(1:minindex), 1);
    step = step(1)*length(lim)/numberTick;
end
if step < 0
    step = -step;
end
% ============================ Step selection
% ============================= which is like...25 or 0.0015
if step > 1
    stepP = 0;i=-1;
    while stepP ~= 1
        i=i+1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step/5)*5, ceil(step/5-1)*5];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
    if stepP == 0
        stepP = 1;
    end
else
    stepP = 1;i=1;
    while stepP == 1
        i=i-1;
        stepP = ceil(step*10^(-i)/5);
    end
    y = [ceil(step*10^(-i)/5)*5*10^i, ceil((step*10^(-i))/5-1)*5*10^i];
    k = find(abs(y-step) == min(abs(y-step)));
    stepP = y(k);
end
% =================================================================

% ============================= closest starting point selection
t = [1, 2];j=0;
while t(1) ~= t(2)
    t = [floor((fix(lim(1)*10^(1-i))+j)/5), ceil((fix(lim(1)*10^(1-i))+j)/5)];
    j=j+1;
end    
stP = t(1)*5*10^(i-1);
% ===============================================================

% ================================================  Tick generation
% ================================================= always Reference point is 0
if stepP > 0
    TickP = 0:-stepP:MaxLim(1);
    %TickP = [fliplr(TickP), (min(lim) + stepP):stepP:MaxLim(end)];
    TickP = [fliplr(TickP), (0 + stepP):stepP:MaxLim(end)];
else
    TickP = 0:stepP:MaxLim(1);
    TickP = [fliplr(TickP), (0 - stepP):-stepP:MaxLim(end)];
end    


% --------------------------------------------------------------------
function varargout = pbImgAxisauto_Callback(h, eventdata, handles, varargin)
currentFig = gcf;
set(findobj(gcf, 'Type', 'axes'), 'XTickLabelMode', 'auto');
set(findobj(gcf, 'Type', 'axes'), 'YTickLabelMode', 'auto');
set(findobj(gcf, 'Type', 'axes'), 'XTickMode', 'auto');
set(findobj(gcf, 'Type', 'axes'), 'YTickMode', 'auto');
set(findobj(gcf, 'Type', 'axes'), 'FontName', 'Helvetica');
set(findobj(gcf, 'Type', 'axes'), 'FontSize', 10);



% --------------------------------------------------------------------
function varargout = pbGrid_Callback(h, eventdata, handles, varargin)
if strcmp(get(findobj(gcf, 'type', 'axes'),'xgrid'), 'on')
    set(findobj(gcf, 'Type', 'axes'), 'xgrid', 'off');
    set(findobj(gcf, 'Type', 'axes'), 'ygrid', 'off');
else
    set(findobj(gcf, 'Type', 'axes'), 'xgrid', 'on');
    set(findobj(gcf, 'Type', 'axes'), 'ygrid', 'on');
end    


% --------------------------------------------------------------------
function rbIQ1_Callback(hObject, eventdata, handles)

if get(hObject, 'value') == 1
    set(handles.rbIP, 'value', 0);
    set(handles.rbIA, 'value', 0);
    set(handles.rbIQ, 'value', 0);
    set(handles.rbIQ2, 'value', 0);
    
    [x, y, z] = getlinefig(gcf);
    if isempty(z)
        return
    end
    [xnum, ynum] = size(x);
    [q1z, q2z] = af2qz(z.af, z.ai, z.Eden, z.Beta, z.Waveln);
    q1z = real(q1z);
    lenQP = length(q1z);
    if lenQP > 1 
        for i=1:ynum
            tt = plot(q1z, y(:,i));
        end
    else
        for i=1:ynum
            tt = plot(q1z, y(:,i));
        end
    end
    z.xaxisname = 'q1z';    
    set(tt, 'Tag', 'data');
    set(tt, 'userdata', z);
end



% --------------------------------------------------------------------
function rbIQ2_Callback(hObject, eventdata, handles)

if get(hObject, 'value') == 1
    set(handles.rbIP, 'value', 0);
    set(handles.rbIA, 'value', 0);
    set(handles.rbIQ1, 'value', 0);
    set(handles.rbIQ, 'value', 0);
    
    [x, y, z] = getlinefig(gcf);
    if isempty(z)
        return
    end
    [xnum, ynum] = size(x);
    [q1z, q2z] = af2qz(z.af, z.ai, z.Eden, z.Beta, z.Waveln);
    q2z = real(q2z);
    lenQP = length(q2z);
    if lenQP > 1 
        for i=1:ynum
            tt = plot(q2z, y(:,i));
        end
    else
        for i=1:ynum
            tt = plot(q2z, y(:,i));
        end
    end
    z.xaxisname = 'q2z';    
    set(tt, 'Tag', 'data');
    set(tt, 'userdata', z);
end



% --------------------------------------------------------------------
function varargout = pushbutton19_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = pbAzimCent_Callback(h, eventdata, handles, varargin)
set(handles.ed_azimX, 'string', get(handles.ed_LCx, 'string'))
set(handles.ed_azimY, 'string', get(handles.ed_LCy, 'string'))


% --------------------------------------------------------------------
function varargout = pbAzimDist_Callback(h, eventdata, handles, varargin)

x1 = str2num(get(handles.ed_azimX, 'string'));
y1 = str2num(get(handles.ed_azimY, 'string'));
x = str2num(get(handles.ed_LCx, 'string'));
y = str2num(get(handles.ed_LCy, 'string'));
dist = sqrt((x1-x)^2 + (y1-y)^2);
set(handles.ed_azimD, 'string', sprintf('%5.1f', dist))


% --------------------------------------------------------------------
function varargout = pbCentering_Callback(h, eventdata, handles, varargin)
ImgUser = get(gcf, 'userdata');
set(handles.ed_azimX, 'string', sprintf('%5.1f', ImgUser.center(1)))
set(handles.ed_azimY, 'string', sprintf('%5.1f', ImgUser.center(2)))




% --------------------------------------------------------------------
function varargout = pbRefCentering_Callback(h, eventdata, handles, varargin)
ImgUser = get(gcf, 'userdata');
Ref = ImgUser.ai/ImgUser.AperP*2;
TiltAng = str2num(get(handles.ed_DAng, 'string'));
x = ImgUser.center(1) + Ref*sin(deg2rad(TiltAng));
y = ImgUser.center(2) - Ref*cos(deg2rad(TiltAng));
set(handles.ed_azimX, 'string', sprintf('%5.1f', x))
set(handles.ed_azimY, 'string', sprintf('%5.1f', y))




% --------------------------------------------------------------------
function varargout = pbDrawC_Callback(h, eventdata, handles, varargin)
%currentFig = gcf;
currentFig = evalin('base', 'SAXSimagehandle');
saxs = getgihandle;

azimX = str2num(get(handles.ed_azimX, 'string'));
azimY = str2num(get(handles.ed_azimY, 'string'));
azimD = str2num(get(handles.ed_azimD, 'string'));
Ang = 0:0.1:359.9;
X = azimD*cos(deg2rad(Ang)) + azimX;
Y = azimD*sin(deg2rad(Ang)) + azimY;
% ImgUser = get(currentFig, 'Userdata');
% 
% if isempty(ImgUser)
%     disp('Wrong Figure Selection or Put the center value')
%     return
% end
% 
% figure(currentFig);
if isfield(handles, 'Lineh')
    handles.Lineh = [handles.Lineh, line(X, Y)];
else
    handles.Lineh = line(X, Y);
end
handles.currentFig = currentFig;
guidata(h, handles);


% --------------------------------------------------------------------
function varargout = pbDrawTool_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------

function handles = linecut_Callback(handles, whichcut, img)
saxs = getgihandle;
%currentFig = gcf;
LCx = str2double(char(cellstr(get(handles.ed_LCx, 'string'))));
LCy = str2double(char(cellstr(get(handles.ed_LCy, 'string'))));
DAng = str2double(char(cellstr(get(handles.ed_DAng, 'string'))));

DAng = DAng + saxs.tiltangle;

if isfield(handles, 'ed_BandWidth')
    cutbandwidth = str2double(char(cellstr(get(handles.ed_BandWidth, 'string'))));
else
    handles.ed_BandWidth = 1;
    cutbandwidth = 1;
end
if ~mod(cutbandwidth, 2)
    cutbandwidth = cutbandwidth + 1;
    set(handles.ed_BandWidth, 'string', num2str(cutbandwidth));
end

if nargin < 3
    img = double(saxs.image);
end
%img = double(get(findobj('Type', 'image'), 'Cdata'));
pnt = [LCx, LCy];
%cutbandwidth = 3; %should be odd number

[R, X, Y, cut] = linecut(img, pnt, DAng, lower(whichcut), saxs);
numavg = 1;
if cutbandwidth > 1
bwindx = -(cutbandwidth-1)/2:(cutbandwidth-1)/2;
  for k=1:numel(bwindx)
    if bwindx(k)~=0
        switch lower(whichcut)
            case 'h'
                XX = cut.X;
                YY = cut.Y+k;
%                c = linecut(img, [cut.X, cut.Y+k]);
            case 'v'
                XX = cut.X+k;
                YY = cut.Y;
%                c = linecut(img, [cut.X+k, cut.Y]);
            otherwise
        end
        c = linecut(img, [XX, YY]);
        numavg = numavg + 1;
        if k==1
            cut.bw1X = XX;
            cut.bw1Y = YY;
        end
        if k==bwindx(end)
            cut.bw2X = XX;
            cut.bw2Y = YY;
        end
    end
    R = R+c;
  end
R = R/numavg;
end

if get(handles.rbIP, 'Value') == 1
    switch lower(whichcut)
        case 'h'
%            X = X;
            X = cut.Xpixel;
        case 'v'
            X = cut.Ypixel;
        otherwise 
            disp('Unknown cut')
    end
    cut.xaxisname = 'p';
elseif get(handles.rbIA, 'Value') == 1
    switch lower(whichcut)
        case 'h'
            X = cut.tthf;
        case 'v'
            X = cut.af;
        otherwise 
            disp('Unknown cut')
    end
    cut.xaxisname = 'a';    
elseif get(handles.rbIQ, 'Value') == 1
    switch lower(whichcut)
        case 'h'
            X = sqrt(cut.qxy.^2+cut.q1z.^2);
        case 'v'
            X = sqrt(cut.qxy.^2+cut.q1z.^2);
        otherwise 
            disp('Unknown cut')
    end
    cut.xaxisname = 'q';    
elseif get(handles.rbIQ1, 'Value') == 1
    switch lower(whichcut)
        case 'h'
            X = cut.qxy;
        case 'v'
            X = cut.q1z;
        otherwise 
            disp('Unknown cut')
    end
    cut.xaxisname = 'q';    
elseif get(handles.rbIQ2, 'Value') == 1
    switch lower(whichcut)
        case 'h'
            X = cut.qxy;
        case 'v'
            X = cut.q2z;
        otherwise 
            disp('Unknown cut')
    end
    cut.xaxisname = 'q';    
end
cut.imgname = saxs.imgname;
cut.ai = saxs.ai;
cut.Intensity = R;
assignin('base', 'SAXSlinecut', cut)
%assignin('base', 'cut', cut)
handles = plotcut(handles, saxs, R, X, Y, cut);



function ed_BandWidth_Callback(hObject, eventdata, handles)
% hObject    handle to ed_BandWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_BandWidth as text
%        str2double(get(hObject,'String')) returns contents of ed_BandWidth as a double
saxs = getgihandle;
saxs.linecutbandwidth = str2double(get(hObject, 'string'));
setgihandle(saxs);

function ed_DAng_Callback(hObject, eventdata, handles)
% hObject    handle to ed_BandWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_BandWidth as text
%        str2double(get(hObject,'String')) returns contents of ed_BandWidth as a double
saxs = getgihandle;
%saxs.tiltangle = str2double(char(cellstr(get(handles.ed_DAng, 'string'))));
setgihandle(saxs);

% --- Executes during object creation, after setting all properties.
function ed_BandWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_BandWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rd_auto_ai.
function rd_auto_ai_Callback(hObject, eventdata, handles)
% hObject    handle to rd_auto_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_auto_ai

function determine_ai(handles)
if get(handles.rd_auto_ai, 'value')
    saxs = getgihandle;
    saxs.ai = 0;
    DAng = str2double(char(cellstr(get(handles.ed_DAng, 'string'))));
    DAng = DAng + saxs.tiltangle;
    img = saxs.image;
    [R, X, Y, cut] = linecut(img, saxs.center, DAng, 'v', saxs);
    [~, ind] = max(R);
    ai = cut.af(ind(1))/2;
    saxs.ai = ai;
    setgihandle(saxs);
end



function ed_azimX_Callback(hObject, eventdata, handles)
% hObject    handle to ed_azimX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_azimX as text
%        str2double(get(hObject,'String')) returns contents of ed_azimX as a double
