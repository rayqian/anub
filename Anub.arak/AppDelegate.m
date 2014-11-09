//
//  AppDelegate.m
//  Anub.arak
//
//  Created by YongbinWang on 14-9-17.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusMenuController;

@synthesize alertPanel;
@synthesize submit;
@synthesize textField;
@synthesize userName;
@synthesize aboutMePanel;

-(AppDelegate*)init{
    statusMenuController = [[StatusMenuController alloc]init];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"anub/Anub.config.plist"];
    NSLog(@"config file name:%@",filename);
    
    //读取plist
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"config file data:%@", data);
    
    [submit setAction:@selector(saveUserName)];
    
    if([data count] == 0){
        [self callEditPanel];
    }else{
        userName = [data objectForKey:@"name"];
    }
    [statusMenuController setUserName:userName];
    [statusMenuController setDelegate:self];
    
    [[NSNotificationCenter defaultCenter]  addObserver:statusMenuController selector:@selector(refreshMenuWithStatus:) name:@"polling_data" object:nil];
    
    
    Polling * polling = [[Polling alloc]init];
    NSThread* pollingThread = [[NSThread alloc] initWithTarget:polling
                                                      selector:@selector(run:)
                                                        object:nil];
    [pollingThread start];
}


-(void)awakeFromNib{
    [[self statusMenuController] initMenu];
}


-(void) saveUserName{
    userName = textField.stringValue;
    NSLog(@"get username:%@",userName);
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"get path:%@",paths);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filedir=[plistPath1 stringByAppendingPathComponent:@"anub"];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filedir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:filedir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //得到完整的文件名
    NSString *filename=[filedir stringByAppendingPathComponent:@"Anub.config.plist"];

    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:userName forKey:@"name"];
    NSLog(@"save to path:%@",data);

    [data writeToFile:filename atomically:YES];
    
    [alertPanel orderOut:nil];
}

//打开编辑昵称窗口
-(void) callEditPanel{
    NSLog(@"callEditPanel");
    [NSApp activateIgnoringOtherApps:YES];
    [alertPanel center];
    [alertPanel makeKeyAndOrderFront:nil];
}

//弹出警告窗口
-(void) callAlert:(NSString *)title{
    NSLog(@"alert:%@",title);
    NSAlert * a = [NSAlert alertWithMessageText:title defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [a runModal];
}

//打开 about me panel
-(void) aboutMeMenu{
    NSLog(@"aboutMePanel");
    [NSApp activateIgnoringOtherApps:YES];
    [aboutMePanel center];
    [aboutMePanel makeKeyAndOrderFront:nil];
}

//退出应用
-(void) quit{
    NSLog(@"Bye");
    [NSApp terminate:self];
}


@end
