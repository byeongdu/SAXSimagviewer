function y=gauss_dq_dth(x,y,z,p)
% using 2D gaussian function 
% p = [area, x0, y0, z0, dr_breadth, dth_breadth];
%
% Author: B. Lee
% Description:  Gaussian
% when p(1) =1, the area should be 1.
pcx = p(2);pcy = p(3);pcz = p(4);
c = [pcx, pcy, pcz];
%[TH,PHI,R] = cart2sph(x,y,z);
peakv = real(c);
inputv = [x, y, z];
dq = abs(norm(peakv)-sqrt(inputv(:,1).^2+inputv(:,2).^2+inputv(:,3).^2));
%dang = angle2vect2(peakv, inputv);
dang = anglePoints3d(repmat(peakv, numel(x), 1), inputv);
dang = real(dang);
y = gauss2d(dq, dang, [p(1), 0, 0, p(5), p(6), 0]);