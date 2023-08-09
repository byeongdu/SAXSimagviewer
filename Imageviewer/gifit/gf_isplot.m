function ret = gf_isplot(varargin)
% check whether a line is display somewhre on a figure or axis or not.
% output -1, 0, 1
%   -1 : error, input field does not exist
%   0 : no data plotted.
%   1 : yes data plotted.
% EX.
% gf_isplot(cut{1}, 'fithandle', gca)
% gf_isplot(cut{1}.fithandle, gca)
if isstruct(varargin{1})
    if isfield(varargin{1}, varargin{2})
        lineh = varargin{1}.(varargin{2});
        figh = varargin{3};
    else
        disp('the input field does not exist... error in gf_isplot...')
        ret = -1;
        return
    end
else
    lineh = varargin{1};
    figh = varargin{2};
end

lines = findobj(figh, 'type', 'line');
if isempty(lineh)
    ret = 0;
    return;
end
if isempty(find(lines == lineh))
    ret = 0;
else
    ret = 1;
end
