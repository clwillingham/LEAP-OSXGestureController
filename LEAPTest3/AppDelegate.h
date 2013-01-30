//
//  AppDelegate.h
//  LEAPTest3
//
//  Created by Chris Willingham on 1/28/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
}

@property (assign) IBOutlet NSWindow *window;
-(void) pressKey:(int)key down:(BOOL)pressDown;


@end
