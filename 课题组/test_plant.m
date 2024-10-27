function [sys,x0,str,ts]=test_plant(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global p
sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 202;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;

sys=simsizes(sizes);
x0=[1 0 0 1];
str=[];
ts=[];
%²ÎÊýparameter a b c d e
p=[5.4 2.3 2.3 30.38 22.54];

function sys=mdlDerivatives(t,x,u)
global p
M=[p(1)+p(2)*cos(x(3)) p(3)+0.5*p(2)*cos(x(3));
   p(3)+0.5*p(2)*cos(x(3)) p(3)];
Vdq=[-p(2)*sin(x(3))*(x(2)*x(4)+0.5*x(4)^2);
    0.5*p(2)*sin(x(3))*x(2)^2];
G=[p(4)*cos(x(1))+p(5)*cos(x(3));
   p(5)*cos(x(1)+x(3))];
F=[0.4*x(2);0.4*x(4)];

tol=u(1:2);
% dq=[x(2);x(4)];

%[ddq1;ddq2];
S=M\(tol-Vdq-G-F);

sys(1)=x(2);
sys(2)=S(1);
sys(3)=x(4);
sys(4)=S(2);
function sys=mdlOutputs(t,x,u)
sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);

