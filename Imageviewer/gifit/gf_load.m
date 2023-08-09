function tmpd = gf_load(filen)
% format of a cut data 
% Example
% % cut : H-cut
% % column : ai   af   tthf   intensity   err
% 0.2     0.5     0.2     1000        10
% ....
fid = fopen(filen, 'r');
%s = fgetl(fid);
tmpd.data = [];
tmpd.column = {};

while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    data = sscanf(tline, '%f');
    if isempty(data)
        [t, r] = strtok(tline, ':');
        t = strtrim(t(2:end));
        r = strtrim(r(2:end));
        switch t
            case 'column'
                while ~isempty(r)
                    [t, r] = strtok(r, ' ');
                    tmpd.column = [tmpd.column, strtrim(t)];
                end
            otherwise
                tmpd.(t) = r;
        end
    else
        tmpd.data = [tmpd.data;data'];
    end
end
        
fclose(fid);
if ~isempty(tmpd.column)
    for i=1:numel(tmpd.column)
        tmpd.(tmpd.column{i}) = tmpd.data(:,i);
    end
else
    % when the names of column are not defined.
    [x, y] = size(tmpd.data);
    if y == 5       % GISAXS
        tmpd.ai = tmpd.data(:,1);
        tmpd.af = tmpd.data(:,2);
        tmpd.tthf = tmpd.data(:,3);
        tmpd.intensity = tmpd.data(:,4);
        tmpd.err = tmpd.data(:,5);
        tmpd.column = {'ai', 'af','tthf','intensity','err'};
    elseif y==3     % SAXS
        tmpd.q = tmpd.data(:,1);
        tmpd.intensity = tmpd.data(:,2);
        tmpd.err = tmpd.data(:,3);
        tmpd.column = {'q','intensity','err'};
    end
end    
%tmpd = cell2struct(tmpd.data, tmpd.column, 2);
tmpd.fn = filen;