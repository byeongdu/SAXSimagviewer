function [N, lambda_theta, lambda_phi, lambda_psi] = eulerRot(n, angle)
% function N = eulerRot(n, angle)
% angle = [theta, phi, psi]
% Euler rotation   : Figure is showin in Hashimoto paper(Macromolecules,
% 27, 11, 1994, 3063...........
%
[nx, ny] = size(n);
if numel(n) > 3
    if (ny ~= 3)
        if (nx == 3)
            n = n';
        else
            error('dimension of n is wrong')
        end
    elseif (ny == 3)
        n = n;
    end
    n = reshape(n, 3, nx*ny/3);
else
    n = n(:);
end
 
theta = double(angle(1)*pi/180);
phi = double(angle(2)*pi/180);
psi = double(angle(3)*pi/180);

lambda_theta = [cos(theta), 0, sin(theta)
    0, 1, 0,
    -1*sin(theta), 0, cos(theta)];%lambda_theta=inv(lambda_theta);
lambda_phi = [cos(phi), -sin(phi), 0
    sin(phi), cos(phi), 0,
    0, 0, 1];%lambda_phi=inv(lambda_phi);
lambda_psi = [cos(psi), -sin(psi), 0
    sin(psi), cos(psi), 0,
    0, 0, 1];%lambda_psi=inv(lambda_psi);

lambda = lambda_phi*lambda_theta*lambda_psi;
N = lambda*n;N = fix(N*1E10)/1E10;