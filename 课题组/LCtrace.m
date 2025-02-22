function [U_trace,H_Z_nn,H_Z] = LCtrace(t,y,k)
global Pattern

C=Pattern{k,2};  % 读取相应模式的控制增益
W_mean=Pattern{k,3};  % 读取相应模式的神经网络权值向量
center=Pattern{k,4};  % 读取相应模式的神经元中心
width=Pattern{k,5};  % 读取相应模式的神经元宽度

l1=1;l2=1;m1=0.8;m2=2.3;g0=9.8;
a=l2^2*m2+l1^2*(m1+m2);
b=2*l1*l2*m2;
c=l2^2*m2;
d=(m1+m2)*l1*g0;
e=m2*l2*g0;

C1=C(1);C2=C(2);

U_trace=zeros(length(t),2);
H_Z_nn=zeros(length(t),2);
H_Z=zeros(length(t),2);

for i=1:length(t),
    X1=y(i,1:2)'; X2=y(i,3:4)';
    Yd=y(i,5:6)';DYd=y(i,7:8)';
    
    q1=X1(1);q2=X1(2);
    dq1=X2(1);dq2=X2(2);
    M=[a+b*cos(q2),c+b/2*cos(q2);c+b/2*cos(q2),c];
    Vm_X2=[-b*sin(q2)*(dq1*dq2+0.5*dq2^2);0.5*b*sin(q2)*dq1^2];
    G=[d*cos(q1)+e*cos(q2);e*cos(q1+q2)];
    F=[0.4*dq1;0.4*dq2];
    
    D2Yd=-0.5*Yd-1.5*DYd+2*sin(1.5*t(i));
    
    Z1=X1-Yd;
    A1=-C1*Z1+DYd;
    DA1=-C1*(X2-DYd)+D2Yd;

    Z2=X2-A1;
    S_Z=phi([X1;X2;DA1], center, width);
    U=M*(-Z1-C2*Z2-W_mean'*S_Z);
    U_trace(i,:)=U';
    
    H_Z_nn(i,:)=(W_mean'*S_Z)';
    H_Z(i,:)=-(M\(Vm_X2+G+F)+DA1)';
end
end