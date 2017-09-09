//
//  GCDSocketManager.m
//  Printer3D
//
//  Created by mac on 2017/1/14.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "GCDSocketManager.h"

#define SocketHost @"地址"
#define SocketPort 端口
//
#import "ServerForDevices.h"

@interface GCDSocketManager()<GCDAsyncSocketDelegate>
{
    //当前IP
    NSString * curIp;
    //当前端口
    int curPort;
}

//握手次数
@property(nonatomic,assign) NSInteger pushCount;

//断开重连定时器
@property(nonatomic,strong) NSTimer *timer;

//重连次数
@property(nonatomic,assign) NSInteger reconnectCount;

@property(nonatomic,strong)NSMutableData *muData;

@end

@implementation GCDSocketManager

//全局访问点
+ (instancetype)sharedSocketManager {
    static GCDSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//可以在这里做一些初始化操作
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark 请求连接
//连接
- (void)connectToServer {
    curIp= [ConfigService valueForName:@"SysActivityIp"];//  APP_API;
    curPort= [[ConfigService valueForName:@"SysActivityPort"] intValue];//APP_PORT;
    
    self.pushCount = 0;
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.socket connectToHost:curIp onPort:curPort error:&error];
    
    if (error) {
        NSLog(@"SocketConnectError:%@",error);
    }
}

#pragma mark 连接成功
//连接成功的回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"socket连接成功");
    [self sendDataToServer];
}

//连接成功后向服务器发送数据
- (void)sendDataToServer {
    //发送数据代码省略...
    
    
    //发送
    [self.socket writeData:[[ServerForDevices getCommonStrArrTypeCode:kCmdType_Beat_req cmdStrArr:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",0],nil]] dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:1];
    //读取数据
    [self.socket readDataWithTimeout:-1 tag:200];
}

//连接成功向服务器发送数据后,服务器会有响应
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
   // [self.socket readDataWithTimeout:-1 tag:200];
    
    
    if(self.muData==nil) {
        self.muData=[NSMutableData data];
    }
    [self.muData appendData:data];
    long long location=[ServerForDevices indexofLineWithData:self.muData];
    if (location>0)//range.location!=NSNotFound)
    {
        NSMutableData *data1 = [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(0, location)]];
        NSMutableArray * readData=[ServerForDevices decodeArrayWithData:data1];
        //分发数据
        [self doDisPatchGoalArray:readData];
        //置空
        self.muData= [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(location+1, self.muData.length-location-1)]];
    }else{
        
    }
    [sock readDataWithTimeout:kSocketTimeOut tag:0];
    
    //服务器推送次数
    self.pushCount++;
    
    //在这里进行校验操作,情况分为成功和失败两种,成功的操作一般都是拉取数据
}

#pragma mark 连接失败
//连接失败的回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Socket连接失败");
    
    self.pushCount = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentStatu = [userDefaults valueForKey:@"Statu"];
    
    //程序在前台才进行重连
    if ([currentStatu isEqualToString:@"foreground"]) {
        
        //重连次数
        self.reconnectCount++;
        
        //如果连接失败 累加1秒重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 * self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        
        self.timer = timer;
    }
}

//如果连接失败,5秒后重新连接
- (void)reconnectServer {
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    //连接失败重新连接
    NSError *error = nil;
    [self.socket connectToHost:curIp onPort:curPort error:&error];
    if (error) {
        NSLog(@"SocektConnectError:%@",error);
    }
}

#pragma mark 断开连接
//切断连接
- (void)cutOffSocket {
    NSLog(@"socket断开连接");
    
    self.pushCount = 0;
    
    self.reconnectCount = 0;
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.socket disconnect];
}

-(void) doDisPatchGoalArray:(NSMutableArray *) pDataArray
{
    //NSLog(@"%@",pDataArray);
    
    if (pDataArray.count>0) {
        NSString * tCmd=pDataArray[0];
        //温度命令
        if ([kCmdType_Beat_req isEqualToString:tCmd]) {
            long  index= [pDataArray[1] intValue];

            [self doReBeatWithIndex:index];
            
        }else if ([kCmdType_Beat_resp isEqualToString:tCmd]){
            
        }else {
            NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
        }
        //        NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
    }
}

-(void) doReBeatWithIndex:(long) pIndex
{
    [self.socket writeData:[[ServerForDevices getCommonStrArrTypeCode:kCmdType_Beat_resp cmdStrArr:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%ld",pIndex],nil]] dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:1];
}
@end
