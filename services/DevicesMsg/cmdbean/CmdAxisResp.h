//
//  CmdAxisResp.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"


@interface CmdAxisResp :  CmdBase

@property(nonatomic,copy) NSString * X;
@property(nonatomic,copy) NSString * Y;
@property(nonatomic,copy) NSString * Z;
@property(nonatomic,copy) NSString * C;
@property(nonatomic,copy) NSString * W;
@property(nonatomic,copy) NSString * WorkX;
@property(nonatomic,copy) NSString * WorkY;
@property(nonatomic,copy) NSString * WorkZ;
@property(nonatomic,copy) NSString * WorkC;
@property(nonatomic,copy) NSString * WorkW;

#pragma mark ctor
-(instancetype)initWithDataX:(NSString *) X mY:(NSString *)Y mZ:(NSString *) Z mC:(NSString *) C mW:(NSString *)W mWorkX:(NSString *) WorkX mWorkY:(NSString *) WorkY mWorkZ:(NSString *) WorkZ mWorkC:(NSString *) WorkC mWorkW:(NSString *) WorkW;
+(instancetype) GetDefValue;

@end
