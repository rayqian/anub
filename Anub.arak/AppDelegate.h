//
//  AppDelegate.h
//  Anub.arak
//
//  Created by YongbinWang on 14-9-17.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Api.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSURLConnectionDelegate>

@property (retain) IBOutlet NSPanel *alertPanel;
@property (retain) IBOutlet NSTextField *textField;
@property (retain) IBOutlet NSButton *submit;

@property (strong) IBOutlet NSPanel *aboutMePanel;


@property (retain) IBOutlet NSMenu *statusMenu;
@property (retain) NSStatusItem * statusItem;

@property (strong) NSString * userName;
@property (strong) NSMutableDictionary * status;
@property (strong) NSArray * statusKey;
@end
