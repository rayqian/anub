//
//  Api.m
//  Anub.arak
//
//  Created by YongbinWang on 14-9-19.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import "Api.h"

#define API_LIST @"http://wbean.sinaapp.com/api/anub.php?type=list"
#define API_OPT  @"http://wbean.sinaapp.com/api/anub.php?type=%@&user=%@&res=%@"

#define TYPE_ALLOC   @"alloc"
#define TYPE_RELEASE @"release"


@implementation Api

-(NSDictionary *)getStatus{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: API_LIST ]];
    [request setHTTPMethod:@"get"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *status = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];//json解析
    return status;
}

-(NSDictionary *) allocResourceOfUserName:(NSString *) userName resource:(NSString *) res{
    return [self operateResource:TYPE_ALLOC :userName :res];
}

-(NSDictionary *) releaseResourceOfUserName:(NSString *) userName resource:(NSString *) res{
    return [self operateResource:TYPE_RELEASE :userName :res];
}

-(NSDictionary *) operateResource:(NSString *)type :(NSString*) userName :(NSString *)res{
    NSString * query = [NSString stringWithFormat:API_OPT, type, userName, res];
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"get"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * ret = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];//json解析
    NSLog(@"%@", ret);
    
    
    return ret;
}



@end



