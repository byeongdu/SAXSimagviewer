function gf_save(varargin)
filen = varargin{1};
model = varargin{2};
cut = varargin{3};
if numel(varargin) > 4
    fit = varargin{4};
else
    fit = {};
end

fid = fopen(filen, 'w');
% save model
fprintf(fid, '%s\n', '% Model used');
fprintf(fid, '%s\n', '% Film information');
for p = 1:length(model.layer(:,1))
    txt = sprintf('%s : ', model.layer{p,1});
    tmparray = model.layer{p,2};
    for i=1:numel(tmparray)
        txt = sprintf('%s %f', txt, tmparray(i));
    end
    txt = sprintf('%s', txt);
    fprintf(fid, '%s\n', txt);
end

fprintf(fid, '%s\n', '% =====================================');
fprintf(fid, '%s\n', '% Particle information');

fieldn{1} = 'Fq';
fieldn{2} = 'Sq';

for p=1:numel(model.particle)
    for k = 1:numel(fieldn)
    fprintf(fid, '%s%s \n', '% ', fieldn{k});
    if isfield(model.particle{p}, fieldn{k})
        fprintf(fid, '%s : %s\n', 'name', model.particle{p}.(fieldn{k}).name);
        if ~strcmp(model.particle{p}.(fieldn{k}).name, 'none')
            t = model.particle{p}.(fieldn{k}).param;
            for i=1:length(t(:,1))
                fprintf(fid, '%s %f %f %f %d\n', t{i,1}, t{i,2}, t{i,3}, t{i,4}, t{i,5});
            end
        end
    else
%        fprintf(fid, '%s : none\n', fieldn{k});
        break;
    end
    end
    if isfield(model.particle{p}, 'CT')
        fprintf(fid, '%s\n', '% CT');
        fprintf(fid, '%s : %s\n', 'name', model.particle{p}.CT.name);
    end
end

fprintf(fid, '%s\n', '% =====================================');
fprintf(fid, '%s\n', '% Cut');
for p=1:numel(cut)
    fieldn = fieldnames(cut{p});
    val = struct2cell(cut{p});
    for k = 1:numel(fieldn);
%    [a,b] = intersect(fieldn, 'fn');
        if ~strcmp(fieldn{k}, 'data')
            if ischar(val{k})
                fprintf(fid, '%s : %s\n', fieldn{k}, val{k});
            else
                fprintf(fid, '%s : %f\n', fieldn{k}, val{k});
            end
        end
    end
    fprintf(fid, '%s :\n', 'data');
    data = cut{p}.data;
    [row,col] = size(data);
    txt = '';
    for k = 1:col
        txt = sprintf('%s %s', txt, '%f');
    end
    if isempty(fit)
        txt = sprintf('%s\n', txt);
%        fprintf(fid, txt, data');
    else
        txt = sprintf('%s %f\n', txt);
        data = [data, fit{p}];
    end
    fprintf(fid, txt, data');
end
fclose(fid);