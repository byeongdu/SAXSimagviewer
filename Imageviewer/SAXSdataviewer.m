function SAXSdataviewer(varargin)

%IMAGEVIEWER  Interactively pan and zoom images on the computer.
%   IMAGEVIEWER starts a GUI for opening image files and interactive
%   panning and zooming.
%
%   IMAGEVIEWER(DIRNAME) starts the GUI with DIRNAME as the initial
%   directory.
%
%   The GUI allows you to navigate through your computer and quickly view
%   image files. It also allows you to interactively explore your images by
%   panning (clicking and drag), zooming (right-click and drag), and
%   centering view (double-clicking).
%

% Copyright 2006 The MathWorks, Inc.

% VERSIONS:
%   v1.0 - first version. (was pictureviewer.m)
%   v1.1 - convert to nested functions. (Nov 13, 2006)
%   v1.2 - bug fix to deal with different image types (Nov 15, 2006)
%   v1.3 - bug fix for centering, sorting of image files.
%          add resize window feature.
%          change FINDOBJ to FINDALL (Nov 16, 2006)
%   v1.4 - cosmetic changes to the GUI.
%          a better timer management. (Dec 2, 2006)
%
% Jiro Doke
% April 2006

 

verNumber = '1.4';

if nargin == 0
  dirname = pwd;
  filename = [];
else
    dirname = pwd;
    filename = varargin{1};
  if ~ischar(dirname) || ~isdir(dirname)
    error('Invalid input argument.\n  Syntax: %s(IMAGE FILE NAME)', upper(mfilename));
  end
end

delete(findall(0, 'type', 'figure', 'tag', 'SAXSImageViewer'));

bgcolor1 = [1 1 1];
%bgcolor1 = [.8 .8 .8];
bgcolor2 = [.7 .7 .7];
txtcolor = [.3 .3 .3];
figHcolormap = [    1.0000    1.0000    1.0000
    1.0000    1.0000    1.0000
    1.0000    0.9176    0.9294
    1.0000    0.8431    0.8902
    1.0000    0.7647    0.8706
    1.0000    0.6902    0.8784
    1.0000    0.6118    0.9059
    1.0000    0.5373    0.9608
    0.9608    0.4588    1.0000
    0.8588    0.3843    1.0000
    0.7373    0.3059    1.0000
    0.5882    0.2314    1.0000
    0.4157    0.1529    1.0000
    0.2196    0.0784    1.0000
         0         0    1.0000
         0    0.1098    1.0000
         0    0.2235    1.0000
         0    0.3333    1.0000
         0    0.4431    1.0000
         0    0.5569    1.0000
         0    0.6667    1.0000
         0    0.7765    1.0000
         0    0.8902    1.0000
         0    1.0000    1.0000
         0    1.0000    0.8902
         0    1.0000    0.7765
         0    1.0000    0.6667
         0    1.0000    0.5569
         0    1.0000    0.4431
         0    1.0000    0.3333
         0    1.0000    0.2235
         0    1.0000    0.1098
         0    1.0000         0
         0    1.0000         0
         0    1.0000         0
    0.1020    1.0000         0
    0.2000    1.0000         0
    0.2980    1.0000         0
    0.4000    1.0000         0
    0.5020    1.0000         0
    0.6000    1.0000         0
    0.7020    1.0000         0
    0.8000    1.0000         0
    0.9020    1.0000         0
    1.0000    1.0000         0
    1.0000    0.8902         0
    1.0000    0.7765         0
    1.0000    0.6667         0
    1.0000    0.5569         0
    1.0000    0.4431         0
    1.0000    0.3333         0
    1.0000    0.2235         0
    1.0000    0.1098         0
    1.0000         0         0
    1.0000         0    0.1098
    0.9804         0    0.0706
    0.9608         0    0.0353
    0.9412    0.0039         0
    0.7529    0.1529    0.1490
    0.5647    0.2275    0.2275
    0.3765    0.2275    0.2275
    0.1882    0.1490    0.1490
         0         0         0
         0         0         0];
%  colormap Jet.
figHcolormap =         [0         0    0.5625
         0         0    0.6250
         0         0    0.6875
         0         0    0.7500
         0         0    0.8125
         0         0    0.8750
         0         0    0.9375
         0         0    1.0000
         0    0.0625    1.0000
         0    0.1250    1.0000
         0    0.1875    1.0000
         0    0.2500    1.0000
         0    0.3125    1.0000
         0    0.3750    1.0000
         0    0.4375    1.0000
         0    0.5000    1.0000
         0    0.5625    1.0000
         0    0.6250    1.0000
         0    0.6875    1.0000
         0    0.7500    1.0000
         0    0.8125    1.0000
         0    0.8750    1.0000
         0    0.9375    1.0000
         0    1.0000    1.0000
    0.0625    1.0000    0.9375
    0.1250    1.0000    0.8750
    0.1875    1.0000    0.8125
    0.2500    1.0000    0.7500
    0.3125    1.0000    0.6875
    0.3750    1.0000    0.6250
    0.4375    1.0000    0.5625
    0.5000    1.0000    0.5000
    0.5625    1.0000    0.4375
    0.6250    1.0000    0.3750
    0.6875    1.0000    0.3125
    0.7500    1.0000    0.2500
    0.8125    1.0000    0.1875
    0.8750    1.0000    0.1250
    0.9375    1.0000    0.0625
    1.0000    1.0000         0
    1.0000    0.9375         0
    1.0000    0.8750         0
    1.0000    0.8125         0
    1.0000    0.7500         0
    1.0000    0.6875         0
    1.0000    0.6250         0
    1.0000    0.5625         0
    1.0000    0.5000         0
    1.0000    0.4375         0
    1.0000    0.3750         0
    1.0000    0.3125         0
    1.0000    0.2500         0
    1.0000    0.1875         0
    1.0000    0.1250         0
    1.0000    0.0625         0
    1.0000         0         0
    0.9375         0         0
    0.8750         0         0
    0.8125         0         0
    0.7500         0         0
    0.6875         0         0
    0.6250         0         0
    0.5625         0         0
    0.5000         0         0];
    
    
figH = figure(...
  'visible'                       , 'off', ...
  'units'                         , 'normalized', ...
  'busyaction'                    , 'queue', ...
  'color'                         , bgcolor1, ...
  'colormap'                      , figHcolormap, ...
  'deletefcn'                     , @stopTimerFcn, ...
  'createfcn'                     , @winCreateFcn, ...
  'keypressfcn'                   , @winKeyPressFcn, ...
  'doublebuffer'                  , 'on', ...
  'handlevisibility'              , 'callback', ...
  'interruptible'                 , 'on', ...
  'menubar'                       , 'none', ...
  'name'                          , upper(mfilename), ...
  'numbertitle'                   , 'off', ...
  'resize'                        , 'on', ...
  'resizefcn'                     , @resizeFcn, ...
  'tag'                           , 'SAXSImageViewer', ...
  'toolbar'                       , 'none', ...
  'defaultaxesunits'              , 'pixels', ...
  'defaulttextfontunits'          , 'pixels', ...
  'defaulttextfontname'           , 'Verdana', ...
  'defaulttextfontsize'           , 12, ...
  'defaultuicontrolunits'         , 'pixels', ...
  'defaultuicontrolfontunits'     , 'pixels', ...
  'defaultuicontrolfontsize'      , 10, ...
  'defaultuicontrolfontname'      , 'Verdana', ...
  'defaultuicontrolinterruptible' , 'off');

uph(1) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'versionPanel');
uicontrol(...
  'style'                     , 'text', ...
  'foregroundcolor'           , txtcolor, ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'center', ...
  'fontweight'                , 'bold', ...
  'string'                    , sprintf('Ver %s', verNumber), ...
  'parent'                    , uph(1), ...
  'tag'                       , 'versionText');
uph(2) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'statusPanel');
uicontrol(...
  'style'                     , 'text', ...
  'foregroundcolor'           , txtcolor, ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'right', ...
  'fontweight'                , 'bold', ...
  'string'                    , '', ...
  'parent'                    , uph(2), ...
  'tag'                       , 'statusText');
uph(3) = uipanel(...
  'units'                     , 'pixels', ...
  'bordertype'                , 'etchedout', ...
  'fontname'                  , 'Verdana', ...
  'fontweight'                , 'bold', ...
  'title'                     , 'View', ...
  'titleposition'             , 'centertop', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'tag'                       , 'frame1');
uicontrol(...
  'style'                     , 'text', ...
  'string'                    , '', ...
  'horizontalalignment'       , 'center', ...
  'fontweight'                , 'bold', ...
  'fontsize'                  , 12, ...
  'backgroundcolor'           , bgcolor1, ...
  'foregroundcolor'           , [.2, .2, .2], ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ZoomCaptionText');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'Full', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @resetView, ...
  'enable'                    , 'off', ...
  'tooltipstring'             , 'View full image', ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ResetViewBtn1');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , '100%', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @resetView, ...
  'enable'                    , 'off', ...
  'tooltipstring'             , 'View true size', ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ResetViewBtn2');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'Help', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @helpBtnCallback, ...
  'enable'                    , 'on', ...
  'parent'                    , figH, ...
  'tag'                       , 'HelpBtn');
uicontrol(...
  'style'                     , 'togglebutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'File Info', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @fileInfoBtnCallback, ...
  'enable'                    , 'off', ...
  'parent'                    , figH, ...
  'tag'                       , 'FileInfoBtn');
uph(4) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'CurrentDirectoryPanel');
uicontrol(...
  'style'                     , 'text', ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , uph(4), ...
  'tag'                       , 'CurrentDirectoryEdit');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'string'                    , '...', ...
  'backgroundcolor'           , bgcolor1, ...
  'callback'                  , @chooseDirectoryCallback, ...
  'parent'                    , figH, ...
  'tag'                       , 'ChooseDirectoryBtn');



% Up Directory Icon
map = [0 0 0;bgcolor1;1 1 0;1 1 1];
upDirIcon = uint8([
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1
  1 1 0 3 2 3 2 3 0 1 1 1 1 1 1 1
  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
  1 0 2 3 2 3 2 3 2 3 2 3 2 3 2 0
  1 0 3 2 3 2 0 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 0 0 0 2 3 2 3 2 3 2 0
  1 0 3 2 0 0 0 0 0 2 3 2 3 2 3 0
  1 0 2 3 2 3 0 3 2 3 2 3 2 3 2 0
  1 0 3 2 3 2 0 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 3 0 0 0 0 0 3 2 3 2 0
  1 0 3 2 3 2 3 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 3 2 3 2 3 2 3 2 3 2 0
  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  ]);
rgbIcon = ind2rgb(upDirIcon, map);

uicontrol(...
  'style'                     , 'pushbutton', ...
  'cdata'                     , rgbIcon, ...
  'backgroundcolor'           , bgcolor1, ...
  'callback'                  , @upDirectoryCallback, ...
  'parent'                    , figH, ...
  'tag'                       , 'UpDirectoryBtn');
uicontrol(...
  'style'                     , 'listbox', ...
  'backgroundcolor'           , 'white', ...
  'callback'                  , @fileListBoxCallback, ...
  'fontname'                  , 'FixedWidth', ...
  'parent'                    , figH, ...
  'tag'                       , 'FileListBox');
uicontrol(...
  'style'                     , 'edit', ...
  'backgroundcolor'           , [1,1,1], ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , figH, ...
  'callback'                  , @filefiltereditCallback, ...
  'tag'                       , 'FileFilterEdit');
uicontrol(...
  'style'                     , 'popupmenu', ...
  'backgroundcolor'           , [1,1,1], ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , figH, ...
  'string'                    , {'name', 'date', 'bytes', 'datenum'},...
  'callback'                  , @filesortpopupCallback, ...
  'tag'                       , 'FileSortPopup');


axes(...
  'box'                       , 'off', ...
  'fontname'                  , 'Verdana', ...
  'fontsize'                  , 14, ...
  'XAxisLocation'             ,'top',...
  'YAxisLocation'             ,'right',...  
  'handlevisibility'          , 'callback', ...
  'parent'                    , figH, ...
  'DataAspectRatio'           , [1,1,1], ...
  'color'                      , [1,1,0], ...
  'tag'                       , 'ImageAxes');
%  'xtick'                     , [], ...
%  'ytick'                     , [], ...

% for making axes for q or angle..
axes(...
  'box'                       , 'off', ...
  'hittest'                   , 'off', ...
  'handlevisibility'          , 'callback', ...
  'parent'                    , figH, ...
  'fontname'                  , 'Verdana', ...
  'fontsize'                  , 14, ...
  'visible'                     ,'on',...
  'color'                       ,'none',...
  'DataAspectRatio'           , [1,1,1], ...
  'tag'                       , 'CoordinateAxes');

% for drawing the zoom line
axH = axes(...
  'units'                     , 'normalized', ...
  'position'                  , [0 0 1 1], ...
  'box'                       , 'off', ...
  'hittest'                   , 'off', ...
  'xlim'                      , [0 1], ...
  'xtick'                     , [], ...
  'ylim'                      , [0 1], ...
  'ytick'                     , [], ...
  'handlevisibility'          , 'callback', ...
  'visible'                   , 'off', ...
  'parent'                    , figH, ...
  'DataAspectRatio'           , [1,1,1], ...
  'tag'                       , 'InvisibleAxes');

line(NaN, NaN, ...
  'linestyle'                 , '--', ...
  'linewidth'                 , 2, ...
  'color'                     , 'r', ...
  'parent'                    , axH, ...
  'tag'                       , 'ZoomLine');

uicontrol(...
  'style'                     , 'listbox', ...
  'backgroundcolor'           , [.75, .75, 1], ...
  'fontname'                  , 'FixedWidth', ...
  'fontsize'                  , 14, ...
  'visible'                   , 'off', ...
  'enable'                    , 'inactive', ...
  'interruptible'             , 'off', ...
  'busyaction'                , 'queue', ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , figH, ...
  'tag'                       , 'MessageTextBox');

% =============================================
% text box to display Q and intensity
% added by Byeongdu Lee
uicontrol(...
  'style'                     , 'text', ...
  'backgroundcolor'           , [1,1,1], ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , figH, ...
  'tag'                       , 'DisplayInfo');


% add toolbar
% Byeongdu Lee
th = uitoolbar(figH);

% Add a push tool to the toolbar
a = [.20:.05:0.95];
img1(:,:,1) = repmat(a,16,1)';
img1(:,:,2) = repmat(a,16,1);
img1(:,:,3) = repmat(flipdim(a,2),16,1);
cbimg = load('mycolorbaricon.mat'); % contains variable named myi
imglcut = zeros(size(img1));
imglcut(1:16,8,1) = 1;

uipushtool(th, ...
        'CData'                 ,imglcut,...
        'TooltipString'         ,'Linecut along the line drawn with linestyle - ',...
        'HandleVisibility'      ,'callback',...
        'ClickedCallback'       ,{@pushline}, ...
        'Tag'                   ,'PushLinecuts');
% Add a toggle tool to the toolbar
img2 = rand(16,16,3);
uitoggletool(th, ...
        'CData'                 ,img2, ...
        'Separator'             ,'on',...
        'TooltipString'         ,'Toggle button to read mouse point',...
        'OnCallback'            , @OntoggleBtCallback, ...  
        'OffCallback'           , @OfftoggleBtCallback, ...  
        'HandleVisibility'      ,'callback', ...
        'Tag'                   ,'ToggleReadValue');
uitoggletool(th, ...
        'CData'                 ,img2, ...
        'Separator'             ,'on',...
        'TooltipString'         ,'Convert Log to Linear image scale',...
        'OnCallback'            , {@loglinConvert, 'log'}, ...  
        'OffCallback'           , {@loglinConvert, 'lin'}, ...  
        'HandleVisibility'      ,'callback', ...
        'Tag'                   ,'ToggleLogLin');
uitoggletool(th, ...
        'CData'                 ,img1, ...
        'Separator'             ,'on',...
        'TooltipString'         ,'Find center using AgBH',...
        'OnCallback'            , {@findcenterCallback, 'on'}, ...  
        'OffCallback'           , {@findcenterCallback, 'off'}, ...  
        'HandleVisibility'      ,'callback', ...
        'Tag'                   ,'ToggleFindCenter');
uitoggletool(th, ...
        'CData'                 ,cbimg.myi, ...
        'Separator'             ,'on',...
        'TooltipString'         ,'Find center using AgBH',...
        'HandleVisibility'      ,'callback', ...
        'OnCallback'            , {@colorbarCallback, 'on'}, ...  
        'OffCallback'           , {@colorbarCallback, 'off'}, ...  
        'Tag'                   ,'ToggleColorbar');
uitoggletool(th, ...
        'CData'                 ,img2, ...
        'Separator'             ,'on',...
        'TooltipString'         ,'Toggle button to measure azimuthal angle; click on three pnts',...
        'OnCallback'            , @azimangle_start, ...  
        'OffCallback'           , @azimangle_Off, ...  
        'HandleVisibility'      ,'callback', ...
        'Tag'                   ,'Toggleazimangle');
    
uipushtool(th, ...
        'CData'                 ,imglcut,...
        'TooltipString'         ,'Reset Axis limits - ',...
        'HandleVisibility'      ,'callback',...
        'ClickedCallback'       ,{@setXYLim}, ...
        'Tag'                   ,'resetAXISlimits');    
% ===================================================       

handles             = guihandles(figH);
handles.figPos      = [];
handles.axPos       = [];
handles.lastDir     = dirname;
handles.ImX         = [];
handles.tm          = timer(...
  'name'            , 'image preview timer', ...
  'executionmode'   , 'fixedspacing', ...
  'objectvisibility', 'off', ...
  'taskstoexecute'  , inf, ...
  'period'          , 0.001, ...
  'startdelay'      , 3, ...
  'timerfcn'        , @getPreviewImages);


linkprop([handles.ImageAxes, handles.CoordinateAxes], 'position');
linkprop([handles.ImageAxes, handles.CoordinateAxes], 'PlotBoxAspectRatio');

resizeFcn;

% Show initial directory
showDirectory;

set(figH, 'visible', 'on');
%figHcolormap = jet;

% save handles of SAXSimageviewer to workspace.
assignin('base', 'SAXSimageviewerhandle', figH);
assignin('base', 'SAXSimagehandle', handles.ImageAxes);

% plot input images if provided..
%if ~isempty(filename)
%    loadImage(filename);
%end
% plot input images if provided..
if ~isempty(varargin)
    loadImage(varargin{:});
end




%% Nested function starts here......
  function pushline(varargin)
      %t = findobj(handles.ImageAxes, 'type', 'line', 'linestyle', '-');
      t = findobj(handles.ImageAxes, 'type', 'line', 'linestyle', '-');
      if numel(t) >= 1
          for k=1:numel(t)
              xd{k} = round(get(t(k), 'xdata'));
              yd{k} = round(get(t(k), 'ydata'));
          end
      else
          disp('No line drawn, no result you get')
          return
      end
        %img = handles.ImX;
%      [x, y] = size(handles.ImX);
%        if strcmp(get(handles.ImageAxes, 'YDir'), 'reverse')
%            yd = y-yd;
%        end
      cut = {};
      for k=1:numel(xd)
        for i=1:numel(xd{k})
            cut{k}(i) = handles.ImX(yd{k}(i), xd{k}(i));
        end
      end
      if numel(cut)
          cut = cut{1};
      end
        %t = [xd', yd']
        %t = handles.ImX(round(xd), round(yd));
      assignin('base', 'lcut', cut);
%      assignin('base', 'img', handles.ImX);
%      assignin('base', 't', [xd', yd']);
  end

  function winCreateFcn(varargin)
%        saxs = getgihandle;
%        handles.saxs = saxs
  end
  
  % ======================
  % color scale changes
  % ======================  
  function setColor(varargin)
        climmode = lower(get(get(handles.ColorScaleGroup,'SelectedObject'),'String'));
        if numel(varargin) == 0
            clim(1) = str2double(get(handles.ColorLowLim, 'string'));
            clim(2) = str2double(get(handles.ColorHighLim, 'string'));
        else
            clim = varargin{1};
        end
        set(handles.ImageAxes, 'cLimmode', climmode);
        switch climmode
            case 'auto'
                if numel(clim) == 2
                    clim = get(handles.ImageAxes, 'cLim');
%                    drawnow;
                    set(handles.ColorLowLim, 'string', num2str(clim(1)));
                    set(handles.ColorHighLim, 'string', num2str(clim(2)));
                end
            case 'manual'
                clim(1) = str2double(get(handles.ColorLowLim, 'string'));
                clim(2) = str2double(get(handles.ColorHighLim, 'string'));
                if isnan(clim)
                    clim = [1, 5000];
                end
                set(handles.ImageAxes, 'cLim', clim);
            otherwise
        end
  end

  function ManualColorEdit(varargin)
 %    mode = get(varargin{1}, 'Tag');
     if get(handles.ManualColor, 'value') == 0
         set(handles.ManualColor, 'value', 1);
     end
%     clim = get(handles.ImageAxes, 'cLim');
     setColor
  end

  function selcbk(source,eventdata)
%        disp(source);
%        disp([eventdata.EventName,'  ',... 
%            get(eventdata.OldValue,'String'),'  ', ...
%            get(eventdata.NewValue,'String')]);
    setColor
  end
  
  % ======================
  % XY scale changes
  % ======================  
  function setXYLim(varargin)
        climmode = lower(get(get(handles.XYLimGroup,'SelectedObject'),'String'));
        %if numel(varargin) ~= 0
        try
            lim = varargin{1};
            xlim = lim(1:2);
            ylim = lim(3:4);
        %end
        catch
            % if numel(varargin) ==0 or numel(varargin{1}) is not 4.
            xllim = str2double(get(handles.XLowLim, 'string'));
            xhlim = str2double(get(handles.XHighLim, 'string'));
            yllim = str2double(get(handles.YLowLim, 'string'));
            yhlim = str2double(get(handles.YHighLim, 'string'));
            xlim = [xllim, xhlim];
            ylim = [yllim, yhlim];
        end
        
        set(handles.ImageAxes, 'xLimmode', climmode);
        set(handles.ImageAxes, 'yLimmode', climmode);
        xv = max(get(get(handles.ImageAxes,'children'),'xdata'));
        yv = max(get(get(handles.ImageAxes,'children'),'ydata'));
        set(handles.ImageAxes, 'PlotBoxAspectRatio', [xv yv 1]);
        CoordinateAxes2ImageAxes;
        switch climmode
            case 'auto'
                getXYLim
            case 'manual'
                set(handles.ImageAxes, 'xLim', xlim);
                set(handles.ImageAxes, 'yLim', ylim);
            otherwise
        end
  end

  function getXYLim
      xlim = get(handles.ImageAxes, 'xLim');
      ylim = get(handles.ImageAxes, 'yLim');
      set(handles.XLowLim, 'string', num2str(xlim(1)));
      set(handles.XHighLim, 'string', num2str(xlim(2)));
      set(handles.YLowLim, 'string', num2str(ylim(1)));
      set(handles.YHighLim, 'string', num2str(ylim(2)));
  end
                      
      
  function ManualXYLimEdit(varargin)
 %    mode = get(varargin{1}, 'Tag');
     if get(handles.ManualXYLim, 'value') == 0
         set(handles.ManualXYLim, 'value', 1);
     end
%     clim = get(handles.ImageAxes, 'cLim');
     setXYLim
  end

  function selcImgSize(source,eventdata)
%        disp(source);
%        disp([eventdata.EventName,'  ',... 
%            get(eventdata.OldValue,'String'),'  ', ...
%            get(eventdata.NewValue,'String')]);
    setXYLim
  end

%--------------------------------------------------------------------------
% resizeFcn
%   This resizes the figure window appropriately
%--------------------------------------------------------------------------
  function resizeFcn(varargin)

    set(figH, 'units', 'pixels');
    figPos = get(figH, 'position');

    % image axis should be rec..
%    if (figPos(3)-150) ~= figPos(4)
%        figPos(4) = figPos(3);
%        set(figH, 'position', figPos);
%    end
    % figure can't be too small or off the screen
   
    if figPos(3) < 750 || figPos(4) < 600
      figPos(3) = max([750 figPos(3)]);
      figPos(4) = max([600 figPos(4)]);
      screenSize = get(0, 'screensize');
      if figPos(1)+figPos(3) > screenSize(3)
        figPos(1) = screenSize(3) - figPos(3) - 50;
      end
      if figPos(2)+figPos(4) > screenSize(4)
        figPos(2) = screenSize(4) - figPos(4) - 50;
      end

      set(figH, 'position', figPos);

    end
    Imgaxislength = figPos(3) - 310;
    if Imgaxislength > figPos(4)-120
        Imgaxislength = figPos(4)-120;
    end
    
    set(handles.versionPanel         , 'position', [1, 1, 100, 25]);
    set(handles.versionText          , 'position', [2, 2, 96, 20]);
    set(handles.statusPanel          , 'position', [102, 1, figPos(3)-102, 25]);
    set(handles.statusText           , 'position', [2, 2, figPos(3)-107, 20]);
    set(handles.frame1               , 'position', [figPos(3)-115, figPos(4)-55, 110, 53]);
    set(handles.DisplayInfo          , 'position', [300, figPos(4)-55, figPos(3)-550, 43]);
    set(handles.ZoomCaptionText      , 'position', [5, 22, 100, 17]);
    set(handles.ResetViewBtn1        , 'position', [5, 2, 47, 20]);
    set(handles.ResetViewBtn2        , 'position', [55, 2, 47, 20]);
    set(handles.HelpBtn              , 'position', [figPos(3)-220, figPos(4)-28, 100, 20]);
    set(handles.FileInfoBtn          , 'position', [figPos(3)-220, figPos(4)-50, 100, 20]);
    set(handles.CurrentDirectoryPanel, 'position', [20, figPos(4)-30, 215, 20]);
%    set(handles.CurrentDirectoryPanel, 'position', [100, figPos(4)-30, 215, 20]);
    set(handles.CurrentDirectoryEdit , 'position', [1, 1, 213, 18]);
    set(handles.ChooseDirectoryBtn   , 'position', [237, figPos(4)-30, 20, 20]);
    set(handles.UpDirectoryBtn       , 'position', [259, figPos(4)-30, 20, 20]);
    set(handles.FileListBox          , 'position', [20, 270, 260, figPos(4)-310]);
    set(handles.FileFilterEdit       , 'position', [20, 250, 260, 20]);
    set(handles.FileSortPopup        , 'position', [20, 230, 260, 20]);
    set(handles.ImageAxes            , 'outerposition', [300, 40, figPos(3)-310, figPos(4)-120]);
    set(handles.ImageAxes            , 'DataAspectRatio', [1,1,1]);
    axPos = get(handles.ImageAxes    , 'position');

    
    textBoxDim  = [400, 200];
    rightMargin = figPos(3)-(axPos(1)+axPos(3));
    topMargin   = figPos(4)-(axPos(2)+axPos(4));
    set(handles.MessageTextBox      , 'position', [figPos(3)-rightMargin-textBoxDim(1), ...
      figPos(4)-topMargin-textBoxDim(2), ...
      textBoxDim]);
    handles.figPos = figPos;
    handles.axPos  = axPos;

    titleStr = get(get(handles.ImageAxes, 'title'), 'string');
    if ~isempty(titleStr)
      % resize image as well
      loadImage(titleStr);
    end

    set(handles.CoordinateAxes, 'position', get(handles.ImageAxes, 'position'));
    set(handles.CoordinateAxes, 'PlotBoxAspectRatio', get(handles.ImageAxes, 'PlotBoxAspectRatio'));
    colorbarCallback; % resize colorbar if needed.

  end

%--------------------------------------------------------------------------
% helpBtnCallback
%   This opens up a help dialog box
%--------------------------------------------------------------------------
  function helpBtnCallback(varargin)

    helpdlg({...
      'Navigate through directories using the list box on the left.', ...
      'Single-click to see the preview.', ...
      'Double-click (list box OR preview image) to open and display image.', ...
      '', 'Click and drag to pan the image.', ...
      'Right click and drag to zoom.', ...
      'Double-click to center view.', ...
      '''Full'' displays the whole image.', ...
      '''100%'' displays the image at the true resolution.', ...
      '''File Info'' displays the current image file info.'}, 'Help');

  end

%--------------------------------------------------------------------------
% fileInfoBtnCallback
%   This displays the file info of the image that's displayed
%--------------------------------------------------------------------------
  function fileInfoBtnCallback(varargin)

    obj = varargin{1};

    if get(obj, 'value')

      % First 9 fields of IMFINFO are always the same
      fnames      = fieldnames(handles.iminfo); fnames = fnames(1:9);
      vals        = struct2cell(handles.iminfo); vals = vals(1:9);

      % Only show file name (not full path)
      [p, n, e]   = fileparts(vals{1});
      vals{1}     = [n e];
      sID         = cellfun('isclass', vals, 'char');
      dID         = cellfun('isclass', vals, 'double');
      fmt         = cell(2, 9);
      fmt(1, :)   = repmat({'%15s: '}, 1, 9);
      fmt(2, sID) = repmat({'%s|'}, 1, length(find(sID)));
      fmt(2, dID) = repmat({'%d|'}, 1, length(find(dID)));
      tmp         = [fnames(:),vals(:)]';
      str         = sprintf([fmt{:}], tmp{:});
      set(handles.MessageTextBox, 'string', str, 'visible', 'on');

    else
      set(handles.MessageTextBox, 'visible', 'off');

    end

  end

%--------------------------------------------------------------------------
% showDirectory
%   This function shows a list of image files in the directory
%--------------------------------------------------------------------------
  function showDirectory(dirname)

    % Reset settings and images
    stopTimer;
    clearImageAxes;
    %----------------------------------------------------------------------

    if nargin == 1
      handles.lastDir = dirname;
    else
      if isempty(handles.lastDir)
        handles.lastDir = pwd;
      end
    end

    set(handles.CurrentDirectoryEdit, 'string', ...
      fixLongDirName(handles.lastDir), ...
      'tooltipstring', handles.lastDir);

    % Get image formats
    [n, n2]= filefilter;
    
    if isempty(n)
      handles.imageID = [];
      handles.imageNames = {};
      handles.imagePreviews = {};
      runTimer = false;
    else
      handles.imageID = 1:length(n);
      handles.imageNames = n;
      handles.imagePreviews = cell(1,length(n));
      runTimer = true;
    end

    if ~isempty(n2)
      n2 = strcat(repmat({'['}, 1, length(n2)), n2, repmat({']'}, 1, length(n2)));
      n = {n2{:}, n{:}};

      handles.imageID = handles.imageID + length(n2);
    end
    set(handles.FileListBox, 'string', n, 'value', 1);

    if runTimer
      startTimer;
    end

    if ~isempty(handles.imageID)
      set(handles.SAXSImageViewer, 'selectiontype', 'normal');
      set(handles.FileListBox, 'value', handles.imageID(1));
      fileListBoxCallback(handles.FileListBox);
    end

  end
  
    function filefiltereditCallback(varargin)
        handles.filefilter = get(varargin{1}, 'string');
        showDirectory
    end

    function filesortpopupCallback(varargin)
        val = get(varargin{1}, 'value');
        sortstr = get(varargin{1}, 'string');
        handles.filesort = sortstr{val};
        showDirectory
    end
        
    function [n, n2] = filefilter
            % Get image formats
    imf  = imformats;
    exts = [imf.ext];
    d = [];
    % check the format string....
    if isfield(handles, 'filefilter')
        formatstring = handles.filefilter;
    else
        formatstring = [];
    end
    
    if isfield(handles, 'filesort')
        sortstring = handles.filesort;
    else
        sortstring = 'name';
    end
    
    % list files
    if isempty(formatstring)
        for id = 1:length(exts)
            d = [d; dir(fullfile(handles.lastDir, ['*.' exts{id}]))];
        end
    else
        d = [d; dir(fullfile(handles.lastDir, formatstring))];
        d = d(~[d.isdir]);
    end

%    sort files;
    if numel(d) < 2
        n = {d.name};
    else
        if isstr(d(1).(sortstring))
            [tmp, tmpind] = sort({d.(sortstring)});
        else
            [tmp, tmpind] = sort([d.(sortstring)]);
        end
        n = {d(tmpind).name};
    end
        

    d2 = dir(handles.lastDir);
    n2 = {d2.name};
    n2 = n2([d2.isdir]);
    ii1 = strmatch('.', n2, 'exact');
    ii2 = strmatch('..', n2, 'exact');
    n2([ii1, ii2]) = '';
    end

 function colorbarCallback(varargin)
    state = get(handles.ToggleColorbar, 'state');
    switch lower(state)
        case 'on'
            if ~isfield(handles, 'colorbarhandle')
                handles.colorbarhandle = colorbar('peer', handles.ImageAxes);
            else
                if ishandle(handles.colorbarhandle)
                    delete(handles.colorbarhandle)
                end
                handles.colorbarhandle = colorbar('peer', handles.ImageAxes);
            end
%            handles.colorbarhandle = colorbar('peer', handles.ImageAxes);
            set(handles.colorbarhandle, 'layer','top',...
                'TickDirMode', 'manual',...
                'xlimmode','manual',...
                'ylimmode','manual',...
                'location', 'North',...
                'unit', 'pixels',...
                'hittest', 'off',...
                'xaxislocation', 'bottom')
%                'xtickmode', 'auto',...
%                'ytickmode', 'manual',...
%                'ytick', [],...
            poc = get(handles.colorbarhandle, 'position');
            poc(4) = poc(4)/3*2;
            poc(3) = poc(3)/3;
%            po = get(handles.ImageAxes, 'position')
%            potight = get(handles.ImageAxes, 'TightInset');
%            npo = [po(1)+5, po(2)+ po(4) - poc(4) - potight(1)- potight(4), po(3)/3, po(4)/20];
            set(handles.colorbarhandle, 'position', poc, 'xaxislocation', 'bottom');
            set(handles.colorbarhandle, 'fontsize', get(handles.ImageAxes, 'fontsize'));
            set(handles.colorbarhandle, 'fontname', get(handles.ImageAxes, 'fontname'));
        case 'off'
            if isfield(handles, 'colorbarhandle')
                if ishandle(handles.colorbarhandle)
                    delete(handles.colorbarhandle)
                end
            end
    end
 end
%--------------------------------------------------------------------------
% toggleBtCallback
%   This is the toggle button callback function
%--------------------------------------------------------------------------
  function OntoggleBtCallback(varargin)
        %hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        %set(gca, 'Xscale', 'log')
      
        gtrack_start
%        gtract_off

  end

  function OfftoggleBtCallback(varargin)
        %hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        %set(gca, 'Xscale', 'log')
       
%        gtract_start
%        gtrack_off
        gtrack_Off

  end


%--------------------------------------------------------------------------
% fixLongDirName
%   This truncates the directory string if it is too long to display
%--------------------------------------------------------------------------
  function newdirname = fixLongDirName(dirname)
    % Modify string for long directory names
    if length(dirname) > 20
      [tmp1, tmp2] = strtok(dirname, filesep);
      if isempty(tmp2)
        newdirname = dirname;

      else
        % in case the directory name starts with a file separator.
        id = strfind(dirname, tmp2);
        tmp1 = dirname(1:id(1));
        [p, tmp2] = fileparts(dirname);
        if strcmp(tmp1, p) || isempty(tmp2)
          newdirname = dirname;

        else
          newdirname = fullfile(tmp1, '...', tmp2);
          tmp3 = '';
          while length(newdirname) < 20
            tmp3 = fullfile(tmp2, tmp3);
            [p, tmp2] = fileparts(p);
            if strcmp(tmp1, p)  % reach root directory
              newdirname = dirname;
              %break; % it will break because dirname is longer than 30 chars

            else
              newdirname = fullfile(tmp1, '...', tmp2, tmp3);

            end
          end
        end
      end
    else
      newdirname = dirname;
    end

  end

%--------------------------------------------------------------------------
% fileListBoxCallback
%   This gets called when an entry is selected in the file list box
%--------------------------------------------------------------------------
  function fileListBoxCallback(varargin)

    obj = varargin{1};
    stopTimer;
    val = get(obj, 'value');
    str = cellstr(get(obj, 'string'));

    if ~isempty(str)

      switch get(handles.SAXSImageViewer, 'selectiontype')
        case 'normal'   % single click - show preview

        case 'open'   % double click - open image and display

          if str{val}(1) == '[' && str{val}(end) == ']'
            dirname = get(handles.CurrentDirectoryEdit, 'tooltipstring');
            newdirname = fullfile(dirname, str{val}(2:end-1));
            showDirectory(newdirname)
          else
            handles.ImX = [];
            loadImage(fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), str{val}));
            startTimer;
          end
      end

    end

    %----------------------------------------------------------------------
    % previewImageClickFcn
    %   This loads the image when the thumbnail is double-clicked
    %----------------------------------------------------------------------
    function previewImageClickFcn(varargin)

      switch get(handles.SAXSImageViewer, 'selectiontype')

        case 'open'   % double-click

          stopTimer;

          handles.ImX = [];
          loadImage(fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), str{val}));

          startTimer;

      end
    end

  end

%--------------------------------------------------------------------------
% chooseDirectoryCallback
%   This opens a directory selector
%--------------------------------------------------------------------------
  function chooseDirectoryCallback(varargin)

    stopTimer;
    dirname = uigetdir(get(handles.CurrentDirectoryEdit, 'tooltipstring'), ...
      'Choose Directory');
    if ischar(dirname)
      showDirectory(dirname)
    end

  end

%--------------------------------------------------------------------------
% upDirectoryCallback
%   This moves up the current directory
%--------------------------------------------------------------------------
  function upDirectoryCallback(varargin)

    stopTimer;
    dirname = get(handles.CurrentDirectoryEdit, 'tooltipstring');
    dirname2 = fileparts(dirname);
    if ~isequal(dirname, dirname2)
      showDirectory(dirname2)
    end

  end

%--------------------------------------------------------------------------
% resetView
%   This resets the view to "Full" or "100%" magnification
%--------------------------------------------------------------------------
  function resetView(varargin)

    obj = varargin{1};
    stopTimer;
    set(handles.MessageTextBox, 'visible', 'off');
    set(handles.FileInfoBtn, 'value', false);

    switch get(obj, 'string')
      case 'Full'
        xlimit = handles.xlimFull;
        ylimit = handles.ylimFull;

      case '100%'
        xlimit = handles.xlim100;
        ylimit = handles.ylim100;
    end

    xl = xlim(handles.ImageAxes); xd = (xlimit - xl)/10;
    yl = ylim(handles.ImageAxes); yd = (ylimit - yl)/10;

    % Restore only if needed
    if ~(isequal(xd, [0 0]) && isequal(yd, [0 0]))

      set(handles.statusText, 'string', 'Restoring View...');

      % Animate with "good" speed
      for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

        set(handles.ImageAxes, ...
          'xlim'                , xl + xd * id, ...
          'ylim'                , yl + yd * id, ...
          'cameraviewanglemode' , 'auto', ...
          'dataaspectratiomode' , 'auto', ...
          'plotboxaspectratio'  , handles.pbar);

        getXYLim
        
        set(handles.ImageAxes           , 'DataAspectRatio', [1,1,1]);

        set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
          round(diff(handles.xlim100)/diff(xl + xd * id)*100)));

        pause(0.01);
      end

      set(handles.statusText, 'string', '');

    end

    startTimer;

  end

%--------------------------------------------------------------------------
% checkImage
%   This loads the selected image and displays it
%--------------------------------------------------------------------------
    function rtn = checkSAXS(saxs, fd)
        rtn = 0;

        if isempty(saxs)
            rtn = 0;
            return
        end
        if isfield(saxs, fd)
            rtn = 1;
            return
        end
    end
%--------------------------------------------------------------------------
% loadImage
%   This loads the selected image and displays it
%--------------------------------------------------------------------------
  function loadImage(varargin)
      if numel(varargin) > 0
          filename = varargin{1};
      end
      
      if numel(varargin) == 2
%          disp('this is Not good')
%          varargin{1}, varargin{2}
          saxs = varargin{2};
      else
%          disp('this is what happend')
          saxs = getgihandle;
      end
      if isfield(saxs, 'frame')
        disp(sprintf('current frame number is %d',saxs.frame));
      end
%      saxs.imgfigurehandle = figH;

    try
      if isempty(handles.ImX)
%        clearImageAxes;
        set(handles.statusText, 'string', 'Loading Image...');
        drawnow;
%        checkSAXS(saxs, 'CCD')
        if ~checkSAXS(saxs, 'CCD')
            [handles.ImX, handles.iminfo] = readImageFileFcn(filename);
            saxs.image = handles.ImX;
            [ph, file] = fileparts(handles.iminfo.Filename);
            saxs.imgname = file;
            saxs.dir = ph;
            saxs.imgsize = size(handles.ImX);
        else
            saxs.imgfigurehandle = figH;
            saxs.imgaxeshandle = handles.ImageAxes;
            [saxs, handles.ImX] = openccdfile(filename, saxs); %% need iminfo.....
            setColor
        end
      end
      if ~isnan(handles.ImX)
          if ~checkSAXS(saxs, 'CCD')
%              disp('OK???')
            iH = imagesc(handles.ImX, 'parent', handles.ImageAxes);
%            iH = saxs.imghandle;
          else
              iH = saxs.imghandle;
          end

          handles.iH = iH;

          if strcmp(get(handles.ToggleLogLin, 'state'), 'on')
              loglinConvert([],[],'log');
          end
 
        set(iH, 'hittest', 'off');

        set(handles.ImageAxes, ...
          'box'                       ,'off',...
          'XAxisLocation'             ,'top',...
          'YAxisLocation'             ,'right',...  
          'buttondownfcn'   , @winBtnDownFcn, ...
          'interruptible'   , 'off', ...
          'busyaction'      , 'queue', ...
          'handlevisibility', 'callback');
        set(handles.ImageAxes           , 'DataAspectRatio', [1,1,1]);
        set(handles.ResetViewBtn1, 'enable', 'on');
        set(handles.ResetViewBtn2, 'enable', 'on');
        set(handles.FileInfoBtn  , 'enable', 'on');
        set(get(handles.ImageAxes, 'title'), ...
          'string'      , sprintf('%s', filename), ...
          'interpreter' , 'none');
        handles.pbar     = get(handles.ImageAxes, 'plotboxaspectratio');

        % NEED to be modified
        handles.xlimFull = get(handles.ImageAxes, 'xlim');
        handles.ylimFull = get(handles.ImageAxes, 'ylim');

        % If image is small, show at 100% size
        sz              = size(handles.ImX);
        handles.xlim100 = sz(2)/2 + [-1, 1] * handles.axPos(3)/2;
        handles.ylim100 = sz(1)/2 + [-1, 1] * handles.axPos(4)/2;
        if all(handles.axPos(3:4) > sz([2 1]))
          set(handles.ImageAxes, ...
            'xlim'                , handles.xlim100, ...
            'ylim'                , handles.ylim100, ...
            'cameraviewanglemode' , 'auto', ...
            'dataaspectratiomode' , 'auto', ...
            'plotboxaspectratio'  , handles.pbar);
          set(handles.ZoomCaptionText, 'string', '100 %');

        else
          set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
            round(diff(handles.xlim100)/diff(handles.xlimFull)*100)));
        end
        setgihandle(saxs);
      end
      
    catch
      errordlg({'Could not open image file', lasterr}, 'Error');
      clearImageAxes;

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(handles.ImageAxes, 'ydir', 'normal')
%    set(handles.CoordinateAxes, 'position', get(handles.ImageAxes, 'position'));
%    set(handles.CoordinateAxes, 'PlotBoxAspectRatio', get(handles.ImageAxes, 'PlotBoxAspectRatio'));
    % Q axis ...............

    %setXYLim

    CoordinateAxes2ImageAxes(saxs)
    
    colorbarCallback;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    set(handles.statusText, 'string', '');
    setColor
    % Set XY lim....
%    setXYLim
%    getXYLim
    
    
  end

%--------------------------------------------------------------------------
% clearImageAxes
%   This clears the image axis
%--------------------------------------------------------------------------
  function clearImageAxes

%    cla(handles.ImageAxes);
%    axis(handles.ImageAxes, 'normal');
    set(get(handles.ImageAxes, 'title') , 'string'        , '');
    set(handles.ImageAxes               , 'buttondownfcn' , '');
    set(handles.ResetViewBtn1           , 'enable'        , 'off');
    set(handles.ResetViewBtn2           , 'enable'        , 'off');
    set(handles.FileInfoBtn             , 'enable'        , 'off', ...
      'value'         , false);
    set(handles.ZoomCaptionText         , 'string'        , '');
    set(handles.MessageTextBox          , 'visible'       , 'off');
    handles.ImX = [];

  end
%--------------------------------------------------------------------------
% clearImageAxes
%   This clears the image axis
%--------------------------------------------------------------------------
  function CoordinateAxes2ImageAxes(varargin)
      if numel(varargin) == 1
          saxs = varargin{1};
      else
          saxs = getgihandle;
      end
      
      xl = get(handles.ImageAxes, 'xlim');
      yl = get(handles.ImageAxes, 'ylim');
      if isfield(saxs, 'center')
          xl = xl - saxs.center(1);
          yl = yl - saxs.center(2);
      end
      if isfield(saxs, 'pxQ');
          xl = xl*saxs.pxQ;
          yl = yl*saxs.pxQ;
      end
      set(handles.CoordinateAxes, 'xlim', xl);
      set(handles.CoordinateAxes, 'ylim', yl);
%      set(handles.CoordinateAxes, 'ydir', 'normal');
      set(handles.CoordinateAxes, 'ydir', get(handles.ImageAxes, 'ydir'));
      set(handles.CoordinateAxes, 'position', get(handles.ImageAxes, 'position'));
      set(handles.CoordinateAxes, 'PlotBoxAspectRatio', get(handles.ImageAxes, 'PlotBoxAspectRatio'));

  end

% short cuts......
    function winKeyPressFcn(varargin)
         src = varargin{1};
         evnt = varargin{2};
         if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & evnt.Key == 'h'
             ImgAnalysis('pb_H_Callback');
         elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & evnt.Key == 'v'
             ImgAnalysis('pb_V_Callback');
         end

         if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'alt') & evnt.Key == 'b'
             val = get(handles.FileListBox, 'value')-1;
             if val>0
                 set(handles.FileListBox, 'value', val);
                 set(handles.SAXSImageViewer, 'selectiontype', 'open')
                 fileListBoxCallback(handles.FileListBox);
             else
                 disp('error: this is the first image');
             end
         end

         if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'alt') & evnt.Key == 'f'
             val = get(handles.FileListBox, 'value')+1;
             if val < numel(get(handles.FileListBox, 'string'))+1
                 set(handles.FileListBox, 'value', val);
                 set(handles.SAXSImageViewer, 'selectiontype', 'open')
                 fileListBoxCallback(handles.FileListBox);
             else
                 disp('error: this is the last image');
             end
         end

         % for multiframe spe file....
         if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'alt') & evnt.Key == '1'
             saxs = getgihandle;
             if ~isfield(saxs, 'frame')
                 saxs.frame = 1;
             else
                 saxs.frame = saxs.frame+1;
             end
             setgihandle(saxs);
             val = get(handles.FileListBox, 'value');
             set(handles.FileListBox, 'value', val);
             set(handles.SAXSImageViewer, 'selectiontype', 'open')
             fileListBoxCallback(handles.FileListBox);
         end

         % for multiframe spe file....
         if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'alt') & evnt.Key == '2'
             saxs = getgihandle;
             if ~isfield(saxs, 'frame')
                 saxs.frame = 1;
             else
                 saxs.frame = saxs.frame-1;
             end
             setgihandle(saxs);
             val = get(handles.FileListBox, 'value');
             set(handles.FileListBox, 'value', val);
             set(handles.SAXSImageViewer, 'selectiontype', 'open')
             fileListBoxCallback(handles.FileListBox);
         end

    end

    function winKeyReleaseFcn(varargin)
         
    end
%--------------------------------------------------------------------------
% winBtnDownFcn
%   This is called when the mouse is clicked in one of the axes
%   NORMAL clicks will start panning mode.
%   ALT clicks will start zooming mode.
%   OPEN clicks will center the view.
%--------------------------------------------------------------------------
  function winBtnDownFcn(varargin)

    obj = varargin{1};
    stopTimer;
    set(handles.MessageTextBox, 'visible', 'off');
    set(handles.FileInfoBtn, 'value', false);

    switch get(handles.SAXSImageViewer, 'selectiontype')
      case 'normal'
        % Start panning mode

        closedHandPointer = [
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,2  ,NaN,2  ,2  ,NaN,2  ,2  ,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,1  ,1  ,2  ,1  ,1  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,1  ,2  ,2  ,1  ,2  ,2  ,1  ,1  ,2  ,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,1  ,2
          NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,NaN,2  ,1  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN
          NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          ];

        xy = get(obj, 'currentpoint');
        set(handles.SAXSImageViewer, ...
          'pointer'               , 'custom', ...
          'pointershapecdata'     , closedHandPointer, ...
          'windowbuttonmotionfcn' , @winBtnMotionFcn);
        set(handles.SAXSImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

      case 'alt'
        % Start zooming mode

        zoomInOutPointer = [
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN
          NaN,2  ,1  ,1  ,1  ,1  ,2  ,NaN,NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN
          2  ,1  ,1  ,1  ,1  ,1  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          2  ,1  ,2  ,1  ,1  ,2  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN,2  ,2  ,2  ,2  ,2  ,2  ,NaN
          2  ,1  ,2  ,1  ,1  ,2  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          2  ,1  ,1  ,1  ,1  ,1  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          NaN,2  ,1  ,1  ,1  ,1  ,2  ,NaN,NaN,2  ,2  ,2  ,2  ,2  ,2  ,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          ];

        xl = get(obj, 'xlim'); midX = mean(xl); rngXhalf = diff(xl) / 2;
        yl = get(obj, 'ylim'); midY = mean(yl); rngYhalf = diff(yl) / 2;
        curPt  = mean(get(obj, 'currentpoint'));curPt = curPt(1:2);
        curPt2 = (curPt-[midX, midY]) ./ [rngXhalf, rngYhalf];
        curPt  = [curPt; curPt];
        curPt2 = [-(1+curPt2).*[rngXhalf, rngYhalf];...
          (1-curPt2).*[rngXhalf, rngYhalf]];
        initPt = get(handles.SAXSImageViewer, 'currentpoint');
        set(handles.statusText, 'string', 'Zooming...');
        set(handles.SAXSImageViewer, ...
          'pointer'               , 'custom', ...
          'pointershapecdata'     , zoomInOutPointer, ...
          'windowbuttonmotionfcn' , @zoomMotionFcn);
        set(handles.SAXSImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

      case 'open'
        % Center the view

        set(handles.SAXSImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

        % Get current units
        un    = get(0, 'units');
        set(0, 'units', 'pixels');
        pt2   = get(0, 'pointerlocation');
        pt    = get(obj, 'currentpoint');
        axPos = get(obj, 'position');
        xl = get(obj, 'xlim'); midX = mean(xl);
        yl = get(obj, 'ylim'); midY = mean(yl);

        % update figure position in case it was moved
        handles.figPos = get(handles.SAXSImageViewer, 'position');

        % get distance between cursor and center of axes
        d = norm(pt2 - (handles.figPos(1:2) + axPos(1:2) + axPos(3:4)/2));

        if d > 2  % center only if distance is at least 2 pixels away
          ld = (mean(pt(:, 1:2)) - [midX, midY]) / 10;
          pd = ((handles.figPos(1:2) + axPos(1:2) + axPos(3:4) / 2) - pt2) / 10;

          set(handles.statusText, 'string', 'Centering...');

          % Animate with "good" speed
          for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

            % Set axes limits and automatically set ticks
            % Set aspect ratios
            set(obj, ...
              'xlim'                , xl + id * ld(1), ...
              'ylim'                , yl + id * ld(2), ...
              'cameraviewanglemode' , 'auto', ...
              'dataaspectratiomode' , 'auto', ...
              'plotboxaspectratio'  , handles.pbar);

            % Move pointer with limits
            set(0, 'pointerlocation', pt2 + id * pd);

            pause(0.01);
          end

        end

        % Reset UNITS
        set(0, 'units', un);
        
        % Read XY lim to text edit box ...
        getXYLim

    end

    %----------------------------------------------------------------------
    % winBtnMotionFcn (nested under winBtnDownFcn)
    %   This function is called when click-n-drag (panning) is happening
    %----------------------------------------------------------------------
    function winBtnMotionFcn(varargin)

      pt = get(handles.ImageAxes, 'currentpoint');

      % Update axes limits and automatically set ticks
      % Set aspect ratios
      set(handles.ImageAxes, ...
        'xlim', get(handles.ImageAxes, 'xlim') + (xy(1,1)-(pt(1,1)+pt(2,1))/2), ...
        'ylim', get(handles.ImageAxes, 'ylim') + (xy(1,2)-(pt(1,2)+pt(2,2))/2), ...
        'plotboxaspectratio'  , handles.pbar);
    
      % Q axis....
      CoordinateAxes2ImageAxes
      set(handles.CoordinateAxes, 'plotboxaspectratio', get(handles.ImageAxes, 'plotboxaspectratio'));
      set(handles.statusText, 'string', 'Panning...');
        
      % Read XYlim to edit box
      getXYLim

    end


    %----------------------------------------------------------------------
    % zoomMotionFcn (nested under winBtnDownFcn)
    %   This performs the click-n-drag zooming function. The pointer
    %   location relative to the initial point determines the amount of
    %   zoom (in or out).
    %----------------------------------------------------------------------
    function zoomMotionFcn(varargin)

      % Power law allows for the inverse to work:
      %      C^(x) * C^(-x) = 1
      % Choose C to get "appropriate" zoom factor
      C                   = 50;
      obj                 = varargin{1};
      pt                  = get(obj, 'currentpoint');
      r                   = C ^ ((initPt(2) - pt(2)) / handles.figPos(4));
      newLimSpan          = r * curPt2; dTemp = diff(newLimSpan);
      pt(1)               = initPt(1);

      % Determine new limits based on r
      lims                = curPt + newLimSpan;

      % Update axes limits and automatically set ticks
      % Set aspect ratios
      set(handles.ImageAxes, ...
        'xlim'                , lims(:,1), ...
        'ylim'                , lims(:,2), ...
        'plotboxaspectratio'  , handles.pbar);

    % Q axis .................
    CoordinateAxes2ImageAxes;
    
    % Read xylim to edit box
    getXYLim
    
    set(handles.CoordinateAxes, 'plotboxaspectratio', get(handles.ImageAxes, 'plotboxaspectratio'));
 
      % Update zoom indicator line
%      get(handles.ZoomLine)
      set(handles.ZoomLine, ...
        'xdata', [initPt(1), pt(1)]/handles.figPos(3), ...
        'ydata', [initPt(2), pt(2)]/handles.figPos(4));
      set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
        round(diff(handles.xlim100)/dTemp(1)*100)));

    end

  end


%--------------------------------------------------------------------------
% winBtnUpFcn
%   This is called when the mouse is released
%--------------------------------------------------------------------------
  function winBtnUpFcn(varargin)
    obj = varargin{1};
    set(obj, ...
      'pointer'               , 'arrow', ...
      'windowbuttonmotionfcn' , '');
    set(handles.statusText, 'string', '');
    set(handles.ZoomLine, 'xdata', NaN, 'ydata', NaN);
    set(handles.SAXSImageViewer, 'windowbuttonupfcn', '');

    startTimer;

  end


%--------------------------------------------------------------------------
% startTimer
%   This starts the timer. If the timer object is invalid, it creates a new
%   one.
%--------------------------------------------------------------------------
  function startTimer

    try

      if ~strcmpi(handles.tm.Running, 'on');
        start(handles.tm);
      end

    catch

      handles.tm          = timer(...
        'name'            , 'image preview timer', ...
        'executionmode'   , 'fixedspacing', ...
        'objectvisibility', 'off', ...
        'taskstoexecute'  , inf, ...
        'period'          , 0.001, ...
        'startdelay'      , 3, ...
        'timerfcn'        , @getPreviewImages);
      start(handles.tm);

    end

  end


%--------------------------------------------------------------------------
% stopTimerFcn
%   This gets called when the figure is closed.
%--------------------------------------------------------------------------
  function stopTimerFcn(varargin)
    if ~ishandle(handles)
        return
    end
    stop(handles.tm);
    % wait until timer stops
    while ~strcmpi(handles.tm.Running, 'off')
      drawnow;
    end
    delete(handles.tm);

  end


%--------------------------------------------------------------------------
% stopTimer
%   This stops the timer object used for generating image previews
%--------------------------------------------------------------------------
  function stopTimer(varargin)

    stop(handles.tm);

    % wait until timer stops
    while ~strcmpi(handles.tm.Running, 'off')
      drawnow;
    end

    set(handles.statusText, 'string', '');

  end


%--------------------------------------------------------------------------
% readImageFileFcn
%   This function reads in the image file and converts to TRUECOLOR
%--------------------------------------------------------------------------
  function [x, info] = readImageFileFcn(filename)
    try
      [x, mp] = imread(filename);
      try
        info = imfinfo(filename);
        info = info(1);
      catch
        info.ColorType = 'marCCD'; % for marccd data... % Byeongdu added.
      end

      switch info.ColorType
        case 'grayscale'
          switch class(x)
            case 'logical'
              x = uint8(x);
              mp = [0 0 0;1 1 1];

            case 'uint8'
              mp = gray(256);

            case 'uint16'
              mp = gray(2^16);

            case {'double','single'}
              cmapsz = size(get(handles.SAXSImageViewer, 'Colormap'), 1);
              mp = gray(cmapsz);

            case 'int16'
              x = double(x)+2^15;
              x = uint16((x-min(x(:)))/(max(x(:))-min(x(:)))*(2^16));
              mp = gray(2^16);

            otherwise
              cmapsz = size(get(handles.SAXSImageViewer, 'Colormap'), 1);
              mp = gray(cmapsz);
          end
%          x = ind2rgb(x, mp);

        case 'indexed'
          if isempty(mp)
            mp = info.Colormap;
          end
          x = ind2rgb(x, mp);

        case 'marCCD'
%            disp('what is problem?')
%            mp = gray(2^16);
        case 'truecolor'
            disp('This is ture color image')
            disp('response from imageviewer2.m')
        otherwise
      end

    catch
      x = NaN;
      info = [];

    end
  end


%% mouse move callback
% read data values....
function gtrack_OnMouseMove(src,evnt)

% get mouse position
    pt = get(handles.ImageAxes, 'CurrentPoint');
    xInd = round(pt(1, 1));
    yInd = round(pt(1, 2));
    texthandles = findobj(handles.ImageAxes, 'type', 'text');
    if ~isempty(texthandles)
    try
        pd = evalin('base', 'peakdata');
        px = abs([pd(:).qp]-xInd);
        py = abs([pd(:).qz]-yInd);
        xp = find(px == min(px));
        yp = find(py == min(py));
        peak = intersect(xp, yp);
        if ~isempty(peak)
            disp(sprintf('Mouse is on the peak %s\n', pd(peak).string))
        end
    catch
        pd = [];
    end
    end
% check if its within axes limits
    xLim = get(handles.ImageAxes, 'XLim');	
    yLim = get(handles.ImageAxes, 'YLim');
    if xInd < xLim(1) | xInd > xLim(2)
    	pos_valuestr = ['Out of X limit'];	
    	return;
    end
    if yInd < yLim(1) | yInd > yLim(2)
    	pos_valuestr = ['Out of Y limit'];
    	return;
    end

% read intensity value....
    try
%    ImValue = interp2(handles.ImX, xInd, yInd);
%        imsize = size(handles.ImX);
        ImValue = handles.ImX(yInd, xInd);
    catch
        ImValue = NaN;
    end

% update figure title
    try
        pos_valuestr = ['X = ' num2str(xInd,handles.titleFmt) ', Y = ' num2str(yInd,handles.titleFmt) ', Z = ' num2str(ImValue,handles.titleFmt)];
% possibility of wrong format strings...
    catch
        gtrack_Off()
    	error('GTRACK: Error printing coordinates. Check that you used a valid format string.')
    end
    set(handles.DisplayInfo, 'string', pos_valuestr);
    
    % save selected point
    handles.MousexInd = xInd;
    handles.MouseyInd = yInd;
    handles.MousezInd = ImValue;
    
    % transferring currentpoint to imganalysis figure and calculate q
    % positions....
    t = findobj('tag', 'GIImgAnalysis');
    if ~isempty(t)
        analhandle = guihandles(t);
        set(analhandle.ed_LCx, 'string', num2str(xInd));
        set(analhandle.ed_LCy, 'string', num2str(yInd));
        imganalysis('pb_coordDown_Callback');
    end
end


% mouse click callback
function gtrack_OnMouseDown(src,evnt)

% if left button, terminate

    switch get(handles.SAXSImageViewer, 'selectiontype')
        case 'normal'
            Xp = handles.selectedX;
            Yp = handles.selectedY;
            Xp = [Xp,handles.MousexInd];
            Yp = [Yp,handles.MouseyInd];
            handles.selectedX = Xp;
            handles.selectedY = Yp;
        case 'extend'
            gtrack_Off
        case 'alt'
            gtrack_Off
%            winBtnDownFcn(handles.ImageAxes);
        otherwise
    end
end


% terminate callback
function gtrack_Off(src,evnt)

% restore default figure properties
set(figH, 'windowbuttonmotionfcn', handles.currFcn);
set(figH, 'windowbuttondownfcn', handles.currFcn2);
set(figH,'Pointer','arrow');
%title(handles.currTitle);
uirestore(handles.theState);
handles.ID=0;
set(handles.ToggleReadValue, 'state', 'off');

end
% terminate callback

function gtrack_start(varargin)
%src,evnt
    handles.titleFmt = '%3.5f';
    % get current figure event functions
    currFcn = get(figH, 'windowbuttonmotionfcn');
    currFcn2 = get(figH, 'windowbuttondownfcn');
%    currTitle = get(get(gca, 'Title'), 'String');
% add data to figure handles
    if (isfield(handles,'ID') & handles.ID==1)
        disp('gtrack is already active.');
        return;
    else
        handles.ID = 1;
    end
    if ~isfield(handles, 'selectedX')
        handles.selectedX = [];
        handles.selectedY = [];
    end
    %
    handles.currFcn = currFcn;
    handles.currFcn2 = currFcn2;
%    handles.currTitle = currTitle;
    handles.theState = uisuspend(figH);

% set event functions 
    set(gcf,'Pointer','crosshair');
    set(gcf, 'windowbuttonmotionfcn', @gtrack_OnMouseMove);        
    set(gcf, 'windowbuttondownfcn', @gtrack_OnMouseDown);          
end

function loglinConvert(varargin)
%src,evnt

action = varargin{3};

    if strcmp(action,'log')
%        ImgUser = get(findobj(gca, 'Type', 'image'), 'CData');
        tmp = log10(abs(double(handles.ImX)+eps));
        set(handles.iH, 'Cdata', tmp);
 %       set(XHR_HANDLES.done, 'string', 'lin')
 %       set(XHR_HANDLES.done, 'CallBack', 'loglin(''lin'');')
    elseif strcmp(action, 'lin')
        set(handles.iH, 'Cdata', handles.ImX);
    end

end

 function findcenterCallback(varargin)
     action = varargin{3};
     switch lower(action)
         case 'on'
            % get current figure event functions
            if ~isfield(handles, 'selectedX')
                disp('please selected points on AgBH, and then press this button to fit and display')
                return
            end
            if numel(handles.selectedX) < 3
                disp(sprintf('Currently %d points are selected, but it should be at least 3\nIt has been reset, try again', numel(handles.selectedX)))
                handles.selectedX = [];
                handles.selectedY = [];
                return
            end
             th = linspace(0,2*pi,360)';
             handles.crtImageAxes = get(handles.ImageAxes, 'nextplot');
             set(handles.ImageAxes, 'nextplot', 'add');
             handles.tmpPlothandle = plot(handles.selectedX, handles.selectedY,'o', 'parent', handles.ImageAxes);
   
            % reconstruct circle from data
            [xc,yc,Re,a] = circfit(handles.selectedX, handles.selectedY);
            xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;
    
            tmph = plot([xe;xe(1)],[ye;ye(1)],'-', 'parent', handles.ImageAxes);
            handles.tmpPlothandle = [handles.tmpPlothandle, tmph];
%             title(' measured fitted and true circles')
%      legend('measured','fitted','true')
            tmph = text(handles.selectedX(1),handles.selectedY(1),sprintf('center (%g , %g );  R=%g',xc,yc,Re), 'parent', handles.ImageAxes);
            handles.tmpPlothandle = [handles.tmpPlothandle, tmph];
         case 'off'
            if ~isfield(handles, 'tmpPlothandle')
                disp('please selected points on AgBH, and then press this button to fit and display')
                return
            end             
             delete(handles.tmpPlothandle);
             handles = rmfield(handles, 'tmpPlothandle');
             set(handles.ImageAxes, 'nextplot', handles.crtImageAxes);
        % to save selected points by clicking left mouse button
            handles.selectedX = [];
            handles.selectedY = [];
             
         otherwise
             
     end
 end

function azimangle_start(varargin)
%src,evnt
    handles.titleFmt = '%3.5f';
    % get current figure event functions
    currFcn = get(figH, 'windowbuttonmotionfcn');
    currFcn2 = get(figH, 'windowbuttondownfcn');
%    currTitle = get(get(gca, 'Title'), 'String');
% add data to figure handles
    if (isfield(handles,'ID') & handles.ID == 2)
        disp('Azimangle is already active.');
        return;
    else
        handles.ID = 2;
    end
    if ~isfield(handles, 'selectedX')
        handles.selectedX = [];
        handles.selectedY = [];
        handles.azimlinehandle = [];
    end
    %
    handles.currFcn = currFcn;
    handles.currFcn2 = currFcn2;
%    handles.currTitle = currTitle;
    handles.theState = uisuspend(figH);

% set event functions 
    set(gcf,'Pointer','crosshair');
    set(gcf, 'windowbuttonmotionfcn', @azimangle_OnMouseMove);        
    set(gcf, 'windowbuttondownfcn', @azimangle_OnMouseDown);          
end

% terminate callback
function azimangle_Off(src,evnt)

% restore default figure properties
set(figH, 'windowbuttonmotionfcn', handles.currFcn);
set(figH, 'windowbuttondownfcn', handles.currFcn2);
set(figH,'Pointer','arrow');
%title(handles.currTitle);
uirestore(handles.theState);
handles.ID=0;
set(handles.Toggleazimangle, 'state', 'off');
    if isfield(handles, 'azimlinehandle');
        if numel(handles.azimlinehandle) > 0
            try
                delete(handles.azimlinehandle);
            catch
                handles.azimlinehandle = [];
            end
%            handles = rmfield(handles, 'azimlinehandle');
        end
    end
end
%% mouse move callback
% read data values....
function azimangle_OnMouseMove(src,evnt)

% get mouse position
    pt = get(handles.ImageAxes, 'CurrentPoint');
    xInd = round(pt(1, 1));
    yInd = round(pt(1, 2));

% check if its within axes limits
    xLim = get(handles.ImageAxes, 'XLim');	
    yLim = get(handles.ImageAxes, 'YLim');
    if xInd < xLim(1) | xInd > xLim(2)
    	pos_valuestr = ['Out of X limit'];	
    	return;
    end
    if yInd < yLim(1) | yInd > yLim(2)
    	pos_valuestr = ['Out of Y limit'];
    	return;
    end

% read intensity value....
    try
%    ImValue = interp2(handles.ImX, xInd, yInd);
%        imsize = size(handles.ImX);
        ImValue = handles.ImX(yInd, xInd);
    catch
        ImValue = NaN;
    end

% update figure title
    try
        pos_valuestr = ['X = ' num2str(xInd,handles.titleFmt) ', Y = ' num2str(yInd,handles.titleFmt) ', Z = ' num2str(ImValue,handles.titleFmt)];
% possibility of wrong format strings...
    catch
        azimangle_Off()
    	error('AZimangle: Error printing coordinates. Check that you used a valid format string.')
    end
    set(handles.DisplayInfo, 'string', pos_valuestr);
    
    % save selected point
    handles.MousexInd = xInd;
    handles.MouseyInd = yInd;
    handles.MousezInd = ImValue;
    
    % transferring currentpoint to imganalysis figure and calculate q
    % positions....
%    t = findobj('tag', 'GIImgAnalysis');
%    if ~isempty(t)
%        analhandle = guihandles(t);
%        set(analhandle.ed_LCx, 'string', num2str(xInd));
%        set(analhandle.ed_LCy, 'string', num2str(yInd));
%        imganalysis('pb_coordDown_Callback');
%    end
    
    if isfield(handles, 'azimlinehandle');
        if numel(handles.selectedX) >= 1
            px = handles.selectedX(end);
            py = handles.selectedY(end);
            Xp = [px, xInd]; Yp = [py, yInd];
            if numel(handles.azimlinehandle) == numel(handles.selectedX)-1
                lhn = line(Xp, Yp);
                handles.azimlinehandle = [handles.azimlinehandle, lhn];
            end
            if ~isempty(handles.azimlinehandle)
                set(handles.azimlinehandle(end), 'xdata', Xp);
                set(handles.azimlinehandle(end), 'ydata', Yp);
            end
        end
    end
end

% mouse click callback
function azimangle_OnMouseDown(src,evnt)

% if left button, terminate

    switch get(handles.SAXSImageViewer, 'selectiontype')
        case 'normal'
            Xp = handles.selectedX;
            Yp = handles.selectedY;
            Xp = [Xp,handles.MousexInd];
            Yp = [Yp,handles.MouseyInd];
            handles.selectedX = Xp;
            handles.selectedY = Yp;
%            if (numel(Xp) > 1) & (numel(Xp) <= 3)
%                lhn = line([Xp(end-1), Xp(end)], [Yp(end-1), Yp(end)]);
%                handles.azimlinehandle = [handles.azimlinehandle, lhn]
%            end
            if (numel(Xp) <= 1)
                if isfield(handles, 'azimlinehandle');
                    delete(handles.azimlinehandle);
                end
                handles.azimlinehandle = [];
            end
            if (numel(Xp) == 3)
                p1 = [Xp(1)-Xp(2),Yp(1)-Yp(2), 0];
                p2 = [Xp(3)-Xp(2),Yp(3)-Yp(2), 0];
                ang = angle2vect(p1, p2);
                tmp = sprintf('Azimuthal angle is %0.2f', ang);
                disp(tmp);
                handles.selectedX = [];
                handles.selectedY = [];
            end
        case 'extend'
            azimangle_Off
        case 'alt'
            azimangle_Off
%            winBtnDownFcn(handles.ImageAxes);
        otherwise
    end
end

        
%% --- end nested functions -----------------------------------------------

end % end everything
