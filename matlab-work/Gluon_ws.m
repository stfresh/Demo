%采用蒙特卡洛法对机器人的工作空间进行描绘
%包括可视化和点云图
%using Robotics Toolbox 10.3.1
clc;
% clear;
%----------------------------------------------------------------------------------------------
%①建立改进型连杆   theta d a alpah
% L(1)=Link([0,0.1205,0,0],'modified');
% L(2)=Link([0,0.080113,0,pi/2],'modified');
% L(3)=Link([0,0,0.2035,0],'modified');
% L(4)=Link([0,0.0044,0.17442,pi],'modified');
% L(5)=Link([0,-0.0809,0,-pi/2],'modified');
% L(6)=Link([0,-0.04436,0,pi/2],'modified');


%①改进型的偏置
% L(1).offset=pi/2;
% L(2).offset=pi/2;
% L(3).offset=0;
% L(4).offset=pi/2;
% L(5).offset=0;
% L(6).offset=0;
%-----------------------------------------------------------------------------------------------
%②标准型 建立连杆   theta d a alpah   d6=0.04436;先设成0
L(1)=Link([0,0.1205,0,pi/2],'standard');
L(2)=Link([0,0,-0.2035,0],'standard');
L(3)=Link([0,0,-0.17442,0],'standard');
L(4)=Link([0,0.08009,0,pi/2],'standard');
L(5)=Link([0,0.08009,0,-pi/2],'standard');
L(6)=Link([0,0,0,0],'standard');

%②设置标准型偏置
L(1).offset=0;
L(2).offset=-pi/2;
L(3).offset=0;
L(4).offset=-pi/2;
L(5).offset=0;
L(6).offset=0;
%-----------------------------------------------------------------------------------------------------


gluon = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','gluon01');
%teach(gluon); 示教部分可选
% robot.plot([0,0,0,0,0,0]);
% hold on;

%关节角限制
theta1min=-2.44;theta1max=2.44;
theta2min=-pi/2;theta2max=pi/2;
theta3min=-2.44;theta3max=2.44;
theta4min=-2.44;theta4max=2.44;
theta5min=-2.44;theta5max=2.44;
theta6min=-2*pi;theta6max=2*pi;



%设置随机次数
n = 50000;
%用于记录末端点的x,y,z值
Xs = zeros(n,1);
Ys = zeros(n,1);
Zs = zeros(n,1);


for i = 1:n  %循环3000次，rand用于产生0~1的随机数
    q1=theta1min + (theta1max-theta1min)*rand;
    q2=theta2min + (theta2max-theta2min)*rand;
    q3=theta3min + (theta3max-theta3min)*rand;
    q4=theta4min + (theta4max-theta4min)*rand;
    q5=theta5min + (theta5max-theta5min)*rand;
    q6=theta6min + (theta6max-theta6min)*rand;
    

    %robot.plot([q1,q2,q3,q4,q5,q6]);%动画显示,可不用
    
    transm = gluon.fkine([q1,q2,q3,q4,q5,q6]);%求解
    %trans中有四个向量t，n，o，a
    %trans = [ n o a t ],我们取第四个位置向量 
    Xs(i) = transm.t(1);
    Ys(i) = transm.t(2);
    Zs(i) = transm.t(3);
    %plot3(trans.t(1),trans.t(2),trans.t(3),'b.','MarkerSize',0.5);  
    %hold on;
end
%对落点进行描绘
% figure('color',[1 1 1]);
% plot3(Xs,Ys,Zs,'b.','MarkerSize',0.5);
% hold on;
Xsmax = max(Xs);
Xsmin = min(Xs);

Ysmax = max(Ys);
Ysmin = min(Ys);

Zsmax = max(Zs);
Zsmin = min(Zs);

subplot(2,2,1);
% plot3(Xs,Ys,Zs,'b.','MarkerSize',0.5);
% grid on;
% xlabel('x轴(meter)','color','k');
% ylabel('y轴(meter)','color','k');
% zlabel('z轴(meter)','color','k');
% 
%--------------------------------------------------------用来画3D包络图的
view(3)		% 设置默认三维视图
% convhulln函数就是算凸包的，得到的是凸包的坐标们
A=[Xs,Ys,Zs];
f = convhulln(A);
% patch函数，将坐标点连成面，形成包络体
patch('vertices',A,'faces',f,'facecolor','r')
% axis equal
xlabel('x轴(meter)','color','k');
ylabel('y轴(meter)','color','k');
zlabel('z轴(meter)','color','k');
%--------------------------------------------------------------------------------------

subplot(2,2,2);
plot(Xs,Ys,'b.','MarkerSize',0.5);
grid on;
xlabel('x轴','color','k');
ylabel('y轴','color','k');

subplot(2,2,3);
plot(Xs,Zs,'b.','MarkerSize',0.5);
grid on;
xlabel('x轴','color','k');
ylabel('z轴','color','k');

subplot(2,2,4);
plot(Ys,Zs,'b.','MarkerSize',0.5);
grid on;
xlabel('y轴','color','k');
ylabel('z轴','color','k');



% xlabel('x轴(meter)','color','k','fontsize',15);
% ylabel('y轴(meter)','color','k','fontsize',15);
% zlabel('z轴(meter)','color','k','fontsize',15);

    
    

