//
//  Polling.m
//  Anub.arak
//
//  Created by YongbinWang on 11/9/14.
//  Copyright (c) 2014 YongbinWang. All rights reserved.
//

#import "Polling.h"


@implementation Polling
@synthesize api;

-(Polling *) init {
    api = [[Api alloc]init];
    return self;
}

-(void)run:contex{
    while (YES) {
        NSDictionary * status = [NSMutableDictionary dictionaryWithDictionary: [api getStatus]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"polling_data" object:status];
        [NSThread sleepForTimeInterval:60.0f];
    }
    
}

@end
