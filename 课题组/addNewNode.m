%X:��ǰNN����
%n:����Ҫѡȡ�ĵ㼯��
%center:�������ĵ㼯��(ÿһ��Ϊһ���ڵ�)
%lambda:��ֵϵ��
%threshold:�Ƿ������½ڵ����ֵ

function newCenter = addNewNode(X,n,center,lambda,threshold) 
%%��ʼ����n������ڵ�����ĵ㼰���Ӧ���룩
nearestNode = zeros(size(X,1),n);     %��X�����n���ڵ�,���������
nearestDis = zeros(n,1);                %����ľ���
    for i = 1 : n
        nearestNode(:,i) = center(:,i);
        dis = norm(X-nearestNode(:,i));
        nearestDis(i) = dis;
    end
%%Ѱ��������X�����n���ڵ�  nearestNode
    for j = n + 1 : size(center,2)                          %�������нڵ�
        distance = norm(X-center(:,j));                %��ڵ�ľ���
           [tempDis,I] = sortrows(nearestDis,'descend');   %��������
           for k = 1 : n                                   %ѭ����������� �㼯
               if tempDis(k) > distance
                   nearestDis(I(k)) = distance;            %�滻����Ӧ�ľ����С
                   nearestNode(:,I(k)) = center(:,j);        %�滻����Ӧ�����ĵ�
                   break;                                  %����ѭ��
               end 
           end
    end
%%�����µ����ĵ� 
P_ba = sum(nearestNode,2) / n;                             %����㼯����
    if norm(X-P_ba) > threshold                            %����㼯���ĳ�����ֵ���������ĵ�
        newCenter = P_ba + lambda*(X-P_ba);
        if any(all(center'==newCenter',2)) == 1            %���֮ǰ�������������
            newCenter = [];
        end
    else
        newCenter = [];
    end
end

