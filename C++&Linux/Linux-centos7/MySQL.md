### 基本操作
	mysql -u root -p      		//进入mysql
	show databases;			//显示数据库
	create database chsdata;		//创建自己的数据库
	use chsdata;			//使用自己的库
	create table myorder(id int,name varchar(32));  //创建表
	select * from myorders;                                   //显示自己的表
	insert into myorder values(100,'cat');		//插入值
### 找回Mysql密码
问题：忘记了root用户密码
1. vim /etc/my.cnf
 插入一句话：skip-grant-tabels   //跳过权限表
2. service mysqld restart                 //重启mysqld服务
3. 进入mysql                              //输入空密码即可
4. show databases;
5. use mysql;                                     //使用mysql这个数据库
6. show tables;                                   //显示当前的表
7. desc user;                                    //进入user表
8. authentication_string                        //找到权限字符串，密码处
9. updata user set authentication_string=password("ch189281480") where user="root"; 
 //password( )函数
10. flush privileges;                        //刷新
11. exit
12. vim /etc/my.cnf
13. 注销skip-grant-tabels          
14. service mysqld restart                 //重启mysqld服务
15. Completed