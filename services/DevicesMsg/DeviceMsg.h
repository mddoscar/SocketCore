//
//  DeviceMsg.h
//  Printer3D
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
设备命令
 */
@interface DeviceMsg : NSObject
@property(nonatomic,assign) int type;
//原始数据
@property(nonatomic,strong) NSMutableData * rawData;

#pragma mark func
-(NSString *)getMsgSplit;
+(NSString *)getMsgSplit;


#pragma mark ctor
//获取数据
//-(instancetype) initWithData:(NSData *) pData;

@end
