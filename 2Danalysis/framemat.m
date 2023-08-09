function R = framemat(filename, start, final)

R = [];
for i = start:1:final
   a = framespe(filename, i);
   R =[R, a];
end
