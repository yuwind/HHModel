# HHModel
轻量化字典转模型
**1、**使用方法

```objc
Person *p = [Person generateModel:
@{@"dog":@[@{@"name":@"dog1"},@{@"name":@"dog2"}],@"number":@"num",@"aa":@"12.3",@"age":@"30",@"ccc":@"123"} //模拟字典
map:nil//替换字段
container:@{@"dog":Dog.class}];//数组映射对象
NSLog(@"%@  %ld   %d",p.dog,p.age,p.ccc);

```

