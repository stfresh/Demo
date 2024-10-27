%{
���������ڶ�ͬһ���ƶ��󡢲�ͬĿ����ٹ켣���������������ƣ�
1) ���Ƚ�϶�̬�淽���Կ�����������ƣ�����ϵͳ������֪,��Ӧ��Direct Control��
2) Ȼ��Ӧ���������ϵͳδ֪��̬���бƽ�����ƻ���������Ŀ�����������ϵͳ����δ֪����Ӧ��Neural Network Control��
3) ���������ѵ����������Ȩֵ�Լ���Ԫ�ֲ��洢��������Ϊ�Ժ����Ŀ��Ϊ�˸��ٹ켣ʱ��ѧϰ���飻
4) ÿ��Ŀ����ٹ켣��Ӧϵͳһ������ģʽ���ڽ��п��������ʱ��ֱ�ӵ��ø�ģʽ��Ӧ��ѧϰ���飬��ѧϰ���ƣ���Ӧ��Learning Control��
%}
clear;
clc;
close all;

%% train

% ȷ������������ĵ㼰���
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
% ��������ʱ������
tspan=0:0.1:5;

% ��������������
C=4*[1,1];
Gamma=45;
Sigma=0.000001;

% ϵͳ״̬��������Ȩֵ��ʼ��
X1_ini=[1,1]';  % ��е�۳�ʼ�Ƕ�
X2_ini=[0,0]';  % ��е�۳�ʼ���ٶ�
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
subplot(2,1,1);plot(t,X1(:,1));title('״̬X1');
subplot(2,1,2);plot(t,X1(:,2));
figure(2);
subplot(2,1,1);plot(t,X2(:,1));title('״̬X2');
subplot(2,1,2);plot(t,X2(:,2));
figure(3);
subplot(2,1,1);plot(t,A1(:,1));title('״̬A1');
subplot(2,1,2);plot(t,A1(:,2));
% figure(4);
% subplot(2,1,1);plot(t,DA1(:,1));title('״̬DA1');
% subplot(2,1,2);plot(t,DA1(:,2));
figure(6);
subplot(2,1,1);plot(t,q(:,1));title('�ؽڽǶ�q');
subplot(2,1,2);plot(t,q(:,2));

%%  
figure(11);
subplot(2,1,1);plot(t,X1(:,1)-Yd1(:,1));title('״̬X1�ĸ������仯����');
subplot(2,1,2);plot(t,X1(:,2)-Yd1(:,2));

figure(22);
subplot(2,1,1);plot(t,X2(:,1)-DYd1(:,1));title('״̬X2�ĸ������仯����');
subplot(2,1,2);plot(t,X2(:,2)-DYd1(:,2));
%  
figure(3);
subplot(2,1,1);plot(t,U_trace(:,1));title('�����źű仯����');
subplot(2,1,2);plot(t,U_trace(:,2));

figure(4);
subplot(121);plot(t,H_Z(:,1),'r-',t,H_Z_nn(:,1),'g--');title('H(:,1)��̬��������');
subplot(122);plot(t,H_Z(:,2),'r-',t,H_Z_nn(:,2),'g--');title('H(:,2)');
% %  
figure(5);
subplot(2,1,1);plot(t,W_1(:,1:100),'LineWidth',1); figure(gcf);title('������Ȩֵ�������');
subplot(2,1,2);plot(t,W_2(:,1:100),'LineWidth',1); figure(gcf);

% %% �洢������
% save center_p3 center_p3;  % �洢��ģʽ����Ӧ����������ز���
% save width_p3 width_p3;
% W_1_mean=mean(W_1(9500:end,:));
% W_2_mean=mean(W_2(9500:end,:));
% W_mean_p3=[W_1_mean;W_2_mean]';
% save W_mean_p3 W_mean_p3;