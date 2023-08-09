function R = dezinger2D(R1, R2)
sizR = size(R1);
R1 = reshape(R1, [numel(R1), 1]);
R2 = reshape(R2, [numel(R2), 1]);

R = (R1+R2)/2;
dif = abs(R2-R1)./R;
mm = find((R1 <= 0) | (R2 <= 0));
dif(mm) = 0;
kk = find(dif > 0.3);
v1 = R1(kk);
v2 = R2(kk);
v = [v1, v2];
kkv = min(v, [], 2);
R(kk) = kkv;
R = reshape(R, sizR);