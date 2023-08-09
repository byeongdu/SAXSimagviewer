    b = findobj('Tag', 'axis_img');
    axes(b);
    [sizeX, sizeY] = size(img);pX=1:sizeX;pY=1:sizeY;[pX, pY]= meshgrid(pY, pX);

    center = handles.center;
    ai = handles.hai;
    SDD = handles.hSDD;
    pixelsize = handles.hpixel_size;

    thf = rad2deg(atan((pX - center(1))./SDD*pixelsize));
    af = rad2deg(atan((-pY + center(2))./sqrt((SDD/pixelsize)^2 + (pX-center(1)).^2))) - ai;
    [qx, qy, qz] = angle2vq2(ai, af, 0, thf);
    qxy = sqrt