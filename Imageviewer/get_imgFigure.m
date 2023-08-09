function img = get_imgFigure(han)
if nargin < 1
    han = gcf;
end
if isempty(han)
    han = gcf;
end
%t = get(get(han, 'Children'), 'Children')
%t{1}
t=findobj(han, '-property', 'CData', '-and', 'type', 'image');
img = get(t(end), 'CData');
if isempty(img)
    error('Image Figure should be on top!!!!!')
end
