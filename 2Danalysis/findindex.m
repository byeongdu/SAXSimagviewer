function findindex(xpixel, ypixel)

try
    peakdata = evalin('base', 'peakdata');
    findit(peakdata, '')
catch
end


try
    peakdataR = evalin('base', 'peakdataR');
    findit(peakdataR, ' by reflected beam')
catch
end

try
    peakdataT = evalin('base', 'peakdataT');
    findit(peakdataT, ' by transmitted beam')
catch
end


function findit(peak, strcmd)

X = [peak.qp];
Y = [peak.qz];
xi = find((X > xpixel-2) & (X < xpixel+2));
yi = find((Y > ypixel-2) & (Y < ypixel+2));
p = intersect(xi, yi);
if ~isempty(p)
    fprintf('The peak is %s%s.\n', peak(p).string, strcmd)
end
end
end