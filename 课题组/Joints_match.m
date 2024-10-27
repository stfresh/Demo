%�������ؿ��巨�Ի����˵Ĺ����ռ�������
%�������ӻ��͵���ͼ
%using Robotics Toolbox 10.3.1
clc;
% clear;
%��׼�� ��������   theta d a alpah   d6=0.04436;�����0
L(1)=Link([0,0.1205,0,pi/2],'standard');
L(2)=Link([0,0,-0.2035,0],'standard');
L(3)=Link([0,0,-0.17442,0],'standard');
L(4)=Link([0,0.08009,0,pi/2],'standard');
L(5)=Link([0,0.08009,0,-pi/2],'standard');
L(6)=Link([0,0,0,0],'standard');

%���ñ�׼��ƫ��
L(1).offset=0;
L(2).offset=-pi/2;
L(3).offset=0;
L(4).offset=-pi/2;
L(5).offset=0;
L(6).offset=0;

gluon = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','gluon01');
%teach(gluon); ʾ�̲��ֿ�ѡ
% robot.plot([0,0,0,0,0,0]);
% hold on;

%����TouchX�������ؽڽǷ�Χ
theta1min=-0.98;theta1max=0.98;
theta2min=0;theta2max=1.75;
theta3min=-0.81;theta3max=1.25;
theta4min=-2.35;theta4max=2.53;
theta5min=-0.5;theta5max=1.75;
theta6min=-2.58;theta6max=2.58;

%�����������
n = 50000;
%���ڼ�¼ĩ�˵��x,y,zֵ
XJ = zeros(n,1);
YJ = zeros(n,1);
ZJ = zeros(n,1);


for i = 1:n  %ѭ��3000�Σ�rand���ڲ���0~1�������

%�����ǹؽ�ƥ�䲿�ֵĹؽڽ�,qtΪtouchX�ǣ�qsΪGluon��������
% qs1 = 2.49qt1;
% qs2 = 1.794qt2 - 1.57;
% qs3 = 2.37qt3 - 0.521;
% qs4 = qt4 - 0.09;
% qs5 = 2.169qt5 - 1.355;
% qs6 = 1.198qt6;
    q1=2.49*(theta1min + (theta1max-theta1min)*rand);
    q2=1.794*(theta2min + (theta2max-theta2min)*rand) - 1.57;
    q3=2.37*(theta3min + (theta3max-theta3min)*rand) - 0.521;
    q4=theta4min + (theta4max-theta4min)*rand-0.09;
    q5=2.169*(theta5min + (theta5max-theta5min)*rand) - 1.355;
    q6=1.198*(theta6min + (theta6max-theta6min)*rand);

    %robot.plot([q1,q2,q3,q4,q5,q6]);%������ʾ,�ɲ���
    
    trans = gluon.fkine([q1,q2,q3,q4,q5,q6]);%���
    %trans�����ĸ�����t��n��o��a
    %trans = [ n o a t ],����ȡ���ĸ�λ������ 
    XJ(i) = trans.t(1);
    YJ(i) = trans.t(2);
    ZJ(i) = trans.t(3);
    %plot3(trans.t(1),trans.t(2),trans.t(3),'b.','MarkerSize',0.5);  
    %hold on;
end
%�����������
figure('color',[1 1 1]);
plot3(XJ,YJ,ZJ,'r.','MarkerSize',0.5);
hold on;
xlabel('x��(meter)','color','k','fontsize',15);
ylabel('y��(meter)','color','k','fontsize',15);
zlabel('z��(meter)','color','k','fontsize',15);

    
    

