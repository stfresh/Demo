### RBF神经网络
![[Pasted image 20220910102804.png]] 

$$ h_{nn}(Z)=\sum_{i=1}^NW_iS_i(Z)=W^TS(Z)$$
其中$W=[w_1,\cdots,w_N]^T\in R^N$为神经网络的权值向量，$S(Z)=[s_1(Z),\cdots,s_N(Z)]^T\in R^N$为神经网络的径向基函数,$Z=[z_1,z_2,\cdots,z_p]^T\in \omega_z\subseteq R^p$为神经网络的输入向量，$N$表示神经网络的神经元节点数，$P$表示神经网络的输入向量维度。
RBF神经网络的径向基函数选取不唯一，常用高斯函数：$$s_i(Z)=exp\left[-\frac{(Z-\delta_i)^T(Z-\delta_i)}{\eta{^2_i}}\right],i=1,2,\cdots,N$$
其中$\delta_i=\left[\delta_{i1},\delta_{i2},\cdots,\delta_{iN}\right]^T\in R^N$为高斯函数的中心点，$\eta_i$为第$i$个神经元点的节点宽度。
- <font  
color="red"  
size="4">引理2.1</font>
对于任意的光滑非线性函数$f(Z):R^P\rightarrow R$,可以通过选择足够多的神经元节点数$N$以及恰当的神经元中心点和宽度，使下式成立：$$f(Z)=W^{*T}S(Z)+\epsilon(Z),\forall Z\in \Omega_Z$$
其中$W^*$是神经网络的理想权值向量，$\epsilon(Z)$是神经网络的逼近误差，满足
$\left\|\epsilon(Z)\right\|\leq\epsilon^*$，$\epsilon^*$是任意小的常数。

### 梯度下降逼近
![[Pasted image 20220923173031.png]]
![[Pasted image 20220924085543.png]]


















