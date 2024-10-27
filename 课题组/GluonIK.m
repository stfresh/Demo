function [Jd] = GluonIK(Td)
%本函数用来求解Gluon机械臂的逆解
%Td为输入的期望位姿矩阵，Jd为输出的期望关节角
%关节角限制
% q1:(-2.45,2.45);
% q2:(-1.58,1.58);
% q3:(-2.45,2.45);
% q4:(-2.45,2.45);
% q5:(-2.45,2.45);
% q6:(-6.19,6.19);

d1 = 0.1205;d2 = 0.080113;d3 = -0.0845; d4 = -0.08009; d5 = -0.08009;d6 = -0.04436;
a2 = 0.2035; a3 = 0.17442; 

nx = Td(1,1);ox = Td(1,2);ax = Td(1,3);px = Td(1,4);
ny = Td(2,1);oy = Td(2,2);ay = Td(2,3);py = Td(2,4);
nz = Td(3,1);oz = Td(3,2);az = Td(3,3);pz = Td(3,4);
% fprintf('%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f',nx,ox,ax,px,ny,oy,ay,py,nz,oz,az,pz);

%求解q1,有两个解
j1a=py-d6*ay;
j1b=ax*d6-px;
j11=atan2(d4-d3-d2,sqrt(j1a^2+j1b^2-(d4-d3-d2)^2))-atan2(j1a,j1b);
j12=atan2(d4-d3-d2,-sqrt(j1a^2+j1b^2-(d4-d3-d2)^2))-atan2(j1a,j1b);

%q1知道了，那么q5也有了,反解acos有正负,单独处理j5*出现为零的情况，因为后面它需要作为分母
j51=acos(ay*cos(j11)-ax*sin(j11));
j52=-acos(ay*cos(j11)-ax*sin(j11));

j53=acos(ay*cos(j12)-ax*sin(j12));
j54=-acos(ay*cos(j12)-ax*sin(j12));

%求q6
j61=atan2(oy*cos(j11)-ox*sin(j11),-(ny*cos(j11)-nx*sin(j11)));
j62=atan2(oy*cos(j12)-ox*sin(j12),-(ny*cos(j12)-nx*sin(j12)));
fprintf('%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f ',j51,j52,j53,j54,j11,j12);

%这里我们先记录下q2,q3,q4的关系，t=q2+q3-q4注意！！！sin(j5*)可能为零，即j5*=0或pi
%选j11，q5可选j51和j52
t1=atan2(az/sin(j51),(ax*cos(j11)+ay*sin(j11))/sin(j51));
t2=atan2(az/sin(j52),(ax*cos(j11)+ay*sin(j11))/sin(j52));
%选j12，q5可选j53和j54
t3=atan2(az/sin(j53),(ax*cos(j12)+ay*sin(j12))/sin(j53));
t4=atan2(az/sin(j54),(ax*cos(j12)+ay*sin(j12))/sin(j54));
%------------------------------------------------------------------------------------------------------------------------------------------到这里为止，应该都没有问题

%求q3和q4，目前只找到fsolve算法，由于涉及q1和q5，那么下面就有四种情况，注意！！！q1选定了，那么q5也定了（但有两种），同时q6也定了（和q1一样）
%方程为：a2cos(q3-q4)+a3cos(q4)=A ----①
%       a2sin(q3-q4)-a3sin(q4)=B -----②

%数值法：---------------------------------------------------------------------------------------------------------------
%一、先计算出常数
%二、带入fsolve计算                 !!!感觉这个解法有问题,不要了！

%①q1=j11,q5=j51 t1
% A1=0.5*px*(cos(j11-t1)+cos(j11+t1))+0.5*py*(sin(j11-t1)+sin(j11+t1))+sin(t1)*(pz-d1)-d6*sin(j51);
% B1=0.5*py*(cos(j11-t1)-cos(j11+t1))-0.5*px*(sin(j11-t1)-sin(j11+t1))+cos(t1)*(d1-pz)-d5;
% 
% [x1]=solveq34(a2,a3,A1,B1);
% j31=x1(1);
% j41=x1(2);
% 
% %②q1=j11,q5=j52 t2
% A2=0.5*px*(cos(j11-t2)+cos(j11+t2))+0.5*py*(sin(j11-t2)+sin(j11+t2))+sin(t2)*(pz-d1)-d6*sin(j52);
% B2=0.5*py*(cos(j11-t2)-cos(j11+t2))-0.5*px*(sin(j11-t2)-sin(j11+t2))+cos(t2)*(d1-pz)-d5;
% 
% [x2]=solveq34(a2,a3,A2,B2);
% j32=x2(1);
% j42=x2(2);
% 
% %③q1=j12,q5=j53 t3
% A3=0.5*px*(cos(j12-t3)+cos(j12+t3))+0.5*py*(sin(j12-t3)+sin(j12+t3))+sin(t3)*(pz-d1)-d6*sin(j53);
% B3=0.5*py*(cos(j12-t3)-cos(j12+t3))-0.5*px*(sin(j12-t3)-sin(j12+t3))+cos(t3)*(d1-pz)-d5;
% 
% [x3]=solveq34(a2,a3,A3,B3);
% j33=x3(1);
% j43=x3(2);
% 
% %④q1=j12,q5=j54 t4
% A4=0.5*px*(cos(j12-t4)+cos(j12+t4))+0.5*py*(sin(j12-t4)+sin(j12+t4))+sin(t4)*(pz-d1)-d6*sin(j54);
% B4=0.5*py*(cos(j12-t4)-cos(j12+t4))-0.5*px*(sin(j12-t4)-sin(j12+t4))+cos(t4)*(d1-pz)-d5;
% 
% [x4]=solveq34(a2,a3,A4,B4);
% j34=x4(1);
% j44=x4(2);
%---------------------------------------------------------------------------------------------------------------------
%解析法：①^2+②^2 = a2^2+2*a2*a3*cos(q3)+a3^2 =A^2+B^2
%q3=±acos((A^2+B^2-a2^2-a3^2)/2*a2*a3)

%1、同样的先算出常数A、B
%2、反函数求解

%①q1=j11,q5=j51 t1
A1=0.5*px*(cos(j11-t1)+cos(j11+t1))+0.5*py*(sin(j11-t1)+sin(j11+t1))+sin(t1)*(pz-d1)-d6*sin(j51);
B1=0.5*py*(cos(j11-t1)-cos(j11+t1))-0.5*px*(sin(j11-t1)-sin(j11+t1))+cos(t1)*(d1-pz)-d5;
%q3
K1=(A1^2+B1^2-a2^2-a3^2)/(2*a2*a3);

j31=acos(K1);
j32=-acos(K1);
%q4 关于求q4，得到q3后我们对① ②式展开将q3带入，得到：
%(a2*cos(q3)+a3)*cos(q4)+(a2*sin(q3))*sin(q4)=A
%(a2*sin(q3))*cos(q4)-(a2*cos(q3)+a3)*sin(q4)=B
%m1*cos(q4)+n1*sin(q4)=A
%n1*cos(q4)-m1*sin(q4)=B
%解得：
%cos(q4)=(B*n1+A*m1)/(m1^2+n1^2)
%sin(q4)=(A*n1-B*m1)/(m1^2+n1^2)
%q4=atan2((A*n1-B*m1)/(m1^2+n1^2),(B*n1+A*m1)/(m1^2+n1^2))
m1=a2*cos(j31)+a3;
n1=a2*sin(j31);
j41=atan2((A1*n1-B1*m1)/(m1^2+n1^2),(B1*n1+A1*m1)/(m1^2+n1^2));
j21=t1-j31+j41;

m2=a2*cos(j32)+a3;
n2=a2*sin(j32);
j42=atan2((A1*n2-B1*m2)/(m2^2+n2^2),(B1*n2+A1*m2)/(m2^2+n2^2));
j22=t1-j32+j42;



%q4 在这里没用atan2求q4，因为这样会出现16个解，不知道为什么，所以换成了asin---------------------
% j41=atan2(A1,sqrt((a2*cos(j31)+a3)^2+(a2*sin(j31))^2-A1^2))-atan2(a2*cos(j31)+a3,a2*sin(j31));
% j21=t1-j31+j41;
% 
% j42=atan2(A1,-sqrt((a2*cos(j31)+a3)^2+(a2*sin(j31))^2-A1^2))-atan2(a2*cos(j31)+a3,a2*sin(j31));
% j22=t1-j31+j42;

% j42=atan2(A1,sqrt((a2*cos(j32)+a3)^2+(a2*sin(j32))^2-A1^2))-atan2(a2*cos(j32)+a3,a2*sin(j32));
% j22=t1-j32+j42;

% j41=asin(A1/sqrt((a2*cos(j31)+a3)^2+(a2*sin(j31))^2))-atan2(a2*cos(j31)+a3,a2*sin(j31));
% j21=t1-j31+j41;
% 
% j42=asin(A1/sqrt((a2*cos(j32)+a3)^2+(a2*sin(j32))^2))-atan2(a2*cos(j32)+a3,a2*sin(j32));
% j22=t1-j32+j42;
%-------------------------------------------------------------------------------------------------

% %②q1=j11,q5=j52 t2
A2=0.5*px*(cos(j11-t2)+cos(j11+t2))+0.5*py*(sin(j11-t2)+sin(j11+t2))+sin(t2)*(pz-d1)-d6*sin(j52);
B2=0.5*py*(cos(j11-t2)-cos(j11+t2))-0.5*px*(sin(j11-t2)-sin(j11+t2))+cos(t2)*(d1-pz)-d5;
%q3
K2=(A2^2+B2^2-a2^2-a3^2)/(2*a2*a3);
j33=acos(K2);
j34=-acos(K2);

m3=a2*cos(j33)+a3;
n3=a2*sin(j33);
j43=atan2((A2*n3-B2*m3),(B2*n3+A2*m3));
j23=t2-j33+j43;

m4=a2*cos(j34)+a3;
n4=a2*sin(j34);
j44=atan2((A2*n4-B2*m4)/(m4^2+n4^2),(B2*n4+A2*m4)/(m4^2+n4^2));
j24=t3-j34+j44;

%q4
% j43=asin(A2/sqrt((a2*cos(j33)+a3)^2+(a2*sin(j33))^2))-atan2(a2*cos(j33)+a3,a2*sin(j33));
% j23=t2-j33+j43;
% j44=asin(A2/sqrt((a2*cos(j34)+a3)^2+(a2*sin(j34))^2))-atan2(a2*cos(j34)+a3,a2*sin(j34));
% j24=t2-j34+j44;


% %③q1=j12,q5=j53 t3
A3=0.5*px*(cos(j12-t3)+cos(j12+t3))+0.5*py*(sin(j12-t3)+sin(j12+t3))+sin(t3)*(pz-d1)-d6*sin(j53);
B3=0.5*py*(cos(j12-t3)-cos(j12+t3))-0.5*px*(sin(j12-t3)-sin(j12+t3))+cos(t3)*(d1-pz)-d5;
%q3
K3=(A3^2+B3^2-a2^2-a3^2)/(2*a2*a3);
j35=acos(K3);
j36=-acos(K3);
%q4
j45=asin(A3/sqrt((a2*cos(j35)+a3)^2+(a2*sin(j35))^2))-atan2(a2*cos(j35)+a3,a2*sin(j35));
j25=t3-j35+j45;

j46=asin(A3/sqrt((a2*cos(j36)+a3)^2+(a2*sin(j36))^2))-atan2(a2*cos(j36)+a3,a2*sin(j36));
j26=t3-j36+j46;



% %④q1=j12,q5=j54 t4
A4=0.5*px*(cos(j12-t4)+cos(j12+t4))+0.5*py*(sin(j12-t4)+sin(j12+t4))+sin(t4)*(pz-d1)-d6*sin(j54);
B4=0.5*py*(cos(j12-t4)-cos(j12+t4))-0.5*px*(sin(j12-t4)-sin(j12+t4))+cos(t4)*(d1-pz)-d5;
%q3
K4=(A4^2+B4^2-a2^2-a3^2)/(2*a2*a3);
j37=acos(K4);
j38=-acos(K4);
%q4
j47=asin(A4/sqrt((a2*cos(j37)+a3)^2+(a2*sin(j37))^2))-atan2(a2*cos(j37)+a3,a2*sin(j37));
j27=t4-j37+j47;

j48=asin(A4/sqrt((a2*cos(j38)+a3)^2+(a2*sin(j38))^2))-atan2(a2*cos(j38)+a3,a2*sin(j38));
j28=t4-j38+j48;


% %求q2,可以用t1和t2求。q2=t*-q3+q4  一共四个解
% %①t1
% j21=t1-j31+j41;  
% 
% %②t2
% j22=t2-j32+j42;
% 
% %③t2
% j23=t3-j33+j43;
% 
% %④t2
% j24=t4-j34+j44;

%%%%%%%%%%%%%%%%%%%%%%%%%%%至此，全部关节求完，进行组合
Jd=[j11 j21 j31 j41 j51 j61;
    j11 j22 j32 j42 j51 j61;
    j11 j23 j33 j43 j52 j61;
    j11 j24 j34 j44 j52 j61;
    j12 j25 j35 j45 j53 j62;
    j12 j26 j36 j46 j53 j62;
    j12 j27 j37 j47 j54 j62;
    j12 j28 j38 j48 j54 j62;
     ];

end

