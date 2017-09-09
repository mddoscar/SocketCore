//
//  CopySenderOnWriteArrayList.m
//  Printer3D
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CopySenderOnWriteArrayList.h"

@interface CopySenderOnWriteArrayList()
{
    NSMutableArray * dataList;
    int size;
    int maxSize;
}
@end


@implementation CopySenderOnWriteArrayList



#pragma mark sizes
//添加元素
-(BOOL) AddBean:(CmdSenderSocketBean *) pCmdSocketBean
{
    @try {
        if ([self GetSize]==[self GetMaxSize]) {
            [self RemoveFirstObj];
            [dataList addObject:pCmdSocketBean];
        }else{
            [dataList addObject:pCmdSocketBean];
            size++;
        }
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return false;
    } @finally {
        
    }
    
    return false;
}
//添加元素
-(BOOL) AddWithType:(NSString *) pType mData:(NSData *) pData
{
    
    @try {
        if ([self GetSize]==[self GetMaxSize]) {
            [self RemoveFirstObj];
            [dataList addObject:[CmdSenderSocketBean initWithDataType:pType mData:pData]];
        }else{
            [dataList addObject:[CmdSenderSocketBean initWithDataType:pType mData:pData]];
            size++;
        }
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return false;
    } @finally {
        
    }
    
    return false;
}
//获取大小
-(int) GetSize
{
    return size;
}
-(int) GetMaxSize
{
    return maxSize;
}
//删除元素
-(CmdSenderSocketBean *) RemoveObjWithIndex:(int) pIndex
{
    
    CmdSenderSocketBean * rObj=nil;
    if (pIndex<=dataList.count-1) {
        rObj= [dataList objectAtIndex:pIndex];
        [dataList removeObjectAtIndex:pIndex];
        size--;
    }
    return rObj;
}
//获取队列第一个元素
-(CmdSenderSocketBean *) RemoveFirstObj
{
    CmdSenderSocketBean * rObj=nil;
    if (dataList.count>0) {
        rObj= [dataList objectAtIndex:0];
        [dataList removeObjectAtIndex:0];
        size--;
    }
    return rObj;
}
//清空所有对象
-(BOOL) ClearObjs
{
    @try {
        [dataList removeAllObjects];
        size=0;
        return true;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return false;
    } @finally {
        
    }
    return false;
}
-(BOOL) IsFull
{
    return  size>=maxSize;
}
-(BOOL) HasValue
{
    return size>0;
}
-(void) initDataMaxSize:(int) pMaxSize
{
    dataList=[NSMutableArray new];
    size=0;
    maxSize=pMaxSize;
}

//
+(instancetype) GetListInstanceMaxSize:(int) pMaxSize
{
    CopySenderOnWriteArrayList *sharedInstance = nil;
    //static dispatch_once_t predicate;
    //dispatch_once(&predicate, ^{
    sharedInstance = [[self alloc] init];
    [sharedInstance initDataMaxSize:pMaxSize];
    //});
    return sharedInstance;
}

@end
