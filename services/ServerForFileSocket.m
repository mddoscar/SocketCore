//
//  ServerForFileSocket.m
//  Printer3D
//
//  Created by mac on 2017/3/10.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "ServerForFileSocket.h"
#import "Ipv4v6Util.h"
//文件
#import "FileHelper.h"
#import "DbDateHelper.h"
#import "GoalWeakProxy.h"
#import "NSTimer+XXBlocksSupport.h"
#define kFileCmdTimeOut 3 //命令超时
#define kReconnectTimeDef 1  //技能cd
#ifdef DEBUG
//#define DFLog(fmt, ...) NSLog((@"FileLog " fmt), ##__VA_ARGS__);
#define DFLog(...) //停用日志
#else
#define DFLog(...)
#endif
#import "AppDelegate.h"

@interface ServerForFileSocket()
{
    //int socketCase;
    //当前IP
    //NSString * curIp;
    //当前端口
    //int curPort;
}
//线程安全
@property (nonatomic,strong) AsyncSocket * asyncSocket;
//数据池子
@property(nonatomic,strong)NSMutableData *muData;
//socket
@property(nonatomic,strong)NSTimer * mSocketTimer;
@property(nonatomic,strong)NSTimer * mUITimerWrite1;
@end
@implementation ServerForFileSocket
@synthesize asyncSocket=_asyncSocket;
@synthesize mCurIp=curIp;
@synthesize mCurPort=curPort;
@synthesize mSocketCase=socketCase;


-(void) setUp
{
    DFLog(@"%d,%s",__LINE__,__FUNCTION__);
    self.isConnected=kStrDef_N;
    self.muData=nil;
    [self doLoadIpConfig];
    //    self.muDataDeb=nil;
    [self startConnet];
    [self setUpTimer];
    
}
-(BOOL) socketIsConnected
{
    return [self.isConnected isEqualToString:kStrDef_Y];
}
-(void) doCutSocket
{
    if (_asyncSocket!=nil) {
      [_asyncSocket disconnect];
    }
    [self doRemoveAll];
    //self=nil;
}
//开始连接
-(void) startConnet
{
    DFLog(@"%d,%s",__LINE__,__FUNCTION__);
    _asyncSocket.delegate=self;
    //    self.muData=nil;
    
    @try {
        [self postLongWithDataIp:curIp mPort:curPort];
    } @catch (NSException *exception) {
        DFLog(@"%@",exception);
    } @finally {
        
    }
}
-(void) doLoadIpConfig
{
    
    curIp= [ConfigService valueForName:@"SysActivityIp"];//  APP_API;
    curPort= [[ConfigService valueForName:@"SysActivityFilePort"] intValue];//APP_PORT;
#pragma mark 重新获取IP
    NSString * redictIp=[Ipv4v6Util getProperIPWithAddress:curIp port:curPort];
    curIp=redictIp;
}
#pragma  mark socket逻辑
-(void) doStartSocketWithCase:(int) pCase;
{
    socketCase=pCase;
    curIp= [ConfigService valueForName:@"SysActivityIp"];//  APP_API;
    curPort= [[ConfigService valueForName:@"SysActivityFilePort"] intValue];//APP_PORT;
    //[self postLongWithDataIp:curIp mPort:curPort];
    
}
#pragma mark--建立连接发送数据
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    DFLog(@"%d:%s",__LINE__,__FUNCTION__);
    [sock readDataWithTimeout:kSocketTimeOut tag:0];
    NSDictionary *fParamData = [NSDictionary dictionaryWithObject:kNoticeSocketStateOn forKey:kNoticeFileSocketStateKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeFileSocketStateCmd object:fParamData];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayFileConncet]=_LS_(@"kMddUiAlertFileSocketOn", nil);
    //逻辑
    //    [self socketLogic];
    //已经连上
    self.isConnected=kStrDef_Y;
    self.timeOut=0;
}

#pragma mark--接收数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    if (nil==self.muData) {
        self.muData=[NSMutableData data];
    }
    [self.muData appendData:data];
    
//    if (self.muData.length>=kOnePackgeLength)//range.location!=NSNotFound)
//    {
//        NSLog(@"接到数据-----------------");
//        //do{
//            NSMutableData *data1 = [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(0, kOnePackgeLength)]];
//            NSMutableArray * readData=[ServerForDevices decodeFileArrayWithData:data1];
//            //分发数据
////                        [self doDisPatchGoalArray:readData];
//            [self doDisPatchGoalArray:readData];
//            //置空
//            self.muData= [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(kOnePackgeLength, self.muData.length-kOnePackgeLength)]];
//            //            NSLog(@"inner");
//        //}while (self.muData.length>=kOnePackgeLength);
//        //self.muData=nil;
//    }else{
//    }
    //NSLog(@"outer-----------");
    [sock readDataWithTimeout:kSocketTimeOut tag:tag];
}
#pragma mark--连接超时调用
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    DFLog(@"onSocket:%p will disconnect with error:%@",sock,err);
    //self.isConnected=NO;
    //    [self doLog:[NSString stringWithFormat:@"onSocket:%p will disconnect with error:%@",sock,err]];
    if(err==nil){
        
    }else {
        [self socketTimeOutAlertWithTcpError:err];
    }
    
}
#pragma mark--断开连接
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    DFLog(@"onSocketDidDisconnect:%p,connect=%@,%d,localhost:%@,%d",sock,sock.connectedHost,sock.connectedPort,sock.localHost,sock.localPort);
    //    [self doLog:[NSString stringWithFormat:@"onSocketDidDisconnect:%p",sock]];
    self.isConnected=kStrDef_N;
    NSDictionary *fParamData = [NSDictionary dictionaryWithObject:kNoticeSocketStateOff forKey:kNoticeFileSocketStateKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeFileSocketStateCmd object:fParamData];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayFileConncet]=_LS_(@"kMddUiAlertFileSocketOff", nil);
//    [self startConnet];
    DFLog(@"self.muData：%@",self.muData);
    
}

#pragma mark 其他代理
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    DFLog(@"%d:%s",__LINE__,__FUNCTION__);
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    //    NSLog(@"%d:%s",__LINE__,__FUNCTION__);
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //     NSLog(@"%d:%s",__LINE__,__FUNCTION__);
    //发送完数据手动读取，-1不设置超时
    //[sock readDataWithTimeout:kSocketTimeOut tag:tag];
}
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    //     NSLog(@"%d:%s",__LINE__,__FUNCTION__);
}
- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    DFLog(@"%d:%s",__LINE__,__FUNCTION__);
}



-(void) doDisPatchGoalArray:(NSMutableArray *) pDataArray
{
    if (pDataArray.count>0) {
        NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfFileArrKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfFileCmd object:fParamData];
//        NSData * TypeLenth=pDataArray[0];
//        NSData * Type=pDataArray[1];
//        NSString * tStr=[[NSString alloc] initWithData:Type encoding:NSUTF8StringEncoding];
//        NSString * tStrLength=[[NSString alloc] initWithData:TypeLenth encoding:NSUTF8StringEncoding];
//        if ([kCmdType_File_FileName_req isEqualToString:tStr]) {
//            
//        }else if ([kCmdType_File_Data_req isEqualToString:tStr]){
//            
//        }
        
    }
}

#pragma 发起请求
-(void) post
{
    //网络可用
    if([self networkVaild ])
    {
        _asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSError *err=nil;
        DFLog(@"host:%@,port:%d",APP_API,APP_File_PORT);
        if (![_asyncSocket connectToHost:APP_API onPort:APP_File_PORT error:&err]) {
            DFLog(@"err:%@",err);
        }
    }else
    {
        //[self netWorkAlert];
    }
    
    
}
-(void) postWithIp:(NSString *)pIp
{
    //网络可用
    if([self networkVaild ])
    {
        //    if (!asyncSocket) {
        _asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSError *err=nil;
        if (![_asyncSocket connectToHost:pIp onPort:APP_File_PORT error:&err]) {
            DFLog(@"err:%@",err);
        }
        //    }
    }else
    {
        //[self netWorkAlert];
    }
    
}
-(void) postWithDataIp :(NSString *)pIp mPort:(UInt16) pPort
{
    //网络可用
    if([self networkVaild ])
    {
        //    if (!asyncSocket) {
        _asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSError *err=nil;
        if (![_asyncSocket connectToHost:pIp onPort:pPort error:&err]) {
            DFLog(@"err:%@",err);
        }
        //    }
    }else
    {
        //[self netWorkAlert];
    }
}
-(void) postLongWithDataIp:(NSString *)pIp mPort:(UInt16) pPort
{
    //网络可用
    if([self networkVaild ])
    {
        if (!_asyncSocket) {
            _asyncSocket=[[AsyncSocket alloc]initWithDelegate:self];
        }
        _asyncSocket.delegate=self;
        //未连接才链接
        if (![_asyncSocket  isConnected]) {
            NSError *err=nil;
            if (![_asyncSocket connectToHost:pIp onPort:pPort error:&err]) {
                DFLog(@"err:%@",err);
            }
        }
        
    }else
    {
        //[self netWorkAlert];
    }
}

-(void) socketTimeOutAlertWithTcpError:(NSError *)err
{
    if(err.code==54)
    {
        //服务端重置忽略
        
    }else
    {
        
    }
#pragma mark ....
    //    _asyncSocket = nil;
    [_asyncSocket disconnect];
    
}
-(Reachability *) networkState
{
    return [Reachability reachabilityForInternetConnection];
}
-(BOOL) networkVaild
{
    BOOL result=false;
    result=[[self networkState] isReachable];
    return result;
}
#pragma mark 文件发送协议

-(void) doWriteData:(NSData *)pData
{
    [_asyncSocket writeData:pData withTimeout:-1 tag:0];
}

-(void)dealloc
{
    [self doRemoveAll];
}
-(void) doRemoveAll
{
    _asyncSocket.delegate=nil;
    _asyncSocket=nil;
    self.muData=nil;
    self.mCurIp=nil;
    self.isConnected=nil;
    //内部定时器
    [self.mSocketTimer invalidate];
    [self.mUITimerWrite1 invalidate];
}

-(void) setUpTimer
{
    self.mSocketTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:[GoalWeakProxy proxyWithTarget:self ]
                                                       selector:@selector(doBeatInnerEvent:)
                                                       userInfo:nil
                                                        repeats:YES];
    self.mUITimerWrite1= [NSTimer scheduledTimerWithTimeInterval:0.001
                                                          target:[GoalWeakProxy proxyWithTarget:self ]
                                                        selector:@selector(doFileDecode:)
                                                        userInfo:nil
                                                         repeats:YES];
}
-(void) doBeatInnerEvent:(NSDictionary *)userInfo
{
    //NSLog(@"%d:%s",__LINE__,__FUNCTION__);
    [self doCheckBeat];
    
}
-(void) doFileDecode:(NSDictionary *)userInfo
{
    if (self.muData.length>=kOnePackgeLength)//range.location!=NSNotFound)
    {
            NSMutableData *data1 = [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(0, kOnePackgeLength)]];
            NSMutableArray * readData=[ServerForDevices decodeFileArrayWithData:data1];
            //分发数据
            //            [self doDisPatchGoalArray:readData];
            [self doDisPatchGoalArray:readData];
            //置空
            self.muData= [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(kOnePackgeLength, self.muData.length-kOnePackgeLength)]];
        //self.muData=nil;
    }
}
-(void) doCheckBeat
{
        //test

        if(![self socketIsConnected]){
            DFLog(@"文件断了的弦=====%@",self.muData);
            //断开连接
//            self.reConnectTime++;
//            if (self.reConnectTime%kReconnectTimeDef==0) {
//                
                self.muData=nil;
                _asyncSocket=nil;
                [self startConnet];
//            }else{
//                //                [self doReBeatWithIndex:self.deviceIndex+1];
//            }
        }else{
            //小于5
            DFLog(@"还活着");
        }
}

//获取服务单例
+(instancetype) GetInstance
{
    static ServerForFileSocket *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
