//
//  ServerGoableSocket.m
//  Printer3D
//
//  Created by mac on 2017/1/12.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "ServerGoableSocket.h"

#define kMaxBeat 65535
#define kMaxTimeOut 7
#define kMaxDisTimeOut 6 //60秒不收到数据就断开
#define kReconnectTimeDef 1  //技能cd
#define kMaxCmdTimeOut 5 //命令超时
#define kMaxTimeDisApear 30 //超时30秒就算挂了
#import "GoalWeakProxy.h"
#import "NSTimer+XXBlocksSupport.h"
#import "AppDelegate.h"
#import "ServerForPrinter3D.h"
#define kFloatConvertRate 1000
//本地缓存
#import "ServerForSocketCache.h"
#import "CmdSocketBean.h"
#import "CopyOnWriteArrayList.h"
//发送
#import "CmdSenderSocketBean.h"
#import "CopySenderOnWriteArrayList.h"
#import "Ipv4v6Util.h"
#import "MddGoalView.h"
//
#define kEmptyTimeOut 3 //3秒给一个空包
//最大处理长度
#define kMaxDataLength (512*1024)

//#import "GCDSocketManager.h"
#ifdef DEBUG
#define DSLog(fmt, ...) NSLog((@"%s [Line %d] SocketLog" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DSLog(...)
#endif
//显示心跳日志
#define kShowBeat 1


@interface ServerGoableSocket()
{
    //int socketCase;
    //当前IP
    //NSString * curIp;
    //当前端口
    //int curPort;
    ServerForSocketCache * gServerForSocketCache;
}
//线程安全
@property (nonatomic,strong) AsyncSocket * asyncSocket;
//数据池子
@property(nonatomic,strong)NSMutableData *muData;
//判断心跳
//@property(nonatomic,strong)NSMutableData * muBeatData;
//调试代码
@property(nonatomic,strong) NSMutableArray * muArr;
//socket
@property(nonatomic,strong)NSTimer * mSocketTimer;
//ui定时器
@property(nonatomic,strong)NSTimer * mUITimer;
@property(nonatomic,strong)NSTimer * mUITimerRead1;
@property(nonatomic,strong)NSTimer * mUITimerRead_1;
@property(nonatomic,strong)NSTimer * mUITimerWrite2;
@property(nonatomic,strong)NSTimer * mUITimerWrite_1;
//发送定时器
@property(nonatomic,strong)NSTimer * mUITimerSender;
@end
@implementation ServerGoableSocket
@synthesize asyncSocket=_asyncSocket;
@synthesize mCurIp=curIp;
@synthesize mCurPort=curPort;
@synthesize mSocketCase=socketCase;
-(void) setUp
{
    DSLog(@"%d,%s",__LINE__,__FUNCTION__);
    self.BeatIndex=0;
    self.isConnected=kStrDef_N;
    self.timeOut=0;
    self.muData=nil;
    self.muArr=[NSMutableArray array];
    gServerForSocketCache=[ServerForSocketCache GetCacheInstance];
    
    [self doLoadIpConfig];
    //    self.muDataDeb=nil;
    [self startConnet];
//    [NSThread detachNewThreadSelector:@selector(setUpTimer) toTarget:self withObject:nil];
    [self setUpTimer];
    
}
-(BOOL) socketIsConnected
{
    return [self.isConnected isEqualToString:kStrDef_Y];
}
-(void) doCutSocket
{
    if(_asyncSocket!=nil){
        [_asyncSocket disconnect];
    }
    [self doRemoveAll];
    //self=nil;
}
//开始连接
-(void) startConnet
{
    DSLog(@"%d,%s",__LINE__,__FUNCTION__);
    _asyncSocket.delegate=self;
    _muArr=[NSMutableArray array];
    socketCase=0;
    //    self.muData=nil;
    
    @try {
        [self postLongWithDataIp:curIp mPort:curPort];
    } @catch (NSException *exception) {
        DSLog(@"%@",exception);
    } @finally {
        
    }
}
-(void) doLoadIpConfig
{

    curIp= [ConfigService valueForName:@"SysActivityIp"];//  APP_API;
    curPort= [[ConfigService valueForName:@"SysActivityPort"] intValue];//APP_PORT;
#pragma mark 重新获取IP
    NSString * redictIp=[Ipv4v6Util getProperIPWithAddress:curIp port:curPort];
    curIp=redictIp;
}
#pragma  mark socket逻辑
-(void) doStartSocketWithCase:(int) pCase;
{
    socketCase=pCase;
    curIp= [ConfigService valueForName:@"SysActivityIp"];//  APP_API;
    curPort= [[ConfigService valueForName:@"SysActivityPort"] intValue];//APP_PORT;
    //[self postLongWithDataIp:curIp mPort:curPort];
    
}
#pragma mark--建立连接发送数据
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    DSLog(@"%d:%s",__LINE__,__FUNCTION__);
    [sock readDataWithTimeout:kSocketTimeOut tag:0];
    //
    NSDictionary *fParamData = [NSDictionary dictionaryWithObject:kNoticeSocketStateOn forKey:kNoticeSocketStateKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeSocketStateCmd object:fParamData];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayConncet]=_LS_(@"kMddUiAlertSocketOn", nil);
    [[MddGoalView GetInitInstance]refeshView];
    //逻辑
    [self socketLogic];
    //已经连上
    
}

#pragma mark--接收数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
#if 0
    NSInteger a=0;
    for (NSInteger i=0; i<data.length; i++) {
        NSData *data1=[data subdataWithRange:NSMakeRange(i,1)];
        
        
        
        if ([data1 isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
            [_muArr addObject: [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
            a=i+1;
            
        }
        if ([data1 isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            
            a+=1;
            
            [self doDisPatchGoalArray:_muArr];
            [_muArr removeAllObjects];
            continue;
            //            break;
            
        }
        
    }
#else
    if (nil==self.muData) {
        self.muData=[NSMutableData data];
    }
    [self.muData appendData:data];
#endif
    //DSLog(@"outer-----------");
    [sock readDataWithTimeout:kSocketTimeOut tag:tag];
}
#pragma mark--连接超时调用
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    DSLog(@"onSocket:%p will disconnect with error:%@",sock,err);
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
    DSLog(@"onSocketDidDisconnect:%p,connect=%@,%d,localhost:%@,%d",sock,sock.connectedHost,sock.connectedPort,sock.localHost,sock.localPort);
    //    [self doLog:[NSString stringWithFormat:@"onSocketDidDisconnect:%p",sock]];
    self.isConnected=kStrDef_N;
    //[self startConnet];
    DSLog(@"self.muData：%@",self.muData);
    [self doClearCache];
    NSDictionary *fParamData = [NSDictionary dictionaryWithObject:kNoticeSocketStateOff forKey:kNoticeSocketStateKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeSocketStateCmd object:fParamData];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayConncet]=_LS_(@"kMddUiAlertSocketOff", nil);
     [[MddGoalView GetInitInstance]refeshView];
    //DSLog(@"sorry the connect is failure %ld",_asyncSocket.userData);
    
    
}

#pragma mark 其他代理
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    DSLog(@"%d:%s",__LINE__,__FUNCTION__);
}
//- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket
//{
//     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
//    return [NSRunLoop new];
//}
//- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
//{
//     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
//    return YES;
//}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    //    DSLog(@"%d:%s",__LINE__,__FUNCTION__);
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
    //发送完数据手动读取，-1不设置超时
    //[sock readDataWithTimeout:kSocketTimeOut tag:tag];
}
- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    //     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
}
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
//  shouldTimeoutReadWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length
//{
//     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
//    return elapsed;
//}
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
// shouldTimeoutWriteWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length
//{
//     DSLog(@"%d:%s",__LINE__,__FUNCTION__);
//    return elapsed;
//}
- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    DSLog(@"%d:%s",__LINE__,__FUNCTION__);
}

-(void) socketLogic
{
    //列表
    if (socketCase==0) {
        [self doSendPresentReqPackage];
    }else if(socketCase==1)
    {
        /*
         NSString * testStr=[ServerForDevices getCommonStrNewTypeCode:kCmdType_Cmd_req cmdStr:kCmdType_Cmd_req_str_stop];
         NSData * testData= [testStr dataUsingEncoding:NSUTF8StringEncoding];
         [_asyncSocket writeData:testData withTimeout:-1 tag:0];
         */
        
    }else if(socketCase==2)
    {
        
    }
    
}
-(void) doDisPatchGoalArray:(NSMutableArray *) pDataArray
{
    if (pDataArray.count>0) {
        NSString * tCmd=pDataArray[0];
        if ([kCmdType_Beat_req isEqualToString:tCmd]) {
            
            int  index= [pDataArray[1] intValue];
            self.isConnected=kStrDef_Y;
            self.timeOut=0;
            self.deviceIndex=index;            DSLog(@"接到心跳index===============================:%d",index);
            [self doReBeatWithIndex:self.deviceIndex];
        }else if ([kCmdType_Beat_resp isEqualToString:tCmd]){
            if (pDataArray.count>1) {
                long  index= [pDataArray[1] intValue];
                if (index==self.BeatIndex) {
                    
                    self.isConnected=kStrDef_Y;
                }
            }
        }else {

            NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
        }
        
    }
}

//缓存命令
-(void)doCacheCmd:(NSMutableArray *) pDataArray mRawData:(NSData *) pData
{
    if (pDataArray.count>0) {
        NSString * tCmd=pDataArray[0];
//        NSLog(@"tCmd:%@",tCmd);
        //缓存了
        if ([gServerForSocketCache AddCmdSocketBeanWithType:tCmd mDataArray:pDataArray]) {
            
        }
        else if([kCmdType_now_req isEqualToString:tCmd])
        {
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]=pDataArray;
            //
            struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
          
            [AppDelegate GetAppDelegate].mGoalDic[kDic_Mechanical_origin_now_dic]=[NSMutableArray arrayWithObjects:kDefDK,[NSString stringWithFormat:@"%d",sp.para.gui.XMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.YMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.ZMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_X],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Y],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Z], nil];//            //其他
//            pDataArray= [ServerForDevices decodeArrayNowPackageWithData:pData];
            
            NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
        }
        else{
            
            NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
        }
        //缓存
        [ServerForDevices DoGoableCacheWithCommand:tCmd WithArray:pDataArray];
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
        DSLog(@"host:%@,port:%d",APP_API,APP_PORT);
        if (![_asyncSocket connectToHost:APP_API onPort:APP_PORT error:&err]) {
            DSLog(@"err:%@",err);
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
        if (![_asyncSocket connectToHost:pIp onPort:APP_PORT error:&err]) {
            DSLog(@"err:%@",err);
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
            DSLog(@"err:%@",err);
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
                DSLog(@"err:%@",err);
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

//写数据
-(void) doWriteData:(NSData*) pData
{
    [self doWriteSocketData:pData];
    //[_asyncSocket writeData:pData withTimeout:-1 tag:0];
}
-(void) doWriteDataStr:(NSString *)pDataStr
{
    [self doWriteSocketData:[pDataStr dataUsingEncoding:NSUTF8StringEncoding]];
    //[_asyncSocket writeData:[pDataStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
-(void) doWriteDataCmd_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr
{
    [self doWriteSocketData:[[ServerForDevices getCommonStrTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding] ];
    //[_asyncSocket writeData: [[ServerForDevices getCommonStrTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
-(void) doWriteDataCmdStrNewType_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr
{
     [self doWriteSocketData:[[ServerForDevices getCommonStrNewTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding]];
    //[_asyncSocket writeData: [[ServerForDevices getCommonStrNewTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
-(void) doWriteDataCmd_req:(NSString*) pCmdType cmdStrArr:(NSMutableArray *) pCmdStrArr
{
    [self doWriteSocketData:[[ServerForDevices getCommonStrArrTypeCode:pCmdType cmdStrArr:pCmdStrArr] dataUsingEncoding:NSUTF8StringEncoding]];
    //[_asyncSocket writeData:[[ServerForDevices getCommonStrArrTypeCode:pCmdType cmdStrArr:pCmdStrArr] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
//统一接口
-(void) doWriteSocketData:(NSData *)pData
{
//    DSLog(@"doWriteSocketData:%ld",pData.length);
//    DSLog(@"pData:%@",pData);
     [_asyncSocket writeData:pData withTimeout:-1 tag:0];
}
#pragma mark cahce
//写数据
-(void) doWriteCacheData:(NSData*) pData
{
    [self doWriteSocketCacheData:pData mType:kDefSenderCmd];
}
-(void) doWriteCacheDataStr:(NSString *)pDataStr
{
    [self doWriteSocketCacheData:[pDataStr dataUsingEncoding:NSUTF8StringEncoding] mType:kDefSenderCmd];
}
-(void) doWriteCacheDataCmd_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr
{
    [self doWriteSocketCacheData:[[ServerForDevices getCommonStrTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding] mType:pCmdType];
}
-(void) doWriteCacheDataCmdStrNewType_req:(NSString*) pCmdType cmdStr:(NSString *) pComStr
{
    [self doWriteSocketCacheData:[[ServerForDevices getCommonStrNewTypeCode:pCmdType cmdStr:pComStr] dataUsingEncoding:NSUTF8StringEncoding] mType:pCmdType];
}
-(void) doWriteCacheDataCmd_req:(NSString*) pCmdType cmdStrArr:(NSMutableArray *) pCmdStrArr
{
    [self doWriteSocketCacheData:[[ServerForDevices getCommonStrArrTypeCode:pCmdType cmdStrArr:pCmdStrArr] dataUsingEncoding:NSUTF8StringEncoding] mType:pCmdType];
}
//统一接口
-(void) doWriteSocketCacheData:(NSData *)pData mType:(NSString *) pType
{
//    DSLog(@"doWriteSocketData:%ld",pData.length);
    [gServerForSocketCache AddCmdSenderSocketBeanWithType:pType mData:pData];
}
-(void) doBeat
{
    self.BeatIndex++;
    if (self.BeatIndex>=kMaxBeat) {
        self.BeatIndex=0;
    }
    [self doWriteDataCmd_req:kCmdType_Beat_req cmdStrArr:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%ld",self.BeatIndex], nil]];
    // [_asyncSocket writeData:[pDataStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
-(void) doCheckBeat
{
    //if (![self socketIsConnected]) {
    //DSLog(@"timeOut%d, self.isConnected:%@",self.timeOut, self.isConnected);
    self.timeOut++;
    if (self.timeOut%kEmptyTimeOut==0) {
//        [self doSendEmptyPack];
    }
    if(self.timeOut>kMaxDisTimeOut)
    {
        //}
        //    DSLog(@"timeOut%d, self.isConnected:%@",self.timeOut, self.isConnected);
        //DSLog(@"timeOut%d, self.isConnected:%@",self.timeOut, self.isConnected);
        if (self.timeOut>kMaxTimeOut) {
            DSLog(@"timeOut%d, self.isConnected:%@",self.timeOut, self.isConnected);
            self.isConnected=kStrDef_N;
            //test
            DSLog(@"断了的弦=====%@",self.muData);
            //断开连接
            self.reConnectTime++;
            if (self.reConnectTime%kReconnectTimeDef==0) {
                if (!self.HasFlat) {
                    //重新计数
                    //                self.reConnectTime=0;
                    if (self.timeOut>=kMaxCmdTimeOut) {
                        self.muData=nil;
                        _asyncSocket=nil;
                        [self startConnet];
                    }
                }
            }else{
                //                [self doReBeatWithIndex:self.deviceIndex+1];
            }
            //}else{
            //不重新连接但是要心跳
            
            //}
        }else{
            //小于5
            DSLog(@"还活着");
            //[self startConnet];
            //self.isConnected=kStrDef_Y;
            //self.timeOut=0;
            //[self doReBeatWithIndex:self.deviceIndex];
            //
        }
    }
    
    //if(self.timeOut % (kMaxTimeOut/2)==0)
    //{
    //如果挂了
    
    //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //
    //        NSString *currentStatu = [userDefaults valueForKey:@"Statu"];
    //
    //        //程序在前台才进行重连
    //        if ([currentStatu isEqualToString:@"foreground"]) {
    //暴力破解++
    
    //        }
    
    //}
}

// 切断socket
//-(void)cutOffSocket{
//
//    _asyncSocket.userData = SocketOfflineByUser;// 声明是由用户主动切断
//
//    //[self.connectTimer invalidate];
//
//    [_asyncSocket disconnect];
//}
-(void) doReBeatWithIndex:(int) pIndex
{
    DSLog(@"发送心跳,isConnect:%@,pIndex:%d   %@",self.isConnected,pIndex,[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",pIndex],nil]);
    [self doWriteDataCmd_req:kCmdType_Beat_resp cmdStrArr:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",pIndex], nil]];

    
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
    self.BeatIndex=0;
    self.timeOut=0;
    self.deviceIndex=0;
    [gServerForSocketCache ClearCmdSocketBeanAll];
    //内部定时器
    [self.mSocketTimer invalidate];
    [self.mUITimer invalidate];
    [self.mUITimerRead1 invalidate];
    [self.mUITimerRead_1 invalidate];
    [self.mUITimerWrite2 invalidate];
    [self.mUITimerWrite_1 invalidate];
    //
    [self.mUITimerSender invalidate];
}

-(void) setUpTimer
{
    self.mSocketTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:[GoalWeakProxy proxyWithTarget:self ]
                                                       selector:@selector(doBeatInnerEvent:)
                                                       userInfo:nil
                                                        repeats:YES];
    self.mUITimerRead1 = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                          target:[GoalWeakProxy proxyWithTarget:self ]
                                                        selector:@selector(doUIFreshBeatEvent)
                                                        userInfo:nil
                                                         repeats:YES];
    self.mUITimerRead_1 = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                           target:[GoalWeakProxy proxyWithTarget:self ]
                                                         selector:@selector(doUIFreshEvent)
                                                         userInfo:nil
                                                          repeats:YES];
    self.mUITimerWrite2 = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                           target:[GoalWeakProxy proxyWithTarget:self ]
                                                         selector:@selector(doDecodeEvent)
                                                         userInfo:nil
                                                          repeats:YES];
    self.mUITimerWrite_1 = [NSTimer scheduledTimerWithTimeInterval:0.003
                                                            target:[GoalWeakProxy proxyWithTarget:self ]
                                                          selector:@selector(doDecodeEvent)
                                                          userInfo:nil
                                                           repeats:YES];
    //发送缓存
    self.mUITimerSender = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                            target:[GoalWeakProxy proxyWithTarget:self ]
                                                          selector:@selector(doSenderCache)
                                                          userInfo:nil
                                                           repeats:YES];
    
}
-(void) doDecodeEvent
{
    long long location=[ServerForDevices indexofLineWithData:self.muData];
    bool hasLine=false;
    if (location>0) {
        hasLine=true;
    }else{
        hasLine=false;
    }
    if (location>0)//range.location!=NSNotFound)
    {
        do{
            NSMutableData *data1 = [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(0, location+1)]];
            NSMutableArray * readData=[ServerForDevices decodeArrayOldWithData:data1];
            //分发数据
            //            [self doDisPatchGoalArray:readData];
            [self doCacheCmd:readData mRawData:data1];
            //置空
            self.muData= [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(location+1, self.muData.length-location-1)]];
            location=[ServerForDevices indexofLineWithData:self.muData];
            if (location>0) {
                hasLine=true;
            }else{
                hasLine=false;
            }
            //            DSLog(@"inner");
        }while (hasLine);
        //self.muData=nil;
    }else{
        //        if (self.muData.length>0) {
        ////            DSLog(@"self.muData=:%ld",self.muData.length);
        //        }
    }
}

-(void) doUIFreshEvent
{
#if 0
    if (nil!=self.muData) {
        long long location=[ServerForDevices indexofLineWithData:self.muData];
        //        int backCount=2;
        //        int backindex=0;
        if (location>0)//range.location!=NSNotFound)
        {
            //            do{
            NSMutableData *data1 = [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(0, location+1)]];
            NSMutableArray * readData=[ServerForDevices decodeArrayOldWithData:data1];
            //分发数据
            [self doDisPatchGoalArray:readData];
            //置空
            self.muData= [NSMutableData dataWithData:[self.muData subdataWithRange:NSMakeRange(location+1, self.muData.length-location-1)]];
            //                backindex++;
            //            }while(backindex<backCount);
            
        }else{
            
            
        }
        
    }
#esle
    
#endif
    //    //按顺序刷
    //    if ([gServerForSocketCache.HeartBeatList HasValue]) {
    //            DSLog(@"心跳队列%d",[gServerForSocketCache.HeartBeatList GetSize]);
    //        //CmdSocketBean * tBeatObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_Beat_resp];
    //        CmdSocketBean * tBeatObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_Beat_req];
    //        //心跳移除队列
    //        [self doDealCmdWith:tBeatObj.data];
    //    }
    
    if ([gServerForSocketCache.CoordinateList HasValue]) {
        CmdSocketBean * tCoodObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_axis_req_resp];
        //心跳移除队列
        [self doDealCmdWith:tCoodObj.data];
    }
    
    if ([gServerForSocketCache.TemperatureList HasValue]) {
        CmdSocketBean * tTemObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_temp_req_resp];
        
        //心跳移除队列
        [self doDealCmdWith:tTemObj.data];
    }
    if ([gServerForSocketCache.SpeedList HasValue]) {
        CmdSocketBean * tSpeedObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_speed_resp];
        
        //心跳移除队列
        [self doDealCmdWith:tSpeedObj.data];
    }
    if ([gServerForSocketCache.LineNumberList HasValue]) {
        CmdSocketBean * tLinenumberObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_linenumber_req_resp];
        
        //心跳移除队列
        [self doDealCmdWith:tLinenumberObj.data];
    }
    
    if ([gServerForSocketCache.FaultList HasValue]) {
        CmdSocketBean * tErrObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_error_resp];
        
        //心跳移除队列
        [self doDealCmdWith:tErrObj.data];
    }
    //心跳移除队列
    
}
-(void) doUIFreshBeatEvent
{
    //    //按顺序刷
    if ([gServerForSocketCache.HeartBeatList HasValue]) {
        DSLog(@"心跳队列%d",[gServerForSocketCache.HeartBeatList GetSize]);
        //CmdSocketBean * tBeatObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_Beat_resp];
        CmdSocketBean * tBeatObj= [gServerForSocketCache getCmdSocketBeanWithType:kCmdType_Beat_req];
        //心跳移除队列
        [self doDealCmdWith:tBeatObj.data];
    }
    
}
-(void) doDealCmdWith:(NSArray *) pDataArray
{
    if(nil!=pDataArray&&pDataArray.count>0)
    {
        NSString * tCmd=pDataArray[0];
//        DSLog(@"tCmd:%@",tCmd);
        if ([kCmdType_Beat_req isEqualToString:tCmd]) {
            
            int  index= [pDataArray[1] intValue];
            self.isConnected=kStrDef_Y;
            self.timeOut=0;
            self.deviceIndex=index;
            DSLog(@"接到心跳index===============================:%d",index);
            [self doReBeatWithIndex:self.deviceIndex];
        }else if ([kCmdType_Beat_resp isEqualToString:tCmd]){
            if (pDataArray.count>1) {
                long  index= [pDataArray[1] intValue];
                if (index==self.BeatIndex) {
                    
                    self.isConnected=kStrDef_Y;
                }
            }
        }else {
          
            NSDictionary *fParamData = [NSDictionary dictionaryWithObject:pDataArray forKey:kNoticfArrKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticfCmd object:fParamData];
          

        }
    }else{
        DSLog(@"非法数据%@",pDataArray);
    }
    
}
//发送缓存
-(void) doSenderCache
{
    if ([gServerForSocketCache.SenderList HasValue]) {
        CmdSenderSocketBean * obj=[gServerForSocketCache.SenderList RemoveFirstObj];
        DSLog(@"count:%d",[gServerForSocketCache.SenderList GetSize]);
        //发送数据
        [self doWriteSocketData:obj.data];
    }
}
//清除缓存
-(void) doClearCache
{
    self.BeatIndex=0;
    self.timeOut=0;
    self.deviceIndex=0;
    [gServerForSocketCache ClearCmdSocketBeanAll];
    self.muData=nil;
}
-(void) doBeatInnerEvent:(NSDictionary *)userInfo
{
    //DSLog(@"%d:%s",__LINE__,__FUNCTION__);
    [self doCheckBeat];
    
}
//发送空包
-(void) doSendEmptyPack
{
    DSLog(@"发送空包");
    [self doWriteDataCmd_req:kCmdType_Empty_req cmdStrArr:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",0], nil]];
    
}
//发送现场包
-(void) doSendPresentReqPackage
{
    DSLog(@"发送现场包");
//    kCmdType_now_req_resp
    [self doWriteDataCmd_req:kCmdType_now_req_resp cmdStrArr:[NSMutableArray array]];
}
-(ServerForSocketCache *) getServerForSocketCache
{
    return gServerForSocketCache;
}
//获取服务单例
+(instancetype) GetInstance
{
    static ServerGoableSocket *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

@end
