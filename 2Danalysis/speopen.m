function R = speopen(filename, numofframe, ROI)
% 'speopen' is to read just one 'spe' file
% if you have a file which is composed of several frames.
% 		then, why don't you use 'framespe'
% usage :
%		for example
% 		A = speopen('test.spe') : the result will be column vector.
% you can also read 2-dimensional file as matrix form.
%
% ROI should not be confused.
% when matrix is display by image.m, row goes to y aixs, colum goes to x
% axis....
% image(ROI(1):ROI(2), ROI(3):ROI(4))
if nargin < 2
    numofframe = 1;
end

fid = fopen(filename, 'r');
fseek(fid, 42, -1);
xextent = fread(fid, 1, 'int16');

fseek(fid, 108, -1);
type = fread(fid, 1, 'int16');

fseek(fid, 656, -1);
yextent = fread(fid, 1, 'int16');

if type == 0
   datatype = 'float32';
   bit_data = 32;
elseif type == 1
   datatype = 'int32';
   bit_data = 32;
elseif type == 2
   datatype = 'int16';
   bit_data = 16;
elseif type == 3
   datatype = 'uint16';
   bit_data = 16;
end
%fseek(fid, 10,-1);
%exp_sec = fread(fid, 1, 'int16');

fseek(fid, 4100, -1);
if nargin<2
    R = readfid(numofframe);
else
    for i=1:numel(numofframe)
        t = readfid(numofframe(i));
        if nargin == 3;
            if ~isempty(t)
                R(:,:,i) = t(ROI(1):ROI(2), ROI(3):ROI(4));
            else
                disp(sprintf('No frame at #%d', numofframe(i)));
                return;
            end
        else
            R(:,:,i) = t;
        end
    end
end

    function R = readfid(nf)
        kk = fseek(fid, bit_data/8*xextent*yextent*(nf-1)+4100, -1);
        if kk>=0
            R = fread(fid, [xextent, yextent], datatype)';
        else
            R = [];
        end
    end
%if nargin > 1
%    for i=1:numofframe
%        ftell(fid)
%        R = fread(fid, [xextent, yextent], datatype)';
%        R(:,:,i) = t(500:800, 300:700);
%    end
%else
%    R = fread(fid, [xextent, yextent], datatype)';
%end

fclose(fid);
end

%rsspe(R);