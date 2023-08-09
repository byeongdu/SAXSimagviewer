function [ImgHandle, saxs] = gishow(img, saxs)
if nargin < 2
    saxs = [];
end

if isfield(saxs, 'imgfigurehandle')
    ImgFigHandle = saxs.imgfigurehandle;
    if isfield(saxs, 'imgaxeshandle')
        if isfield(saxs, 'imghandle')
%            k = get(saxs.imgfigurehandle, 'children')
%            cbar = findobj(k, 'tag', 'colorbar');
%            set(cbar, 'xaxisdirection', setv)
            if ~ishandle(saxs.imghandle)
                ImgHandle = imagesc(img, 'parent', saxs.imgaxeshandle);
            else
%                set(saxs.imghandle, 'cdata', img);
                ImgHandle = saxs.imghandle;
            end
        else
            ImgHandle = imagesc(img, 'parent', saxs.imgaxeshandle);
        end
    end
else
    ImgFigHandle = findobj('tag', 'SAXSImageViewer');
    if isempty(ImgFigHandle)
        ImgFigHandle = figure;
        set(ImgFigHandle, 'Tag', 'SAXSImageViewer');
    end
    imgh = findobj(ImgFigHandle, 'tag', 'ImageAxes');
    if ~isempty(imgh)
        saxs.imgaxeshandle = imgh;
        ImgHandle = imagesc(img, 'parent', imgh);
    else
        if isfield(saxs, 'imgxaxis')
            ImgHandle = image(saxs.imgxaxis, saxs.imgyaxis, img, 'parent', ImgFigHandle);
            axis xy;
        else
            ImgHandle = image(img);
        end
        saxs.imgaxeshandle = get(ImgHandle, 'parent');
    end
end


%axis image;
axisHandle = get(ImgHandle, 'parent');
title(saxs.imgname, 'parent', axisHandle, 'interpreter' , 'none');
set(ImgHandle, 'CdataMapping', 'scaled');
set(axisHandle, 'FontName', 'Verdana');
set(axisHandle, 'FontSize', 14);
set(axisHandle, 'Tickdir', 'out');
set(axisHandle, 'xcolor', [0 0 0]);
set(axisHandle, 'ycolor', [0 0 0]);

saxs.imgfigurehandle = ImgFigHandle;
saxs.imghandle = ImgHandle;
setgihandle(saxs)