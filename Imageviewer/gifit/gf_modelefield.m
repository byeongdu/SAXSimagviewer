function [E, af,z] = gf_modelefield(md, cut, ai, af)
% [E, af] = gf_modelefield(md, cut, ai, af)
m = cell2struct(md.layer(:,2), md.layer(:,1),1);
z = fix(-m.interface(end)*0.1):-1:fix(m.interface(end)+m.interface(end)*0.1);



%tic
%r0 = 2.82E-5;
%lambda = 12.576/m.xEng;
%s.eden = m.edensity;
%s.beta = m.beta;
%s.zin = m.interface(2:end);
%s.sig = m.roughness(2:end);
%[s, eden, beta, zin, sig] = slabProfile(s);
%eden = eden(:);beta = beta(:);
%zin = [zin(:);0];
%sig = [sig(:);0];
%d1 = 1/(2*pi)*r0*lambda^2*eden;
%b1 = beta;
%prof = [zin, d1, b1, sig, zeros(size(zin))];
%edp = edprofile(prof, numel(z));
%E = efield(af, edp, lambda);E = abs(E).^2;
%toc
%size(E)


if nargin == 3
    E = efieldcal_ang(ai, z, 12.576/m.xEng, m.edensity, m.beta, m.interface(2:end), m.roughness(2:end));
elseif nargin == 4
    E = efieldcal_ang(af, z, 12.576/m.xEng, m.edensity, m.beta, m.interface(2:end), m.roughness(2:end));%, af);
else
    af = cut(:,2);
    E = efieldcal_ang(af, z, 12.576/m.xEng, m.edensity, m.beta, m.interface(2:end), m.roughness(2:end));%, af);
end