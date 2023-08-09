function [R, p, TimeStp] = GoldOpen(filename)
% 'Goldopen' is to read just one Gold detector file at BESSRC
% usage :
%		for example
% 		[A, p] = Goldopen('test.xxx') : the result will be column vector.
% you can also read 2-dimensional file as matrix form.
% p is the Scaler Counts.
% p(2) is ICdata, p(3) is Photodiode data;

fid = fopen(filename, 'r');

if (fid<0) 
	error(['Couldn''t find ' file]);
end

%xextent = 1536;
%yextent = 1536;

line=fgetl(fid);
% ==================== Header bytes
while line~=-1
    [~, paramvalue] = strtok(line,'=');
	if strcmp(strtok(line,'='),'HEADER_BYTES')
        break
	end
	line=fgetl(fid);
end
Header_bytes = str2double(paramvalue(2:end-1));

% ==================== data type
while line~=-1
    [~, paramvalue] = strtok(line,'=');
	if strcmp(strtok(line,'='),'Data_type')
        break
	end
	line=fgetl(fid);
end

paramvalue = paramvalue(2:end-1);

if strcmp(paramvalue, 'unsigned short int')
    datatype = 'uint16';
else%if strcmp(paramvalue, 'float32');
    datatype = 'float';
end
% ==================== Xextent
while line~=-1
    [~, paramvalue] = strtok(line,'=');
	if strcmp(strtok(line,'='),'SIZE1')
        break
	end
	line=fgetl(fid);
end
xextent = str2double(paramvalue(2:end-1));
% ==================== Yextent
while line~=-1
    [~, paramvalue] = strtok(line,'=');
	if strcmp(strtok(line,'='),'SIZE2')
        break
	end
	line=fgetl(fid);
end
yextent = str2double(paramvalue(2:end-1));

% ====================== ICdata reading
if nargout > 1
    line=fgetl(fid);

    while line~=-1
        if strcmp(strtok(line, '='), 'GOLD_EXPOSE_TIMESTAMP')
            [~, paramvalue] = strtok(line,'=');
            [paramname, paramvalue] = strtok(paramvalue,' ');
            dateS = paramname(2:end);
            timeS = paramvalue(2:(end-1));
            TimeStp = datenum(dateS) + datenum(timeS);
        end
            
    	if strcmp(strtok(line,'='),'ID12_SCLC1_COUNTS_01')
    		p(1)=str2double(line(22:(end-1)));
        elseif strcmp(strtok(line,'='),'ID12_SCLC1_COUNTS_02')  % IC data
    		p(2)=str2double(line(22:(end-1)));
        elseif strcmp(strtok(line,'='),'ID12_SCLC1_COUNTS_03')  % Photodiode data
    		p(3)=str2double(line(22:(end-1)));
        elseif strcmp(strtok(line,'='),'ID12_SCLC1_COUNTS_04')
    		p(4)=str2double(line(22:(end-1)));
            break
    	end
    	line=fgetl(fid);
    end
end

% ================== image offset
line=fgetl(fid);
while line~=-1
    [~, paramvalue] = strtok(line,'=');
	if strcmp(strtok(line,'='),'IMAGE_OFFSET')
        break
	end
	line=fgetl(fid);
end
Image_offset = str2double(paramvalue(2:end-1));

% =================== data reading and subtracting the offset value............
fseek(fid, Header_bytes+1, -1);
R = fread(fid, [xextent, yextent], datatype)' - Image_offset;
fclose(fid);

%rsspe(R);