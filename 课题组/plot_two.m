function plot_two(x,y1,y2,label_x,label_y,legend_y,ylabel_position)
figure
%设置图窗属性
set(gcf,'PaperUnits','inches','PaperPosition',[100 100 520 440],'PaperPositionMode','auto');
%获取图窗属性
% set(gcf)
subplot(2,1,1)
set(gcf,'DefaultTextInterpreter','latex' )
plot(x,y1,'linewidth',1)
%不需要两个X轴标签
% xlabel(label_x);
ylabel(label_y(1),'position',ylabel_position(1,:));
if legend_y ~= ""
   legend(legend_y(1),legend_y(2)) 
end
set (gca,'position',[0.1,0.6,0.8,0.39],'fontsize',12,'linewidth',0.5) 

subplot(2,1,2)
set(gcf,'DefaultTextInterpreter','latex' )
plot(x,y2,'linewidth',1);
xlabel(label_x);
ylabel(label_y(2),'position',ylabel_position(2,:)) 
if legend_y ~= ""
    %,'interpreter','latex'
   legend(legend_y(3),legend_y(4))
end
set (gca,'position',[0.1,0.12,0.8,0.39] ,'fontsize',12,'linewidth',0.5)
end

