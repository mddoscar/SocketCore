//
//  CmdLinenumberResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdLinenumberResp.h"

@implementation CmdLinenumberResp
-(instancetype)initWithData:(NSString *) number
{
    if (self=[super init]) {
        self.type=kCmdType_linenumber_req_resp;
        self.number=number;
    }
    return self;
}
+(instancetype) GetDefValue
{
      return [[[self class] alloc] initWithData:kDefInitValue ];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdLinenumberResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.number=pDataArray[1];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.number=pDataArray[1];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.number, nil];
}
@end
