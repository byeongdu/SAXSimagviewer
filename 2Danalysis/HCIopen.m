function R = HCIopen(filename)
% this function is for loading HCI binary data file.
% default data size is 1024*1024.

fid = fopen(filename, 'r');
fseek(fid, 512, -1);
datatype = 'int32';
R = fread(fid, [1024, 1024], datatype);
fclose(fid);