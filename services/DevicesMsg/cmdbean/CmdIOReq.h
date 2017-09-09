//
//  CmdIOReq.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdIOReq :  CmdBase
@property(nonatomic,copy) NSString * index;
@property(nonatomic,copy) NSString * value;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,copy) NSString * dir;
@property(nonatomic,copy) NSString * state;
#pragma mark ctor
-(instancetype)initWithDataIndex:(NSString *) index mValue:(NSString *) value mCmd:(NSString *) cmd mDir:(NSString *) dir mState:(NSString *) state;
+(instancetype) GetDefValue;
@end
