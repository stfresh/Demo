%x_1i =  A*arctan(s_1i)+B
%s_1i = tan[(x_1i -  B)/A]
function [sys,x0,str,ts]=constraint_plant(t,x,u,flag)
switch flag
case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
case 3
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
global p g l1 l2 up_delat low_delat A B
up_delat = [1.1,1.4];    %关节1和关节2的上下限
low_delat = [-1.1,-1.4];
A=(up_delat - low_delat) /2;  %A和B为转换系数
B=(up_delat + low_delat) /2;

%p为对象参数
m1 = 0.316;  %unit is 'kg' 
m2 = 0.323;

l1 = 1.04;  %unit is 'm'
l2 = 0.96;  % li is the length of ith link i
lc1 = 1/2 * l1; % lci the center of mass to joint of ith link
lc2 = 1/2 * l2;

I1 = 0.16;% ;  % moment of inertial  unit: kgm^2
I2 = 0.07;%;

g = 9.8;

p(1) = m1 * lc1.^2 + m2 * l1^2 + I1;
p(2) = m2 *lc2.^2 + I2;
p(3) = m2 * l1 * lc2;
p(4) = m1 * lc2 + m2 * l1;
p(5) = m2 * lc2;

sizes = simsizes;
sizes.NumContStates  = 4;  %6个状态q1 dq1 q2 dq2 
sizes.NumDiscStates  = 0;  % x(1)=q1 x(2)=dq1 x(3)=q2 x(4)=dq2
sizes.NumOutputs     = 4;   %4个输出，q1,dq1,q2,dq2  
sizes.NumInputs      = 3;   %tau +num_node
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0.8 0 0.5 0];      %六个初始状态 [q1,dq1,q2,dq2]
str=[];
ts=[];


function sys=mdlDerivatives(t,x,u)
global p g l1 l2
q1=x(1);
q2=x(3);
dq1=x(2);
dq2=x(4);
dq=[dq1;dq2];

J=[-l1*sin(q1)-l2*sin(q1+q2)  -l2*sin(q1+q2);  
    l1*cos(q1)+l2*cos(q1+q2)  l2*cos(q1+q2) ];

M=[p(1)+p(2)+2*p(3)*cos(x(3)) p(2)+p(3)*cos(x(3));
    p(2)+p(3)*cos(x(3)) p(2)];
C=[-p(3)*x(4)*sin(x(3)) -p(3)*(x(2)+x(4))*sin(x(3));
    p(3)*x(2)*sin(x(3))  0];
G=[p(4)*g*cos(x(1)) + p(5)*g*cos(x(1)+x(3)); p(5)*g*cos(x(1)+x(3))];

Fe=[0;0];

%得到的力矩
tol=u(1:2);


ddq=M\(tol-C*dq-G-J'*Fe);

sys(1)=x(2);
sys(2)=ddq(1);
sys(3)=x(4);
sys(4)=ddq(2);
% sys(5)=1/A*(1+s(1)*s(1))*x(2);
% sys(6)=1/A*(1+s(2)*s(2))*x(4);

function sys=mdlOutputs(t,x,u)
sys(1)=x(1);    %q1
sys(2)=x(3);    %q2
sys(3)=x(2);    %dq1
sys(4)=x(4);    %dq2

