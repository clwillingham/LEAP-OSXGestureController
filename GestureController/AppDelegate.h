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
    NSStatusItem * statusItem;
}
@property (weak) IBOutlet NSMenu *statusMenu;

@property (assign) IBOutlet NSWindow *window;
-(void) pressKey:(int)key down:(BOOL)pressDown;
-(void) scrollX:(NSInteger)x scrollY:(NSInteger)y;
- (IBAction)onQuitClick:(id)sender;
- (IBAction)onAboutClick:(id)sender;


@end
