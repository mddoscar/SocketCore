//
//  CmdFileName.m
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CmdFileName.h"

@implementation CmdFileName

-(instancetype)initWithData:(NSString *) filename Size:(NSString *)size
{
    if (self=[super init]) {
        self.type=kCmdType_File_req;
        self.filename=filename;
        self.size=size;
    }
    return self;
}
+(instancetype) GetDefValue
{
    return [[[self class] alloc] initWithData:kDefInitValue Size:kDefInitValue];
}
//重写
-(instancetype) convertFromArray:(NSArray *)pDataArray
{
    CmdFileName * obj=[[self class] GetDefValue];
    if (pDataArray&&pDataArray.count>0) {
        obj.type=pDataArray[0];
        obj.filename=pDataArray[1];
        obj.size=pDataArray[2];
    }
    return obj;
}
-(instancetype) updateWithArray:(NSArray *)pDataArray
{
    if (pDataArray&&pDataArray.count>0) {
        self.filename=pDataArray[1];
        self.size=pDataArray[2];

    }
    return self;
}
-(NSMutableArray *) toCmdArray
{
    return [NSMutableArray arrayWithObjects:self.type,self.filename,self.size, nil];
}
@end
