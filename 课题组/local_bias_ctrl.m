function [sys,x0,str,ts] = local_bias_ctrl(t,x,u,flag)

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
global node gamma1 gamma2 delta b K1 K2 center p Td g bl
bl=[0.047,0.047]; % prefect for approximation 局部偏置
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
%中心点
%测试当输入脱离RBF近似区域
% [D1,D2,D3,D4,D5,D6]=ndgrid(-10:1:-8,-10:1:-8,-10:1:-8,-10:1:-8,-10:1:-8,-10:1:-8);
[D1,D2,D3,D4,D5,D6]=ndgrid(-1:1:1,-1:1:1,-1:1:1,1.5:1:3.5,-1:1:1,-0.5:1:1.5);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
node=size(center,2);
%网络宽度，默认为1 ！！！网络宽度影响非常的大，之前用的0.25误差巨大
b=1;
delta=0.001; %防止权值漂移的附加项
gamma1=8; % for updating Weight
gamma2=4; % for updating Weight
K2=1*diag([10  5]);
K1=0.5*diag([10  5]);

sizes = simsizes;
sizes.NumContStates  = node*2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4+30*2; %暂时输出两个tau,加2个RBF逼近误差,再输出30个权值
sizes.NumInputs      = 10;%输出就是6个期望轨迹q1,q2的位置、速度、加速度和对象两个关节的实际位置、速度输出
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,node*2);%初始的神经网络权值
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
global node gamma1 gamma2 delta b K1 center bl
xd1=u(1);
d_xd1=u(2);
dd_xd1=u(3);
xd2=u(4);
d_xd2=u(5);
dd_xd2=u(6);

x1=u(7);
d_x1=u(8);
x2=u(9);
d_x2=u(10);

Xd=[xd1;xd2];
d_Xd=[d_xd1;d_xd2];
dd_Xd=[dd_xd1;dd_xd2];
X1=[x1;x2];
X2=[d_x1;d_x2];
e=Xd-X1;
de=d_Xd-X2;
r=de+K1*e;
dqr=d_Xd+K1*e;
ddqr=dd_Xd+K1*de;



%神经网络的输入向量
Z=[X1' dqr' ddqr']';
%计算神经元的输出
S=zeros(1,node);
for j=1:1:node
    S(1,j)=exp(-norm(Z-center(:,j))^2/(b*b));%行向量
end
SL=[S+bl(1);S+bl(2)];
%自适应律更新
W1=x(1:node)';
norm_W1=norm(W1);
W2=x(node+1:2*node)';
norm_W2=norm(W2);
%限制范数大小
sys(1:node)=gamma1*SL(1,:)*r(1);
if(norm_W1>14)
    sys(1:node)=gamma1*(SL(1,:)*r(1)-delta*W1); 
end

sys(1+node:2*node)=gamma2*SL(2,:)*r(2);  
if(norm_W2>10)
   sys(1+node:2*node)=gamma2*(SL(2,:)*r(2)-delta*W2);
end





function sys=mdlOutputs(t,x,u)
global node K2 b K1 center  Td p g bl
xd1=u(1);
d_xd1=u(2);
dd_xd1=u(3);
xd2=u(4);
d_xd2=u(5);
dd_xd2=u(6);

x1=u(7);
d_x1=u(8);
x2=u(9);
d_x2=u(10);

Xd=[xd1;xd2];
d_Xd=[d_xd1;d_xd2];
dd_Xd=[dd_xd1;dd_xd2];
X1=[x1;x2];
X2=[d_x1;d_x2];
e=Xd-X1;
de=d_Xd-X2;
r=de+K1*e;
dqr=d_Xd+K1*e;
ddqr=dd_Xd+K1*de;

%神经网络的输入向量
Z=[X1' dqr' ddqr']';
%计算神经元的输出
S=zeros(1,node);
for j=1:1:node
    S(1,j)=exp(-norm(Z-center(:,j))^2/(b*b));
end
SL=[S+bl(1);S+bl(2)];

W1=x(1:node)';
W2=x(node+1:2*node)';
%计算逼近输出
Ta=[W1*SL(1,:)';W2*SL(2,:)'];

l1 = 0.35;  %unit is 'm'
l2 = 0.31;  % li is the length of ith link i
M=[p(1)+p(2)+2*p(3)*cos(x2) p(2)+p(3)*cos(x2);
    p(2)+p(3)*cos(x2) p(2)];
% C=[-p(3)*d_x2*sin(x2) -p(3)*(d_x1+d_x2)*sin(x2);
%     p(3)*d_x1*sin(x2)  0];
G=[p(4)*g*cos(x1) + p(5)*g*cos(x1+x2); p(5)*g*cos(x1+x2)];
J=[-l1*sin(x1)+l2*sin(x1+x2)  -l2*sin(x1+x2);  l1*cos(x1)+l2*cos(x1+x2)  l2*cos(x1+x2) ];
% if t>100
% %     Td=J'*[0,8]';
% end

d_x1=dqr(1); %C1(q,dqr)*dqr
d_x2=dqr(2);
C1=[-p(3)*d_x2*sin(x2) -p(3)*(d_x1+d_x2)*sin(x2);
    p(3)*d_x1*sin(x2)  0];

%计算逼近误差
e_RBF=M*ddqr+C1*dqr+G+Td-Ta;
%输出力矩
Tau=K2*r+Ta;

sys(1)=Tau(1);
sys(2)=Tau(2);
sys(3)=e_RBF(1);
sys(4)=e_RBF(2);
sys(5:34)=x(node-29:node);
sys(35:64)=x(2*node-29:2*node);



