//
//  CmdLinenumberResp.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"


@interface CmdLinenumberResp : CmdBase

@property(nonatomic,copy) NSString * number;
#pragma mark ctor
-(instancetype)initWithData:(NSString *) number;
+(instancetype) GetDefValue;
@end
