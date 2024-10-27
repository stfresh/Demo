close all;

figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,5),'k:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
legend('Ideal position signal','link1 tracking');
subplot(212);
plot(t,x(:,2),'r',t,x(:,6),'k:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');
legend('Ideal speed signal','link1 Speed tracking');

figure(2);
subplot(211);
plot(t,x(:,3),'r',t,x(:,7),'k:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
legend('Ideal position signal','link2 tracking');
subplot(212);
plot(t,x(:,4),'r',t,x(:,8),'k:','linewidth',2);
xlabel('time(s)');ylabel('Speed tracking');
legend('Ideal speed signal','link2 Speed tracking');

figure(3);
subplot(211);
plot(t,W(:,3:102),'b','linewidth',0.5);
xlabel('time(s)');ylabel('weight1');
legend('W1');
subplot(212);
plot(t,W(:,103:202),'r','linewidth',0.5);
xlabel('time(s)');ylabel('weight2');
legend('W2');
