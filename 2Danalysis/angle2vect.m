function ang = angle2vect(A, B)
% function calculating the angle between two vector.
% return in radian
sA = size(A,1);
sB = size(B,1);
if (sA == 1) & (sB) == 1
A = A/norm(A);
B = B/norm(B);
U = A;
V = B;
[Q, R] = qr([U', V'], 0);
Q2 = Q(:,2)'; 
Q1 = Q(:,1)'; 
angle=@(v) atan2(dot(Q2,v),dot(Q1,v));
ang = mod(angle(V),2*pi);
    return
elseif (sA ==1) & (sB>1)
    nA = norm(A);
    A = repmat(A, [sB, 1]);
    nA = repmat(nA, [sB, 1]);
    nB = sqrt(B(:,1).^2+B(:,2).^2+B(:,3).^2);
elseif (sA > 1) & (sB ==1)
    nB = norm(B);
    B = repmat(B, [sA, 1]);
    nB = repmat(nB, [sA, 1]);
    nA = sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2);
elseif (sA == sB) & (sA > 1)
    nA = sqrt(A(:,1).^2+A(:,2).^2+A(:,3).^2);
    nB = sqrt(B(:,1).^2+B(:,2).^2+B(:,3).^2);
end
%A = A./repmat(nA, [1,3]);
%B = B./repmat(nB, [1,3]);
%C = cross(A, B);
%t = C<0;
val = dot(A, B, 2)./nA./nB;
val(val<-1) = -1;
val(val>1) = 1;
ang = acos(val);
%ang(t) = 2*pi-ang(t);