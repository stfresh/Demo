%W*S'����W��S��Ϊ������
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
%���ĵ�
% [D1,D2,D3,D4]=ndgrid(-1:1:1,-1.5:1:1.5,-1:1:1,-1:1:1);
% center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
%     reshape(D4,1,[]);];
[D1,D2,D3,D4,D5,D6]=ndgrid(-1:1:1,-1.5:1:1.5,-1:1:1,-1:1:1,-1:1:1,-1:1:1);
center=[reshape(D1,1,[]);reshape(D2,1,[]);reshape(D3,1,[]);
    reshape(D4,1,[]);reshape(D5,1,[]);reshape(D6,1,[]);];
broad_center = zeros(size(center,1),600);     % ��������磬��ʼ������600��,����������Ϊ6ά��[x11,x12,x21,x22,d_alpha1,d_alpha2]
broad_center(:,1:3) = center(:,1:3);    %��ʼǰ�������ĵ㸳��ֵ
num_bnode = 3;                          %���NN�Ľڵ���,��ʼΪ3��
node_size=size(broad_center,2);
S=zeros(1,node_size);
b=[1.2;1;1;1;1;1];
delta=0.001; %��ֹȨֵƯ�Ƶĸ�����
Gamma=diag([10  10]); %���������ϵ��
C2=diag([12  10]);



sizes = simsizes;
sizes.NumContStates  = node_size*2;     %2��Ȩֵ�����ýڵ�
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;% tau + node_num
sizes.NumInputs      = 12;  %Z1,Z2,d_Alpha,X1,X2
sizes.DirFeedthrough = 1;   %0 ��ʾû�У����û��ڱ�д mdlOutputs �Ӻ���ʱȷ���Ӻ����� sys �������������u��
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = zeros(1,node_size*2);%��ʼ��������Ȩֵ��Ϊ0
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u)
global node_size delta b broad_center num_bnode S Gamma
Z2=[u(3);u(4)];
d_Alpha =[u(5);u(6)];

X1=[u(9);u(10)];
X2=[u(11);u(12)];

%���������������
Psi=[X1' X2' d_Alpha']';
% Psi=[X1' X2']';
%����ǰ���������ĵ�
newCenter = addNewNode(Psi,3,broad_center,0.5,0.5); 
%�½ڵ㲻Ϊ��
if size(newCenter,1) ~= 0 
    if num_bnode + 1 <= node_size
        num_bnode = num_bnode + 1;
        broad_center(:,num_bnode) = newCenter;
    end
end

for j=1:1:num_bnode                 %���NN�ڵ��������
   input_error = ((Psi-broad_center(:,j)).^2)'*(1./b.^2);
   S(1,j)=exp(-input_error);
end


%����Ӧ�ɸ���---------------------���NN
W1=x(1:node_size)'; %����Ǳ����������   1~600Ϊ��һ��tau��Ȩֵ��601~1200�ǵڶ���tau��Ȩֵ
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
%��̬�ƽ�����
Ta=[W1*S';W2*S'];

%����ƽ����
% e_RBF=M*ddqr+C*dqr+G-Ta;
%�������
Tau=-gamma*Z1-C2*Z2;
sys(1)=Tau(1);
sys(2)=Tau(2);
sys(3)=num_bnode;




