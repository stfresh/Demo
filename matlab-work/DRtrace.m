function [U_trace,DA1_trace,H_Z] = DRtrace(t,y,C)

l1=1;l2=1;m1=0.8;m2=2.3;g0=9.8;
a=l2^2*m2+l1^2*(m1+m2);
b=2*l1*l2*m2;
c=l2^2*m2;
d=(m1+m2)*l1*g0;
e=m2*l2*g0;

C1=C(1);C2=C(2);

U_trace=zeros(length(t),2);
DA1_trace=zeros(length(t),2);
H_Z=zeros(length(t),2);

for i=1:length(t),
    X1=y(i,1:2)'; X2=y(i,3:4)';
    
    q1=X1(1);q2=X1(2);
    dq1=X2(1);dq2=X2(2);
    M=[a+b*cos(q2),c+b/2*cos(q2);c+b/2*cos(q2),c];
    Vm_X2=[-b*sin(q2)*(dq1*dq2+0.5*dq2^2);0.5*b*sin(q2)*dq1^2];
    G=[d*cos(q1)+e*cos(q2);e*cos(q1+q2)];
    F=[0.4*dq1;0.4*dq2];
    
Yd=[0.6-0.2*cos(pi*i/10);1.01+0.2*sin(pi*i/10)];
DYd=[0.2*pi*sin(pi*i/10);0.2*pi*cos(pi*i/10)];
D2Yd=[0.2*pi*pi*cos(pi*i/10);-0.2*pi*pi*sin(pi*i/10)];
    
    Z1=X1-Yd;
    A1=-C1*Z1+DYd;
    DA1=-C1*(X2-DYd)+D2Yd;
    DA1_trace(i,:)=DA1';

    Z2=X2-A1;
    U=-M*Z1+Vm_X2+G+F+M*DA1-C2*M*Z2;
    U_trace(i,:)=U';
    
    H_Z(i,:)=-(Vm_X2+G+F+M*DA1)';
end
end