function [x] = solveq34(a2,a3,A,B)
%     % ���庯����������㷽������������̵�ֵ
    equations = @(x) [a2*cos(x(1)-x(2))+a3*cos(x(2))-A; a2*sin(x(1)-x(2))-a3*sin(x(2))-B];
%     % ʹ��fsolve������ⷽ����
    x = fsolve(equations, [0;0]);

% %     % ���庯����������㷽������������̵�ֵ
%     equations = @(x) [a2*x(1)+a3*x(2)-A; a2*x(1)-a3*x(2)-B];
% %     % ʹ��fsolve������ⷽ����
%     x = fsolve(equations, [0;0]);
end

