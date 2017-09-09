//
//  ServerGoableSocket.h
//  Printer3D
//
//  Created by mac on 2017/1/12.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerForSocketCache;
//引用服务
#import "ServerForDevices.h"
//全局广播字符串
//#define kServerGoableSocketNotifStr @"ServerGoableSocketNotifStr"
//广播数组
#define kNoticfArrKey @"NoticfArrKey"
#define kNoticfCmd @"NoticfCmd"
//全局ui
#define kNoticfGoalParamKey @"NoticfGoalParamKey"
#define kNoticfUiParamCmd @"NoticfUiParamCmd"
//全局data
#define kNotifDataKey @"NotifDataKey"
//文件广播
#define kNoticfFileArrKey @"NoticfFileArrKey"
#define kNoticfFileCmd @"NoticfFileCmd"
//连接广播
#define kNoticeSocketStateKey @"NoticeSocketStateKey"
#define kNoticeSocketStateCmd @"NoticeSocketStateCmd"

//文件连接广播
#define kNoticeFileSocketStateKey @"NoticeFileSocketStateKey"
#define kNoticeFileSocketStateCmd @"NoticeFileSocketStateCmd"
//连接状态
#define kNoticeSocketStateOn @"1" //连上
#define kNoticeSocketStateOff @"0" //断开

enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};
/*
 socket服务单例
 */
@interface ServerGoableSocket : NSObject<AsyncSocketDelegate>
#pragma mark data
//是否在传递文件
@property(nonatomic,assign)BOOL IsFileState;
//ip端口相关
@property(nonatomic,assign)int mSocketCase;
//当前Ip
@property(nonatomic,copy)NSString * mCurIp;
//当前端口
@property(nonatomic,assign) int mCurPort;
//判断是否还连接着
@property(nonatomic,copy)__block NSString * isConnected;
//beat数据
@property(nonatomic,assign)__block long BeatIndex;
//超时时间
@property(nonatomic,assign) __block int timeOut;
//设备心跳
@property(nonatomic,assign)__block int deviceIndex;
//重连的计数器
@property(nonatomic,assign)__block int reConnectTime;
@property(nonatomic,assign) BOOL HasFlat;

#pragma mark func
//开始
-(void) setUp;
//开始连接
-(void) startConnet;
-(void) doRemoveAll;
//是否还活着
-(BOOL) socketIsConnected;
//断开
-(void) doCutSocket;
//加载配置
-(void) doLoadIpConfig;
//-(void) doDisPatchArray:(NSMutableArray *) pDataArray;
//-(void) post;
//-(void) postWithIp:(NSString *)pIp;
//-(void) postWithDataIp :(NSString *)pIp mPort:(UInt16) pPort;
//-(void) postLongWithDataIp:(NSString *)pIp mPort:(UInt16) pPort;
-(Reachability *) networkState;
-(BOOL) networkVaild;
//写数据
#pragma mark writeData
//写数据
-(void) doWriteData:(NSData*) pData;
-(void) doWriteDataStr:(NSString *)pDataStr;
-(void) doWriteDataCmd_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr;
-(void) doWriteDataCmdStrNewType_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr;
-(void) doWriteDataCmd_req:(NSString*) pCmdType cmdStrArr:(NSMutableArray *) pCmdStrArr;
//写缓存
-(void) doWriteCacheData:(NSData*) pData;
-(void) doWriteCacheDataStr:(NSString *)pDataStr;
-(void) doWriteCacheDataCmd_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr;
-(void) doWriteCacheDataCmdStrNewType_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr;
-(void) doWriteCacheDataCmd_req:(NSString*) pCmdType cmdStrArr:(NSMutableArray *) pCmdStrArr;
//发送心跳
-(void) doBeat;
//确认心跳
-(void) doCheckBeat;
//获取缓冲区
-(ServerForSocketCache *) getServerForSocketCache;
//获取服务单例
+(instancetype) GetInstance;


@end
