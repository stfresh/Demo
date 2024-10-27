function [U_trace,H_Z_nn,H_Z] = NNtrace(t,y,C,center,width)
% 
% l1=1;l2=1;m1=0.8;m2=2.3;g0=9.8;
% a=l2^2*m2+l1^2*(m1+m2);
% b=2*l1*l2*m2;
% c=l2^2*m2;
% d=(m1+m2)*l1*g0;
% e=m2*l2*g0;




l1=1;l2=1;
P=[1.66 0.42 0.63 3.75 1.25];
g=9.8;
L=[l1^2 l2^2 l1*l2 l1 l2];

pl=0.5;

M=P+pl*L;

C1=C(1);C2=C(2);

U_trace=zeros(length(t),2);
H_Z_nn=zeros(length(t),2);
H_Z=zeros(length(t),2);

for i=1:length(t),
    X1=y(i,1:2)'; X2=y(i,3:4)';
    x=y(i,1:2)'; dx=y(i,3:4)';
    
    W=reshape(y(i,5:end),[],2);
    
    Q=(x(1)^2+x(2)^2-l1^2-l2^2)/(2*l1*l2);
    
    q2=acos(Q);
    dq2=-1/sqrt(1-Q^2);

    A=x(2)/x(1);
    p1=atan(A);
    d_p1=1/(1+A^2);

    B=sqrt(x(1)^2+x(2)^2+l1^2-l2^2)/(2*l1*sqrt(x(1)^2+x(2)^2));
    p2=acos(B);
    d_p2=-1/sqrt(1-B^2);

    if q2>0
        q1=p1-p2;
        dq1=d_p1-d_p2;
    else
        q1=p1+p2;
        dq1=d_p1+d_p2;
    end
    q=[q1;q2];
    J=[-sin(q1)-sin(q1+q2) -sin(q1+q2);
    cos(q1)+cos(q1+q2) cos(q1+q2)];
    d_J=[-dq1*cos(q1)-(dq1+dq2)*cos(q1+q2) -(dq1+dq2)*cos(q1+q2);
        -dq1*sin(q1)-(dq1+dq2)*sin(q1+q2) -(dq1+dq2)*sin(q1+q2)];

    D=[M(1)+M(2)+2*M(3)*cos(q2) M(2)+M(3)*cos(q2);
        M(2)+M(3)*cos(q2) M(2)];
    C=[-M(3)*dq2*sin(q2) -M(3)*(dq1+dq2)*sin(q2);
        M(3)*dq1*sin(q2)  0];
    G=[M(4)*g*cos(q1)+M(5)*g*cos(q1+q2);
       M(5)*g*cos(q1+q2)];

    Dx=(inv(J))'*D*inv(J);
    Cx=(inv(J))'*(C-D*inv(J)*d_J)*inv(J);
    Gx=(inv(J))'*G;

    Yd=[1-0.2*cos((0.1*pi)*i/10);1+0.2*sin((0.1*pi)*i/10)];
    DYd=[0.2*(0.1*pi)*sin((0.1*pi)*i/10);0.2*(0.1*pi)*cos((0.1*pi)*i/10)];
    D2Yd=[0.2*(0.1*pi)^2*cos((0.1*pi)*i/10);-0.2*(0.1*pi)^2*sin((0.1*pi)*i/10)];
    
    Z1=X1-Yd;
    A1=-C1*Z1+DYd;
    DA1=-C1*(X2-DYd)+D2Yd;

    Z2=X2-A1;
    S_Z=phi([X1;X2;q], center, width);
    U=Dx*(-Z1-C2*Z2-W'*S_Z);
    U_trace(i,:)=U';
    
    H_Z_nn(i,:)=(W'*S_Z)';
    H_Z(i,:)=-(Dx\(Cx*dx+Gx)+DA1)';
end
end