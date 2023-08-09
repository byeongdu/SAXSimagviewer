function R = lineplot(img, start, final)

step = 1;

angleV = (final(1) - start(1)) + (final(2) - start(2))*j;
theta = angle(angleV);

d_max = fix(sqrt((final(2) -start(2)).^2 + (final(1) - start(1)).^2));

for i = 0:step:d_max
   R(i+1,1) = i;
   
   Xposi(i+1) = i*cos(theta)+start(1);
   Yposi(i+1) = i*sin(theta)+start(2);
   
   R(i+1,2) = intens(img, [Xposi(i+1), Yposi(i+1)]);
end
