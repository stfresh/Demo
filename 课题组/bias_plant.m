function [sys,x0,str,ts]=bias_plant(t,x,u,flag)
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
global p Td g 
%p为参数
%负载
Td=[0,0]';
m1 = 2;  %unit is 'kg' %The model is referred "Aptive Nerual Network Contol..." 
m2 = 0.85;

l1 = 0.35;  %unit is 'm'
l2 = 0.31;  % li is the length of ith link i
lc1 = 1/2 * l1; % lci the center of mass to joint of ith link
lc2 = 1/2 * l2;

I1 = 1/4*m1*l1^2;%1825795.31e-09 ;  % moment of inertial
I2 = 1/4*m2*l2^2;%26213426.68e-09 ;

g = 9.81;

p(1) = m1 * lc1.^2 + m2 * l1^2 + I1;
p(2) = m2 * lc2.^2 + I2;
p(3) = m2 * l1 * lc2;
p(4) = m1 * lc2 + m2 * l1;
p(5) = m2 * lc2;

sizes = simsizes;
sizes.NumContStates  = 4;  %4个连续状态的微分dp1 ddq1 dp2 ddq2
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;   %四个输出，q1,dq1,q2,dq2
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[0 0 0 0];      %四个初始状态为0？
str=[];
ts=[];


function sys=mdlDerivatives(t,x,u)
global p Td g
l1 = 0.35;  %unit is 'm'
l2 = 0.31;  % li is the length of ith link i
M=[p(1)+p(2)+2*p(3)*cos(x(3)) p(2)+p(3)*cos(x(3));
    p(2)+p(3)*cos(x(3)) p(2)];
C=[-p(3)*x(4)*sin(x(3)) -p(3)*(x(2)+x(4))*sin(x(3));
    p(3)*x(2)*sin(x(3))  0];
G=[p(4)*g*cos(x(1)) + p(5)*g*cos(x(1)+x(3)); p(5)*g*cos(x(1)+x(3))];
J=[-l1*sin(x(1))+l2*sin(x(1)+x(3))  -l2*sin(x(1)+x(3));  l1*cos(x(1))+l2*cos(x(1)+x(3))  l2*cos(x(1)+x(3)) ];

% if t>100
%     Td=J'*[0,8]';
% end
tol=u(1:2);
dq=[x(2);x(4)];

%[ddq1;ddq2];
ddq=M\(tol-C*dq-G-Td);

sys(1)=x(2);
sys(2)=ddq(1);
sys(3)=x(4);
sys(4)=ddq(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);

