//
//  ServerForSocketCache.m
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "ServerForSocketCache.h"

//类型跟数据
#import "CmdSocketBean.h"
#import "CommonMsgHeader.h"
#import "CopyOnWriteArrayList.h"
#import "CopySenderOnWriteArrayList.h"
//缓存
#import "CmdSenderSocketBean.h"
//缓存大小
#define kMaxQueueFault 20 //故障包
#define kMaxQueueTemperature 20 //温度
#define kMaxQueueSpeed 20   //速率
#define kMaxQueueLineNumber 5  //
#define kMaxQueueCoordinate 20 //位置
#define kMaxQueueHeartBeat 5 //心跳
//发送最多缓存100条
#define kMaxQueueSender 20 //发送缓存


@interface ServerForSocketCache()
{
   // CopyOnWriteArrayList * FaultList;//故障包
   // CopyOnWriteArrayList * TemperatureList;//温度包
   // CopyOnWriteArrayList * SpeedList;//速度包
   // CopyOnWriteArrayList * LineNumberList;//行号包
   // CopyOnWriteArrayList * CoordinateList;//位置包
   // CopyOnWriteArrayList * HeartBeatList;//心跳包
}
@end
@implementation ServerForSocketCache
@synthesize FaultList=FaultList;
@synthesize TemperatureList=TemperatureList;
@synthesize SpeedList=SpeedList;
@synthesize LineNumberList=LineNumberList;
@synthesize CoordinateList=CoordinateList;
@synthesize HeartBeatList=HeartBeatList;
//
@synthesize SenderList=SenderList;
-(void) setup
{
    FaultList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueFault];
    TemperatureList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueTemperature];
    SpeedList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueSpeed];
    LineNumberList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueLineNumber];
    CoordinateList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueCoordinate];
    HeartBeatList=[CopyOnWriteArrayList GetListInstanceMaxSize:kMaxQueueHeartBeat];
    //
    SenderList=[CopySenderOnWriteArrayList GetListInstanceMaxSize:kMaxQueueSender];
}
//获取
-(CmdSocketBean*) getCmdSocketBeanWithType:(NSString *) pType
{
    CmdSocketBean * rObj=nil;
    @try {
        int tType=[pType intValue];
        switch (tType) {
            case 0:
            {
                rObj= [HeartBeatList RemoveFirstObj];
            }
                break;
                
                //        case 1:
                //        {
                //            rObj= [HeartBeatList RemoveFirstObj];
                //        }
                //            break;
            case 12:
            {
                rObj=[CoordinateList RemoveFirstObj];
            }
                break;
            case 14:
            {
                rObj=[LineNumberList RemoveFirstObj];
            }
                break;
            case 15:
            {
                rObj= [SpeedList RemoveFirstObj];
            }
                break;
            case 17:
            {
                rObj= [TemperatureList RemoveFirstObj];
            }
                break;
            case 19:
            {
                
                rObj=[FaultList RemoveFirstObj];
            }
                break;
//            default:
//            {
//                rObj= [FaultList RemoveFirstObj];
//            }
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@,pType:%@",exception,pType);
    } @finally {
        
    }
   
    /*
    if ([kCmdType_Beat_resp isEqualToString:pType]) {
        rObj= [HeartBeatList RemoveFirstObj];
    }else  if ([kCmdType_axis_req_resp isEqualToString:pType]) {
         rObj= [CoordinateList RemoveFirstObj];
    }else  if ([kCmdType_linenumber_req_resp isEqualToString:pType]) {
        rObj= [LineNumberList RemoveFirstObj];
    }else  if ([kCmdType_speed_resp isEqualToString:pType]) {
        rObj= [SpeedList RemoveFirstObj];
    }else  if ([kCmdType_temp_req_resp isEqualToString:pType]) {
        rObj= [TemperatureList RemoveFirstObj];
    }else{
         rObj= [FaultList RemoveFirstObj];
    }*/
    return rObj;
}
//添加
-(BOOL) AddCmdSocketBeanWithType:(NSString *) pType mDataArray:(NSArray *) pDataArray
{
    BOOL rRes=false;
    int tType=[pType intValue];
    
    switch (tType) {
        case 0:
        {
           rRes= [HeartBeatList AddWithType:pType mDataArray:pDataArray];
        }
            break;

//        case 1:
//        {
//          rRes= [HeartBeatList AddWithType:pType mDataArray:pDataArray];
//        }
//            break;
        case 12:
        {
            rRes=[CoordinateList AddWithType:pType mDataArray:pDataArray];
        }
            break;
        case 14:
        {
            rRes= [LineNumberList AddWithType:pType mDataArray:pDataArray];
        }
            break;
        case 15:
        {
            rRes= [SpeedList AddWithType:pType mDataArray:pDataArray];
        }
            break;
        case 17:
        {
             rRes= [TemperatureList AddWithType:pType mDataArray:pDataArray];
        }
            break;
        case 19:
        {
            rRes= [FaultList AddWithType:pType mDataArray:pDataArray];
        }
            break;
//        default:
//        {
//             rRes= [FaultList AddWithType:pType mDataArray:pDataArray];
//        }
            break;
    }
    return rRes;
}
-(BOOL) ClearCmdSocketBeanWithType:(NSString *) pType
{
    BOOL rRes=false;
    int tType=[pType intValue];
    switch (tType) {
        case 0:
        {
            rRes= [HeartBeatList ClearObjs];
        }
            break;
        case 12:
        {
            rRes= [CoordinateList ClearObjs];
        }
            break;
        case 14:
        {
            rRes= [LineNumberList ClearObjs];
        }
            break;
        case 15:
        {
            rRes=[SpeedList ClearObjs];

        }
            break;
        case 17:
        {
            rRes= [TemperatureList ClearObjs];
        }
            break;
        case 19:
        {
            rRes= [FaultList ClearObjs];
        }
            break;
        default:
        {
            rRes= [FaultList ClearObjs];
        }
            break;
    }
/*
    if ([kCmdType_Beat_resp isEqualToString:pType]) {
        rRes= [HeartBeatList ClearObjs];
    }else  if ([kCmdType_axis_req_resp isEqualToString:pType]) {
        rRes= [CoordinateList ClearObjs];
    }else  if ([kCmdType_linenumber_req_resp isEqualToString:pType]) {
        rRes= [LineNumberList ClearObjs];
    }else  if ([kCmdType_speed_resp isEqualToString:pType]) {
        rRes= [SpeedList ClearObjs];
    }else  if ([kCmdType_temp_req_resp isEqualToString:pType]) {
        rRes= [TemperatureList ClearObjs];
    }else  if ([kCmdType_temp_req_resp isEqualToString:pType]) {
        rRes= [FaultList ClearObjs];
    }
*/
    return rRes;
}
-(BOOL) ClearCmdSocketBeanAll
{
    @try {
        [FaultList ClearObjs];
        [TemperatureList  ClearObjs];
        [SpeedList ClearObjs];
        [LineNumberList ClearObjs];
        [CoordinateList ClearObjs];
        [HeartBeatList ClearObjs];
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    return false;
}
//获取
-(CmdSenderSocketBean*) getCmdSendSocketBeanWithIndex:(NSInteger *) pIndex
{
    CmdSenderSocketBean * rObj=nil;
    @try {
       [SenderList RemoveFirstObj];
    } @catch (NSException *exception) {
        NSLog(@"%@,pType:%ld",exception,(long)pIndex);
    } @finally {
        
    }

    return rObj;
}
//添加
-(BOOL) AddCmdSenderSocketBeanWithType:(NSString *) pType mData:(NSData *) pData
{
    BOOL rRes=false;
    @try {
        rRes= [SenderList AddWithType:pType mData:pData];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }

    return rRes;
}

-(BOOL) ClearSenderCmdSocketBeanAll
{
    @try {
        [SenderList ClearObjs];
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    return false;
}
-(NSInteger) GetResetCount
{
    return [FaultList GetSize]+[TemperatureList GetSize]+[SpeedList GetSize]+[LineNumberList GetSize]+[CoordinateList GetSize]+[HeartBeatList GetSize];
}
//获取服务单例
+(instancetype) GetCacheInstance
{
    static ServerForSocketCache *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setup];
    });
    return sharedInstance;
}
@end
