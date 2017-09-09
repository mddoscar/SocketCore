//
//  CmdErrorResp.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdErrorResp.h"

@implementation CmdErrorResp
-(instancetype)initWithDataSfindex:(NSString *) sfindex mSfvalue:(NSString *) sfvalue mOffset:(NSString *) offset mValue:(NSString *) value
{
    if (self=[super init]) {
        self.type=kCmdType_error_resp;
        self.sfindex=sfindex;
        self.sfvalue=sfvalue;
        self.offset=offset;
        self.value=value;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithDataSfindex:kDefInitValue mSfvalue:kDefInitValue mOffset:kDefInitValue mValue:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdErrorResp * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.sfindex=pDataArray[1];
        obj.sfvalue=pDataArray[2];
        obj.offset=pDataArray[3];
        obj.value=pDataArray[4];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.sfindex=pDataArray[1];
        self.sfvalue=pDataArray[2];
        self.offset=pDataArray[3];
        self.value=pDataArray[4];
    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.sfindex,self.sfvalue,self.offset,self.value, nil];
}
@end
