### service管理服务的基本状态
	service 服务名 [start|stop|restart| reload | status]
	service network status

### 查看service所管理的服务名：
	方式一：ls -l /etc/init.d    // 有限显示
	方式二：setup

### 运行级别：
#### 查看当前运行级别
	systemctl get-default
	graphical.target

#### 设置默认级别
	systemctl set-default multi-user.target

### 设置某些级别服务的开启和关闭
	chkconfig --list |network
	chkconfig --level 5 network on/off
	
	systemctl  [start|stop|restart| reload | status] 服务名 
	systemctl status firewalld


### systemctl 所管理的服务所在位置：
	ls -l /usr/lib/systemd/system

### 用systemctl设置服务的开机自启动状态

	systemctl list-unit-files   //查看服务开机启动状态
	systemctl enable 服务名   //设置服务开机启动
	systemctl disable 服务名   //关闭服务开机启动
	systemctl is-enabled 服务名  //查看某个服务是否自启动

#### 例子：查看防火墙的状态 (firewalled)

	打开或关闭指定端口
	查看协议和端口
	netstat -anp |more
	
	打开端口：firewall-cmd --permanent --add-port=端口号/协议
	关闭端口：firewall-cmd --permanent --remove-port=端口号/协议
	重新载入才能生效：firewall-cmd --reloda
	查询端口是否开放：firewall-cmd  --query-port=端口号/协议

	e.g.
	firewall-cmd --permanent --add-port=111/tcp
	firewall-cmd --reloda
	firewall-cmd --query-port=111/tcp
	[yes]
	firewall-cmd --permanent --remove-port=111/tcp
	firewall-cmd --reload
	firewall-cmd --query-port=111/tcp
	[no]