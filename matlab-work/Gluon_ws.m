%�������ؿ��巨�Ի����˵Ĺ����ռ�������
%�������ӻ��͵���ͼ
%using Robotics Toolbox 10.3.1
clc;
% clear;
%----------------------------------------------------------------------------------------------
%�ٽ����Ľ�������   theta d a alpah
% L(1)=Link([0,0.1205,0,0],'modified');
% L(2)=Link([0,0.080113,0,pi/2],'modified');
% L(3)=Link([0,0,0.2035,0],'modified');
% L(4)=Link([0,0.0044,0.17442,pi],'modified');
% L(5)=Link([0,-0.0809,0,-pi/2],'modified');
% L(6)=Link([0,-0.04436,0,pi/2],'modified');


%�ٸĽ��͵�ƫ��
% L(1).offset=pi/2;
% L(2).offset=pi/2;
% L(3).offset=0;
% L(4).offset=pi/2;
% L(5).offset=0;
% L(6).offset=0;
%-----------------------------------------------------------------------------------------------
%�ڱ�׼�� ��������   theta d a alpah   d6=0.04436;�����0
L(1)=Link([0,0.1205,0,pi/2],'standard');
L(2)=Link([0,0,-0.2035,0],'standard');
L(3)=Link([0,0,-0.17442,0],'standard');
L(4)=Link([0,0.08009,0,pi/2],'standard');
L(5)=Link([0,0.08009,0,-pi/2],'standard');
L(6)=Link([0,0,0,0],'standard');

%�����ñ�׼��ƫ��
L(1).offset=0;
L(2).offset=-pi/2;
L(3).offset=0;
L(4).offset=-pi/2;
L(5).offset=0;
L(6).offset=0;
%-----------------------------------------------------------------------------------------------------


gluon = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','gluon01');
%teach(gluon); ʾ�̲��ֿ�ѡ
% robot.plot([0,0,0,0,0,0]);
% hold on;

%�ؽڽ�����
theta1min=-2.44;theta1max=2.44;
theta2min=-pi/2;theta2max=pi/2;
theta3min=-2.44;theta3max=2.44;
theta4min=-2.44;theta4max=2.44;
theta5min=-2.44;theta5max=2.44;
theta6min=-2*pi;theta6max=2*pi;



%�����������
n = 50000;
%���ڼ�¼ĩ�˵��x,y,zֵ
Xs = zeros(n,1);
Ys = zeros(n,1);
Zs = zeros(n,1);


for i = 1:n  %ѭ��3000�Σ�rand���ڲ���0~1�������
    q1=theta1min + (theta1max-theta1min)*rand;
    q2=theta2min + (theta2max-theta2min)*rand;
    q3=theta3min + (theta3max-theta3min)*rand;
    q4=theta4min + (theta4max-theta4min)*rand;
    q5=theta5min + (theta5max-theta5min)*rand;
    q6=theta6min + (theta6max-theta6min)*rand;
    

    %robot.plot([q1,q2,q3,q4,q5,q6]);%������ʾ,�ɲ���
    
    transm = gluon.fkine([q1,q2,q3,q4,q5,q6]);%���
    %trans�����ĸ�����t��n��o��a
    %trans = [ n o a t ],����ȡ���ĸ�λ������ 
    Xs(i) = transm.t(1);
    Ys(i) = transm.t(2);
    Zs(i) = transm.t(3);
    %plot3(trans.t(1),trans.t(2),trans.t(3),'b.','MarkerSize',0.5);  
    %hold on;
end
%�����������
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
% xlabel('x��(meter)','color','k');
% ylabel('y��(meter)','color','k');
% zlabel('z��(meter)','color','k');
% 
%--------------------------------------------------------������3D����ͼ��
view(3)		% ����Ĭ����ά��ͼ
% convhulln����������͹���ģ��õ�����͹����������
A=[Xs,Ys,Zs];
f = convhulln(A);
% patch������������������棬�γɰ�����
patch('vertices',A,'faces',f,'facecolor','r')
% axis equal
xlabel('x��(meter)','color','k');
ylabel('y��(meter)','color','k');
zlabel('z��(meter)','color','k');
%--------------------------------------------------------------------------------------

subplot(2,2,2);
plot(Xs,Ys,'b.','MarkerSize',0.5);
grid on;
xlabel('x��','color','k');
ylabel('y��','color','k');

subplot(2,2,3);
plot(Xs,Zs,'b.','MarkerSize',0.5);
grid on;
xlabel('x��','color','k');
ylabel('z��','color','k');

subplot(2,2,4);
plot(Ys,Zs,'b.','MarkerSize',0.5);
grid on;
xlabel('y��','color','k');
ylabel('z��','color','k');



% xlabel('x��(meter)','color','k','fontsize',15);
% ylabel('y��(meter)','color','k','fontsize',15);
% zlabel('z��(meter)','color','k','fontsize',15);

    
    

