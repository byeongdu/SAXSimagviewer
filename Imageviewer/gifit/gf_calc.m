function [err, cut, ycal] = gf_calc(model, P, cut, varargin)
% P is the number of variables to be fitted...
% varargin{1} should be a cut.
c = [];
ycal = [];
ymea = [];
ymerr = [];
numpnts = [];
if ~iscell(cut)
    disp('a cut should be a cell array')
    return
end
if ~isfield(cut{1}, 'optycol')
    error('Condition your cut data')
    return
end
ycol = cut{1}.optycol;

% ==========================================
% combine all cut data to a single data set.
% ==========================================
for i=1:numel(cut)
%    [xv,yv]=size(cut(i).data);
    ymea = [ymea;cut{i}.intensity];
    ymerr = [ymerr;cut{i}.err];
    numpnts(i) = length(cut{i}.intensity);
    
    % ========================================
    % Calculate scattering intensity from a model
    % ========================================
%    y = gf_model2intensity(model, c, varargin);
    yr = gf_model2intensity(model, cut{i}, varargin);
    ycal = [ycal;yr(:)];
end   
    
    % chisqure calculation
    if ~isempty(P)
        err = calerr(ymea, ycal, P, ymerr);
    else
        err = [];
    end

    % =========================================
    % separate fitted value back to each cut
    % =========================================
fit = {};

for i=1:numel(cut)
    fit{i} = ycal(1:numpnts(i));
    ycal(1:numpnts(i)) = [];
    cut{i}.fit = fit{i}; 
    % ======================================
    % plot the fit to gf_uplot
    % ======================================

    if isfield(cut{i}, 'fithandle')
        if ishandle(cut{i}.fithandle)
            set(cut{i}.fithandle,'YData',fit{i});
%            txt = sprintf('fit of %s', cut{i}.tag);
%            set(cut{i}.text_handle,'String',txt);
            drawnow
        end
    end
    
        
end


function chi2 = calerr(y, fit, P, errorbar)
% P is number of variables.
%    errorbar = cut.data(:,cut.optycol+1);
    chi2 = chi_squared(y, fit, P, errorbar); 
    
function y = gf_model2intensity(model, cut, varargin)
y = 0;
cutdata = cut;
for i=1:numel(model.particle)
    if (i>1) || strcmp(cut.SAXSmode, 'simulation')
        if strcmp(model.particle{i}.layer, model.particle{i}.layer);
            cutdata  = gf_Qcal(cut, model, i);
            if ~isfield(model.particle{i}, 'zdep')
                interface = gf_model(model, 'get', 'layer', 'interface');
                model.particle{i}.zdep = interface(str2double(model.particle{i}.layer));
%                i, model.particle{i}.zdep
                % if zdep is not assigned, particles are assumed to be on top
                % interfaces of each layer.
            end
        end
    end
    if strcmp(model.particle{i}.CT.name, 'none')
        y = y + feval('gf_LMA', model.particle{i}, cutdata, varargin);
    else
        y = y + feval(model.particle{i}.CT.name, model.particle{i}, cutdata, varargin);
    end
end
