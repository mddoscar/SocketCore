//
//  CopySenderOnWriteArrayList.h
//  Printer3D
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdSenderSocketBean.h"
/*
 发送读写数组
 */
@interface CopySenderOnWriteArrayList : NSObject
#pragma mark func
//添加元素
-(BOOL) AddBean:(CmdSenderSocketBean *) pCmdSocketBean;
//添加元素
-(BOOL) AddWithType:(NSString *) pType mData:(NSData *) pData;
//获取大小
-(int) GetSize;
-(int) GetMaxSize;
//删除元素
-(CmdSenderSocketBean *) RemoveObjWithIndex:(int) pIndex;
//获取队列第一个元素
-(CmdSenderSocketBean *) RemoveFirstObj;
//清空所有对象
-(BOOL) ClearObjs;
-(BOOL) IsFull;
-(BOOL) HasValue;
//获取服务(不能单粒)
+(instancetype) GetListInstanceMaxSize:(int) pMaxSize;

@end
