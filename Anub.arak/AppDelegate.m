//
//  AppDelegate.m
//  Anub.arak
//
//  Created by YongbinWang on 14-9-17.
//  Copyright (c) 2014年 YongbinWang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusItem;
@synthesize statusMenu;
@synthesize alertPanel;
@synthesize submit;
@synthesize textField;
@synthesize userName;
@synthesize status;
@synthesize statusKey;
@synthesize aboutMePanel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"anub/Anub.config.plist"];
    NSLog(@"%@",filename);
    
    //读取plist
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"%@", data);
    
    [submit setAction:@selector(saveUserName)];
    
    if([data count] == 0){
        [self callPanel];
    }else{
        userName = [data objectForKey:@"name"];
    }
}
-(void)awakeFromNib{
    [self getStatus];
    [self initMenuProcess];
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    
    // 添加ip地址
    NSString *wifiIP = [[[NSHost currentHost] addresses] objectAtIndex:1];
    [statusItem setTitle: NSLocalizedString(wifiIP,@"")];
    
    [statusItem setAction:@selector(refreshMenu)];
    [statusItem setHighlightMode:YES];
    
}

-(void)initMenuProcess{
    [statusMenu removeAllItems];
    for(int i=0;i<[statusKey count];i++){
        NSString * key = [statusKey objectAtIndex:i];
        NSDictionary *sub = [status objectForKey:key];
        NSString * res    = [sub objectForKey:@"res"];
        NSString * op     = [sub objectForKey:@"op"];
        NSString * user   = [sub objectForKey:@"user"];
        NSString * menuTitle;
        
        if([op isEqual: @"alloc"]){
            menuTitle = [NSString stringWithFormat:@"%@ - %@",res,user];
            NSLog(@"alloc");
        }else if([op isEqual:@"release"]){
            menuTitle = [NSString stringWithFormat:@"%@",res];
            NSLog(@"release");
        }
        NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:menuTitle action:@selector(setValueProcess:) keyEquivalent:@""];
        [menu setTitle: menuTitle];
        [menu setTag:i];
        [statusMenu addItem:menu];
    }

//    编辑按钮
//    NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:@"edit" action:@selector(callPanel) keyEquivalent:@""];
//    [statusMenu addItem:menu];
    
    NSMenuItem *fengexianMenu = [[NSMenuItem alloc] initWithTitle:@"-------" action:nil keyEquivalent:@""];
    [statusMenu addItem:fengexianMenu];

    
    NSMenuItem *freshMenu = [[NSMenuItem alloc] initWithTitle:@"Refresh" action:@selector(refreshMenu) keyEquivalent:@""];
    [statusMenu addItem:freshMenu];
    
    NSMenuItem *aboutMeMenu = [[NSMenuItem alloc] initWithTitle:@"About me" action:@selector(aboutMeMenu) keyEquivalent:@""];
    [statusMenu addItem:aboutMeMenu];
    
    NSMenuItem *fengexianMenu2 = [[NSMenuItem alloc] initWithTitle:@"-------" action:nil keyEquivalent:@""];
    [statusMenu addItem:fengexianMenu2];

    NSMenuItem *exitMenu = [[NSMenuItem alloc] initWithTitle:@"Exit" action:@selector(quit) keyEquivalent:@""];
    [statusMenu addItem:exitMenu];

    

}

-(void)setValueProcess:menuItem{
    [self getStatus];
    
    NSLog(@"master process");
    NSLog(@"%@", menuItem);
    
    NSString * res = [statusKey objectAtIndex:[menuItem tag]];
    NSMutableDictionary * menuData = [[status objectForKey:res]copy];
    
    NSString * op = [menuData objectForKey:@"op"];
    if([op isEqual:@"release"]){
        NSDictionary * ret = [self callRemote:@"alloc" :res];
        NSLog(@"%@", ret);

        if([ret objectForKey:@"id"]){
            //[menuData setObject:@"alloc" forKey:@"op"];
            //[status setObject:menuData forKey:res];
        }else{
            [self callAlert:[ret objectForKey:@"errmsg"]];
        }
    }
    
    if([op isEqual:@"alloc"]){
        NSDictionary * ret = [self callRemote:@"release" :res];
        NSLog(@"%@", ret);

        if([ret objectForKey:@"id"]){
            //[menuData setObject:@"release" forKey:@"op"];
            //[status setObject:menuData forKey:res];
        }else{
            [self callAlert:[ret objectForKey:@"errmsg"]];
        }
    }
    [self refreshMenu];
}

-(NSMutableDictionary *)getStatus{
    status = nil;
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://wbean.sinaapp.com/api/anub.php?type=list"]];
    [request setHTTPMethod:@"get"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    status = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];//json解析
    statusKey = [status allKeys];
    
    NSLog(@"%@",status);
    return status;
}

-(void) saveUserName{
    userName = textField.stringValue;
    NSLog(@"%@",userName);
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"%@",paths);
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
    NSLog(@"%@",data);

    [data writeToFile:filename atomically:YES];
    
    //todo 调用接口，上传用户名。
    [alertPanel orderOut:nil];
}

-(void) quit{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [NSApp terminate:self];
}

-(void) refreshMenu{
    [self getStatus];
    [self initMenuProcess];
}

-(void) callPanel{
    NSLog(@"%@",alertPanel);
    [NSApp activateIgnoringOtherApps:YES];
    [alertPanel center];
    [alertPanel makeKeyAndOrderFront:nil];
}

-(NSDictionary *) callRemote:(NSString *)type :(NSString *)res{
    NSString * query =[NSString stringWithFormat:@"http://wbean.sinaapp.com/api/anub.php?type=%@&user=%@&res=%@",type,userName,res];
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:strUrl]];
    [request setHTTPMethod:@"get"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@",returnData);
    NSDictionary * ret = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];//json解析
    
    return ret;

}

-(void) callAlert:(NSString *)title{
    NSAlert * a = [NSAlert alertWithMessageText:title defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [a runModal];
}

//打开 about me panel
-(void) aboutMeMenu{
    NSLog(@"%@",aboutMePanel);
    [NSApp activateIgnoringOtherApps:YES];
    [aboutMePanel center];
    [aboutMePanel makeKeyAndOrderFront:nil];
}


@end
