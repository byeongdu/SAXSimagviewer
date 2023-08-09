function findcenter_graphical(varargin)

warning off
verNumber = '1.0';
init

function init
    s = getgihandle;
    f = figure;
    set(f, 'MenuBar', 'none');
    %tbh = uitoolbar(f);
    %set(f, 'uitoggletool', 'on');
 
    set(f, 'Tag', 'fig_findcenter_g')
    set(f, 'Name', 'FindCenter');
    set(f, 'units', 'pixels');
    
    figPos = get(f, 'position');
    figPos(3) = 300;
    figPos(4) = 200;
    set(f, 'position', figPos);

    up_DetSet = uipanel('Parent', f,...
        'units', 'pixel',...
        'title', 'Standard Sample', ...
        'Position',[10 150 185 50]) ;
    
    
    std = load_diffraction_standards;
    samstr = cell(numel(std), 1);
    for k = 1:numel(std)
        samstr{k} = std(k).sample;
    end
    
    m = uicontrol('Parent', up_DetSet, ...
        'tag', 'pu_standard',...
        'style', 'popup', ...
        'position', [10, 10, 150, 20], ...
        'string', samstr);
    set(m, 'userdata', std);
    
    up_spg = uipanel('Parent', f, ...
        'unit', 'pixel',...
        'title', 'Setup Information', ...
        'Position',[0 1 185 150]) ;

    w_uc_text = 25;
    h_uc_text = 20;
    left_uc_text = 1;
    bottom_uc_text = 50;
    uc_X = uicontrol('Parent', up_spg, 'style', 'text', 'position', [left_uc_text, h_uc_text*3+bottom_uc_text, w_uc_text, h_uc_text], 'string', 'X');
    uc_Y = uicontrol('Parent', up_spg, 'style', 'text', 'position', [left_uc_text, h_uc_text*2+bottom_uc_text, w_uc_text, h_uc_text], 'string', 'Y');
    uc_SDD = uicontrol('Parent', up_spg, 'style', 'text', 'position', [left_uc_text, h_uc_text+bottom_uc_text, w_uc_text, h_uc_text], 'string', 'SDD');
    uc_pitch = uicontrol('Parent', up_spg, 'style', 'text', 'position', [left_uc_text, h_uc_text*0+bottom_uc_text, w_uc_text, h_uc_text], 'string', 'Pitch');
    uc_yaw = uicontrol('Parent', up_spg, 'style', 'text', 'position', [left_uc_text, h_uc_text*(-1)+bottom_uc_text, w_uc_text, h_uc_text], 'string', 'Yaw');

    left_uc_text = left_uc_text + w_uc_text;
    w_uc_text = 50;
    ed_X = uicontrol('Parent', up_spg, 'tag', 'ed_X', 'style', 'edit', 'position', [left_uc_text, bottom_uc_text+h_uc_text*3, w_uc_text, h_uc_text], 'string', '720');
    ed_Y = uicontrol('Parent', up_spg, 'tag', 'ed_Y', 'style', 'edit', 'position', [left_uc_text, bottom_uc_text+h_uc_text*2, w_uc_text, h_uc_text], 'string', '180');
    ed_SDD = uicontrol('Parent', up_spg, 'tag', 'ed_SDD', 'style', 'edit', 'position', [left_uc_text, bottom_uc_text+h_uc_text, w_uc_text, h_uc_text], 'string', '2000');
    ed_pitch = uicontrol('Parent', up_spg, 'tag', 'ed_pitch', 'style', 'edit', 'position', [left_uc_text, bottom_uc_text+h_uc_text*0, w_uc_text, h_uc_text], 'string', '0');
    ed_yaw = uicontrol('Parent', up_spg, 'tag', 'ed_yaw', 'style', 'edit', 'position', [left_uc_text, bottom_uc_text+h_uc_text*(-1), w_uc_text, h_uc_text], 'string', '0');

    if ~isempty(s)
        set(ed_X, 'string', s.center(1));
        set(ed_Y, 'string', s.center(2));
        set(ed_SDD, 'string', s.SDD);
        if isfield(s, 'tiltangle')
            set(ed_pitch, 'string', s.tiltangle(1));
            if numel(s.tiltangle) > 1
                set(ed_yaw, 'string', s.tiltangle(2));
            end
        end
    end
    
    left_uc_text = left_uc_text + w_uc_text;
    w_uc_text = 100;
    sld_X = uicontrol('Parent', up_spg, 'style', 'slider', 'position', [left_uc_text, bottom_uc_text+h_uc_text*3, w_uc_text, h_uc_text], 'value', 0.5, 'min', 0, 'max', 1, 'callback', @slider_callback);
    sld_Y = uicontrol('Parent', up_spg, 'style', 'slider', 'position', [left_uc_text, bottom_uc_text+h_uc_text*2, w_uc_text, h_uc_text], 'value', 0.5, 'min', 0, 'max', 1, 'callback', @slider_callback);
    sld_SDD = uicontrol('Parent', up_spg, 'style', 'slider', 'position', [left_uc_text, bottom_uc_text+h_uc_text*1, w_uc_text, h_uc_text], 'value', 0.5, 'min', 0, 'max', 1, 'callback', @slider_callback);
    sld_pitch = uicontrol('Parent', up_spg, 'style', 'slider', 'position', [left_uc_text, bottom_uc_text+h_uc_text*0, w_uc_text, h_uc_text], 'value', 0.5, 'min', 0, 'max', 1, 'callback', @slider_callback);
    sld_yaw = uicontrol('Parent', up_spg, 'style', 'slider', 'position', [left_uc_text, bottom_uc_text+h_uc_text*(-1), w_uc_text, h_uc_text], 'value', 0.5, 'min', 0, 'max', 1, 'callback', @slider_callback);
    set(sld_X, 'userdata', ed_X);
    set(sld_Y, 'userdata', ed_Y);
    set(sld_SDD, 'userdata', ed_SDD);
    set(sld_pitch, 'userdata', ed_pitch);
    set(sld_yaw, 'userdata', ed_yaw);

    uicontrol('style', 'pushbutton',...
        'position', [190, 90, 100, 50], ...
        'string', 'Draw',...
        'callback', @drawstandardrings);
    uicontrol('style', 'pushbutton',...
        'position', [190, 40, 100, 50], ...
        'string', 'Clear',...
        'callback', @clearrings);
    
end

    function sam = load_diffraction_standards(varargin)
        fid = fopen('FG_diffracton_standards.txt', 'r');
        sam = [];
        k = 1;
        while 1
            l = fgetl(fid);
            if ~ischar(l), break, end
            [sample, qvalstr] = strtok(l);
            sam(k).sample = sample;
            qval = eval(['[', qvalstr, ']']);
            sam(k).qval = qval;
            k = k + 1;
        end
        fclose(fid);
                
    end

    function slider_callback(varargin)
       
        % Update values
        sv = get(gcbo, 'value');
        edhandle = get(gcbo, 'Userdata');
        pv = str2double(get(edhandle, 'string'));
        if pv==0
            pv = 1;
        end
        if sv == 0.51
            f = -0.1;
        elseif sv == 0.49
            f = 0.1;
        else
            f = pv*(sv-0.5)/0.5*0.05;
        end
        cv = pv + f;
        set(edhandle, 'string', cv);

        %if (sv == 1) || (sv == 0)
        set(gcbo, 'value', 0.5);
        set(edhandle, 'Userdata', cv);
        %end
        
        % Draw lines
        drawstandardrings
    end
    function drawstandardrings(varargin)
        % Erase lines
        ax = evalin('base', 'SAXSimagehandle');
        clearrings;
        
        % Draw lines.
        sd = findobj(gcbf, 'tag', 'pu_standard');
        sd_ud = get(sd, 'userdata');
        sd_val = get(sd, 'value');
        qv = sd_ud(sd_val).qval;
        %strSD = get(sd, 'string');
        %STD = strSD{sd_val};
        %qv = qstandard(STD);
        
        X = str2double(get(findobj(gcbf, 'tag', 'ed_X'), 'string'));
        Y = str2double(get(findobj(gcbf, 'tag', 'ed_Y'), 'string'));
        SDD = str2double(get(findobj(gcbf, 'tag', 'ed_SDD'), 'string'));
        pitch = str2double(get(findobj(gcbf, 'tag', 'ed_pitch'), 'string'));
        yaw = str2double(get(findobj(gcbf, 'tag', 'ed_yaw'), 'string'));
        h = [];
        for i=1:numel(qv)
            han = drawring(X, Y, SDD, pitch, yaw, qv(i), ax);
            h = [h, han];
        end
        set(gcbf, 'userdata', h);
    end
    function qv = qstandard(sample)
        switch sample
            case 'AgBH'
                qv = 0.1076*[1:1:11];
            case 'Si'
                qv = [1, 2,3];
            case 'Al2O3'
                qv = [1,2,3];
        end
    end
    function h = drawring(xc, yc, SDD, pitch, yaw, qvalue, axh)
        ph = linspace(0, 2*pi, 360);ph = ph(:)*180/pi;
        saxs = getgihandle;
        if ~isfield(saxs, 'tiltangle')
            ta = 0;
        else
            ta = saxs.tiltangle;
        end
        
        ta(1) = pitch;
        ta(2) = yaw;
        ta(3) = 0;
        
        px = q2pixel([qvalue(:)*ones(size(ph)), qvalue(:)*zeros(size(ph)), ph], ...
            saxs.waveln, [xc, yc], saxs.psize, SDD, ta);
        %[X, Y] = pol2cart(ph, R);
        h = line(px(:,1), px(:,2), 'color', 'w', 'parent', axh);
    end
    function clearrings(varargin)
        delete(get(gcbf, 'userdata'));
    end
end