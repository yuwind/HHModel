//
//  ViewController.m
//  HHModel
//
//  Created by 豫风 on 2018/2/8.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HHModel.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *p = [Person generateModel:@{@"dog":@[@{@"name":@"dog1"},@{@"name":@"dog2"}],@"number":@"num",@"aa":@"12.3",@"age":@"30",@"ccc":@"123"} map:nil container:@{@"dog":Dog.class}];
    NSLog(@"%@  %ld   %d",p.dog,p.age,p.ccc);
}



@end
