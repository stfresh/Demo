function [sys,x0,str,ts] = test_ctrl(t,x,u,flag)

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
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
global node c_H1 c_H2 p c1 c2 b
[D1,D2,D3,D4,D5,D6]=ndgrid(-1.05:0.5:1.05,...
-1.05:0.5:1.05,...
-1.05:0.5:1.05,...
-1.05:0.5:1.05,...
-1.05:0.5:1.05,...
-1.05:0.5:1.05);
%中心点
c_H1=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
c_H2=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
node=size(c_H1,2);
%网络宽度
b=0.625;
p=1;
c1=1;
c2=16;
sizes = simsizes;
sizes.NumContStates  = node*2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 202;
sizes.NumInputs      = 10;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,node*2);
str = [];
ts  = [];
function sys=mdlDerivatives(t,x,u)
global node c_H1 c_H2 p c1 c2 b
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
Z1=X1-Xd;
alf1=-c1.*Z1+d_Xd;
Z2=X2-alf1;
d_alf1=-c1.*X2+c1.*d_Xd+dd_Xd;
%神经网络的输入向量
Z=[X1' X2' d_alf1']';

for j=1:1:node
    h1(j)=exp(-norm(Z-c_H1(:,j))^2/(b*b));
    h2(j)=exp(-norm(Z-c_H2(:,j))^2/(b*b));
end


%自适应增益矩阵
T1=7*eye(node);
T2=7*eye(node);

%自适应律更新
for i=1:1:node
    sys(i)=T1(i,i)*h1(i)*Z2(1);
    sys(i+node)=T2(i,i)*h2(i)*Z2(2);
end



function sys=mdlOutputs(t,x,u)
global node c_H1 c_H2 p c1 c2 b
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
Z1=X1-Xd;
alf1=-c1*Z1+d_Xd;
Z2=X2-alf1;
d_alf1=-c1*X2+c1*d_Xd+dd_Xd;
%神经网络的输入向量
Z=[X1' X2' d_alf1']';

for j=1:1:node
    h1(j)=exp(-norm(Z-c_H1(:,j))^2/(b*b));
    h2(j)=exp(-norm(Z-c_H2(:,j))^2/(b*b));
end
%选择输出权值,按这样说的话，系统的x()给的是按列，我们自己的h1(j)就是行向量
W1=[x(1:node)]';
W2=[x(node+1:node*2)]';

H1=W1*h1';
H2=W2*h2';
%估计的函数
H=[H1;H2];
%输出力矩
tol=-Z1-c2.*Z2-H-p*0.01.*Z2;
sys(1)=tol(1);
sys(2)=tol(2);
%各输出100个权值
for j=1:100
    sys(2+j)=W1(j);
    sys(102+j)=W2(j);
end

