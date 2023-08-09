function C = intens(img, posi)
% 이미지로 부터 주어진 position(정수가 아니라도)의 값을 읽는 함수
% 만일 정수가 아닌 index이면 linear interpolate해서 얻는다.
% function C = intens(img, position)
% 여기서 position은 좌표값.
%
% 그래프에서 X축은 column, Y축은 row...
% img(matrix)를 그림으로 그렸을때..
% X축은 column, Y축은 row
% 그림에서 좌표 (4, 3)은 그 matrix의 (3, 4)의 데이터에 해당함.
% 그러므로 여기서 posi위치의 값을 얻기 위해서는 X와 Y의 위치가
% 바뀌어야 함.
if numel(posi) == 2
    X = posi(1); % row
    Y = posi(2); % column

    X1 = fix(X);
    X2 = fix(X)+1;
    Y1 = fix(Y);
    Y2 = fix(Y)+1;

    if fix(X) == X
        X2 = X1;
    end

    if fix(Y) == Y
        Y2 = Y1;
    end

    try
    temp1 = [img(Y1, X1), img(Y1, X2)];
    temp2 = [img(Y2, X1), img(Y2, X2)];

    C = (((temp2(2)-temp1(2))*(Y-Y1)+temp1(2))-((temp2(1)-temp1(1))*(Y-Y1)+temp1(1)))*(X-X1)+((temp2(1)-temp1(1))*(Y-Y1)+temp1(1));
    catch
        C = 0;
    end
end
% old
%X = posi(1); % row
%Y = posi(2); % column

%if ((X == fix(X))&(Y== fix(Y)))
%   C = img(Y, X);
%elseif ((X == fix(X))&(Y ~= fix(Y)))
%   Y1 = fix(Y);
%   Y2 = fix(Y)+1;
%   temp(1) = img(Y1, X);
%   temp(2) = img(Y2, X);
   %a = polyfit((Y1:1:Y2), temp,1);
   %C = a(1)*Y+a(2);
%   C = spline([Y1 Y2], temp, Y);
%elseif ((X ~= fix(X))&(Y == fix(Y)))
%   X1 = fix(X);
%   X2 = fix(X)+1;
%   temp(1) = img(Y, X1);
%   temp(2) = img(Y, X2);
   %a = polyfit((X1:1:X2), temp,1);
   %C = a(1)*X+a(2);
%   C = spline([X1 X2], temp, X);
%elseif ((X ~= fix(X))&(Y ~= fix(Y)))
%   X1 = fix(X);
%   X2 = fix(X)+1;
%   Y1 = fix(Y);
%   Y2 = fix(Y)+1;
%   temp1(1) = img(Y1, X1);
%   temp1(2) = img(Y1, X2);
%   temp2(1) = img(Y2, X1);
%   temp2(2) = img(Y2, X2);
   %a1 = polyfit((fix(Y):1:(fix(Y)+1)), temp1,1);
   %a2 = polyfit((fix(Y):1:(fix(Y)+1)), temp2,1);
   %CC(1) = a1(1)*Y+a1(2);
   %CC(2) = a2(1)*Y + a2(2);
   %a3 = polyfit((fix(X):1:(fix(X)+1)), CC,1);
%   C = spline([X1 X2], [spline([Y1 Y2], temp1, Y), spline([Y1 Y2], temp2, Y)], X);
   %C = a3(1)*X + a3(2);
%end