function [sys,x0,str,ts] = test_chushihua(t,x,u,flag)

switch flag
case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
case 3
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
global node center

center = [1,2,3];
node = size(center,2);
sizes = simsizes;
sizes.NumContStates  = node;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = zeros(1,node);
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u)
global node center
center(:,4)=node;
    sys(1:node)=0;
node = node + 1;


function sys=mdlOutputs(t,x,u)
global node center
sys(1)=center(size(center,2));
sys(2) = node;

