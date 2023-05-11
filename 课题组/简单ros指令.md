 ## 1.话题消息
	 rostopic list

	rostopic type [topic]

	rosmsg show [msg]  :rosmsg show geometry_msgs/Twist

	rostopic type /turtle1/cmd_vel | rosmsg show 结合查看话题和消息类型

	rosmsg info geometry_msgs/Twist  //显示具体数据格式，变量

	rostopic echo /话题  //打印该话题发布的消息

### 查看节点（就是可执行文件）、话题、消息关系（rqt_graph）

#### 使用rqt_plot，滚动时间图上显示发布到某个话题上的数据
	rosrun rqt_plot rqt_plot

### 消息发布
	rostopic pub可以把数据发布到当前某个正在广播的话题上。
	rostopic pub [topic] [msg_type] [args]
	eg:
	rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[2.0, 0.0, 0.0]' '[0.0, 0.0, 1.8]'

![[Pasted image 20230308204205.png]]

**重复发送消息**

![[Pasted image 20230308204402.png]]


## 2.ROS服务和参数
```
rosservice list         输出活跃服务的信息
rosservice call         用给定的参数调用服务 rosservice call [service] [args]

 rosservice call /clear

rosservice type         输出服务的类型 rosservice type /clear
rosservice find         按服务的类型查找服务
rosservice uri          输出服务的ROSRPC uri
```

	rosservice type /spawn | rossrv show 查看服务类型并显示数据结构,以便我们选择参数去调用
```
float32 x
float32 y
float32 theta
string name
---                     name为可选字段
string name
```

	rosservice call /spawn 2 2 0.2 ""

### rosparam参数
rosparam能让我们在ROS参数服务器（Parameter Server）上存储和操作数据。参数服务器能够存储整型（integer）、浮点（float）、布尔（boolean）、字典（dictionaries）和列表（list）等数据类型。rosparam使用YAML标记语言的语法。一般而言，YAML的表述很自然：1是整型，1.0是浮点型，one是字符串，true是布尔型，[1, 2, 3]是整型组成的列表，{a: b, c: d}是字典。rosparam有很多命令可以用来操作参数，如下所示：
```
rosparam set            设置参数
rosparam get            获取参数
rosparam load           从文件中加载参数
rosparam dump           向文件中转储参数
rosparam delete         删除参数
rosparam list           列出参数名
```

![[Pasted image 20230308211744.png]]

**也可以用rosparam get /来显示参数服务器上的所有内容：**
	rosparam get /

![[Pasted image 20230308212143.png]]

### 安装、查找、列出、进入包
	sudo apt install 包名
	rospack find 包名
	rospack list
	roscd 包名
	rosls 包名 //列出包里的文件

![[Pasted image 20230329173952.png]]


![[Pasted image 20230330204559.png]]