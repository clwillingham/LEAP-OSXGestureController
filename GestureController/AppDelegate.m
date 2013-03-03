//
//  AppDelegate.m
//  LEAPTest3
//
//  Created by Chris Willingham on 1/28/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import "AppDelegate.h"
#import "GestureListener.h"
#import "Gesture.h"
#import <Carbon/Carbon.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    GestureListener *listener = [[GestureListener alloc] init];
    
    [listener setGestureEvent:^(Gesture *g) {
        switch ([g direction]) {
            case Up:
                NSLog(@"Gesturing Up");
                
                //NSLog(@"MissionControl");
                [[NSWorkspace sharedWorkspace] launchApplication:@"Mission Control"];
                break;
            case Down:
                NSLog(@"Gesturing Down");
                CoreDockSendNotification(@"com.apple.expose.front.awake", NULL);
                break;
            case Left:
                NSLog(@"Gesturing Left with %ld fingers", [g fingers]);
                [self pressKey:kVK_Control down:true];
                [self pressKey:kVK_LeftArrow down:true];
                [self pressKey:kVK_Control down:false];
                [self pressKey:kVK_LeftArrow down:false];
                break;
            case Right:
                NSLog(@"Gesturing Right");
                [self pressKey:kVK_Control down:true];
                [self pressKey:kVK_RightArrow down:true];
                [self pressKey:kVK_Control down:false];
                [self pressKey:kVK_RightArrow down:false];
                break;
            case Fist:
                NSLog(@"Gesturing with Fist");
                [[NSWorkspace sharedWorkspace] launchApplication:@"/System/Library/Frameworks/Screensaver.framework/Versions/A/Resources/ScreenSaverEngine.app"];
            default:
                break;
        }
    }];
    [listener run];
}

-(void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:[self statusMenu]];
    //[statusItem setTitle:@"Test"];
    NSBundle *bundle = [NSBundle mainBundle];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"hand" ofType:@"png"]];
    [img setSize:NSMakeSize(20, 20)];
    [statusItem setImage:img];
    [statusItem setHighlightMode:YES];
    [window close];
}

-(void) pressKey:(int)key down:(BOOL)pressDown{
    CGEventRef downEvent = CGEventCreateKeyboardEvent(NULL, key, pressDown);
    
    CGEventPost(kCGHIDEventTap, downEvent);
    
    CFRelease(downEvent);
}

- (IBAction)onQuitClick:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)onAboutClick:(id)sender {
}

@end
