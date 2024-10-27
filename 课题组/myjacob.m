function [J] = myjacob(Q)
%标准型雅可比矩阵求解
%5.23,已验证正确性，与GluonSDH中用工具箱的jacob0结果一致
a2=-0.2035;a3=-0.17442;d1=0.1205;d4=0.08009;
d5=0.08009;
q1=Q(1);
q2=Q(2);
q3=Q(3);
q4=Q(4);
q5=Q(5);
q6=Q(6);
%求运动学正解
T01 = [cos(q1) 0 sin(q1) 0;sin(q1) 0 -cos(q1) 0;0 1 0 d1;0 0 0 1];
T12 = [cos(q2) -sin(q2) 0 a2*cos(q2);sin(q2) cos(q2) 0 a2*sin(q2);0 0 1 0;0 0 0 1];
T23 = [cos(q3) -sin(q3) 0 a3*cos(q3);sin(q3) cos(q3) 0 a3*sin(q3);0 0 1 0;0 0 0 1];
T34 = [cos(q4) 0 sin(q4) 0;sin(q4) 0 -cos(q4) 0;0 1 0 d4;0 0 0 1];
T45 = [cos(q5) 0 -sin(q5)  0;sin(q5) 0 cos(q5) 0;0 -1 0 d5;0 0 0 1];
T56 = [cos(q6) -sin(q6) 0 0;sin(q6) cos(q6) 0 0;0 0 1 0;0 0 0 1];

k = [0; 0; 1];

%初始赋值
Jv = zeros(3, 6);
Jw = zeros(3, 6);
%获取每个关节原点与基座标的变换矩阵T01,T02...T06
T{6}=zeros(4);
T{1}=T01;
T{2}=T{1}*T12;
T{3}=T{2}*T23;
T{4}=T{3}*T34;
T{5}=T{4}*T45;
T{6}=T{5}*T56;

%进行矢量积求解
for i = 1: 6
   if i == 1
       R = eye(3);
       p_im = T{6}(1: 3, 4);
   else
       R = T{i-1}(1: 3, 1: 3);
       p_im = T{6}(1: 3, 4) - T{i-1}(1: 3, 4);
   end
   
   zi_1 = R * k;
   Jv(:, i) = cross(zi_1, p_im);
   Jw(:, i) = zi_1;
end

% 组合
J = [Jv; Jw];

end

