%X:当前NN输入
%n:所需要选取的点集数
%center:所有中心点集合(每一列为一个节点)
%lambda:阈值系数
%threshold:是否增加新节点的阈值

function newCenter = addNewNode(X,n,center,lambda,threshold) 
%%初始化（n个最近节点的中心点及其对应距离）
nearestNode = zeros(size(X,1),n);     %离X最近的n个节点,存的是中心
nearestDis = zeros(n,1);                %最近的距离
    for i = 1 : n
        nearestNode(:,i) = center(:,i);
        dis = norm(X-nearestNode(:,i));
        nearestDis(i) = dis;
    end
%%寻找离输入X最近的n个节点  nearestNode
    for j = n + 1 : size(center,2)                          %遍历所有节点
        distance = norm(X-center(:,j));                %与节点的距离
           [tempDis,I] = sortrows(nearestDis,'descend');   %降序排序
           for k = 1 : n                                   %循环遍历最近点 点集
               if tempDis(k) > distance
                   nearestDis(I(k)) = distance;            %替换掉对应的距离大小
                   nearestNode(:,I(k)) = center(:,j);        %替换掉对应的中心点
                   break;                                  %跳出循环
               end 
           end
    end
%%计算新的中心点 
P_ba = sum(nearestNode,2) / n;                             %最近点集中心
    if norm(X-P_ba) > threshold                            %如果点集中心超过阈值则新增中心点
        newCenter = P_ba + lambda*(X-P_ba);
        if any(all(center'==newCenter',2)) == 1            %如果之前存才则无需新增
            newCenter = [];
        end
    else
        newCenter = [];
    end
end

