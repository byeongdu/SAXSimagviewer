function gf_data(hObject, eventdata, varargin)
% need handles
if strcmp(get(hObject, 'tag'), 'pmData')
    % Initialize and Display fields of cut
    %
    cut = getappdata(gcbf, 'cut');
    hpmData = hObject;
    cst = get(hpmData, 'string');
    particle = str2double(cst{get(hpmData, 'value')});    
%    cut = ct{particle};
%    cut = varargin{1};
    noneedtoini = 0;

    if isfield(cut{particle}, 'inid')
        if cut{particle}.inid == 1
            noneedtoini = 1;
        end
    end

    if noneedtoini == 0
        if ~isfield(cut{particle}, 'tag')
            cut{particle}.tag = cut{particle}.fn;
            %cut{particle}.tag = 'data';
        end
        if ~isfield(cut{particle}, 'optfit');
            cut{particle}.optfit = 0;
        end
        if ~isfield(cut{particle}, 'optplot')
            cut{particle}.optplot = 0;
        end
        if ~isfield(cut{particle}, 'SAXSmode')
            cut{particle}.SAXSmode = 'SAXS';
        end
        if ~isfield(cut{particle}, 'pntfit')
            cut{particle}.pntfit = numel(cut{particle}.data(:,1));
        end
        if isfield(cut{particle}, 'type')
            switch cut{particle}.type
                case 0      %vertical cut
                    cut{particle}.optxcol = 2;
                    cut{particle}.optycol = 4;
                case 1      %Horizontal cut
                    cut{particle}.optxcol = 3;
                    cut{particle}.optycol = 4;
                case 2      %Image
                    cut{particle}.optxcol = 3;
                    cut{particle}.optycol = 4;
                otherwise      %Image
                    cut{particle}.optxcol = 1;
                    cut{particle}.optycol = 2;
            end
        end
        if ~isfield(cut{particle}, 'optxcol')
            cut{particle}.optxcol = 1;
        end
        if ~isfield(cut{particle}, 'optycol')
            cut{particle}.optycol = 2;
        end
        if ~isfield(cut{particle}, 'datahandle')
            cut{particle}.datahandle = 0;
        end
        cut{particle}.inid = 1;
    end
    handle = guihandles(gcbf);
    set(handle.eddatatag, 'string', cut{particle}.tag);
    set(handle.edNpntsfit, 'string', cut{particle}.pntfit);
    set(handle.edSAXSmode, 'string', cut{particle}.SAXSmode);
    set(handle.rdPlotorNot, 'value', cut{particle}.optplot);
    set(handle.rdFitorNot, 'value', cut{particle}.optfit);
% ===============================================
%    dn = 1:numel(cut{particle}.data(1,:));
%    t = numlist2cellstr(dn);
%    set(handle.pmxcol, 'string', t);
%    set(handle.pmycol, 'string', t);
%    set(handle.pmxcol, 'value', findcellstr(t, num2str(cut{particle}.optxcol)));
%    set(handle.pmycol, 'value', findcellstr(t, num2str(cut{particle}.optycol)));
% ===============================================
    set(handle.pmxcol, 'string', cut{particle}.column);
    set(handle.pmycol, 'string', cut{particle}.column);
    set(handle.pmxcol, 'value', cut{particle}.optxcol);
    set(handle.pmycol, 'value', cut{particle}.optycol);
% ===============================================    
    setappdata(gcbf, 'cut', cut);

    % refresh the list of pmData, numbers of cuts.
    dn = 1:numel(cut);
    t = numlist2cellstr(dn(:));
    set(hObject, 'string', t);
    
    % =======================
    % plot data
    % ======================
    gf_data([], [], 'optplot');
else
    % ============================
    % Actual callbacks 
    % ============================
    fieldname = varargin{1};
    cut = getappdata(gcbf, 'cut');
    
    if ~isempty(hObject)
        strdata = get(hObject, 'style');
    else
        strdata = 'none';
    end
%    get(hObject,'tag')
    hpmData = findobj(gcbf, 'tag', 'pmData');
    cst = get(hpmData, 'string');
    particle = str2num(cst{get(hpmData, 'value')});    
%    strdata

    % if hObject is one of handles of pmData
    % read values of the handle.
    if strcmp(strdata, 'edit')
        val = get(hObject, 'string');
    end
    if strcmp(strdata, 'radiobutton')
        val = get(hObject, 'value');
    end
    if strcmp(strdata, 'popupmenu')
% ===========================================
% when cst is a mixed number array. ex) cst = {'1','3','2','5'}....
%        cst = get(hObject, 'string');
%        val = str2num(cst{get(hObject, 'value')})  
% ===========================================
        val = get(hObject, 'value'); % when cst is a sequence of a number array. ex) cst = {'1','2','3'}
    end
    
    % if hObject is one of handles of pmData
    % set values, otherwise skip...
    if ~strcmp(strdata, 'none')
        cut{particle}.(fieldname) = val;
        setappdata(gcbf, 'cut', cut);
    end
    
    % ==================
    % Execute commands....
    % ==================
    switch fieldname
        case 'optplot'
            h = findall(0, 'tag', 'gf_uplot');
            if isempty(h)
                h = gf_uplot;
            end
            if get(findobj(gcbf, 'tag', 'rdPlotorNot'), 'value')
%                xcol = cut{particle}.optxcol;
%                ycol = cut{particle}.optycol;
                figure(h);
                t = findobj(h, 'tag', 'data', 'DisplayName', cut{particle}.tag);
                if isempty(t)
%                    t = plot(cut{particle}.data(:,xcol), cut{particle}.data(:,ycol), 'b');
                    t = gf_plotcut(cut{particle}, 'b');
                else
                    set(t, 'Visible', 'on');
                end
                cut{particle}.datahandle = t;
                set(t, 'tag', 'data');
                set(t, 'DisplayName', cut{particle}.tag)
                set(t, 'userdata', particle);   %% index to find the number of a cut.
            else
%                t = findobj(h, 'tag', 'data');
                t = findobj(h, 'DisplayName', cut{particle}.tag);
                delete(t);
                cut{particle}.datahandle = 0;
            end
            setappdata(gcbf, 'cut', cut);
        otherwise
    end
end
end       