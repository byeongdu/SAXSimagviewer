function fitd = gf_reducepnts(cut)
    fitd = cut;
    selpnt = cut.selectpnts;
    
    if ~isempty(cut.column)
        indx = 1:numel(cut.(cut.column{1}));
        indx(selpnt)=[];
        cutreduce
    else
        indx = 1:numel(cut.data(:,1));
        indx(selpnt)=[];
        fitd.data(indx,:) = [];
    end
    
    if numel(selpnt) > cut.pntfit
        ind = linspace(1, numel(selpnt), str2double(cut.pntfit));
        indx = 1:numel(selpnt);indx(fix(ind)) = [];
        fitd.data(indx,:)=[];
    end
% =================================
% Nested Function
% =================================
    function cutreduce
        fitd.data(indx,:) = [];
        for i=1:numel(cut.column)
            tmp = fitd.(cut.column{i});
            tmp(indx) = [];
            fitd.(cut.column{i}) = tmp(:);
        end
    end
end