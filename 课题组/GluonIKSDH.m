function [Jd] = GluonIKSDH(Td)
a2=-0.2035;a3=-0.17442;d1=0.1205;d2=0;d3=0;d4=0.08009;d5=0.08009;d6=0;
nx = Td(1,1);ox = Td(1,2);ax = Td(1,3);px = Td(1,4);
ny = Td(2,1);oy = Td(2,2);ay = Td(2,3);py = Td(2,4);
nz = Td(3,1);oz = Td(3,2);az = Td(3,3);pz = Td(3,4);

%q1
j11=atan2(py,px)+atan2(d4,sqrt(px^2+py^2-d4^2));
j12=atan2(py,px)+atan2(d4,-sqrt(px^2+py^2-d4^2));
%fprintf('%6.2f %6.2f \n',j11,j12);

%q5
j51=atan2(sqrt(1-(ax*sin(j11)-ay*cos(j11))^2),ax*sin(j11)-ay*cos(j11));
j52=atan2(-sqrt(1-(ax*sin(j11)-ay*cos(j11))^2),ax*sin(j11)-ay*cos(j11));
j53=atan2(sqrt(1-(ax*sin(j12)-ay*cos(j12))^2),ax*sin(j12)-ay*cos(j12));
j54=atan2(-sqrt(1-(ax*sin(j12)-ay*cos(j12))^2),ax*sin(j12)-ay*cos(j12));
%fprintf('%6.2f %6.2f %6.2f %6.2f\n ',j51,j52,j53,j54);

%q6
j61=atan2(-(ox*sin(j11)-oy*cos(j11))/sin(j51),(nx*sin(j11)-ny*cos(j11))/sin(j51));
j62=atan2(-(ox*sin(j11)-oy*cos(j11))/sin(j52),(nx*sin(j11)-ny*cos(j11))/sin(j52));
j63=atan2(-(ox*sin(j12)-oy*cos(j12))/sin(j53),(nx*sin(j12)-ny*cos(j12))/sin(j53));
j64=atan2(-(ox*sin(j12)-oy*cos(j12))/sin(j54),(nx*sin(j12)-ny*cos(j12))/sin(j54));
%fprintf('%6.2f %6.2f %6.2f %6.2f\n ',j61,j62,j63,j64);

%q234 用t表示，四种 q4=t*-q2-q3
% t1=atan2(az/sin(j51),(ax*cos(j11)+ay*sin(j11))/sin(j51));
% t2=atan2(az/sin(j52),(ax*cos(j11)+ay*sin(j11))/sin(j52));
% t3=atan2(az/sin(j53),(ax*cos(j12)+ay*sin(j12))/sin(j53));
% t4=atan2(az/sin(j54),(ax*cos(j12)+ay*sin(j12))/sin(j54));

%-----------------------------------------------------------------------------------------------------------------
%q3
%选j11和j51
m1=px*cos(j11)+py*sin(j11)-d5*(az/-sin(j51));
n1=pz-d1+d5*(ax*cos(j11)+ay*sin(j11))/-sin(j51);
k1=(m1^2+n1^2-a2^2-a3^2)/(2*a2*a3);
%如果k1大于1,我们就要舍去，并让2，3，4角为-1表示舍弃
if (k1 <= 1)
    j31=atan2(sqrt(1-k1^2),k1);
    j32=atan2(-sqrt(1-k1^2),k1);
    %q2
    s21=(n1*(a3*cos(j31)+a2)-m1*a3*sin(j31))/((a3*cos(j31)+a2)^2+(a3*sin(j31))^2);
    c21=(n1-s21*(a2+a3*cos(j31)))/(a3*sin(j31));
    s22=(n1*(a3*cos(j32)+a2)-m1*a3*sin(j32))/((a3*cos(j32)+a2)^2+(a3*sin(j32))^2);
    c22=(n1-s22*(a2+a3*cos(j32)))/(a3*sin(j32));
    j21=atan2(s21,c21);
    j22=atan2(s22,c22);
    %q4
    s41=cos(j21+j31)*(az/-sin(j51))-sin(j21+j31)*((ax*cos(j11)+ay*sin(j11))/-sin(j51));
    s42=cos(j22+j32)*(az/-sin(j51))-sin(j22+j32)*((ax*cos(j11)+ay*sin(j11))/-sin(j51));
    c41=((ax*cos(j11)+ay*sin(j11))/-sin(j51)+s41*sin(j21+j31))/cos(j21+j31);
    c42=((ax*cos(j11)+ay*sin(j11))/-sin(j51)+s42*sin(j22+j32))/cos(j22+j32);
    j41=atan2(s41,c41);
    j42=atan2(s42,c42);
%     j41=t1-j31-j21;
%     j42=t1-j32-j22;
else
    j31=-1;j21=-1;j41=-1;
    j32=-1;j22=-1;j42=-1;
end
%------------------------------------------------------------------------------------------------------------- 一轮结束
%-----------------------------------------------------------------------------------------------------------------二轮开始
%q3
%选j11和j52
m2=px*cos(j11)+py*sin(j11)-d5*(az/-sin(j52));
n2=pz-d1+d5*(ax*cos(j11)+ay*sin(j11))/-sin(j52);
k2=(m2^2+n2^2-a2^2-a3^2)/(2*a2*a3);
%如果k2大于1,我们就要舍去
if (k2 <= 1)
    j33=atan2(sqrt(1-k2^2),k2);
    j34=atan2(-sqrt(1-k2^2),k2);
    %q2
    s23=(n2*(a3*cos(j33)+a2)-m2*a3*sin(j33))/((a3*cos(j33)+a2)^2+(a3*sin(j33))^2);
    c23=(n2-s23*(a2+a3*cos(j33)))/(a3*sin(j33));
    s24=(n2*(a3*cos(j34)+a2)-m2*a3*sin(j34))/((a3*cos(j34)+a2)^2+(a3*sin(j34))^2);
    c24=(n2-s23*(a2+a3*cos(j34)))/(a3*sin(j34));
    j23=atan2(s23,c23);
    j24=atan2(s24,c24);
    %q4
    s43=cos(j23+j33)*(az/-sin(j52))-sin(j23+j33)*((ax*cos(j11)+ay*sin(j11))/-sin(j52));
    s44=cos(j24+j34)*(az/-sin(j52))-sin(j24+j34)*((ax*cos(j11)+ay*sin(j11))/-sin(j52));
    c43=((ax*cos(j11)+ay*sin(j11))/-sin(j52)+s43*sin(j23+j33))/cos(j23+j33);
    c44=((ax*cos(j11)+ay*sin(j11))/-sin(j52)+s44*sin(j24+j34))/cos(j24+j34);
    j43=atan2(s43,c43);
    j44=atan2(s44,c44);
%     j41=t1-j31-j21;
%     j42=t1-j32-j22;
else
    j33=-1;j23=-1;j43=-1;
    j34=-1;j24=-1;j44=-1;
end
%------------------------------------------------------------------------------------------------------------- 二轮结束

%-----------------------------------------------------------------------------------------------------------------三轮开始
%q3
%选j12和j53
m3=px*cos(j12)+py*sin(j12)-d5*(az/-sin(j53));
n3=pz-d1+d5*(ax*cos(j12)+ay*sin(j12))/-sin(j53);
k3=(m3^2+n3^2-a2^2-a3^2)/(2*a2*a3);
%如果k3大于1,我们就要舍去
if (k3 <= 1)
    j35=atan2(sqrt(1-k3^2),k3);
    j36=atan2(-sqrt(1-k3^2),k3);
    %q2    
    s25=(n3*(a3*cos(j35)+a2)-m3*a3*sin(j35))/((a3*cos(j35)+a2)^2+(a3*sin(j35))^2);
    c25=(n3-s25*(a2+a3*cos(j35)))/(a3*sin(j35));
    s26=(n3*(a3*cos(j36)+a2)-m3*a3*sin(j36))/((a3*cos(j36)+a2)^2+(a3*sin(j36))^2);
    c26=(n3-s26*(a2+a3*cos(j36)))/(a3*sin(j36));
    j25=atan2(s25,c25);
    j26=atan2(s26,c26);
    %q4
    s45=cos(j25+j35)*(az/-sin(j53))-sin(j25+j35)*((ax*cos(j12)+ay*sin(j12))/-sin(j53));
    s46=cos(j26+j36)*(az/-sin(j53))-sin(j26+j36)*((ax*cos(j12)+ay*sin(j12))/-sin(j53));
    c45=((ax*cos(j12)+ay*sin(j12))/-sin(j53)+s45*sin(j25+j35))/cos(j25+j35);
    c46=((ax*cos(j12)+ay*sin(j12))/-sin(j53)+s46*sin(j26+j36))/cos(j26+j36);
    j45=atan2(s45,c45);
    j46=atan2(s46,c46);
%     j45=t3-j35-j25;
%     j46=t3-j36-j26;
else
    j35=-1;j25=-1;j45=-1;
    j36=-1;j26=-1;j46=-1;
end
%------------------------------------------------------------------------------------------------------------- 三轮结束
%-----------------------------------------------------------------------------------------------------------------四轮开始
%q3
%选j12和j54
m4=px*cos(j12)+py*sin(j12)-d5*(az/-sin(j54));
n4=pz-d1+d5*(ax*cos(j12)+ay*sin(j12))/-sin(j54);
k4=(m4^2+n4^2-a2^2-a3^2)/(2*a2*a3);
%如果k4大于1,我们就要舍去
if (k4 <= 1)
    j37=atan2(sqrt(1-k4^2),k4);
    j38=atan2(-sqrt(1-k4^2),k4);
    %q2
    s27=(n4*(a3*cos(j37)+a2)-m4*a3*sin(j37))/((a3*cos(j37)+a2)^2+(a3*sin(j37))^2);
    c27=(n4-s27*(a2+a3*cos(j37)))/(a3*sin(j37));
    s28=(n4*(a3*cos(j38)+a2)-m4*a3*sin(j38))/((a3*cos(j38)+a2)^2+(a3*sin(j38))^2);
    c28=(n4-s28*(a2+a3*cos(j38)))/(a3*sin(j38));
    j27=atan2(s27,c27);
    j28=atan2(s28,c28);
    %q4
    s47=cos(j27+j37)*(az/-sin(j54))-sin(j27+j37)*((ax*cos(j12)+ay*sin(j12))/-sin(j54));
    s48=cos(j28+j38)*(az/-sin(j54))-sin(j28+j38)*((ax*cos(j12)+ay*sin(j12))/-sin(j54));
    c47=((ax*cos(j12)+ay*sin(j12))/-sin(j54)+s47*sin(j27+j37))/cos(j27+j37);
    c48=((ax*cos(j12)+ay*sin(j12))/-sin(j54)+s48*sin(j28+j38))/cos(j28+j38);
    j47=atan2(s47,c47);
    j48=atan2(s48,c48);
%     j45=t3-j35-j25;
%     j46=t3-j36-j26;
else
    j37=-1;j27=-1;j47=-1;
    j38=-1;j28=-1;j48=-1;
end
%------------------------------------------------------------------------------------------------------------- 四轮结束

%j1和j5的组合决定j6，j2跟着j3（j3有几种，j2就有几种），j3又跟着j1和j5（j1和j5得组合四种，j3取正负，一共8种）
%j11>j51>j61  j11>j52>j62 j12>j53>j63 j12>j54>j64
%j11>j51>j31  j11>j51>j32 j11>j52>j33 j11>j52>j34  j12>j53>j35  j12>j53>j36 j12>j54>j37 j12>j54>j38
%j31>j21 ……

%j3应该有八种，那么j2也有八种，j4
%---------------------对最后的解进行筛选
%对于q1，我们使用atan2，解的范围应该是[-pi,pi]，但是当实际角q1为负值时会出现求解的绝对值大于pi的情况，此时需要进行加减2pi处理
if j11>pi
    j11=j11-2*pi;
end
if j12>pi
    j12=j12-2*pi;
end
if j11<-pi
    j11=j11+2*pi;
end
if j12<-pi
    j12=j12+2*pi;
end
Jd=[j11 j21 j31 j41 j51 j61;
    j11 j22 j32 j42 j51 j61;
    j11 j23 j33 j43 j52 j62;
    j11 j24 j34 j44 j52 j62;
    j12 j25 j35 j45 j53 j63;
    j12 j26 j36 j46 j53 j63;
    j12 j27 j37 j47 j54 j64;
    j12 j28 j38 j48 j54 j64;];




end

