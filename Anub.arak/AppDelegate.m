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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"localuser" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
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
    [statusItem setTitle: NSLocalizedString(@"Status",@"")];
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

    //编辑按钮
//    NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:@"edit" action:@selector(callPanel) keyEquivalent:@""];
//    [statusMenu addItem:menu];
    
    NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:@"exit" action:@selector(quit) keyEquivalent:@""];
    [statusMenu addItem:menu];

    
    
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
    
    //添加一项内容
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"localuser" ofType:@"plist"];

    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObject:userName forKey:@"name"];
    NSLog(@"%@",data);

    [data writeToFile:plistPath atomically:YES];
    
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


@end
