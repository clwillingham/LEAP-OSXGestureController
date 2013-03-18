/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import "LeapObjectiveC.h"

#include <string>
#import "Leap.h"

//////////////////////////////////////////////////////////////////////////
//VECTOR
@implementation LeapVector

// Xcode 4.3 and earlier do not auto-synthesize scalar properties
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

- (id)initWithX:(float)x y:(float)y z:(float)z;
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

- (id)initWithVector:(const LeapVector *)vector;
{
    self = [super init];
    if (self) {
        _x = [vector x];
        _y = [vector y];
        _z = [vector z];
    }
    return self;
}

- (id)initWithLeapVector:(void *)leapVector;
{
    self = [super init];
    if (self) {
        Leap::Vector *v = (Leap::Vector *)leapVector;
        _x = v->x;
        _y = v->y;
        _z = v->z;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f, %f)", _x, _y, _z];
}

- (float)pitch
{
    return atan2(_y, -_z);
}

- (float)roll
{
    return atan2(_x, -_y);
}

- (float)yaw
{
    return atan2(_x, -_z);
}

- (LeapVector *)plus:(const LeapVector *)vector
{
    return [[LeapVector alloc] initWithX:(_x + [vector x]) y:(_y + [vector y]) z:(_z + [vector z])];
}

- (LeapVector *)minus:(const LeapVector *)vector
{
    return [[LeapVector alloc] initWithX:(_x - [vector x]) y:(_y - [vector y]) z:(_z - [vector z])];
}

- (LeapVector *)negate
{
    return [[LeapVector alloc] initWithX:(-_x) y:(-_y) z:(-_z)];
}

- (LeapVector *)times:(float)scalar
{
    return [[LeapVector alloc] initWithX:(scalar*_x) y:(scalar*_y) z:(scalar*_z)];
}

- (LeapVector *)divide:(float)scalar
{
    return [[LeapVector alloc] initWithX:(_x/scalar) y:(_y/scalar) z:(_z/scalar)];
}

- (BOOL)equals:(const LeapVector *)vector
{
    return _x == [vector x] && _y == [vector y] && _z == [vector z];
}

- (float)dot:(LeapVector *)vector
{
    return _x * [vector x] + _y * [vector y] + _z * [vector z];
}

- (LeapVector *)cross:(LeapVector *)vector
{
    Leap::Vector me(_x, _y, _z);
    Leap::Vector other([vector x], [vector y], [vector z]);
    Leap::Vector product = me.cross(other);
    return [[LeapVector alloc] initWithX:product.x y:product.y z:product.z];
}

- (LeapVector *)normalized
{
    Leap::Vector me(_x, _y, _z);
    Leap::Vector norm = me.normalized();
    return [[LeapVector alloc] initWithX:norm.x y:norm.y z:norm.z];
}

- (NSArray *)toNSArray
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:_x], [NSNumber numberWithFloat:_y], [NSNumber numberWithFloat:_z], nil];
}

- (NSMutableData *)toFloatPointer
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:4 * sizeof(float)];
    float *rawData = (float *)[data mutableBytes];
    rawData[0] = _x;
    rawData[1] = _y;
    rawData[2] = _z;
    rawData[3] = 0; // encourage alignment
    return data;
}

+ (LeapVector *)zero
{
    const Leap::Vector& v = Leap::Vector::zero();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)xAxis;
{
    const Leap::Vector& v = Leap::Vector::xAxis();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)yAxis;
{
    const Leap::Vector& v = Leap::Vector::yAxis();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)zAxis;
{
    const Leap::Vector& v = Leap::Vector::zAxis();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)left;
{
    const Leap::Vector& v = Leap::Vector::left();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)right;
{
    const Leap::Vector& v = Leap::Vector::right();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)down;
{
    const Leap::Vector& v = Leap::Vector::down();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)up;
{
    const Leap::Vector& v = Leap::Vector::up();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)forward;
{
    const Leap::Vector& v = Leap::Vector::forward();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

+ (LeapVector *)backward;
{
    const Leap::Vector& v = Leap::Vector::backward();
    return [[LeapVector alloc] initWithX:v.x y:v.y z:v.z];
}

@end;

//////////////////////////////////////////////////////////////////////////
//MATRIX
@implementation LeapMatrix

// Xcode 4.2 does not auto-synthesize properties
@synthesize xBasis = _xBasis;
@synthesize yBasis = _yBasis;
@synthesize zBasis = _zBasis;
@synthesize origin = _origin;

- (id)initWithXBasis:(const LeapVector *)xBasis yBasis:(const LeapVector *)yBasis zBasis:(const LeapVector *)zBasis origin:(const LeapVector *)origin;
{
    self = [super init];
    if (self) {
        _xBasis = [[LeapVector alloc] initWithVector:xBasis];
        _yBasis = [[LeapVector alloc] initWithVector:yBasis];
        _zBasis = [[LeapVector alloc] initWithVector:zBasis];
        _origin = [[LeapVector alloc] initWithVector:origin];
    }
    return self;
}

- (id)initWithMatrix:(LeapMatrix *)matrix;
{
    self = [super init];
    if (self) {
        _xBasis = [[LeapVector alloc] initWithVector:[matrix xBasis]];
        _yBasis = [[LeapVector alloc] initWithVector:[matrix yBasis]];
        _zBasis = [[LeapVector alloc] initWithVector:[matrix zBasis]];
        _origin = [[LeapVector alloc] initWithVector:[matrix origin]];
    }
    return self;
}

- (id)initWithLeapMatrix:(void *)matrix;
{
    self = [super init];
    if (self) {
        Leap::Matrix *m = (Leap::Matrix *)matrix;
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m->xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m->yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m->zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m->origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians;
{
    self = [super init];
    if (self) {
        Leap::Vector v([axis x], [axis y], [axis z]);
        Leap::Matrix m(v, angleRadians);
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis angleRadians:(float)angleRadians translation:(const LeapVector *)translation;
{
    self = [super init];
    if (self) {
        Leap::Vector leapAxis([axis x], [axis y], [axis z]);
        Leap::Vector leapTranslation([translation x], [translation y], [translation z]);
        Leap::Matrix m(leapAxis, angleRadians, leapTranslation);
        _xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        _yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        _zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        _origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"xBasis:%@ yBasis:%@ zBasis:%@ origin:%@", _xBasis, _yBasis, _zBasis, _origin];
}

- (LeapVector *)transformPoint:(const LeapVector *)point
{
    LeapVector *a = [_xBasis times:[point x]];
    LeapVector *b = [_yBasis times:[point y]];
    LeapVector *c = [_zBasis times:[point z]];
    return [[[a plus:b] plus:c] plus:_origin];
}

- (LeapVector *)transformDirection:(const LeapVector *)direction;
{
    LeapVector *a = [_xBasis times:[direction x]];
    LeapVector *b = [_yBasis times:[direction y]];
    LeapVector *c = [_zBasis times:[direction z]];
    return [[a plus:b] plus:c];
}

- (LeapMatrix *)orthoNormalized;
{
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (LeapMatrix *)times:(const LeapMatrix *)other;
{
    LeapMatrix *unnormalized;
    unnormalized = [[LeapMatrix alloc] initWithXBasis:[self transformDirection:[other xBasis]] yBasis:[self transformDirection:[other yBasis]] zBasis:[self transformDirection:[other zBasis]] origin:[self transformPoint:[other origin]]];
    return [unnormalized orthoNormalized];
}

- (BOOL)equals:(const LeapMatrix *)other;
{
    return [_xBasis equals:[other xBasis]] && [_yBasis equals:[other yBasis]] && [_zBasis equals:[other zBasis]];
}

- (NSMutableArray *)toNSArray3x3
{
    float float_ar[9];
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    m.toArray3x3<float>(float_ar);
    NSMutableArray *ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < 9; i++) {
        [ar addObject:[NSNumber numberWithFloat:float_ar[i]]];
    }
    return ar;
}

- (NSMutableArray *)toNSArray4x4
{
    float float_ar[16];
    const Leap::Vector localXBasis([_xBasis x], [_xBasis y], [_xBasis z]);
    const Leap::Vector localYBasis([_yBasis x], [_yBasis y], [_yBasis z]);
    const Leap::Vector localZBasis([_zBasis x], [_zBasis y], [_zBasis z]);
    const Leap::Vector localOrigin([_origin x], [_origin y], [_origin z]);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    m.toArray4x4<float>(float_ar);
    NSMutableArray *ar = [NSMutableArray array];
    for (NSUInteger i = 0; i < 16; i++) {
        [ar addObject:[NSNumber numberWithFloat:float_ar[i]]];
    }
    return ar;
}

- (NSMutableData *)toFloatPointer3x3
{
    NSMutableArray *ar = [self toNSArray3x3];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:12 * sizeof(float)];
    float *rawData = (float *)data.mutableBytes;
    for (NSUInteger i = 0; i < 12; i++) {
        if (i < 9) {
            rawData[i] = [[ar objectAtIndex:i] floatValue];
        }
        else {
            rawData[i] = 0; // for alignment
        }
    }
    return data;
}

- (NSMutableData *)toFloatPointer4x4
{
    NSMutableArray *ar = [self toNSArray4x4];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:16 * sizeof(float)];
    float *rawData = (float *)data.mutableBytes;
    for (NSUInteger i = 0; i < 16; i++) {
        rawData[i] = [[ar objectAtIndex:i] floatValue];
    }
    return data;
}

+ (LeapMatrix *)identity;
{
    const Leap::Matrix& m = Leap::Matrix::identity();
    return [[LeapMatrix alloc] initWithLeapMatrix:(void *)&m];
}

@end

//////////////////////////////////////////////////////////////////////////
//POINTABLE
@implementation LeapPointable
{
    Leap::Pointable *_interfacePointable;
}

@synthesize frame = _frame;
@synthesize hand = _hand;

- (id)initWithPointable:(void *)pointable frame:(const LeapFrame *)frame hand:(const LeapHand *)hand
{
    self = [super init];
    if (self) {
        _interfacePointable = new Leap::Pointable(*(const Leap::Pointable *)pointable);
        _frame = frame;
        _hand = hand;
    }
    return self;
}

+ (LeapPointable *)typedPointableAlloc:(void *)leapPointable
{
    LeapPointable *pointable;
    const Leap::Pointable *castedPointable = (const Leap::Pointable *)leapPointable;
    if (castedPointable->isFinger()) {
        pointable = [LeapFinger alloc];
    } else if (castedPointable->isTool()) {
        pointable = [LeapTool alloc];
    }
    else {
        pointable = [LeapPointable alloc];
    }
    return pointable;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Pointable";
    }
    return [NSString stringWithFormat:@"Pointable Id:%d", [self id]];
}

- (void *)interfacePointable
{
    return _interfacePointable;
}

- (int32_t)id
{
    return _interfacePointable->id();
}

- (const LeapVector *)tipPosition
{
    return [[LeapVector alloc] initWithX:_interfacePointable->tipPosition().x y:_interfacePointable->tipPosition().y z:_interfacePointable->tipPosition().z];
}

- (const LeapVector *)tipVelocity
{
    return [[LeapVector alloc] initWithX:_interfacePointable->tipVelocity().x y:_interfacePointable->tipVelocity().y z:_interfacePointable->tipVelocity().z];
}

- (const LeapVector *)direction
{
    return [[LeapVector alloc] initWithX:_interfacePointable->direction().x y:_interfacePointable->direction().y z:_interfacePointable->direction().z];
}

- (float)width
{
    return _interfacePointable->width();
}

- (float)length
{
    return _interfacePointable->length();
}

- (BOOL)isFinger
{
    return _interfacePointable->isFinger();
}

- (BOOL)isTool
{
    return _interfacePointable->isTool();
}

- (BOOL)isValid
{
    return _interfacePointable->isValid();
}

- (const LeapFrame *)frame
{
    NSAssert(_frame != nil, @"Pointable's frame property has been deallocated due to weak ARC reference. Retain a strong pointer to this frame if you wish to access it later.");
    return _frame;
}

- (const LeapHand *)hand
{
    NSAssert(_hand != nil, @"Pointable's finger property has been deallocated due to weak ARC reference. Retain a strong pointer to this hand if you wish to access it later.");
    return _hand;
}

- (void)dealloc
{
    delete _interfacePointable;
}

+ (LeapPointable *)invalid
{
    static const Leap::Pointable &invalid_pointable = Leap::Pointable::invalid();
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_pointable frame:nil hand:nil];
    return pointable;
}

@end;

//////////////////////////////////////////////////////////////////////////
//FINGER
@implementation LeapFinger : LeapPointable

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Finger";
    }
    return [NSString stringWithFormat:@"Finger Id:%d", [self id]];
}

+ (LeapPointable *)invalid
{
    static const Leap::Finger &invalid_finger = Leap::Finger::invalid();
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_finger frame:nil hand:nil];
    return pointable;
}

@end

//////////////////////////////////////////////////////////////////////////
//TOOL
@implementation LeapTool : LeapPointable

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Tool";
    }
    return [NSString stringWithFormat:@"Tool Id:%d", self.id];
}

+ (LeapPointable *)invalid
{
    static const Leap::Tool &invalid_tool = Leap::Tool::invalid();
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&invalid_tool frame:nil hand:nil];
    return pointable;
}

@end

//////////////////////////////////////////////////////////////////////////
//HAND
@implementation LeapHand
{
    Leap::Hand *_interfaceHand;
}

@synthesize frame = _frame;

- (id)initWithHand:(void *)hand frame:(const LeapFrame *)frame
{
    self = [super init];
    if (self) {
        _interfaceHand = new Leap::Hand(*(const Leap::Hand *)hand);
        _frame = frame;
    }
    return self;
}

- (NSString *)description
{
    if (![self isValid]) {
        return @"Invalid Hand";
    }
    return [NSString stringWithFormat:@"Hand Id:%d", [self id]];
}

- (int32_t)id
{
    return _interfaceHand->id();
}

- (NSArray *)pointables
{
    NSMutableArray *pointables_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->pointables().count(); i++) {
        const Leap::Pointable &tmpLeapPointable = _interfaceHand->pointables()[i];
        LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:_frame hand:self];
        [pointables_ar addObject:pointable];
    }
    return [NSArray arrayWithArray:pointables_ar];
}

- (NSArray *)fingers
{
    NSMutableArray *fingers_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->fingers().count(); i++) {
        const Leap::Finger &tmpLeapFinger = _interfaceHand->fingers()[i];
        LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self];
        [fingers_ar addObject:finger];
    }
    return [NSArray arrayWithArray:fingers_ar];
}

- (NSArray *)tools
{
    NSMutableArray *tools_ar = [NSMutableArray array];
    for (int i = 0; i < _interfaceHand->tools().count(); i++) {
        const Leap::Tool &tmpLeapTool = _interfaceHand->tools()[i];
        LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self];
        [tools_ar addObject:tool];
    }
    return [NSArray arrayWithArray:tools_ar];
}

- (const LeapPointable *)pointable:(int32_t)pointable_id
{
    const Leap::Pointable &tmpLeapPointable = _interfaceHand->pointable(pointable_id);
    return [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:_frame hand:self];
}

- (const LeapFinger *)finger:(int32_t)finger_id
{
    const Leap::Finger &tmpLeapFinger = _interfaceHand->finger(finger_id);
    return [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:_frame hand:self];
}

- (const LeapTool *)tool:(int32_t)tool_id
{
    const Leap::Tool &tmpLeapTool = _interfaceHand->tool(tool_id);
    return [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:_frame hand:self];
}

- (const LeapVector *)palmPosition
{
    return [[LeapVector alloc] initWithX:_interfaceHand->palmPosition().x y:_interfaceHand->palmPosition().y z:_interfaceHand->palmPosition().z];
}

- (const LeapVector *)palmVelocity
{
    return [[LeapVector alloc] initWithX:_interfaceHand->palmVelocity().x y:_interfaceHand->palmVelocity().y z:_interfaceHand->palmVelocity().z];
}

- (const LeapVector *)palmNormal
{
    return [[LeapVector alloc] initWithX:_interfaceHand->palmNormal().x y:_interfaceHand->palmNormal().y z:_interfaceHand->palmNormal().z];
}

- (const LeapVector *)direction
{
    return [[LeapVector alloc] initWithX:_interfaceHand->direction().x y:_interfaceHand->direction().y z:_interfaceHand->direction().z];
}

- (const LeapVector *)sphereCenter
{
    return [[LeapVector alloc] initWithX:_interfaceHand->sphereCenter().x y:_interfaceHand->sphereCenter().y z:_interfaceHand->sphereCenter().z];
}

- (float)sphereRadius
{
    return _interfaceHand->sphereRadius();
}

- (BOOL)isValid
{
    return _interfaceHand->isValid();
}

- (const LeapFrame *)frame
{
    NSAssert(_frame != nil, @"Hand's frame has been deallocated due to weak ARC reference. Retain a strong pointer to this frame if you wish to access it later.");
    return _frame;
}

- (void)dealloc
{
    delete _interfaceHand;
}

- (LeapVector *)translation:(const LeapFrame *)since_frame
{
    Leap::Vector v = _interfaceHand->translation(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame
{
    Leap::Vector v = _interfaceHand->rotationAxis(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (float)rotationAngle:(const LeapFrame *)since_frame
{
    return _interfaceHand->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)since_frame axis:(const LeapVector *)axis
{
    Leap::Vector v([axis x], [axis y], [axis z]);
    return _interfaceHand->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame
{
    Leap::Matrix m = _interfaceHand->rotationMatrix(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (float)scaleFactor:(const LeapFrame *)since_frame
{
    return _interfaceHand->scaleFactor(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

+ (LeapHand *)invalid
{
    static const Leap::Hand &invalid_hand = Leap::Hand::invalid();
    LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&invalid_hand frame:nil];
    return hand;
}

@end;

//////////////////////////////////////////////////////////////////////////
//SCREEN
@implementation LeapScreen
{
    Leap::Screen *_interfaceScreen;
}

- (id)initWithScreen:(void *)screen
{
    self = [super init];
    if (self) {
        _interfaceScreen = new Leap::Screen(*(const Leap::Screen *)screen);
    }
    return self;
}

- (NSString *)description
{
    std::string str = _interfaceScreen->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceScreen
{
    return (void *)_interfaceScreen;
}

- (int32_t)id
{
    return _interfaceScreen->id();
}

- (LeapVector *)intersect:(LeapPointable *)pointable normalize:(BOOL)normalize clampRatio:(float)clampRatio
{
    const Leap::Pointable *leapPointable = (const Leap::Pointable *)[pointable interfacePointable];
    Leap::Vector v = _interfaceScreen->intersect(*leapPointable, normalize, clampRatio);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)horizontalAxis
{
    Leap::Vector v = _interfaceScreen->horizontalAxis();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)verticalAxis
{
    Leap::Vector v = _interfaceScreen->verticalAxis();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)bottomLeftCorner
{
    Leap::Vector v = _interfaceScreen->bottomLeftCorner();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)normal
{
    Leap::Vector v = _interfaceScreen->normal();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (int)widthPixels
{
    return _interfaceScreen->widthPixels();
}

- (int)heightPixels
{
    return _interfaceScreen->heightPixels();
}

- (float)distanceToPoint:(const LeapVector *)point
{
    Leap::Vector p([point x], [point y], [point z]);
    return _interfaceScreen->distanceToPoint(p);
}

- (BOOL)isValid
{
    return _interfaceScreen->isValid();
}

- (BOOL)equals:(const LeapScreen *)other
{
    return *_interfaceScreen == *(const Leap::Screen *)[other interfaceScreen];
}

- (void)dealloc
{
    delete _interfaceScreen;
}

+ (const LeapScreen *)invalid
{
    static const Leap::Screen &invalid_screen = Leap::Screen::invalid();
    return [[LeapScreen alloc] initWithScreen:(void *)&invalid_screen];
}

@end;

/////////////////////////////////////////////////////////////////////////
//GESTURE
@implementation LeapGesture
{
    Leap::Gesture *_interfaceGesture;
}

@synthesize frame = _frame;
@synthesize hands = _hands;
@synthesize pointables = _pointables;

- (id)initWithGesture:(void *)leapGesture frame:(LeapFrame *)frame
{
    self = [super init];
    if (self) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        Leap::Frame leapFrame = *(Leap::Frame *)[frame interfaceFrame];
        switch(((const Leap::Gesture *)leapGesture)->type()) {
            case LEAP_GESTURE_TYPE_SWIPE:
                _interfaceGesture = new Leap::SwipeGesture(*(const Leap::SwipeGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_CIRCLE:
                _interfaceGesture = new Leap::CircleGesture(*(const Leap::CircleGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_SCREEN_TAP:
                _interfaceGesture = new Leap::ScreenTapGesture(*(const Leap::ScreenTapGesture *)leapGesture);
                break;
            case LEAP_GESTURE_TYPE_KEY_TAP:
                _interfaceGesture = new Leap::KeyTapGesture(*(const Leap::KeyTapGesture *)leapGesture);
                break;
            default:
                _interfaceGesture = new Leap::Gesture(*(const Leap::Gesture *)leapGesture);
        }
        _frame = frame;
        
        NSMutableArray *hands_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.hands().count(); i++) {
            const Leap::Hand &tmpLeapHand = leapFrame.hands()[i];
            LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:frame];
            [hands_ar addObject:hand];
            [dictionary setObject:hand forKey:[NSNumber numberWithUnsignedInteger:tmpLeapHand.id()]];
        }
        _hands = [NSArray arrayWithArray:hands_ar];
        
        NSMutableArray *pointables_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.pointables().count(); i++) {
            const Leap::Pointable &tmpLeapPointable = leapFrame.pointables()[i];
            const LeapHand *hand;
            if (tmpLeapPointable.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapPointable.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
            LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:frame hand:hand];
            [pointables_ar addObject:pointable];
        }
        _pointables = [NSArray arrayWithArray:pointables_ar];

    }
    return self;
}

- (NSString *)description
{
    std::string str = _interfaceGesture->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceGesture
{
    return (void *)_interfaceGesture;
}

- (LeapGestureType)type
{
    return (LeapGestureType)_interfaceGesture->type();
}

- (LeapGestureState)state
{
    return (LeapGestureState)_interfaceGesture->state();
}

- (int32_t)id
{
    return _interfaceGesture->id();
}

- (int64_t)duration
{
    return _interfaceGesture->duration();
}

- (float)durationSeconds
{
    return _interfaceGesture->durationSeconds();
}

- (BOOL)isValid
{
    return _interfaceGesture->isValid();
}

- (BOOL)equals:(const LeapGesture *)other
{
    return *_interfaceGesture == *(const Leap::Gesture *)[other interfaceGesture];
}

- (void)dealloc
{
    delete _interfaceGesture;
}

+ (const LeapGesture *)invalid
{
    static const Leap::Gesture &invalid_gesture = Leap::Gesture::invalid();
    return [[LeapGesture alloc] initWithGesture:(void *)&invalid_gesture frame:nil];
}

@end


//////////////////////////////////////////////////////////////////////////
//SWIPE GESTURE
@implementation LeapSwipeGesture : LeapGesture

- (const LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->position();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (const LeapVector *)startPosition
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->startPosition();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (const LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::SwipeGesture *)[self interfaceGesture])->direction();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (float)speed
{
    return ((const Leap::SwipeGesture *)[self interfaceGesture])->speed();
}

- (const LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::SwipeGesture *)[self interfaceGesture])->pointable();
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:nil];
}

@end

//////////////////////////////////////////////////////////////////////////
//CIRCLE GESTURE
@implementation LeapCircleGesture : LeapGesture

- (float)progress
{
    return ((const Leap::CircleGesture *)[self interfaceGesture])->progress();
}

- (const LeapVector *)center
{
    const Leap::Vector &leapVector = ((const Leap::CircleGesture *)[self interfaceGesture])->center();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (const LeapVector *)normal
{
    const Leap::Vector &leapVector = ((const Leap::CircleGesture *)[self interfaceGesture])->normal();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (float)radius
{
    return ((const Leap::CircleGesture *)[self interfaceGesture])->radius();
}

- (const LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::CircleGesture *)[self interfaceGesture])->pointable();
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:nil];
}

@end

//////////////////////////////////////////////////////////////////////////
//SCREEN TAP GESTURE
@implementation LeapScreenTapGesture : LeapGesture

- (const LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->position();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (const LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->direction();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (float)progress
{
    return ((const Leap::ScreenTapGesture *)[self interfaceGesture])->progress();
}

- (const LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::ScreenTapGesture *)[self interfaceGesture])->pointable();
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:nil];
}

@end

//////////////////////////////////////////////////////////////////////////
//KEY TAP GESTURE
@implementation LeapKeyTapGesture : LeapGesture

- (const LeapVector *)position
{
    const Leap::Vector &leapVector = ((const Leap::KeyTapGesture *)[self interfaceGesture])->position();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (const LeapVector *)direction
{
    const Leap::Vector &leapVector = ((const Leap::KeyTapGesture *)[self interfaceGesture])->direction();
    return [[LeapVector alloc]initWithX:leapVector.x y:leapVector.y z:leapVector.z];
}

- (float)progress
{
    return ((const Leap::KeyTapGesture *)[self interfaceGesture])->progress();
}

- (const LeapPointable *)pointable
{
    const Leap::Pointable &leapPointable = ((const Leap::KeyTapGesture *)[self interfaceGesture])->pointable();
    return [[LeapPointable typedPointableAlloc:(void *)&leapPointable]initWithPointable:(void *)&leapPointable frame:[self frame] hand:nil];
}

@end

//////////////////////////////////////////////////////////////////////////
//FRAME
@implementation LeapFrame
{
    Leap::Frame *_interfaceFrame;
}

@synthesize hands = _hands;
@synthesize pointables = _pointables;
@synthesize fingers = _fingers;
@synthesize tools = _tools;

- (id)initWithFrame:(const void *)frame
{
    self = [super init];
    if (self) {
        _interfaceFrame = new Leap::Frame(*(const Leap::Frame *)frame);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        Leap::Frame leapFrame = *(Leap::Frame *)frame;

        NSMutableArray *hands_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.hands().count(); i++) {
            const Leap::Hand &tmpLeapHand = leapFrame.hands()[i];
            LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) frame:self];
            [hands_ar addObject:hand];
            [dictionary setObject:hand forKey:[NSNumber numberWithUnsignedInteger:tmpLeapHand.id()]];
        }
        _hands = [NSArray arrayWithArray:hands_ar];

        NSMutableArray *pointables_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.pointables().count(); i++) {
            const Leap::Pointable &tmpLeapPointable = leapFrame.pointables()[i];
            const LeapHand *hand;
            if (tmpLeapPointable.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapPointable.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
            LeapPointable *pointable = [[LeapPointable typedPointableAlloc:(void *)&tmpLeapPointable] initWithPointable:(void *)&tmpLeapPointable frame:self hand:hand];
            [pointables_ar addObject:pointable];
        }
        _pointables = [NSArray arrayWithArray:pointables_ar];

        NSMutableArray *fingers_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.fingers().count(); i++) {
            const Leap::Finger &tmpLeapFinger = leapFrame.fingers()[i];
            const LeapHand *hand;
            if (tmpLeapFinger.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapFinger.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
            LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger frame:self hand:hand];
            [fingers_ar addObject:finger];
        }
        _fingers = [NSArray arrayWithArray:fingers_ar];

        NSMutableArray *tools_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.tools().count(); i++) {
            const Leap::Tool &tmpLeapTool = leapFrame.tools()[i];
            const LeapHand *hand;
            if (tmpLeapTool.hand().isValid()) {
                hand = [dictionary objectForKey:[NSNumber numberWithUnsignedInteger:tmpLeapTool.hand().id()]];
            }
            else {
                hand = [LeapHand invalid];
            }
            LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool frame:self hand:hand];
            [tools_ar addObject:tool];
        }
        _tools = [NSArray arrayWithArray:tools_ar];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Frame Id:%lld", self.id];
}

- (void *)interfaceFrame
{
    return (void *)_interfaceFrame;
}

- (int64_t)id
{
    return _interfaceFrame->id();
}

- (int64_t)timestamp
{
    return _interfaceFrame->timestamp();
}

- (const LeapHand *)hand:(int32_t)hand_id
{
    NSEnumerator *e = [_hands objectEnumerator];
    LeapHand *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == hand_id) {
            return obj;
        }
    }
    return [LeapHand invalid];
}

- (const LeapPointable *)pointable:(int32_t)pointable_id
{
    NSEnumerator *e = [_pointables objectEnumerator];
    LeapPointable *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == pointable_id) {
            return obj;
        }
    }
    return [LeapPointable invalid];
}

- (const LeapPointable *)finger:(int32_t)finger_id
{
    NSEnumerator *e = [_fingers objectEnumerator];
    LeapFinger *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == finger_id) {
            return obj;
        }
    }
    return [LeapFinger invalid];
}

- (const LeapPointable *)tool:(int32_t)tool_id
{
    NSEnumerator *e = [_tools objectEnumerator];
    LeapTool *obj;
    while (obj = [e nextObject]) {
        if ([obj id] == tool_id) {
            return obj;
        }
    }
    return [LeapTool invalid];
}

- (void)dealloc
{
    delete _interfaceFrame;
}

- (LeapGesture *)typedGestureCreate:(void *)leapGesture
{
    LeapGesture *gesture;
    switch(((const Leap::Gesture *)leapGesture)->type()) {
        case LEAP_GESTURE_TYPE_SWIPE:
            gesture = [LeapSwipeGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_CIRCLE:
            gesture = [LeapCircleGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_SCREEN_TAP:
            gesture = [LeapScreenTapGesture alloc];
            break;
        case LEAP_GESTURE_TYPE_KEY_TAP:
            gesture = [LeapKeyTapGesture alloc];
            break;
        default:
            gesture = [LeapGesture alloc];
    }
    return [gesture initWithGesture:leapGesture frame:self];
}

- (NSArray *)gestures:(const LeapFrame *)since_frame
{
    Leap::GestureList leapGestures = (since_frame == nil ?
                                      _interfaceFrame->gestures() :
                                      _interfaceFrame->gestures(*(Leap::Frame*)[since_frame interfaceFrame]));
    NSMutableArray *gestures_ar = [NSMutableArray array];
    for (Leap::GestureList::const_iterator it = leapGestures.begin(); it != leapGestures.end(); ++it) {
        const Leap::Gesture leapGesture = *it;
        LeapGesture *gesture = [self typedGestureCreate:(void *)&leapGesture];
        [gestures_ar addObject:gesture];
    }
    return [NSArray arrayWithArray:gestures_ar];
}

- (LeapGesture *)gesture:(int32_t) gesture_id
{
    Leap::Gesture leapGesture = _interfaceFrame->gesture(gesture_id);
    return [self typedGestureCreate:(void *)&leapGesture];
}

- (LeapVector *)translation:(const LeapFrame *)since_frame
{
    Leap::Vector v = _interfaceFrame->translation(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame
{
    Leap::Vector v = _interfaceFrame->rotationAxis(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (float)rotationAngle:(const LeapFrame *)since_frame
{
    return _interfaceFrame->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)since_frame axis:(const LeapVector *)axis
{
    Leap::Vector v([axis x], [axis y], [axis z]);
    return _interfaceFrame->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame
{
    Leap::Matrix m = _interfaceFrame->rotationMatrix(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (float)scaleFactor:(const LeapFrame *)since_frame
{
    return _interfaceFrame->scaleFactor(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

- (BOOL)isValid
{
    return _interfaceFrame->isValid();
}

+ (LeapFrame *)invalid
{
    static const Leap::Frame &invalid_frame = Leap::Frame::invalid();
    return [[LeapFrame alloc]initWithFrame:(void *)&invalid_frame];
}

@end;

//////////////////////////////////////////////////////////////////////////
//CONFIG
@implementation LeapConfig
{
    Leap::Config _config;
}

- (id)initWithConfig:(void *)config
{
    self = [super init];
    if (self) {
        _config = *(Leap::Config *)config;
    }
    return self;
}

- (LeapValueType)convertFromLeapValueType:(Leap::Config::ValueType)val
{
    switch(val) {
        case Leap::Config::ValueType::TYPE_UNKNOWN:
            return TYPE_UNKNOWN;
        case Leap::Config::ValueType::TYPE_BOOLEAN:
            return TYPE_BOOLEAN;
        case Leap::Config::ValueType::TYPE_INT32:
            return TYPE_INT32;
        case Leap::Config::ValueType::TYPE_UINT32:
            return TYPE_UINT32;
        case Leap::Config::ValueType::TYPE_INT64:
            return TYPE_INT64;
        case Leap::Config::ValueType::TYPE_UINT64:
            return TYPE_UINT64;
        case Leap::Config::ValueType::TYPE_FLOAT:
            return TYPE_FLOAT;
        case Leap::Config::ValueType::TYPE_DOUBLE:
            return TYPE_DOUBLE;
        case Leap::Config::ValueType::TYPE_STRING:
            return TYPE_STRING;
        default:
            return TYPE_UNKNOWN;
    }
}

- (LeapValueType)type:(NSString *)key;
{
    std::string *keyString = new std::string([key UTF8String]);
    Leap::Config::ValueType val = _config.type(*keyString);
    free(keyString);
    return [self convertFromLeapValueType:val];
}

- (BOOL)getBool:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL val = _config.getBool(*keyString);
    free(keyString);
    return val;
}

- (int32_t)getInt32:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    int32_t val = _config.getInt32(*keyString);
    free(keyString);
    return val;
}

- (int64_t)getInt64:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    int64_t val = _config.getInt64(*keyString);
    free(keyString);
    return val;
}

- (uint32_t)getUInt32:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    uint32_t val = _config.getUInt32(*keyString);
    free(keyString);
    return val;
}

- (uint64_t)getUInt64:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    uint64_t val = _config.getUInt64(*keyString);
    free(keyString);
    return val;
}

- (float)getFloat:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    float val = _config.getFloat(*keyString);
    free(keyString);
    return val;
}

- (float)getDouble:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    float val = _config.getDouble(*keyString);
    free(keyString);
    return val;
}

- (NSString *)getString:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    std::string str = _config.getString(*keyString);
    NSString *val = [[NSString alloc] initWithUTF8String:str.c_str()];
    free(keyString);
    return val;
}

@end;

//////////////////////////////////////////////////////////////////////////
//NOTIFICATION LISTENER
class LeapNotificationListener : public Leap::Listener
{
public:
    virtual void onInit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnInit" object:_controller];
        }
    }

    virtual void onConnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnConnect" object:_controller];
        }
    }

    virtual void onDisconnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnDisconnect" object:_controller];
        }
    }

    virtual void onExit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnExit" object:_controller];
        }
    }

    virtual void onFrame(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"OnFrame" object:_controller];
        }
    }

    void setController(LeapController *controller)
    {
        _controller = controller;
    }

private:
    LeapController *_controller;
};

//////////////////////////////////////////////////////////////////////////
//DELEGATE LISTENER
class LeapDelegateListener : public Leap::Listener
{
public:
    virtual void onInit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onInit:)]) {
                [_delegate onInit:_controller];
            }
        }
    }
    
    virtual void onConnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onConnect:)]) {
                [_delegate onConnect:_controller];
            }
        }
    }
    
    virtual void onDisconnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onDisconnect:)]) {
                [_delegate onDisconnect:_controller];
            }
        }
    }
    
    virtual void onExit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onExit:)]) {
                [_delegate onExit:_controller];
            }
        }
    }
    
    virtual void onFrame(const Leap::Controller& leapController)
    {
        @autoreleasepool {
            if ([_delegate respondsToSelector:@selector(onFrame:)]) {
                [_delegate onFrame:_controller];
            }
        }
    }
    
    void setController(LeapController *controller)
    {
        _controller = controller;
    }
    
    void initWithDelegate(id<LeapDelegate> delegate)
    {
        _delegate = delegate;
    }

    id<LeapDelegate> _delegate;
private:
    LeapController *_controller;
};

//////////////////////////////////////////////////////////////////////////
//CONTROLLER
@implementation LeapController
{
    Leap::Controller *_controller;
    Leap::Listener *_listener;
}

// initWithController is used only by the wrapper
- (id)initWithController:(void *)controller
{
    self = [super init];
    if (self) {
        _controller = (Leap::Controller *)controller;
        _listener = NULL;
    }
    return self;
}

// init and initWithDelegate may be called by the user
- (id)init
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        _controller = new Leap::Controller();
        _listener = NULL;
    }
    return self;
}

- (id)initWithListener:(id<LeapListener>)leapListener
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        LeapNotificationListener *notificationListener = new LeapNotificationListener();
        notificationListener->setController(self);
        _listener = notificationListener;
        _controller = new Leap::Controller(*_listener);
    }
    return self;
}

- (BOOL)addListener:(id<LeapListener>)listener
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if ([listener respondsToSelector:@selector(onInit:)]) {
        [nc addObserver:listener selector:@selector(onInit:) name:@"OnInit" object:self];
    }
    if ([listener respondsToSelector:@selector(onConnect:)]) {
        [nc addObserver:listener selector:@selector(onConnect:) name:@"OnConnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onDisconnect:)]) {
        [nc addObserver:listener selector:@selector(onDisconnect:) name:@"OnDisconnect" object:self];
    }
    if ([listener respondsToSelector:@selector(onExit:)]) {
        [nc addObserver:listener selector:@selector(onExit:) name:@"OnExit" object:self];
    }
    if ([listener respondsToSelector:@selector(onInit:)]) {
        [nc addObserver:listener selector:@selector(onFrame:) name:@"OnFrame" object:self];
    }

    if (!_listener) {
        LeapNotificationListener *notificationListener = new LeapNotificationListener();
        notificationListener->setController(self);
        _listener = notificationListener;
        _controller->addListener(*notificationListener);
        // note: Because we use a single C++ Leap::Listener per controller under the hood, if you
        // have more than one LeapListener, only the first will receive @"OnInit"
    }
    return TRUE;
}

- (BOOL)removeListener:(id<LeapListener>)listener
{
    [[NSNotificationCenter defaultCenter] removeObserver:listener];
    return TRUE;
}

- (id)initWithDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(!_controller, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        LeapDelegateListener *delegateListener = new LeapDelegateListener();
        delegateListener->initWithDelegate(leapDelegate);
        delegateListener->setController(self);
        _listener = delegateListener;
        _controller = new Leap::Controller(*_listener);
    }
    return self;
}

- (BOOL)addDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(_listener == NULL, @"Delegates are one-to-one, cannot have more than one LeapDelegate per LeapController. Use the LeapListener object for the NSNotification pattern instead. (And no mixing of delegates and the LeapListener NSNotification pattern on a single controller)");
    LeapDelegateListener *delegateListener = new LeapDelegateListener();
    delegateListener->initWithDelegate(leapDelegate);
    delegateListener->setController(self);
    _listener = delegateListener;
    _controller->addListener(*_listener);
    return TRUE;
}

- (BOOL)removeDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(_listener, @"Must call addDelegate before trying to remove a LeapDelegate");
    _controller->removeListener(*_listener);
    _listener = NULL;
    return TRUE;
}

- (LeapFrame *)frame:(int)history
{
    Leap::Frame leapFrame = _controller->frame(history);
    LeapFrame *frame = [[LeapFrame alloc] initWithFrame:(void *)&leapFrame];
    return frame;
}

- (LeapConfig *)config;
{
    Leap::Config leapConfig = _controller->config();
    LeapConfig *config = [[LeapConfig alloc] initWithConfig:(void *)&leapConfig];
    return config;
}

- (BOOL)isConnected
{
    return _controller->isConnected();
}

- (void)enableGesture:(LeapGestureType)gesture_type enable:(BOOL)enable
{
    _controller->enableGesture(Leap::Gesture::Type(gesture_type), enable);
}

- (BOOL)isGestureEnabled:(LeapGestureType)gesture_type;
{
    return _controller->isGestureEnabled(Leap::Gesture::Type(gesture_type));
}

- (NSArray *)calibratedScreens;
{
    Leap::ScreenList leapScreens = _controller->calibratedScreens();
    NSMutableArray *screens_ar = [NSMutableArray array];
    for (Leap::ScreenList::const_iterator it = leapScreens.begin(); it != leapScreens.end(); ++it) {
        Leap::Screen leapScreen = *it;
        LeapScreen *screen = [[LeapScreen alloc] initWithScreen:(void *)&leapScreen];
        [screens_ar addObject:screen];
    }
    return [NSArray arrayWithArray:screens_ar];
}

- (void)dealloc
{
    if (_listener) {
        _controller->removeListener(*_listener);
        delete _listener;
    }
    if (_controller) {
        delete _controller;
    }
}

@end;

@implementation NSNotificationCenter (MainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification
{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
}

- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject
{
	NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
	[self postNotificationOnMainThread:notification];
}

@end

const float LEAP_PI = Leap::PI;
const float LEAP_DEG_TO_RAD = Leap::DEG_TO_RAD;
const float LEAP_RAD_TO_DEG = Leap::RAD_TO_DEG; 
