clear;
clc;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.5, 'alpha', 0,'offset',pi/2);
L3 = Link('d', 0, 'a', 0, 'alpha', pi/2,'offset',pi/4);
L4 = Link('d', 1, 'a', 0, 'alpha', -pi/2);
L5 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L6 = Link('d', 1, 'a', 0, 'alpha', 0);
b=isrevolute(L1);  %Link �ຯ��
robot=SerialLink([L1,L2,L3,L4,L5,L6]);   %SerialLink �ຯ��
robot.name='������������˱�';
robot.comment='Ʈ�����';
robot.display();  %Link �ຯ��
theta=[0 0 0 0 0 0];
robot.plot(theta);   %SerialLink �ຯ��