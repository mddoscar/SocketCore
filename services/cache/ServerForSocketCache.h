//
//  ServerForSocketCache.h
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CmdSocketBean;
@class CopyOnWriteArrayList;
@class CopySenderOnWriteArrayList;
@class CmdSenderSocketBean;
/*
 socket二级缓存
 */
@interface ServerForSocketCache : NSObject

#pragma mark func
//获取
-(CmdSocketBean*) getCmdSocketBeanWithType:(NSString *) pType;
//添加
-(BOOL) AddCmdSocketBeanWithType:(NSString *) pType mDataArray:(NSArray *) pDataArray;
//清空
-(BOOL) ClearCmdSocketBeanWithType:(NSString *) pType;
//清空所有
-(BOOL) ClearCmdSocketBeanAll;
#pragma mark 发送缓存
//获取
-(CmdSenderSocketBean*) getCmdSendSocketBeanWithIndex:(NSInteger *) pIndex;
//添加
-(BOOL) AddCmdSenderSocketBeanWithType:(NSString *) pType mData:(NSData *) pData;
//发送
-(BOOL) ClearSenderCmdSocketBeanAll;
//获取剩余缓存
-(NSInteger) GetResetCount;
#pragma mark data
@property(nonatomic,strong) CopyOnWriteArrayList * FaultList;//故障包
@property(nonatomic,strong) CopyOnWriteArrayList * TemperatureList;//温度包
@property(nonatomic,strong) CopyOnWriteArrayList * SpeedList;//速度包
@property(nonatomic,strong) CopyOnWriteArrayList * LineNumberList;//行号包
@property(nonatomic,strong) CopyOnWriteArrayList * CoordinateList;//位置包
@property(nonatomic,strong) CopyOnWriteArrayList * HeartBeatList;//心跳包
//发送数据的缓存
@property(nonatomic,strong) CopySenderOnWriteArrayList * SenderList;//心跳包
//获取服务单例
+(instancetype) GetCacheInstance;


@end
