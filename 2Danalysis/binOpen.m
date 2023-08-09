function R = binOpen(filename, startbyte, dataFormat, xdim, ydim)
% 'binopen' is to read just arbitrary binary file

fid = fopen(filename, 'r+', 'n');


fseek(fid, startbyte, -1);
ftell(fid);
R = fread(fid, [xdim, ydim], dataFormat)';

ftell(fid);
fseek(fid, 0, 1);
ftell(fid);
fclose(fid);

%rsspe(R);