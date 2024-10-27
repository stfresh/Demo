function [y] = TouchXfkine(Q)
%TouchX正向运动学 6.8 改进型
d4=0.13335;d6=0.03;a2=0.13335;
q1=Q(1);q2=Q(2);q3=Q(3);q4=Q(4);q5=Q(5);q6=Q(6);
T01=[cos(q1) -sin(q1) 0 0;sin(q1) cos(q1) 0 0;0 0 1 0;0 0 0 1];
T12=[cos(q2) -sin(q2) 0 0;0 0 -1 0;sin(q2) cos(q2) 0 0;0 0 0 1];
T23=[cos(q3) -sin(q3) 0 a2;sin(q3) cos(q3) 0 0;0 0 1 0;0 0 0 1];
T34=[cos(q4) -sin(q4) 0 0;0 0 -1 -d4;sin(q4) cos(q4) 0 0;0 0 0 1];
T45=[cos(q5) -sin(q5) 0 0;0 0 -1 0;sin(q5) cos(q5) 0 0;0 0 0 1];
T56=[cos(q6) -sin(q6) 0 0;0 0 1 d6;-sin(q6) -cos(q6) 0 0;0 0 0 1];

T06=T01*T12*T23*T34*T45*T56;
y=T06;
end

