//
//  Api.h
//  Anub.arak
//
//  Created by YongbinWang on 14-9-19.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Api : NSObject

-(NSDictionary *) getStatus;
-(NSDictionary *) allocResourceOfUserName:(NSString *) userName resource:(NSString *) res;
-(NSDictionary *) releaseResourceOfUserName:(NSString *) userName resource:(NSString *) res;

@end


