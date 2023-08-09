function count = scanSAXSspecfile(specfile, searchstr)
if isempty(specfile)
    count = [];
    return;
end
count = specSAXSn2(specfile, searchstr, 1);