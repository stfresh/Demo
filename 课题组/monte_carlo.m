%定义D-H参数
a2= 0.420;
a3= 0.375;
d2= 0.138+0.024;
d3=-0.127-0.024;
d4= 0.114+0.021;
d5= 0.114+0.021;
d6= 0.090+0.021;


%定义出XYZ的坐标值。
for i=1:100000
theta1=-pi   +2*pi*rand;
theta2=0     +2*pi*rand;
theta3=-(5/6)*pi+(5/3)*pi*rand;
theta4=-pi    +2*pi*rand;
theta5=-pi   +2*pi*rand;
theta6=-pi    +2*pi*rand;

x(i)= a2*cos(theta1)*cos(theta2)+a3*cos(theta1)*cos(theta2+theta3)-d5*cos(theta1)*sin(theta2+theta3+theta4)-sin(theta1)*(d2+d3+d4)-d6*(cos(theta5)*sin(theta1)-cos(theta1)*cos(theta2+theta3+theta4)*sin(theta5));
y(i)=d6*(cos(theta1)*cos(theta5)+cos(theta2+theta3+theta4)*sin(theta1)*sin(theta5))+a3*sin(theta1)*cos(theta2+theta3)-d5*sin(theta1)*sin(theta2+theta3+theta4)+cos(theta1)*(d2+d3+d4)+a2*cos(theta2)*sin(theta1);
z(i)=-a3*sin(theta2+theta3)-a2*sin(theta2)-d5*cos(theta2+theta3+theta4)-d6*sin(theta5)*sin(theta2+theta3+theta4);
end
plot3(x,y,z,'b.','MarkerSize',0.5)