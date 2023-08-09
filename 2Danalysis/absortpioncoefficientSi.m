function nu = absortpioncoefficientSi(Xenergy)
% function nu_medium = absortpioncoefficientSi(Xenergy)
% Xenergy : X-ray energy in keV
% nu : linear absorption coefficient of Si in cm-1.


% mass attenuation coefficient, nu/rho of Si.
% Data from http://www.physics.nist.gov/PhysRefData/XrayMassCoef/ElemTab/z14.html
% Energy (MeV), the mass attenuation coefficient, ?/?, and the mass energy-absorption coefficient, ?en/?
Tab = [
1.00000E-03  1.570E+03  1.567E+03 
   1.50000E-03  5.355E+02  5.331E+02 
   1.83890E-03  3.092E+02  3.070E+02 
   1.83890E-03  3.192E+03  3.059E+03 
   2.00000E-03  2.777E+03  2.669E+03 
   3.00000E-03  9.784E+02  9.516E+02 
   4.00000E-03  4.529E+02  4.427E+02 
   5.00000E-03  2.450E+02  2.400E+02 
   6.00000E-03  1.470E+02  1.439E+02 
   8.00000E-03  6.468E+01  6.313E+01 
   1.00000E-02  3.389E+01  3.289E+01 
   1.50000E-02  1.034E+01  9.794E+00 
   2.00000E-02  4.464E+00  4.076E+00 
   3.00000E-02  1.436E+00  1.164E+00 
   4.00000E-02  7.012E-01  4.782E-01 
   5.00000E-02  4.385E-01  2.430E-01 
   6.00000E-02  3.207E-01  1.434E-01 
   8.00000E-02  2.228E-01  6.896E-02 
   1.00000E-01  1.835E-01  4.513E-02 
   1.50000E-01  1.448E-01  3.086E-02 
   2.00000E-01  1.275E-01  2.905E-02 
   3.00000E-01  1.082E-01  2.932E-02 
   4.00000E-01  9.614E-02  2.968E-02 
   5.00000E-01  8.748E-02  2.971E-02 
   6.00000E-01  8.077E-02  2.951E-02 
   8.00000E-01  7.082E-02  2.875E-02 
   1.00000E+00  6.361E-02  2.778E-02 
   1.25000E+00  5.688E-02  2.652E-02 
   1.50000E+00  5.183E-02  2.535E-02 
   2.00000E+00  4.480E-02  2.345E-02 
   3.00000E+00  3.678E-02  2.101E-02 
   4.00000E+00  3.240E-02  1.963E-02 
   5.00000E+00  2.967E-02  1.878E-02 
   6.00000E+00  2.788E-02  1.827E-02 
   8.00000E+00  2.574E-02  1.773E-02 
   1.00000E+01  2.462E-02  1.753E-02 
   1.50000E+01  2.352E-02  1.746E-02 
   2.00000E+01  2.338E-02  1.757E-02];
% Density of air
d = 2.3290; % g/cm3 at RT;
Tab(:,1) = Tab(:,1)*1000; %MeV to keV;
[~, ind] = min(abs(Tab(:,1)-Xenergy));
nu = interp1(Tab(ind-1:ind+1,1), Tab(ind-1:ind+1,2), Xenergy);
nu = nu*d;