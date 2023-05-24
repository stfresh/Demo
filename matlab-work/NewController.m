clear;
clc;
close all;
%% train
% 确定神经网络的中心点及宽度
[D1,D2,D3,D4,D5,D6]=ndgrid(0.6:0.2:1.4,...
                           0.6:0.2:1.4,...
                          -0.5:0.2:0.5,...
                            -1:0.2:1,...
                          -0.6:0.2:0.2,...
                           1.2:0.3:2.2);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
width=[0.2;0.2;0.2;0.2;0.2;0.3].*1.25;
% 控制器参数设置
C=800*[0.001,0.001];
Gamma=80;
Sigma=0.000001;
% 系统状态及神经网络权值初始化
X1=[1,0.8]';  % 机械臂初始位置
X2=[0.3,0.3]';  % 机械臂初始速度
W_ini=zeros(size(center,2),2);


count = 1;
t_=0;
t=[];
h=0.01;
dt=0.01;
Yd1=[];
DYd1=[];
D2Yd1=[];
Val=[];

%% 控制循环
% 四阶龙格库塔
y = [X1;X2;reshape(W_ini,[],1)];
tic
while count<5000
%% 保存数据
K1=NewNNdesignCPU(t_,y,C,center,width,Gamma,Sigma);
K2=NewNNdesignCPU(t_,y+(h/2)*K1,C,center,width,Gamma,Sigma);
K3=NewNNdesignCPU(t_,y+(h/2)*K2,C,center,width,Gamma,Sigma);
K4=NewNNdesignCPU(t_,y+h*K3,C,center,width,Gamma,Sigma);
y=y+h/6*(K1+2*K2+2*K3+K4);

if (mod(count,10)==1) %% 采样保存
Yd1_=[1-0.2*cos((0.1*pi)*t_),1+0.2*sin((0.1*pi)*t_)];
DYd1_=[0.2*(0.1*pi)*sin((0.1*pi)*t_),0.2*(0.1*pi)*cos((0.1*pi)*t_)];
D2Yd1_=[0.2*(0.1*pi)^2*cos((0.1*pi)*t_),-0.2*(0.1*pi)^2*sin((0.1*pi)*t_)];
Yd1=[Yd1;Yd1_];
DYd1=[DYd1;DYd1_];
D2Yd1=[D2Yd1;D2Yd1_];
Val_=y';
Val=[Val;Val_];
t=[t;t_];
end

%% 时间更新
if (mod(count,100)==1)
    disp(['t=',num2str(t_)]);
end

t_=t_+dt;
count=count+1;
end
toc
[U_trace,H_Z_nn,H_Z] = NNtrace(t,Val,C,center,width);
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

for j=1:size(q2,1)
    if q2(j)>0
        q1(j,:)=p1(j)-p2(j);
        dq1(j,:)=d_p1(j)-d_p2(j);
    else
        q1(j,:)=p1(j)+p2(j);
        dq1(j,:)=d_p1(j)+d_p2(j);
    end
end
q=[q1,q2];
%% 
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

figure(5);
subplot(2,1,1);plot(t,q(:,1));title('关节角度q');
subplot(2,1,2);plot(t,q(:,2));

figure(7);
subplot(2,1,1);plot(t,X1(:,1)-Yd1(:,1));title('状态X1的跟踪误差变化曲线');
subplot(2,1,2);plot(t,X1(:,2)-Yd1(:,2));

figure(8);
subplot(2,1,1);plot(t,X2(:,1)-DYd1(:,1));title('状态X2的跟踪误差变化曲线');
subplot(2,1,2);plot(t,X2(:,2)-DYd1(:,2));
 
figure(9);
subplot(2,1,1);plot(t,U_trace(:,1));title('输入信号变化曲线');
subplot(2,1,2);plot(t,U_trace(:,2));

figure(10);
subplot(121);plot(t,H_Z(:,1),'r-',t,H_Z_nn(:,1),'g--');title('H(:,1)动态及神经网络');
subplot(122);plot(t,H_Z(:,2),'r-',t,H_Z_nn(:,2),'g--');title('H(:,2)');

figure(11);
subplot(2,1,1);plot(t,W_1(:,1:100),'LineWidth',1); figure(gcf);title('神经网络权值收敛情况');
subplot(2,1,2);plot(t,W_2(:,1:100),'LineWidth',1); figure(gcf);

% %% 存储神经网络
% save center_p3 center_p3;  % 存储该模式所对应的神经网络相关参数
% save width_p3 width_p3;
% W_1_mean=mean(W_1(9500:end,:));
% W_2_mean=mean(W_2(9500:end,:));
% W_mean_p3=[W_1_mean;W_2_mean]';
% save W_mean_p3 W_mean_p3;