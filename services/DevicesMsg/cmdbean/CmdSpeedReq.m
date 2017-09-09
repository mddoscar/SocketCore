//
//  CmdSpeedReq.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdSpeedReq.h"

@implementation CmdSpeedReq
-(instancetype)initWithDataStype:(NSString *) stype mNumber:(NSString *) number mValue:(NSString *) value  mDir:(NSString *) dir
{
    if (self=[super init]) {
        self.type=kCmdType_speedset_req;
        self.stype=stype;
        self.number=number;
        self.value=value;
        self.dir=dir;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataStype:kDefInitValue mNumber:kDefInitValue mValue:kDefInitValue mDir:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdSpeedReq * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.stype=pDataArray[1];
        obj.number=pDataArray[2];
        obj.value=pDataArray[3];
        obj.dir=pDataArray[4];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.stype=pDataArray[1];
        self.number=pDataArray[2];
        self.value=pDataArray[3];
        self.dir=pDataArray[4];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.stype,self.number,self.value,self.dir, nil];
}
@end
