//
//  CmdBeatReq.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdBeatReq.h"

@implementation CmdBeatReq

-(instancetype)initWithData:(NSString *)beat
{
    if (self=[super init]) {
        self.type=kCmdType_Beat_req;
        self.beat=beat;
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
    CmdBeatReq * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.beat=pDataArray[1];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.type=pDataArray[0];
        self.beat=pDataArray[1];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.beat, nil];
}
@end
