function [T] = SDHfkinefunc(Q)
%…Ë÷√≤Œ ˝
a2=-0.2035;a3=-0.17442;d1=0.1205;d2=0;d3=0;d4=0.08009;
d5=0.08009;%d6=0.04436;
q1=Q(1);
q2=Q(2);
q3=Q(3);
q4=Q(4);
q5=Q(5);
q6=Q(6);

T01 = [cos(q1) 0 sin(q1) 0;sin(q1) 0 -cos(q1) 0;0 1 0 d1;0 0 0 1];
T12 = [cos(q2) -sin(q2) 0 a2*cos(q2);sin(q2) cos(q2) 0 a2*sin(q2);0 0 1 0;0 0 0 1];
T23 = [cos(q3) -sin(q3) 0 a3*cos(q3);sin(q3) cos(q3) 0 a3*sin(q3);0 0 1 0;0 0 0 1];
T34 = [cos(q4) 0 sin(q4) 0;sin(q4) 0 -cos(q4) 0;0 1 0 d4;0 0 0 1];
T45 = [cos(q5) 0 -sin(q5)  0;sin(q5) 0 cos(q5) 0;0 -1 0 d5;0 0 0 1];
T56 = [cos(q6) -sin(q6) 0 0;sin(q6) cos(q6) 0 0;0 0 1 0;0 0 0 1];
T06 = T01*T12*T23*T34*T45*T56;
T=T06;
end

