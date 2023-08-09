function mypixval(arg)

switch arg
case 'MotionFcn'
    MotionFcn
case 'ButtonDownFcn'
    ButtonDownOnImage
case 'Arbline'
    ButtonDownArbline
end

function MotionFcn
figureHandle = gcbf;
axesHandle = findobj(figureHandle, 'type', 'axes');
pt = get(axesHandle, 'CurrentPoint');
ImgUser = get(figureHandle, 'Userdata');
cxH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_curX');
cyH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_curY');
X = num2str(fix(pt(1, 1)*10)/10);
Y = num2str(fix(pt(1, 2)*10)/10);
set(cxH, 'string', X);
set(cyH, 'string', Y);

% ========= data loading =====================================
%    t = get(findobj(figureHandle, 'Type', 'image'), 'Cdata');
%    if ~isgray(t)
%        if isind(t)
%            [x1, y1, z1] = size(t);
%            if z1 ~= 1
%                t = ind2gray(t);
%             end
%        elseif isrgb(t)
%            [x1, y1, z1] = size(t);
%            if z1 ~= 1
%                t = rgb2gray(t);
%            end
%        end
%    end

%    if ~strcmp(class(t), 'double')
%        t = double(t);
%    end
%    [xx, yy] = size(t);
%    if (X > 1) & (X < xx) & (Y > 1) & (Y < yy)
%        fix(X), fix(Y)
%        Data = t(fix(X), fix(Y))
%    end

%Z = interp2(data, X, Y)


function ButtonDownOnImage

figureHandle = gcbf;
if strcmp(get(gcf, 'selectiontype'), 'alt')
    axesHandle = findobj(figureHandle, 'type', 'axes');
    pt = get(axesHandle, 'CurrentPoint');
    ImgUser = get(figureHandle, 'Userdata');
    cxH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCx');
    cyH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCy');
    set(cxH, 'string', num2str(fix(pt(1, 1)*10)/10));
    set(cyH, 'string', num2str(fix(pt(1, 2)*10)/10));
end


function ButtonDownArbline
disp('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
figureHandle = gcbf;
axesHandle = findobj(figureHandle, 'type', 'axes');
pt = fix(get(axesHandle, 'CurrentPoint')*10)/10;
ImgUser = get(figureHandle, 'Userdata');

if strcmp(get(figureHandle, 'selectiontype'), 'normal')
    x0H = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCx');
    y0H = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCy');
    x0 = str2num(get(x0H, 'string'));
    y0 = str2num(get(y0H, 'string'));
    x = pt(1, 1);y = pt(1, 2);
    DAng = x-x0 + (y-y0)*j;
    DAng = rad2deg(angle(DAng))
    
    Dist = sqrt((x - x0)^2 + (y - y0)^2);
    X = x0:(x-x0)/fix(Dist):x;
    Y = y0:(y-y0)/fix(Dist):y;
   % Y = (X - x0)*sin(deg2rad(DAng)) + y0

    k = find(Y<1);
    X(k) = [];Y(k) = [];

    t = get(findobj(figureHandle, 'Type', 'image'), 'Cdata');
    if ~isgray(t)
        if isind(t)
            t = ind2gray(t);
        elseif isrgb(t)
            t = rgb2gray(t);
        end
    end

    if ~strcmp(class(t), 'double')
        t = double(t);
    end

    Data = interp2(double(t), X, Y);
    figure(figureHandle);
    k = line(X, Y);
    set(k, 'color', [1, 0, 0])
    
    edNewFigH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_newFig');
    NewfigH = str2num(char(cellstr(get(edNewFigH, 'string'))));
    oldlegend = [];
    if isempty(NewfigH)
        NewfigH = 0;
        figure
    end
    if (NewfigH ~= 0)
        figure(NewfigH)
        rbHH = findobj(ImgUser.AnalHandle, 'Tag', 'rb_holdon');
        if get(rbHH, 'value')
            hold on
            lineuserdata = get(findobj(NewfigH, 'tag', 'legend'), 'Userdata');
            if isfield(lineuserdata, 'lstrings')
                oldlegend = lineuserdata.lstrings;
            end
        else
            hold off
        end
    end

    tplot = plot(1:length(Data), Data);
    
    % line property and userdata setting.
    lineuser.X = X;                 % pixel value in image
    lineuser.Y = Y;                 % pixel vaule in image
    lineuser.x = [x0, x];           % line cut position
    lineuser.y = [y0, y];           % line cut position
    lineuser.qp = [x0-ImgUser.Cx, x -ImgUser.Cx]*ImgUser.QperP;  % q parallel component
    lineuser.qz = [y0-ImgUser.Cy, y-ImgUser.Cy]*ImgUser.QperP;    % q perpendicular component
    lineuser.QperP = ImgUser.QperP;
    lineuser.AperP = ImgUser.AperP;
    set(tplot, 'Tag', 'data');
    set(tplot, 'Userdata', lineuser)
% ================================================

    edLg = findobj(ImgUser.AnalHandle, 'Tag', 'ed_legend');
    if isempty(char(cellstr(get(edLg, 'string'))))
        tempstr = sprintf('Line Cut of %s at x :%s to %s, y : %s to %s', ImgUser.Fname, num2str(x0), num2str(x), num2str(y0), num2str(y));
        legend([oldlegend, {tempstr}])
    else
        legend([oldlegend, cellstr(get(handles.ed_legend, 'string'))]);
    end

elseif strcmp(get(figureHandle, 'selectiontype'), 'alt')
    cxH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCx');
    cyH = findobj(ImgUser.AnalHandle, 'Tag', 'ed_LCy');
    set(cxH, 'string', num2str(pt(1, 1)));
    set(cyH, 'string', num2str(pt(1, 2)));
end
