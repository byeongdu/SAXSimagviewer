function maskmake(img)




%Now plot the data and save the graphics handles.
f = figure;
set(f, 'toolbar', 'figure')

imagesc(img)

h1 = uicontrol('Position', [20 0 50 20], 'String', 'drawpolygon', ...
                      'Callback', @drawpolygon);
h12 = uicontrol('Position', [70 0 50 20], 'String', 'drawcircle', ...
                      'Callback', @drawc);
h2 = uicontrol('Position', [20 20 100 20], 'String', 'Invert the selection', ...
                      'Callback', @invert);
h3 = uicontrol('Position', [20 40 100 20], 'String', 'Add to the mask', ...
                      'Callback', @addmask);
h3 = uicontrol('Position', [20 60 100 20], 'String', 'Remove from the mask', ...
                      'Callback', @rmmask);
h4 = uicontrol('Position', [20 80 100 20], 'String', 'show mask', ...
                      'Callback', @showmask);
h5 = uicontrol('Position', [20 100 100 20], 'String', 'show image', ...
                      'Callback', @showimage);
h5 = uicontrol('Position', [20 120 100 20], 'String', 'save mask', ...
                      'Callback', @savemask);
h5 = uicontrol('Position', [20 140 100 20], 'String', 'load mask', ...
                      'Callback', @loadmask);
h5 = uicontrol('Position', [20 160 100 20], 'String', 'show histogram', ...
                      'Callback', @loadmask);

%handles = guihandles(f);
ax = findall(f, 'type', 'axes');

sizea = size(img);
mask = uint8(ones(sizea));
assignin('base', 'mask', mask);
x = 1:sizea(1);
y = 1:sizea(2);
[X,Y] = meshgrid(y,x);
btdfcn = '';
%uiwait(gcf);
tmpmask = [];
ctn = [];
r = [];
maskhandle = [];
lh = [];
%% 
    function drawpolygon(varargin)
        btdfcn = get(f, 'windowbuttondownfcn');
        set(f, 'windowbuttondownfcn', @gtrack_on);
        set(ax, 'userdata', []);
    end
    function gtrack_on(src, event)
        switch get(f, 'selectiontype')
        case 'normal'
            pt = get(ax, 'CurrentPoint');
            xInd = pt(1, 1);
            yInd = pt(1, 2);
            t = get(ax, 'userdata');
            t = [t; [xInd, yInd]];
            set(ax, 'userdata', t);
            if numel(t(:,1)) > 1
                lh = line(t(:,1), t(:,2));
            end
        case 'extend'
            gtrack_off
        case 'alt'
            gtrack_off
%            winBtnDownFcn(handles.ImageAxes);
        otherwise
        end
    end
    function gtrack_off
        if ~isempty(lh)
            delete(lh)
            lh = [];
        end
        
        set(f, 'windowbuttondownfcn', btdfcn);
            t = get(ax, 'userdata');
            t = [t; [t(1,1), t(1,2)]];
%            set(ax, 'userdata', t);
            if numel(t(:,1)) > 1
                lh = line(t(:,1), t(:,2));
            end
        makemask
        k = findall(f, 'type', 'line');
        delete(k);
    end
    function makemask(varargin)
        t = get(ax, 'userdata');
        tmpmask = inpolygon(X(:), Y(:), t(:,1), t(:,2));
        tmpmask = double(tmpmask);
        tmpmask(tmpmask == 0) = 2;
        tmpmask = reshape(tmpmask, size(X));
        tmpmask = tmpmask - 1;
        showm(tmpmask);
        %assignin('base', 'saxs_mask', mask)
    end
    function drawc(varargin)
        ctn = ginput(1);
        set(f, 'windowbuttonmotionfcn', @wdbmf_circle);
        set(ax, 'userdata', []);
        set(f, 'windowbuttondownfcn', @wdbdf_circle);
    end
    function wdbmf_circle(varargin)
        pt = get(ax, 'CurrentPoint');
        r = sqrt(abs(ctn(1)-pt(1,1)).^2 + abs(ctn(2)-pt(1,2)).^2);
        drawcir(ctn(1), ctn(2), r, 100)
    end
    function drawcir(x, y, r, ns)
        theta = linspace(0, 2*pi, ns);
        pline_x = r * cos(theta) + x;
        pline_y = r * sin(theta) + y;
        k = findall(ax, 'type', 'line');
        delete(k)
        line(pline_x, pline_y);
    end
    function wdbdf_circle(varargin)
        m = sqrt(abs(X-ctn(1)).^2+abs(Y-ctn(2)).^2)-r;
        indx = m > 0;
        %indy = m <= 0;
        tmpmask = zeros(size(X));
        tmpmask(indx) = 1;
        tmpmask = reshape(tmpmask, size(X));
        k = findall(ax, 'type', 'line');
        delete(k)
        showm(tmpmask);
    end
    function varargout = invert(varargin)
        if numel(varargin) == 1
            tmpmask = abs(varargin{1} -1);
            varargout{1} = tmpmask;
        else
            tmpmask = abs(tmpmask -1);
            showm(tmpmask);
        end
    end
    function rtn = maskand(a,b)
        a = uint8(a);
        b = uint8(b);
        rtn = a & b;
    end
    function rtn = maskor(a,b)
        a = uint8(a);
        b = uint8(b);
        rtn = a | b;
    end
    function rmmask(varargin)
        mask = evalin('base', 'mask');
        %mask = mask - uint8(tmpmask);
        tm = invert(tmpmask);
        mask = maskor(mask, tm);
        assignin('base', 'mask', mask);
    end
    function addmask(varargin)
        mask = evalin('base', 'mask');
        %mask = mask.*uint8(tmpmask);
        mask = maskand(mask, tmpmask);
        assignin('base', 'mask', mask);
    end
    function showmask(varargin)
        mask = evalin('base', 'mask');
        showm(mask);
    end
    function showm(msk)
        try
        if ~isempty(maskhandle)
            delete(maskhandle)
            maskhandle = [];
        end
        catch
            maskhandle = [];
        end
        %hold on;
        %maskhandle = image(E);
        %hold off;
        E = abs(msk-3); E = E*0.5;
        h = findall(f, 'type', 'image');
        set(h, 'alphadata', E);
        set(f, 'windowbuttonmotionfcn', '');
        set(f, 'windowbuttondownfcn', '');
    end
    function showimage(varargin)
        cla
        
        lim = input('type min and max, ex [0,10] : ');
        %set(ax, 'CLim', lim)
        imagesc(img, lim);
        ax = findall(f, 'type', 'axes');
        try
        if ~isempty(maskhandle)
            delete(maskhandle)
            maskhandle = [];
        end
        catch
            maskhandle =[];
        end
    end
    function savemask(varargin)
        mask = evalin('base', 'mask');
        [filename, pathname] = uiputfile('*.bmp', 'Save as');
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return
        else
            imwrite(mask, fullfile(pathname, filename));
            disp(['Mask saved as ', fullfile(pathname, filename)])
        end
        %imwrite(mask, 'mask.bmp')
    end
    function loadmask(varargin)
        [filename, pathname] = uigetfile('*.*', 'Pick a mask file');
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return
        else
            disp(['User selected ', fullfile(pathname, filename)])
        end
        mask = imread(fullfile(pathname, filename));
        assignin('base', 'mask', mask);
    end
end
        