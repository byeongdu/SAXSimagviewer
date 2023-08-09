function C = intens_m(img, posi)

% 이미지로 부터 주어진 position(정수가 아니라도)의 값을 읽는 함수
% 만일 정수가 아닌 index이면 linear interpolate해서 얻는다.
% function C = intens(img, position)
C = zeros(360,1);

k = find((posi(:,1)==fix(posi(:,1)))&(posi(:,2)==fix(posi(:,2))));
% posi는 두 컬럼 데이터, 그 중 row의 index를 return.

for i=1:length(k)
C(k(i)) = img(posi(k(i),1), posi(k(i),2));
end

l = find((posi(:,1)~=fix(posi(:,1)))&(posi(:,2)==fix(posi(:,2))));
for i=1:length(l)
Y1 = fix(posi(l(i),1));
Y2 = fix(posi(l(i),1))+1;
temp(1) = img(Y1, posi(l(i),2));
temp(2) = img(Y2, posi(l(i),2));
a = polyfit((Y1:1:Y2), temp,1);
C(l(i)) = a(1)*posi(l(i),1)+a(2);
end

m = find((posi(:,1)==fix(posi(:,1)))&(posi(:,2)~=fix(posi(:,2))));
for i=1:length(m)
X1 = fix(posi(m(i),2));
X2 = fix(posi(m(i),2))+1;
temp(1) = img(posi(m(i),1), X1);
temp(2) = img(posi(m(i),1), X2);
a = polyfit((X1:1:X2), temp,1);
C(m(i)) = a(1)*posi(l(i),2)+a(2);
end

n = find((posi(:,1)~=fix(posi(:,1)))&(posi(:,2)~=fix(posi(:,2))));
for i=1:length(n)
X1 = fix(posi(n(i),2));
X2 = fix(posi(n(i),2))+1;
Y1 = fix(posi(n(i),1));
Y2 = fix(posi(n(i),1))+1;
temp1(1) = img(Y1, X1);
temp1(2) = img(Y1, X2);
temp2(1) = img(Y2, X1);
temp2(2) = img(Y2, X2);
a1 = polyfit((fix(posi(n(i),1)):1:(fix(posi(n(i),1))+1)), temp1,1);
a2 = polyfit((fix(posi(n(i),1)):1:(fix(posi(n(i),1))+1)), temp2,1);
CC(1) = a1(1)*posi(n(i),1)+a1(2);
CC(2) = a2(1)*posi(n(i),1) + a2(2);
a3 = polyfit((fix(posi(n(i),2)):1:(fix(posi(n(i),2))+1)), CC,1);
C(n(i)) = a3(1)*posi(n(i),2) + a3(2);
end
