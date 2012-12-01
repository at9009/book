//
//  SRequest.h
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

extern NSString * const SRequestMethodGet;
extern NSString * const SRequestMethodPost;

typedef void (^SRequestHandler)(id result, NSError * error);

@interface SPostImageItem : NSObject

@property (nonatomic, copy) NSString * field;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;

@end

@interface SRequest : NSObject

+ (SRequest *) requestWithMethod:(NSString *) path;

// 默认位get请求。
+ (SRequest *) requestWithMethod:(NSString *) method params:(NSDictionary *) params;


+ (SRequest *) requestWithMethod:(NSString *) method
                          params:(NSDictionary *) params
                            type:(NSString *) type;


- (void) startWithHandler:(SRequestHandler) handler;

- (void) setParam:(id) param forKey:(NSString *) key;

@end
