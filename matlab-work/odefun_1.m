function dy=odefun_1(t,y);
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=-1.1*y(1)-y(1)^3-0.4*y(2)+0.620*cos(1.8*t);
end
