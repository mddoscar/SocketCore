//
//  CmdSessionResp.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdSessionResp :  CmdBase

@property(nonatomic,copy) NSString * sid;
#pragma mark ctor
-(instancetype)initWithData:(NSString *) sid;
+(instancetype) GetDefValue;
@end
