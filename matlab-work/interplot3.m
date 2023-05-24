
%三次多项式插值法
clear;
clc;
q_array=[0,50,150,100,0];%指定起止位置
t_array=[0,2,4,8,10];%指定起止时间
v_array=[0,10,20,-15,0];%指定起止速度
t=[t_array(1)];q=[q_array(1)];v=[v_array(1)];a=[0];%初始状态
for i=1:1:length(q_array)-1%每一段规划的时间
     a0=q_array(i);
     a1=v_array(i);
     a2=(3/(t_array(i+1)-t_array(i))^2)*(q_array(i+1)-q_array(i))-(1/(t_array(i+1)-t_array(i)))*(2*v_array(i)+v_array(i+1));
     a3=(2/(t_array(i+1)-t_array(i))^3)*(q_array(i)-q_array(i+1))+(1/(t_array(i+1)-t_array(i))^2)*(v_array(i)+v_array(i+1));
     ti=t_array(i)+0.001:0.001:t_array(i+1);
     qi=a0+a1*(ti-t_array(i))+a2*(ti-t_array(i)).^2+a3*(ti-t_array(i)).^3;
     vi=a1+2*a2*(ti-t_array(i))+3*a3*(ti-t_array(i)).^2;
     ai=2*a2+6*a3*(ti-t_array(i));
     t=[t,ti];q=[q,qi];v=[v,vi];a=[a,ai];
end
subplot(3,1,1),plot(t,q,'r'),xlabel('t/s'),ylabel('p/m');hold on; plot(t_array,q_array,'o','color','r'),grid on;
subplot(3,1,2),plot(t,v,'b'),xlabel('t/s'),ylabel('v/(m/s)');hold on;plot(t_array,v_array,'*','color','r'),grid on;
subplot(3,1,3),plot(t,a,'g'),xlabel('t/s'),ylabel('a/(m/s^2)');hold on;