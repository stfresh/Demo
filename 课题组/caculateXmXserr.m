%calculate the xm_xs err

%-----------------------------------before ��һ��Ϊxm,��xm����ʱ���ģ��ڶ���Ϊxs
bx_err = 0;
bforce_err = 0;
ax_err = 0;
aforce_err = 0;
%����λ�����
for i = 2001 : 5000  %ȡ3000��������
    bx_err = bx_err + abs( out.beforeXm_Xs.signals.values(i,1)-out.beforeXm_Xs.signals.values(i,2));
end
bx_err = bx_err / 3000;
%�������������
for i = 2001 : 5000  
    bforce_err = bforce_err + abs( out.before_force.signals.values(i,1)-out.before_force.signals.values(i,2));
end
bforce_err = bforce_err / 3000;

%---------------------------------after correction
%����λ�����
for i = 2001 : 5000  %ȡ3000��������
    ax_err = ax_err + abs( out.afterXm_Xs.signals.values(i,1)-out.afterXm_Xs.signals.values(i,2));
end
ax_err = ax_err / 3000;
%�������������
for i = 2001 : 5000  
    aforce_err = aforce_err + abs( out.after_force.signals.values(i,1)-out.after_force.signals.values(i,2));
end
aforce_err = aforce_err / 3000;
