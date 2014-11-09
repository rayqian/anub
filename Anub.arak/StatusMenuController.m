//
//  StatusMenuController.m
//  Anub.arak
//
//  Created by YongbinWang on 11/9/14.
//  Copyright (c) 2014 YongbinWang. All rights reserved.
//

#import "StatusMenuController.h"

@interface StatusMenuController ()

@end

@implementation StatusMenuController
@synthesize delegate;
@synthesize api;
@synthesize userName;
@synthesize statusItem;
@synthesize statusMenu;
@synthesize status;
@synthesize statusKey;

-(StatusMenuController *) init{
    self = [super init];
    api = [[Api alloc]init];
    
    statusMenu = [[NSMenu alloc]init];
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    
    // 添加ip地址
    NSString *wifiIP = [[[NSHost currentHost] addresses] objectAtIndex:1];
    [statusItem setTitle: NSLocalizedString(wifiIP,@"")];
    
    [statusItem setAction:@selector(refreshMenu)];
    [statusItem setHighlightMode:YES];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)initMenu{
    [self getStatus];
    [statusMenu removeAllItems];
    for(int i=0;i<[statusKey count];i++){
        NSString * key = [statusKey objectAtIndex:i];
        NSDictionary *sub = [status objectForKey:key];
        NSString * res    = [sub objectForKey:@"res"];
        NSString * op     = [sub objectForKey:@"op"];
        NSString * user   = [sub objectForKey:@"user"];
        NSString * menuTitle;
        
        
        NSLog(@"%@:%@",op,res);

        if([op isEqual: @"alloc"]){
            menuTitle = [NSString stringWithFormat:@"%@ - %@",res,user];
        }else if([op isEqual:@"release"]){
            menuTitle = [NSString stringWithFormat:@"%@",res];
        }
        
        NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:menuTitle action:@selector(setValueProcess:) keyEquivalent:@""];
        [menu setTarget:self];
        [menu setTag:i];
        [statusMenu addItem:menu];
    }
    //    编辑按钮
    //    NSMenuItem *menu = [[NSMenuItem alloc] initWithTitle:@"edit" action:@selector(callEditPanel) keyEquivalent:@""];
    //    [statusMenu addItem:menu];
    
    NSMenuItem *fengexianMenu = [[NSMenuItem alloc] initWithTitle:@"-------" action:nil keyEquivalent:@""];
    [statusMenu addItem:fengexianMenu];
    
    
    NSMenuItem *freshMenu = [[NSMenuItem alloc] initWithTitle:@"Refresh" action:@selector(refreshMenu) keyEquivalent:@""];
    [freshMenu setTarget:self];
    [statusMenu addItem:freshMenu];
    
    NSMenuItem *aboutMeMenu = [[NSMenuItem alloc] initWithTitle:@"About me" action:@selector(aboutMeMenu) keyEquivalent:@""];
    [aboutMeMenu setTarget:[self delegate]];
    [statusMenu addItem:aboutMeMenu];
    
    NSMenuItem *fengexianMenu2 = [[NSMenuItem alloc] initWithTitle:@"-------" action:nil keyEquivalent:@""];
    [statusMenu addItem:fengexianMenu2];
    
    NSMenuItem *exitMenu = [[NSMenuItem alloc] initWithTitle:@"Exit" action:@selector(quit) keyEquivalent:@""];
    [exitMenu setTarget:[self delegate]];
    [statusMenu addItem:exitMenu];

}

-(void)setValueProcess:menuItem{
    [self getStatus];
    
    NSString * res = [statusKey objectAtIndex:[menuItem tag]];
    NSMutableDictionary * menuData = [[status objectForKey:res]copy];
    
    NSString * op = [menuData objectForKey:@"op"];
    NSDictionary * ret = nil;
    if([op isEqual:@"release"]){
        ret = [api allocResourceOfUserName:userName resource:res];
    }
    
    if([op isEqual:@"alloc"]){
        ret = [api releaseResourceOfUserName:userName resource:res];
    }
    if(![ret objectForKey:@"id"]){
        [[self delegate] callAlert:[ret objectForKey:@"errmsg"]];
    }
    
    [self refreshMenu];
}


//访问接口，获取新数据，刷新菜单目录
-(void) refreshMenu{
    [self getStatus];
    [self initMenu];
}

-(void) refreshMenuWithStatus:(NSNotification *)_status{
    status = [NSMutableDictionary dictionaryWithDictionary: _status.object];
    statusKey = [status allKeys];
    [self initMenu];
    NSLog(@"refreshMenuWithStatus");
}

-(void)getStatus{
    status = [NSMutableDictionary dictionaryWithDictionary: [api getStatus]];
    statusKey = [status allKeys];
    NSLog(@"get status:%@",status);
}

//清理
-(void)dealloc{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    api = nil;
    status = nil;
    statusKey = nil;
    statusMenu = nil;
    statusItem = nil;
    userName = nil;
}

@end
