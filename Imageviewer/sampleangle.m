function sample = sampleangle(reflectBeam, directbeam, SDD, pixelsize)
% function sample = sampleangle(reflectBeam, directbeam, SDD, pixelsize)
distH = abs(reflectBeam - directbeam)*pixelsize;

sample = rad2deg(atan(distH/SDD)/2);