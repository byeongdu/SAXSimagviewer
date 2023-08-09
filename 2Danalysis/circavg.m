function y = circavg(image, waveln, psize, SDD, Bp, offset, Qoption, Qscale, Limit, mu, mask, CCDradius, dezinger, dezingertimes)
% data = circavg(image, waveln, psize, SDD, Bp, offset, Qoption, Qscale, Limit, mu, mask, CCDradius, dezinger, dezingertimes)
% example: circavg(image, waveln,psize,center,offset,[],[],[],[],mask)
% Bp = [Beamx, Beamy]
% Qoption = 0 for pixel based, 1 for Q based
% Limit = [High L, Low L]
% mu = [mu start; mu end; mu start2; mu end2;....];
% mask : should be same dimension with a data image.
% CCDradius : radius of CCD active area (marCCD). default = 0 for no
% masking.
dfwl = 1;
dfoffset=10;
dfpsize = 0.7;
dfSDD = 2000;
dfBp = [100,100];
dfQoption = 0;
dfLimit = [2^16, -1000];
dfmu = [];
dfmask = [];
dfQscale = [0.1, 200];
dfccdR = 0;
CCDradius = 0;
if nargin < 12
    CCDradius = 0;
    dezinger = [];
    dezingertimes = [];
end

if isempty(Qoption)
    Qoption = dfQoption;
end
if isempty(Qscale)
    Qscale = dfQscale;
end
if isempty(Limit)
    Limit = dfLimit;
end
if isempty(dezinger)
    dezinger = 0;
    dezingertimes = 5;
end

if (nargin < 2)
    waveln=dfwl;
    offset = dfoffset;
    psize=dfpsize;
    SDD=dfSDD;
    Bp = dfBp;
    Qoption = dfQoption;
    Qscale = dfQscale;
    Limit = dfLimit;
    mu = dfmu;
    mask = dfmask;
    CCDradius = dfccdR;
    dezinger = 0;
    dezingertimes = 5;
elseif (nargin<7)
    Qoption = dfQoption;
    Qscale = dfQscale;
    Limit = dfLimit;
    mu = dfmu;
    mask = dfmask;
    CCDradius = dfccdR;
    dezinger = 0;
    dezingertimes = 5;
elseif (nargin<9)    
    Limit = dfLimit;
    mu = dfmu;
    mask = dfmask;
    CCDradius = dfccdR;
    dezinger = 0;
    dezingertimes = 5;
end
y=[];
if isempty(mask)
    mask = ones(size(image));
end
mask = double(mask);
%circularavg(image, offset, [beamX, beamY], [maxlimit, minlimit], [mu_start, mu_end], mask, Qoption, [Qmax, Qnum], waveln, psize, SDD);
%CCDradius = 0;
%Bp2 = Bp;
%Bp(2) = Bp2(1);Bp(1)=Bp2(2);
%image = image - offset;
%y = circularavg(image, 0, Bp, Limit, mu, mask, Qoption, Qscale, waveln, psize, SDD,CCDradius);
%image, offset, [beamX, beamY], [highL, lowL], [mu_S, mu_E], and mask, Qoption, Qscale, waveln, psize, SDD, CCDradius, deZinger
%Bp = Bp-1;
y = circularavg(flipud(double(image)), offset, Bp, Limit, mu, flipud(mask), Qoption, Qscale, waveln, psize, SDD,CCDradius, dezinger, dezingertimes);
%y = circularavgn(image, offset, Bp, Limit, mu, mask, Qoption, Qscale, waveln, psize, SDD, CCDradius);