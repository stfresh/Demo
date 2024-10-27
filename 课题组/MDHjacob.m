function [J] = MDHjacob(Q)
%改进型雅可比矩阵求解，5.23 已验证正确性（实验了五组解，均与工具箱的jacob0相等，使用Gluon02模型）没问题！！！
%一些初始化工作
a2=0.2035;a3=0.17442;d1=0.1205;d2=0.080113;d3=-0.0845;d4=-0.08009;
d5=-0.08009;d6=-0.04436;
T{6}=zeros(4);
q1=Q(1);
q2=Q(2);
q3=Q(3);
q4=Q(4);
q5=Q(5);
q6=Q(6);

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

n = 6; % number of degrees of freedom
k = [0; 0; 1];

% preallocationg the Jacobian matrix
Jv = zeros(3, n);
Jw = zeros(3, n);

for i = 1: 6
   R = T{i}(1: 3, 1: 3);
   T_i_n = (inv(T{i})) * T{n};
   p_i_n = T_i_n(1: 3, 4);
   
   z_i = R * k;
   
   Jv(:, i) = cross(z_i, R*p_i_n);
   Jw(:, i) = z_i;
end

J = [Jv; Jw];

end

