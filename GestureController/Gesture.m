//
//  Gesture.m
//  LEAPTest3
//
//  Created by Chris Willingham on 1/29/13.
//  Copyright (c) 2013 Chris Willingham. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture

@synthesize direction;
@synthesize fingers;
@synthesize avgVelocity;
@synthesize type;

-(id)initWithDirection:(Direction)dir andFingers:(NSInteger)count andVelocity:(LeapVector*)vector{
    if(self = [super init]){
        self.direction = dir;
        self.fingers = count;
        self.avgVelocity = vector;
    }
    return self;
}

-(id)initWithDirection:(Direction)dir andFingers:(NSInteger)count{
    if(self = [super init]){
        self.direction = dir;
        self.fingers = count;
    }
    return self;
}

-(id)initWithVelocity:(LeapVector*)vector andFingers:(NSInteger)count{
    if(self = [super init]){
        self.avgVelocity = vector;
        self.fingers = count;
        self.type = SCROLL_GESTURE;
    }
    return self;
}

    
@end
