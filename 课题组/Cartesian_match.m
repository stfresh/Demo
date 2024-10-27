%�ѿ����ռ�ƥ��
%�������ӻ��͵���ͼ
%using Robotics Toolbox 10.3.1
clc;
Xg=X;
Yg=Y;
Zg=Z;
for i=1:50000
    Xg(i) = 2.6*X(i)-0.26;
    Yg(i) = 1.8*Y(i)+0.03;
    Zg(i) = 1.7*Z(i)+0.10;
 %��ӳ����X��Y�ռ���Լ��
 %��Xg�����ڡ�-0.05,0.05��֮��
 if Xg(i) > -0.05 && Xg(i) <= 0 && Yg(i) > -0.05 && Yg(i) < 0.05
    Xg(i) = -0.05;
 elseif Xg(i) < 0.05 && Xg(i) >=0  && Yg(i) > -0.05 && Yg(i) < 0.05
        Xg(i) = 0.05;
 end
 

%     Xg(i) = 1.8*X(i)-0.3959;
%     Yg(i) = 1.8*Y(i)-0.0268;
%     Zg(i) = 1.8*Z(i);

end
figure("name","Cartesian_match");
title("Cartesian_match");
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
xlabel('x(meter)','color','k');
ylabel('y(meter)','color','k');
zlabel('z(meter)','color','k');

subplot(2,2,2);
plot(Xg,Yg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Ys,'b.','MarkerSize',0.5);
xlabel('x','color','k');
ylabel('y','color','k');

subplot(2,2,3);
plot(Xg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Zs,'b.','MarkerSize',0.5);
xlabel('x','color','k');
ylabel('z','color','k');

subplot(2,2,4);
plot(Yg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Ys,Zs,'b.','MarkerSize',0.5);
xlabel('y','color','k');
ylabel('z','color','k');



    
    

