function ang = angle2vect2(A, B)
% function calculating the angle between vector A to vector B in the counter clockwise.
% radian angle from A to B around the cross(A, B).
% counter clockwise in the left hand coordinate system.
% clockwise in the right hand coordinate system.

if size(A, 2) == 2
    x1 = A(:,1);
    x2 = B(:,1);
    y1 = A(:,2);
    y2 = B(:,2);
    ang = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi);
else
    ang = mod(atan2(sqrt(sum(cross(A, B, 2).^2,2)), dot(A, B, 2)), 2*pi);
end