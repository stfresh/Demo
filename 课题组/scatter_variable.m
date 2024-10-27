%% 原2018未修改
I=eye(2,2);
b = 1:1:200;
m = length(b);
K = 0.1:0.1:1;
len = length(K);
w=0:0.01:5;
n=length(w);

Ms = zeros(m,len,n); %有m行len列 个 n个列值

res = zeros(m*len,2); %收集结果存储（b，K）的值

%先算范数
for i = 1:m  %b
    for j=1:len  %K
        for k = 1:n  %w T = 1
            Hs=[b(i)*K(j) K(j)*exp(complex(0,-w(k)));-exp(complex(0,-w(k))) 1/b(i)];
            Ms(i,j,k)=norm([1 0;0 -1]*(Hs-I)/(Hs+I));
        end
    end
end

%判断范数是否都小于1,放入结果集
ansNum = 1;
for i = 1:m  %b
    for j=1:len  %K
        for k = 1:n  %w
            if Ms(i,j,k) > 1
                break;
            end
        end
        if k == n && Ms(i,j,k) <= 1
            res(ansNum,:) = [b(i);K(j)];
            ansNum = ansNum + 1;
        end
    end
end

%画图

test = zeros(1,n);
base = ones(1,501); 
plot(0:0.01:5,base,'r-.','LineWidth',1);
for j = 1:200
    for i = 1:n
        test(i) = Ms(j,10,i);
    end
    hold on;
    plot(0:0.01:5,test);
end
%% 对力反馈部分进行修改，Fm=Fs(t-T)+b*K*dxm
I=eye(2,2);
b = 1:1:200;
m = length(b);
K = 0.1:0.1:1;
len = length(K);
w=0:0.01:5;
n=length(w);

Ms = zeros(m,len,n); %有m行len列 个 n个列值

res = zeros(m*len,2); %收集结果存储（b，K）的值

%先算范数
for i = 1:m  %b
    for j=1:len  %K
        for k = 1:n  %w T = 2
            Hs=[b(i)*K(j) exp(complex(0,-2*w(k)));-exp(complex(0,-2*w(k))) K(j)/b(i)];
            Ms(i,j,k)=norm([1 0;0 -1]*(Hs-I)/(Hs+I));
        end
    end
end

%判断范数是否都小于1,放入结果集
ansNum = 1;
for i = 1:m  %b
    for j=1:len  %K
        for k = 1:n  %w
            if Ms(i,j,k) > 1
                break;
            end
        end
        if k == n && Ms(i,j,k) <= 1
            res(ansNum,:) = [b(i);K(j)];
            ansNum = ansNum + 1;
        end
    end
end

%画图
test = zeros(1,n);
base = ones(1,501);
plot(0:0.01:5,base,'r-.','LineWidth',1);
ylim([0.3,1.3]);
for j = 1:m
    for i = 1:n
        test(i) = Ms(j,10,i);
    end
    hold on;
    plot(0:0.01:5,test);
end

