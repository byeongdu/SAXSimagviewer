function w = rotatevector(theta, phi, v)
% R = rotatevector(theta, phi, v)
% rotatevector.m will rotate vector v.
% rotation matrix is one to rotate [0,0,1] in cartesian coordinate to
% vector u (theta, phi, 1) in spherical coordinate.
% input vector v is assumed to be row vector. ex) [1,1,1];
%
% Byeongdu Lee
n = [0, 0, 1];
[x, y, z] = sph2cart(theta*pi/180, phi*pi/180, 1);
u = [x,y, z];n=n(:)';

t = cross(n,u);

%Then define the angle of rotation as:

a = atan2(norm(t),dot(n,u))*180/pi;

%which will range from 0 to pi.

%  Then unit vector t0 and angle a uniquely characterize the desired rotation of 
%any arbitrary vector v to a vector w as follows:

% vc = cross(v,t0);
% w = dot(v,t0)*t0 + cos(a)*cross(t0,vc) + sin(a)*vc;
[sizex, sizey] = size(v);
[w, R] = eulerRot2(n, t, a);
if numel(v) < 3
    error('input should be a vector');
    return
end
if sizex == 3
    v = v';
end
w = v*R;
    
