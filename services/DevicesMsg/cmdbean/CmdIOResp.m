//
//  CmdIOResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdIOResp.h"

@implementation CmdIOResp
-(instancetype)initWithDataIndex:(NSString *) index mValue:(NSString *) value mCmd:(NSString *) cmd mDir:(NSString *) dir mState:(NSString *) state
{
    if (self=[super init]) {
        self.type=kCmdType_door_resp;
        self.index=index;
        self.value=value;
        self.cmd=cmd;
        self.dir=dir;
        self.state=state;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataIndex:kDefInitValue mValue:kDefInitValue mCmd:kDefInitValue mDir:kDefInitValue mState:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdIOResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.index=pDataArray[1];
        obj.value=pDataArray[2];
        obj.cmd=pDataArray[3];
        obj.dir=pDataArray[4];
        obj.state=pDataArray[5];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.index=pDataArray[1];
        self.value=pDataArray[2];
        self.cmd=pDataArray[3];
        self.dir=pDataArray[4];
        self.state=pDataArray[5];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.index,self.value,self.cmd,self.dir,self.state, nil];
}
@end
