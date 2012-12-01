//
//  SRequest.m
//  SCaodan
//
//  Created by SunJiangting on 12-11-15.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SRequest.h"

NSString * const SRequestMethodGet  = @"GET";
NSString * const SRequestMethodPost = @"POST";

@implementation SPostImageItem

@end

@interface SRequest ()

@property (nonatomic, strong) NSMutableURLRequest * request;
@property (nonatomic, strong) NSOperationQueue * operationQueue;

@property (nonatomic, copy) NSString * method;
@property (nonatomic, strong) NSMutableDictionary * params;
@property (nonatomic, copy) NSString * type;

- (id) initWithRequestMethod:(NSString *) method
                      params:(NSDictionary *) params
                        type:(NSString *) type;

- (void) setupRequest;

@end


static NSString * kBoundary = @"Boundary";

@implementation SRequest

+ (SRequest *) requestWithMethod:(NSString *) method {
    SRequest * request = [SRequest requestWithMethod:method params:nil];
    return request;
}

// 默认位get请求。
+ (SRequest *) requestWithMethod:(NSString *) method params:(NSDictionary *) params {
    SRequest * request = [SRequest requestWithMethod:method params:params type:SRequestMethodGet];
    return request;
}


+ (SRequest *) requestWithMethod:(NSString *) method
                          params:(NSDictionary *) params
                            type:(NSString *) type {
    SRequest * request = [[SRequest alloc] initWithRequestMethod:method params:params type:type];
    return request;
}


- (id) initWithRequestMethod:(NSString *) method
                      params:(NSDictionary *) params
                        type:(NSString *) type {
    self = [super init];
    if (self) {
        self.method = method;
        self.params = [NSMutableDictionary dictionaryWithDictionary:params];
        self.type = type;
        self.operationQueue = [[NSOperationQueue alloc] init];
        
        self.request = [[NSMutableURLRequest alloc] init];
        self.request.HTTPMethod = type;
        
    }
    return self;
}


- (void) startWithHandler:(SRequestHandler) handler {
    
    [self setupRequest];
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:self.operationQueue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        id result = nil;
        if (!error) {
             result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
        handler(result,error);
        
    }];
}


- (void) setParam:(id) param forKey:(NSString *) key {
    [self.params setValue:param forKey:key];
}

- (void) setupRequest {
    NSString * urlString = kHostName;
    if (self.method && ![self.method isEqualToString:@""]) {
        if ([self.method characterAtIndex:self.method.length-1] != '/') {
            self.method = [self.method stringByAppendingString:@"/"];
        }
        urlString = [urlString stringByAppendingFormat:@"/%@",self.method];
    } else {
        return;
    }
    if ([self.request.HTTPMethod isEqualToString:SRequestMethodGet]) {
        // GET 请求
        NSMutableString * temp = [NSMutableString stringWithString:@"?sid=testSid"];
        [self.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [temp appendFormat:@"&%@=%@",key,obj];
        }];
        self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,temp]];
        SLog(@"GET请求地址%@",self.request.URL);
    } else {
        // POST 请求
        SLog(@"POST 请求地址：%@",urlString);
        self.request.URL = [NSURL URLWithString:urlString];
        __block BOOL multipart = NO;
        NSMutableData * postData = [NSMutableData dataWithCapacity:512];
        [self.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key isEqualToString:@"image"]) {
                multipart = YES;
                SPostImageItem * item = (SPostImageItem *) obj;
                if ([item isKindOfClass:[SPostImageItem class]]) {
                    NSString * body = [NSString stringWithFormat:
                                       @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n",
                                       kBoundary,
                                       item.field,
                                       item.name];
                    
                    [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                    [postData appendData:UIImageJPEGRepresentation(item.image, 1.0)];
                    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                } else if ([item isKindOfClass:[NSString class]]){
                    // 当做字段来处理
                    NSString * body = [NSString stringWithFormat:
                                       @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                       kBoundary, key, obj];
                    [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                }
               
            } else {
                NSString * body = [NSString stringWithFormat:
                                             @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                             kBoundary, key, obj];
                
                [postData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }];
        
        [postData appendData:
         [[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        if(multipart) {
            [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, kBoundary]
                forHTTPHeaderField:@"Content-Type"];
            [self.request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        }
        [self.request setHTTPBody:postData];
    }

}

@end
