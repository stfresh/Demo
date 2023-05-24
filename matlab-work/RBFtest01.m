%RBF逼近仿真，采用2-5-1
close all;


%% 定义变量以及初始化
alfa=0.05;
xite=0.15;
x=[0,1]';

b=3*ones(5,1);
c=[-1 -0.5 0 0.5 1;
    -1 -0.5 0 0.5 1];
w=rands(5,1);        %初始权重

w_1=w;w_2=w_1;
c_1=c;c_2=c_1;
b_1=b;b_2=b_1;
d_w=0*w;
d_b=0*b;
y_1=0;               %初始时刻有y（k-1）=0
ts=0.001;

%% 进入大循环
%  time=zero(1,10000);
%  u=zero(1,10000);
%  y=zero(1,10000);
%  d_c=zero(2,5);
%  h=zero(5,1);
for k=1:1:10000
   
    time(k)=k*ts;
    u(k)=sin(k*ts);
    
    y(k)=u(k)^3+y_1/(1+y_1^2);
    
    x(1)=u(k);
    x(2)=y_1;
 % 计算h(j)
  for j=1:1:5
      h(j)=exp(-norm(x-c(:,j)).^2/(2*b(j)*b(j)));
  end
 ym(k)=w'*h';
 em(k)=y(k)-ym(k);
 
 M=2;
 if M==2           %only weight value update
     for j=1:1:5
         d_w(j)=xite*em(k)*h(j);
     end
 elseif M==2      %Update w,b,c
     for j=1:1:5
         d_w(j)=xite*em(k)*h(j);
         d_b(j)=xite*em(k)*w(j)*h(j)*(b(j).^(-3))*norm(x-c(:,j).^2);
         for i=1:1:2
             d_c(i,j)=xite*em(k)*w(j)*h(j)*(x(i)-c(i,j))*(b(j).^(-2));
         end
     end
  b=b_1+d_b+alfa*(b_1-b_2);
  c=c_1+d_c+alfa*(c_1-c_2);
 end
 
 w=w_1+d_w+alfa*(w_1-w_2);
 
 y_1=y(k);         %重新幅值给下一个时刻，作为RBF的第二个输入
 
 w_2=w_1;           %延续权值
 w_1=w;
 
 c_2=c_1;          %延续中心点
 c_1=c;
 
 b_2=b_1;           %延续宽度
 b_1=b;
 
end     %结束一次迭代

%% 画图

figure(1);
subplot(2,1,1);
plot(time,y,'r',time,ym,'k:','linewidth',2);
xlabel('time(s)');ylabel('y and ym');
legend('ideal signal','signal approximation');

subplot(2,1,2);
plot(time,y-ym,'k','linewidth',2);
xlabel('time(s)');ylabel('error');
legend('traking error');


 
 
         
      
 
    

