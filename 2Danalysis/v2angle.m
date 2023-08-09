function [tthf, af] = v2angle(v1, v2, v3)
% Calculate the polar angles for a vector from [0,0,0] to [v1, v2, v3]
% Return angles in radian.
% The angles above are different from tthf and af defined in x-ray
% scattering. Be careful that these angles are different from tthf and af
% used in the x-ray diffraction.
% see pixel2angles.m for x-ray diffraction.
tthf = atan(v2./v1);
af = atan(v3./sqrt(v1.^2+v2.^2));
