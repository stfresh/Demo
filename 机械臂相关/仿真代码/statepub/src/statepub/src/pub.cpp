/*
    一、首先确定消息类型为：sensor_msgs/JointState

    二、消息格式为：
    std_msgs/Header header
        uint32 seq
        time stamp
        string frame_id
    string[] name
    float64[] position
    float64[] velocity
    float64[] effort

    三、创建功能包所需的依赖
    roscpp rospy std_msgs sensor_msgs

    四、实现流程：
    1、包含所需的头文件
    2、初始化节点
    3、创建发布对象
    4、组织所要发布的消息
    5、循环发布消息
*/
#include "ros/ros.h"
#include "sensor_msgs/JointState.h"
#include "std_msgs/Float64.h"
#include <iostream>
using namespace std;
int main(int argc, char *argv[])
{
    setlocale(LC_ALL,"");
    //2.初始化节点
    ros::init(argc,argv,"statepub");
    ros::NodeHandle nh;
    //3.创建发布对象
    ros::Publisher pub = nh.advertise<sensor_msgs::JointState>("joint_states",1);
    //等待发布者注册完毕
    sleep(0.5);
    //4、组织所要发布的消息
    sensor_msgs::JointState msg;

    //5、循环发布消息
        //设置发布频率
    ros::Rate r(10);
    /*
        ros::spin() 是进入了循环执行回调函数，而 ros::spinOnce() 只会执行一次回调函数(没有循环)，
        在 ros::spin() 后的语句不会执行到，而 ros::spinOnce() 后的语句可以执行。
    */
   double initnum = 0.01;
   double Count = initnum;

    while(ros::ok()){
        //更新消息
        //msg.header.seq = 100;
        msg.header.stamp = ros::Time::now();
        //msg.header.frame_id = "";
        msg.position.resize(6);
        msg.name.resize(6);

        msg.position[0] = 1.57 + Count;
        msg.name[0] = "axis_joint_1";

        msg.position[1] = 0;
        msg.name[1] = "axis_joint_2";

        msg.position[2] = 1.57;
        msg.name[2] = "axis_joint_3";

        msg.position[3] = 1.57;
        msg.name[3] = "axis_joint_4";

        msg.position[4] = 1.57;
        msg.name[4] = "axis_joint_5";

        msg.position[5] = 0;
        msg.name[5] = "axis_joint_6";

        if(Count == initnum)
            ROS_INFO("Starting publish...");
       ROS_INFO("The publish value is %f", msg.position[0]);
        
        pub.publish(msg);
        //改变数值
        Count = Count + 0.001;
        ros::spinOnce();
        //经验证，确实执行了
        //ROS_INFO("后面的语句你执行了？");
        r.sleep();
        
    }

    
    return 0;
}

