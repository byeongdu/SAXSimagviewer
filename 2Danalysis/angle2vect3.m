function ang = angle2vect3(A, B)
% radian angle from A to B around the cross(A, B).
% clock-wise in the left hand coordinate system.
% counter-clockwise in the right hand coordinate system.

k = cross(A, B);
A2 = rotate_around_vector(A, k, 90);
ang = angle2vect2(A, B);
if dot(A2, B) < 0 % if negative, B is left of A.
    ang = ang;
else
    ang = -ang;
end
ang = ang;
