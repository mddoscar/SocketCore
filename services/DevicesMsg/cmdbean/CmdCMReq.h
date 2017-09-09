//
//  CmdCMReq.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"


@interface CmdCMReq : CmdBase

@property(nonatomic,copy) NSString * cmd;

#pragma mark ctor
-(instancetype)initWithData:(NSString *) cmd;
+(instancetype) GetDefValue;
@end
