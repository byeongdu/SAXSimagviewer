function A = criticalang(edensity, wavelength)
% enter all the parameter in Angstrom scale.
% function A = criticalang(edensity, wavelength)
A = rad2deg(sqrt(2.818E-5/pi*edensity)*wavelength);

function rtn = rad2deg(ang)
rtn = ang*180/pi;
