function t = isLaue(kf, k0, tol)
% t = isLaue(kf, k0, tol)
% t = isLaue(qv, ki, tol)
% t = isLaue([qp, qz], ki, tol)
if nargin<3
    tol = 0.001;
end
if size(k0, 2) == 3
    ki = k0;
    qv = kf;

    k0 = sqrt(sum(ki.^2, 2));
    if size(qv, 2)>2
        kf = qv+ki;
    else % [qp, qz]
        qz = qv(:,2);
        qxy = qv(:,1);
        qx = -1*(qxy.^2+qz.^2)/(2*k0);
        sgn = sign(qv(:, 1));
        sgn(sgn==0) = 1;
        qy = sgn.*sqrt(qxy.^2-qx.^2);
        t = imag(qy)<0.00001;
        return
    end
end
    
if ~isempty(k0)
    lkf = sqrt(sum(kf.^2, 2));
    t = lkf-k0 < tol;
end

