//
//  CmdTempResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdTempResp.h"

@implementation CmdTempResp
-(instancetype)initWithDataStype:(NSString *) stype mNumber:(NSString *) number mOffset:(NSString *) offset mValue:(NSString *) value
{
    if (self=[super init]) {
        self.type=kCmdType_temp_req_resp;
        self.stype=stype;
        self.number=number;
        self.offset=offset;
        self.value=value;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataStype:kDefInitValue mNumber:kDefInitValue mOffset:kDefInitValue mValue:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdTempResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.stype=pDataArray[1];
        obj.number=pDataArray[2];
        obj.offset=pDataArray[3];
        obj.value=pDataArray[4];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.stype=pDataArray[1];
        self.number=pDataArray[2];
        self.offset=pDataArray[3];
        self.value=pDataArray[4];
//        NSLog(@"CmdTempResp  updateWithArray%@",pDataArray);
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.stype,self.number,self.offset,self.value, nil];
}
@end
