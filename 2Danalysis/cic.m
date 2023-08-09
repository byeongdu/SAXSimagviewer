function data = cic(img, cent, waveln, psize, SDD, offset, mu)
%data = cic(img, cent, waveln, psize, SDD, offset, mu)
maxlimit = 2^20;
minlimit = 0;
isSectoravg = 0;
muNumber = numel(mu)/2;
isSectoravg = 0;
if (muNumber ~=0) isSectoravg = 1;end
isMask = 0;

img = img - offset;
[m, n] = size(img);

cent_Y = cent(1);
cent_X = cent(2);

edge(1) = fix(dist(m, n, cent_X, cent_Y));
edge(2) = fix(dist(1, n, cent_X, cent_Y));
edge(3) = fix(dist(m, 1, cent_X, cent_Y));
edge(4) = fix(dist(1, 1, cent_X, cent_Y));

maxl = max(edge);maxl = maxl(1)*2;
npx = zeros(maxl,1);
y = zeros(maxl,1);
y2 = zeros(maxl,1);

max_index =0;
count = 0;
index = 0;

for i = 1:n
     for j=1:m
         maskdata = 1;
         if (isSectoravg) 
             azim = azimang(i, j, cent_X, cent_Y);
             inSector = 0;
             for (mn=1:muNumber)
                 if ((azim >= mu(mn)) & (azim <= mu(muNumber+mn))) inSector = 1;end
             end
             if (inSector == 0) maskdata = 0;end
         end
         dt = img(j, i);
         isval = validatedata(maskdata, dt, maxlimit, minlimit);
         if isval
            index = floor(sqrt((i-cent_X)*(i-cent_X) + (j-cent_Y)*(j-cent_Y)) + 0.5)+1;
            y(index) = y(index) + dt;
            y2(index) = y2(index) + dt^2;
            npx(index) = npx(index) + 1;
            if (index > max_index)
                max_index = index;
            end
         end
    end
end

a = find(npx == 0);
npx(a) = [];
y(a) = [];
y2(a) = [];
%y = y./npx;
data = zeros(numel(y), 3);
for i=1:numel(y)
        data(i,1) = 4.0*pi/waveln*sin(1.0/2.0*atan((i-1)*psize/SDD));
        data(i,2) = y(i)/npx(i);
        data(i,3) = sqrt(y2(i))/npx(i);
end


    function z = dist(x1, y1, x2, y2)
        z = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
    end

    function retval = validatedata(mask, data, maxlimit, minlimit)
        retval = 0;
        if (mask > 0) if ((data > minlimit) & (data < maxlimit)) retval = 1;end;end
    end

end