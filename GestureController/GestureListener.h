//
//  LeapTest.h
//  LEAPTest2
//
//  Created by Chris Willingham on 1/28/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "include/LeapObjectiveC.h"
#import "Gesture.h"

typedef void (^OnGestureEvent) (Gesture *g);

@interface GestureListener : NSObject<LeapListener>{

}

- (void) run;

- (void) setGestureEvent:(OnGestureEvent)callback;

- (void) gestureDetected:(Gesture*)gesture;

- (void) handleSwipe: (LeapSwipeGesture*)swipe;

@end
