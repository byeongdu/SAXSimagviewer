function [a, x, y] = linecutread(file)
% ascii file(2colum with header format) reader
% function [a, x, y] = linecutread(file)
% a = [x, y]
fid=fopen(file);
x = [];y = [];a = [];
i=1;
while 1
    tline = fgetl(fid);
    if ischar(tline)
        rline = sscanf(tline, '%f');
        if isnumeric(rline)
            x(i)=rline(1);y(i)=rline(2);i=i+1;
        end
    else
        break;
    end
end
    x = x';y=y';
    a = [x, y];
fclose(fid);