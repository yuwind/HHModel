//
//  Person.h
//  HHModel
//
//  Created by 豫风 on 2018/2/8.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dog.h"

@interface Person : NSObject

@property (nonatomic, strong) NSArray *dog;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, assign) CGFloat aa;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL ccc;

@end
