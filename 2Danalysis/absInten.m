function R = absInten(Data, IC1, Iempty, IC2, Tsample, Tempty, tsample, Fabs, IC)
% absInten(Data, IC1, Iempty, Idc,Tsample,Tempty, tsample, Fabs, IC)
%
% Data : dark current subtracted intensity
% IC1 : Incident X-ray flux when sample measured => IC current before sample
% Iempty : dark current subtracted empty cell Intensity
% IC2 : indicent X-ray flux when empty cell measured => IC current before sample
% Tsample : Transmittance of sample + cell
% Tempty : Transmittnace of empty cell
% t : thickness of sample
% IC : incident X-ray flux when Standard measured => IC current before sample
% Fabs : absolute intensity conversion factor derived from standards
%          = t_standard * T_standard * I_standard(q = 0.0227A) / I_measured_standard_at_given_geometry(q = 0.0227A)
%          where, t_standard = 1.88
%                     T_standard = 0.524 at wavelength(?) ~ 0.424 at 1.608A
%                     I_standard(q = 0.0227A) = 36.25cm^-1
% cf) How to obtain I_measured_standard_at_given_geometry.
%       I_measured_standard_at_given_geometry(q) = Iobs(q) - T_standard/T_empty*I_empty(q)
%

R = (Data./IC1 - Tsample./Tempty.*Iempty./IC2)./(Tsample.*tsample)*Fabs*IC;