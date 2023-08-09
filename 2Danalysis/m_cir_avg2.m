filename = ['ct60s'];
filename1 = ['ct60s-1'];
filename2 = ['ct60s-2'];
filename3 = ['ct60s-3'];
filename4 = ['ct60s-4'];
%filename5 = ['ls60s-5'];
%filename6 = ['ls60s-6'];
%filename7 = ['ls60s-7'];
mu1 = 80
mu2 = 100

filespe = [filename, '.spe']; 
R = speopen(filespe);
A = circular(R, center, mu1, mu2);
filedat = [filename, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename1, '.spe']; 
R = speopen(filespe);
A = circular(R, center, mu1, mu2);
filedat = [filename1, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);


filespe = [filename2, '.spe']; 
R = speopen(filespe);
A = circular(R, center, mu1, mu2);
filedat = [filename2, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename3, '.spe']; 
R = speopen(filespe);
A = circular(R, center, mu1, mu2);
filedat = [filename3, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename4, '.spe']; 
R = speopen(filespe);
A = circular(R, center, mu1, mu2);
filedat = [filename4, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

%filespe = [filename5, '.spe']; 
%R = speopen(filespe);
%A = circular(R, center, mu1, mu2);
%filedat = [filename5, '1d.dat']
%a = ['save ', filedat, ' A -ascii'];
%eval(a);

%filespe = [filename6, '.spe']; 
%R = speopen(filespe);
%A = circular(R, center, mu1, mu2);
%filedat = [filename6, '1d.dat']
%a = ['save ', filedat, ' A -ascii'];
%eval(a);

%filespe = [filename7, '.spe']; 
%R = speopen(filespe);
%A = circular(R, center, mu1, mu2);
%filedat = [filename7, '1d.dat']
%a = ['save ', filedat, ' A -ascii'];
%eval(a);
