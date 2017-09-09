//
//  CmdGcodeReq.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdGcodeReq : CmdBase

@property(nonatomic,copy) NSString * body;
@property(nonatomic,copy) NSString * index;
#pragma mark ctor
-(instancetype)initWithData:(NSString *) body Index:(NSString *) index;
+(instancetype) GetDefValue;
@end
