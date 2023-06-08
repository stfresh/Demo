%采用蒙特卡洛法对机器人的工作空间进行描绘
%包括可视化和点云图
%using Robotics Toolbox 10.3.1
clc;
% clear;
%建立连杆   theta d a alpah
L(1)=Link([0,0,0,0],'modified');
L(2)=Link([0,0,0,pi/2],'modified');
L(3)=Link([0,0,0.13335,0],'modified');
L(4)=Link([0,0.13335,0,pi/2],'modified');
L(5)=Link([0,0,0,pi/2],'modified');
L(6)=Link([0,0.03,0,-pi/2],'modified');

%设置偏置
% L(1).offset=0;
% L(2).offset=0;
L(3).offset=0;
% L(4).offset=0;
% L(5).offset=0;
% L(6).offset=0;
touchX = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','touchX01');
%teach(touchX); 示教部分可选
% touchX.plot([0,0,0,0,0,0]);
% hold on;

%6个关节角的限制设置   这个是参考网上文件的
% theta1min=-0.98;theta1max=0.98;
% theta2min=0;theta2max=1.78;
% theta3min=-0.81;theta3max=1.25;
% theta4min=-2.35;theta4max=2.53;
% theta5min=-0.5;theta5max=1.75;
% theta6min=-2.58;theta6max=2.58;

%这个是自己实物测试的，选定仿真角度大于测试角度，确保实际的角度都在仿真里面
theta1min=-0.98;theta1max=0.98;
theta2min=-0.02;theta2max=1.78;
theta3min=-0.1;theta3max=1.25;
theta4min=-2.35;theta4max=2.53;
theta5min=-0.5;theta5max=1.75;
theta6min=-2.78;theta6max=2.78;

%设置随机次数
n = 50000;
%用于记录末端点的x,y,z值
X = zeros(n,1);
Y = zeros(n,1);
Z = zeros(n,1);


for i = 1:n  %循环3000次，rand用于产生0~1的随机数
    q1=theta1min + (theta1max-theta1min)*rand;
    q2=theta2min + (theta2max-theta2min)*rand;
    q3=theta3min + (theta3max-theta3min)*rand;
    q4=theta4min + (theta4max-theta4min)*rand;
    q5=theta5min + (theta5max-theta5min)*rand;
    q6=theta6min + (theta6max-theta6min)*rand;
    
    %robot.plot([q1,q2,q3,q4,q5,q6]);%动画显示,可不用
    
    trans = touchX.fkine([q1,q2,q3,q4,q5,q6]);%求解
    %trans中有四个向量t，n，o，a
    %trans = [ n o a t ],我们取第四个位置向量 
    X(i) = trans.t(1);
    Y(i) = trans.t(2);
    Z(i) = trans.t(3);
    %plot3(trans.t(1),trans.t(2),trans.t(3),'b.','MarkerSize',0.5);  
    %hold on;
end
%对落点进行描绘
Xmmax = max(X);
Xmmin = min(X);

Ymmax = max(Y);
Ymmin = min(Y);

Zmmax = max(Z);
Zmmin = min(Z);

subplot(2,2,1);
plot3(X,Y,Z,'r.','MarkerSize',0.5);
grid on;
xlabel('x轴(meter)','color','k');
ylabel('y轴(meter)','color','k');
zlabel('z轴(meter)','color','k');

subplot(2,2,2);
plot(X,Y,'r.','MarkerSize',0.5);
grid on;
xlabel('x轴','color','k');
ylabel('y轴','color','k');

subplot(2,2,3);
plot(X,Z,'r.','MarkerSize',0.5);
grid on;
xlabel('x轴','color','k');
ylabel('z轴','color','k');

subplot(2,2,4);
plot(Y,Z,'r.','MarkerSize',0.5);
grid on;
xlabel('y轴','color','k');
ylabel('z轴','color','k');




% figure('color',[1 1 1]);
% plot3(X,Y,Z,'r.','MarkerSize',0.5);
% hold on;
% xlabel('x轴(meter)','color','k','fontsize',15);
% ylabel('y轴(meter)','color','k','fontsize',15);
% zlabel('z轴(meter)','color','k','fontsize',15);

    
    

