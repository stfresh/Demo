%笛卡尔空间匹配
%包括可视化和点云图
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
view(3)		% 设置默认三维视图
% convhulln函数就是算凸包的，得到的是凸包的坐标们,
A=[Xg,Yg,Zg];
f = convhulln(A);
% patch函数，将坐标点连成面，形成包络体，先画匹配的
patch('vertices',A,'faces',f,'facecolor','r')
hold on;
%再画原本Gluon的空间
B=[Xs,Ys,Zs];
f1 = convhulln(B);
patch('vertices',B,'faces',f1,'facecolor','b')
xlabel('x轴(meter)','color','k');
ylabel('y轴(meter)','color','k');
zlabel('z轴(meter)','color','k');

subplot(2,2,2);
plot(Xg,Yg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Ys,'b.','MarkerSize',0.5);
xlabel('x轴','color','k');
ylabel('y轴','color','k');

subplot(2,2,3);
plot(Xg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Xs,Zs,'b.','MarkerSize',0.5);
xlabel('x轴','color','k');
ylabel('z轴','color','k');

subplot(2,2,4);
plot(Yg,Zg,'r.','MarkerSize',0.5);
grid on;
hold on;
plot(Ys,Zs,'b.','MarkerSize',0.5);
xlabel('y轴','color','k');
ylabel('z轴','color','k');



    
    

