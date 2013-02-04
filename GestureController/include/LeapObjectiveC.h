/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import <Foundation/Foundation.h>

/*************************************************************************
Do not be alarmed by the copyright notice above. Please bear with us as we
work with our lawyers to finalize a permissive license for this code.

This wrapper works by doing a deep copy of the bulk of the hand and finger
hierarchy as soon as you the user requests [controller frame]. This is
enables us to set up the appropriate linkage between LeapHand and
LeapPointable ObjectiveC objects.

The motions API forced our hand to move the Frame and Hand objects towards
thin wrappers. Each now contains a pointer to its corresponding C++ object.
The screen calibration API brought Pointable objects to wrap and keep
around a C++ Leap::Pointable object as well.

Because the wrapped C++ object is kept around, attributes such as position
and velocity now have their ObjectiveC objects created lazily.

Major Leap API features supported in this wrapper today:
* Obtaining data through both polling (LeapController only) as well as
  through callbacks (LeapDelegate)
* Multiple delegates (listeners) per controller
* Querying for fingers, tools, or general pointables
* Various hand/finger properties: palmNormal, direction, sphereRadius,
  and more
* Basic angle accessors: pitch, roll, yaw
* Vector math helper functions: pitch, roll, raw, vector add, scalar
  multiply, dot product, cross product, LeapMatrix, and more
* Querying back up the hierarchy, e.g. [finger hand] or [hand frame]
* Indexing fingers or tools by persistent ID e.g. [frame finger:ID]
  or [hand tool:ID]
* LeapConfig API (for forthcoming features)
* Motions API
* Screen calibration API

Notes:
* Requires XCode 4.2+, relies on Automatic Reference Counting (ARC),
  minimum target OS X 10.7
* Intending to use ObjectiveC properties with modern variable name
  styles (underscore-prefixed) in a future version
* Intending to switch from delegates to NSNotifications in a future
  versions
* Contributions are welcome

*************************************************************************/

//////////////////////////////////////////////////////////////////////////
//VECTOR
@interface LeapVector : NSObject

- (id)initWithX:(float)leapX withY:(float)leapY withZ:(float)leapZ;
- (id)initWithVector:(const LeapVector *)vector;
- (id)initWithLeapVector:(void *)leapVector;
- (NSString *)description;

- (float)pitch;
- (float)roll;
- (float)yaw;
- (LeapVector *)plus:(const LeapVector *)vector;
- (LeapVector *)minus:(const LeapVector *)vector;
- (LeapVector *)negate;
- (LeapVector *)times:(float)scalar;
- (LeapVector *)divide:(float)scalar;
// not provided: unary assignment operators (plus_equals, minus_equals)
// user should emulate with above operators
- (BOOL)equals:(const LeapVector *)vector;
// not provided: not_equals
// user should emulate with !v.equals(...)
- (float)dot:(LeapVector *)vector;
- (LeapVector *)cross:(LeapVector *)vector;
- (LeapVector *)normalized;
- (NSArray *)toNSArray;
- (NSMutableData *)toFloatPointer;
// not provided: toVector4Type
// no templates, and ObjectiveC does not have a common math vector type
+ (LeapVector *)zero;
+ (LeapVector *)xAxis;
+ (LeapVector *)yAxis;
+ (LeapVector *)zAxis;
+ (LeapVector *)left;
+ (LeapVector *)right;
+ (LeapVector *)down;
+ (LeapVector *)up;
+ (LeapVector *)forward;
+ (LeapVector *)backward;

@property (nonatomic, assign, readwrite)float x;
@property (nonatomic, assign, readwrite)float y;
@property (nonatomic, assign, readwrite)float z;

@end

//////////////////////////////////////////////////////////////////////////
//MATRIX
@interface LeapMatrix : NSObject

- (id)initWithXBasis:(const LeapVector *)aXBasis withYBasis:(const LeapVector *)aYBasis withZBasis:(const LeapVector *)aZBasis withOrigin:(const LeapVector *)aOrigin;
- (id)initWithAxis:(const LeapVector *)axis withAngleRadians:(float)angleRadians;
- (id)initWithAxis:(const LeapVector *)axis withAngleRadians:(float)angleRadians withTranslation:(const LeapVector *)translation;
- (id)initWithMatrix:(LeapMatrix *)matrix;
- (id)initWithLeapMatrix:(void *)matrix;
- (NSString *)description;

// not provided: setRotation
// This was mainly an internal helper function for the above constructors
- (LeapVector *)transformPoint:(const LeapVector *)point;
- (LeapVector *)transformDirection:(const LeapVector *)direction;
- (LeapMatrix *)orthoNormalized;
- (LeapMatrix *)times:(const LeapMatrix *) other;
// not provided: unary assignment operator times_equals
- (BOOL)equals:(const LeapMatrix *) other;
// not provided: not_equals
- (NSMutableArray *)toNSArray3x3;
- (NSMutableArray *)toNSArray4x4;
+ (LeapMatrix *)identity;

@property (nonatomic, strong, readwrite)const LeapVector *xBasis;
@property (nonatomic, strong, readwrite)const LeapVector *yBasis;
@property (nonatomic, strong, readwrite)const LeapVector *zBasis;
@property (nonatomic, strong, readwrite)const LeapVector *origin;

@end

//////////////////////////////////////////////////////////////////////////
//CONSTANTS
extern const float LEAP_PI;
extern const float LEAP_DEG_TO_RAD;
extern const float LEAP_RAD_TO_DEG;

//////////////////////////////////////////////////////////////////////////
//POINTABLE
@class LeapFrame;
@class LeapHand;

@interface LeapPointable : NSObject

- (id)initWithPointable:(void *)pointable withFrame:(const LeapFrame *)frame withHand:(const LeapHand *)hand;
- (NSString *)description;

- (void *)interfacePointable;
- (int32_t)id;
- (const LeapVector *)tipPosition;
- (const LeapVector *)tipVelocity;
- (const LeapVector *)direction;
- (float)width;
- (float)length;
- (BOOL)isFinger;
- (BOOL)isTool;
- (BOOL)isValid;
- (const LeapFrame *)frame;
- (const LeapHand *)hand;
+ (const LeapPointable *)invalid;

@end

//////////////////////////////////////////////////////////////////////////
//FINGER
@interface LeapFinger : LeapPointable
@end

//////////////////////////////////////////////////////////////////////////
//TOOL
@interface LeapTool : LeapPointable
@end

//////////////////////////////////////////////////////////////////////////
//HAND
@interface LeapHand : NSObject

- (id)initWithHand:(void *)hand withFrame:(LeapFrame *)aFrame;
- (NSString *)description;

- (void *)interfaceHand;
- (int32_t)id;
- (NSArray *)pointables;
- (NSArray *)fingers;
- (NSArray *)tools;
- (const LeapPointable *)pointable:(int32_t)pointable_id;
- (const LeapFinger *)finger:(int32_t)finger_id;
- (const LeapTool *)tool:(int32_t)tool_id;
- (const LeapVector *)palmPosition;
- (const LeapVector *)palmVelocity;
- (const LeapVector *)palmNormal;
- (const LeapVector *)direction;
- (const LeapVector *)sphereCenter;
- (float)sphereRadius;
- (BOOL)isValid;
- (const LeapFrame *)frame;
- (LeapVector *)translation:(const LeapFrame *)since_frame;
- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame withAxis:(const LeapVector *)axis;
- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame;
- (float)scaleFactor:(const LeapFrame *)since_frame;
+ (const LeapHand *)invalid;

@end
//////////////////////////////////////////////////////////////////////////
//SCREEN
@interface LeapScreen : NSObject

- (id)initWithScreen:(void *)screen;
- (NSString *)description;
- (void *)interfaceScreen;
- (int32_t)id;
- (LeapVector *)intersect:(LeapPointable *)pointable withNormalize:(BOOL)normalize withClampRatio:(float)clampRatio;
- (LeapVector *)horizontalAxis;
- (LeapVector *)verticalAxis;
- (LeapVector *)bottomLeftCorner;
- (LeapVector *)normal;
- (int)widthPixels;
- (int)heightPixels;
- (float)distanceToPoint:(const LeapVector *)point;
- (BOOL)isValid;
- (BOOL)equals:(const LeapScreen *)other;
// not provided: not_equals
// user should emulate with !scr.equals(...)
+ (const LeapScreen *)invalid;

@end

//////////////////////////////////////////////////////////////////////////
//FRAME
@interface LeapFrame : NSObject

@property (nonatomic, weak, readonly)NSArray *hands;
@property (nonatomic, weak, readonly)NSArray *pointables;
@property (nonatomic, weak, readonly)NSArray *fingers;
@property (nonatomic, weak, readonly)NSArray *tools;

- (id)initWithFrame:(const void *)frame;
- (NSString *)description;

- (void *)interfaceFrame;
- (int64_t)id;
- (int64_t)timestamp;
- (NSArray *)hands;
- (NSArray *)pointables;
- (NSArray *)fingers;
- (NSArray *)tools;
- (const LeapHand *)hand:(int32_t)hand_id;
- (const LeapPointable *)pointable:(int32_t)pointable_id;
- (const LeapFinger *)finger:(int32_t)finger_id;
- (const LeapTool *)tool:(int32_t)tool_id;
- (LeapVector *)translation:(const LeapFrame *)since_frame;
- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame withAxis:(const LeapVector *)axis;
- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame;
- (float)scaleFactor:(const LeapFrame *)since_frame;
+ (const LeapFrame *)invalid;

@end

//////////////////////////////////////////////////////////////////////////
//CONFIG
typedef enum {
    TYPE_UNKNOWN,
    TYPE_BOOLEAN,
    TYPE_INT32, TYPE_UINT32, TYPE_INT64, TYPE_UINT64,
    TYPE_FLOAT, TYPE_DOUBLE,
    TYPE_STRING
} LeapValueType;

@interface Config : NSObject

- (id)initWithConfig:(void *)leapConfig;

- (LeapValueType)type:(NSString *)key;
- (BOOL)getBool:(NSString *)key;
- (int32_t)getInt32:(NSString *)key;
- (int64_t)getInt64:(NSString *)key;
- (uint32_t)getUInt32:(NSString *)key;
- (uint64_t)getUInt64:(NSString *)key;
- (float)getFloat:(NSString *)key;
- (float)getDouble:(NSString *)key;
- (NSString *)getString:(NSString *)key;

@end

//////////////////////////////////////////////////////////////////////////
//CONTROLLER
/*************************************************************************
LeapController: The class you need to instantiate to begin getting
callbacks from Leap.

To run:
1 -  Run the Leap application and make sure the icon appears in your
     toolbar and that it's green
2 -  Create an instance of the LeapController class
3a - Call init (no arguments) then poll LeapController object for frame
     data at regular intervals; OR
3b - Call initWithDelegate to pass the object which conforms to the
     LeapDelegate protocol and which you want to receive the Leap
     callbacks
*************************************************************************/

@interface LeapController : NSObject

- (id)init;
- (id)initWithController:(void *)leapController;
- (id)initWithDelegate:(id)delegate;
- (BOOL)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (LeapFrame *)frame:(int)history;
- (Config *)config;
- (BOOL)isConnected;
- (NSArray *)calibratedScreens;

@end

//////////////////////////////////////////////////////////////////////////
//LISTENER (DELEGATE)
/*************************************************************************
 LeapDelegate: The protocol your class needs to conform to in order to get
 callbacks from the leap library. Terminology: wherever the C++ API uses
 "listener" for ObjectiveC a "delegate" is basically the same thing. You
 can practically use a LeapDelegate-conforming class in ObjectiveC in place
 of a corresponding Leap::Listener-derived class in C++.
 *************************************************************************/

@protocol LeapDelegate<NSObject>

@optional
- (void)onInit:(LeapController *)controller;
- (void)onConnect:(LeapController *)controller;
- (void)onDisconnect:(LeapController *)controller;
- (void)onExit:(LeapController *)controller;
- (void)onFrame:(LeapController *)controller;

@end

//////////////////////////////////////////////////////////////////////////
