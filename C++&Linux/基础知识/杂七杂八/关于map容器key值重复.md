# 1 问题描述

C++的标准库关联容器map是不允许有key相同的键值对存在的。那么当key已经存在的情况下，我们再次插入相同的key，那么key的value会被覆盖吗？
# 2 编码测试
``` c++
#include <map>
#include <string>
#include <iostream>
using std::map;
using std::string;
using std::cout;
using std::endl;
using std::make_pair;
/**
* 测试map的插入覆盖特性
* 注意众多的using声明
*/
int main()
{
    map<string, string> testMap;
    testMap.insert(make_pair("bkey","bval"));
    cout << "before convert: " << testMap["bkey"] << endl;

     //insert方式，重复的key会直接被放弃，而不是进行覆盖（这一点与Java不同） 
    testMap.insert(make_pair("bkey","cval"));  
    cout <<"insert convert test:  " << testMap["bkey"] << endl;

    //[]方式是可以覆盖的
    testMap["bkey"] = "dval";  
    cout <<"[] convert test:"  << testMap["bkey"] << endl;

    return 0;
}
```

``` c++
测试结果：
before convert: bval
insert convert test:  bval
[] convert test:dval

```
# 3 测试结论

从测试结果我们可以看出，使用insert()插入元素的方式并不能覆盖掉相同key的值；而使用[ ]方式则可以覆盖掉之前的值。
# 4 原因分析
在map的源码中，insert方法是这样定义的
```c++
pair<iterator,bool> insert(const value_type& __x) 
    { return _M_t.insert_unique(__x); }
```
他调用_M_t.insert_unique(_x)方法，该方法会首先遍历整个集合，判断是否存在相同的key，如果存在则直接返回，放弃插入操作。如果不存在才进行插入。  
而[]方式是通过重载[]操作符来实现的，它直接进行插入或覆盖。