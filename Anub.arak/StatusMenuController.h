//
//  StatusMenuController.h
//  Anub.arak
//
//  Created by YongbinWang on 11/9/14.
//  Copyright (c) 2014 YongbinWang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Api.h"

@protocol MainDelegate <NSObject>

-(void) callAlert:(NSString *)title;

@end

@interface StatusMenuController : NSViewController
@property (strong) Api * api;
@property (strong) id<MainDelegate> delegate;
@property (strong) NSString * userName;

//主菜单和子菜单
@property (retain) IBOutlet NSMenu * statusMenu;
@property (retain) NSStatusItem    * statusItem;

//菜单数据
@property (strong) NSMutableDictionary * status;
@property (strong) NSArray             * statusKey;

-(void)initMenu;

@end
