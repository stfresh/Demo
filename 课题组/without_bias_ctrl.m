%W*S'����W��S��Ϊ������
function [sys,x0,str,ts] = without_bias_ctrl(t,x,u,flag)

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
global node gamma1 gamma2 delta b K1 K2 center p Td g broad_center num_bnode S
%����
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
%���ĵ�
% [D1,D2,D3,D4,D5,D6]=ndgrid(-1:1:1,-1:1:1,-1:1:1,-1:1:1,-1:1:1,-1:1:1);
[D1,D2,D3,D4,D5,D6]=ndgrid(-1:1:1,-1:1:1,-1:1:1,-1:1:1,-1:1:1,-1:1:1);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[])];
% node=size(center,2);
broad_center = zeros(6,1000);     % ��������磬��ʼ������300��
broad_center(:,1:3) = center(:,1:3);    %��ʼǰ�������ĵ㸳��ֵ
num_bnode = 3;                          %���NN�Ľڵ���
node=size(broad_center,2);
S=zeros(1,node);
b=[0.8;0.8;0.8;0.8;0.9;1];
delta=0.001; %��ֹȨֵƯ�Ƶĸ�����
gamma1=4; % for updating Weight
gamma2=4; % for updating Weight
K2=1*diag([50  5]);
K1=0.5*diag([20  15]);

sizes = simsizes;
sizes.NumContStates  = node*2;     %2��Ȩֵ�����ýڵ�
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;%��ʱ�������tau,��2��RBF�ƽ����
sizes.NumInputs      = 10;%�������6�������켣q1,q2��λ�á��ٶȡ����ٶȺͶ��������ؽڵ�ʵ��λ�á��ٶ����
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,node*2);%��ʼ��������Ȩֵ��Ϊ0
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
global node gamma1 gamma2 delta b K1 center broad_center num_bnode S
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



%���������������
Z=[X1' dqr' ddqr']';
%����ǰ���������ĵ�
newCenter = addNewNode(Z,3,broad_center,0.5,1); 
%�½ڵ㲻Ϊ��
if size(newCenter,1) ~= 0 
    if num_bnode + 1 <= 1000                                %----------------------����ҲҪ����Ƚڵ�Ĵ�С
        num_bnode = num_bnode + 1;
        broad_center(:,num_bnode) = newCenter;
    end
end
%������Ԫ�����
% S=zeros(1,node);
% for j=1:1:node
%    % S(1,j)=exp(-norm(Z-center(:,j))^2/(b*b));
%    input_error = ((Z-center(:,j)).^2)'*(1./b.^2);
%    S(1,j)=exp(-input_error);
% end


for j=1:1:num_bnode                 %���NN�ڵ��������
   input_error = ((Z-broad_center(:,j)).^2)'*(1./b.^2);
   S(1,j)=exp(-input_error);
end

%����Ӧ�ɸ���---------------------���NN
W1=x(1:node)'; %����Ǳ����������   1~300Ϊ��һ��tau��Ȩֵ��301~600�ǵڶ���tau��Ȩֵ
norm_W1=norm(W1);
W2=x(node+1:2*node)';
norm_W2=norm(W2);
%���Ʒ�����С
if(norm_W1>14)
    sys(1:node)=gamma1*(S*r(1)-delta*W1);      %����ֻ����ǰnum_bnode��Ȩֵ         
    
else
     sys(1:node)=gamma1*S*r(1);  
end

if(norm_W2>10)
   sys(1+node:2*node)=gamma2*(S*r(2)-delta*W2);
    
else
     sys(1+node:2*node)=gamma2*S*r(2);  
end

% -----------------------------------------------����Ϊ���Ȳ���
% %����Ӧ�ɸ���
% W1=x(1:node)'; %����Ǳ����������
% norm_W1=norm(W1);
% W2=x(node+1:2*node)';
% norm_W2=norm(W2);
% %���Ʒ�����С
% if(norm_W1>14)
%     sys(1:node)=gamma1*(S*r(1)-delta*W1);             
%     
% else
%      sys(1:node)=gamma1*S*r(1);  
% end
% 
% if(norm_W2>10)
%    sys(1+node:2*node)=gamma2*(S*r(2)-delta*W2);
%     
% else
%      sys(1+node:2*node)=gamma2*S*r(2);  
% end





function sys=mdlOutputs(t,x,u)
global node K2 K1 Td p g num_bnode S
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

W1=x(1:node)';
W2=x(node+1:2*node)';
%����ƽ����
Ta=[W1*S';W2*S'];

l1 = 0.35;  %unit is 'm'
l2 = 0.31;  % li is the length of ith link i
M=[p(1)+p(2)+2*p(3)*cos(x2) p(2)+p(3)*cos(x2);
    p(2)+p(3)*cos(x2) p(2)];
% C=[-p(3)*d_x2*sin(x2) -p(3)*(d_x1+d_x2)*sin(x2);
%     p(3)*d_x1*sin(x2)  0];
G=[p(4)*g*cos(x1) + p(5)*g*cos(x1+x2); p(5)*g*cos(x1+x2)];
J=[-l1*sin(x1)-l2*sin(x1+x2)  -l2*sin(x1+x2);  l1*cos(x1)+l2*cos(x1+x2)  l2*cos(x1+x2) ];
% if t>100
%     Td=J'*[0,8]';
% end

% d_x1=dqr(1); %C1(q,dqr)*dqr
% d_x2=dqr(2);
C1=[-p(3)*dqr(2)*sin(x2) -p(3)*(dqr(1)+dqr(2))*sin(x2);
    p(3)*dqr(1)*sin(x2)  0];

%����ƽ����
e_RBF=M*ddqr+C1*dqr+G+Td-Ta;
%�������
Tau=K2*r+Ta;

sys(1)=Tau(1);
sys(2)=Tau(2);
sys(3)=e_RBF(1);
%sys(4)=e_RBF(2);
sys(4)=num_bnode;
% sys(5:34)=x(node-29:node);
% sys(35:64)=x(2*node-29:2*node);



