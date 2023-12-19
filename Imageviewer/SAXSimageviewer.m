function SAXSimageviewer(varargin)

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
% 
% Modified for SAXS/GISAXS use by Byeongdu Lee
% To make an App, include the following files.
% C:\Users\blee\Google Drive\mytool\1DSAXS\GUI\SG_icons.mat
% C:\Users\blee\Google Drive\mytool\GiSAXS\GUI2\mycolorbaricon.mat
% C:\Users\blee\Google Drive\mytool\GiSAXS\GUI2\icons\*

 
warning off
%verNumber = '8/28/2019';
verNumber = '8/8/2023';

if nargin == 0
  dirname0 = pwd;
%  filename0 = [];
else
    dirname0 = pwd;
    filename0 = varargin{1};
    figHini = findobj('type', 'figure', 'tag', 'SAXSImageViewer');
    if ~isempty(figHini)
        guidata(figHini);
    else
        SAXSimageviewer;
        figHini = findobj('type', 'figure', 'tag', 'SAXSImageViewer');
        guihandles(figHini);
    end
    
    if ischar(varargin{1})
        if ~ischar(dirname0) || ~isdir(dirname0)
            error('Invalid input argument.\n  Syntax: %s(IMAGE FILE NAME)', upper(mfilename));
        end
        tmpimg = dir(filename0);
        if isempty(tmpimg)
            filename0 = fullfile(dirname0, filename0);
        end
    end

    loadImage(filename0);

    drawnow;
    return
end

delete(findall(0, 'type', 'figure', 'tag', 'SAXSImageViewer'));


figHini = init_viewer(verNumber);
udf0.figPos      = [];
udf0.axPos       = [];
udf0.lastDir     = dirname0;
setappdata(figHini, 'tmpdata', udf0);
    
% ===================================================       

handles0             = guihandles(figHini);
linkprop([handles0.ImageAxes, handles0.CoordinateAxes], 'position');
linkprop([handles0.ImageAxes, handles0.CoordinateAxes], 'PlotBoxAspectRatio');
guidata(figHini, handles0);

resizeFcn(figHini);

handles0 = guidata(figHini);

% Show initial directory
showDirectory(figHini);
%guidata(figH, handles)
set(figHini, 'visible', 'on');
%figHcolormap = jet;

% save handles of SAXSimageviewer to workspace.
assignin('base', 'SAXSimageviewerhandle', figHini);
assignin('base', 'SAXSimagehandle', handles0.ImageAxes);

% plot input images if provided..
%if ~isempty(filename)
%    loadImage(filename);
%end
% plot input images if provided..
if ~isempty(varargin)
    loadImage(varargin{:});
end


%% Nested function
    function figH = init_viewer(verNumber)
        % These iconds are at 1DSAXS/Gui
        icons = load('SG_icons.mat');
        
        bgcolor1 = [1 1 1];
        %bgcolor1 = [.8 .8 .8];
        bgcolor2 = [.7 .7 .7];
        txtcolor = [.3 .3 .3];
%         figHcolormap1 = [    1.0000    1.0000    1.0000
%             1.0000    1.0000    1.0000
%             1.0000    0.9176    0.9294
%             1.0000    0.8431    0.8902
%             1.0000    0.7647    0.8706
%             1.0000    0.6902    0.8784
%             1.0000    0.6118    0.9059
%             1.0000    0.5373    0.9608
%             0.9608    0.4588    1.0000
%             0.8588    0.3843    1.0000
%             0.7373    0.3059    1.0000
%             0.5882    0.2314    1.0000
%             0.4157    0.1529    1.0000
%             0.2196    0.0784    1.0000
%                  0         0    1.0000
%                  0    0.1098    1.0000
%                  0    0.2235    1.0000
%                  0    0.3333    1.0000
%                  0    0.4431    1.0000
%                  0    0.5569    1.0000
%                  0    0.6667    1.0000
%                  0    0.7765    1.0000
%                  0    0.8902    1.0000
%                  0    1.0000    1.0000
%                  0    1.0000    0.8902
%                  0    1.0000    0.7765
%                  0    1.0000    0.6667
%                  0    1.0000    0.5569
%                  0    1.0000    0.4431
%                  0    1.0000    0.3333
%                  0    1.0000    0.2235
%                  0    1.0000    0.1098
%                  0    1.0000         0
%                  0    1.0000         0
%                  0    1.0000         0
%             0.1020    1.0000         0
%             0.2000    1.0000         0
%             0.2980    1.0000         0
%             0.4000    1.0000         0
%             0.5020    1.0000         0
%             0.6000    1.0000         0
%             0.7020    1.0000         0
%             0.8000    1.0000         0
%             0.9020    1.0000         0
%             1.0000    1.0000         0
%             1.0000    0.8902         0
%             1.0000    0.7765         0
%             1.0000    0.6667         0
%             1.0000    0.5569         0
%             1.0000    0.4431         0
%             1.0000    0.3333         0
%             1.0000    0.2235         0
%             1.0000    0.1098         0
%             1.0000         0         0
%             1.0000         0    0.1098
%             0.9804         0    0.0706
%             0.9608         0    0.0353
%             0.9412    0.0039         0
%             0.7529    0.1529    0.1490
%             0.5647    0.2275    0.2275
%             0.3765    0.2275    0.2275
%             0.1882    0.1490    0.1490
%                  0         0         0
%                  0         0         0];
        %  colormap Jet.
        figHcolormap2 =         [0         0    0.5625
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

%          'deletefcn'                     , @stopTimerFcn, ...

        figH = figure(...
          'visible'                       , 'off', ...
          'integerhandle'                 , 'off', ...
          'units'                         , 'normalized', ...
          'busyaction'                    , 'queue', ...
          'color'                         , bgcolor1, ...
          'colormap'                      , figHcolormap2, ...
          'createfcn'                     , @winCreateFcn, ...
          'keypressfcn'                   , @winKeyPressFcn, ...
          'doublebuffer'                  , 'on', ...
          'handlevisibility'              , 'callback', ...
          'IntegerHandle'                 , 'off',...
          'interruptible'                 , 'on', ...
          'menubar'                       , 'none', ...
          'name'                          , upper(mfilename), ...
          'numbertitle'                   , 'off', ...
          'resize'                        , 'on', ...
          'CloseRequestFcn'               , @SAXSimage_CloseRequestFcn,...  
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
          'string'                    , sprintf('Last updated: %s', verNumber), ...
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
          'horizontalalignment'       , 'left', ...
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
%         uicontrol(...
%           'style'                     , 'pushbutton', ...
%           'backgroundcolor'           , bgcolor2, ...
%           'string'                    , 'Fix Scale', ...
%           'fontweight'                , 'bold', ...
%           'callback'                  , @mnplot_qaxis, ...
%           'enable'                    , 'on', ...
%           'parent'                    , figH, ...
%           'tag'                       , 'qaxisBtn');
%         uicontrol(...
%           'style'                     , 'togglebutton', ...
%           'backgroundcolor'           , bgcolor2, ...
%           'string'                    , 'File Info', ...
%           'fontweight'                , 'bold', ...
%           'callback'                  , @fileInfoBtnCallback, ...
%           'enable'                    , 'off', ...
%           'parent'                    , figH, ...
%           'tag'                       , 'FileInfoBtn');
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
          'callback'                  , @DirListBoxCallback, ...
          'fontname'                  , 'FixedWidth', ...
          'parent'                    , figH, ...
          'tag'                       , 'DirListBox');
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

        % preview panel ===============================================
        uph(5) = uipanel(...
          'units'                     , 'pixels', ...
          'bordertype'                , 'etchedout', ...
          'backgroundcolor'           , bgcolor1, ...
          'fontname'                  , 'Verdana', ...
          'fontsize'                  , 10, ...
          'fontweight'                , 'bold', ...
          'title'                     , 'Color Scale & Image Zoom', ...
          'titleposition'             , 'centertop', ...
          'parent'                    , figH, ...
          'tag'                       , 'PreviewImagePanel');

%         axes(...
%           'handlevisibility'          , 'callback', ...
%           'parent'                    , uph(5), ...
%           'visible'                   , 'off', ...
%           'tag'                       , 'PreviewImageAxes');
% 
        ubg(1) = uibuttongroup(...
          'visible'                   ,'on', ...
          'backgroundcolor'           , bgcolor1,...
          'parent'                    ,uph(5),...
          'SelectionChangeFcn'        , @selcbk, ...
          'SelectedObject'            , [], ...
          'Tag'                       , 'ColorScaleGroup');
        %  'Position'                  ,[0 0 .2 1]);
        uicontrol(...
          'style'                     , 'radiobutton', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(1), ...
          'string'                    , 'auto',...
          'tag'                       , 'AutoColor');
        %  'SelectionChangeFcn'        , @AutoColorCallback, ...
        uicontrol(...
          'style'                     , 'radiobutton', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(1), ...
          'string'                    , 'Manual',...
          'tag'                       , 'ManualColor');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(1), ...
          'callback'                  , @ManualColorEdit, ...
          'tag'                       , 'ColorLowLim');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(1), ...
          'callback'                  , @ManualColorEdit, ...
          'tag'                       , 'ColorHighLim');

        ubg(2) = uibuttongroup(...
          'visible'                   ,'on', ...
          'backgroundcolor'           , bgcolor1,...
          'parent'                    ,uph(5),...
          'SelectionChangeFcn'        , @selcImgSize, ...
          'SelectedObject'            , [], ...
          'Tag'                       , 'XYLimGroup');
        %  'Position'                  ,[0 0 .2 1]);
        uicontrol(...
          'style'                     , 'radiobutton', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'auto',...
          'tag'                       , 'AutoXYLim');
        %  'SelectionChangeFcn'        , @AutoColorCallback, ...
        uicontrol(...
          'style'                     , 'radiobutton', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'Manual',...
          'tag'                       , 'ManualXYLim');
        uicontrol(...
          'style'                     , 'text', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'min', ...
          'tag'                       , 'txtscaleMin');
        uicontrol(...
          'style'                     , 'text', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'max', ...
          'tag'                       , 'txtscaleMax');
        uicontrol(...
          'style'                     , 'text', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'center', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'X', ...
          'tag'                       , 'txtscaleX');
        uicontrol(...
          'style'                     , 'text', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'center', ...
          'parent'                    , ubg(2), ...
          'string'                    , 'Y', ...
          'tag'                       , 'txtscaleY');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'callback'                  , @ManualXYLimEdit, ...
          'tag'                       , 'XLowLim');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'callback'                  , @ManualXYLimEdit, ...
          'tag'                       , 'YLowLim');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'callback'                  , @ManualXYLimEdit, ...
          'tag'                       , 'XHighLim');
        uicontrol(...
          'style'                     , 'edit', ...
          'backgroundcolor'           , bgcolor1, ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , ubg(2), ...
          'callback'                  , @ManualXYLimEdit, ...
          'tag'                       , 'YHighLim');

        axes(...
          'box'                       , 'off', ...
          'fontname'                  , 'Verdana', ...
          'fontsize'                  , 14, ...
          'XAxisLocation'             ,'top',...
          'YAxisLocation'             ,'right',...  
          'handlevisibility'          , 'callback', ...
          'parent'                    , figH, ...
          'color'                      , [1,1,0], ...
          'tag'                       , 'ImageAxes');
%          'DataAspectRatio'           , [1,1,1], ...

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
          'tag'                       , 'CoordinateAxes');
%          'DataAspectRatio'           , [1,1,1], ...

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
          'tag'                       , 'InvisibleAxes');
%          'DataAspectRatio'           , [1,1,1], ...

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
 
        uicontrol(...
          'style'                     , 'text', ...
          'backgroundcolor'           , [1,1,1], ...
          'horizontalalignment'       , 'left', ...
          'parent'                    , figH, ...
          'tag'                       , 'DisplayCoordInfo');

       %% Menu
        hMenuDet = uimenu(figH,...
            'Label','Epics',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuDet');

        hMenuPilatus = uimenu(hMenuDet,...
            'Label','Pilatus2M...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuDetPilatus',...,
            'checked', 'off',...
            'callback',{@chooseDet, 'Pilatus2M'});
         hMenuPilatus = uimenu(hMenuDet,...
            'Label','Eiger9M...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuDetPilatus',...,
            'checked', 'off',...
            'callback',{@chooseDet, 'Eiger9M'});
      
        hMenuPE = uimenu(hMenuDet,...
            'Label','PerkinElmer...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuDetPE',...,
            'checked', 'off',...
            'callback',{@chooseDet, 'PE'});
        hMenuPE = uimenu(hMenuDet,...
            'Label','Mar 300...',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuDetMar300',...,
            'checked', 'off',...
            'callback',{@chooseDet, 'Mar300'});
        
        function chooseDet(varargin)
            src = varargin{1};
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                stopmonitor;
            else
                src.Checked = 'on';
                startmonitor(varargin{3});
            end
        end

        
        hMenuView = uimenu(figH,...
            'Label','&View',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuView');
        hMenuViewlog = uimenu(hMenuView,...
            'Label','&Log Scale...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuViewLog',...
            'Accelerator','g',...
            'callback',{@loglinConvert, 'log'});
        hMenuViewlinear = uimenu(hMenuView,...
            'Label','&Linear Scale...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuViewLinear',...
            'Accelerator','l',...
            'callback',{@loglinConvert, 'lin'});
        hMenuViewColorbar = uimenu(hMenuView,...
            'Label','Color Bar...',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuViewColorbar',...
            'checked','off',...
            'callback',@menuviewColorCallblack);
            
        function menuviewColorCallblack(src,event)
            obj = findobj(gcbf, 'tag', 'ToggleColorbar');
            if strcmp(src.Checked,'on')
                set(obj, 'state', 'off');
                src.Checked = 'off';
            else
                set(obj, 'state', 'on');
                src.Checked = 'on';
            end
        end

        hMenuResetAxis = uimenu(hMenuView,...
            'Label','Reset XY Axis...',...
            'Position',4,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuResetAxis',...
            'callback',@setXYLim);
        
        hMenuPlayImage = uimenu(hMenuView,...
            'Label','Play FileList...',...
            'Position',5,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuPlayImages',...
            'callback',@playimages);
        
%         uimenu(hcmenu,'Label','Set current image as Background','Callback',@uimenu_setbackground);
%         uimenu(hcmenu,'Label','Set current image as Air','Callback',@uimenu_setEmpty);
%         uimenu(hcmenu,'Label','Show Region of Interest','Callback',@uimenu_showRegionofInterest);
%         uimenu(hcmenu,'Label','Set current image as mask','Callback',@uimenu_setmask);
       
        hMenuSet = uimenu(figH,...
            'Label','Background',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Enable', 'on',...
            'Tag','SSL_MenuSet');
        hMenuSetBack = uimenu(hMenuSet,...
            'Label','Set current image as Background...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuSetBack',...
            'callback',@uimenu_setbackground); 
        hMenuSetAir = uimenu(hMenuSet,...
            'Label','Set current image as Air...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuSetAir',...
            'callback',@uimenu_setEmpty); 
        hMenuSetMask = uimenu(hMenuSet,...
            'Label','Set current image as Mask...',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuSetMask',...
            'callback',@uimenu_setmask); 
        
        
        hMenuMouse = uimenu(figH,...
            'Label','&Mouse',...
            'Position',5,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMouse');
        hMenuMouseRead = uimenu(hMenuMouse,...
            'Label','Read Mouse Clicks...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMouseRead',...
            'checked', 'off', ...
            'callback',@ReadMousePnts);
        
        hMenuCoordination = uimenu(figH,...
            'Label','&Setting',...
            'Position',4,...
            'HandleVisibility','callback',...
            'Tag','SSL_SetCoordinate');

        function setcoordinate(varargin)
            src = varargin{1};
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                theotherstatus = 'on';
            else
                src.Checked = 'on';
                theotherstatus = 'off';
            end
            if varargin{3} == 0
                obj = findobj(gcbf, 'Tag', 'SSL_RightHandCoordinate');
                set(obj, 'checked', theotherstatus)
            else
                obj = findobj(gcbf, 'Tag', 'SSL_LeftHandCoordinate');
                set(obj, 'checked', theotherstatus)
            end
            obj = findobj(gcbf, 'Tag', 'SSL_RightHandCoordinate');
            saxs = get(figH, 'userdata');
            if get(obj, 'checked')
                saxs.coordinationsystem = 'right';
            else
                saxs.coordinationsystem = 'left';
            end
            set(figH, 'userdata', saxs);
        end

        hMenuLeftHandCoordinate = uimenu(hMenuCoordination,...
            'Label','Left Hand Coordination System...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_LeftHandCoordinate',...
            'checked', 'on', ...
            'callback', {@setcoordinate, 0});

        hMenuRightHandCoordinate = uimenu(hMenuCoordination,...
            'Label','Right Hand Coordination System...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_RightHandCoordinate',...
            'checked', 'off', ...
            'callback',{@setcoordinate, 1});
        

        function ReadMousePnts(src,event)
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                datakeepertoggleup;
            else
                src.Checked = 'on';
                fitpeaktoggledown;
            end
        end

        hMenuMouseShow = uimenu(hMenuMouse,...
            'Label','Show Mouse Selects...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMouseShow',...
            'Checked', 'off',...
            'callback',@ShowMouseSelects);

        function ShowMouseSelects(src,event)
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                clearSelPeaks;
            else
                src.Checked = 'on';
                showSelPeaks;
            end
        end

        hMenuMouseRemoveSel = uimenu(hMenuMouse,...
            'Label','Clear Mouse Selects...',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMouseRemoveSel',...
            'callback',@RemoveMouseSelects);


        hMenuMouseCircleFit = uimenu(hMenuMouse,...
            'Label','Fit the Selected to a Circle...',...
            'Position',4,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMouseCircleFit',...
            'Separator', 'on',...,
            'Checked', 'off',...
            'callback',@menuFitCircle);

        function menuFitCircle(src,event)
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                findcenterCallback(src, event, 'off');
            else
                src.Checked = 'on';
                findcenterCallback(src, event, 'on');
            end
        end

        
        hMenuTools = uimenu(figH,...
            'Label','&Tools',...
            'Position',6,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuTool');
        hMenuFitAgBH = uimenu(hMenuTools,...
            'Label','Fit SAXS AgBehenate...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuFitAgBH',...
            'callback',@agbhSAXScalibrate);
        hMenuAbs = uimenu(hMenuTools,...
            'Label','Find Absolute Scale Factor...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuViewLog',...
            'callback',@gcfit);
        hMenuMask = uimenu(hMenuTools,...
            'Label','Overlay a matrix "tmpmask"...',...
            'Position',3,...
            'Separator', 'on',...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMask',...
            'callback',@overlaytmp);
        hMenuAreaIntegrate = uimenu(hMenuTools,...
            'Label','Fill masked regions via inversion symmetry...',...
            'Position',4,...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_MenuInvSym',...
            'callback',@uimenu_applyinvsym);
        hMenuFindPeaks = uimenu(hMenuTools,...
            'Label','Find peaks ...',...
            'Position',5,...
            'Separator', 'on',...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_MenuFindPeaks',...
            'callback',@find2dpeaks);
        hMenu2Dfit = uimenu(hMenuTools,...
            'Label','Choose Peaks and Show ...',...
            'Position',6,...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_Menu2Dfit',...
            'callback',@menutools2DfitCallblack);
        hMenueditnumpnts = uimenu(hMenuTools,...
            'Label','Show "numpnts" and add/remove...',...
            'Position',7,...
            'Separator', 'on',...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_Menu_edit_numpnts',...
            'callback',@menutools_edit_numpntsCallblack);
        hMenu2Dfit2 = uimenu(hMenuTools,...
            'Label','2D Gaussians Fit of "numpnts"...',...
            'Position',8,...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_Menu2Dfitnumpnts',...
            'callback',@menutools_numpnts2DfitCallblack);
        hMenuFitresultSave = uimenu(hMenuTools,...
            'Label','Save "fit2dpeak" for DICVOL...',...
            'Position',9,...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_Menufit2dpeakDICVOL',...
            'callback',@menutools_save_fit2dpeak_DICVOL_Callblack);
        hMenu2Dfit = uimenu(hMenuTools,...
            'Label','Draw ROIs to Fit with 2D Gaussians...',...
            'Position',10,...
            'Separator', 'on',...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_Menu2Dfit',...
            'callback',@menutools_rect2DfitCallblack);
        hMenuAreaIntegrate = uimenu(hMenuTools,...
            'Label','Integrate Intensities of Zoomed In Area...',...
            'Position',11,...
            'HandleVisibility','callback',...
            'checked','off',...
            'Tag','SSL_MenuAreaIntegrate',...
            'callback',@uimenu_integratedintensity);


        hMenuPlugin = uimenu(figH,...
            'Label','&Plugin',...
            'Position',7,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuPlugin');
        hMenuMask = uimenu(hMenuPlugin,...
            'Label','Auto-update to 12ID Website...',...
            'Position',3,...
            'HandleVisibility','callback',...
            'Tag','SSL_AutoWebupdate',...
            'callback',@autoupdateOn);
        hMenuMask = uimenu(hMenuPlugin,...
            'Label','Mask Maker...',...
            'Position',2,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuMask',...
            'callback',@makemask);
        hMenuSetup = uimenu(hMenuPlugin,...
            'Label','Experiment Setup...',...
            'Position',1,...
            'HandleVisibility','callback',...
            'Tag','SSL_MenuSetup',...
            'callback', @call_gisaxsleenew);
        function overlaytmp(varargin)
            tmpmask = evalin('base', 'tmpmask');
            showm(tmpmask);
        end    
        function menutools2DfitCallblack(src,event)
            if strcmp(src.Checked,'off')
                src.Checked = 'on';
                fitpeaktoggledown
            else
                src.Checked = 'off';
                fitpeaktoggleup
            end
        end
            
        function menutools_rect2DfitCallblack(src,event)
            if strcmp(src.Checked,'off')
                src.Checked = 'on';
                drawROIandfit_toggledown
            else
                src.Checked = 'off';
                drawROIandfit_toggleup
            end
        end
        function menutools_numpnts2DfitCallblack(src, event)
            drawROIandfit_numpnts
        end
        function menutools_edit_numpntsCallblack(src, event)
            if strcmp(src.Checked,'off')
                src.Checked = 'on';
                edit_numpnts_toggledown
            else
                src.Checked = 'off';
                edit_numpnts_toggleup
            end
        end
        function menutools_save_fit2dpeak_DICVOL_Callblack(src, event)
            fit2dpeak_saveforDICVOL
        end        
        function call_gisaxsleenew(varargin)
            set(findobj('tag', 'SSL_MenuSet'), 'enable', 'on');
            gisaxsleenew_App;
            %gisaxsleenew('SetSAXSValues');
        end
        nposition = 2;
        if ~isempty(which('spacegroup'))
            nposition = nposition + 1;
            hMenuSpaceGroup = uimenu(hMenuPlugin,...
                'Label','Space Group...',...
                'Position',nposition,...
                'HandleVisibility','callback',...
                'Tag','SSL_MenuSpacegroup',...
                'callback', 'spacegroup');
        end
        if ~isempty(which('startFitLee'))
            nposition = nposition + 1;
            hMenuFitLee = uimenu(hMenuPlugin,...
                'Label','FitLee...',...
                'Position',4,...
                'HandleVisibility','callback',...
                'Tag','SSL_MenuFitLee',...
                'callback', 'startFitLee');
        end

        % add toolbar
        % Byeongdu Lee
        th = uitoolbar(figH);

        % Add a push tool to the toolbar
        a = .20:.05:0.95;
        img1(:,:,1) = repmat(a,16,1)';
        img1(:,:,2) = repmat(a,16,1);
        img1(:,:,3) = repmat(flip(a,2),16,1);
        cbimg = load('mycolorbaricon.mat'); % contains variable named myi
%        imglcut = zeros(size(img1));
%        imglcut(1:16,8,1) = 1;

        % Add a toggle tool to the toolbar
        %img2 = rand(16,16,3);
        %img2 = ind2rgb(imread(strcat(matlabroot,'\toolbox\matlab\icons\tool_data_cursor.gif')),map);
        %img2 = imread(strcat(matlabroot,'\toolbox\matlab\icons\tool_data_cursor.png'))/65536;
        [X, mapx] = imread(fullfile(...
            matlabroot,'toolbox','matlab','icons','tool_data_cursor.gif'));
        % Convert indexed image and colormap to truecolor
        img2 = ind2rgb(X,mapx);
        [X, mapx] = imread(fullfile(...
            matlabroot,'toolbox','matlab','icons','tool_ellipse.gif'));
        % Convert indexed image and colormap to truecolor
        img3 = ind2rgb(X,mapx);
        t = img3 == 1;img3(t) = NaN;
        t = img2 == 1;img2(t) = NaN;

        img0 = load(fullfile(...
            matlabroot,'toolbox','matlab','icons','pointer.mat'));
        try
            icon_eraser = imread('eraser.png');
            %icon_tick = imread('tick.png');
        catch
            mn = fullfile(matlabroot,'toolbox','mytool','1DSAXS', 'GUI', 'eraser.png');
            %mn = fullfile(matlabroot,'toolbox','mytool','1DSAXS', 'GUI', 'tick.png');
            icon_eraser = imread(mn);
        end
        t = icon_eraser == 0;icon_eraser=double(icon_eraser)/255;
        icon_eraser(t)= NaN;

        icon_leftarrow = imread('arrowback.png');
        icon_leftarrow=ind2rgb(icon_leftarrow, mapx);
        t = icon_leftarrow == 1;
        icon_leftarrow=double(icon_leftarrow)/3;
        icon_leftarrow(t)= NaN;

        icon_rightarrow = imread('arrowforward.png');
        icon_rightarrow=ind2rgb(icon_rightarrow, mapx);
        t = icon_rightarrow == 1;
        icon_rightarrow=double(icon_rightarrow)/3;
        icon_rightarrow(t)= NaN;
             

        pth = fileparts(which('SAXSimageviewer'));
        imgA = imread(fullfile(pth, 'icons', 'abs.png'));
        imgAzimA = imread(fullfile(pth, 'icons', 'AzimAng.png'));
        imgInterA = imread(fullfile(pth, 'icons', 'InterAng.png'));

        img4 = imread(fullfile(pth, 'icons', '1374031590_13.png'));
        t= img4==0;img4=double(img4)/255;
        img4(t)= NaN;

        imgundo = imread(fullfile(pth, 'icons', '1374031648_back_undo.png'));
        t= imgundo==0;imgundo=double(imgundo)/255;
        imgundo(t)= NaN;

        imgshow = imread(fullfile(pth, 'icons', '1374031872_25.png'));
        t= imgshow==0;imgshow=double(imgshow)/255;
        imgshow(t)= NaN;

        imgfit = imread(fullfile(pth, 'icons', '1374031932_plug_extension.png'));
        t= imgfit==0;imgfit=double(imgfit)/255;
        imgfit(t)= NaN;

        imgquickmasking = [
            1    1    1    1    1    1    1    1    0    0    1    1    1    1    1    1
    1    1    1    1    1    1    0    0    6    7    0    1    1    1    1    1
    1    1    1    1    1    0    5    6    6    7    7    0    1    1    1    1
    1    1    1    1    0    5    5    5    6    6    7    7    0    1    1    1
    1    1    1    0    5    5    5    5    5    6    6    6    0    1    1    1
    1    1    1    0    5    5    4    5    5    5    6    6    0    1    1    1
    1    1    0    5    5    4    4    4    5    5    5    0    1    1    1    1
    1    1    0    5    4    4    4    4    4    5    0    1    1    1    1    1
    1    0    5    4    4    4    3    4    4    0    1    1    1    1    1    1
    1    0    4    4    4    3    3    3    4    4    0    1    1    1    1    1
    0    4    4    4    3    3    3    3    3    4    4    0    1    1    1    1
    0    4    4    3    3    2    2    3    3    3    4    4    0    1    1    1
    1    0    3    3    2    2    2    2    3    3    4    4    0    1    1    1
    1    1    0    2    2    0    0    2    2    3    3    0    1    1    1    1
    1    1    1    0    0    1    1    0    3    3    0    1    1    1    1    1
    1    1    1    1    1    1    1    1    0    0    1    1    1    1    1    1];
t = imgquickmasking == 1;
imgquickmasking(t) = NaN;
map = [0         0         0
    0.8310    0.8160    0.7840
    1.0000         0         0
    1.0000    0.3065         0
    1.0000    0.5645         0
    1.0000    0.8065         0
    1.0000    1.0000         0
    1.0000    1.0000    0.6855];
        
imgquickmasking = ind2rgb(imgquickmasking, map);

        %imggi2cart = imread('gi2cart_icon.bmp');
        %xx = NaN*ones(34, 34, 3);
        %xx(5:30, 5:30, 1:3) = imggi2cart;
        %imggi2cart = xx/255;
%         uipushtool(th, ...
%                 'CData'                 ,imglcut,...
%                 'TooltipString'         ,'Linecut along the line drawn with linestyle - ',...
%                 'HandleVisibility'      ,'callback',...
%                 'ClickedCallback'       ,{@pushline}, ...
%                 'Tag'                   ,'PushLinecuts');
        uipushtool(th, ...
                'CData'                 ,icon_eraser,...
                'TooltipString'         ,'Erase all lines on SAXSimageviwer.',...
                'HandleVisibility'      ,'callback',...
                'ClickedCallback'       ,{@eraselines}, ...
                'Tag'                   ,'PushEraselines');
        
        uitoggletool(th, ...
                'CData'                 ,img0.cdata, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'To read q/angle/intensity values at the current mouse position. Left-click for record the position.',...
                'OnCallback'            , @OntoggleBtCallback, ...  
                'OffCallback'           , @OfftoggleBtCallback, ...  
                'HandleVisibility'      ,'callback', ...
                'Tag'                   ,'ToggleReadValue');
            
%         uitoggletool(th, ...
%                 'CData'                 ,imgshow, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'Show all selected peaks using the arrow tool on the left.',...
%                 'HandleVisibility'      ,'callback', ...
%                 'OnCallback'            , @peakshowtoggledown, ...  
%                 'OffCallback'           , @peakshowtoggleup, ...  
%                 'Tag'                   ,'Togglepeakshow');
            
        uitoggletool(th, ...
                'CData'                 ,imgquickmasking, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'Draw a region of interest.',...
                'OnCallback'            , @Ontoggle_quickmask_Callback, ...  
                'OffCallback'           , @Offtoggle_quickmask_Callback, ...  
                'HandleVisibility'      ,'callback', ...
                'Tag'                   ,'ToggleQuickMask');
        uitoggletool(th, ...
                'CData'                 ,img1, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'Switch the image scale between Log and Linear.',...
                'OnCallback'            , {@loglinConvert, 'log'}, ...  
                'OffCallback'           , {@loglinConvert, 'lin'}, ...  
                'HandleVisibility'      ,'callback', ...
                'Tag'                   ,'ToggleLogLin');
        uitoggletool(th, ...
                'CData'                 ,cbimg.myi, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'Colorbar',...
                'HandleVisibility'      ,'callback', ...
                'OnCallback'            , {@colorbarCallback, 'on'}, ...  
                'OffCallback'           , {@colorbarCallback, 'off'}, ...  
                'Tag'                   ,'ToggleColorbar');
        uitoggletool(th, ...
                'CData'                 ,imgInterA, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'Angle between three points. Click three points, A, B and C, on an image. An angle ABC will be measured.',...
                'OnCallback'            , @azimangle_start, ...  
                'OffCallback'           , @azimangle_Off, ...  
                'HandleVisibility'      ,'callback', ...
                'Tag'                   ,'Toggleazimangle');

        uitoggletool(th, ...
                'CData'                 ,imgAzimA, ...
                'Separator'             ,'on',...
                'TooltipString'         ,'Azimuthal angle. Click two points on an image.',...
                'OnCallback'            , @azimangle_start, ...  
                'OffCallback'           , @azimangle_Off, ...  
                'HandleVisibility'      ,'callback', ...
                'Tag'                   ,'ToggleTiltangle');
        uipushtool(th, ...
                'CData'                 ,icon_leftarrow,...
                'TooltipString'         ,'HDF lower number.',...
                'HandleVisibility'      ,'callback',...
                'ClickedCallback'       ,@flipHDFleft, ...
                'Tag'                   ,'FlipHDFleft');
        uipushtool(th, ...
                'CData'                 ,icon_rightarrow,...
                'TooltipString'         ,'HDF higher number.',...
                'HandleVisibility'      ,'callback',...
                'ClickedCallback'       ,@flipHDFright, ...
                'Tag'                   ,'FlipHDFright');
        
%         uipushtool(th, ...
%                 'CData'                 ,imgundo,...
%                 'TooltipString'         ,'Reset Axis limits - ',...
%                 'HandleVisibility'      ,'callback',...
%                 'ClickedCallback'       ,{@setXYLim}, ...
%                 'Tag'                   ,'resetAXISlimits');    
% 
%         uipushtool(th, ...
%                 'CData'                 ,img4, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'Load maskmaker.',...
%                 'ClickedCallback'       , @makemask, ...  
%                 'HandleVisibility'      ,'callback', ...
%                 'Tag'                   ,'pushMask');

%         uipushtool(th, ...
%                 'CData'                 ,img3, ...
%                 'TooltipString'         ,'Calibrate SAXS q space with a silver behenate. Load a AgBH image first.',...
%                 'ClickedCallback'            , @agbhSAXScalibrate, ...  
%                 'HandleVisibility'      ,'callback', ...
%                 'Tag'                   ,'AgbhSAXScalibrate');
% 

%         uitoggletool(th, ...
%                 'CData'                 ,img2, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'When toggle on, left-click to pick a point and right-click to remove a point. When toogle off, points will be transferred to Workspace as ''mousepnt''.',...
%                 'HandleVisibility'      ,'callback', ...
%                 'OffCallback'           , @datakeepertoggleup, ...  
%                 'OnCallback'            , @fitpeaktoggledown, ...  
%                 'Tag'                   ,'ToggleDataKeeper');
%         uitoggletool(th, ...
%                 'CData'                 ,img3, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'Fit the selected points with to a circle equation.',...
%                 'OnCallback'            , {@findcenterCallback, 'on'}, ...  
%                 'OffCallback'           , {@findcenterCallback, 'off'}, ...  
%                 'HandleVisibility'      ,'callback', ...
%                 'Tag'                   ,'ToggleFindCenter');



%         uipushtool(th, ...
%                 'CData'                 ,imgA, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'Use Glassy Carbon L17 for calculating the absolute scale factor',...
%                 'ClickedCallback'       , @gcfit, ...  
%                 'HandleVisibility'      ,'callback', ...
%                 'Tag'                   ,'GCSAXScalibrate');
% 
%         uitoggletool(th, ...
%                 'CData'                 ,imgfit, ...
%                 'Separator'             ,'on',...
%                 'TooltipString'         ,'Fit peak(s) with 2D gaussian',...
%                 'HandleVisibility'      ,'callback', ...
%                 'OnCallback'            , @fitpeaktoggledown, ...  
%                 'OffCallback'           , @fitpeaktoggleup, ...  
%                 'Tag'                   ,'Togglefitpeak');
% 
%        uitoggletool(th,...
%                 'CData',icons.iconmonitor.play,...
%                 'TooltipString','Show Pilatus2M 2D image as you take',...
%                 'HandleVisibility'      ,'callback', ...
%                 'OnCallback'            , @startmonitor, ...  
%                 'OffCallback'           , @stopmonitor, ...  
%                 'Tag','ToggleMonitor2D');



    end


%% Nested function starts here......

    function startmonitor(varargin)
%        stopmonitor
        delete(timerfind('TimerFcn', 'mca(600)'));
        saxs = getgihandle;
        if numel(varargin) == 1 % called from Menu.
            DET = varargin{1};
        else
            [~, name] = system('hostname');
            switch lower(strtrim(name))
                case 'green'
                    DET = 'mar300';
                otherwise
                    if isempty(saxs)
                        saxs.imgsize = [2000, 2000];
                    end
                    if saxs.imgsize(1) > 3000
                        DET = 'PE';
                    else
                        DET = 'Pilatus2M';
                    end
            end
        end
        switch lower(DET)
            case 'mar300'
                s12DET = mar12IDC;
            case 'pe'
                s12DET = PE;
            case 'pilatus2m'
                s12DET = Pilatus;
            case 'eiger9m'
                s12DET = Eiger;

        end
        s12DET = connect(s12DET);
        s12DET = get(s12DET);

%        mcamon(s12DET.SeqNumber{2}, 'mcamon_2Dauto_update');
%        mcamon(s12DET.ArrayNumber{2}, 'mcamon_2Dauto_update');
        mcamon(s12DET.FullFileName{2}, 'mcamon_2Dauto_update');
        assignin('base', 's12DET', s12DET);
        mcamontimer('start')
        disp('Auto update started')
    end

    function stopmonitor(varargin)
        disp('Auto update stopped')
        mcamontimer('stop');
        s12DET = evalin('base', 's12DET');
        mcaclearmon(s12DET.ArrayNumber{2});
        mcaclearmon(s12DET.AcquirePOLL{2});
        s12DET = disconnect(s12DET);
        assignin('base', 's12DET', s12DET);
    end

    function eraselines(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);        
        t = findobj(handles.ImageAxes, 'type', 'line');
        delete(t);
        set(findobj(handles.ImageAxes, 'type', 'image'), 'alphadata', 1);
    end

  function winCreateFcn(varargin)
%        saxs = getgihandle;
%        handles.saxs = saxs
  end

  function SAXSimage_CloseRequestFcn(varargin)
      hFig = findobj('Tag','SAXSImageViewer');
      try
          delete(hFig);
%          stopmonitor;
          evalin('caller',['clear ','mousepnt']) 
          evalin('caller',['clear ','SAXSimagehandle']);
          evalin('caller',['clear ','SAXSimageviewerhandle']);
      catch
          error('Error in SAXSimage_CloseRequestFcn')
      end
  end
  
  % ======================
  % color scale changes
  % ======================  
    function setColor(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        climmode = lower(get(get(handles.ColorScaleGroup,'SelectedObject'),'String'));
        if numel(varargin) == 0
            clim(1) = str2double(get(handles.ColorLowLim, 'string'));
            clim(2) = str2double(get(handles.ColorHighLim, 'string'));
        else
            clim = varargin{1};
            if isnan(clim)
                clim = [1, 5000];
            end
            set(handles.ColorLowLim, 'string', clim(1));
            set(handles.ColorHighLim, 'string', clim(2));
            set(handles.ImageAxes, 'cLim', clim);
            return
        end
        
        set(handles.ImageAxes, 'cLimmode', climmode);
        switch climmode
            case 'auto'
                if numel(clim) == 2
                    clim = get(handles.ImageAxes, 'cLim');
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
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        if get(handles.ManualColor, 'value') == 0
            set(handles.ManualColor, 'value', 1);
        end
        setColor
    end

%    function selcbk(source,eventdata)
    function selcbk(varargin)
        setColor
    end
  
  % ======================
  % XY scale changes
  % ======================  
    function setXYLim(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        climmode = lower(get(get(handles.XYLimGroup,'SelectedObject'),'String'));
        try
            lim = varargin{1};
            xlimvalue = lim(1:2);
            ylimvalue = lim(3:4);
            getXYLim

        catch
            xllim = str2double(get(handles.XLowLim, 'string'));
            if isnan(xllim)
                xllim = handles.ImageAxes.XLim(1);
                set(handles.XLowLim, 'string', xllim);
            end
            xhlim = str2double(get(handles.XHighLim, 'string'));
            if isnan(xhlim)
                xhlim = handles.ImageAxes.XLim(2);
                set(handles.XHighLim, 'string', xhlim);
            end
            yllim = str2double(get(handles.YLowLim, 'string'));
            if isnan(yllim)
                yllim = handles.ImageAxes.YLim(1);
                set(handles.YLowLim, 'string', yllim);
            end
            yhlim = str2double(get(handles.YHighLim, 'string'));
            if isnan(yhlim)
                yhlim = handles.ImageAxes.YLim(2);
                set(handles.YHighLim, 'string', yhlim);
            end
            xlimvalue = [xllim, xhlim];
            ylimvalue = [yllim, yhlim];
        end

        CoordinateAxes2ImageAxes;
        
        switch climmode
            case 'auto'
                ud = getappdata(handles.ImageAxes, 'tmpdata');
                xlimvalue = ud.xlimFull;
                ylimvalue = ud.ylimFull;
                set(handles.ImageAxes, 'xLim', xlimvalue);
                set(handles.ImageAxes, 'yLim', ylimvalue);
                getXYLim
            case 'manual'
                set(handles.ImageAxes, 'xLim', xlimvalue);
                set(handles.ImageAxes, 'yLim', ylimvalue);
            otherwise
        end
    end

    function getXYLim
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        xlimvalue = get(handles.ImageAxes, 'xlim');
        ylimvalue = get(handles.ImageAxes, 'yLim');
        set(handles.XLowLim, 'string', num2str(xlimvalue(1)));
        set(handles.XHighLim, 'string', num2str(xlimvalue(2)));
        set(handles.YLowLim, 'string', num2str(ylimvalue(1)));
        set(handles.YHighLim, 'string', num2str(ylimvalue(2)));
    end

      
    function ManualXYLimEdit(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        if get(handles.ManualXYLim, 'value') == 0
            set(handles.ManualXYLim, 'value', 1);
        end
        setXYLim
    end

    function selcImgSize(varargin)
        setXYLim
    end

%--------------------------------------------------------------------------
% resizeFcn
%   This resizes the figure window appropriately
%--------------------------------------------------------------------------
    function resizeFcn(varargin)
        if numel(varargin)>0
            figH = varargin{1};
        else
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        handles = guidata(figH);

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
            figPos(2) = screenSize(4) - figPos(4) - 100;
          end

          set(figH, 'position', figPos);

        end

        set(handles.versionPanel         , 'position', [1, 1, 200, 25]);
        set(handles.versionText          , 'position', [2, 2, 196, 20]);
        set(handles.statusPanel          , 'position', [102+100, 1, figPos(3)-102-100, 25]);
        set(handles.statusText           , 'position', [2+100, 2, figPos(3)-107-100, 20]);
        set(handles.frame1               , 'position', [figPos(3)-115, figPos(4)-55, 110, 53]);
%         set(handles.DisplayCoordInfo     , 'position', [300, figPos(4)-85, figPos(3)-450, 60]);
        set(handles.ZoomCaptionText      , 'position', [5, 22, 100, 17]);
        set(handles.ResetViewBtn1        , 'position', [5, 2, 47, 20]);
        set(handles.ResetViewBtn2        , 'position', [55, 2, 47, 20]);
%         set(handles.qaxisBtn             , 'position', [figPos(3)-220, figPos(4)-28, 100, 20]);
%         set(handles.FileInfoBtn          , 'position', [figPos(3)-220, figPos(4)-50, 100, 20]);
        set(handles.CurrentDirectoryPanel, 'position', [20, figPos(4)-30, 215, 20]);
        %    set(handles.CurrentDirectoryPanel, 'position', [100, figPos(4)-30, 215, 20]);
        set(handles.CurrentDirectoryEdit , 'position', [1, 1, 213, 18]);
        set(handles.ChooseDirectoryBtn   , 'position', [237, figPos(4)-30, 20, 20]);
        set(handles.UpDirectoryBtn       , 'position', [259, figPos(4)-30, 20, 20]);
        set(handles.DirListBox           , 'position', [20, figPos(4)-120, 260, 80]);
        set(handles.FileListBox          , 'position', [20, 270, 260, figPos(4)-395]);
        set(handles.FileFilterEdit       , 'position', [20, 250, 260, 20]);
        set(handles.FileSortPopup        , 'position', [20, 230, 260, 20]);
        set(handles.PreviewImagePanel    , 'position', [20, 40, 260, 150]);
        %    set(handles.PreviewImageAxes     , 'position', [5, 5, 245, 190]);
        set(handles.ColorScaleGroup      , 'position', [0, 0, 0.45, 1])
        set(handles.AutoColor            , 'position', [5, 100, 60, 20]);
        set(handles.ManualColor          , 'position', [5, 80, 60, 20]);
        set(handles.ColorLowLim          , 'position', [20, 60, 40, 20]);
        set(handles.ColorHighLim         , 'position', [60, 60, 40, 20]);
        set(handles.XYLimGroup           , 'position', [0.5, 0, 0.45, 1])
        set(handles.AutoXYLim            , 'position', [5, 100, 60, 20]);
        set(handles.ManualXYLim          , 'position', [5, 80, 60, 20]);
        set(handles.XLowLim              , 'position', [20, 60, 40, 20]);
        set(handles.XHighLim             , 'position', [60, 60, 40, 20]);
        set(handles.YLowLim              , 'position', [20, 40, 40, 20]);
        set(handles.YHighLim             , 'position', [60, 40, 40, 20]);
        set(handles.txtscaleX            , 'position', [0, 60, 20, 20]);
        set(handles.txtscaleY            , 'position', [0, 40, 20, 20]);
        set(handles.txtscaleMin          , 'position', [20, 20, 40, 20]);
        set(handles.txtscaleMax          , 'position', [60, 20, 40, 20]);
        % for MATLAB version below 2014b 
        %set(handles.ImageAxes            , 'outerposition', [310, 40, figPos(3)-310, figPos(4)-120]);
        % for MATLAB version from 2014b 
        set(handles.ImageAxes            , 'outerposition', [300, 80, figPos(3)-310, figPos(4)-160]);
        set(handles.ImageAxes            , 'DataAspectRatio', [1,1,1]);
        axPos = get(handles.ImageAxes    , 'position');


        textBoxDim  = [400, 200];
        rightMargin = figPos(3)-(axPos(1)+axPos(3));
        topMargin   = figPos(4)-(axPos(2)+axPos(4));
        set(handles.MessageTextBox      , 'position', [figPos(3)-rightMargin-textBoxDim(1), ...
          figPos(4)-topMargin-textBoxDim(2), ...
          textBoxDim]);
        set(handles.DisplayInfo          , 'position', [300, figPos(4)-30, figPos(3)-550, 15]);
        set(handles.DisplayCoordInfo          , 'position', [300, figPos(4)-120, figPos(3)-550, 80]);
      
        udf = getappdata(figH, 'tmpdata');
        udf.figPos = figPos;
        udf.axPos = axPos;
        setappdata(figH, 'tmpdata', udf);
        %handles.figPos = figPos;
        %handles.axPos  = axPos;


%        titleStr = get(get(handles.ImageAxes, 'title'), 'string');
%        if ~isempty(titleStr)
%            loadImage(titleStr);
%            handles = guidata(figH);
%        end

        set(handles.CoordinateAxes, 'position', get(handles.ImageAxes, 'position'));
%        set(handles.CoordinateAxes, 'PlotBoxAspectRatio', get(handles.ImageAxes, 'PlotBoxAspectRatio'));
        colorbarCallback(figH); % resize colorbar if needed.
    end

%--------------------------------------------------------------------------
% helpBtnCallback
%   This opens up a help dialog box
%--------------------------------------------------------------------------
    function mnplot_qaxis(varargin)

        CoordinateAxes2ImageAxes

    end

%--------------------------------------------------------------------------
% fileInfoBtnCallback
%   This displays the file info of the image that's displayed
%--------------------------------------------------------------------------
    function fileInfoBtnCallback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);

        obj = varargin{1};

        if get(obj, 'value')

            % First 9 fields of IMFINFO are always the same
            fnames      = fieldnames(handles.iminfo); fnames = fnames(1:9);
            vals        = struct2cell(handles.iminfo); vals = vals(1:9);

            % Only show file name (not full path)
            [~, n, e]   = fileparts(vals{1});
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
    function showDirectory(varargin)
        figH = [];
        isNewLoad = 0;
        if numel(varargin) < 1
            dirname = '';
        else
            if ischar(varargin{1})
                dirname = varargin{1};
            else
                dirname = '';
            end
            if ishandle(varargin{1})
                figH = varargin{1};
                isNewLoad = 1;
            end
        end
        if isempty(figH)
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        
        % Reset settings and images
%        stopTimer;
        %cla(handles.PreviewImageAxes);
        %axis(handles.PreviewImageAxes, 'normal');
        clearImageAxes(figH);
        %----------------------------------------------------------------------

        handles = guidata(figH);
        udf = getappdata(figH, 'tmpdata');
        if isNewLoad
            udf.lastDir = pwd;
        else
%        if nargin == 1
            if length(dirname) > 1
                udf.lastDir = dirname;
            end
        end
    
        set(handles.CurrentDirectoryEdit, 'string', ...
          fixLongDirName(udf.lastDir), ...
          'tooltipstring', udf.lastDir);
        
%        setappdata(figH, 'tmpdata', udf);
        
        
        %guidata(figH, handles);
        % Get image formats
        if isfield(udf, 'filefilter')
            ff = udf.filefilter;
        else
            ff = [];
        end
        if isfield(udf, 'filesort')
            fs = udf.filesort;
        else
            fs = 'name';
        end
        [n, n2]= filefilter(udf.lastDir, ff, fs);
%        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);

        if isempty(n)
            udf.imageID = [];
            udf.imageNames = {};
            udf.imagePreviews = {};
%            runTimer = false;
        else
            udf.imageID = 1:length(n);
            udf.imageNames = n;
            udf.imagePreviews = cell(1,length(n));
%            runTimer = true;
        end

        if ~isempty(n2)
            n2 = strcat(repmat({'['}, 1, length(n2)), n2, ...
                repmat({']'}, 1, length(n2)));
            %n = {n2{:}, n{:}};

            udf.imageID = udf.imageID + length(n2);
        end
        
        %if ~isempty(n)
        set(handles.FileListBox, 'string', n, 'value', 1);
        %end
        %if ~isempty(n2)
        set(handles.DirListBox, 'string', n2, 'value', 1);
        %end


%         if runTimer
%             startTimer;
%         end

        if ~isempty(udf.imageID)
          set(handles.SAXSImageViewer, 'selectiontype', 'normal');
          if udf.imageID(1) <= numel(n)
            set(handles.FileListBox, 'value', udf.imageID(1));
          end
          fileListBoxCallback(handles.FileListBox, figH);
        end

        setappdata(figH, 'tmpdata', udf);
        %guidata(figH, handles);

    end
  
    function filefiltereditCallback(varargin)
%        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        figH = evalin('base', 'SAXSimageviewerhandle');
        udf = getappdata(figH, 'tmpdata');
        udf.filefilter = get(varargin{1}, 'string');
        setappdata(figH, 'tmpdata', udf);
        %guidata(figH, handles);
        showDirectory
        
    end

    function filesortpopupCallback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
%        guidata(figH, handles);
        udf = getappdata(figH, 'tmpdata');
        val = get(varargin{1}, 'value');
        sortstr = get(varargin{1}, 'string');
        udf.filesort = sortstr{val};
        %guidata(figH, handles);
        setappdata(figH, 'tmpdata', udf)
        showDirectory
    end
        
    function [n, n2] = filefilter(dirn, filefilter, filesort)
            
        imf  = imformats;
        exts = [imf.ext];
        exts = [exts, 'h5'];
        d = [];
        formatstring = filefilter;
        sortstring = filesort;

        % list files
        if isempty(formatstring)
            for id = 1:length(exts)
                d = [d; dir(fullfile(dirn, ['*.' exts{id}]))];
            end
        else
            d = [d; dir(fullfile(dirn, formatstring))];
            d = d(~[d.isdir]);
        end

    %    sort files;
        if numel(d) < 2
            n = {d.name};
        else
            if ischar(d(1).(sortstring))
                [~, tmpind] = sort({d.(sortstring)});
            else
                [~, tmpind] = sort([d.(sortstring)]);
            end
            tmpind = fliplr(tmpind);
            n = {d(tmpind).name};
        end

        %n2 = [];
        d2 = dir(dirn);
        % The following code is needed to display directories in the
        % filelistbox.
        %d2 = dir(handles.lastDir);
        n2 = {d2.name};
        n2 = n2([d2.isdir]);
        ii1 = strcmp('.', n2); % logic of .
        ii2 = strcmp('..', n2); % logic of ..
        Log_dir = ii1 | ii2;
        n2(Log_dir) = [];
    end

    function colorbarCallback(varargin)
        if numel(varargin)>0
            figH = varargin{1};
        else
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        handles = guidata(figH);
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
                set(handles.colorbarhandle, 'TicksMode', 'auto',...
                    'location', 'North',...
                    'units', 'pixels',...
                    'hittest', 'off',...
                    'color', 'w',...
                    'Axislocation', 'out')
%                 set(handles.colorbarhandle, 'TickMode', 'manual',...
%                     'xlimmode','manual',...
%                     'ylimmode','manual',...
%                     'location', 'North',...
%                     'unit', 'pixels',...
%                     'hittest', 'off',...
%                     'xaxislocation', 'bottom')
    %                'xtickmode', 'auto',...
    %                'ytickmode', 'manual',...
    %                'ytick', [],...
                poc = get(handles.colorbarhandle, 'position');
                poc(4) = poc(4)/3*2;
                poc(3) = poc(3)/3;
                %poc(1) = 780;
                %poc(2) = poc(2);
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
        guidata(figH, handles);
    end
%--------------------------------------------------------------------------
% toggleBtCallback
%   This is the toggle button callback function
%--------------------------------------------------------------------------
    function OntoggleBtCallback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        gtrack_start
        % Mouse left click menu
        hcmenu = uicontextmenu;
%         uimenu(hcmenu,'Label','Integrated Intensity','Callback',@uimenu_integratedintensity);
        uimenu(hcmenu,'Label','Set current position as ai','Callback',@uimenu_setai);
        uimenu(hcmenu,'Label','Print Coordinates','Callback',@uimenu_printcoordinates);
        uimenu(hcmenu,'Label','Click for the tilt angle calculation','Callback',@uimenu_gettiltangle);
        uimenu(hcmenu,'Label','Current point to imganalysis','Callback',@uimenu_imganalysis_setpoint);
        uimenu(hcmenu,'Label','qxy cut(H)','Callback',{@uimenu_linecut, 'h'});
        uimenu(hcmenu,'Label','q_{t,z} cut(V)','Callback',{@uimenu_linecut, 'v1'});
        uimenu(hcmenu,'Label','q_{r,z} cut(V)','Callback',{@uimenu_linecut, 'v2'});
        uimenu(hcmenu,'Label','2\theta_f cut(V)','Callback',{@uimenu_linecut, 'tth'});
        uimenu(hcmenu,'Label','\alpha_f cut(V)','Callback',{@uimenu_linecut, 'af'});
        uimenu(hcmenu,'Label','Clean lines','Callback',@uimenu_cleanlines);
        uimenu(hcmenu,'Label','Toggle Off','Callback',@gtrack_Off);
        % Locate line objects
        %himage = findall(gcf,'Type','axes');
        set(handles.ImageAxes,'uicontextmenu',hcmenu)
    end

    function OfftoggleBtCallback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        %hObject, eventdata, handles)

        % Remove the uicontextmenu    
        handles = guidata(figH);
        set(handles.ImageAxes,'uicontextmenu','')
        gtrack_Off
    
    end
% ----------------------------------
% Callback for a toggle button for quick masking.
% ----------------------------------
    
    function Ontoggle_quickmask_Callback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        f= handles.SAXSImageViewer;
        ax = handles.ImageAxes;
        btdfcn = get(f, 'windowbuttondownfcn');
        setappdata(f, 'oldwindowbuttondownfcn', btdfcn);
        set(f, 'windowbuttondownfcn', @masktrack_on);
        
        btdfcn = get(f, 'windowbuttonmotionfcn');
        setappdata(f, 'oldwindowbuttonmotionfcn', btdfcn);

        t = get(f, 'windowbuttonupfcn');
        setappdata(f, 'oldwindowbuttonupfcn', t)
        
        set(f, 'windowbuttonmotionfcn', '');        
        set(f, 'windowbuttonupfcn', '');        
%        set(gcf, 'windowbuttondownfcn', @gtrack_OnMouseDown);          
        
        set(ax, 'userdata', []);
        try
            tmpmask = evalin('base', 'tmpmask');
            showm(tmpmask);
        catch
        end
    end

    function Offtoggle_quickmask_Callback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');

        %masktrack_off
        handles = guidata(figH);
        f= handles.SAXSImageViewer;
        %ax = handles.ImageAxes;
        %set(findobj(ax, 'type', 'image'), 'alphadata', 1);
        set(handles.ToggleQuickMask, 'state', 'off');
        btdfcn = getappdata(f, 'oldwindowbuttondownfcn');
        set(f, 'windowbuttondownfcn', btdfcn);
        btdfcn = getappdata(f, 'oldwindowbuttonmotionfcn');
        set(f, 'windowbuttonmotionfcn', btdfcn);
        t = getappdata(f, 'oldwindowbuttonupfcn');
        set(f, 'windowbuttonupfcn', t);
        
    end

    function masktrack_on(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        f= handles.SAXSImageViewer;
        ax = handles.ImageAxes;
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
                setappdata(f, 'linehandle', lh);
            end
        case 'extend'
            masktrack_off
        case 'alt'
            masktrack_off
%            winBtnDownFcn(handles.ImageAxes);
        otherwise
        end
    end
    
    function masktrack_off
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        f= handles.SAXSImageViewer;
        ax = handles.ImageAxes;
        lh = getappdata(f, 'linehandle');
        if ~isempty(lh)
            delete(lh)
            lh = [];
        end

        t = get(ax, 'userdata');
        t = [t; [t(1,1), t(1,2)]];
%            set(ax, 'userdata', t);
        if numel(t(:,1)) > 1
            lh = line(t(:,1), t(:,2));
        end
        setappdata(f, 'linehandle', lh);
        compositemask(f, ax, t)
        k = findall(ax, 'type', 'line');
        delete(k);
        
        Offtoggle_quickmask_Callback
    end
    function compositemask(varargin)
        %f = varargin{1};
        ax = varargin{2};
        %t = varargin{3};
        s = getgihandle;
        [X, Y] = meshgrid(1:s.imgsize(2), 1:s.imgsize(1));
        %X = getappdata(f, 'X');
        %Y = getappdata(f, 'Y');
        t = get(ax, 'userdata');
        tmpmask = inpolygon(X(:), Y(:), t(:,1), t(:,2));
        tmpmask = double(tmpmask);
        %tmpmask(tmpmask == 0) = 2;
        tmpmask = reshape(tmpmask, size(X));
        %tmpmask = tmpmask - 1;
        showm(tmpmask);
        assignin('base', 'tmpmask', tmpmask);
    end
    function showm(msk)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        ax = handles.ImageAxes;
        E = double(abs(msk));
        E(E<=0)=0.3;
        set(findobj(ax, 'type', 'image'), 'alphadata', E);
        %set(f, 'windowbuttonmotionfcn', '');
        %set(f, 'windowbuttondownfcn', '');
    end
% ---------------------------------------------------
% UIMENU
    function uimenu_showRegionofInterest(varargin)
        try
            tmpmask = evalin('base', 'tmpmask');
            showm(tmpmask);
        catch
        end
    end
    function uimenu_printcoordinates(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        cdn = handles.coordinate;
        if isfield(cdn, 'qtz')
            z = cdn.qtz/cdn.qt;
            y = cdn.qy/cdn.qt;
            fprintf('Coordinates are [0, %0.3f, %0.3f]\n', y, z)
        else
            z = cdn.qz/cdn.q;
            y = cdn.qy/cdn.q;
            fprintf('Coordinates are [0, %0.3f, %0.3f]\n', y, z)
        end

            %imganalysis('pb_coordDown_Callback');
    end
    function uimenu_imganalysis_setpoint(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        t = findobj('tag', 'GIImgAnalysis');
        cdn = handles.coordinate;
        if ~isempty(t)
            analhandle = guihandles(t);
            if strcmp(t.Name, 'Linecut Tool')
                if isfield(cdn, 'qtz')
                    analhandle.ed_qtz.Value = num2str(cdn.qtz);
                    analhandle.ed_qt.Value = num2str(cdn.qt);
                else
                    analhandle.ed_qtz.Value = num2str(cdn.qz);
                    analhandle.ed_qt.Value = num2str(cdn.q);
                end
                if isfield(cdn, 'qrz')
                    analhandle.ed_qrz.Value = num2str(cdn.qrz);
                    analhandle.ed_qr.Value = num2str(cdn.qr);
                else
                    analhandle.ed_qtz.Value = num2str(cdn.qz);
                    analhandle.ed_qr.Value = num2str(cdn.q);
                end
                if isfield(cdn, 'qxy')
                    analhandle.ed_qxy.Value = num2str(cdn.qxy);
                else
                    analhandle.ed_qxy.Value = num2str(cdn.qy);
                end
                analhandle.ed_af.Value = num2str(cdn.af);
                analhandle.ed_tth.Value = num2str(cdn.tthf);
                analhandle.ed_xpixel.Value = num2str(cdn.x);
                analhandle.ed_ypixel.Value = num2str(cdn.y);                
            else
                if isfield(cdn, 'qtz')
                    set(analhandle.ed_qtz, 'string', num2str(cdn.qtz));
                    set(analhandle.ed_qt, 'string', num2str(cdn.qt));
                else
                    set(analhandle.ed_qtz, 'string', num2str(cdn.qz));
                    set(analhandle.ed_qt, 'string', num2str(cdn.q));
                end
                if isfield(cdn, 'qrz')
                    set(analhandle.ed_qrz, 'string', num2str(cdn.qrz));
                    set(analhandle.ed_qr, 'string', num2str(cdn.qr));
                else
                    set(analhandle.ed_qtz, 'string', num2str(cdn.qz));
                    set(analhandle.ed_qr, 'string', num2str(cdn.q));
                end
                if isfield(cdn, 'qxy')
                    set(analhandle.ed_qxy, 'string', num2str(cdn.qxy));
                else
                    set(analhandle.ed_qxy, 'string', num2str(cdn.qy));
                end
                set(analhandle.ed_af, 'string', num2str(cdn.af));
                set(analhandle.ed_tth, 'string', num2str(cdn.tthf));
                set(analhandle.ed_xpixel, 'string', num2str(cdn.x));
                set(analhandle.ed_ypixel, 'string', num2str(cdn.y));
            end
            %imganalysis('pb_coordDown_Callback');
        end
    end
    function uimenu_gettiltangle(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        saxs = getgihandle;
        xInd = handles.MousexInd;
        yInd = handles.MouseyInd;
        center = saxs.center;
        pos = [xInd, yInd] - center;
        th = cart2pol(pos(1), pos(2));
        cprintf('-comment', 'Tilt angle is %0.3f\n', 90-rad2deg(th))
    end
        
    function uimenu_setai(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        saxs = getgihandle;

        xInd = handles.MousexInd;
        yInd = handles.MouseyInd;

        [~, af, ~, ~] = giangle(xInd, yInd, saxs);

        if ~isfield(saxs, 'ai')
            saxs.ai = 0;
        end
        ai = saxs.ai;
        alpha = af+ai;
        ai = alpha/2;
        saxs.ai = ai;
        setgihandle(saxs);
        hgisaxslee = findobj('tag', 'gisaxsleenew');
        saxsleehandles = guihandles(hgisaxslee);
        set(saxsleehandles.ed_ai, 'string', num2str(ai));
    end
    function uimenu_integratedintensity(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = get(figH, 'userdata');
        img = saxs.image;
        
        xllim = str2double(get(handles.XLowLim, 'string'));
        xhlim = str2double(get(handles.XHighLim, 'string'));
        yllim = str2double(get(handles.YLowLim, 'string'));
        yhlim = str2double(get(handles.YHighLim, 'string'));
        xlimvalue = round([xllim, xhlim]);
        ylimvalue = round([yllim, yhlim]);
        integratedintensity = sum(sum(img(ylimvalue(1):ylimvalue(2), xlimvalue(1):xlimvalue(2))));
        fprintf('Integrated intensity: %0.3f\n', integratedintensity);
        fprintf('Mean value: %0.3f\n', integratedintensity/(xhlim-xllim+1)/(yhlim-yllim+1));
    end
    function uimenu_applyinvsym(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
%        handles = guidata(figH);
        %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = get(figH, 'userdata');
        img = saxs.image;
        if ~isfield(saxs, 'mask')
            fprintf('Need saxs.mask.\n')
            return
        end        
        ind = saxs.mask(:)<1;
        ind = ind | isnan(saxs.mask(:));
        
        % new method:
        x = 1:saxs.imgsize(2);
        y = 1:saxs.imgsize(1);
        [X, Y] = meshgrid(x, y);
        if ~isfield(saxs, 'qmap')

            [qmap, thmap] = pixel2q([X(:),Y(:)], saxs);
            saxs.qmap = qmap;
            saxs.thmap = thmap;
        end
        qv = saxs.qmap(ind);
        th = rad2deg(saxs.thmap(ind)+pi);
        P = q2pixel([qv(:),zeros(numel(qv), 1), th(:)], ...
            saxs.waveln, saxs.center, saxs.psize, saxs.SDD, saxs.tiltangle);
        val = interp2(X, Y, img, P(:,1), P(:,2));
        % ==========================================

        % % old method:
        % if ~isfield(saxs, 'qmap')
        %     x = 1:saxs.imgsize(1);
        %     y = 1:saxs.imgsize(2);
        %     [X, Y] = ndgrid(x, y);
        %     [qmap, thmap, SF, ang] = pixel2q([X(:),Y(:)], saxs);
        %     saxs.qmap = qmap;
        %     saxs.thmap = thmap;
        % end
        % val = interp2(reshape(saxs.qmap, size(img))', ...
        %     reshape(saxs.thmap, size(img))', ...
        %     img', saxs.qmap(ind), -saxs.thmap(ind));
        % % ==========================================

        img(ind)=val;
        saxs.image = img;
        setgihandle(saxs);
        assignin('base', 'fillimage', img);
        handles = guidata(figH);
        if handles.ToggleLogLin.State % log?
            img = log10(abs(img));
        else
            img = abs(img);
        end
        set(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData', img)
        fprintf("\n2D image is exported to base as fillimage to save.\n")
    end
    function uimenu_linecut(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = get(figH, 'userdata');
        img = saxs.image;
        
        %if varargin{1} == 'h'
        cutdir = varargin{3};
        saxs = getgihandle;
%         try
%             si = evalin('base', 'sampleinfo');
%         catch
%             si = [];
%         end
        %mpoint.x = handles.MousexInd;
        %mpoint.y = handles.MouseyInd;
        pix = [handles.MousexInd, handles.MouseyInd];
        if isfield(saxs, 'linecutbandwidth')
            bw = saxs.linecutbandwidth;
        else
            bw = 0;
        end
        cut = linecut_q(img, pix, cutdir, saxs, bw);
        switch cutdir
            case 'h'
                figure;semilogy(cut.qxy, cut.Iq);
                xlabel('q_{xy}', 'fontsize', 14);
                ylabel('Intensity', 'fontsize', 14);
            case 'v1'
                figure;semilogy(cut.qz, cut.Iq);
                xlabel('q_{t,z}', 'fontsize', 14);
                ylabel('Intensity', 'fontsize', 14);
            case 'v2'
                figure;semilogy(cut.qz, cut.Iq);
                xlabel('q_{r,z}', 'fontsize', 14);
                ylabel('Intensity', 'fontsize', 14);
            case 'tth'
                figure;semilogy(cut.tth, cut.Iq);
                xlabel('q_{2\theta_f}', 'fontsize', 14);
                ylabel('Intensity', 'fontsize', 14);
            case 'af'
                figure;semilogy(cut.af, cut.Iq);
                xlabel('q_{\alpha_f}', 'fontsize', 14);
                ylabel('Intensity', 'fontsize', 14);
        end
        cut.handle = line(cut.X, cut.Y, 'parent', handles.ImageAxes);
        set(cut.handle, 'color', 'w', 'linestyle', ':');
        assignin('base', 'cut', cut);
    end
    function uimenu_cleanlines(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        t = findobj(handles.ImageAxes, 'type', 'line');
        delete(t);
    end
    function uimenu_setbackground(varargin)
        %figH = evalin('base', 'SAXSimageviewerhandle');
        %handles = guidata(figH);
%        img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');

        saxs = getgihandle;
        saxs.backgroundimage = double(saxs.image);

        qNorm = check_normalizationoptions(saxs);
        if qNorm
            s = sprintf(['When you define the current image as Background,\n',...
            'do not select any normalization options before loading the image.\n',...
            'Otherwise, the background will be normalized twice']);
            fprintf(s)
        end
        try
            sampleinfo = evalin('base', 'sampleinfo');
            saxs.background_exptime = sampleinfo.Exposuretime;
            saxs.background_I0 = sampleinfo.IC/sampleinfo.Exposuretime;
            saxs.background_BS = sampleinfo.BS/sampleinfo.Exposuretime;
            %else
            %    saxs.background_I0 = 1;
            %end
        catch
            saxs.background_exptime = 1;
            saxs.background_I0 = 1;
            saxs.background_BS = 1;
            fprintf('Sampleinfo is not available. Default t, I0 and BS is applied to the background.\n');
        end
        if ~isfield(saxs, 'empty_I0')
            fprintf('NOTE: If an empty air data is not defined, the absolute intensity conversion cannot be done.\n');
            saxs.background_T = 1;
        else
            saxs.background_T = saxs.background_BS/saxs.empty_BS*saxs.empty_I0/saxs.background_I0;
            fprintf('Transmittance of the background is %0.4f.\n', saxs.background_T);
        end

        setgihandle(saxs);
    end
    function uimenu_setEmpty(varargin)
        %figH = evalin('base', 'SAXSimageviewerhandle');
        %handles = guidata(figH);
%        img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = getgihandle;
%        saxs.backgroundimage = double(img);
        saxs.emptyairimage = double(saxs.image);
        qNorm = 0;
        if isfield(saxs, 'qtime_normalize')
            if saxs.qtime_normalize
                qNorm = 1;
            end
        end
        if isfield(saxs, 'qScaleI0')
            if saxs.qScaleI0
                qNorm = 1;
            end
        end
        if isfield(saxs, 'qScaleFactor')
            if saxs.qScaleFactor
                qNorm = 1;
            end
        end
        if qNorm
            s = sprintf(['When you define the current image as an air (not even an empty cell),\n',...
            'do not select any normalization options before loading the image.\n',...
            'Otherwise, the air will be normalized twice']);
            fprintf(s)
        end
        try
            sampleinfo = evalin('base', 'sampleinfo');
            saxs.empty_exptime = sampleinfo.Exposuretime;
            saxs.empty_I0 = sampleinfo.IC/sampleinfo.Exposuretime;
            saxs.empty_BS = sampleinfo.BS/sampleinfo.Exposuretime;
            %else
            %    saxs.background_I0 = 1;
            %end
        catch
            saxs.empty_exptime = 1;
            saxs.empty_I0 = 1;
            saxs.empty_BS = 1;
            fprintf('Sampleinfo is not available. Default t, I0 and BS is applied to the air.\n');
        end
        
        setgihandle(saxs);
    end
    function uimenu_setmask(varargin)
        %figH = evalin('base', 'SAXSimageviewerhandle');
        %handles = guidata(figH);
%        img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = getgihandle;
        %t = find(handles.ImX<=0);
        img = saxs.image;
        img(img<=0) = NaN;
        saxs.maskimage = double(img);
        setgihandle(saxs);
    end
%--------------------------------------------------------------------------
% getPreviewImages
%   This is the TimerFcn for the preview timer object
%--------------------------------------------------------------------------
%   function getPreviewImages(varargin)
% 
% 
%   end


%--------------------------------------------------------------------------
% fixLongDirName
%   This truncates the directory string if it is too long to display
%--------------------------------------------------------------------------
    function newdirname = fixLongDirName(dirname)
    % Modify string for long directory names
        if length(dirname) > 20
          [~, tmp2] = strtok(dirname, filesep);
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
        figH = [];
        if numel(varargin) > 1
            if ishandle(varargin{2})
                figH = varargin{2};
            end
        end
        if isempty(figH)
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        handles = guidata(figH);
        %stopTimer;
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
%                handles.ImX = [];
                guidata(figH, handles)
                loadImage(fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), str{val}));
                %startTimer;
              end
          end

        end

    end

%--------------------------------------------------------------------------
% fileListBoxCallback
%   This gets called when an entry is selected in the file list box
%--------------------------------------------------------------------------
    function DirListBoxCallback(varargin)
        obj = varargin{1};
        figH = [];
        if numel(varargin) > 1
            if ishandle(varargin{2})
                figH = varargin{2};
            end
        end
        if isempty(figH)
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        handles = guidata(figH);
        %stopTimer;
        val = get(obj, 'value');
        str = cellstr(get(obj, 'string'));

        if ~isempty(str)

          switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'   % single click - show preview

            case 'open'   % double click - open image and display

              if str{val}(1) == '[' && str{val}(end) == ']'
                dirname = get(handles.CurrentDirectoryEdit, 'tooltipstring');
                newdirname = fullfile(dirname, str{val}(2:end-1));
%                                fileListBoxCallback(newdirname)

                showDirectory(newdirname)
              end
          end

        end

    end
%--------------------------------------------------------------------------
% chooseDirectoryCallback
%   This opens a directory selector
%--------------------------------------------------------------------------
    function chooseDirectoryCallback(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        %stopTimer;
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
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        %    stopTimer;
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
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        obj = varargin{1};
        %stopTimer;
        set(handles.MessageTextBox, 'visible', 'off');
%         set(handles.FileInfoBtn, 'value', false);
        ud = getappdata(handles.ImageAxes, 'tmpdata');
        switch get(obj, 'string')
          case 'Full'
            xlimit = ud.xlimFull;
            ylimit = ud.ylimFull;

          case '100%'
            xlimit = ud.xlim100;
            ylimit = ud.ylim100;
        end

        xl = xlim(handles.ImageAxes); xd = (xlimit - xl)/10;
        yl = ylim(handles.ImageAxes); yd = (ylimit - yl)/10;

        % Restore only if needed
        if ~(isequal(xd, [0 0]) && isequal(yd, [0 0]))

          set(handles.statusText, 'string', 'Restoring View...');

          % Animate with "good" speed
          for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

%             set(handles.ImageAxes, ...
%               'xlim'                , xl + xd * id, ...
%               'ylim'                , yl + yd * id, ...
%               'cameraviewanglemode' , 'auto', ...
%               'dataaspectratiomode' , 'auto', ...
%               'plotboxaspectratio'  , ud.pbar);
            set(handles.ImageAxes, ...
              'xlim'                , xl + xd * id, ...
              'ylim'                , yl + yd * id, ...
              'cameraviewanglemode' , 'auto', ...
              'dataaspectratiomode' , 'auto');

            getXYLim

            set(handles.ImageAxes           , 'DataAspectRatio', [1,1,1]);

            set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
              round(diff(ud.xlim100)/diff(xl + xd * id)*100)));

            pause(0.01);
          end

          set(handles.statusText, 'string', '');

        end

        %startTimer;

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

    function f = statustext_cleanup(imgvhandle, text)
        f = parfeval(backgroundPool,@myfun, 1, imgvhandle, text);
        function myfun(varargin)
            varargin
            set(imgvhandle.statusText, 'string', text);
            pause(2)
        end
    end
%--------------------------------------------------------------------------
% loadImage
%   This loads the selected image and displays it
%--------------------------------------------------------------------------

    function [valchosen, dettype] = choose_h5_groups(varargin)
        items = varargin{1};
        items2 = varargin{2};
        valchosen = 1;
        dettype = 1;
        d = dialog('Position',[300 300 250 250],'Name','Dataset');
        uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 150 210 25],...
               'String','Choose a dataset:');

        uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 130 100 25],...
               'String',items,...
               'Callback',@popup_choose_group_callback);
           
        uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 200 210 25],...
               'String','Detectors:');

        uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 180 100 25],...
               'String',items2,...
               'Callback',@popup_choose_detector_callback);
           
        uicontrol('Parent',d,...
               'Position',[89 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

        % Wait for d to close before running to completion
        uiwait(d);
       function popup_choose_group_callback(varargin)
           if ishandle(varargin{1})
               popup = varargin{1};
               idx = popup.Value;
               popup_items = popup.String;
               valchosen = idx;
               close(d)
           end
       end
       function popup_choose_detector_callback(varargin)
           if ishandle(varargin{1})
               popup = varargin{1};
               idx = popup.Value;
               popup_items = popup.String;
               dettype = idx;
               %close(d)
           end
       end
    end
    function valchosen = choose_beamlines(varargin)
        items = {'12-ID-B', '12-ID-C', 'NSLSII-LiX', 'NSLSII-LiX-WAXS'};

        d = dialog('Position',[300 300 250 250],'Name','Dataset');
        uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 200 210 25],...
               'String','Choose a dataset:');

        uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 180 100 25],...
               'String',items,...
               'Callback',@popup_choose_beamline_callback);
           

        uicontrol('Parent',d,...
               'Position',[89 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

        % Wait for d to close before running to completion
        uiwait(d);
        function popup_choose_beamline_callback(varargin)
               if ishandle(varargin{1})
                   popup = varargin{1};
                   idx = popup.Value;
                   popup_items = popup.String;
                   valchosen = popup_items{idx};
                   close(d)
               end
           end
    end
    function loadImage(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        sampleinfo = [];
        if isfield(handles, 'statusText')
            set(handles.statusText, 'string', 'Loading Image...');
        end
        filename = [];
        if numel(varargin) ==1
            if ischar(varargin{1})
                filename = varargin{1};
            else
                filename = [];
                saxsimage = varargin{1};
            end
        end

        if numel(varargin) >= 2
            saxs = varargin{2};
        else
            saxs = getgihandle;
        end
        ind2dis = 1;
        if numel(varargin) == 3
            ind2dis = varargin{3};
        end
        if ~isempty(filename)
%            if ~isfield(saxs, 'beamline')
            saxs.beamline = 'unknown';
            [~, ~, ext] = fileparts(filename);
            if contains(ext, {'.h5', '.hdf'})
                try
                    att = h5readatt(filename, '/entry', 'NX_class');
                catch
                    saxs.beamline = 'NSLSII-LiX';
                end
                %%% check if data is from APS 12ID %%%
                try
                    saxs.beamline = h5read(filename, '/entry/instrument/source/facility_beamline');
                catch
                    
                end
    
                %%% check if data is from LiX beamline %%%
                if strcmp(saxs.beamline, 'unknown')
                    try
                        att = h5readatt(filename, '/', 'detectors');
                        saxs.beamline = 'NSLSII-LiX';
                    catch
                        saxs.beamline = '12-ID';
                    end
                end
    %            end
                if contains(saxs.beamline, '12-ID')
                    saxs.h5entry = '/entry/data/data';
                end
                if contains(saxs.beamline, 'NSLSII-LiX')
                    dt = h5info(filename);
                    n_group = 0;
                    if numel(dt.Groups)==1
                        %dt = dt.Groups;
                    end

                    groupName = {};
                    for i=1:numel(dt.Groups)
                        %fprintf('%s\n', dt.Groups(i).Name)
                        groupName{i} = dt.Groups(i).Name;
                    end
                    %n_group = input('Which group you want to read? ');
                    detectors = {'SAXS', 'WAXS'};
                    [n_group, dettype] = choose_h5_groups(groupName, detectors);
                    
                    if dettype == 1
                        saxs.beamline = 'NSLSII-LiX';
                    else
                        saxs.beamline = 'NSLSII-LiX-WAXS';
                    end
                    if ~isempty(filename)
                        [~, fn, ~] = fileparts(filename);
                        if n_group > 0
                            fn = sprintf('%s', dt.Groups(n_group).Name);
                        end
                    end
                    if strcmp(saxs.beamline, 'NSLSII-LiX')
                        saxs.h5entry = sprintf('/%s/pil/data/pil1M_image', fn);
                    end
                    if strcmp(saxs.beamline, 'NSLSII-LiX-WAXS')
                        saxs.h5entry = sprintf('/%s/pil/data/pilW2_image', fn);
                    end
                end
            end
        end

        % data loading 
        isnew = false;
        if ~isempty(filename)  % from file
%            [saxs, handles] = SAXSimageviwerLoadimage(filename, saxs, handles);
            try
                saxs = SAXSimageviwerLoadimage(filename, saxs, handles);
            catch
                if contains(filename, '.h5')
%                    if ~isfield(saxs, 'beamline')
                        valchosen = choose_beamlines;

                        saxs.beamline = valchosen;
                        setgihandle(saxs)
%                    end
                end
            end
            if ismatrix(saxs.image)
                set(handles.FlipHDFright, 'enable', 'off')
                set(handles.FlipHDFleft, 'enable', 'off')
            else
                set(handles.FlipHDFright, 'enable', 'on')
                set(handles.FlipHDFleft, 'enable', 'on')
                s = sprintf('A HDF file with %i frames is loaded.', size(saxs.image, 3));
                set(handles.statusText, 'string', s);
            end
            saxs.frame = 1;
            isnew = true;
            if isfield(saxs, 'ai')
                if numel(saxs.ai) > 1
                    saxs.ai = saxs.ai(end);
                end
            end
        else                   % from input.
            if numel(varargin) == 3
                saxs.frame = ind2dis;
            else
                saxs.image = double(saxsimage);
            end
%            handles.ImX = saxs.image;
        end
        if isnew
            if isfield(saxs, 'offset')
                saxs.image = saxs.image - saxs.offset;
    %            handles.ImX = handles.ImX - saxs.offset;
            end
    
            if isfield(saxs, 'imgoperation')
                if isfield(saxs.imgoperation, 'LeftRight')
                    if saxs.imgoperation.LeftRight
                        saxs.image = fliplr(saxs.image);
    %                    handles.ImX = saxs.image;
                    end
                end
                if isfield(saxs.imgoperation, 'Transpose')
                    if saxs.imgoperation.Transpose
                        saxs.image = transpose(saxs.image);
    %                    handles.ImX = saxs.image;
                    end
                end
                if isfield(saxs.imgoperation, 'UpDown')
                    if saxs.imgoperation.UpDown
                        saxs.image = flipud(saxs.image);
    %                    handles.ImX = saxs.image;
                    end
                end
            end
    
            try
                sampleinfo = evalin('base', 'sampleinfo');
            catch
                sampleinfo = [];
            end
    
            % -------------------------------------------------------------------------
            % Data normalization and/or background subtraction.
            % -------------------------------------------------------------------------
            % Apply mask
            if isfield(saxs, 'maskimage')
    %            handles.ImX = handles.ImX.*saxs.maskimage;
                saxs.image = saxs.image.*saxs.maskimage;
            end
            
            % Check all the normalization options.
            qExptimeNorm = 0;
            if isfield(saxs, 'qtime_normalize')
                qExptimeNorm = saxs.qtime_normalize;
            end
            
            isSampleInfoReady = 0;
            if ~isempty(sampleinfo)
                if strcmp(saxs.imagename, sampleinfo.Filename{1})
                    isSampleInfoReady = 1;
                end
            end
            IC = 1;
            if isSampleInfoReady
                BS = sampleinfo.BS./sampleinfo.Exposuretime;
                IC = sampleinfo.IC./sampleinfo.Exposuretime;
            end
            
            qTransNorm = 0;
            if isfield(saxs, 'qTrans4BSF')
                qTransNorm = saxs.qTrans4BSF;
            end
            
            qSampleThickness = 0;
            if isfield(saxs, 'qSampleThickness')
                qSampleThickness = saxs.qSampleThickness;
            end
            
            qBackSubtract = 0;
            if isfield(saxs, 'backgroundimage') && isfield(saxs, 'qBackSubtract')
                qBackSubtract = saxs.qBackSubtract;
            end
            
            qScaleFactor = 0;
            if isfield(saxs, 'qScaleFactor')
                if isfield(saxs, 'ScaleFactor')
                    qScaleFactor = saxs.qScaleFactor;
                else
                    fprintf('ScaleFactor is not defined. Put a value and hit enter.\n');
                end
            end
            
            qPolarization = 0;
            if isfield(saxs, 'polarization')
                qPolarization = 1;
                PolFactor = saxs.polarization;
            end
            
            qAirPath = 0;
            if isfield(saxs, 'airpath')
                qAirPath = 1;
                AirPathFactor = saxs.airpath;
            end
            
            qDetPath = 0;
            if isfield(saxs, 'detpath')
                qDetPath = 1;
                DetPathFactor = saxs.detpath;
            end
            
            qScaleI0 = 0;
            if isfield(saxs, 'qScaleI0')
                qScaleI0 = saxs.qScaleI0;
                if isfield(saxs, 'qScaleI0')
                    qScaleI0 = saxs.qScaleI0;
                else
                    fprintf('ScaleI0 is not defined. Put a value and hit enter.\n');
                end
            end
            
            % Time normalization
            if qExptimeNorm 
                if isSampleInfoReady
    %                handles.ImX = handles.ImX/sampleinfo.Exposuretime;
                    saxs.image = saxs.image/sampleinfo.Exposuretime;
                else
                    error('Turn off the exposure time normalization option or turn on the auto update option');
                end
            end
            
            % Calculate Transmittance
            defaultT = -999;
            Transmittance = defaultT;
            if isfield(saxs, 'empty_BS') && isSampleInfoReady && qTransNorm
                Transmittance = BS/saxs.empty_BS/IC*saxs.empty_I0;
                fprintf('Transmittance of the sample may be %0.4f\n', Transmittance);
            end
            
            % Background subtraction.
            if qBackSubtract
                SSF = 1;
                %BSF = 1;
                if qTransNorm
                    if Transmittance == defaultT
                        s = ['To compute Transmittance,',...
                            ' 1. an empty air data should be defined.',...
                            ' 2. specfile should be loaded.', ...
                            ' 3. Auto Update option should be turned on.'];
                        error(s);
                    end
                    BSF = 1/saxs.background_T;
                    SSF = 1/Transmittance;
                else
                    BSF = saxs.BackScaleFactor;
                end
                if BSF < 0
                    fprintf('BSF is negative. Make sure this is true.\n');
                end
                
                if qExptimeNorm
                    BSF = BSF/saxs.background_exptime;
                end
                
                if qScaleI0
                    FN = saxs.ScaleI0Fieldname;
                    if strcmp(FN, 'BS')
                        if isfield(sampleinfo, FN)
                            Normv = 1/sampleinfo.(FN);
                            saxs.image = saxs.image*Normv;
                        end
                    else
                        BSF = BSF/saxs.background_I0*IC;
                        fprintf('I0/I0back = %0.3f.\n', IC/saxs.background_I0);
                    end
                end
                saxs.image = SSF*saxs.image - BSF*saxs.backgroundimage;
            else
                if qScaleI0
                    FN = saxs.ScaleI0Fieldname;
                    if isfield(sampleinfo, FN)
                        Normv = 1/sampleinfo.(FN);
                        saxs.image = saxs.image*Normv;
                   end
                end
            end
            
            if qScaleFactor
                saxs.image = saxs.image*saxs.ScaleFactor;
            end
    
            
            if qSampleThickness
                saxs.image = saxs.image/saxs.SampleThickness;
            end
            
            if qPolarization
                saxs.image = saxs.image./PolFactor;
            end
            
            if qAirPath
                saxs.image = saxs.image.*AirPathFactor;
            end
            
            if qDetPath
                saxs.image = saxs.image.*DetPathFactor;
            end
            
    %        saxs.image = handles.ImX;
    
            if qScaleI0 && qScaleFactor
                if ~isfield(saxs, 'empty_I0')
                    fprintf('NOTE: If an empty air data is not defined, the absolute intensity conversion cannot be done.\n');
    %             else
    %                 fprintf('Finally, you need to divide data by the sample thickness(cm) to obtain data in an absolute scale\n');
                end
            end
        end
        
        %
        % -------------------------------------------------------------------------      

        %try
        %if ~isempty(findobj('tag', 'gisaxsleenew'))
        if isfield(saxs, 'isAutoSetupUpdate')
            if saxs.isAutoSetupUpdate == 1
                setgihandle(saxs);
                gisaxsleenew('SetSAXSValues');
            end
        end
        %end
        if ~isempty(sampleinfo)
            saxs.xeng = sampleinfo.Energy;
            saxs.waveln = eng2wl(saxs.xeng);
            saxs.ai = sampleinfo.th;
        end

        if ~checkSAXS(saxs, 'CCD')
            if isfield(handles, 'iH')
                %set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'CData', handles.ImX);
                set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'CData', saxs.image);
            else
                if isfield(saxs, 'frame')
                    ind2dis = saxs.frame;
                    filename = saxs.imgname;
                else
                    ind2dis = 1;
                end
                iH = imagesc(saxs.image(:, :, ind2dis), 'parent', handles.ImageAxes);
                set(iH, 'tag', 'SAXSimageviewerImage')
%                iH = imagesc(handles.ImX, 'parent', handles.ImageAxes);
%                findobj(gcbf, 'tag', 'SAXSimageviewerImage') = iH;
            end
%            guidata(figH, handles);
%            setXYLim
%            figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        else
%            findobj(gcbf, 'tag', 'SAXSimageviewerImage') = saxs.imghandle;
        end


        set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'hittest', 'off');
        set(handles.ImageAxes, ...
            'box'                       ,'off',...
            'XAxisLocation'             ,'top',...
            'YAxisLocation'             ,'right',...  
            'interruptible'   , 'off', ...
            'busyaction'      , 'queue', ...
            'handlevisibility', 'callback', ...);
            'buttondownfcn'   , @winBtnDownFcn);

        set(handles.ImageAxes           , 'DataAspectRatio', [1,1,1]);
        set(handles.ResetViewBtn1, 'enable', 'on');
        set(handles.ResetViewBtn2, 'enable', 'on');
%         set(handles.FileInfoBtn  , 'enable', 'on');
        [~, fname, ext] = fileparts(filename);
        set(get(handles.ImageAxes, 'title'), ...
            'string'      , sprintf('%s%s', fname, ext), ...
            'interpreter' , 'none');
        

        % NEED to be modified
        ud.pbar     = get(handles.ImageAxes, 'plotboxaspectratio');
        %xlimFull = get(handles.ImageAxes, 'xlim');
        %ylimFull = get(handles.ImageAxes, 'ylim');

        % If image is small, show at 100% size
        sz              = size(saxs.image);
        xlimFull = [1, sz(2)];
        ylimFull = [1, sz(1)];
        udf = getappdata(figH, 'tmpdata');
        %figPos = udf.figPos;
        axPos = udf.axPos;
        %setappdata(figH, 'tmpdata', udf);
        
        xlim100 = sz(2)/2 + [-1, 1] * axPos(3)/2;
        ylim100 = sz(1)/2 + [-1, 1] * axPos(4)/2;
%        handles.xlim100 = xlim100;
%        handles.ylim100 = ylim100;
        ud.xlimFull = xlimFull;
        ud.ylimFull = ylimFull;
        ud.xlim100 = xlim100;
        ud.ylim100 = ylim100;
        setappdata(handles.ImageAxes, 'tmpdata', ud);


        if all(axPos(3:4) > sz([2 1]))
            if isfield(handles, 'xlim100')
             set(handles.ImageAxes, ...
               'xlim'                , handles.xlim100, ...
               'ylim'                , handles.ylim100, ...
               'cameraviewanglemode' , 'auto', ...
               'dataaspectratiomode' , 'auto');
            end
             set(handles.ZoomCaptionText, 'string', '100 %');

        else
            set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
            round(diff(xlim100)/diff(xlimFull)*100)));
        end

        setgihandle(saxs);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(handles.ImageAxes, 'ydir', 'normal');

%        guidata(figH, handles);

        if strcmp(get(handles.ToggleLogLin, 'state'), 'on')
            loglinConvert([],[],'log');
            figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        else
            if (isfield(saxs, 'image'))
%                if ishandle(findobj(gcbf, 'tag', 'SAXSimageviewerImage'))
%                    set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'cdata', saxs.image);
                    set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'CData', saxs.image(:,:,ind2dis));
%                end
            end
        end

        setXYLim;


        colorbarCallback;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        setgihandle(saxs);
        
%         set(handles.ImageAxes, 'xlim', xlimFull);
%         set(handles.ImageAxes, 'ylim', ylimFull);
%        set(handles.ImageAxes, 'xlim', xlim100);
%        set(handles.ImageAxes, 'ylim', ylim100);
        
        %set(handles.statusText, 'string', '');
        
        setColor
        %set(handles.CoordinateAxes, 'plotboxaspectratio', get(handles.ImageAxes, 'plotboxaspectratio'));
        CoordinateAxes2ImageAxes(saxs);
        
        drawnow;
        
        % check number of handles on the imageaxes.....
        % BLEE
        % size(findobj(gcf, 'type', 'axes'))
    end



%--------------------------------------------------------------------------
% clearImageAxes
%   This clears the image axis
%--------------------------------------------------------------------------
    function clearImageAxes(varargin)
        if numel(varargin) > 0 
            figH = varargin{1};
        else
            figH = evalin('base', 'SAXSimageviewerhandle');
        end
        handles = guidata(figH);

    %    cla(handles.ImageAxes);
    %    axis(handles.ImageAxes, 'normal');
        if isfield(handles, 'ImageAxes')
            set(get(handles.ImageAxes, 'title') , 'string'        , '');
            set(handles.ImageAxes               , 'buttondownfcn' , '');
            set(handles.ResetViewBtn1           , 'enable'        , 'off');
            set(handles.ResetViewBtn2           , 'enable'        , 'off');
%             set(handles.FileInfoBtn             , 'enable'        , 'off', ...
%               'value'         , false);
            set(handles.ZoomCaptionText         , 'string'        , '');
            set(handles.MessageTextBox          , 'visible'       , 'off');
%            handles.ImX = [];
%            guidata(figH, handles);
        end
    end
%--------------------------------------------------------------------------
% clearImageAxes
%   This clears the image axis
%--------------------------------------------------------------------------
    function CoordinateAxes2ImageAxes(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        if numel(varargin) == 1
            saxs = varargin{1};
        else
            saxs = getgihandle;
        end

        xl = get(handles.ImageAxes, 'xlim');
        yl = get(handles.ImageAxes, 'ylim');
        if isfield(saxs, 'center')
          if isfield(saxs, 'axistype') % draw axis based on reflected beam
              switch saxs.axistype
                  case 'q'
                      axistype = 0;
                  case 'af'
                      axistype = 1;
                  case 'qrz'
                      axistype = 2;
                  case 'dX'
                      axistype = 3;
              end
          else
              axistype = 0;
          end
          switch axistype
              case 3
                  %cy = pixel2angle([0, saxs.ai], saxs.center, saxs.SDD, saxs.psize, [], 1);
                  xl = (xl - saxs.center(1));
                  yl = yl - saxs.center(2);
                  %xl = xl*q2angle(saxs.pxQ, saxs.waveln);
                  %yl = yl*q2angle(saxs.pxQ, saxs.waveln);
                xlabel(handles.CoordinateAxes, sprintf('X_{f}'), 'fontsize', 14)
                ylabel(handles.CoordinateAxes, sprintf('Y_{f}'), 'fontsize', 14)
              case 1
                  cy = pixel2angle([0, saxs.ai], saxs.center, saxs.waveln, saxs.SDD, saxs.psize, [], 1);
                  xl = (xl - saxs.center(1));
                  yl = yl - cy(2);
                  xl = xl*q2angle(saxs.pxQ, saxs.waveln);
                  yl = yl*q2angle(saxs.pxQ, saxs.waveln);
                  if handles.SSL_RightHandCoordinate.Checked == 1
                      xlabel(handles.CoordinateAxes, sprintf('-2%c_{f} (deg)', char(952)), 'fontsize', 14)
                  else
                      xlabel(handles.CoordinateAxes, sprintf('2%c_{f} (deg)', char(952)), 'fontsize', 14)
                  end
                ylabel(handles.CoordinateAxes, sprintf('%c_{f} (deg)', char(945)), 'fontsize', 14)
              case 2
                  cy = pixel2angle([0, saxs.ai*2], saxs.center, saxs.waveln, saxs.SDD, saxs.psize, [], 1);
                  xl = (xl - saxs.center(1));
                  yl = yl - saxs.center(2)- cy(2);
                  xl = xl*saxs.pxQ;
                  yl = yl*saxs.pxQ;
                xlabel(handles.CoordinateAxes, sprintf('q_{xy} (%c^{-1})', char(197)), 'fontsize', 14)
                ylabel(handles.CoordinateAxes, sprintf('q_{rz} (%c^{-1})', char(197)), 'fontsize', 14)
              case 0
                  xl = (xl - saxs.center(1));
                  yl = yl - saxs.center(2);
                  xl = xl*saxs.pxQ;
                  yl = yl*saxs.pxQ;
                  if handles.SSL_RightHandCoordinate.Checked == 1
                      xlabel(handles.CoordinateAxes, sprintf('-q_y (%c^{-1})', char(197)), 'fontsize', 14)
                  else
                      xlabel(handles.CoordinateAxes, sprintf('q_y (%c^{-1})', char(197)), 'fontsize', 14)
                  end
                ylabel(handles.CoordinateAxes, sprintf('q_z (%c^{-1})', char(197)), 'fontsize', 14)
          end
        end

        try
            set(handles.CoordinateAxes, 'xlim', xl);
            set(handles.CoordinateAxes, 'ylim', yl);
        catch
            error('error in CoordinateAxes2ImageAxes')
        end
%        set(handles.CoordinateAxes, 'position', get(handles.ImageAxes, 'position'));
%        set(handles.CoordinateAxes, 'PlotBoxAspectRatio', get(handles.ImageAxes, 'PlotBoxAspectRatio'));
    end

% short cuts......
    function winKeyPressFcn(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
         %src = varargin{1};
         evnt = varargin{2};
         if (length(evnt.Modifier) == 1) && strcmp(evnt.Modifier{:},'control') && (strcmp(evnt.Key, 'h'))
             ImgAnalysis('pb_H_Callback');
         elseif (length(evnt.Modifier) == 1) && strcmp(evnt.Modifier{:},'control') && (strcmp(evnt.Key, 'v'))
             ImgAnalysis('pb_V_Callback');
         end

         if length(evnt.Modifier) == 1 && strcmp(evnt.Modifier{:},'alt') && strcmp(evnt.Key, 'b')
             val = get(handles.FileListBox, 'value')-1;
             if val>0
                 set(handles.FileListBox, 'value', val);
                 set(handles.SAXSImageViewer, 'selectiontype', 'open')
                 fileListBoxCallback(handles.FileListBox);
             else
                 disp('error: this is the first image');
             end
         end

         if length(evnt.Modifier) == 1 && strcmp(evnt.Modifier{:},'alt') && strcmp(evnt.Key, 'f')
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
         if length(evnt.Modifier) == 1 && strcmp(evnt.Modifier{:},'alt') && strcmp(evnt.Key, '1')
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
         if length(evnt.Modifier) == 1 && strcmp(evnt.Modifier{:},'alt') && strcmp(evnt.Key, '2')
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


%--------------------------------------------------------------------------
% winBtnDownFcn
%   This is called when the mouse is clicked in one of the axes
%   NORMAL clicks will start panning mode.
%   ALT clicks will start zooming mode.
%   OPEN clicks will center the view.
%--------------------------------------------------------------------------
    function winBtnDownFcn(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        obj = varargin{1};
        set(handles.MessageTextBox, 'visible', 'off');
%         set(handles.FileInfoBtn, 'value', false);
        udf = getappdata(figH, 'tmpdata');
        %ud = getappdata(handles.ImageAxes, 'tmpdata');
        %figPos = get(figH, 'position');

        switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'

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
            udf.xy = xy;
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

            xl = get(obj, 'xlim'); midX = mean(xl); rngXhalf = diff(xl)/2;
            yl = get(obj, 'ylim'); midY = mean(yl); rngYhalf = diff(yl)/2;
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
            udf.curPt = curPt;
            udf.curPt2 = curPt2;
            udf.initPt = initPt;
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
            %ud.figPos = figPos;
            %udf.figPos = get(handles.SAXSImageViewer, 'position');
            %setappdata(figH, 'tmpdata', udf);
            %guidata(figH, handles);

            % get distance between cursor and center of axes
            d = norm(pt2 - (udf.figPos(1:2) + axPos(1:2) + axPos(3:4)/2));

            if d > 2  % center only if distance is at least 2 pixels away
              ld = (mean(pt(:, 1:2)) - [midX, midY]) / 10;
              pd = ((udf.figPos(1:2) + axPos(1:2) + axPos(3:4) / 2) - pt2) / 10;

              set(handles.statusText, 'string', 'Centering...');

              % Animate with "good" speed
              for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

                set(obj, ...
                  'xlim'                , xl + id * ld(1), ...
                  'ylim'                , yl + id * ld(2), ...
                  'cameraviewanglemode' , 'auto');

                % Move pointer with limits
                %set(0, 'pointerlocation', pt2 + id * pd);

                pause(0.01);
              end

            end
            % Reset UNITS
            set(0, 'units', un);
            % Read XY lim to text edit box ...
            
            setXYLim([xl + id * ld(1), yl + id * ld(2)]);
        end

        
        setappdata(figH, 'tmpdata', udf);


        %----------------------------------------------------------------------
        % winBtnMotionFcn (nested under winBtnDownFcn)
        %   This function is called when click-n-drag (panning) is happening
        %----------------------------------------------------------------------
        function winBtnMotionFcn(varargin)
            figHn = evalin('base', 'SAXSimageviewerhandle');
            handlesn = guidata(figHn);
            udfn = getappdata(figHn, 'tmpdata');
            ptn = get(handlesn.ImageAxes, 'currentpoint');

            set(handlesn.ImageAxes, ...
                'xlim', get(handlesn.ImageAxes, 'xlim') + ...
                    (udfn.xy(1,1)-(ptn(1,1)+ptn(2,1))/2), ...
                'ylim', get(handlesn.ImageAxes, 'ylim') + ...
                    (udfn.xy(1,2)-(ptn(1,2)+ptn(2,2))/2));

            % Q axis....
            CoordinateAxes2ImageAxes
            set(handlesn.statusText, 'string', 'Panning...');
            getXYLim

        end
    


        %----------------------------------------------------------------------
        % zoomMotionFcn (nested under winBtnDownFcn)
        %   This performs the click-n-drag zooming function. The pointer
        %   location relative to the initial point determines the amount of
        %   zoom (in or out).
        %----------------------------------------------------------------------
        function zoomMotionFcn(varargin)
            figHn = evalin('base', 'SAXSimageviewerhandle');
            handlesn = guidata(figHn);

            % Power law allows for the inverse to work:
            %      C^(x) * C^(-x) = 1
            % Choose C to get "appropriate" zoom factor
            
            udfn = getappdata(figHn, 'tmpdata');

            C                   = 50;
            objn                 = varargin{1};
            ptn                  = get(objn, 'currentpoint');
            r                   = C ^ ((udfn.initPt(2) - ptn(2)) / udfn.figPos(4));
            newLimSpan          = r * udfn.curPt2; 
            dTemp = diff(newLimSpan);
            ptn(1)               = udfn.initPt(1);

            % Determine new limits based on r
            lims                = udfn.curPt + newLimSpan;

            % Update axes limits and automatically set ticks
            % Set aspect ratios
%             set(handles.ImageAxes, ...
%             'xlim'                , lims(:,1), ...
%             'ylim'                , lims(:,2), ...
%             'plotboxaspectratio'  , ud.pbar);
            set(handlesn.ImageAxes, ...
            'xlim'                , lims(:,1), ...
            'ylim'                , lims(:,2));

            % Q axis .................
            CoordinateAxes2ImageAxes;

            % Read xylim to edit box
            getXYLim

%            set(handles.CoordinateAxes, 'plotboxaspectratio', get(handles.ImageAxes, 'plotboxaspectratio'));

              % Update zoom indicator line
        %      get(handles.ZoomLine)
            set(handlesn.ZoomLine, ...
                'xdata', [udfn.initPt(1), ptn(1)]/udfn.figPos(3), ...
                'ydata', [udfn.initPt(2), ptn(2)]/udfn.figPos(4));
            udn = getappdata(handlesn.ImageAxes, 'tmpdata');

            set(handlesn.ZoomCaptionText, 'string', sprintf('%d %%', ...
                round(diff(udn.xlim100)/dTemp(1)*100)));

        end
    end

  


%--------------------------------------------------------------------------
% winBtnUpFcn
%   This is called when the mouse is released
%--------------------------------------------------------------------------
    function winBtnUpFcn(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        obj = varargin{1};
        set(obj, ...
          'pointer'               , 'arrow', ...
          'windowbuttonmotionfcn' , '');
        set(handles.statusText, 'string', '');
        set(handles.ZoomLine, 'xdata', NaN, 'ydata', NaN);
        set(handles.SAXSImageViewer, 'windowbuttonupfcn', '');

    %startTimer;

    end


%% mouse move callback
% read data values....
    function gtrack_OnMouseMove(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);

    % get mouse position
        pt = get(handles.ImageAxes, 'CurrentPoint');
        %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = get(figH, 'userdata');
        img = saxs.image;
        xInd = round(pt(1, 1));
        yInd = round(pt(1, 2));
        %texthandles = findobj(handles.ImageAxes, 'type', 'text');
        %if ~isempty(texthandles)
        peakstr = [];

        % check if its within axes limits
        xlimvalue = get(handles.ImageAxes, 'XLim');	
        ylimvalue = get(handles.ImageAxes, 'YLim');
        if xInd < xlimvalue(1) || xInd > xlimvalue(2)
            %pos_valuestr = ['Out of X limit'];	
            return;
        end
        if yInd < ylimvalue(1) || yInd > ylimvalue(2)
            %pos_valuestr = ['Out of Y limit'];
            return;
        end

    % read intensity value....
        try
            ImValue = img(yInd, xInd);
        catch
            ImValue = NaN;
        end

          % save selected point
        handles.MousexInd = xInd;
        handles.MouseyInd = yInd;
        handles.MousezInd = ImValue;

        saxs = getgihandle;

        %[tthf, af] = giangle(xInd, yInd, saxs);
        if isfield(saxs, 'tiltangle')
            ta = saxs.tiltangle;
        else
            ta = [];
        end
        if isfield(saxs, 'psize')
            psize = saxs.psize;
        else
            psize = [];
        end
        if ~isfield(saxs, 'ai')
            saxs.ai = 0;
        end

        if ~isfield(saxs, 'tthi')
            saxs.tthi = 0;
        end
        if ~isfield(saxs, 'waveln')
            saxs.waveln = 1;
        end

        ai = saxs.ai;
        tthi = saxs.tthi;
        if ~isfield(saxs, 'edensity')
            Ed = 0;
        else
            Ed = saxs.edensity;
        end
        if ~isfield(saxs, 'beta')
            Bt = 0;
        else
            Bt = saxs.beta;
        end
        try
            %ang = pixel2angle2([xInd, yInd], saxs.center, saxs.SDD, psize, ta);
            Pixel = bsxfun(@minus, [xInd, yInd], saxs.center);
            if handles.SSL_RightHandCoordinate.Checked == 1
                Pixel(:,1) = -Pixel(:,1);
            end
            [tthf, af] = pixel2angles(Pixel, saxs.SDD, saxs.psize, saxs.tiltangle);
            af = af - ai;
            
            %tthf = ang(:,1); af = ang(:,2)-ai;
        catch
            tthf = [];
%            ang = [];
        end
        if isempty(tthf)
            isgisaxs = -1;
        else
            if (Ed ~= 0) || (Bt ~= 0) || (saxs.ai ~= 0)
                isgisaxs = 1;
            else
                isgisaxs = 0;
            end
        end
        


        switch isgisaxs
            case 1
                [qx, qy, qxy, q1z, ~, q3z, ~, q1, ~, q3, ~] = ...
                    giangle2q(tthf, af, tthi, ai, saxs);
                q1z = real(q1z); %q2z = real(q2z); 
                q3z = real(q3z); %q4z = real(q4z);
                handles.q.qxy = qxy;
                handles.q.qz = q1z;
            case 0
                [q, th] = pixel2q([xInd, yInd], saxs);
                [qx, qy, qz] = angle2vq2(0, af, 0, tthf, saxs.waveln);%since ai=0
                %qxy = angle2q(tthf, saxs.waveln);
                %qz = angle2q(af, saxs.waveln);%since ai = 0
                %q = sqrt(qxy.^2 + qz.^2);
                qxy = sqrt(qx.^2+qy.^2);
                qy = qxy;
                qx = 0;
                handles.q.qxy = qxy;
                handles.q.qz = qz;
                handles.q.q = q;
                handles.q.th = th;
            otherwise
        end
        
        % Loading peak indexing
        try
            peak{1} = evalin('base', 'peakdata');
        catch
            peak{1} = [];
        end
        try
            peak{2} = evalin('base', 'peakdataT');
        catch
            peak{2} = [];
        end
        try
            peak{3} = evalin('base', 'peakdataR');
        catch
            peak{3} = [];
        end
        pstr = 'Indexing:';
        for i=1:3
            if ~isempty(peak{i})
                x = [peak{i}.qp] - xInd;
                y = [peak{i}.qz] - yInd;
                ind = find((abs(x)<2) & (abs(y)<2));
                if ~isempty(ind) 
                    pstr = sprintf('%s%s', peak{i}(ind).string);
                end   
            end
        end

%         figPos = get(gcbf, 'position');
%         pos = [300, figPos(4)-85]
%        pos(1) = xlimvalue(1)+fix(abs(xlimvalue(2)-xlimvalue(1))*0.02);
%        pos(2) = ylimvalue(2)-fix(abs(ylimvalue(2)-ylimvalue(1))*0.1);
%        pAxis = get(handles.ImageAxes, 'position');
%        pDisplayInfo = get(handles.DisplayInfo, 'position');
%         pos(1) = xlimvalue(1)-fix(abs(xlimvalue(2)-xlimvalue(1))*0.1)*2
%         pos(2) = ylimvalue(2)+fix(abs(ylimvalue(2)-ylimvalue(1))*0.1)
%         pos(1) = pAxis(1)-pDisplayInfo(1)+100;
%         pos(2) = 1400;
        
        try
            pos_valuestr = ['X = ', num2str(xInd,handles.titleFmt), ...
                ', Y = ', num2str(yInd,handles.titleFmt), ...
                ', Z = ', num2str(ImValue,handles.titleFmt)];
            coordinate = [];
            %if saxs.ai > 0
            switch isgisaxs
                case 1
                    coordinate.qx = qx;
                    coordinate.qy = qy;
                    coordinate.qxy = qxy;
                    coordinate.qtz = q1z;
                    coordinate.qrz = q3z;
                    coordinate.qt = q1;
                    coordinate.qr = q3;
                    coordinate.tthf = tthf;
                    coordinate.af = af;

                    postr1 = sprintf('%s', ...
                        ['2tth_{f} = ', num2str(tthf,handles.titleFmt),...
                        ', a_{f} = ', num2str(af,handles.titleFmt),...
                        ', a/2 = ', num2str((ai+af)/2,handles.titleFmt)]);
                    postr2 = sprintf('%s', ...
                        ['q_{x} = ', num2str(qx,handles.titleFmt),...
                        ', q_{y} = ', num2str(qy,handles.titleFmt),...
                        ', q_{xy} = ', num2str(qxy,handles.titleFmt)]);
                    postr3 = sprintf('%s', ...
                        ['q_{t,z} = ', num2str(q1z,handles.titleFmt),...
                        ', q_{r,z} = ', num2str(q3z,handles.titleFmt)]);
                    postr4 = sprintf('%s', ...
                        ['q_{t} = ', num2str(q1,handles.titleFmt),...
                        ', q_{r} = ' num2str(q3,handles.titleFmt)]);
                    if isfield(handles, 'txth')
                        if ishandle(handles.txth)
                            delete(handles.txth);
                        end
                    end

                    if isempty(peakstr)
                        printstr = sprintf('%s\n%s\n%s\n%s', ...
                            postr1,postr2,postr3,postr4);
                    else
                        printstr = sprintf('%s\n%s\n%s\n%s\n%s', ...
                            postr1,postr2,postr3,postr4,peakstr);
                    end
                    if length(pstr) > 5
                        printstr = sprintf('%s\n%s', printstr, pstr);
                    end
%                     handles.txth = text(pos(1), ...
%                         pos(2), printstr, ...
%                         'fontsize', 12, ...
%                         'backgroundcolor', [.7 .9 .7], ...
%                         'parent', handles.ImageAxes);
%                    po = get(handles.DisplayCoordInfo, 'position');
                    % , [300, figPos(4)-100, figPos(3)-550, 60]
%                    po(4) = 80;
                    set(handles.DisplayCoordInfo, 'string', sprintf('%s', printstr));
                case 0

                    coordinate.qy = qy;
                    coordinate.qz = qz;
                    coordinate.q = q(1);
                    coordinate.tthf = tthf;
                    coordinate.af = af;
                    coordinate.th = th;


                     postr1 = sprintf('2D powder:\n%s', ...
                         ['2tth_{f} = ', num2str(tthf,handles.titleFmt),... 
                         ', a_{f} = ', num2str(af,handles.titleFmt)]);
                     postr2 = sprintf('%s', ...
                         ['q_{y} = ', num2str(qxy,handles.titleFmt),...
                         ', q_{z} = ', num2str(qz,handles.titleFmt)]);
                     postr3 = sprintf('3D powder:\n%s', ...
                         ['q = ', num2str(coordinate.q,handles.titleFmt), ...
                         ', phi = ', num2str(th*180/pi, '%0.2f')]);
                     if isfield(handles, 'txth')
                        if ishandle(handles.txth)
                            delete(handles.txth);
                        end
                     end

                    if isempty(peakstr)
                        printstr = sprintf('%s\n%s\n%s', ...
                            postr1,postr2,postr3);
                    else
                        printstr = sprintf('%s\n%s\n%s\n%s', ...
                            postr1,postr2,postr3,peakstr);
                    end
                    if length(pstr) > 5
                        printstr = sprintf('%s\n%s', printstr, pstr);
                    end
%                     handles.txth = text(pos(1), ...
%                          pos(2), printstr,...
%                          'fontsize', 12, ...
%                          'backgroundcolor', [.7 .9 .7],...
%                          'parent', handles.ImageAxes);
                    set(handles.DisplayCoordInfo, 'string', sprintf('%s', printstr));
                otherwise

            end
            coordinate.x = xInd;
            coordinate.y = yInd;
            handles.coordinate = coordinate;
            
            guidata(figH, handles);
            
        catch
            gtrack_Off()
            error('GTRACK: Error printing coordinates. Check that you used a valid format string.')
        end

        set(handles.DisplayInfo, 'string', sprintf('%s', pos_valuestr));
    end


% mouse click callback
    function gtrack_OnMouseDown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        pt = get(handles.ImageAxes, 'CurrentPoint');
        xInd = pt(1, 1);
        yInd = pt(1, 2);

        try
            mpoint = evalin('base', 'mousepnt');
        catch
            mpoint = [];
            mpoint.x = [];
            mpoint.y = [];
            mpoint.qxy = [];
            mpoint.qz = [];
        end

        switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'
                Xp = xInd;Yp=yInd;
                handles.selectedX = [handles.selectedX, Xp];
                handles.selectedY = [handles.selectedY, Yp];
                guidata(figH, handles);
                %if strcmp(get(handles.ToggleDataKeeper, 'State'), 'on')
                if ~isfield(mpoint, 'x')
                    mpoint = [];
                    mpoint.x = Xp;
                    mpoint.y = Yp;
                else
                    mpoint.x = [mpoint.x,Xp];
                    mpoint.y = [mpoint.y,Yp];
                end
                if isfield(handles, 'q')
                    mpoint.qxy = [mpoint.qxy, handles.q.qxy];
                    mpoint.qz = [mpoint.qz, handles.q.qz];
                end
                assignin('base', 'mousepnt', mpoint);
                %end
            case 'extend'
                %gtrack_Off
                %OfftoggleBtCallback;
            case 'alt'
                %gtrack_Off
                %OfftoggleBtCallback;
    %            winBtnDownFcn(handles.ImageAxes);
            otherwise
        end

    end

    function RemoveMouseSelects(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        handles.selectedX = [];
        handles.selectedY = [];
        guidata(figH, handles);
    end

% terminate callback
    function gtrack_Off(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        handles.selectedX = [];
        handles.selectedY = [];

        % restore default figure properties
        set(figH, 'windowbuttonmotionfcn', handles.currFcn);
        set(figH, 'windowbuttondownfcn', handles.currFcn2);
        set(figH,'Pointer','arrow');
        %title(handles.currTitle);
        uirestore(handles.theState);
        handles.ID=0;
        set(handles.ToggleReadValue, 'state', 'off');
        if isfield(handles, 'txth')
            if ishandle(handles.txth)
                delete(handles.txth);
            end
        end

        %    rest = 1;
        guidata(figH, handles);
    end
% terminate callback

    function gtrack_start(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
    %src,evnt
        handles.titleFmt = '%3.5f';
        handles.selectedX = [];
        handles.selectedY = [];
        % get current figure event functions
        currFcn = get(figH, 'windowbuttonmotionfcn');
        currFcn2 = get(figH, 'windowbuttondownfcn');
    %    currTitle = get(get(gca, 'Title'), 'String');
    % add data to figure handles
        if (isfield(handles,'ID') && handles.ID==1)
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

        guidata(figH, handles);

    % set event functions 

        set(gcf,'Pointer','crosshair');
        set(gcf, 'windowbuttonmotionfcn', @gtrack_OnMouseMove);        
        set(gcf, 'windowbuttondownfcn', @gtrack_OnMouseDown);          
    end

    function flipHDFright(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
%        action = varargin{3};
        saxs = getgihandle;
        if ~isfield(saxs, 'frame')
            saxs.frame = 1;
        end
        setgihandle(saxs)
        imgnumber = 1;
        if ismatrix(saxs.image)
            saxs.frame = 1;
        else
            imgnumber = size(saxs.image, 3);
            if saxs.frame < imgnumber
                saxs.frame = saxs.frame+1;
                loadImage([], saxs, saxs.frame)
            end
        end
        saxs = getgihandle;
        s = sprintf("Frame index = %i/%i\n", saxs.frame, imgnumber);
        %s = sprintf('Current frame number is %d', saxs.frame);
        set(handles.statusText, 'string', s);

    end
    function flipHDFleft(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        %action = varargin{3};
        saxs = getgihandle;
        imgnumber = 1;
        if ~isfield(saxs, 'frame')
            saxs.frame = 1;
        end
        setgihandle(saxs)
        if ismatrix(saxs.image)
            saxs.frame = 1;
        else
            imgnumber = size(saxs.image, 3);
            if saxs.frame >= 2
                saxs.frame = saxs.frame-1;
                loadImage([], saxs, saxs.frame)
            end
        end
        saxs = getgihandle;
        s = sprintf("Image index = %i/%i", saxs.frame, imgnumber);
        set(handles.statusText, 'string', s);
    end
    function loglinConvert(varargin)
    %src,evnt
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        action = varargin{3};
        saxs = getgihandle;
        if ismatrix(saxs.image)
            img = saxs.image;
        else
            if isfield(saxs, 'frame')
                ind2dis = saxs.frame;
            else
                ind2dis = 1;
            end
            img = double(saxs.image(:,:,ind2dis));
        end

        if strcmp(action,'log')
            tmp = log10(abs(img+eps));
    %        ishandle(findobj(gcbf, 'tag', 'SAXSimageviewerImage'))
            set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'Cdata', tmp);
            if ~isempty(varargin{2})
                if strcmp(varargin{2}.EventName, 'On')
                    setColor([0, 5])
                    return
                end
            end
            setColor
        elseif strcmp(action, 'lin')
    %        ishandle(findobj(gcbf, 'tag', 'SAXSimageviewerImage'))
            set(findobj(gcbf, 'tag', 'SAXSimageviewerImage'), 'Cdata', img);
        end

    end

     function findcenterCallback(varargin)
         figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
         action = varargin{3};
         crtImageAxes = get(handles.ImageAxes, 'nextplot');
         switch lower(action)
             case 'on'
                % get current figure event functions
                if ~isfield(handles, 'selectedX')
                    disp('please selected points on AgBH, and then press this button to fit and display')
                    return
                end
                if numel(handles.selectedX) < 3
                    fprintf('Currently %d points are selected, but it should be at least 3\nIt has been reset, try again\n', numel(handles.selectedX));
%                    handles.selectedX = [];
%                    handles.selectedY = [];
%                    guidata(figH, handles);
                    return
                end
                 th = linspace(0,2*pi,360)';
%                 crtImageAxes = get(handles.ImageAxes, 'nextplot');
                 set(handles.ImageAxes, 'nextplot', 'add');
                 handles.tmpPlothandle = plot(handles.selectedX, handles.selectedY,'o', 'parent', handles.ImageAxes);

                % reconstruct circle from data
                [xc,yc,Re,~] = circfit(handles.selectedX, handles.selectedY);
                xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;

                tmph = plot([xe;xe(1)],[ye;ye(1)],'-', 'parent', handles.ImageAxes);
                handles.tmpPlothandle = [handles.tmpPlothandle, tmph];
    %             title(' measured fitted and true circles')
    %      legend('measured','fitted','true')
                tmph = text(handles.selectedX(1),handles.selectedY(1),sprintf('center (%g , %g );  R=%g',xc,yc,Re), 'parent', handles.ImageAxes);
                handles.tmpPlothandle = [handles.tmpPlothandle, tmph];
             case 'off'
                if ~isfield(handles, 'tmpPlothandle')
                    disp('Please selected points on AgBH, and then press this button to fit and display')
                    return
                end             
                delete(handles.tmpPlothandle);
                handles = rmfield(handles, 'tmpPlothandle');
                set(handles.ImageAxes, 'nextplot', crtImageAxes);
%                handles.selectedX = [];
%                handles.selectedY = [];

             otherwise

         end
         guidata(figH, handles);
     end
%% Azimuthal angle determination
    function azimangle_start(varargin)
        %src,evnt
        
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        handles.titleFmt = '%3.5f';
        % get current figure event functions
        currFcn = get(figH, 'windowbuttonmotionfcn');
        currFcn2 = get(figH, 'windowbuttondownfcn');

        switch get(varargin{1}, 'tag')
            case 'Toggleazimangle'
                if (isfield(handles,'ID') && handles.ID == 2)
                    disp('Azimangle is already active.');
                    return;
                else
                    handles.ID = 2;
                end
            case 'ToggleTiltangle'
                if (isfield(handles,'ID') && handles.ID == 3)
                    disp('Titleangle is already active.');
                    return;
                else
                    handles.ID = 3;
                end
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
        handles.selectedX = [];
        handles.selectedY = [];
        guidata(figH, handles);
        set(gcf,'Pointer','crosshair');
        set(gcf, 'windowbuttonmotionfcn', @azimangle_OnMouseMove);
        set(gcf, 'windowbuttondownfcn', @azimangle_OnMouseDown);     
    end

% terminate callback
    function azimangle_Off(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        handles.selectedX = [];
        handles.selectedY = [];

        % restore default figure properties
        set(figH, 'windowbuttonmotionfcn', handles.currFcn);
        set(figH, 'windowbuttondownfcn', handles.currFcn2);
        set(figH,'Pointer','arrow');
        %title(handles.currTitle);
        uirestore(handles.theState);
        switch handles.ID
            case 2
                set(handles.Toggleazimangle, 'state', 'off');
            case 3
                set(handles.ToggleTiltangle, 'state', 'off');
        end
        handles.ID=0;
        if isfield(handles, 'azimlinehandle')
            if numel(handles.azimlinehandle) > 0
                try
                    delete(handles.azimlinehandle);
                catch
                    handles.azimlinehandle = [];
                end
            end
        end
        guidata(figH, handles);
    end

    function azimangle_OnMouseMove(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);

    % get mouse position
        pt = get(handles.ImageAxes, 'CurrentPoint');
        %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
        saxs = get(figH, 'userdata');
        img = saxs.image;
        xInd = round(pt(1, 1));
        yInd = round(pt(1, 2));

    % check if its within axes limits
        xlimvalue = get(handles.ImageAxes, 'XLim');	
        ylimvalue = get(handles.ImageAxes, 'YLim');
        if xInd < xlimvalue(1) || xInd > xlimvalue(2)
            %pos_valuestr = ['Out of X limit'];	
            return;
        end
        if yInd < ylimvalue(1) || yInd > ylimvalue(2)
            %pos_valuestr = ['Out of Y limit'];
            return;
        end

    % read intensity value....
        try
            ImValue = img(yInd, xInd);
        catch
            ImValue = NaN;
        end

    % update figure title
        try
            pos_valuestr = ['X = ', num2str(xInd,handles.titleFmt),...
                ', Y = ', num2str(yInd,handles.titleFmt),...
                ', Z = ', num2str(ImValue,handles.titleFmt)];
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

        if isfield(handles, 'azimlinehandle')
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
        guidata(figH, handles);
    end

% mouse click callback
    function azimangle_OnMouseDown(~,~)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);

        switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'
                Xp = handles.selectedX;
                Yp = handles.selectedY;
                Xp = [Xp,handles.MousexInd];
                Yp = [Yp,handles.MouseyInd];
                handles.selectedX = Xp;
                handles.selectedY = Yp;
                
                switch handles.ID
                    case 2 % azimuthal angle
                        if (numel(Xp) <= 1)
                            if isfield(handles, 'azimlinehandle')
                                delete(handles.azimlinehandle);
                            end
                            handles.azimlinehandle = [];
                        end
                        if (numel(Xp) == 3)
                            p1 = [Xp(1)-Xp(2),Yp(1)-Yp(2), 0];
                            p2 = [Xp(3)-Xp(2),Yp(3)-Yp(2), 0];
                            ang = angle2vect2(p1, p2);
                            tmp = sprintf('Angle between line 12 to line 32 is %0.2f radian or %0.2f degree.\n', ang, ang*180/pi);
                            fprintf(tmp);
                            handles.selectedX = [];
                            handles.selectedY = [];
                        end
                    case 3 % tilt angle
                        if (numel(Xp) <= 1)
                            if isfield(handles, 'azimlinehandle')
                                delete(handles.azimlinehandle);
                            end
                            handles.azimlinehandle = [];
                        end
                        if (numel(Xp) == 2)
                            p1 = [Xp(1)-Xp(2),Yp(1)-Yp(2)];
                            %ang = -atan(p1(2)/p1(1));
                            ang = atan2(-p1(2), -p1(1));
                            tmp = sprintf('Azimuthal angle is %0.2f radian or %0.2f degree.\n', ang, ang*180/pi);
                            fprintf(tmp);
                            handles.selectedX = [];
                            handles.selectedY = [];
                        end
                end
                guidata(figH, handles);
            case 'extend'
                azimangle_Off
            case 'alt'
                azimangle_Off
    %            winBtnDownFcn(handles.ImageAxes);
            otherwise
        end
    end

    function playimages(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        str = get(handles.FileListBox, 'string');
        for i=numel(str):-1:1
            loadImage(fullfile(get(handles.CurrentDirectoryEdit, ...
                'tooltipstring'), str{i}));
            pause(0.2)
        end
    
    end

    function agbhSAXScalibrate(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        saxs = getgihandle;
        saxs.image(saxs.image>1.00E9) = -1;
        [center, SDDpeak] = agbhSAXS(saxs.image);
        % draw a circle...
        %[xc,yc,Re,a] = circfit(handles.selectedX, handles.selectedY);
        th = linspace(0, 2*pi, 100);
        xc = center(1); yc = center(2);
        Re = SDDpeak;
        xe = Re*cos(th)+yc; ye = Re*sin(th)+xc;
        tmph = line(xe,ye, 'parent', handles.ImageAxes, 'color', 'g');
        %tmph = line([xe;xe(1)],[ye;ye(1)],'-', 'parent', handles.ImageAxes);
        try
            handles.tmpPlothandle = [handles.tmpPlothandle, tmph];
        catch
            handles.tmpPlothandle = tmph;
        end
        guidata(figH, handles);
        try
            sampleinfo = evalin('base', 'sampleinfo');
            saxs.ai = sampleinfo.th;
            saxs.xeng = sampleinfo.Energy;
            saxs.waveln = eng2wl(saxs.xeng);
        catch
            fprintf('sampleinfo not available\n');
        end    
        try
            saxs.center = [yc, xc];
            saxs.px = Re;
            setgihandle(saxs);
            gisaxsleenew('SetSAXSValues')
            gisaxsleenew('ReadandSetValues')
        catch
            error('Error in putting the setup info to gisaxsleenew');
        end
    end

    function autoupdateOn(varargin)
        f = findobj('tag', 'AvgDataPlot');
        if isempty(f)
            f = figure;
            set(f, 'tag', 'AvgDataPlot');
        end
    end
    function makemask(varargin)
        maskmaker
    end

    function datakeepertoggleup(varargin)
        try
            pickpeaksdone
%            evalin('caller',['clear ','mousepnt']) 
        catch
%            disp('variable mpoint does not exist.')
        end
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
%         try
%             mousepnt = evalin('base', 'mousepnt');
%         catch
%             mousepnt = [];
%         end
%         try
%             mousepnt_handle = evalin('base', 'mousepnt_handle');
%         catch
%             mousepnt_handle = [];
%         end
%         mousepnt = [mousepnt;handles.selectedX(:), handles.selectedY(:)];
%         mousepnt_handle = [mousepnt_handle, handles.pg];
        if ~isfield(handles, 'selectedX')
            handles.selectedX = [];
            handles.selectedY = [];
        end
        mousepnt = [handles.selectedX(:), handles.selectedY(:)];
        if ~isfield(handles, 'pg')
            handles.pg = [];
        end
        mousepnt_handle = handles.pg;
        assignin('base', 'mousepnt', mousepnt);
        assignin('base', 'mousepnt_handle', mousepnt_handle);
        clearSelPeaks
    end
    function showSelPeaks(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        X = handles.selectedX;
        Y = handles.selectedY;

        for i=1:length(X)
            xInd = X(i);
            yInd = Y(i);


            h = putcross(xInd, yInd);
            set(h, 'tag', 'mousepnt2read');
            set(h(1), 'userdata', xInd);
            set(h(2), 'userdata', yInd);
        end
    end
    function clearSelPeaks(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        obj = findobj(figH, 'tag', 'mousepnt2read');
        delete(obj)
    end

    function peakshowtoggledown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        try
            mpoint = evalin('base', 'mousepnt');
            tmph = putcross(mpoint.x,mpoint.y);
            handles.tmpPlothandle = tmph;
            guidata(figH, handles);
        catch
        end
        
    end
    function peakshowtoggleup(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        if isfield(handles, 'tmpPlothandle')
            delete(handles.tmpPlothandle);
        end
        handles.tmpPlothandle = [];
        guidata(figH, handles);
        set(gcf,'Pointer','arrow');
        set(gcf, 'windowbuttondownfcn', handles.currFcn2);      

    end

    function drawROIandfit_toggledown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        currFcn = get(figH, 'windowbuttonmotionfcn');
        currFcn2 = get(figH, 'windowbuttondownfcn');
        try
            delete(handles.rechandles);
        catch
        end
        handles.currFcn = currFcn;
        handles.currFcn2 = currFcn2;
    %    handles.currTitle = currTitle;
        handles.theState = uisuspend(figH);
        if isfield(handles, 'selectedX')
            handles.selectedX = [];
            handles.selectedY = [];
        end

        % set event functions 
        set(gcf,'Pointer','crosshair');
        %set(gcf, 'windowbuttonmotionfcn', @gtrack_OnMouseMove);        
        set(gcf, 'windowbuttondownfcn', @drawback2pickpeaks); 
        fprintf('Left click to start to draw a box and right click to finish the box.\n');
        guidata(figH, handles);
    end

    function drawROIandfit_toggleup(varargin)
        pickpeaksdone
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        % get the dimension of images...
        img0 = get(findobj(handles.ImageAxes, 'type', 'image'), 'CData');
        if ~isfield(handles, 'selectedX')
            fprintf('There is no selectedX field in GUI handles.\n');
            return
        end
        fit2dpeak = Gaussian2dfit(handles.selectedX, handles.selectedY, img0);
        saxs = getgihandle;
        qpos = calcangle2q(fit2dpeak.X(:), fit2dpeak.Y(:), saxs);
        fit2dpeak.q = qpos;
        assignin('base', 'fit2dpeak', fit2dpeak);
        disp('Data fitting done')
        disp('You can see fitted 2D as follow:')
        disp('[e,imgc]=fitwith2dgaussian(fit2dpeak.param, fit2dpeak.xarr,{fit2dpeak.xarr, fit2dpeak.yarr});')
        disp('imagesc(imgc)')

        guidata(figH, handles);
    end

    function drawROIandfit_numpnts(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        % get the dimension of images...
        %img0 = get(findobj(handles.ImageAxes, 'type', 'image'), 'CData');
        saxs = getgihandle;
        if ndims(saxs.image)==3
            img0 = saxs.image(:,:,saxs.frame);
        else
            img0 = saxs.image;
        end
        fprintf('\n')
        fprintf('Variable "numpnts" will be loaded from the workspace.\n')
        numpnts = evalin('base', 'numpnts');
        try
            Option2Dfit = evalin('base', 'Option2Dfit');
        catch
            Option2Dfit.peak_xwidth = 1;
            Option2Dfit.peak_ywidth = 2;
            Option2Dfit.ROI = 5;
            assignin('base', 'Option2Dfit', Option2Dfit)
            fprintf('\n')
            fprintf('Edit the variable, Option2Dfit, with fields peak_xwidth, peak_ywidth, ROI');
            fprintf('For now, the default is used.');
            fprintf('\n')
        end
        xw = Option2Dfit.peak_xwidth;
        yw = Option2Dfit.peak_ywidth;
        ROI = Option2Dfit.ROI;rx = ROI;ry=ROI;
        % rx and ry are the half width of the image section containing the
        % peak to fit.
        % xw and yw are the initial values for the peak widths to fit.
        fprintf('\n')
        fprintf('2D Gaussian peak fit starts with ROI of %i and an initial peakwidth %0.1f.\n', ROI, xw)
        fprintf('\n')
        fit2dpeak = Gaussian2dfit(numpnts(:,1), numpnts(:,2), img0, ...
            'xwidth', xw, 'ywidth', yw, 'ROIx', rx, 'ROIy', ry);
        qpos = calcangle2q(fit2dpeak.X(:), fit2dpeak.Y(:), saxs);
        fit2dpeak.q = qpos;
        fit2dpeak.q_sig = fit2dpeak.param(:,4:5)*saxs.pxQ;
        assignin('base', 'fit2dpeak', fit2dpeak);
        fprintf('\n')
        disp('Data fitting done')
        fprintf('\n')
%        disp('You can see fitted 2D as follow:')
%        disp('[e,imgc]=fitwith2dgaussian(fit2dpeak.param, fit2dpeak.xarr,{fit2dpeak.xarr, fit2dpeak.yarr});')
%        disp('imagesc(imgc)')

        guidata(figH, handles);
    end

    function plot_numpnts(varargin)
        if numel(varargin)==1
            numpnts = varargin{1};
        else
            numpnts = evalin('base', 'numpnts');
        end
        delete(findobj(gcbf, 'tag', 'numpnts'))
        k = line(numpnts(:,1), numpnts(:,2));
        set(k, 'linestyle', 'none', 'Marker','o','MarkerEdgeColor','r', 'tag', 'numpnts')
    end
    function edit_numpnts_toggledown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        % get current figure event functions
        currFcn2 = get(figH, 'windowbuttondownfcn');
    %    currTitle = get(get(gca, 'Title'), 'String');
    % add data to figure handles
        plot_numpnts

        if (isfield(handles,'ID') && handles.ID==1)
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
        handles.currFcn2 = currFcn2;
        handles.theState = uisuspend(figH);
        guidata(figH, handles);

        set(gcf,'Pointer','crosshair');
        set(gcf, 'windowbuttondownfcn', @edit_numpnts_OnMouseDown);         
    end
    function edit_numpnts_toggleup(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);

        % restore default figure properties
        set(figH, 'windowbuttondownfcn', handles.currFcn2);
        set(figH,'Pointer','arrow');
        %title(handles.currTitle);
        uirestore(handles.theState);
        handles.ID=0;
        %    rest = 1;
        guidata(figH, handles);        
    end
    function edit_numpnts_OnMouseDown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        numpnts = evalin('base', 'numpnts');
        pt = get(handles.ImageAxes, 'CurrentPoint');
        xInd = round(pt(1, 1));
        yInd = round(pt(1, 2));
        switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'
                numpnts = [numpnts;[xInd, yInd]];
                plot_numpnts(numpnts)
            case {'extend', 'alt'}
                [~, ind] = min(sqrt(sum((numpnts-[xInd, yInd]).^2, 2)));
                numpnts(ind, :) = [];
                plot_numpnts(numpnts)
            otherwise
        end        
        assignin('base', 'numpnts', numpnts);
    end

    function fit2dpeak_saveforDICVOL(varargin)
        [filename, pathname] = uiputfile('*.txt', 'Save PEAKS for DICVOL as');
        fn = fullfile(pathname, filename);
        saveforDICVOL(fn)
    end
    function saveforDICVOL(filename)
        fit2dpeak = evalin('base', 'fit2dpeak');
        saxs = getgihandle;
        pixpos = [fit2dpeak.X(:), fit2dpeak.Y(:)];
        pixpos = pixpos - saxs.center;
        [th, r] = cart2pol(pixpos(:,1), pixpos(:,2));
        [x, y] = pol2cart(th+pi, r);
        
        % pixel tolerance
        tol = 2; % tolerance is 2 pixel;
        N_input_peaks = numel(x);
        % apply inversion symmetry
        fprintf('\n')
        fprintf('\n')
        fprintf('Inversion symmetric position checking with tolerane %0.1f pixels.\n', tol)
        pair = zeros(size(x));
        for i=1:N_input_peaks
            pos = pixpos(i, :);
            posn = [x, y] - pos;
            d = sqrt(sum(posn.^2, 2));
            if any(d<tol)
                indx = find(d<tol);
                while numel(indx)>1
                    tol = tol-0.2;
                    fprintf('Tolerane is reduced to %f pixels.\n', tol)
                    indx = find(d<tol);
                end
                pair(i) = indx;
            end
        end
        cen_shift = zeros(sum(pair>0), 2);
        N_pairs = size(cen_shift, 1)/2;
        fprintf('\n')
        fprintf('Total %i pairs are found.\n', N_pairs)
        k = 1;
        for i=1:N_input_peaks
            if pair(i)>0
                pos = pixpos(i, :);
                posn = pixpos(pair(i), :);
                cen_shift(k,:) = (pos+posn)/2;
                k = k+1;
            end
        end
        fprintf('\n')
        fprintf('From the pairs, the beam center devication is estimated as: \n')
        fprintf('   Beamcenter shifted by X_c = %0.5f and Y_c = %0.5f\n', mean(cen_shift, 1))
        fprintf('   Standard deviation: [X_c]s = %0.5f, [Y_c]s = %0.5f\n', std(cen_shift, 1))
        % modifying beamcenter ==============================
        pixpos = pixpos - mean(cen_shift, 1);
        saxs.center = [0, 0];
        qpos = calcangle2q(pixpos(:,1), pixpos(:,2), saxs);
        fit2dpeak.q = qpos;
        % ===================================================

        fit2dpeak.pix = sqrt(pixpos(:,1).^2+pixpos(:,2).^2);
        fit2dpeak.pix = fit2dpeak.pix(:);

        % Merge all peaks that have pixel distance within the tolerance

        pix = fit2dpeak.pix;
        q = fit2dpeak.q;
        q_sig = fit2dpeak.q_sig;

        q = sqrt(sum(q.^2,2));
        q_sig = sqrt(sum(q_sig.^2,2));
        % sorting....
        [pd, ic] = sort(pix);
        k = 1;
        peakindex = {};
        ind = ic(1);

        for i=2:numel(pd)
            if pd(i)-pd(i-1)>tol
%                p0 = pd(i);
                peakindex{k} = ind;
                k = k+1;
                ind = ic(i);
            else
                ind = [ind, ic(i)];
            end
        end
        qv = zeros(numel(peakindex), 1);
        qv_sig = qv;
        for i=1:numel(peakindex)
            qv(i) = mean(q(peakindex{i}));
            qv_sig(i) = mean(q_sig(peakindex{i}));
        end
        N_peaks = numel(qv);
        fprintf('\n')
        fprintf('Total %i inputs are reduced to %i.\n', N_input_peaks, N_peaks)
        fprintf('\n')
        fprintf('\n')
        % convert to d-spacing and save for DICVOL.
        m = [2*pi./qv, qv_sig./qv];
        m = sort(m, 1, 'descend');
        maxd = m(1, 1);
        f = 1/maxd*5;
        maxd = maxd*f;
        m(:,1) = m(:,1)*f;
        sig = m(:,2);
        Npeak = length(m(:,1));
        %[~, b,ext] = fileparts(filename);
        %fn = [b, ext];
        fid = fopen(filename, 'w');
        fprintf(fid, '**** Scale factor %0.5e ****\n', f);
        fprintf(fid, '%i  %s\n', Npeak, '3 1 1 1 1 0 0');
        fprintf(fid, '%0.3f %0.3f %0.3f 0.0 %0.3f 0 0\n', maxd*3, maxd*3, maxd*3, 5*maxd^3);
        fprintf(fid, '%s\n', '0 0 0 0');
        fprintf(fid, '%s\n', '1.0 0 0 0 0');
        for i=1:Npeak
            fprintf(fid, '%0.3f %0.3f\n', m(i, 1), sig(i)*m(i, 1));
        end
        fclose(fid);

    end
    function ppos = find2dpeaks(varargin)
        saxs = getgihandle;
%         % method 1: peak2dfind
%         % Disect center-blocked image matrix into smaller pieces
%         runit = 10;
%         cunit = 10;
%         ntop = 100; % maximum number of peaks to find.
%         dist = sqrt(2)*5;
% 
%         blkmat = matsect(saxs.image, runit, cunit);
%         
%         % Find the brightest pixels in the top n (ntop) image blocks sorted by collective intensity
%         maxmat = findPeakCandidates(blkmat, ntop);
%         
%         % Sieving by distance
%         ppos = distanceFilter(saxs.image, maxmat, dist);

        % method 2: FastPeakfind
        img = saxs.image;
        if ndims(img)==3
            img = img(:, :, saxs.frame);
        end
        if isfield(saxs, 'mask')
            img = img.*saxs.mask;
        end
        filt = (fspecial('gaussian', 21,3));
        cent = FastPeakFind(img, 2, filt, 2, 1);
        ppos = reshape(cent, 2, numel(cent)/2)';
        %k = line(ppos(:,1), ppos(:,2)); 
        %set(k, 'linestyle', 'none', 'Marker','s','MarkerEdgeColor','r')

        %% will need to remove peaks that are not relevant....
        ROI = 5;
        ind2go = [];
        for i=1:size(ppos, 1)
            p = ppos(i, :);
            x = fix(p(1))-ROI:fix(p(1))+ROI;
            y = fix(p(2))-ROI:fix(p(2))+ROI;
            y(y>size(img, 2) | y<1) = [];
            x(x>size(img, 2) | x<1) = [];
            [~, xi] = min(abs(x-p(1)));
            [~, yi] = min(abs(y-p(2)));
            dt = img(y, x);dt(yi-1:yi+1, xi-1:xi+1) = NaN;
            dt = dt(:); dt(isnan(dt)) = [];
            mv = mean(dt(:));
            if img(p(2), p(1))<mv*3
                ind2go = [ind2go, i];
            end
        end
        ppos(ind2go, :) = [];
        k2 = line(ppos(:,1), ppos(:,2)); 
        assignin('base', 'numpnts', ppos)
        set(k2, 'linestyle', 'none', 'Marker','o','MarkerEdgeColor','r')
    end

    function qpos = calcangle2q(varargin)
        xInd = varargin{1};
        yInd = varargin{2};
        saxs = varargin{3};
        if isfield(saxs, 'ai')
            ai = saxs.ai;
        else
            ai = 0;
        end
        if ~isfield(saxs, 'SDD')
            error('The setup file may not be loaded yet.')
        end
        try
            %ang = pixel2angle2([xInd, yInd], saxs.center, saxs.SDD, psize, ta);
            Pixel = bsxfun(@minus, [xInd, yInd], saxs.center);
            [tthf, af] = pixel2angles(Pixel, saxs.SDD, saxs.psize, saxs.tiltangle);
            af = af - ai;
            
            %tthf = ang(:,1); af = ang(:,2)-ai;
        catch
            tthf = [];
%            ang = [];
        end
        if isempty(tthf)
            isgisaxs = -1;
        else
            if (saxs.ai ~= 0)
                isgisaxs = 1;
            else
                isgisaxs = 0;
            end
        end

        switch isgisaxs
            case 1
                if isfield(saxs, 'tthi')
                    tthi = saxs.tthi;
                else
                    tthi = 0 ;
                end
                [qx, qy, qxy, q1z, ~, q3z, ~, q1, ~, q3, ~] = ...
                    giangle2q(tthf, af, tthi, ai, saxs);
                q1z = real(q1z); %q2z = real(q2z); 
                q3z = real(q3z); %q4z = real(q4z);
                qpos = [qxy, q3z];
            case 0
                [q, th] = pixel2q([xInd, yInd], saxs);
                [qx, qy, qz] = angle2vq2(0, af, 0, tthf, saxs.waveln);%since ai=0
                %qxy = angle2q(tthf, saxs.waveln);
                %qz = angle2q(af, saxs.waveln);%since ai = 0
                %q = sqrt(qxy.^2 + qz.^2);
                qxy = sqrt(qx.^2+qy.^2);
                qpos = [qxy, qz];
            otherwise
        end
    end

    function fitpeaktoggledown(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        currFcn = get(figH, 'windowbuttonmotionfcn');
        currFcn2 = get(figH, 'windowbuttondownfcn');
    %    currTitle = get(get(gca, 'Title'), 'String');
    % add data to figure handles
        if ~isfield(handles, 'selectedX')
            handles.selectedX = [];
            handles.selectedY = [];
        end
        %
        handles.pg = [];
        handles.selectedX = [];
        handles.selectedY = [];
        handles.currFcn = currFcn;
        handles.currFcn2 = currFcn2;
    %    handles.currTitle = currTitle;
        handles.theState = uisuspend(figH);

        % set event functions 
        set(gcf,'Pointer','crosshair');
        %set(gcf, 'windowbuttonmotionfcn', @gtrack_OnMouseMove);        
        set(gcf, 'windowbuttondownfcn', @pickpeaks);      
        guidata(figH, handles);
    end

    function fitpeaktoggleup(varargin)
        pickpeaksdone
        figH = evalin('base', 'SAXSimageviewerhandle');
        handles = guidata(figH);
        if isfield(handles, 'selectedX')
            X = handles.selectedX;
            Y = handles.selectedY;
        else
            X = [];
            Y = [];
        end
        numpnts = [X(:), Y(:)];
        assignin('base', 'numpnts', numpnts);

        try
            delete(handles.pg)
            handles.pg = [];
        catch
            
        end
        
        guidata(figH, handles);

    end


    function drawback2pickpeaks(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        %set(figH, 'WindowButtonMotionFcn', @mg_BPP_mouseMove);
        %set(figH, 'WindowButtonupfcn', @mg_BPP_mouseup);

        pt = get(handles.ImageAxes, 'CurrentPoint');
        xInd = round(pt(1, 1));
        yInd = round(pt(1, 2));
        switch get(handles.SAXSImageViewer, 'selectiontype')
            case 'normal'
                handles.x0s = xInd;
                handles.y0s = yInd;
                guidata(figH, handles);

            case 'alt'   
                if isfield(handles, 'x0s')
                    x0 = handles.x0s;
                    y0 = handles.y0s;
                    h = drawrect(x0, xInd, y0, yInd);
                    handles.rechandles = h;
                    if isfield(handles, 'selectedX')
                        dX = handles.selectedX;
                        dY = handles.selectedY;
                    else
                        dX = [];
                        dY = [];
                    end
                    handles.selectedX = [...
                        dX; x0, xInd];
                    handles.selectedY = [...
                        dY; y0, yInd];
                    guidata(figH, handles);
                end
        end
    end
% 
%     function mg_BPP_mouseMove(varargin)
%         figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
%         C = get(handles.ImageAxes, 'CurrentPoint');
% %        fprintf('%0.3f, %0.3f\n', C(1), C(2));
%         delete(handles.rechandles);
%         handles.x1s = C(1);
%         handles.y1s = C(2);
%         h = drawrect(handles.x0s, C(1), handles.y0s, C(2));
%         handles.rechandles = h;
%         guidata(figH, handles);
%     end
%     function mg_BPP_mouseup(varargin)
%         mg_BPP_mouseMove
%         figH = evalin('base', 'SAXSimageviewerhandle');
%         %handles = guidata(figH);
%         set(figH, 'WindowButtonMotionFcn', '');
%     end
    function h = drawrect(x0, x1, y0, y1)
        %offset = abs([x0, x1]-[x1, y1]);
        %xCoords = [x0 x0+offset(1) x0+offset(1) x0 x0];
        %yCoords = [y0 y0 y0+offset(2) y0+offset(2) y0];
        %h = plot(xCoords, yCoords);
        h(1) = line([x0, x1], [y0, y0]);
        h(2) = line([x0, x0], [y0, y1]);
        h(3) = line([x1, x1], [y0, y1]);
        h(4) = line([x0, x1], [y1, y1]);
        set(h, 'color', 'k')
%        fprintf('%0.3f, %0.3f\n', x1, y1);
    end
    function pickpeaks(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        pt = get(handles.ImageAxes, 'CurrentPoint');
        xInd = round(pt(1, 1));
        yInd = round(pt(1, 2));

        switch get(handles.SAXSImageViewer, 'selectiontype')
        case 'normal'
            Xp = handles.selectedX;
            Yp = handles.selectedY;
            Xp = [Xp,xInd];
            Yp = [Yp,yInd];
            handles.selectedX = Xp;
            handles.selectedY = Yp;
            h = putcross(xInd, yInd);
            set(h, 'tag', 'mousepnt2read');
            set(h(1), 'userdata', xInd);
            set(h(2), 'userdata', yInd);
            handles.pg = [handles.pg, h];
        case 'extend'
%            n=n+1;
            pickpeaksdone
        case 'alt'
            %pickpeaksdone
            Xp = handles.selectedX;
            Yp = handles.selectedY;
            d = (Xp - xInd).^2+(Yp - yInd).^2;
            [~, mindx] = min(d);
            handles.selectedX(mindx) = [];
            handles.selectedY(mindx) = [];
            ind2go = [(mindx-1)*2+1, (mindx-1)*2+2];
            delete(handles.pg(ind2go));
            handles.pg(ind2go) = [];
            

%            winBtnDownFcn(handles.ImageAxes);
        otherwise
        end        
        guidata(figH, handles);
    end
    function pickpeaksdone(varargin)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        set(figH, 'windowbuttonmotionfcn', handles.currFcn);
        set(figH, 'windowbuttondownfcn', handles.currFcn2);
        set(handles.ImageAxes, 'buttondownfcn', @winBtnDownFcn);
        set(gcf, 'Pointer', 'arrow');
    end
    function h = putcross(X, Y)
        figH = evalin('base', 'SAXSimageviewerhandle');handles = guidata(figH);
        h = zeros(1, numel(X)*2);
        for i=1:numel(X)
            xv = X(i);yv = Y(i);
            h((i-1)*2+1) = line([xv-5, xv+5], yv*ones(1,2), 'color','r', 'linewidth', 2, 'parent', handles.ImageAxes);
            h((i-1)*2+2) = line(xv*ones(1,2), [yv-5, yv+5], 'color','r', 'linewidth', 2, 'parent', handles.ImageAxes);
        end
    end

    function gcfit(varargin)
        % gc L17 samples
        gc = [0.0063   41.2739
    0.0072   39.4490
    0.0081   38.6674
    0.0090   38.2356
    0.0099   37.9955
    0.0108   37.6382
    0.0117   36.9394
    0.0126   36.5603
    0.0135   36.6277
    0.0144   36.5361
    0.0153   35.7443
    0.0162   35.8664
    0.0171   35.0903
    0.0180   35.0126
    0.0189   35.1064
    0.0198   34.5533
    0.0207   34.4455
    0.0216   34.3759
    0.0225   34.0067
    0.0234   33.6900
    0.0243   33.7166
    0.0252   33.4428
    0.0261   33.1734
    0.0270   33.1718
    0.0279   32.9530
    0.0288   32.7905
    0.0297   32.5111
    0.0306   32.4417
    0.0315   32.5191
    0.0324   32.2882
    0.0333   32.1144
    0.0342   32.0581
    0.0351   32.0247
    0.0360   31.7302
    0.0369   31.6690
    0.0378   31.5375
    0.0387   31.3582
    0.0396   31.1881
    0.0406   31.4062
    0.0415   31.2941
    0.0424   31.1123
    0.0433   31.0548
    0.0442   30.8880
    0.0451   30.9037
    0.0460   30.7206
    0.0469   30.6986
    0.0478   30.6643
    0.0487   30.7806
    0.0496   30.5652
    0.0505   30.3721
    0.0514   30.5102
    0.0523   30.7354
    0.0532   30.5131
    0.0541   30.5610
    0.0550   30.5022
    0.0559   30.2876
    0.0568   30.3371
    0.0577   30.2450
    0.0586   30.4042
    0.0595   30.2769
    0.0604   30.1234
    0.0613   30.3692
    0.0622   30.2567
    0.0631   30.3946
    0.0640   30.3688
    0.0649   30.3031
    0.0658   30.1799
    0.0667   30.3079
    0.0676   30.2667
    0.0685   30.1389
    0.0694   30.2408
    0.0703   30.1356
    0.0712   30.0722
    0.0721   29.9960
    0.0730   30.0016
    0.0739   29.9239
    0.0748   30.1480
    0.0757   29.9021
    0.0766   29.8931
    0.0775   29.8983
    0.0784   29.9258
    0.0793   29.8156
    0.0802   29.8080
    0.0811   29.6573
    0.0820   29.7428
    0.0829   29.5192
    0.0838   29.5156
    0.0847   29.4622
    0.0856   29.3378
    0.0865   29.2300
    0.0874   29.2736
    0.0883   29.2317
    0.0892   29.0075
    0.0901   28.9989
    0.0910   28.8525
    0.0919   28.8295
    0.0928   28.6803
    0.0937   28.7166
    0.0946   28.5722
    0.0955   28.2118
    0.0964   28.1147
    0.0973   28.1376
    0.0982   28.0553
    0.0991   27.8474
    0.1000   27.7929
    0.1009   27.6579
    0.1018   27.5261
    0.1027   27.3295
    0.1036   27.2629
    0.1045   27.0936
    0.1054   26.9688
    0.1063   26.8030
    0.1072   26.6893
    0.1081   26.4965
    0.1090   26.2968
    0.1099   26.1365
    0.1108   25.9110
    0.1117   25.7964
    0.1126   25.6848
    0.1135   25.4902
    0.1144   25.3623
    0.1153   25.1310
    0.1162   24.8886
    0.1171   24.8140
    0.1180   24.4854
    0.1189   24.3451
    0.1198   24.1938
    0.1208   23.9728
    0.1217   23.8274
    0.1226   23.5537
    0.1235   23.4519
    0.1244   23.3160
    0.1253   23.0816
    0.1262   23.0165
    0.1271   22.6742
    0.1280   22.6221
    0.1289   22.3020
    0.1298   22.1916
    0.1307   21.8945
    0.1316   21.7871
    0.1325   21.5110
    0.1334   21.3129
    0.1343   21.1013
    0.1352   20.8992
    0.1361   20.7603
    0.1370   20.4468
    0.1379   20.3584
    0.1388   20.1140
    0.1397   19.8982
    0.1406   19.7324
    0.1415   19.5570
    0.1424   19.3080
    0.1433   19.1626
    0.1442   18.9771
    0.1451   18.7968
    0.1460   18.6097
    0.1469   18.4120
    0.1478   18.2410
    0.1487   17.9903
    0.1496   17.8042
    0.1505   17.5352
    0.1514   17.3845
    0.1523   17.1631
    0.1532   16.9755
    0.1541   16.7650
    0.1550   16.6417
    0.1559   16.3919
    0.1568   16.2886
    0.1577   16.1086
    0.1586   15.8877
    0.1595   15.7268
    0.1604   15.5187
    0.1613   15.3451
    0.1622   15.2337
    0.1631   15.0449
    0.1640   14.8966
    0.1649   14.6407
    0.1658   14.4795
    0.1667   14.2666
    0.1676   14.1955
    0.1685   14.0438
    0.1694   13.7867
    0.1703   13.6484
    0.1712   13.5028
    0.1721   13.4108
    0.1730   13.2159
    0.1739   12.9921
    0.1748   12.8493
    0.1757   12.7054
    0.1766   12.5414
    0.1775   12.3886
    0.1784   12.2062
    0.1793   12.1547
    0.1802   11.9201
    0.1811   11.7766
    0.1820   11.6400
    0.1829   11.5113
    0.1838   11.3574
    0.1847   11.2848
    0.1856   11.1059
    0.1865   10.9616
    0.1874   10.8294
    0.1883   10.6301
    0.1892   10.5226
    0.1901   10.4190
    0.1910   10.2665
    0.1919   10.0951
    0.1928    9.9948
    0.1937    9.9479
    0.1946    9.8172
    0.1955    9.5638
    0.1964    9.4923
    0.1973    9.4249
    0.1982    9.2537
    0.1991    9.1267
    0.2001    9.0536
    0.2010    8.9060
    0.2019    8.8463
    0.2028    8.7422
    0.2037    8.5505
    0.2046    8.4751
    0.2055    8.3637
    0.2064    8.2401
    0.2073    8.1432
    0.2082    8.0287
    0.2091    7.9340
    0.2100    7.8333
    0.2109    7.7384
    0.2118    7.6506
    0.2127    7.5530
    0.2136    7.4034
    0.2145    7.3778
    0.2154    7.2525
    0.2163    7.1598
    0.2172    7.0717
    0.2181    6.9957
    0.2190    6.8898
    0.2199    6.7976
    0.2208    6.7287
    0.2217    6.6526
    0.2226    6.5855
    0.2235    6.4749
    0.2244    6.3761
    0.2253    6.2949
    0.2262    6.2308
    0.2271    6.1614
    0.2280    6.0973
    0.2289    5.9733
    0.2298    5.9151
    0.2307    5.8693
    0.2316    5.7730
    0.2325    5.6984
    0.2334    5.6388
    0.2343    5.5517
    0.2352    5.4652
    0.2361    5.4246
    0.2370    5.3571
    0.2379    5.2870
    0.2388    5.2248
    0.2397    5.1674
    0.2406    5.0884
    0.2415    5.0360
    0.2424    4.9708
    0.2433    4.9462
    0.2442    4.8633
    0.2451    4.7809
    0.2460    4.7317
    0.2469    4.6676
    0.2478    4.6477
    0.2487    4.5429
    0.2496    4.5023
    0.2505    4.4521
    0.2514    4.3796
    0.2523    4.3290
    0.2532    4.2938
    0.2541    4.2271
    0.2550    4.2077
    0.2559    4.1467
    0.2568    4.1205
    0.2577    4.0466
    0.2586    4.0129
    0.2595    3.9506
    0.2604    3.9048
    0.2613    3.8592
    0.2622    3.8146
    0.2631    3.7702
    0.2640    3.7430
    0.2649    3.6633
    0.2658    3.6302
    0.2667    3.6187
    0.2676    3.5372
    0.2685    3.5163
    0.2694    3.4780
    0.2703    3.4389
    0.2712    3.4176
    0.2721    3.3606
    0.2730    3.3329
    0.2739    3.2616
    0.2748    3.2281
    0.2757    3.1791
    0.2766    3.1823
    0.2775    3.1776
    0.2784    3.1099
    0.2793    3.0726
    0.2803    3.0378
    0.2812    3.0482
    0.2821    2.9736
    0.2830    2.9454
    0.2839    2.9317
    0.2848    2.8868
    0.2857    2.8535
    0.2866    2.8383
    0.2875    2.7897
    0.2884    2.7781
    0.2893    2.7349
    0.2902    2.7189
    0.2911    2.6779
    0.2920    2.6547
    0.2929    2.6372
    0.2938    2.6145
    0.2947    2.5695
    0.2956    2.5453
    0.2965    2.4988
    0.2974    2.4872
    0.2983    2.4700
    0.2992    2.4369
    0.3001    2.4169
    0.3010    2.4064
    0.3019    2.3795
    0.3028    2.3368
    0.3037    2.3028
    0.3046    2.3254
    0.3055    2.2766
    0.3064    2.2425
    0.3073    2.2033
    0.3082    2.2297
    0.3091    2.1913
    0.3100    2.1718
    0.3109    2.1548
    0.3118    2.1296
    0.3127    2.1103
    0.3136    2.0851
    0.3145    2.0552
    0.3154    2.0603
    0.3163    2.0402
    0.3172    2.0209
    0.3181    1.9918
    0.3190    1.9680
    0.3199    1.9605
    0.3208    1.9295
    0.3217    1.9101
    0.3226    1.8993
    0.3235    1.8957
    0.3244    1.8734
    0.3253    1.8520
    0.3262    1.8526
    0.3271    1.8150
    0.3280    1.7976
    0.3289    1.7899
    0.3298    1.7664
    0.3307    1.7330
    0.3316    1.7523
    0.3325    1.7081
    0.3334    1.7023
    0.3343    1.6848
    0.3352    1.6533
    0.3361    1.6654
    0.3370    1.6451
    0.3379    1.6339
    0.3388    1.6020
    0.3397    1.6076
    0.3406    1.5986
    0.3415    1.5846
    0.3424    1.5631
    0.3433    1.5511
    0.3442    1.5389
    0.3451    1.5146
    0.3460    1.5078
    0.3469    1.5030
    0.3478    1.4827
    0.3487    1.4653
    0.3496    1.4456
    0.3505    1.4466
    0.3514    1.4370
    0.3523    1.4195
    0.3532    1.4091
    0.3541    1.4138
    0.3550    1.3980
    0.3559    1.3511
    0.3568    1.3603
    0.3577    1.3725
    0.3586    1.3548
    0.3595    1.3216
    0.3605    1.3107
    0.3614    1.3170
    0.3623    1.2970
    0.3632    1.3040
    0.3641    1.2815
    0.3650    1.2693
    0.3659    1.2779
    0.3668    1.2618
    0.3677    1.2517
    0.3686    1.2169
    0.3695    1.2236
    0.3704    1.2003
    0.3713    1.2110
    0.3722    1.1978
    0.3731    1.1721
    0.3740    1.1858
    0.3749    1.1744
    0.3758    1.1485
    0.3767    1.1471
    0.3776    1.1400
    0.3785    1.1373
    0.3794    1.1299
    0.3803    1.1095
    0.3812    1.1020
    0.3821    1.0930
    0.3830    1.0903
    0.3839    1.0657
    0.3848    1.0783
    0.3857    1.0768
    0.3866    1.0580
    0.3875    1.0392
    0.3884    1.0321
    0.3893    1.0349
    0.3902    1.0454
    0.3911    1.0334
    0.3920    1.0147
    0.3929    1.0066
    0.3938    1.0003
    0.3947    0.9907
    0.3956    0.9822
    0.3965    0.9885
    0.3974    0.9665
    0.3983    0.9585
    0.3992    0.9568
    0.4001    0.9590
    0.4010    0.9356
    0.4019    0.9354
    0.4028    0.9257
    0.4037    0.9179
    0.4046    0.9189
    0.4055    0.9057
    0.4064    0.9032
    0.4073    0.8970
    0.4082    0.9040
    0.4091    0.8883
    0.4100    0.8740
    0.4109    0.8787
    0.4118    0.8650
    0.4127    0.8570
    0.4136    0.8597
    0.4145    0.8439
    0.4154    0.8423
    0.4163    0.8332
    0.4172    0.8290
    0.4181    0.8302
    0.4190    0.8289
    0.4199    0.8078
    0.4208    0.8089
    0.4217    0.8127
    0.4226    0.8017
    0.4235    0.7862
    0.4244    0.7739
    0.4253    0.7856
    0.4262    0.7893
    0.4271    0.7776
    0.4280    0.7610
    0.4289    0.7542
    0.4298    0.7595
    0.4307    0.7477
    0.4316    0.7488
    0.4325    0.7427
    0.4334    0.7406
    0.4343    0.7365
    0.4352    0.7304
    0.4361    0.7229
    0.4370    0.7186
    0.4379    0.7152
    0.4388    0.7089
    0.4397    0.7108
    0.4407    0.7112
    0.4416    0.6916
    0.4425    0.6891
    0.4434    0.6902
    0.4443    0.6748
    0.4452    0.6882
    0.4461    0.6770
    0.4470    0.6781
    0.4479    0.6636];
    %% 
        % Check if normalization option is applied to the GC data.
    saxs = getgihandle;

    qNorm = check_normalizationoptions(saxs);
    if qNorm
        s = sprintf(['Reload GC data without normalization options other than the exposure time,\n',...
        'do not select any normalization options before loading the image.\n',...
        'Otherwise, the background will be normalized twice']);
        fprintf(s)
    end
    
    gc(:,2) = gc(:,2)*0.1; %thickness of glassy carbon L17 is 1mm.
    isReadySF = 1;
    try
        si = evalin('base', 'sampleinfo');
    catch
        isReadySF = 0;
    end
    if ~isfield(saxs, 'emptyairimage')
        isReadySF = 0;
    end
    
    if ~isReadySF
        error('Select specfile, check Auto Update box, and Define an empty air data before proceeding.\n')
    end

    BS = si.BS/si.Exposuretime;
    IC = si.IC/si.Exposuretime;
        
    defaultT = -999;
    Transmittance = defaultT;
    if isfield(saxs, 'empty_BS') && ~isempty(si)
        Transmittance = BS/saxs.empty_BS/IC*saxs.empty_I0;
        fprintf('Transmittance of the sample may be %0.4f\n', Transmittance);
    end
    
    Tgc = 0.8857;  % Transmittance of glassy carbon L17 at 14keV.
    %T = input(sprintf('What is the transmittance of the standard? [%0.4f]:', Tgc));
    fprintf('Transmittance of L17 at 14 keV is known to be %0.4f.\n', Tgc);
    fprintf('Transmittance of your GC is calculated as %0.4f.\n', Transmittance);
%     if isempty(T)
%         T = Tgc;
%     end
    gc(:,2) = gc(:,2) * Transmittance; % Transmittance is multiplied to dOmega/dSigma.
    
    % Background subtraction and Data normalization.
    img = saxs.image/si.Exposuretime - Transmittance*saxs.emptyairimage/saxs.empty_exptime;
    fprintf('Air background is subtracted from your GC data followed by normalizing exposure time.\n');
    
    [~, ~, ~, cut] = linecut(img, saxs.center, 0, 'h', saxs);
    R = cut.Intensity;
    x = cut.qxy.*sign(cut.tthf);
    Pilatus2mHmask = [488:494, 982:988];
    R(Pilatus2mHmask) = [];
    x(Pilatus2mHmask) = [];
    % remove q<0
    outR = find(x<0.0);x(outR) = []; R(outR) = [];
    x(650:end) = [];
    R(650:end) = [];
    % if x(650) > 0.2
    if max(x) < 0.2
        qmax = max(x);
    else
        qmax = 0.2;
    end
    cut.X(Pilatus2mHmask) = [];
    outR = find(x<0.02);x(outR) = []; R(outR) = [];
    outR = find(x>qmax);x(outR) = []; R(outR) = [];
    outR = find(isnan(R)==1);x(outR) = []; R(outR) = [];
    gc_int = interp1(gc(:,1), gc(:,2), x);
    %R = R/si.Exposuretime;
    %IC = si.IC/si.Exposuretime;
    fprintf('Exposure time %0.3fs\n', si.Exposuretime);
    fprintf('Linecut made at q=0 will be compared with dsigma/dOmega of GC.\n');
    
    normaln = gc_int(:)./R(:);
    outl = outlier2(normaln);
    normaln(outl) = [];
    fitvalue = mean(normaln);
    fprintf('Scale factor: %0.4e\n', fitvalue);
    fprintf('I0/s of the reference is: %0.4e\n', IC);
    % Update the result
    % 1. On gisaxsleenew
    saxs.ScaleFactor = fitvalue;
    saxs.ScaleI0 = IC;
    setgihandle(saxs);
    hgisaxslee = findobj('tag', 'gisaxsleenew');
    saxsleehandles = guihandles(hgisaxslee);
    set(saxsleehandles.ed_ScaleFactor, 'string', sprintf('%0.4e', fitvalue));
    set(saxsleehandles.ed_I0Ref, 'string', sprintf('%0.4e', IC));
    % 2. To users
    figure;
    loglog(gc(:,1), gc(:,2), 'b', x, R*fitvalue, 'ro');
    fprintf('In order to covert the count of image into an absolute scale,\n')
    fprintf('1. multiply data by the scale factor.\n');
    fprintf('2. divide data by the thickness (cm).\n')
    fprintf('3. divide data by the exposure time (second).\n')
%    fprintf('4. If needed, divide data by I0Ref, which is %0.4f in this experiment.\n', IC)
    fprintf('This assumes the following:\n')
    fprintf('The incoming flux is the same and measurement geometry not changed.\n')
%    fprintf('The data has not been normalized by the time.\n')
    end

    function qNorm = check_normalizationoptions(saxs)
        qNorm = 0;
        if isfield(saxs, 'qtime_normalize')
            if saxs.qtime_normalize
                qNorm = 1;
            end
        end
        if isfield(saxs, 'qScaleI0')
            if saxs.qScaleI0
                qNorm = 1;
            end
        end
        if isfield(saxs, 'qScaleFactor')
            if saxs.qScaleFactor
                qNorm = 1;
            end
        end
    end
%% --- end nested functions -----------------------------------------------

end % end everything

%   function pushline(varargin)
%       figH = evalin('base', 'SAXSimageviewerhandle');
%       handles = guidata(figH);
%       %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
%       %img = get(findobj(handles.ImageAxes, 'tag', 'SAXSimageviewerImage'), 'CData');
%       saxs = get(figH, 'userdata');
%       img = saxs.image;
% 
%       %t = findobj(handles.ImageAxes, 'type', 'line', 'linestyle', '-');
%       t = findobj(handles.ImageAxes, 'type', 'line', 'linestyle', '-');
%       if numel(t) >= 1
%           xd = cell(size(t));
%           yd = cell(size(t));
%           for k=1:numel(t)
%               xd{k} = round(get(t(k), 'xdata'));
%               yd{k} = round(get(t(k), 'ydata'));
%           end
%       else
%           disp('No line drawn, no result you get')
%           return
%       end
%         %img = handles.ImX;
% %      [x, y] = size(handles.ImX);
% %        if strcmp(get(handles.ImageAxes, 'YDir'), 'reverse')
% %            yd = y-yd;
% %        end
%       cut = cell(size(xd));
%       for k=1:numel(xd)
%         for i=1:numel(xd{k})
%             cut{k}(i) = img(yd{k}(i), xd{k}(i));
%         end
%       end
%       if numel(cut)
%           cut = cut{1};
%       end
%         %t = [xd', yd']
%         %t = handles.ImX(round(xd), round(yd));
%       assignin('base', 'lcut', cut);
% %      assignin('base', 'img', handles.ImX);
% %      assignin('base', 't', [xd', yd']);
%   end
