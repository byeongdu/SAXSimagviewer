function [R, crossv, ang] = rotate_between_vectors(A, B)
% R = rotate_between_vectors(v1, v2)
% Obtain the rotation matrix that will bring v2 to v1;
% Rotation axis = v2 x v1;
%
% Byeongdu Lee
crossv = cross(B, A);
if norm(crossv) == 0
    if dot(A, B, 2) > 0
        ang = 0;
        R = eye(3);
    elseif dot(A, B, 2) < 0
        ang = pi;
        R = eye(3);
        R(3,3) = -1;
    end
else
    %ang = acos(dot(A, B, 2)/norm(A)/norm(B));
    ang = angle2vect2(A, B);
    [~, R] = rotate_around_vector(B, crossv, ang*180/pi);
end
