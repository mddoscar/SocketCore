//
//  CmdMechanicalOriginResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdMechanicalOriginResp.h"

@implementation CmdMechanicalOriginResp

-(instancetype)initWithDataX:(NSString *) X mY:(NSString *)Y mZ:(NSString *) Z mC:(NSString *) C mW:(NSString *)W
{
    if (self=[super init]) {
        self.type=kCmdType_Mechanical_origin_resp;
        self.X=X;
        self.Y=Y;
        self.Z=Z;
        self.C=C;
        self.W=W;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataX:kDefInitValue mY:kDefInitValue mZ:kDefInitValue mC:kDefInitValue mW:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdMechanicalOriginResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.X=pDataArray[1];
        obj.Y=pDataArray[2];
        obj.Z=pDataArray[3];
        obj.C=pDataArray[4];
        obj.W=pDataArray[5];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.X=pDataArray[1];
        self.Y=pDataArray[2];
        self.Z=pDataArray[3];
        self.C=pDataArray[4];
        self.W=pDataArray[5];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.X,self.Y,self.Z,self.C,self.W, nil];
}
@end
