%{
本程序用于对同一控制对象、不同目标跟踪轨迹的神经网络控制器设计：
1) 首先结合动态面方法对控制器进行设计，假设系统参数已知,对应于Direct Control；
2) 然后应用神经网络对系统未知动态进行逼近，设计基于神经网络的控制器，假设系统参数未知，对应于Neural Network Control；
3) 最后将神经网络训练后收敛的权值以及神经元分布存储起来，作为以后控制目标为此跟踪轨迹时的学习经验；
4) 每个目标跟踪轨迹对应系统一种运行模式，在进行控制器设计时可直接调用该模式对应的学习经验，即学习控制，对应于Learning Control。
%}
clear;
clc;
close all;

%% train

% 确定神经网络的中心点及宽度
% [D1,D2,D3,D4,D5,D6,D7,D8]=ndgrid(0.6:0.2:1.4,0.6:0.2:1.4,-0.5:0.2:0.5,-0.5:0.2:0.5,-0.2:0.1:0.2,-0.4:0.7:1,-0.6:0.35:0.1,1.2:0.5:2.2);
% center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[]);reshape(D7,1,[]);reshape(D8,1,[])];
% width=[0.2;0.2;0.2;0.2;0.1;0.7;0.35;0.5].*1.25;
[D1,D2,D3,D4,D5,D6]=ndgrid(0.6:0.2:1.4,...
                           0.6:0.2:1.4,...
                          -0.5:0.1:0.5,...
                            -1:0.2:1,...
                          -0.6:0.2:0.2,...
                           1.2:0.3:2.2);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
width=[0.2;0.2;0.1;0.2;0.2;0.3].*1.25;
% 设置运行时间区间
tspan=0:0.1:5;

% 控制器参数设置
C=4*[1,1];
Gamma=45;
Sigma=0.000001;

% 系统状态及神经网络权值初始化
X1_ini=[1,1]';  % 机械臂初始角度
X2_ini=[0,0]';  % 机械臂初始角速度
W_ini=zeros(size(center,2),2);

% Direct Control
% [t,Val]=ode45('DRdesign',tspan,[X1_ini;X2_ini],[],C);
% [U_trace,DA1_trace,H_Z] = DRtrace(t,Val,C);

% Neural Network Control
[t,Val]=ode45('NNdesignCPU',tspan,[X1_ini;X2_ini;reshape(W_ini,[],1)],[],...
     C,center,width,Gamma,Sigma);
[U_trace,H_Z_nn,H_Z] = NNtrace(t,Val,C,center,width);

% Learning Control
% [t,Val]=ode45('LCdesign',tspan,[X1_ini;X2_ini;Yd_ini;DYd_ini],[],k);
% [U_trace,H_Z_nn,H_Z] = LCtrace(t,Val,k);

fprintf('Training is complete.\n');

%% figure
X1=Val(:,1:2);X2=Val(:,3:4);
n=size(center,2);
W_1=Val(:,5:end-n);W_2=Val(:,end-n+1:end);
x=Val(:,1:2);
l1=1;l2=1;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];

pl=0.5;

M=P+pl*L;
Q=(x(:,1).^2+x(:,2).^2-l1^2-l2^2)./(2*l1*l2);
q2=acos(Q);
dq2=-1./sqrt(1-Q.^2);

A=x(:,2)./x(:,1);
p1=atan(A);
d_p1=1./(1+A.^2);

B=sqrt(x(:,1).^2+x(:,2).^2+l1^2-l2^2)./(2*l1*sqrt(x(:,1).^2+x(:,2).^2));
p2=acos(B);
d_p2=-1./sqrt(1-B.^2);

for i=1:size(q2,1)
    if q2(i)>0
        q1(i,:)=p1(i)-p2(i);
        dq1(i,:)=d_p1(i)-d_p2(i);
    else
        q1(i,:)=p1(i)+p2(i);
        dq1(i,:)=d_p1(i)+d_p2(i);
    end
end
q=[q1,q2];
%% 
Yd1=[1-0.2*cos((0.1*pi)*t),1+0.2*sin((0.1*pi)*t)];
DYd1=[0.2*(0.1*pi)*sin((0.1*pi)*t),0.2*(0.1*pi)*cos((0.1*pi)*t)];
D2Yd1=[0.2*(0.1*pi)^2*cos((0.1*pi)*t),-0.2*(0.1*pi)^2*sin((0.1*pi)*t)];

% Yd1=[0.6-0.2*cos(pi*t),1.01+0.2*sin(pi*t)];
% DYd1=[0.2*pi*sin(pi*t),0.2*pi*cos(pi*t)];
% D2Yd1=[0.2*pi*pi*cos(pi*t),-0.2*pi*pi*sin(pi*t)];
A1=-C(1)*(X1-Yd1)+DYd1;
DA1=-C(1)*(X2-DYd1)+D2Yd1;

figure(1);
subplot(2,1,1);plot(t,X1(:,1));title('状态X1');
subplot(2,1,2);plot(t,X1(:,2));
figure(2);
subplot(2,1,1);plot(t,X2(:,1));title('状态X2');
subplot(2,1,2);plot(t,X2(:,2));
figure(3);
subplot(2,1,1);plot(t,A1(:,1));title('状态A1');
subplot(2,1,2);plot(t,A1(:,2));
% figure(4);
% subplot(2,1,1);plot(t,DA1(:,1));title('状态DA1');
% subplot(2,1,2);plot(t,DA1(:,2));
figure(6);
subplot(2,1,1);plot(t,q(:,1));title('关节角度q');
subplot(2,1,2);plot(t,q(:,2));

%%  
figure(11);
subplot(2,1,1);plot(t,X1(:,1)-Yd1(:,1));title('状态X1的跟踪误差变化曲线');
subplot(2,1,2);plot(t,X1(:,2)-Yd1(:,2));

figure(22);
subplot(2,1,1);plot(t,X2(:,1)-DYd1(:,1));title('状态X2的跟踪误差变化曲线');
subplot(2,1,2);plot(t,X2(:,2)-DYd1(:,2));
%  
figure(3);
subplot(2,1,1);plot(t,U_trace(:,1));title('输入信号变化曲线');
subplot(2,1,2);plot(t,U_trace(:,2));

figure(4);
subplot(121);plot(t,H_Z(:,1),'r-',t,H_Z_nn(:,1),'g--');title('H(:,1)动态及神经网络');
subplot(122);plot(t,H_Z(:,2),'r-',t,H_Z_nn(:,2),'g--');title('H(:,2)');
% %  
figure(5);
subplot(2,1,1);plot(t,W_1(:,1:100),'LineWidth',1); figure(gcf);title('神经网络权值收敛情况');
subplot(2,1,2);plot(t,W_2(:,1:100),'LineWidth',1); figure(gcf);

% %% 存储神经网络
% save center_p3 center_p3;  % 存储该模式所对应的神经网络相关参数
% save width_p3 width_p3;
% W_1_mean=mean(W_1(9500:end,:));
% W_2_mean=mean(W_2(9500:end,:));
% W_mean_p3=[W_1_mean;W_2_mean]';
% save W_mean_p3 W_mean_p3;