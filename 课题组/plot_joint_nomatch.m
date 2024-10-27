subplot(2,2,1);
plot3(Xs,Ys,Zs,'b.','MarkerSize',0.5);
grid on;
hold on;
plot3(X,Y,Z,'r.','MarkerSize',0.5);
xlabel('x÷·(meter)','color','k');
ylabel('y÷·(meter)','color','k');
zlabel('z÷·(meter)','color','k');

subplot(2,2,2);
plot(Xs,Ys,'b.','MarkerSize',0.5);
grid on;
hold on;
plot(X,Y,'r.','MarkerSize',0.5);
xlabel('x÷·','color','k');
ylabel('y÷·','color','k');

subplot(2,2,3);
plot(Xs,Zs,'b.','MarkerSize',0.5);
grid on;
hold on;
plot(X,Z,'r.','MarkerSize',0.5);
xlabel('x÷·','color','k');
ylabel('z÷·','color','k');

subplot(2,2,4);
plot(Ys,Zs,'b.','MarkerSize',0.5);
grid on;
hold on;
plot(Y,Z,'r.','MarkerSize',0.5);
xlabel('y÷·','color','k');
ylabel('z÷·','color','k');