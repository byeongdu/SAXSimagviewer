function handles = plotcut(handles, saxs, R, X, Y, cut)

%if ~isfield(saxs, 'imgaxeshandle')
%    saxs.imgaxeshandle = get(saxs.imghandle, 'parent');
    imgaxeshandle = evalin('base', 'SAXSimagehandle');
%end
currentFig = imgaxeshandle;
if isfield(handles, 'Lineh')
    nl = line(cut.X, cut.Y, 'parent', currentFig, 'color', 'r');
    handles.Lineh = [handles.Lineh, nl];
else
%    get(currentFig)
    handles.Lineh = line(cut.X, cut.Y, 'parent', currentFig, 'color', 'r');
end



handles.currentFig = currentFig;

NewfigH = str2double(char(cellstr(get(handles.ed_newFig, 'string'))));
oldlegend = [];
if isempty(NewfigH) | isnan(NewfigH)
    NewfigH = 0;
    NewfigH = figure(2);
end

if (NewfigH >= 1)
    figure(NewfigH)
    if get(handles.rb_holdon, 'value')
        hold on
        lineuserdata = get(findobj(NewfigH, 'tag', 'legend'), 'Userdata');
        if isfield(lineuserdata, 'lstrings')
            oldlegend = lineuserdata.lstrings;
        end
    else
        hold off
    end
end

% ================== selection of x axis.
% ===========================
tt = plot(X, R);

set(tt, 'Tag', 'data');
set(tt, 'userdata', cut);
% ============================================
[ps, na, ext] = fileparts(saxs.imgname);imgname = [na, ext];
if isempty(char(cellstr(get(handles.ed_legend, 'string'))))
%    tempstr = sprintf('H Cut of %s at x :%s, y : %s', saxs.imgname, num2str(LCx), num2str(LCy));
    tempstr = sprintf('H Cut of %s', imgname);
    legend([oldlegend, {tempstr}])
else
    legend([oldlegend, cellstr(get(handles.ed_legend, 'string'))]);
end
end