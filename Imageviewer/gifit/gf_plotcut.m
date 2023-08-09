function h = gf_plotcut(cut, c)
% plotting cut
% plotting fit
xcol = cut.optxcol;
ycol = cut.optycol;
    if ~isempty(cut.column)
        xf = cut.column{xcol};
        yf = cut.column{ycol};
        h = plot(cut.(xf), cut.(yf), c);
    else
        h = plot(cut.data(:,xcol), cut.data(:,ycol), c);
    end
end