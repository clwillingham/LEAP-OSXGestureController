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

@synthesize x;
@synthesize y;
@synthesize z;

- (id)initWithX:(float)leapX withY:(float)leapY withZ:(float)leapZ;
{
    self = [super init];
    if (self) {
        x = leapX;
        y = leapY;
        z = leapZ;
    }
    return self;
}

- (id)initWithVector:(const LeapVector *)aVector;
{
    self = [super init];
    if (self) {
        x = aVector.x;
        y = aVector.y;
        z = aVector.z;
    }
    return self;
}

- (id)initWithLeapVector:(void *)leapVector;
{
    self = [super init];
    if (self) {
        Leap::Vector *v = (Leap::Vector *)leapVector;
        x = v->x;
        y = v->y;
        z = v->z;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%f, %f, %f)", x, y, z];
}

- (float)pitch
{
    return atan2(y, -z);
}

- (float)roll
{
    return atan2(x, -y);
}

- (float)yaw
{
    return atan2(x, -z);
}

- (LeapVector *)plus:(const LeapVector *)vector
{
    return [[LeapVector alloc] initWithX:(x + vector.x) withY:(y + vector.y) withZ:(z + vector.z)];
}

- (LeapVector *)minus:(const LeapVector *)vector
{
    return [[LeapVector alloc] initWithX:(x - vector.x) withY:(y - vector.y) withZ:(z - vector.z)];
}

- (LeapVector *)negate
{
    return [[LeapVector alloc] initWithX:(-x) withY:(-y) withZ:(-z)];
}

- (LeapVector *)times:(float)scalar
{
    return [[LeapVector alloc] initWithX:(scalar*x) withY:(scalar*y) withZ:(scalar*z)];
}

- (LeapVector *)divide:(float)scalar
{
    return [[LeapVector alloc] initWithX:(x/scalar) withY:(y/scalar) withZ:(z/scalar)];
}

- (BOOL)equals:(const LeapVector *)vector
{
    return x == vector.x && y == vector.y && z == vector.z;
}

- (float)dot:(LeapVector *)vector
{
    return x * vector.x + y * vector.y + z * vector.z;
}

- (LeapVector *)cross:(LeapVector *)vector
{
    Leap::Vector me(x, y, z );
    Leap::Vector other(vector.x, vector.y, vector.z);
    Leap::Vector product = me.cross(other);
    return [[LeapVector alloc] initWithX:product.x withY:product.y withZ:product.z];
}

- (LeapVector *)normalized
{
    Leap::Vector me(x, y, z);
    Leap::Vector norm = me.normalized();
    return [[LeapVector alloc] initWithX:norm.x withY:norm.y withZ:norm.z];
}

- (NSArray *)toNSArray
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], [NSNumber numberWithFloat:z], nil];
}

- (NSMutableData *)toFloatPointer
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:4 * sizeof(float)];
    float *rawData = (float *)data.mutableBytes;
    rawData[0] = x;
    rawData[1] = y;
    rawData[2] = z;
    rawData[3] = 0; // encourage alignment
    return data;
}

+ (LeapVector *)zero
{
    const Leap::Vector& v = Leap::Vector::zero();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)xAxis;
{
    const Leap::Vector& v = Leap::Vector::xAxis();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)yAxis;
{
    const Leap::Vector& v = Leap::Vector::yAxis();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)zAxis;
{
    const Leap::Vector& v = Leap::Vector::zAxis();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)left;
{
    const Leap::Vector& v = Leap::Vector::left();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)right;
{
    const Leap::Vector& v = Leap::Vector::right();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)down;
{
    const Leap::Vector& v = Leap::Vector::down();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)up;
{
    const Leap::Vector& v = Leap::Vector::up();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)forward;
{
    const Leap::Vector& v = Leap::Vector::forward();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

+ (LeapVector *)backward;
{
    const Leap::Vector& v = Leap::Vector::backward();
    return [[LeapVector alloc] initWithX:v.x withY:v.y withZ:v.z];
}

@end;

//////////////////////////////////////////////////////////////////////////
//MATRIX
@implementation LeapMatrix

@synthesize xBasis;
@synthesize yBasis;
@synthesize zBasis;
@synthesize origin;

- (id)initWithXBasis:(const LeapVector *)aXBasis withYBasis:(const LeapVector *)aYBasis withZBasis:(const LeapVector *)aZBasis withOrigin:(const LeapVector *)aOrigin;
{
    self = [super init];
    if (self) {
        xBasis = [[LeapVector alloc] initWithVector:aXBasis];
        yBasis = [[LeapVector alloc] initWithVector:aYBasis];
        zBasis = [[LeapVector alloc] initWithVector:aZBasis];
        origin = [[LeapVector alloc] initWithVector:aOrigin];
    }
    return self;
}

- (id)initWithMatrix:(LeapMatrix *)matrix;
{
    self = [super init];
    if (self) {
        xBasis = [[LeapVector alloc] initWithVector:matrix.xBasis];
        yBasis = [[LeapVector alloc] initWithVector:matrix.yBasis];
        zBasis = [[LeapVector alloc] initWithVector:matrix.zBasis];
        origin = [[LeapVector alloc] initWithVector:matrix.origin];
    }
    return self;
}

- (id)initWithLeapMatrix:(void *)matrix;
{
    self = [super init];
    if (self) {
        Leap::Matrix *m = (Leap::Matrix *)matrix;
        xBasis = [[LeapVector alloc] initWithLeapVector:&m->xBasis];
        yBasis = [[LeapVector alloc] initWithLeapVector:&m->yBasis];
        zBasis = [[LeapVector alloc] initWithLeapVector:&m->zBasis];
        origin = [[LeapVector alloc] initWithLeapVector:&m->origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis withAngleRadians:(float)angleRadians;
{
    self = [super init];
    if (self) {
        Leap::Vector v(axis.x, axis.y, axis.z);
        Leap::Matrix m(v, angleRadians);
        xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (id)initWithAxis:(const LeapVector *)axis withAngleRadians:(float)angleRadians withTranslation:(const LeapVector *)translation;
{
    self = [super init];
    if (self) {
        Leap::Vector leapAxis(axis.x, axis.y, axis.z);
        Leap::Vector leapTranslation(translation.x, translation.y, translation.z);
        Leap::Matrix m(leapAxis, angleRadians, leapTranslation);
        xBasis = [[LeapVector alloc] initWithLeapVector:&m.xBasis];
        yBasis = [[LeapVector alloc] initWithLeapVector:&m.yBasis];
        zBasis = [[LeapVector alloc] initWithLeapVector:&m.zBasis];
        origin = [[LeapVector alloc] initWithLeapVector:&m.origin];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"xBasis:%@ yBasis:%@ zBasis:%@ origin:%@", xBasis, yBasis, zBasis, origin];
}

- (LeapVector *)transformPoint:(const LeapVector *)point
{
    LeapVector *a = [xBasis times:point.x];
    LeapVector *b = [yBasis times:point.y];
    LeapVector *c = [zBasis times:point.z];
    return [[[a plus:b] plus:c] plus:origin];
}

- (LeapVector *)transformDirection:(const LeapVector *)direction;
{
    LeapVector *a = [xBasis times:direction.x];
    LeapVector *b = [yBasis times:direction.y];
    LeapVector *c = [zBasis times:direction.z];
    return [[a plus:b] plus:c];
}

- (LeapMatrix *)orthoNormalized;
{
    const Leap::Vector localXBasis(xBasis.x, xBasis.y, xBasis.z);
    const Leap::Vector localYBasis(yBasis.x, yBasis.y, yBasis.z);
    const Leap::Vector localZBasis(zBasis.x, zBasis.y, zBasis.z);
    const Leap::Vector localOrigin(origin.x, origin.y, origin.z);
    Leap::Matrix m(localXBasis, localYBasis, localZBasis, localOrigin);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (LeapMatrix *)times:(const LeapMatrix *)other;
{
    LeapMatrix *unnormalized;
    unnormalized = [[LeapMatrix alloc] initWithXBasis:[self transformDirection:other.xBasis] withYBasis:[self transformDirection:other.yBasis] withZBasis:[self transformDirection:other.zBasis] withOrigin:[self transformPoint:other.origin]];
    return [unnormalized orthoNormalized];
}

- (BOOL)equals:(const LeapMatrix *)other;
{
    return [xBasis equals:other.xBasis] && [yBasis equals:other.yBasis] && [zBasis equals:other.zBasis];
}

- (NSMutableArray *)toNSArray3x3
{
    float float_ar[9];
    const Leap::Vector localXBasis(xBasis.x, xBasis.y, xBasis.z);
    const Leap::Vector localYBasis(yBasis.x, yBasis.y, yBasis.z);
    const Leap::Vector localZBasis(zBasis.x, zBasis.y, zBasis.z);
    const Leap::Vector localOrigin(origin.x, origin.y, origin.z);
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
    const Leap::Vector localXBasis(xBasis.x, xBasis.y, xBasis.z);
    const Leap::Vector localYBasis(yBasis.x, yBasis.y, yBasis.z);
    const Leap::Vector localZBasis(zBasis.x, zBasis.y, zBasis.z);
    const Leap::Vector localOrigin(origin.x, origin.y, origin.z);
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
    Leap::Pointable *interfacePointable;
    const LeapFrame *frame;
    const LeapHand *hand;
}

- (id)initWithPointable:(void *)pointable withFrame:(const LeapFrame *)aFrame withHand:(const LeapHand *)aHand
{
    self = [super init];
    if (self) {
        interfacePointable = new Leap::Pointable(*(const Leap::Pointable *)pointable);
        frame = aFrame;
        hand = aHand;
    }
    return self;
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
    return interfacePointable;
}

- (int32_t)id
{
    return interfacePointable->id();
}

- (const LeapVector *)tipPosition
{
    return [[LeapVector alloc] initWithX:interfacePointable->tipPosition().x withY:interfacePointable->tipPosition().y withZ:interfacePointable->tipPosition().z];
}

- (const LeapVector *)tipVelocity
{
    return [[LeapVector alloc] initWithX:interfacePointable->tipVelocity().x withY:interfacePointable->tipVelocity().y withZ:interfacePointable->tipVelocity().z];
}

- (const LeapVector *)direction
{
    return [[LeapVector alloc] initWithX:interfacePointable->direction().x withY:interfacePointable->direction().y withZ:interfacePointable->direction().z];
}

- (float)width
{
    return interfacePointable->width();
}

- (float)length
{
    return interfacePointable->length();
}

- (BOOL)isFinger
{
    return interfacePointable->isFinger();
}

- (BOOL)isTool
{
    return interfacePointable->isTool();
}

- (BOOL)isValid
{
    return interfacePointable->isValid();
}

- (const LeapFrame *)frame
{
    return frame;
}

- (const LeapHand *)hand
{
    return hand;
}

- (void)dealloc
{
    delete interfacePointable;
}

+ (LeapPointable *)invalid
{
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&(Leap::Pointable::invalid()) withFrame:nil withHand:nil];
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
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&(Leap::Finger::invalid()) withFrame:nil withHand:nil];
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
    LeapPointable *pointable = [[LeapFinger alloc] initWithPointable:(void *)&(Leap::Tool::invalid()) withFrame:nil withHand:nil];
    return pointable;
}

@end

//////////////////////////////////////////////////////////////////////////
//HAND
@implementation LeapHand
{
    Leap::Hand *interfaceHand;
    const LeapFrame *frame;
}

- (id)initWithHand:(void *)hand withFrame:(const LeapFrame *)aFrame
{
    self = [super init];
    if (self) {
        interfaceHand = new Leap::Hand(*(const Leap::Hand *)hand);
        frame = aFrame;
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

- (void *)interfaceHand
{
    return (void *)interfaceHand;
}

- (int32_t)id
{
    return interfaceHand->id();
}

- (NSArray *)pointables
{
    NSMutableArray *pointables_ar = [NSMutableArray array];
    for (int i = 0; i < interfaceHand->pointables().count(); i++) {
        const Leap::Pointable &tmpLeapPointable = interfaceHand->pointables()[i];
        LeapPointable *pointable = [[LeapPointable alloc] initWithPointable:(void *)&tmpLeapPointable withFrame:frame withHand:self];
        [pointables_ar addObject:pointable];
    }
    return [NSArray arrayWithArray:pointables_ar];
}

- (NSArray *)fingers
{
    NSMutableArray *fingers_ar = [NSMutableArray array];
    for (int i = 0; i < interfaceHand->fingers().count(); i++) {
        const Leap::Finger &tmpLeapFinger = interfaceHand->fingers()[i];
        LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger withFrame:frame withHand:self];
        [fingers_ar addObject:finger];
    }
    return [NSArray arrayWithArray:fingers_ar];
}

- (NSArray *)tools
{
    NSMutableArray *tools_ar = [NSMutableArray array];
    for (int i = 0; i < interfaceHand->tools().count(); i++) {
        const Leap::Tool &tmpLeapTool = interfaceHand->tools()[i];
        LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool withFrame:frame withHand:self];
        [tools_ar addObject:tool];
    }
    return [NSArray arrayWithArray:tools_ar];
}

- (const LeapPointable *)pointable:(int32_t)pointable_id
{
    const Leap::Pointable &tmpLeapPointable = interfaceHand->pointable(pointable_id);
    return [[LeapPointable alloc] initWithPointable:(void *)&tmpLeapPointable withFrame:frame withHand:self];
}

- (const LeapFinger *)finger:(int32_t)finger_id
{
    const Leap::Finger &tmpLeapFinger = interfaceHand->finger(finger_id);
    return [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger withFrame:frame withHand:self];
}

- (const LeapTool *)tool:(int32_t)tool_id
{
    const Leap::Tool &tmpLeapTool = interfaceHand->tool(tool_id);
    return [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool withFrame:frame withHand:self];
}

- (const LeapVector *)palmPosition
{
    return [[LeapVector alloc] initWithX:interfaceHand->palmPosition().x withY:interfaceHand->palmPosition().y withZ:interfaceHand->palmPosition().z];
}

- (const LeapVector *)palmVelocity
{
    return [[LeapVector alloc] initWithX:interfaceHand->palmVelocity().x withY:interfaceHand->palmVelocity().y withZ:interfaceHand->palmVelocity().z];
}

- (const LeapVector *)palmNormal
{
    return [[LeapVector alloc] initWithX:interfaceHand->palmNormal().x withY:interfaceHand->palmNormal().y withZ:interfaceHand->palmNormal().z];
}

- (const LeapVector *)direction
{
    return [[LeapVector alloc] initWithX:interfaceHand->direction().x withY:interfaceHand->direction().y withZ:interfaceHand->direction().z];
}

- (const LeapVector *)sphereCenter
{
    return [[LeapVector alloc] initWithX:interfaceHand->sphereCenter().x withY:interfaceHand->sphereCenter().y withZ:interfaceHand->sphereCenter().z];
}

- (float)sphereRadius
{
    return interfaceHand->sphereRadius();
}

- (BOOL)isValid
{
    return interfaceHand->isValid();
}

- (const LeapFrame *)frame
{
    return frame;
}

- (void)dealloc
{
    delete interfaceHand;
}

- (LeapVector *)translation:(const LeapFrame *)since_frame
{
    Leap::Vector v = interfaceHand->translation(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame
{
    Leap::Vector v = interfaceHand->rotationAxis(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (float)rotationAngle:(const LeapFrame *)since_frame
{
    return interfaceHand->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)since_frame withAxis:(const LeapVector *)axis
{
    Leap::Vector v = { axis.x, axis.y, axis.z };
    return interfaceHand->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame
{
    Leap::Matrix m = interfaceHand->rotationMatrix(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (float)scaleFactor:(const LeapFrame *)since_frame
{
    return interfaceHand->scaleFactor(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

+ (LeapHand *)invalid
{
    LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(Leap::Hand::invalid()) withFrame:nil];
    return hand;
}

@end;

//////////////////////////////////////////////////////////////////////////
//SCREEN
@implementation LeapScreen
{
    Leap::Screen *interfaceScreen;
}

- (id)initWithScreen:(void *)screen
{
    self = [super init];
    if (self) {
        interfaceScreen = new Leap::Screen(*(const Leap::Screen *)screen);
    }
    return self;
}

- (NSString *)description
{
    std::string str = interfaceScreen->toString();
    return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void *)interfaceScreen
{
    return (void *)interfaceScreen;
}

- (int32_t)id
{
    return interfaceScreen->id();
}

- (LeapVector *)intersect:(LeapPointable *)pointable withNormalize:(BOOL)normalize withClampRatio:(float)clampRatio
{
    const Leap::Pointable *leapPointable = (const Leap::Pointable *)[pointable interfacePointable];
    Leap::Vector v = interfaceScreen->intersect(*leapPointable, normalize, clampRatio);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)horizontalAxis
{
    Leap::Vector v = interfaceScreen->horizontalAxis();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)verticalAxis
{
    Leap::Vector v = interfaceScreen->verticalAxis();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)bottomLeftCorner
{
    Leap::Vector v = interfaceScreen->bottomLeftCorner();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)normal
{
    Leap::Vector v = interfaceScreen->normal();
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (int)widthPixels
{
    return interfaceScreen->widthPixels();
}

- (int)heightPixels
{
    return interfaceScreen->heightPixels();
}

- (float)distanceToPoint:(const LeapVector *)point
{
    Leap::Vector p = { point.x, point.y, point.z };
    return interfaceScreen->distanceToPoint(p);
}

- (BOOL)isValid
{
    return interfaceScreen->isValid();
}

- (BOOL)equals:(const LeapScreen *)other
{
    return *interfaceScreen == *(const Leap::Screen *)[other interfaceScreen];
}

- (void)dealloc
{
    delete interfaceScreen;
}

+ (const LeapScreen *)invalid
{
    return [[LeapScreen alloc] initWithScreen:(void *)&Leap::Screen::invalid()];
}

@end;

//////////////////////////////////////////////////////////////////////////
//FRAME
@implementation LeapFrame
{
    Leap::Frame *interfaceFrame;
}

@synthesize hands;
@synthesize pointables;
@synthesize fingers;
@synthesize tools;

- (id)initWithFrame:(const void *)frame
{
    self = [super init];
    if (self) {
        interfaceFrame = new Leap::Frame(*(const Leap::Frame *)frame);
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        Leap::Frame leapFrame = *(Leap::Frame *)frame;

        NSMutableArray *hands_ar = [NSMutableArray array];
        for (int i = 0; i < leapFrame.hands().count(); i++) {
            const Leap::Hand &tmpLeapHand = leapFrame.hands()[i];
            LeapHand *hand = [[LeapHand alloc] initWithHand:(void *)&(tmpLeapHand) withFrame:self];
            [hands_ar addObject:hand];
            [dictionary setObject:hand forKey:[NSNumber numberWithUnsignedInteger:tmpLeapHand.id()]];
        }
        hands = [NSArray arrayWithArray:hands_ar];

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
            LeapPointable *pointable = [[LeapPointable alloc] initWithPointable:(void *)&tmpLeapPointable withFrame:self withHand:hand];
            [pointables_ar addObject:pointable];
        }
        pointables = [NSArray arrayWithArray:pointables_ar];

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
            LeapFinger *finger = [[LeapFinger alloc] initWithPointable:(void *)&tmpLeapFinger withFrame:self withHand:hand];
            [fingers_ar addObject:finger];
        }
        fingers = [NSArray arrayWithArray:fingers_ar];

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
            LeapTool *tool = [[LeapTool alloc] initWithPointable:(void *)&tmpLeapTool withFrame:self withHand:hand];
            [tools_ar addObject:tool];
        }
        tools = [NSArray arrayWithArray:tools_ar];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Frame Id:%lld", self.id];
}

- (void *)interfaceFrame
{
    return (void *)interfaceFrame;
}

- (int64_t)id
{
    return interfaceFrame->id();
}
- (int64_t)timestamp
{
    return interfaceFrame->timestamp();
}

- (NSArray *)hands
{
    return hands;
}

- (NSArray *)pointables
{
    return pointables;
}

- (NSArray *)fingers
{
    return fingers;
}

- (NSArray *)tools
{
    return tools;
}

- (const LeapHand *)hand:(int32_t)hand_id
{
    NSEnumerator *e = [hands objectEnumerator];
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
    NSEnumerator *e = [pointables objectEnumerator];
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
    NSEnumerator *e = [fingers objectEnumerator];
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
    NSEnumerator *e = [tools objectEnumerator];
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
    delete interfaceFrame;
}

- (LeapVector *)translation:(const LeapFrame *)since_frame
{
    Leap::Vector v = interfaceFrame->translation(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (LeapVector *)rotationAxis:(const LeapFrame *)since_frame
{
    Leap::Vector v = interfaceFrame->rotationAxis(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapVector alloc] initWithLeapVector:&v];
}

- (float)rotationAngle:(const LeapFrame *)since_frame
{
    return interfaceFrame->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

- (float)rotationAngle:(const LeapFrame *)since_frame withAxis:(const LeapVector *)axis
{
    Leap::Vector v = { axis.x, axis.y, axis.z };
    return interfaceFrame->rotationAngle(*(const Leap::Frame *)[since_frame interfaceFrame], v);
}

- (LeapMatrix *)rotationMatrix:(const LeapFrame *)since_frame
{
    Leap::Matrix m = interfaceFrame->rotationMatrix(*(const Leap::Frame *)[since_frame interfaceFrame]);
    return [[LeapMatrix alloc] initWithLeapMatrix:&m];
}

- (float)scaleFactor:(const LeapFrame *)since_frame
{
    return interfaceFrame->scaleFactor(*(const Leap::Frame *)[since_frame interfaceFrame]);
}

+ (LeapFrame *)invalid
{
    NSAssert(0, @"'invalid' LeapFrame object not supported in ObjectiveC wrapper, probably doesn't have many use cases anyway");
    return nil;
}

@end;

//////////////////////////////////////////////////////////////////////////
//CONFIG
@implementation Config
{
    Leap::Config config;
}

- (id)initWithConfig:(void *)leapConfig
{
    self = [super init];
    if (self) {
        config = *(Leap::Config *)leapConfig;
    }
    return self;
}

- (LeapValueType)convertFromLeapValueType:(Leap::Config::ValueType)val
{
    switch (val) {
        case Leap::Config::ValueType::TYPE_UNKNOWN:
            return TYPE_UNKNOWN;
            break;
        case Leap::Config::ValueType::TYPE_BOOLEAN:
            return TYPE_BOOLEAN;
            break;
        case Leap::Config::ValueType::TYPE_INT32:
            return TYPE_INT32;
            break;
        case Leap::Config::ValueType::TYPE_UINT32:
            return TYPE_UINT32;
            break;
        case Leap::Config::ValueType::TYPE_INT64:
            return TYPE_INT64;
            break;
        case Leap::Config::ValueType::TYPE_UINT64:
            return TYPE_UINT64;
            break;
        case Leap::Config::ValueType::TYPE_FLOAT:
            return TYPE_FLOAT;
            break;
        case Leap::Config::ValueType::TYPE_DOUBLE:
            return TYPE_DOUBLE;
            break;
        case Leap::Config::ValueType::TYPE_STRING:
            return TYPE_STRING;
            break;
            
        default:
            return TYPE_UNKNOWN;
            break;
    }
}

- (LeapValueType)type:(NSString *)key;
{
    std::string *keyString = new std::string([key UTF8String]);
    Leap::Config::ValueType val = config.type(*keyString);
    free(keyString);
    return [self convertFromLeapValueType:val];
}

- (BOOL)getBool:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    BOOL val = config.getBool(*keyString);
    free(keyString);
    return val;
}

- (int32_t)getInt32:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    int32_t val = config.getInt32(*keyString);
    free(keyString);
    return val;
}

- (int64_t)getInt64:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    int64_t val = config.getInt64(*keyString);
    free(keyString);
    return val;
}

- (uint32_t)getUInt32:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    uint32_t val = config.getUInt32(*keyString);
    free(keyString);
    return val;
}

- (uint64_t)getUInt64:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    uint64_t val = config.getUInt64(*keyString);
    free(keyString);
    return val;
}
- (float)getFloat:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    float val = config.getFloat(*keyString);
    free(keyString);
    return val;
}

- (float)getDouble:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    float val = config.getDouble(*keyString);
    free(keyString);
    return val;
}

- (NSString *)getString:(NSString *)key
{
    std::string *keyString = new std::string([key UTF8String]);
    std::string str = config.getString(*keyString);
    NSString *val = [[NSString alloc] initWithUTF8String:str.c_str()];
    free(keyString);
    return val;
}

@end;

//////////////////////////////////////////////////////////////////////////
//SAMPLE LISTENER
class LeapListener : public Leap::Listener
{
public:
    virtual void onInit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
	    if ([delegate respondsToSelector:@selector(onInit:)]) {
                [delegate onInit:controller];
	    }
        }
    }

    virtual void onConnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
	    if ([delegate respondsToSelector:@selector(onConnect:)]) {
                [delegate onConnect:controller];
	    }
        }
    }

    virtual void onDisconnect(const Leap::Controller& leapController)
    {
        @autoreleasepool {
	    if ([delegate respondsToSelector:@selector(onDisconnect:)]) {
                [delegate onDisconnect:controller];
            }
        }
    }

    virtual void onExit(const Leap::Controller& leapController)
    {
        @autoreleasepool {
	    if ([delegate respondsToSelector:@selector(onExit:)]) {
                [delegate onExit:controller];
	    }
        }
    }

    virtual void onFrame(const Leap::Controller& leapController)
    {
        @autoreleasepool {
	    if ([delegate respondsToSelector:@selector(onFrame:)]) {
                [delegate onFrame:controller];
	    }
        }
    }

    void initWithDelegate(id<LeapDelegate> d)
    {
        delegate = d;
    }

    void setController(Leap::Controller *leapController)
    {
        controller = [[LeapController alloc] initWithController:(void *)leapController];
    }

    id<LeapDelegate> delegate;
private:
    LeapController *controller;
};

//////////////////////////////////////////////////////////////////////////
//CONTROLLER
@implementation LeapController
{
    Leap::Controller controller;
    NSPointerArray *listeners;
    BOOL isControllerOwner;
}

// initWithController is used only by the wrapper
- (id)initWithController:(void *)leapController
{
    self = [super init];
    if (self) {
        controller = *(Leap::Controller *)leapController;
        listeners = [[NSPointerArray alloc] initWithOptions:0];
    }
    return self;
}

// init and initWithDelegate may be called by the user
- (id)init
{
    NSAssert(!isControllerOwner, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        controller = *(new Leap::Controller());
        isControllerOwner = TRUE;
    }
    return self;
}

- (id)initWithDelegate:(id<LeapDelegate>)leapDelegate
{
    NSAssert(!isControllerOwner, @"Attempting to initialize a controller more than once");
    self = [super init];
    if (self) {
        LeapListener *listener = new LeapListener();
        listener->initWithDelegate(leapDelegate);
        listener->setController(&controller);
        controller = *(new Leap::Controller(*listener));
        [listeners addPointer:(void *)listener];
        isControllerOwner = TRUE;
    }
    return self;
}

- (BOOL)addDelegate:(id<LeapDelegate>)leapDelegate
{
    LeapListener *listener = new LeapListener();
    listener->initWithDelegate(leapDelegate);
    controller.addListener(*listener);
    listener->setController(&controller);
    [listeners addPointer:(void *)listener];
    return TRUE;
}

- (BOOL)removeDelegate:(id<LeapDelegate>)leapDelegate
{
    for (NSUInteger i = 0; i < [listeners count]; i++) {
        LeapListener *listener = (LeapListener *)[listeners pointerAtIndex:i];
        if (listener->delegate == leapDelegate) {
            delete listener;
            [listeners removePointerAtIndex:i];
        }
        return TRUE;
    }
    NSAssert(false, @"Attemped to remove delegate (listener) but id not found");
    return FALSE;
}

- (void)setController:(void *)leapController
{
    controller = *(Leap::Controller *)leapController;
    isControllerOwner = TRUE;
}

- (LeapFrame *)frame:(int)history
{
    Leap::Frame leapFrame = controller.frame(history);
    LeapFrame *frame = [[LeapFrame alloc] initWithFrame:(void *)&leapFrame];
    return frame;
}

- (Config *)config;
{
    Leap::Config leapConfig = controller.config();
    Config *config = [[Config alloc] initWithConfig:(void *)&leapConfig];
    return config;
}

- (BOOL)isConnected
{
    return controller.isConnected();
}

- (NSArray *)calibratedScreens;
{
    Leap::ScreenList leapScreens = controller.calibratedScreens();
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
    if (isControllerOwner) {
        delete &controller;
    }
    for (NSUInteger i = 0; i < [listeners count]; i++) {
        LeapListener *leapListener = (LeapListener *)[listeners pointerAtIndex:i];
        delete leapListener;
        [listeners replacePointerAtIndex:i withPointer:nil];
    }
}

@end;

const float LEAP_PI = Leap::PI;
const float LEAP_DEG_TO_RAD = Leap::DEG_TO_RAD;
const float LEAP_RAD_TO_DEG = Leap::RAD_TO_DEG; 
