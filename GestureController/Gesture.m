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

-(id)initWithDirection:(Direction)dir andFingers:(NSInteger)count{
    if(self = [super init]){
        self.direction = dir;
        self.fingers = count;
    }
    return self;
}
    
@end
