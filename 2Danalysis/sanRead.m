function [m, H] = sanRead(filename)
% function m = sanRead(filename)
% .SAN datafile open 
% Determine the number of columns in the file 
% by looking at the firstline

fid = fopen(filename,'r');
if (fid == -1)
  error('File not found or permission denied.');
end

firstline = ' ';
startn = ' ';
while startn ~= 'OK'
   firstline = fgetl(fid);
   if (length(firstline) >= 18)&(firstline(1:18) == 'Counting_time(sec)')
       dataline = fscanf(fid, '%f');
       H.ctime = dataline(1);
       H.mcount = dataline(2);
       clear dataline
   end

   if (length(firstline) >= 10)&(firstline(1:10) == 'Wavelength')
       dataline = fscanf(fid, '%f');
       H.wavel = dataline(1);
       clear dataline
   end
   
   if (length(firstline) >= 12)&(firstline(1:12) == 'Transmission')
       dataline = fscanf(fid, '%f');
       H.Tr = dataline(1);
       H.thick = dataline(2);
       clear dataline
   end
   
   if (length(firstline) >= 14)&(firstline(1:14) == 'Sam_Det_Dis(m)')
       dataline = fscanf(fid, '%f');
       H.SDD = dataline(1);
       clear dataline
   end
   
   if (length(firstline) >= 19)&(firstline(1:19) == 'Detector_Pixel(x,y)')
       dataline = fscanf(fid, '%f');
       H.pixelsize = dataline(1);
       clear dataline
   end
   
   if (length(firstline) >= 2)&(firstline(1:2) == '//')
      startn = 'OK';
   end
end


m = fscanf(fid, '%d', [128, 128]);

m = flipud(rot90(m));