function data = circularavgn(img, offset, bxy, Limit, mu, mask, Qoption, Qscale, waveln, psize, SDD, CCDradius)
% Limit is the intensity limit [high limit, low limit]
    isMask = 0;
    isSectoravg = 0;

    DEF_MAXL = 2^20;
    DEF_MINL = 0;
    edge = zeros(4,1);
    d = 0; k=0;
    
    [row, col] = size(img);
	if (numel(Limit) > 1) 
        maxlimit = max(Limit);
        minlimit = min(Limit);
    else
        maxlimit = DEF_MAXL;
        minlimit = DEF_MINL;
    end
    
    muNumber = numel(mu)/2;
    isSectoravg = 0;
    if (muNumber ~=0) isSectoravg = 1;end

	[rowmask, colmask] = size(mask);
    isMask = 0;
	if (rowmask > 0) 
	    if ((rowmask == row) & (colmask == col)) isMask = 1;
	    else printf('Error : Dimension of a mask is different from that of data\n');end
    end
    
    if (numel(bxy) >1) 
        cent_X = bxy(1);
        cent_Y = bxy(2);
    else
        printf('Error : Wrong beam centers, will be set [1,1]\n');
        cent_X = 1.0;
        cent_Y = 1.0;
    end
    
    edge(1) = fix(dist(row, col, cent_X, cent_Y));
    edge(2) = fix(dist(1, col, cent_X, cent_Y));
    edge(3) = fix(dist(row, 1, cent_X, cent_Y));
    edge(4) = fix(dist(1, 1, cent_X, cent_Y));
    
    
    for k=1:4
        if (d<edge(k))
            d = edge(k);
        end
        d = d-1;
    end
    % output matrix generation =============================
    if (Qoption) 
        qmax = Qscale(1);
        qN = Qscale(2);
        MAXSIZE = qN;
    else 
        qmax = 0.0;
        qN = 0.0;
        MAXSIZE = d+1;
    end

    if (CCDradius < 1) CCDradius = d;end
    
    data = zeros(MAXSIZE, 5);
    qv = zeros(MAXSIZE, 1);
    avg = qv; avg2 = qv; npx = qv;
    maxlimit
    for i = 1:row
        for j = 1:col
            indimg = i*row+j;
            imgv = img(indimg);
            isvalid = 1;
            if (isMask) 
                maskdata = mask(indimg);
            else maskdata = 1;end

            if (isSectoravg) 
                azim = azimang(i, j, cent_X, cent_Y);
                inSector = 0;
                for (m=1:muNumber)
                    if ((azim >= mu(m)) & (azim <= mu(muNumber+m))) inSector = 1;end
                end
                if (inSector == 0) maskdata = 0;end
            end
            isvalid = validatedata(maskdata, imgv, maxlimit, minlimit);
            isvalid = isvalid * inMarcircle(row, col, CCDradius, i, j);
            if (isvalid) 
                dx2 = (i - cent_X)*(i - cent_X);
                dy2 = (j - cent_Y)*(j - cent_Y);
                r2 = floor(sqrt(dx2 + dy2) +0.5);
                qval = 4.0*pi/waveln*sin(1.0/2.0*atan(r2*psize/SDD));
                if (Qoption) 
                    r2 = floor(qval/qmax*MAXSIZE);
                    qval = (r2+0.5)*(qmax/MAXSIZE);
                end
                if (r2 >= 0 && r2 < MAXSIZE) 
                    qv(r2) = qval;
                    avg(r2) = avg(r2)+ imgv - offset;
                    avg2(r2) = avg2(r2) + (imgv-offset)*(imgv-offset);
                    npx(r2) = npx(r2) + 1.0;
                end
            end
        end
    end

    for (i=1:MAXSIZE)
    	data(i,1) = qv(i);
        data(i,2) = avg(i)/npx(i);
        data(i,3) = sqrt(avg(i))/npx(i);
        data(i,4) = avg(i);
        data(i,5) = npx(i);
    end
end


function z = dist(x1, y1, x2, y2)
    z = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
end

function theta = azimang(X, Y, Xc, Yc)
    theta = 0;
    dx = X-Xc;
    dy = Y-Yc;
    if (dx>0) 
        if (dy >= 0) theta = atan(dy/dx)*180/pi;end
        if (dy < 0) theta = 360 + atan(dy/dx)*180/pi;end
    end
    if (dx<0) theta = atan(dy/dx)*180/pi + 180;end
    if (dx == 0) 
        if (dy > 0)	theta = 90;end
        if (dy <= 0) theta = 270;end
    end
end

function retval = inMarcircle(dimx, dimy, R, X, Y)
    retval = 1;
    R1 = 0.0;
    R1 = sqrt((dimx/2.0-X)*(dimx/2.0-X) + (dimy/2.0-Y)*(dimy/2.0-Y));
    if (R1 > R) retval = 0;end
end

function retval = validatedata(mask, data, maxlimit, minlimit)

    retval = 0;
    if (mask > 0) if ((data > minlimit) & (data < maxlimit)) retval = 1;end;end
end

