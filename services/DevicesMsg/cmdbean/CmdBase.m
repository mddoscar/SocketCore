//
//  CmdBase.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdBase.h"


@implementation CmdBase
@synthesize mddDelegate=_mddDelegate;
-(instancetype)init
{
    if (self=[super init]) {
        
    }
    return self;
}

+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithData:kDefInitValue];
}
-(instancetype)convertFromArray:(NSArray * )pDataArray
{
    CmdBase * obj=[[[self class] alloc] initWithData:kDefInitValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
    }
    return obj;
}
-(instancetype)updateWithArray:(NSArray * )pDataArray
{
    CmdBase * obj=[[[self class] alloc] initWithData:kDefInitValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
    }
    return obj;
}
-(NSString *)description
{
    return [((NSDictionary *)self) JSONString];
}

@end
