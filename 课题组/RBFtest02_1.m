%RBFÑµÁ· p26 3-5-2 
close all;
load wfile b c W;

x=[0.970 0.001 0.001;
    1.000 0.000 0.000];
NS=2;
h=zeros(5,1);

for i=1:1:NS
    for j=1:1:5
        h(j)=exp(-norm(x(i,:)'-c(:,j)).^2/(2*b.^2));
    end
    y1(i,:)=W'*h;
end



    
  
   
   
   
   
    
      

