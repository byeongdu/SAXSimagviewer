function [Amp, RGBdata] = imAmpRGB(FFTed)
% FFTed is fourier transformed 2-dimensional image.
% so, it is complex 2-dimensional matrix;
Amp = abs(FFTed);
%maxAmp = max(max(Amp));
minAmp = min(min(Amp));
Phase = rad2deg(angle(FFTed));
[m, n] = size(FFTed);
RGBdata = zeros(m,n,3);

PhaseR = Phase;

a = abs(Phase) >= 60;
b = find(abs(Phase) < 60);
PhaseR(a) = 1;
PhaseR(b) = abs((abs(Phase(b))-60)/60);

PhaseG = Phase-120;

a = abs(PhaseG) >= 60;
b = find(abs(PhaseG) < 60);
PhaseG(a) = 1;
PhaseG(b) = abs((abs(PhaseG(b))-60)/60);

PhaseB = Phase+120;

a = abs(PhaseB) >= 60;
b = find(abs(PhaseB) < 60);
PhaseB(a) = 1;
PhaseB(b) = abs((abs(PhaseB(b))-60)/60);



RGBdata(:, :, 1) = PhaseR;
RGBdata(:, :, 2) = PhaseG;
RGBdata(:, :, 3) = PhaseB;

RGBdata(:, :, 1) = PhaseR./Amp*minAmp;
RGBdata(:, :, 2) = PhaseG./Amp*minAmp;
RGBdata(:, :, 3) = PhaseB./Amp*minAmp;