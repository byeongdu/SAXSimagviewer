function put_imgFigure(img, imgTitle)
global handles

try
    set(get(handles.axis_img, 'Children'), 'CData', img);
    if nargin == 2
        set(handles.imgFigure, 'Name', imgTitle);
    end
catch
    disp(lasterr);
end