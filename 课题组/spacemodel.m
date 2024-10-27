function [sys,x0,str,ts,simStateCompliance] = spacemodel(t,x,u,flag)


switch flag,

  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
 
  case 1,
    sys=mdlDerivatives(t,x,u);

  case 3,
    sys=mdlOutputs(t,x,u);
    
  case{2,4,9}
        sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end


function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes


sizes = simsizes;

sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;   

sys = simsizes(sizes);

x0  = [0];


str = [];


ts  = [];

simStateCompliance = 'UnknownSimState';


function sys=mdlDerivatives(t,x,u)
xm=u(1);
dxm=u(2);
ddxm=u(3);
x1=u(4);
dx1=u(5);
e=x1-xm;
de=dx1-dxm;

nmn=6;
s=de+nmn*e;
v=ddxm-2*nmn*de-nmn^2*e;

gama=0.5;
sys(1)=-gama*v*s;

function sys=mdlOutputs(t,x,u)
xm=u(1);
dxm=u(2);
ddxm=u(3);
x1=u(4);
dx1=u(5);

e=x1-xm;
de=dx1-dxm;

nmn=6;

mp=x(1);
ut=mp*(ddxm-2*nmn*de-nmn^2*e);

sys(1)=mp;
sys(2)=ut;


