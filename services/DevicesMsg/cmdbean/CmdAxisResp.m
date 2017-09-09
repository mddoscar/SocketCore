//
//  CmdAxisResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdAxisResp.h"

@implementation CmdAxisResp


-(instancetype)initWithDataX:(NSString *) X mY:(NSString *)Y mZ:(NSString *) Z mC:(NSString *) C mW:(NSString *)W mWorkX:(NSString *) WorkX mWorkY:(NSString *) WorkY mWorkZ:(NSString *) WorkZ mWorkC:(NSString *) WorkC mWorkW:(NSString *) WorkW
{
    if (self=[super init]) {
        self.type=kCmdType_axis_req_resp;
        self.X=X;
        self.Y=Y;
        self.Z=Z;
        self.C=C;
        self.W=W;
        self.WorkX=WorkX;
        self.WorkY=WorkY;
        self.WorkZ=WorkZ;
        self.WorkC=WorkC;
        self.WorkW=WorkW;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataX:kDefInitValue mY:kDefInitValue mZ:kDefInitValue mC:kDefInitValue mW:kDefInitValue mWorkX:kDefInitValue mWorkY:kDefInitValue mWorkZ:kDefInitValue mWorkC:kDefInitValue mWorkW:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdAxisResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.X=pDataArray[1];
        obj.Y=pDataArray[2];
        obj.Z=pDataArray[3];
        obj.C=pDataArray[4];
        obj.W=pDataArray[5];
        obj.WorkX=pDataArray[6];
        obj.WorkY=pDataArray[7];
        obj.WorkZ=pDataArray[8];
        obj.WorkC=pDataArray[9];
        obj.WorkW=pDataArray[10];
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
        self.WorkX=pDataArray[6];
        self.WorkY=pDataArray[7];
        self.WorkZ=pDataArray[8];
        self.WorkC=pDataArray[9];
        self.WorkW=pDataArray[10];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.X,self.Y,self.Z,self.C,self.W,self.WorkX,self.WorkY,self.WorkZ,self.WorkC,self.WorkW, nil];
}
@end
