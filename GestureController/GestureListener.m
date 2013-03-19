//
//  LeapTest.m
//  LEAPTest2
//
//  Created by Chris Willingham on 1/28/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import "GestureListener.h"
#import "Gesture.h"

@implementation GestureListener{
    LeapController *controller;
    Gesture *prevGesture;
    OnGestureEvent onGesture;
    int gestureTimeout;
}

-(id)init{
    gestureTimeout = 0;
    return self;
}

- (void) run{
    controller = [[LeapController alloc] init];
    [controller addListener:self];
    NSLog(@"running");
    [[NSRunLoop currentRunLoop] run]; // required for performSelectorOnMainThread:withObject
}

- (void)setGestureEvent:(OnGestureEvent)callback{
    onGesture = callback;
}

#pragma mark - SampleListener Callbacks

- (void)onInit:(NSNotification *)notification
{
    NSLog(@"Initialized");
}

- (void)onConnect:(NSNotification *)notification;
{
    NSLog(@"Connected");
    LeapController *aController = (LeapController *)[notification object];
//    [aController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
//    [aController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
//    [aController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [aController enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
}

- (void)onDisconnect:(NSNotification *)notification;
{
    NSLog(@"Disconnected");
}

- (void)onExit:(NSNotification *)notification;
{
    NSLog(@"Exited");
}

- (void)onFrame:(NSNotification *)notification;
{
    LeapController *aController = (LeapController *)[notification object];
    
    // Get the most recent frame and report some basic information
    LeapFrame *frame = [aController frame:0];
    
    if(gestureTimeout > 0 && prevGesture != nil){
        gestureTimeout--;
//        NSLog(@"timeout %d", gestureTimeout);
    }else{
        gestureTimeout = 0;
    
        prevGesture = nil;
    }
    NSArray *fingers = [frame fingers];
    if ([fingers count] != 0) {
        // Calculate the hand's average finger tip position
        LeapVector *avgPos = [[LeapVector alloc] init];
        LeapVector *avgVelocity = [[LeapVector alloc] init];
        int fingerCount = 0;
        for (int i = 0; i < [fingers count]; i++) {
            LeapFinger *finger = [fingers objectAtIndex:i];
            if (finger.tipPosition.z < 0) {
                avgPos = [avgPos plus:[finger tipPosition]];
                avgVelocity = [avgVelocity plus:[finger tipVelocity]];
                fingerCount ++;
            }
        }
        avgPos = [avgPos divide:[fingers count]];
        avgVelocity = [avgVelocity divide:[fingers count]];
        //NSLog(@"Hand has %ld fingers, average finger tip position %@",
        //      [fingers count], avgVelocity);
        if(fingerCount > 0){
            if([avgVelocity y] > 700){
                Gesture *gesture = [[Gesture alloc] initWithDirection:Up andFingers:[fingers count] andVelocity:avgVelocity];
                //NSLog(@"Gesture up with %ld fingers", [fingers count]);
                [self gestureDetected:gesture];
            }else if([avgVelocity y] < -700){
                Gesture *gesture = [[Gesture alloc] initWithDirection:Down andFingers:[fingers count] andVelocity:avgVelocity];
                //NSLog(@"Gesture down with %ld fingers", [fingers count]);
                [self gestureDetected:gesture];
            }else if([avgVelocity x] > 500){
                Gesture *gesture = [[Gesture alloc] initWithDirection:Right andFingers:[fingers count] andVelocity:avgVelocity];
                //NSLog(@"Gesture right with %ld fingers", [fingers count]);
                [self gestureDetected:gesture];
            }else if([avgVelocity x] < -500){
                Gesture *gesture = [[Gesture alloc] initWithDirection:Left andFingers:[fingers count] andVelocity:avgVelocity];
                //NSLog(@"Gesture left with %ld fingers", [fingers count]);
                [self gestureDetected:gesture];
            }else{
                gestureTimeout = 0;
                prevGesture = nil;
            }
      }

            
    }else{
        //gestureTimeout = 0;
        //prevGesture = nil;
    }
    
//    NSArray *gestures = [frame gestures:nil];
//    if(gestures.count > 0){
//        Gesture *gesture = [[Gesture alloc] init];
//        LeapGesture *leapGesture = [gestures objectAtIndex:0];
//        if(leapGesture.type == LEAP_GESTURE_TYPE_SWIPE && leapGesture.state == LEAP_GESTURE_STATE_STOP){
//            [self handleSwipe:(LeapSwipeGesture*)leapGesture];
//        }
//    }
    
    
    //    if (([[frame hands] count] > 0) || [[frame gestures:nil] count] > 0) {
    //        NSLog(@" ");
    //    }
}

-(void) handleSwipe: (LeapSwipeGesture*)swipe{
    Gesture *gesture = [[Gesture alloc] init];
    NSLog(@"DIrection: %@", swipe.direction);
    if(swipe.direction.x > 0.75){
        gesture.direction = Right;
    }else if(swipe.direction.x < -0.75){
        gesture.direction = Left;
    }else if(swipe.direction.y < -0.75){
        gesture.direction = Down;
    }else{
        gesture.direction = Up;
    }
    gesture.fingers = 1;
    [self gestureDetected:gesture];
}

-(void) gestureDetected:(Gesture *)gesture{
    
    if ((prevGesture == nil || [prevGesture direction] != [gesture direction]) && onGesture != nil) {
        gestureTimeout = 50;
        prevGesture = gesture;
        onGesture(gesture);
    }
}


@end
