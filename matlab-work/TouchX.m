clc;
clear;
%建立连杆   theta d a alpah
L(1)=Link([0,0,0,0],'modified');
L(2)=Link([0,0,0,pi/2],'modified');
L(3)=Link([0,0,0.13335,0],'modified');
L(4)=Link([0,0.13335,0,pi/2],'modified');
L(5)=Link([0,0,0,pi/2],'modified');
L(6)=Link([0,0.03,0,-pi/2],'modified');
%设置关节变量变化范围
L(1).qlim=[-0.98,0.98];
L(2).qlim=[0,1.78];
L(3).qlim=[0,1.25];
L(4).qlim=[-2.50,2.53];
L(5).qlim=[-0.5,1.75];
L(6).qlim=[-2.58,2.58];

%设置偏置
L(1).offset=0;
L(2).offset=0;
L(3).offset=0;
L(4).offset=0;
L(5).offset=0;
L(6).offset=0;
touchX = SerialLink([L(1),L(2),L(3),L(4),L(5),L(6)],'name','touchX01');
