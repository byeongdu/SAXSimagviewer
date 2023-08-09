function plotTiltCircle_blee(x,calibrant)
% plotTiltCircle3(x,calibrant): plot the picked and fitted data points on
% the calibrant rings
% x:fitted [xc yc SSDrel yaw]
% calibrant: struct data for calibrant rings(fields: wavelenght, data([{q,xy};...))

% written by Xiaobing Zuo, 3/2011

wavelength = calibrant.wavelength;
data=calibrant.data;

kMax=length(data);

figure('name','fitting calibrant q-rings')
hold on
for k=1:kMax
    q=data(k).q;
    xy = data(k).xy;
    
    tg_2th = tan(2.*asin(q*wavelength/(4*pi)));
    xn=xy(1,:)'-x(1);
    yn=xy(2,:)'-x(2);
    y0 = real(sqrt((x(3)*tg_2th).^2-xn.^2));
    y2 = y0;
    %[nPx, delta_sdd] = detector_rotate([xn, y2], [x(4), 0, 0]);
    %NewSDDratio = x(3) + delta_sdd;
    tan2th = y2/x(3);
    y2 = y2./(tan2th*sin(x(4)*pi/180) + cos(x(4)*pi/180));
    newPx =[xn, y2];

    
    plot(xn,yn,'or', 'MarkerSize',10)

    plot(newPx(:,1),newPx(:,2),'-ob','MarkerSize',4);
    plot(newPx(:,1),y0,'-g','MarkerSize',4);
end    
hold off