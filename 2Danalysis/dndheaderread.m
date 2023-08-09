function data = dndheaderread(filename, headername)
% 'dndopen' is to read dnd 1D data files.
% data = dndopen(filename)
%

fid = fopen(filename, 'r');
line = fgetl(fid);
if findstr(headername, 'Timestamp')
    headername = 'Timestamp when scan started';
end

while line~=-1
    [head, R] = strtok(line, ' ');
    if ~strcmp(head,'#')
        break
    end
    t = findstr(R, headername);
    if ~isempty(t)
        data = R(t+length(headername):end);
        if findstr(headername, 'Timestamp')
            [da, data] = strtok(data, ' ');
        end
        break
    end
    line=fgetl(fid);
end
fclose(fid);