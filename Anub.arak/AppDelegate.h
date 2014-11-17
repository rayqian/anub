//
//  AppDelegate.h
//  Anub.arak
//
//  Created by YongbinWang on 14-9-17.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusMenuController.h"
#import "Polling.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSURLConnectionDelegate, MainDelegate>

@property (strong) StatusMenuController * statusMenuController;

//编辑昵称窗口和相关控件
@property (retain) IBOutlet NSPanel *alertPanel;
@property (retain) IBOutlet NSTextField *textField;
@property (retain) IBOutlet NSButton *submit;

//关于我
@property (retain) IBOutlet NSPanel *aboutMePanel;


//数据
@property (strong) NSString * userName;

-(void) callAlert:(NSString *)title;

@end
