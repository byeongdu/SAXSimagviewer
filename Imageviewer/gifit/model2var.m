function [var, varname] = model2var(model)
% read data in fields of freeList of params...
    var = [];
    varname = {};
    pt = model.particle;
    for i=1:numel(pt)
        getparams(model, i, 'Fq');
        getparams(model, i, 'Sq');
        getparams(model, i, 'CT');
    end
% ==============================
% nested function
% ==============================
function getparams(model, numofparticle, fieldname)
k = gf_model(model, 'get', 'particle', numofparticle, fieldname, 'fit');
val = gf_model(model, 'get', 'particle', numofparticle, fieldname);
    if ~isempty(k)
        fn = fieldnames(k);
        for p = 1:numel(fn)
            if k.(fn{p}) ~= 0
                varname = [varname; {i}, {fieldname}, {fn{p}}];
                var = [var, val.(fn{p})];
            end
        end
    end
end

end