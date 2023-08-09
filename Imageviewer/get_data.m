function Data = get_data
handle_lines = get(gca, 'Children');
number_line = length(handle_lines);
tempLine = get(handle_lines);
Data = cell(3, number_line);
    
for i = 1:number_line
    Data{1, i} = tempLine(i).XData';
    Data{2, i} = tempLine(i).YData';
    Data{3, i} = get(handle_lines, 'userdata');
end
