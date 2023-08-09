function model = gf_var2model(var,varname,model)
%params = var2params(var,params,freeList)
% varname = {particle number, 'FqorSq', 'varname')
% gf_model(md, 'set', 'particle', 1, 'Fq', 'r', 5, 1)
% var should contain values only for freeList...
%Support function for 'fit.m'
%Written by G.M Boynton, Summer of '00
%gf_model(md, 'get', 'particle', 1, 'Fq', 'fit')
%count = 1;
for i=1:numel(var)
    model = gf_model(model, 'set', 'particle', varname{i, 1}, varname{i,2}, varname{i,3}, 2, var(i));
end