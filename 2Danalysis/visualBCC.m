function visualBCC(R, b1, b2, b3)
% BCC구조를 그리는 프로그래미....
figure
hold on
visualsphere(R, [0 0 0], 'k');
visualsphere(R, b1, 'k');
visualsphere(R, b2, 'k');
visualsphere(R, b3, 'k');
visualsphere(R, b1+b2, 'k');
visualsphere(R, b1+b3, 'k');
visualsphere(R, b2+b3, 'k');
visualsphere(R, (b1+b2+b3), 'k');
visualsphere(R, 1/2*(b1+b2+b3), 'r');


t = line([0 b1(1)], [0 b1(2)], [0, b1(3)]);set(t, 'color', [1 0 0]); % Red
t = line([0 b2(1)], [0 b2(2)], [0, b2(3)]);set(t, 'color', [0 1 0]); % Green
t = line([0 b3(1)], [0 b3(2)], [0, b3(3)]);set(t, 'color', [0 0 1]); % Blue

view([90, 0, 0]);