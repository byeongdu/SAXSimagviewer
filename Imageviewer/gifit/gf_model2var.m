function [var, varname, bnd] = gf_model2var(model)
% read data in fields of freeList of params...
    var = [];UB=[];LB=[];
    varname = {};
    pt = model.particle;
    for i=1:numel(pt)
        getparams(model, i, 'Fq');
        getparams(model, i, 'Sq');
        getparams(model, i, 'CT');
    end
    bnd = [LB(:), UB(:)];
    var = var(:);
% ==============================
% nested function
% ==============================
function getparams(model, numofparticle, fieldname)
k = gf_model(model, 'get', 'particle', numofparticle, fieldname, 'fit');
val = gf_model(model, 'get', 'particle', numofparticle, fieldname);
UBval = gf_model(model, 'get', 'particle', numofparticle, fieldname, 'UB');
LBval = gf_model(model, 'get', 'particle', numofparticle, fieldname, 'LB');
    if ~isempty(k)
        fn = fieldnames(k);
        for p = 1:numel(fn)
            if k.(fn{p}) ~= 1
                varname = [varname; {i}, {fieldname}, {fn{p}}];
                var = [var, val.(fn{p})];
                UB = [UB, UBval.(fn{p})];
                LB = [LB, LBval.(fn{p})];
            end
        end
    end
end

end