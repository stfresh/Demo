%RBFѵ�� p26 3-5-2 ��ģ
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
b=10;                    %��ֵ

xs=[1 0 0];               %Ideal input
ys=[1 0];                 %Ideal output
OUT=2;                     %˫���
NS=1;                     %ѵ��������

k=0;

E=1.0;
while E>=1e-20
    k=k+1;
    times(k)=k;
    
    for s=1:1:NS
        x=xs(s,:);   %ȡ���ݼ���һ����Ϊ����
     for j=1:1:5
         h(j)=exp(-norm(x'-c(:,j)).^2/(2*b.^2));
     end
   yl=W'*h;                %��һ��ʵ�����
   
   el=0;
   y=ys(s,:);
   for l=1:1:OUT
       el=el+0.5*(y(l)-yl(l))^2;   %���������������ÿ�����ݼ����ܵ����
   end
   
   es(s)=el;  %��¼ÿ�����ݼ��������
   
  E=0;      %�������������ݼ������
  if s==NS
      for s=1:1:NS
          E=E+es(s);
      end
  end
  error=y-yl';% 2��1
  dW=xite*h*error;        %[5��1]��[1��2]=[5��2]
  W=W_1+dW+alfa*(W_1-W_2);
  W_2=W_1;W_1=W;
    end
    Ek(k)=E;    %��¼ÿ�ε��������仯
end
figure(1);
plot(times,Ek,'r','linewidth',2);
xlabel('k');ylabel('Error index change');
save wfile b c W;

    
  
   
   
   
   
    
      

