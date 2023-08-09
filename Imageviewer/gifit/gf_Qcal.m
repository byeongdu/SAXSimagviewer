function cut = gf_Qcal(cut, model, n)
% function cut = gf_Qcal(cut, model, n)
% here, n is the number of layer to 
% n should be 1, 2, 3... 1 means air, 2 does film, 3 does substrate.
if nargin < 3
    n=1;
end

md = gf_model(model, 'cell2struct', 'layer');md = md.layer;
ai = cut.ai;
af = cut.af;
%tthi = 0;
tth = cut.tthf;
if isfield(cut, 'waveln');
    lambda = str2double(sprintf('%s', cut.waveln));
else
    lambda = eng2wl(md.xEng);
end    
%model.particle{n}.layer, lambda, md.edensity, md.beta, md.interface(2:end), md.roughness(2:end);
[Ti, Tf, Ri, Rf, kiz, kfz] = GISAXS_wave_Amp_Vector(ai, af, model.particle{n}.layer, lambda, md.edensity, md.beta, md.interface(2:end), md.roughness(2:end));
k0 = 2*pi/lambda;
kix = k0.*(cos(deg2rad(ai)));
kiy = k0.*(cos(deg2rad(tth))); 
kfx = k0.*(cos(deg2rad(tth)).*cos(deg2rad(af)));
kfy = k0.*(sin(deg2rad(tth)).*cos(deg2rad(af)));
qx = kfx - kix;
qy = kfy - kiy;
qpa = 4*pi/lambda*sin(tth/2*pi/180);
kiz = kiz(:);
kfz = kfz(:);
Ti = Ti(:);
Tf = Tf(:);
Ri = Ri(:);
Rf = Rf(:);
q1z = kfz-kiz;q2z = -kfz-kiz;q3z = kfz+kiz;q4z = -kfz+kiz;
cut.qpa = qpa;
cut.qx = (qx);
cut.qy = (qy);
cut.q1z = (q1z);
cut.q2z = (q2z);
cut.q3z = (q3z);
cut.q4z = (q4z);
cut.Ti = Ti;
cut.Tf = Tf;
cut.Ri = Ri;
cut.Rf = Rf;
cut.kiz = kiz;
cut.kfz = kfz;
cut.q = sqrt(qpa(:).^2 + q1z(:).^2);
fields = {'qpa', 'qx', 'qy', 'q1z', 'q2z', 'q3z', 'q4z', 'Ti', 'Tf', 'Ri', 'Rf', 'kiz', 'kfz', 'q'};
cut.column = [cut.column, fields];
[tmp, i] = unique(cut.column);
cut.column = cut.column(sort(i));