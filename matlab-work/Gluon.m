clc;
clear;
%建立连杆   theta d a alpah
L(1)=Link([0,0.10503,0,0],'modified');
L(2)=Link([0,0.080113,0,pi/2],'modified');
L(3)=Link([0,0,0.17447,0],'modified');
L(4)=Link([0,0.0044,0.17442,pi],'modified');
L(5)=Link([0,-0.08009,0,-pi/2],'modified');
L(6)=Link([0,-0.04436,0,pi/2],'modified');
%设置关节变量变化范围
L(1).qlim=[-2.44,2.44];
L(2).qlim=[-pi/2,pi/2];
L(3).qlim=[-2.44,2.44];
L(4).qlim=[-2.44,2.44];
L(5).qlim=[-2.44,2.44];
L(6).qlim=[-2*pi,2*pi];

%设置偏置
L(1).offset=pi/2;
L(2).offset=pi/2;
L(3).offset=0;
L(4).offset=pi/2;
L(5).offset=0;
L(6).offset=0;
gluon = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','test01');
