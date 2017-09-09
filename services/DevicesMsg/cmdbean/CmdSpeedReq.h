//
//  CmdSpeedReq.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdSpeedReq :  CmdBase
@property(nonatomic,copy) NSString * stype;
@property(nonatomic,copy) NSString * number;
@property(nonatomic,copy) NSString * value;
@property(nonatomic,copy) NSString * dir;
#pragma mark ctor
-(instancetype)initWithDataStype:(NSString *) stype mNumber:(NSString *) number mValue:(NSString *) value  mDir:(NSString *) dir;
+(instancetype) GetDefValue;
@end
