function [PowSpec, xaxis, yaxis] = PowerSpec(x, M, N)
% In this subrountine, log square modulus of the Fourier transform is made,
% Input: images needs transform...    (sourcefile)
% Output: the logarithim of the power spectrum of the image above (sourcefile)+'_out.jpg'
%
% xaxis becomes qx = 2*pi/dsp_x;
% yaxis becomes qy = 2*pi/dsp_y;
%
% convert to grayscale if necessary
if (exist('isgray')== 2)
    if (~isgray(x))
        if (isrgb(x))hep
            x = rgb2gray(x);
        end
    end
end

% calculate power spectrum of image
%PowSpec = log(abs(fftshift(fft2(x)))).^2;
if nargin < 2
    [M, N] = size(x);
end
[row, col] = size(x);
dx = row/M;
dy = col/N;

PowSpec = abs(fftshift(fft2(x, M, N))).^2;
PowSpec(find(PowSpec == inf))= 0;
xaxis = linspace(-M/2,M/2,M)'*dx/M/(2*pi); % xaxis becomes qx = 2*pi/dsp_x;
yaxis = linspace(-N/2,N/2,N)'*dy/N/(2*pi); % yaxis becomes qy = 2*pi/dsp_y;
