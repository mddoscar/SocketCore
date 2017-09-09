//
//  CmdMechanicalOriginResp.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdMechanicalOriginResp : CmdBase
@property(nonatomic,copy) NSString * X;
@property(nonatomic,copy) NSString * Y;
@property(nonatomic,copy) NSString * Z;
@property(nonatomic,copy) NSString * C;
@property(nonatomic,copy) NSString * W;
#pragma mark ctor
-(instancetype)initWithDataX:(NSString *) X mY:(NSString *)Y mZ:(NSString *) Z mC:(NSString *) C mW:(NSString *)W;
+(instancetype) GetDefValue;
@end
