//
//  ServerForFileSocket.h
//  Printer3D
//
//  Created by mac on 2017/3/10.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 文件socket服务
 */
@interface ServerForFileSocket : NSObject<AsyncSocketDelegate>
//ip端口相关
@property(nonatomic,assign)int mSocketCase;
//当前Ip
@property(nonatomic,copy)NSString * mCurIp;
//当前端口
@property(nonatomic,assign) int mCurPort;
//判断是否还连接着
@property(nonatomic,copy)__block NSString * isConnected;
//超时时间
@property(nonatomic,assign) __block int timeOut;
//重连的计数器
@property(nonatomic,assign)__block int reConnectTime;
#pragma mark func
//开始
-(void) setUp;
//开始连接
-(void) startConnet;
//删除所有
-(void) doRemoveAll;
//是否还活着
-(BOOL) socketIsConnected;
//断开
-(void) doCutSocket;
//加载配置
-(void) doLoadIpConfig;
//网络状态
-(Reachability *) networkState;
//网络可用
-(BOOL) networkVaild;
//写数据
-(void) doWriteData:(NSData*) pData;

//获取服务单例
+(instancetype) GetInstance;


@end
