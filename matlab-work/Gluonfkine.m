%4.21 代值验证运动学方程是没错的，能算出和示教一样的位置
%4.25 再次验证，我的运动学方程是没错的！
% syms q1 q2 q3 q4 q5 q6 d1 d2 a2 a3 d3 d4 d5 d6;
q1=pi/2;q2=0;q3=pi/2;q4=0;q5=pi/2;q6=0;
a2=0.2035;a3=0.17442;d1=0.1205;d2=0.080113;d3=-0.0845;d4=-0.08009;
d5=-0.08009;d6=-0.04436;

% T = [nx ox ax px;ny oy ay py;nz oz az pz;0 0 0 1];
%syms nx ox ax px ny oy ay py nz oz az pz
T{6}=zeros(4);
%不带偏置的角度
T01 = [cos(q1) -sin(q1) 0 0;sin(q1) cos(q1) 0 0;0 0 1 d1;0 0 0 1];
T12 = [cos(q2) -sin(q2) 0 0;0 0 -1 -d2;sin(q2) cos(q2) 0 0;0 0 0 1];
T23 = [cos(q3) -sin(q3) 0 a2;sin(q3) cos(q3) 0 0;0 0 1 d3;0 0 0 1];
T34 = [cos(q4) -sin(q4) 0 a3;-sin(q4) -cos(q4) 0 0;0 0 -1 -d4;0 0 0 1];
T45 = [cos(q5) -sin(q5) 0 0;0 0 1 d5;-sin(q5) -cos(q5) 0 0;0 0 0 1];
T56 = [cos(q6) -sin(q6) 0 0;0 0 -1 -d6;sin(q6) cos(q6) 0 0;0 0 0 1];
T{1}=T01;
T{2}=T{1}*T12;
T{3}=T{2}*T23;
T{4}=T{3}*T34;
T{5}=T{4}*T45;
T{6}=T{5}*T56;
% res = simplify(T06);