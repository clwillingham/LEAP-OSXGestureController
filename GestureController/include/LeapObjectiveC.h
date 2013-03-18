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
  through callbacks
* Support for single-threaded callbacks through NSNotification objects
  (LeapListener), in addition to ObjectiveC delegates (LeapDelegate)
* Querying for fingers, tools, or general pointables
* Various hand/finger properties: palmNormal, direction, sphereRadius,
  and more
* Vector math helper functions: pitch, roll, raw, vector add, scalar
  multiply, dot product, cross product, LeapMatrix, and more
* Querying back up the hierarchy, e.g. [finger hand] or [hand frame]
* Indexing fingers or tools by persistent ID e.g. [frame finger:ID]
  or [hand tool:ID]
* LeapConfig API (for forthcoming features)
* Motions API
* Screen positioning API

Notes:
* Class names are prefixed by Leap, although LM and LPM were considered.
  Users may change the prefix locally, for example:
    sed -i '.bak' 's/Leap\([A-NP-Z]\)/LPM\1/g' LeapObjectiveC.*
    # above regexp matches LeapController, LeapVector, not LeapObjectiveC
* Requires XCode 4.2+, relies on Automatic Reference Counting (ARC),
  minimum target OS X 10.7
* Contributions are welcome

*************************************************************************/

//////////////////////////////////////////////////////////////////////////
//VECTOR
@interface LeapVector : NSObject

- (id)initWithX:(float)x y:(float)y z:(float)z;
- (id)initWithVector:(const LeapVector *)vector;
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

@property (nonatomic, assign, readonly)float x;
@property (nonatomic, assign, readonly)float y;
@property (nonatomic, assign, readonly)float z;

@end

//////////////////////////////////////////////////////////////////////////
//MATRIX
@interface LeapMatrix : NSObject

- (id)initWithXBasis:(const LeapVector *)xBasis yBasis:(const LeapVector *)yBasis zBasis:(const LeapVector *)zBasis origin:(const LeapVector *)origin;
- (id)initWithMatrix:(LeapMatrix *)matrix;
- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians;
- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians translation:(const LeapVector *)translation;
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

@property (nonatomic, strong, readonly)const LeapVector *xBasis;
@property (nonatomic, strong, readonly)const LeapVector *yBasis;
@property (nonatomic, strong, readonly)const LeapVector *zBasis;
@property (nonatomic, strong, readonly)const LeapVector *origin;

@end

//////////////////////////////////////////////////////////////////////////
//CONSTANTS
extern const float LEAP_PI;
extern const float LEAP_DEG_TO_RAD;
extern const float LEAP_RAD_TO_DEG;

typedef enum LeapGestureType {
    LEAP_GESTURE_TYPE_INVALID = -1,
    LEAP_GESTURE_TYPE_SWIPE = 1,
    LEAP_GESTURE_TYPE_CIRCLE = 4,
    LEAP_GESTURE_TYPE_SCREEN_TAP = 5,
    LEAP_GESTURE_TYPE_KEY_TAP = 6,
} LeapGestureType;

typedef enum LeapGestureState {
    LEAP_GESTURE_STATE_INVALID = -1,
    LEAP_GESTURE_STATE_START = 1,
    LEAP_GESTURE_STATE_UPDATE = 2,
    LEAP_GESTURE_STATE_STOP = 3,
} LeapGestureState;

//////////////////////////////////////////////////////////////////////////
//POINTABLE
@class LeapFrame;
@class LeapHand;

@interface LeapPointable : NSObject

- (NSString *)description;
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

@property (nonatomic, weak, getter = frame, readonly) const LeapFrame *frame;
@property (nonatomic, weak, getter = hand, readonly) const LeapHand *hand;

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

- (NSString *)description;
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
- (float)rotationAngle:(const LeapFrame *)since_frame axis:(const LeapVector *)axis;
- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame;
- (float)scaleFactor:(const LeapFrame *)since_frame;
+ (const LeapHand *)invalid;

@property (nonatomic, weak, getter = frame, readonly) const LeapFrame *frame;

@end

//////////////////////////////////////////////////////////////////////////
//SCREEN
@interface LeapScreen : NSObject

- (NSString *)description;
- (int32_t)id;
- (LeapVector *)intersect:(LeapPointable *)pointable normalize:(BOOL)normalize clampRatio:(float)clampRatio;
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
//GESTURE
@interface LeapGesture : NSObject

@property (nonatomic, strong, readonly)LeapFrame *frame;
@property (nonatomic, weak, readonly)NSArray *hands;
@property (nonatomic, weak, readonly)NSArray *pointables;

- (NSString *)description;
- (LeapGestureType)type;
- (LeapGestureState)state;
- (int32_t)id;
- (int64_t)duration;
- (float)durationSeconds;
- (NSArray *)hands;
- (NSArray *)pointables;
- (BOOL)isValid;
- (BOOL)equals:(const LeapGesture *)other;
// not provided: not_equals
// user should emulate with !scr.equals(...)
+ (const LeapGesture *)invalid;

@end

////////////////////////////////////////////////////////////////////////
//SWIPE GESTURE
@interface LeapSwipeGesture : LeapGesture

- (LeapVector *)position;
- (LeapVector *)startPosition;
- (LeapVector *)direction;
- (float)speed;
- (LeapPointable *)pointable;

@end

//////////////////////////////////////////////////////////////////////////
//CIRCLE GESTURE
@interface LeapCircleGesture : LeapGesture

- (float)progress;
- (const LeapVector *)center;
- (const LeapVector *)normal;
- (float)radius;
- (LeapPointable *)pointable;

@end

//////////////////////////////////////////////////////////////////////////
//SCREEN TAP GESTURE
@interface LeapScreenTapGesture : LeapGesture

- (LeapVector *)position;
- (LeapVector *)direction;
- (float)progress;
- (LeapPointable *)pointable;

@end

//////////////////////////////////////////////////////////////////////////
//KEY TAP GESTURE
@interface LeapKeyTapGesture : LeapGesture

- (LeapVector *)position;
- (LeapVector *)direction;
- (float)progress;
- (LeapPointable *)pointable;

@end

//////////////////////////////////////////////////////////////////////////
//FRAME
@interface LeapFrame : NSObject

@property (nonatomic, strong, readonly)NSArray *hands;
@property (nonatomic, strong, readonly)NSArray *pointables;
@property (nonatomic, strong, readonly)NSArray *fingers;
@property (nonatomic, strong, readonly)NSArray *tools;

- (NSString *)description;
- (void *)interfaceFrame;
- (int64_t)id;
- (int64_t)timestamp;
- (const LeapHand *)hand:(int32_t)hand_id;
- (const LeapPointable *)pointable:(int32_t)pointable_id;
- (const LeapFinger *)finger:(int32_t)finger_id;
- (const LeapTool *)tool:(int32_t)tool_id;
- (NSArray *)gestures:(const LeapFrame *)since_frame;
- (LeapGesture *)gesture:(int32_t)gesture_id;
- (LeapVector *)translation:(const LeapFrame *)since_frame;
- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame;
- (float)rotationAngle:(const LeapFrame *)since_frame axis:(const LeapVector *)axis;
- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame;
- (float)scaleFactor:(const LeapFrame *)since_frame;
- (BOOL)isValid;
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

@interface LeapConfig : NSObject

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
3b - Call initWithListener to pass object(s) which conform to the
     LeapListener protocol through which you want to receive the Leap
     NSNotification callbacks; OR
3c - Call initWithDelegate to pass the one object which conforms to the
     LeapDelegate protocol through which you want to receive the
     Leap callbacks
*************************************************************************/

@interface LeapController : NSObject

- (id)init;
- (id)initWithListener:(id)listener;
- (BOOL)addListener:(id)listener;
- (BOOL)removeListener:(id)listener;
- (id)initWithDelegate:(id)delegate;
- (BOOL)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (LeapFrame *)frame:(int)history;
- (LeapConfig *)config;
- (BOOL)isConnected;
- (void)enableGesture:(LeapGestureType)gesture_type enable:(BOOL)enable;
- (BOOL)isGestureEnabled:(LeapGestureType)gesture_type;
- (NSArray *)calibratedScreens;

@end

//////////////////////////////////////////////////////////////////////////
//LISTENER
/*************************************************************************
 LeapListener: The protocol your class needs to conform to in order to get
 callbacks from the Leap library.
 
 Note: Using callbacks (and thus this protocol) is not mandatory. See
 above 3a in the LeapController description.
 
 Originally the primary protocol was LeapDelegate which used ObjectiveC
 delegates, but we have since switched to NSNotifications. LeapDelegate
 methods typically take arguments of type (LeapController *), while
 LeapListener methods take an (NSNotification *) argument from which you
 may query the (LeapController *) object.
 
 You must have a running NSRunLoop to receive NSNotification objects:
   [[NSRunLoop currentRunLoop] run];
 
 You can practically use a LeapListener-conforming class in ObjectiveC in
 place of a corresponding Leap::Listener-derived class in C++. Calling
 [controller addListener] takes care of the corresponding NSNotification
 addObserver:selector:name:object calls for standard Leap callbacks.
 LeapListener objects are the "observers" while a LeapController object is
 the notification "sender". You may also call
   [[NSNotificationCenter defaultCenter] addObserver:selector:name:object]
 for direct ObjectiveC-style control of the notifications.
 *************************************************************************/

@protocol LeapListener<NSObject>

@optional
- (void)onInit:(NSNotification *)notification;
- (void)onConnect:(NSNotification *)notification;
- (void)onDisconnect:(NSNotification *)notification;
- (void)onExit:(NSNotification *)notification;
- (void)onFrame:(NSNotification *)notification;

@end

//////////////////////////////////////////////////////////////////////////
//DELEGATE
/*************************************************************************
 LeapDelegate: A legacy alternative to LeapListener that uses ObjectiveC
 delegates.

 Note: Using callbacks (and thus this protocol) is not mandatory. See
 above 3a in the LeapController description.
 
 Delegates are simpler to understand than NSNotification objects, and the
 one-to-many communication feature is often not necessary anyway. Note
 a drawback of this delegate implementation is that callbacks come back
 on a thread different from the main thread (as in the Leap C++ API).

 Note: These method names do not match Apple's delegate naming guidelines
 (for which we would have chosen controllerDidConnect, controllerDidExit).
 However, developers are encouraged to use notifications (LeapListener)
 which do not have such a convention.
 *************************************************************************/

@protocol LeapDelegate<NSObject>

@optional
- (void)onInit:(LeapController *)controller;
- (void)onConnect:(LeapController *)controller;
- (void)onDisconnect:(LeapController *)controller;
- (void)onExit:(LeapController *)controller;
- (void)onFrame:(LeapController *)controller;

@end

@interface NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;

@end


//////////////////////////////////////////////////////////////////////////
