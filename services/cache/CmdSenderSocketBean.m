//
//  CmdSenderSocketBean.m
//  Printer3D
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdSenderSocketBean.h"

@implementation CmdSenderSocketBean
-(instancetype) initWithDataType:(NSString *) pType mData:(NSData *) pData
{
    if (self=[super init]) {
        self.type=pType;
        self.data=pData;
    }
    return self;
}
+(instancetype) initWithDataType:(NSString *) pType mData:(NSData *) pData
{
    return [[CmdSenderSocketBean alloc] initWithDataType:pType mData:pData];
}
@end
