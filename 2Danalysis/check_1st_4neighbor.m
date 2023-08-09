function isedge = check_1st_4neighbor(row, col, masked, sig, maxrow, maxcol)
    isedge = [0,0,0,0];
    minrow = 1;
    mincol = 1;
    neghx = [-1, 0; 0, 1; 0, -1; 1, 0];
    %isedge = 0;
    n0v = masked(row, col);
    for l = 1:4
        %isedge = 0;
        n1r = row + neghx(l, 1);
        n1c = col + neghx(l, 2);
        if (n1r>maxrow) || (n1r<minrow) || (n1c>maxcol) || (n1c<mincol)
            n1v = 0;
        else
            n1v = masked(n1r, n1c);
        end
        if n1v > (sig + n0v) 
            % If one of its first neighbor is larger than its value, it is
            % the edge of mask.
            isedge(l) = 1;
        end
    end
    