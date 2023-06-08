%�ѿ����ռ�ƥ��
%�������ӻ��͵���ͼ
%using Robotics Toolbox 10.3.1
clc;
Xg=zeros(50000,1);
Yg=zeros(50000,1);
Zg=zeros(50000,1);
for i=1:50000
    Xg(i) = 2.4*X(i)-0.26;
    Yg(i) = 1.6*Y(i)-0.05;
    Zg(i) = 1.4*Z(i)+0.11;
    
%     Xg(i) = 3*X(i)-0.433;
%     Yg(i) = 2*Y(i)-0.0286;
%     Zg(i) = 1.7*Z(i)+0.1;

end
subplot(2,2,1);
view(3)		% ����Ĭ����ά��ͼ
% convhulln����������͹���ģ��õ�����͹����������,
A=[Xg,Yg,Zg];
f = convhulln(A);
% patch������������������棬�γɰ����壬�Ȼ�ƥ���
patch('vertices',A,'faces',f,'facecolor','r')
hold on;
%�ٻ�ԭ��Gluon�Ŀռ�
B=[Xs,Ys,Zs];
f1 = convhulln(B);
patch('vertices',B,'faces',f1,'facecolor','b')
xlabel('x��(meter)','color','k');
ylabel('y��(meter)','color','k');
zlabel('z��(meter)','color','k');

subplot(2,2,2);
plot(Xg,Yg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Ys,'b.','MarkerSize',0.5);
xlabel('x��','color','k');
ylabel('y��','color','k');

subplot(2,2,3);
plot(Xg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Zs,'b.','MarkerSize',0.5);
xlabel('x��','color','k');
ylabel('z��','color','k');

subplot(2,2,4);
plot(Yg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Ys,Zs,'b.','MarkerSize',0.5);
xlabel('y��','color','k');
ylabel('z��','color','k');



    
    

