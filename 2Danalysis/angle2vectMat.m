function interangle = angle2vectMat(qx, qy, qz, n)
% Function calculating the angle between two vector.
% this function is only between scattering vector matrix and cylinder
% direction vector...
%

qx = real(qx);qy=real(qy);qz=real(qz);
n = reshape(n, length(n), 1);
DotProd = qx*n(1) + qy*n(2) + qz*n(3);
Norm1 = sqrt(qx.^2 + qy.^2 + qz.^2);
Norm2 = norm(n);

% if Norm = 0, it is because vector q is 0...
% then it needs not to be normalized.
Norm1(find(Norm1 == 0)) = 1;
Norm2(find(Norm2 == 0)) = 1;

interangle = rad2deg(acos(DotProd./Norm1/Norm2));