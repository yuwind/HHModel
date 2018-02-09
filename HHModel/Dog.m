//
//  Dog.m
//  HHModel
//
//  Created by 豫风 on 2018/2/9.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,name:%@",self.class,self.name];
}

@end
