function [sys,x0,str,ts] = plants(t,x,u,flag)


switch flag,


  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

 
  case 1,
    sys=mdlDerivatives(t,x,u);

  case 3,
    sys=mdlOutputs(t,x,u);
    
  case {2,4,9}
      sys=[];
      

 
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end


function [sys,x0,str,ts]=mdlInitializeSizes


sizes = simsizes;

sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   

sys = simsizes(sizes);

x0  = [0.5,0];


str = [];


ts  = [0 0];




function sys=mdlDerivatives(t,x,u)
m=1;
ut=u(2);
sys(1)=x(2);
sys(2)=1/m*ut;



function sys=mdlOutputs(t,x,u)

m=1;
sys(1)=x(1);
sys(2)=x(2);
sys(3)=m;





