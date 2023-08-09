function R = frameSpe(filename, framenumber)
% spe화일 읽는 프로그램.
% frame을 지정하면 그것 읽고
% 안하면 모든 화일 읽기 column 데이터로 반환

%fid = fopen(filename, 'r');
%fseek(fid, 30, -1);
%hour = fread(fid, 1, 'int8')

%fid = fopen(filename, 'r');
%fseek(fid, 32, -1);
%minu = fread(fid, 1, 'int8')

%fid = fopen(filename, 'r');
%fseek(fid, 38, -1);
%sec = fread(fid, 1, 'int8')
%
fid = fopen(filename, 'r');
fseek(fid, 42, -1);
xextent = fread(fid, 1, 'int16');

fseek(fid, 108, -1);
type = fread(fid, 1, 'int16');

fseek(fid, 656, -1);
yextent = fread(fid, 1, 'int16');

if type == 0
   datatype = 'float32';
   byte_size = 8;
elseif type == 1
   datatype = 'int32';
   byte_size = 8;
elseif type == 2
   datatype = 'int16';
   byte_size = 4;
elseif type == 3
   datatype = 'uint16';
   byte_size = 4;
end

if nargin == 1
   %fseek(fid, 10,-1);
   %exp_sec = fread(fid, 1, 'int16');
   i =1;
   R = [];
   while fseek(fid, (4098*(i*2-1) + 2), -1) == 0;
      R = [R , fread(fid, [xextent, yextent], datatype)];
      i = i+1;
   end
else
   %findwhere = 4098*(framenumber*2-1) + 2;
   %fseek(fid, findwhere, -1);
   %R = fread(fid, [xextent, yextent], datatype);
   %R = R';
   fseek(fid, (4100 + xextent*yextent*(framenumber-1)*byte_size), -1);
   R = fread(fid, [xextent, yextent], datatype);
   R = R';
end

fclose(fid);

%rsspe(R);