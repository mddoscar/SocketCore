//
//  CmdSessionResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdSessionResp.h"

@implementation CmdSessionResp

-(instancetype)initWithData:(NSString *) sid
{
    if (self=[super init]) {
        self.type=kCmdType_Session_resp;
        self.sid=sid;
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
    CmdSessionResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.sid=pDataArray[1];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.sid=pDataArray[1];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.sid, nil];
}
@end
