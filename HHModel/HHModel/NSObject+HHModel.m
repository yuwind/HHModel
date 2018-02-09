//
//  NSObject+HHModel.m
//  HHModel
//
//  Created by 豫风 on 2018/2/8.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "NSObject+HHModel.h"
#import <objc/runtime.h>

static inline NSString *toString(id object){
    if([object isEqual:[NSNull null]] || object == nil || object == NULL){
        return @"";
    }else if ([object isKindOfClass:NSString.class]){
        return [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return [NSString stringWithFormat:@"%@",object];
}

@implementation NSObject (HHModel)

+ (instancetype)generateModel:(NSDictionary *)sources
{
    return [self generateModel:sources map:nil];
}
+ (instancetype)generateModel:(id)sources map:(NSDictionary *)map
{
    return [self generateModel:sources map:map container:nil];
}
+ (instancetype)generateModel:(id)sources map:(NSDictionary *)map container:(NSDictionary <NSString *,Class>*)container;
{
    unsigned int count;
    id model = [[self alloc]init];
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i<count; i++) {
        id object = nil;
        Ivar ivar = ivars[i];
        NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1];
        NSString *ivarKey = ivarName;
        if (map) {
            if ([map.allKeys containsObject:ivarName]) {
                 object = [sources objectForKey:map[ivarName]];
                ivarKey = map[ivarName];
            }
        }else{
            object = [sources objectForKey:ivarName];
        }
        if (object) {
            if ([object isKindOfClass:[NSString class]]) {
                NSString *value = toString(object);
                NSString *selName = [NSString stringWithFormat:@"set%@%@:",[ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                char *cType = (char *)ivar_getTypeEncoding(ivar);
                if (strlen(cType) == 0)continue;
                switch (*cType) {
                    case 'B':{
                        BOOL paramter = value.integerValue>0?YES:NO;
                        if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                            IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                            void (*function)(id,SEL,BOOL) = (void (*)(id,SEL,BOOL))method;
                            function(model,NSSelectorFromString(selName),paramter);
                        }
                    }
                        break;
                    case 'c':
                    case 'C':
                    case 's':
                    case 'S':
                    case 'i':
                    case 'I':
                    case 'l':
                    case 'L':
                    case 'q':
                    case 'Q':{
                        NSInteger paramter = value.integerValue;
                        if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                            IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                            void (*function)(id,SEL,NSInteger) = (void (*)(id,SEL,NSInteger)) method;
                            function(model,NSSelectorFromString(selName),paramter);
                        }
                    }
                        break;
                    case 'f':
                    case 'd':
                    case 'D':{
                        double paramter = value.doubleValue;
                        if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                            IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                            void (*function)(id,SEL,double) = (void (*)(id,SEL,double)) method;
                            function(model,NSSelectorFromString(selName),paramter);
                        }
                    }
                        break;
                    case '@': {
                        NSString *type = [NSString stringWithUTF8String:cType];
                        if ([type isEqualToString:@"@\"NSNumber\""]) {
                            if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                                IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                                void (*function)(id,SEL,NSNumber *) = (void (*)(id,SEL,NSNumber *)) method;
                                function(model,NSSelectorFromString(selName),@(value.floatValue));
                            }
                        }else if ([type isEqualToString:@"@\"NSString\""]){
                            if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                                IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                                void (*function)(id,SEL,NSString *) = (void (*)(id,SEL,NSString *)) method;
                                function(model,NSSelectorFromString(selName),value);
                            }
                        }
                    }
                }
            }else if ([object isKindOfClass:[NSDictionary class]]){
                if (container&&[container.allKeys containsObject:ivarKey]) {
                    id containerObject = [[container objectForKey:ivarKey] generateModel:object map:map container:container];
                    NSString *selName = [NSString stringWithFormat:@"set%@%@:",[ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                    if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                        IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                        void (*function)(id,SEL,id) = (void (*)(id,SEL,id)) method;
                        function(model,NSSelectorFromString(selName),containerObject);
                    }
                }else{
                    NSString *selName = [NSString stringWithFormat:@"set%@%@:",[ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                    if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                        IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                        void (*function)(id,SEL,NSDictionary *) = (void (*)(id,SEL,NSDictionary *)) method;
                        function(model,NSSelectorFromString(selName),object);
                    }
                }
                
            }else if ([object isKindOfClass:[NSArray class]]){
                if (container&&[container.allKeys containsObject:ivarKey]) {
                    NSArray *array = [NSArray generateModel:object class:container[ivarKey] map:map container:container];
                    NSString *selName = [NSString stringWithFormat:@"set%@%@:",[ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                    if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                        IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                        void (*function)(id,SEL,NSArray *) = (void (*)(id,SEL,NSArray *)) method;
                        function(model,NSSelectorFromString(selName),array);
                    }
                }else{
                    NSString *selName = [NSString stringWithFormat:@"set%@%@:",[ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                    if ([model respondsToSelector:NSSelectorFromString(selName)]) {
                        IMP method = [model methodForSelector:NSSelectorFromString(selName)];
                        void (*function)(id,SEL,NSArray *) = (void (*)(id,SEL,NSArray *)) method;
                        function(model,NSSelectorFromString(selName),object);
                    }
                }
            }
        }
    }
    return model;
}

@end

@implementation NSArray (HHModel)

+ (instancetype)generateModel:(NSArray <NSDictionary *>*)sources class:(Class)mapClass map:(NSDictionary *)map
{
    return [self generateModel:sources class:mapClass map:map container:nil];
}
+ (instancetype)generateModel:(NSArray <NSDictionary *>*)sources class:(Class)mapClass map:(NSDictionary *)map container:(NSDictionary <NSString *,Class>*)container
{
    NSMutableArray *arrayM =[NSMutableArray array];
    for (NSDictionary *dict in sources) {
        id object =[mapClass generateModel:dict map:map container:container];
        [arrayM addObject:object];
    }
    return arrayM.copy;
}

@end
