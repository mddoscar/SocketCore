//
//  ZeroPoint.m
//  Printer3D
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "ZeroPoint.h"

#define kDefRate 1.0

@implementation ZeroPoint

//构造
-(id) initWithDataX:(int) pX Y:(int)pY Z:(int) pZ rate:(double) pRate
{
    if(self =[super init]){
        self.x=pX;
        self.y=pY;
        self.z=pZ;
        self.rate=pRate;
    }
    return self;
}
//默认构造
-(id) initWithDataDefX:(int) pX Y:(int)pY Z:(int) pZ
{
    
    if(self =[super init]){
        self.x=pX;
        self.y=pY;
        self.z=pZ;
        self.rate=kDefRate;
    }
    return self;
}
+(instancetype) GetDefValue
{
    ZeroPoint * rObj=[[ZeroPoint alloc] initWithDataX:0 Y:0 Z:0 rate:kDefRate];
    return rObj;
}
@end
