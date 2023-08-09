function err = gf_fitFunction(var, varname, model, origVarargin)
%err = fitFunction(var,funName,params,freeList,origVarargin)
%
%Support function for 'gi_fit.m'
%Written by Byeongdu


%stick values of var into params

model = gf_var2model(var, varname, model);
cut = origVarargin{1};
if numel(origVarargin)>1
    vararg = origVarargin{2:end};
else
    vararg = {};
end
err = gf_calc(model, numel(var), cut, vararg);
