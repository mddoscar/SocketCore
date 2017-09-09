//
//  CmdGcodeResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdGcodeResp.h"

@implementation CmdGcodeResp
-(instancetype)initWithDataIndex:(NSString *) index
{
    if (self=[super init]) {
        self.type=kCmdType_GCode_resp;
        self.index=index;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataIndex:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdGcodeResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.index=pDataArray[1];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.index=pDataArray[1];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.index, nil];
}
@end
