**其负责把日志写进日志文件**

### 查看rsysklogd是否启动 -v 表示反向匹配，即不包含
	/etc/rsyslog.conf   记录日志服务程序所要维护的日志
	ps aux |grep "rsyslog"|grep -v "grep"    

### 查询rsyslogd 服务的自启动状态
	systemctl list-unit-files |grep "rsyslog"

### 日志管理服务应用实例
- 在/etc/rsyslog.conf 中添加一个日志文件/etc/log/ch.log，当事件发生时（如sshd服务），该文件会接收到信息并保存，如**重启、登录**。

1. vim /etc/rsyslog.conf
2. 添加 通配符.通配符                                   /var/log/ch.log
3. >  /var/log/ch.log
4. 重启XShell 登录
5. cd /var/log
6. cat ch.log |grep sshd
