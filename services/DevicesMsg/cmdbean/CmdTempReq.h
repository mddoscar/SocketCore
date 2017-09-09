//
//  CmdTempReq.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdTempReq : CmdBase
@property(nonatomic,copy) NSString * stype;
@property(nonatomic,copy) NSString * number;
@property(nonatomic,copy) NSString * offset;
@property(nonatomic,copy) NSString * value;
#pragma mark ctor
-(instancetype)initWithDataStype:(NSString *) stype mNumber:(NSString *) number mOffset:(NSString *) offset mValue:(NSString *) value;
//值颠倒
+(instancetype) GetDefValue;
@end
