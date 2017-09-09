//
//  CmdSenderSocketBean.h
//  Printer3D
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDefSenderCmd @"100"
/*
 发送命令结构体
 */
@interface CmdSenderSocketBean : NSObject
//命令类型
@property(nonatomic,copy) NSString * type;
//命令数据
@property(nonatomic,strong) NSData * data;

-(instancetype) initWithDataType:(NSString *) pType mData:(NSData *) pData;
+(instancetype) initWithDataType:(NSString *) pType mData:(NSData *) pData;


@end
