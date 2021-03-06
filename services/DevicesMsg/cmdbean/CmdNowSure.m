//
//  CmdNowSure.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdNowSure.h"

@implementation CmdNowSure
-(instancetype)initWithData
{
    if (self=[super init]) {
        self.type=kCmdType_now_resp;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithData];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdNowSure * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type, nil];
}
@end
