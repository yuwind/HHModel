//
//  NSObject+HHModel.h
//  HHModel
//
//  Created by 豫风 on 2018/2/8.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HHModel)

+ (instancetype)generateModel:(NSDictionary *)sources;
+ (instancetype)generateModel:(NSDictionary *)sources map:(NSDictionary *)map;
+ (instancetype)generateModel:(NSDictionary *)sources map:(NSDictionary *)map container:(NSDictionary <NSString *,Class>*)container;

@end

@interface NSArray (HHModel)

+ (instancetype)generateModel:(NSArray <NSDictionary *>*)sources class:(Class)mapClass map:(NSDictionary *)map;
+ (instancetype)generateModel:(NSArray <NSDictionary *>*)sources class:(Class)mapClass map:(NSDictionary *)map container:(NSDictionary <NSString *,Class>*)container;

@end
