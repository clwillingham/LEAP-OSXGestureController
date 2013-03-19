//
//  Gesture.h
//  LEAPTest3
//
//  Created by Chris Willingham on 1/29/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "include/LeapObjectiveC.h"

typedef enum {
    Up,
    Down,
    Left,
    Right
} Direction;

typedef enum {
    SCROLL_GESTURE,
    SWIPE_GESTURE
}GestureType;

@interface Gesture : NSObject

@property (nonatomic) Direction direction;

@property (nonatomic) NSInteger fingers;
@property (nonatomic) LeapVector *avgVelocity;
@property (nonatomic) GestureType *type;


-(id) initWithDirection:(Direction)dir andFingers:(NSInteger)count andVelocity:(LeapVector*)vector;
-(id) initWithDirection:(Direction)dir andFingers:(NSInteger)count;
-(id) initWithVelocity:(LeapVector*)vector andFingers:(NSInteger)count;

@end
