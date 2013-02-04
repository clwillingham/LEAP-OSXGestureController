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

@interface Gesture : NSObject

@property (nonatomic) Direction direction;
@property (nonatomic) NSInteger fingers;


-(id) initWithDirection:(Direction)dir andFingers:(NSInteger)count;

@end
