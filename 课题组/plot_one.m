function plot_one(x,y,label_x,label_y,legend_y,ylabel_position)
%生成一个图窗
figure
%设置图窗属性
set(gcf,'PaperUnits','inches','PaperPosition',[100 100 520 440],'PaperPositionMode','auto');
set(gcf,'DefaultTextInterpreter','latex' );

plot(x,y,'linewidth',1)
xlabel(label_x);
ylabel(label_y,'position',ylabel_position);
if legend_y ~= ""
   legend(legend_y) 
end
%设置坐标轴的位置
set (gca,'position',[0.15,0.15,0.8,0.8],'fontsize', 12,'linewidth',0.5)
end

