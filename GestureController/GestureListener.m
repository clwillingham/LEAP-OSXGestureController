//
//  LeapTest.m
//  LEAPTest2
//
//  Created by Chris Willingham on 1/28/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import "GestureListener.h"
#import "Gesture.h"

@implementation GestureListener

-(id)init{
    gestureTimeout = 0;
    return self;
}

- (void) run{
    controller = [[LeapController alloc] init];
    [controller addDelegate:self];
    NSLog(@"running");
}

- (void)setGestureEvent:(OnGestureEvent)callback{
    onGesture = callback;
}

- (void)onConnect:(LeapController *)controller{
    NSLog(@"controller connected");
}

-(void)onDisconnect:(LeapController *)controller{
    NSLog(@"Disconnected");
}

-(void)onFrame:(LeapController *)controller{
    LeapFrame *frame = [controller frame:0];
    
    if(gestureTimeout > 0 && prevGesture != nil){
        gestureTimeout--;
        //NSLog(@"timeout %d", gestureTimeout);
    }else{
        gestureTimeout = 0;
        
        prevGesture = nil;
    }
    
    NSLog([NSString stringWithFormat:@"%d", [[frame hands] count]]);
    if ([[frame hands] count] != 0) {
        // Get the first hand
        LeapHand *hand = [[frame hands] objectAtIndex:0];
        
        
        
        NSArray *fingers = [hand fingers];
        if ([fingers count] != 0) {
            // Calculate the hand's average finger tip position
            LeapVector *avgPos = [[LeapVector alloc] init];
            LeapVector *avgVelocity = [[LeapVector alloc] init];
            LeapVector *palmVelocity = [hand palmVelocity];

            for (int i = 0; i < [fingers count]; i++) {
                LeapFinger *finger = [fingers objectAtIndex:i];
                
                avgPos = [avgPos plus:[finger tipPosition]];
                avgVelocity = [avgVelocity plus:[finger tipVelocity]];
            }
            avgPos = [avgPos divide:[fingers count]];
            avgVelocity = [avgVelocity divide:[fingers count]];
            //NSLog(@"Hand has %ld fingers, average finger tip position %@",
            //      [fingers count], avgVelocity);
            if([avgPos z] < 0){
                if([avgVelocity y] > 700){
                    Gesture *gesture = [[Gesture alloc] initWithDirection:Up andFingers:[fingers count]];
                    //NSLog(@"Gesture up with %ld fingers", [fingers count]);
                    //NSLog(@"Gesture up with %@,%@",palmVelocity,avgVelocity);
                    [self gestureDetected:gesture];
                }else if([avgVelocity y] < -700){
                    Gesture *gesture = [[Gesture alloc] initWithDirection:Down andFingers:[fingers count]];
                    //NSLog(@"Gesture down with %ld fingers", [fingers count]);
                    //NSLog(@"Gesture down with %@,%@",palmVelocity,avgVelocity);
                    [self gestureDetected:gesture];
                }else if([avgVelocity x] > 500){
                    Gesture *gesture = [[Gesture alloc] initWithDirection:Right andFingers:[fingers count]];
                    //NSLog(@"Gesture right with %ld fingers", [fingers count]);
                    //NSLog(@"Gesture right with %@,%@",palmVelocity,avgVelocity);
                    [self gestureDetected:gesture];
                }else if([avgVelocity x] < -500){
                    Gesture *gesture = [[Gesture alloc] initWithDirection:Left andFingers:[fingers count]];
                    //NSLog(@"Gesture left with %ld fingers", [fingers count]);
                    //NSLog(@"Gesture left with %@,%@",palmVelocity,avgVelocity);
                    [self gestureDetected:gesture];
                }else if([palmVelocity z]<-500){
                    //NSLog(@"Gesture fist with %@,%@",palmVelocity,avgVelocity);
                    Gesture *gesture = [[Gesture alloc] initWithDirection:Fist andFingers:[fingers count]];
                    [self gestureDetected:gesture];
                }
            }
            
                
        }else{
            //gestureTimeout = 0;
            //prevGesture = nil;
        }
    }

}

-(void) gestureDetected:(Gesture *)gesture{
    if ((prevGesture == nil || [prevGesture direction] != [gesture direction]) && onGesture != nil) {
        gestureTimeout = 200;
        prevGesture = gesture;
        onGesture(gesture);
    }
}

-(void)onInit:(LeapController *)controller{
    NSLog(@"Initialized");
}

-(void)onExit:(LeapController *)controller{
    NSLog(@"Exited");
}

@end
