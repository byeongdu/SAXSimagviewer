function theta = azimang(X, Y, Xc, Yc)
    %theta = atan2(X-Xc, Y-Yc)+pi/2;
    if nargin>2
        theta = pixel2pol(X-Xc, Y-Yc);
    else
        theta = pixel2pol(X, Y);
    end
end