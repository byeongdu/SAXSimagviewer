function [edger, edgec] = maskedgefinder(maskrow, maskcol, masked, sig)
masksize = size(masked);

if nargin < 4
    indn = sub2ind(masksize, maskrow, maskcol);
    tmask = masked;
    tmask(indn) = [];
    sig = std(tmask(:))*3;
end

%sig = 6;
edger = [];
edgec = [];
edgecount = 1;
maxrow = masksize(1);
maxcol = masksize(2);
minrow = 1;
mincol = 1;
neghx = [-1, 0; 0, 1; 0, -1; 1, 0];
for i=1:numel(maskrow)
    row = maskrow(i);
    col = maskcol(i);
    % first 4 neighbors
    n1 = check_1st_4neighbor(row, col, masked, sig, maxrow, maxcol);
    for l=1:4
        if n1(l) == 0
            continue
        end
        nrow = row+neghx(l, 1);
        ncol = col+neghx(l, 2);
        n2 = check_1st_4neighbor(nrow, ncol, masked, sig, maxrow, maxcol);
        if sum(n2) > 0
            edger(edgecount) = nrow;
            edgec(edgecount) = ncol;
            edgecount = edgecount + 1;
        end
    end
    if mod(i, 100000)==0
       fprintf('....Currently processing ... %i/%i done\n', i, numel(maskrow)) 
    end
end