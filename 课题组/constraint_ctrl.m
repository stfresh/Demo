%W*S'文中W和S均为行向量
function [sys,x0,str,ts] = constraint_ctrl(t,x,u,flag)

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
global node_size center p g broad_center num_bnode l1 l2 b S delta C2 Gamma
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
p(2) = m2 * lc2.^2 + I2;
p(3) = m2 * l1 * lc2;
p(4) = m1 * lc2 + m2 * l1;
p(5) = m2 * lc2;
%中心点
% [D1,D2,D3,D4]=ndgrid(-1:1:1,-1.5:1:1.5,-1:1:1,-1:1:1);
% center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
%     reshape(D4,1,[]);];
[D1,D2,D3,D4,D5,D6]=ndgrid(-1:1:1,-1.5:1:1.5,-1:1:1,-1:1:1,-1:1:1,-1:1:1);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[]);];
broad_center = zeros(size(center,1),600);     % 宽度神经网络，初始化上限600个,神经网络输入为6维吧[x11,x12,x21,x22,d_alpha1,d_alpha2]
broad_center(:,1:3) = center(:,1:3);    %初始前三个中心点赋初值
num_bnode = 3;                          %宽度NN的节点数,初始为3个
node_size=size(broad_center,2);
S=zeros(1,node_size);
b=[1.2;1;1;1;1;1];
delta=0.001; %防止权值漂移的附加项
Gamma=diag([10  10]); %神经网络更新系数
C2=diag([12  10]);



sizes = simsizes;
sizes.NumContStates  = node_size*2;     %2份权值，共用节点
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;% tau + node_num
sizes.NumInputs      = 12;  %Z1,Z2,d_Alpha,X1,X2
sizes.DirFeedthrough = 1;   %0 表示没有，即用户在编写 mdlOutputs 子函数时确保子函数的 sys 不出现输入变量u；
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,node_size*2);%初始的神经网络权值都为0
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
global node_size delta b broad_center num_bnode S Gamma
Z2=[u(3);u(4)];
d_Alpha =[u(5);u(6)];

X1=[u(9);u(10)];
X2=[u(11);u(12)];

%神经网络的输入向量
Psi=[X1' X2' d_Alpha']';
% Psi=[X1' X2']';
%计算前增加新中心点
newCenter = addNewNode(Psi,3,broad_center,0.5,0.5); 
%新节点不为空
if size(newCenter,1) ~= 0 
    if num_bnode + 1 <= node_size
        num_bnode = num_bnode + 1;
        broad_center(:,num_bnode) = newCenter;
    end
end

for j=1:1:num_bnode                 %宽度NN节点输出计算
   input_error = ((Psi-broad_center(:,j)).^2)'*(1./b.^2);
   S(1,j)=exp(-input_error);
end


%自适应律更新---------------------宽度NN
W1=x(1:node_size)'; %这就是变成行向量了   1~600为第一个tau的权值，601~1200是第二个tau的权值
W2=x(node_size+1:2*node_size)';
sys(1:node_size)=Gamma(1)*(S*Z2(1)-delta*W1);             
sys(1+node_size:2*node_size)=Gamma(2)*(S*Z2(2)-delta*W2);


function sys=mdlOutputs(t,x,u)
global node_size num_bnode S C2
Z1=[u(1);u(2)];
Z2=[u(3);u(4)];
gamma=diag([u(7) u(8)]);

W1=x(1:node_size)';
W2=x(node_size+1:2*node_size)';
%动态逼近计算
Ta=[W1*S';W2*S'];

%计算逼近误差
% e_RBF=M*ddqr+C*dqr+G-Ta;
%输出力矩
Tau=-gamma*Z1-C2*Z2;
sys(1)=Tau(1);
sys(2)=Tau(2);
sys(3)=num_bnode;




