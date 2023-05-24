%采用标准DH参数
syms q1 q2 q3 q4 q5 q6 d1 d2 a2 a3 d3 d4 d5 d6;
% q1=1.0669;q2=2.3566;q3=-pi/2;q4=2.3566;q5=1.2893;q6=pi/4;
% a2=-0.2035;a3=-0.17442;d1=0.1205;d2=0;d3=0;d4=0.08009;
% d5=0.08009;d6=0.04436;
syms nx ox ax px ny oy ay py nz oz az pz;
T = [nx ox ax px;ny oy ay py;nz oz az pz;0 0 0 1];


%不带偏置的角度,对应GluonSDH模型，这里先把d6设为0
T01 = [cos(q1) 0 sin(q1) 0;sin(q1) 0 -cos(q1) 0;0 1 0 d1;0 0 0 1];
T12 = [cos(q2) -sin(q2) 0 a2*cos(q2);sin(q2) cos(q2) 0 a2*sin(q2);0 0 1 0;0 0 0 1];
T23 = [cos(q3) -sin(q3) 0 a3*cos(q3);sin(q3) cos(q3) 0 a3*sin(q3);0 0 1 0;0 0 0 1];
T34 = [cos(q4) 0 sin(q4) 0;sin(q4) 0 -cos(q4) 0;0 1 0 d4;0 0 0 1];
T45 = [cos(q5) 0 -sin(q5)  0;sin(q5) 0 cos(q5) 0;0 -1 0 d5;0 0 0 1];
T56 = [cos(q6) -sin(q6) 0 0;sin(q6) cos(q6) 0 0;0 0 1 0;0 0 0 1];

T06 = T01*T12*T23*T34*T45*T56;
