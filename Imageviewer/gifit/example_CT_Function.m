function y = example_CT_Function(particle, cut, varargin)
%err = [chi2, y] = example_CT_Function(model, P, cut, plot_handle,
%text_handle)
% P is number of fitting parameters
%
%Calculates the sum of squared error between y and the predicted function,
%which is the sum of a sinusoid and a 2nd order polynomial.  
%
%The predicted function is defined by  the 2 parameters for the sinuosoid 
%('amp' and 'freq') and 3 parameters for the 2nd order polynomial 
%(poly(1),poly(2), and poly(3)).
%
%This is the required format for a function to be minimized by 'fit.m':
%
%1) All model parameters must be fields of the first input parameter (p)
%2) The first output parameter must be the error value to be minimized 
%
%Written by G.M Boynton, September 12,2005
y = 0;

yfq = feval(particle.Fq.name, particle.Fq.param, cut, varargin);
ysq = feval(particle.Sq.name, particle.Sq.param, cut, varargin);
y = yfq(:).*ysq(:);

