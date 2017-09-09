//
//  CmdGcodeReq.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdGcodeReq.h"

@implementation CmdGcodeReq

-(instancetype)initWithData:(NSString *) body Index:(NSString *) index
{
    if (self=[super init]) {
        self.type=kCmdType_GCode_req;
        self.body=body;
        self.index=index;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithData:kDefInitValue Index:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdGcodeReq * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.body=pDataArray[1];
        obj.index=pDataArray[2];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.body=pDataArray[1];
        self.index=pDataArray[2];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.body,self.index, nil];
}
@end
