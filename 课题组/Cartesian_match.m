%笛卡尔空间匹配
%包括可视化和点云图
%using Robotics Toolbox 10.3.1
clc;
Xg=X;
Yg=Y;
Zg=Z;
for i=1:50000
    Xg(i) = 2.6*X(i)-0.26;
    Yg(i) = 1.8*Y(i)+0.03;
    Zg(i) = 1.7*Z(i)+0.10;
 %对映射后的X、Y空间做约束
 %将Xg限制在【-0.05,0.05】之外
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



    
    

