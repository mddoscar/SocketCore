//
//  AxisBean.m
//  Printer3D
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "AxisBean.h"

#import "ZeroPoint.h"
#define kDefRate 1.0

@implementation AxisBean



-(id) initWithDataRawX:(int) pRawX rawY:(int) pRawY rawZ:(int) pRawZ rawC:(int) pRawC rawW:(int) pRawW rate:(double) pRate ZeroPos:(ZeroPoint *)pZeroPoint
{
    if (self=[super init]) {
        self.rawX=pRawX;
        self.rawY=pRawY;
        self.rawZ=pRawZ;
        self.rawC=pRawC;
        self.rawW=pRawW;
        self.rate=pRate;
        self.mZeroPos=pZeroPoint;
    }
    return self;
}
-(id) initWithDataDefRawX:(int) pRawX rawY:(int) pRawY rawZ:(int) pRawZ rawC:(int) pRawC rawW:(int) pRawW
{
    if (self=[super init]) {
        self.rawX=pRawX;
        self.rawY=pRawY;
        self.rawZ=pRawZ;
        self.rawC=pRawC;
        self.rawW=pRawW;
        self.rate=kDefRate;
        self.mZeroPos=[ZeroPoint GetDefValue];
    }
    return self;
}
-(id) initWithDataDef
{
    if (self=[super init]) {
        self.rawX=0;
        self.rawY=0;
        self.rawZ=0;
        self.rawC=0;
        self.rawW=0;
        self.rate=kDefRate;
        self.mZeroPos=[ZeroPoint GetDefValue];
    }
    return self;
}
-(id) initWithDataBean:(AxisBean *) pAxisBean
{
    if (self =[super init]) {
        self =[[[self class] alloc] initWithDataDefRawX:0 rawY:0 rawZ:0 rawC:0 rawW:0];
    }
    return self;
}

/*
 XY对调
 ______________
 [x']=    [0 1 0 0] [x]
 [y']     [1 0 0 0] [y]
 [z']     [0 0 1 0] [z]
 [1 ]     [0 0 0 1] [1]
 */
-(AxisBean *) ConvertX2Y
{
    AxisBean * newBean= [[AxisBean alloc] initWithDataBean:self];
    newBean.rawX=0*self.rawX+1*self.rawY+0*self.rawZ+0*1;
    newBean.rawY=1*self.rawX+0*self.rawY+0*self.rawZ+0*1;
    newBean.rawZ=0*self.rawX+0*self.rawY+1*self.rawZ+0*1;
    newBean.rawC=self.rawC;
    newBean.rawW=self.rawW;
    newBean.rate=self.rate;
    newBean.mZeroPos=self.mZeroPos;
    return newBean;
}
/*
 XY对调
 ______________
 [x']=    [0 1 0 ] [x]
 [y']     [1 0 0 ] [y]
 [1 ]     [0 0 1 ] [1]
 */
+(CGPoint) ConvertX2YWithPoint:(CGPoint) pPos
{
    CGPoint  newpos;
    newpos.x=0*pPos.x+1*pPos.y+0*1;
    newpos.y=1*pPos.x+0*pPos.y+0*1;
    return newpos;
}
@end
