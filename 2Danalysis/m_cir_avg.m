filename = ['pe'];
filename1 = ['pe-1'];
filename2 = ['pe-2'];
filename3 = ['pe-3'];
filename4 = ['pe-4'];

filespe = [filename, '.spe']; 
R = speopen(filespe);
A = circular(R, center);
filedat = [filename, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename1, '.spe']; 
R = speopen(filespe);
A = circular(R, center);
filedat = [filename1, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);


filespe = [filename2, '.spe']; 
R = speopen(filespe);
A = circular(R, center);
filedat = [filename2, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename3, '.spe']; 
R = speopen(filespe);
A = circular(R, center);
filedat = [filename3, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);

filespe = [filename4, '.spe']; 
R = speopen(filespe);
A = circular(R, center);
filedat = [filename4, '1d.dat']
a = ['save ', filedat, ' A -ascii'];
eval(a);
