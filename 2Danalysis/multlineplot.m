function a = multlineplot(img, center)
A0 = lineplot3(img, center, 0, 1);
A90 = lineplot3(img, center, 90, 1);
A180 = lineplot3(img, center, 180, 1);
A270 = lineplot3(img, center, 270, 1);
figure
hold on
a(1) = plot(A0(:,1), A0(:,2),'r')
a(2) = plot(A90(:,1), A90(:,2),'b')
a(3) = plot(A180(:,1), A180(:,2),'g')
a(4) = plot(A270(:,1), A270(:,2),'m')
legend('mu = 0', 'mu = 90', 'mu = 180', 'mu = 270')