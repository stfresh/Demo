% clc;
% clear;
%��������   theta d a alpah   d6=0.04436;�����0
L(1)=Link([0,0.1205,0,pi/2],'standard');
L(2)=Link([0,0,-0.2035,0],'standard');
L(3)=Link([0,0,-0.17442,0],'standard');
L(4)=Link([0,0.08009,0,pi/2],'standard');
L(5)=Link([0,0.08009,0,-pi/2],'standard');
L(6)=Link([0,0,0,0],'standard');
%���ùؽڱ����仯��Χ
L(1).qlim=[-2.44,2.44];
L(2).qlim=[-pi/2,pi/2];
L(3).qlim=[-2.44,2.44];
L(4).qlim=[-2.44,2.44];
L(5).qlim=[-2.44,2.44];
L(6).qlim=[-2*pi,2*pi];

%����ƫ��
L(1).offset=0;
L(2).offset=-pi/2;
L(3).offset=0;
L(4).offset=-pi/2;
L(5).offset=0;
L(6).offset=0;
gluonSDH = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','Gluon');
light('Position',[0.5,0.5,0.5],'color','w');