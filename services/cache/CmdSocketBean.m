//
//  CmdSocketBean.m
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdSocketBean.h"

@implementation CmdSocketBean

-(instancetype) initWithDataType:(NSString *) pType mData:(NSArray *) pDataArray
{
    if (self=[super init]) {
        self.type=pType;
        self.data=pDataArray;
    }
    return self;
}
+(instancetype) initWithDataType:(NSString *) pType mData:(NSArray *) pDataArray
{
    return [[CmdSocketBean alloc] initWithDataType:pType mData:pDataArray];
}
@end
