function nu_medium = absortpioncoefficientSi(Xenergy)
% function nu_medium = absortpioncoefficientAir(Xenergy)
% Xenergy : X-ray energy in keV
% nu_medium : linear absorption coefficient of air at 25C


% mass attenuation coefficient, nu/rho of dry air.
% Data from http://physics.nist.gov/PhysRefData/XrayMassCoef/ComTab/air.html
% Energy (MeV), the mass attenuation coefficient, ?/?, and the mass energy-absorption coefficient, ?en/?
Tab = [
1.00000E-03  3.606E+03  3.599E+03 
1.50000E-03  1.191E+03  1.188E+03 
2.00000E-03  5.279E+02  5.262E+02 
3.00000E-03  1.625E+02  1.614E+02 
3.20290E-03  1.340E+02  1.330E+02 
3.20290E-03  1.485E+02  1.460E+02 
4.00000E-03  7.788E+01  7.636E+01 
5.00000E-03  4.027E+01  3.931E+01 
6.00000E-03  2.341E+01  2.270E+01 
8.00000E-03  9.921E+00  9.446E+00 
1.00000E-02  5.120E+00  4.742E+00 
1.50000E-02  1.614E+00  1.334E+00 
2.00000E-02  7.779E-01  5.389E-01 
3.00000E-02  3.538E-01  1.537E-01 
4.00000E-02  2.485E-01  6.833E-02 
5.00000E-02  2.080E-01  4.098E-02 
6.00000E-02  1.875E-01  3.041E-02 
8.00000E-02  1.662E-01  2.407E-02 
1.00000E-01  1.541E-01  2.325E-02 
1.50000E-01  1.356E-01  2.496E-02 
2.00000E-01  1.233E-01  2.672E-02 
3.00000E-01  1.067E-01  2.872E-02 
4.00000E-01  9.549E-02  2.949E-02 
5.00000E-01  8.712E-02  2.966E-02 
6.00000E-01  8.055E-02  2.953E-02 
8.00000E-01  7.074E-02  2.882E-02 
1.00000E+00  6.358E-02  2.789E-02 
1.25000E+00  5.687E-02  2.666E-02 
1.50000E+00  5.175E-02  2.547E-02 
2.00000E+00  4.447E-02  2.345E-02 
3.00000E+00  3.581E-02  2.057E-02 
4.00000E+00  3.079E-02  1.870E-02 
5.00000E+00  2.751E-02  1.740E-02 
6.00000E+00  2.522E-02  1.647E-02 
8.00000E+00  2.225E-02  1.525E-02 
1.00000E+01  2.045E-02  1.450E-02 
1.50000E+01  1.810E-02  1.353E-02 
2.00000E+01  1.705E-02  1.311E-02];
% Density of air
d = 0.0011839; % g/cm3 at 25oC;
Tab(:,1) = Tab(:,1)*1000; %MeV to keV;
[~, ind] = min(abs(Tab(:,1)-Xenergy));
nu_medium = interp1(Tab(ind-1:ind+1,1), Tab(ind-1:ind+1,2), Xenergy);
nu_medium = nu_medium*d;