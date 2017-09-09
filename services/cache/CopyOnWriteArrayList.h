//
//  CopyOnWriteArrayList.h
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdSocketBean.h"

/*
 读写数组
 */
@interface CopyOnWriteArrayList : NSObject

#pragma mark func
//添加元素
-(BOOL) AddBean:(CmdSocketBean *) pCmdSocketBean;
//添加元素
-(BOOL) AddWithType:(NSString *) pType mDataArray:(NSArray *) pDataArray;
//获取大小
-(int) GetSize;
-(int) GetMaxSize;
//删除元素
-(CmdSocketBean *) RemoveObjWithIndex:(int) pIndex;
//获取队列第一个元素
-(CmdSocketBean *) RemoveFirstObj;
//清空所有对象
-(BOOL) ClearObjs;
-(BOOL) IsFull;
-(BOOL) HasValue;
//获取服务(不能单粒)
+(instancetype) GetListInstanceMaxSize:(int) pMaxSize;

@end
