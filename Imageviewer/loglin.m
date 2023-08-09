function loglin(action)

    if ~exist('action','var') 
        action = 'init';
    elseif isempty(action)
        action = 'init';
    end

    if strcmp(action, 'init');
        XHR_HANDLES = INIT;
        return
    end

    XHR_HANDLES = get(gcbf,'userdata');
    curFig = XHR_HANDLES.plot;

    if strcmp(action,'log')
        ImgUser = get(findobj(gca, 'Type', 'image'), 'CData');
        set(findobj(curFig, 'Type', 'image'), 'Cdata', log(double(ImgUser)));
        set(XHR_HANDLES.done, 'string', 'lin')
        set(XHR_HANDLES.done, 'CallBack', 'loglin(''lin'');')
    elseif strcmp(action, 'lin')
        hSAXSlee=findobj('Tag','GISAXSLee');
        saxs=get(hSAXSlee, 'Userdata');
        [saxs, data]=openccdfile({saxs.imgname},saxs);
        set(hSAXSlee, 'Userdata', saxs);
        set(findobj(curFig, 'Type', 'image'), 'Cdata', data);
        set(XHR_HANDLES.done, 'string', 'log')
        set(XHR_HANDLES.done, 'CallBack', 'loglin(''log'');')
    end

    if strcmp(action,'exit');
        close(XHR_HANDLES.plot);
        return;
    end
    
    set(curFig,'userdata',XHR_HANDLES);
end

function [H] = INIT
    saxs=getgihandle;
    curFig = saxs.imgfigurehandle;
    H.plot = curFig;

    H.done        = uicontrol(H.plot, 'Style','Push','Units','Normalized',...
                              'Position',[.80 .00 .10 .05],...
                              'String','log',...
                              'Tag','LOG',...
                              'CallBack','loglin(''log'');');
    H.exit        = uicontrol(H.plot, 'Style','Push','Units','Normalized',...
                              'Position',[.90 .00 .10 .05],...
                              'String','exit',...
                              'Tag','EXIT',...
                              'CallBack','loglin(''exit'');');
   set(curFig,'userdata',H);
end