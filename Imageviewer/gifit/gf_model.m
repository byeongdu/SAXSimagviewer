%% Structure of Model 
% Model.particle = {P1, P2, ...}
%       P1.Fq
%          Fq.fname
%          Fq.z
%          Fq.param = {'R', 1, 0.8, 1.2, 0; ...}
%                   name, ini_value, Lower limit (fraction), Upper limit
%                   (fraction), Hold or not
%       P1.Sq
%          Sq.fname
%          Sq.param = {'R', 1, 0.8, 1.2, 0; ...}
%                   name, ini_value, Lower limit (fraction), Upper limit
%                   (fraction), Hold or not
%          Sq.method = 'LMA'
%                   
% Model.layer ...
%   = { 'edensity', [0, 0.4, 0.7]; ...
%       'beta',     [0, 1E-9, 1E-7]; ...
%       'z',        [NaN, 3, 3]; ...
%       'sig',      [NaN, 0, 0]; ...
%       'xEng',   12};
function ret = gf_model(model, action, varargin)
    
    if nargin < 2
        ret = numel(model.Fq);
        return
    end

    switch lower(action)
        case 'ini'
             ret.layer ...
               = { 'edensity', [0, 0.4, 0.7]; ...
                   'beta',     [0, 1E-9, 1E-7]; ...
                   'interface',        [0, 0, -300]; ...
                   'roughness',      [0, 3, 3]; ...
                   'number',    [1, 2, 3];...
                   'xEng',   12};
%               p1.param = {'R', 1, 0.8, 1.2, 0; 'dR', 0.2, 0.8, 1.2, 1};
             ret.particle = {};
        case 'get'
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    paramname = varargin{2};
                    model = gf_model(model, 'cell2struct', fieldname);
                    ret = model.(fieldname).(paramname);
                case 'particle'
                    % ex : gf_model(md, 'get', 'particle', 1, 'Fq')
                    number = varargin{2};
                    numvar = numel(varargin);
                    if ~isfield(model.(fieldname){number}, 'Fq')
                        ret = [];
                        return;
                    end
                    if numvar ==3
                        fieldFqSqCT = varargin{3};
                        if ~isempty(model.(fieldname){number}.(fieldFqSqCT).param)
                            ret = gf_model(model.(fieldname){number}.(fieldFqSqCT).param, 'cell2struct', 'particle');
                        else 
                            ret = [];
                            return
                        end
                    elseif numvar == 2 
                        % ex : gf_model(md, 'get', 'particle', 1)
                        if ~isempty(model.(fieldname){number}.Fq.param)
                            ret.Fq = gf_model(model, 'get', 'particle', number, 'Fq');
                        end
                        if ~isempty(model.(fieldname){number}.Sq.param)
                            ret.Sq = gf_model(model, 'get', 'particle', number, 'Sq');
                        end
                        if ~isempty(model.(fieldname){number}.CT.param)
                            ret.CT = gf_model(model, 'get', 'particle', number, 'CT');
                        end
                    elseif numvar == 4
                        % ex : gf_model(md, 'get', 'particle', 1, 'Fq', 'UB')
                        fieldFqSqCT = varargin{3};
                        if ~isempty(model.(fieldname){number}.(fieldFqSqCT).param)
                            ret = gf_model(model.(fieldname){number}.(fieldFqSqCT).param, 'cell2struct', 'particle', varargin{4});
                        else 
                            ret = [];
                        end
                    end
            end
                    
                
        case 'set'
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    paramname = varargin{2};
                    value = varargin{3};
 %                  ret = model
                    model = gf_model(model, 'cell2struct', fieldname);
                    model.(fieldname).(paramname) = value;
                    ret = gf_model(model, 'struct2cell', fieldname);
%                   disp('should be cell')
                case 'particle'
                    % gf_model(md, 'set', 'particle', 1, 'Fq', 'r', 5, 1)
                    % gf_model(md, 'set', 'particle', 1, 'Fq', 'r', column, value)
                    number = varargin{2};
                    fieldFqSqCT = varargin{3};
                    paramname = varargin{4};
                    colum = varargin{5};
                    value = varargin{6};
                    if ~isempty(model.particle{number}.(fieldFqSqCT).param)
                        [a1, a2, a3] = intersect(model.particle{number}.(fieldFqSqCT).param(:,1), paramname);
                        model.particle{number}.(fieldFqSqCT).param{a2, colum} = value;
                        ret = model;
                    else
                        sprintf('Error : the field, %s is not existing\n', fieldFqSqCT)
                        ret = model;
                        return
                    end
            end
        case 'add'
            num = varargin{2};
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    numlayer = numel(model.layer)/2;
                    for i=1:numlayer
                        switch model.layer{i,1}
                        case {'edensity', 'beta', 'interface', 'roughness'}
                            crt_val = model.layer{i,2};
                            crt_val = [crt_val(1:num), 0, crt_val(num+1:end)];
                            model.layer{i,2} = crt_val;
                        case 'number'
                            t = numel(model.layer{i,2});
                            model.layer{i,2} = 1:(t+1);
                            otherwise
                        end
                    end
                case 'particle'
            end
            ret = model;
        case 'remove'
            num = varargin{2};
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    numlayer = numel(model.layer)/2;
                    for i=1:numlayer
                        switch model.layer{i,1}
                        case {'edensity', 'beta', 'interface', 'roughness'}
                            model.layer{i,2}(num) = [];
                        case 'number'
                            t = numel(model.layer{i,2});
                            model.layer{i,2} = 1:(t-1);
                        otherwise
                        end
                    end
                case 'particle'
                    model.particle(num) = [];
            end
            ret = model;
        case 'cell2struct'        % conversion cell to struct
            ret = model;
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    ret.layer = cell2struct(model.layer(:,2), model.layer(:,1), 1);
                case 'particle' % input model should be 
                                % either model.particle{1}.Fq.param,
                                % ...Sq... or ...CT....
                    if numel(varargin) == 1 
                        % ex: gf_model(md.particle{1}.Fq.param, 'cell2struct', 'particle')
                        ret = cell2struct(model(:,2), model(:,1), 1);
                    else
                        % ex : gf_model(md.particle{1}.Fq.param, 'cell2struct', 'particle', 'UB')
                        switch lower(varargin{2});
                            case 'lb'
                                ret = cell2struct(model(:,3), model(:,1), 1);
                            case 'ub'
                                ret = cell2struct(model(:,4), model(:,1), 1);
                            case 'fit'
                                ret = cell2struct(model(:,5), model(:,1), 1);
                        end
                    end
            end
        case 'struct2cell'
            ret = model;
            fieldname = varargin{1};
            switch fieldname
                case 'layer'
                    lay = model.layer;
                    f = fieldnames(lay);
                    c = struct2cell(lay);
                    c = [f, c];
%                    ret = rmfield(model, 'Layer');
                    ret.layer = c;
                case 'particle'
                    lay = model.particle;
                    f = fieldnames(lay);
                    c = struct2cell(lay);
                    c = [f, c];
%                    ret = rmfield(model, 'Particle');
                    ret.particle = c;
            end

        otherwise
            disp('There is not the action you select')
    end
end