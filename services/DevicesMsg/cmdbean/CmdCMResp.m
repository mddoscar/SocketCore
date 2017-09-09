//
//  CmdCMResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdCMResp.h"

@implementation CmdCMResp


-(instancetype)initWithData:(NSString *) cmd
{
    if (self=[super init]) {
        self.type=kCmdType_Cmd_resp;
        self.cmd=cmd;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithData:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdCMResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.cmd=pDataArray[1];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.cmd=pDataArray[1];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.cmd, nil];
}
@end
