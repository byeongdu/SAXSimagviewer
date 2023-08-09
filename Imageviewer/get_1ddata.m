function Data = get_1ddata
% 출력은 cell format으로 출력한다.
% cell format 인 Data로 부터 vector format으로 데이터를 추출하려면
% [a, b, c, d ... ] = deal(Data{:}) 와 같은 command를 사용하야한다.

handle_lines = get(get(findobj('Tag', '1D_Data_Display'), 'Children'), 'Children');
number_line = length(handle_lines);
tempLine = get(handle_lines);
Data = cell(2, number_line);
    
for i = 1:number_line
    Data{1, i} = tempLine(i).XData';
    Data{2, i} = tempLine(i).YData';
end
