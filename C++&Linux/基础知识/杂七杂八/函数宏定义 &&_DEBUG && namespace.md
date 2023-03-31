## 一 、宏定义
　#define FUN(a) "a"

　　则，输入FUN(345)会被替换成什么？

　　其实，如果这么写，无论宏的实参是什么，都不会影响其被替换成"a"的命运。

　　也就是说，""内的字符不被当成形参，即使它和一模一样。
　　
### 1.1 有参宏定义中#的用法

　　#define STR(str) #str

　　#用于把宏定义中的参数两端加上字符串的""

　　比如，这里STR(my#name)会被替换成"my#name"

　　一般由任意字符都可以做形参，但以下情况会出错：

　　STR())这样，编译器不会把“)”当成STR()的参数。

　　STR(,)同上，编译器不会把“,”当成STR的参数。

　　STR(A,B)如果实参过多，则编译器会把多余的参数舍去。（VC++2008为例）

　　STR((A,B))会被解读为实参为：(A,B)，而不是被解读为两个实参，第一个是(A第二个是B)。
　　
### 1.2有参宏定义中##的用法

　　#define WIDE(str) L##str

　　则会将形参str的前面加上L

　　比如：WIDE("abc")就会被替换成L"abc"

　　如果有#define FUN(a,b) vo##a##b()

　　那么FUN(id ma,in)会被替换成void main()

### 1.3 多行宏定义
宏定义中允许包含两行以上命令的情形，此时必须在最右边加上\\ 且该行 \\ 后**不能再有任何字符**，连注释部分都不能有，下面的每行最后的一定要是 \\   后面加一个空格都会报错，**更不能跟注释**。
```c++
#define swap(x, y)\
x = x + y;\
 
y = x - y;\
 
x = x - y;

```

#define` 标识符`( ... ) 替换列表(可选) 定义有**可变数量实参的仿函数宏**，但无常规实参。额外的实参（是谓可变实参_）只能用 `__VA_ARGS__` 标识符访问，它会被与要被替换的标识符一起提供的实参替换。

替换列表 可以含有记号序列“`__VA_OPT__ (` 内容 `)`”，如果 `__VA_ARGS__` 非空，那么它会被 内容 替换，否则不展开成任何内容。
```C++
#define F(...) f(0 __VA_OPT__(,) __VA_ARGS__)
#define G(X, ...) f(0, X __VA_OPT__(,) __VA_ARGS__)
#define SDEF(sname, ...) S sname __VA_OPT__(= { __VA_ARGS__ })
F(a, b, c) // 替换为 f(0, a, b, c)
F()        // 替换为 f(0)
G(a, b, c) // 替换为 f(0, a, b, c)
G(a, )     // 替换为 f(0, a)
G(a)       // 替换为 f(0, a)
SDEF(foo);       // 替换为 S foo;
SDEF(bar, 1, 2); // 替换为 S bar = { 1, 2 };
```

## 二、DEBUG
[(7条消息) C/C++ 中利用debug宏定义打开/关闭调试输出_乌托的博客-CSDN博客_c++ debug宏](https://blog.csdn.net/u012707739/article/details/80217959)
### **debug宏作为调试开关**

在写程序时，为了调试，经常需要加一些输出语句，等调试完成又得注释掉，如果下次还需要调试还得解注释，十分费时费力，为了解决这个麻烦，可以定义一个debug宏作为调试输出的开关。
```C++
#include <stdio.h>

int main(void)
{
    int i, sum;

    for (i = 1, sum = 0; i <= 5; i++)
    {
        sum += i;
#ifdef DEBUG
        printf("sum += %d is %d\n", i, sum);
#endif
    }
    printf("total sum is %d\n", sum);
}
```

上面代码中，只有定义DEBUG宏时，才会输出相加过程，我们可以在[gcc](https://so.csdn.net/so/search?q=gcc&spm=1001.2101.3001.7020)编译时用-D选项定义DEBUG宏来打开这个调试开关，输出调试信息
	gcc test.c -o test -D DEBUG 

## 三、命名空间
参考reference
[命名空间 - cppreference.com](https://zh.cppreference.com/w/cpp/language/namespace)
