function [data, header] = dndopen(filename)
% [data, header] = dndopen(filename)
% 'dndopen' is to read dnd 1D data files.
% data = dndopen(filename)
%

fid = fopen(filename, 'r');
firstline = '#';
startn = '#';
while startn == '#'
   firstline = fgetl(fid);
   startn = firstline(1);
end
i = 1;
while 1
    data(i,:) = sscanf(firstline, '%f')';
    firstline = fgetl(fid);
    if length(firstline) < 1, break, end
    if ~ischar(firstline), break, end
    i=i+1;
end
fclose(fid);

header = {'Wavelength (Angstrom)', 'X pixel size (mm)',...
    'X binning',...
    'X-coordinate location of direct beam (pix)',...
    'Y-coordinate location of direct beam (pix)',...
    'Sample to detector distance (mm)'};
headerfn = {'waveln', 'Xpsize', 'Xbin', 'beamX', 'beamY', 'SDD'};
for i=1:numel(header)
    str = dndheaderread(filename, header{i});
    dt.(headerfn{i}) = str2double(str);
end
dt.psize = dt.Xpsize;
dt.center = [dt.beamX, dt.beamY];
dt.Xeng = 12.398/dt.waveln;
header = dt;