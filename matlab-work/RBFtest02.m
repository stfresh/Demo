%RBF训练 p26 3-5-2 建模
close all;

xite=0.10;
alfa=0.05;

W=rands(5,2);
W_1=W;
W_2=W_1;
h=[0 0 0 0 0]';

c=2*[-0.5 -0.25 0 0.25 0.5;
    -0.5 -0.25 0 0.25 0.5;
    -0.5 -0.25 0 0.25 0.5];
b=10;                    %恒值

xs=[1 0 0];               %Ideal input
ys=[1 0];                 %Ideal output
OUT=2;                     %双输出
NS=1;                     %训练数据组

k=0;

E=1.0;
while E>=1e-20
    k=k+1;
    times(k)=k;
    
    for s=1:1:NS
        x=xs(s,:);   %取数据集的一行作为输入
     for j=1:1:5
         h(j)=exp(-norm(x'-c(:,j)).^2/(2*b.^2));
     end
   yl=W'*h;                %第一组实际输出
   
   el=0;
   y=ys(s,:);
   for l=1:1:OUT
       el=el+0.5*(y(l)-yl(l))^2;   %俩个输出，所以算每次数据集的总的误差
   end
   
   es(s)=el;  %记录每次数据集的总误差
   
  E=0;      %最终误差，所有数据集的误差
  if s==NS
      for s=1:1:NS
          E=E+es(s);
      end
  end
  error=y-yl';% 2×1
  dW=xite*h*error;        %[5×1]×[1×2]=[5×2]
  W=W_1+dW+alfa*(W_1-W_2);
  W_2=W_1;W_1=W;
    end
    Ek(k)=E;    %记录每次迭代的误差变化
end
figure(1);
plot(times,Ek,'r','linewidth',2);
xlabel('k');ylabel('Error index change');
save wfile b c W;

    
  
   
   
   
   
    
      

