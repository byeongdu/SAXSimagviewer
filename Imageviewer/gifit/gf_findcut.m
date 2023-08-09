function indx = gf_findcut(linetag, cut)
% indx = gf_findcut(linetag, cut)
% example : gf_findcut('sto69h.dat', cut)
% Byeongdu Lee
%    tag = get(linehandle(i), 'tag');

    fnames = fieldnames(cut{1});
%    k = cell(numel(fnames),numel(cut));
    k = cell(numel(fnames), numel(cut));
    for i=1:numel(cut)
        temp = struct2cell(cut{i});
        k(:,i) = temp(1:numel(fnames));
    end
    tagp = findcellstr(fnames, 'tag');
    tags = k(tagp, :);
    indx = findcellstr(tags, linetag);