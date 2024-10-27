% b = sym('b');
% sT=sym('sT');
% Hs = [b*tanh(sT) -sech(sT);sech(sT) tanh(sT)/b];
% I = eye(2);
% Ms = [1 0;0 -1]*(Hs - I)/(Hs + I);
%% basic
I=eye(2,2);
b = 1:1:200;
m = length(b);
w=0:0.01:5;
n=length(w);
Ms=zeros(m,n);
for i = 1:m  %b
    for k = 1:n  %w T = 1
        Hs = [0 complex(0,w(k));-complex(0,w(k)) 0];
        Ms(i,k)=norm([1 0;0 -1]*(Hs-I)/(Hs+I));
    end
end
for j = 1:m
    test=Ms(j,:);
    plot(w,test);
    hold on;
end
%% ÐÂ¿ò¼Ü

I=eye(2,2);
b = 1:1:200;
m = length(b);
w=0:0.01:5;
n=length(w);
Ms=zeros(m,n);
for i = 1:m  %b
    for k = 1:n  %w T = 
        Hs = [b(i)*(1-exp(complex(0,-2*w(k)))) exp(complex(0,-w(k))); -exp(complex(0,-w(k))) 1/b(i)];
        Ms(i,k)=norm([1 0;0 -1]*(Hs-I)/(Hs+I));
    end
end
base = ones(1,501); 
plot(0:0.01:5,base,'r-.','LineWidth',1);
ylabel("\textbf{$\Vert S(s) \Vert$}",'interpreter','latex','fontsize', 14);
xlabel("\textbf{$\omega/rad$}",'interpreter','latex','fontsize', 14);
annotation('textarrow',[0.461428571428571 0.385714285714286],...
    [0.876737226277371 0.812043795620437],'Color',[1 0 0],'String',"\textbf{$\Vert S(s)=1 \Vert$}",'interpreter','latex');
hold on;
for j = 1:m
    test=Ms(j,:);
    plot(w,test);
    hold on;
end