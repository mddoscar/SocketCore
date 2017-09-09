//
//  GCDSocketManager.h
//  Printer3D
//
//  Created by mac on 2017/1/14.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

/*
 没用到。。。。。
 */
@interface GCDSocketManager : NSObject

@property(nonatomic,strong) GCDAsyncSocket *socket;

//单例
+ (instancetype)sharedSocketManager;

//连接
- (void)connectToServer;

//断开
- (void)cutOffSocket;

@end
