function [x, y]= circularc(img, cent)

[m, n] = size(img);
x = zeros(m*2,1);
y = zeros(m*2,1);

cent_Y = cent(2);
cent_X = cent(1);
max_index =0;
count = 0;
index = 0;

for i = 1:n
     for j=1:m
                index = floor(sqrt((i-cent_X)*(i-cent_X) + (j-cent_Y)*(j-cent_Y)) + 0.5)+1;
                y(index) = y(index) + img(j, i);
                x(index) = x(index) + 1;
                if (index > max_index)
                        max_index = index;
               end
    end
end

a = find(x == 0);
x(a) = [];
y(a) = [];

y = y./x;
x = 0:(length(y)-1);