//
//  CopyOnWriteArrayList.m
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "CopyOnWriteArrayList.h"

@interface CopyOnWriteArrayList()
{
    NSMutableArray * dataList;
    int size;
    int maxSize;
}
@end

@implementation CopyOnWriteArrayList

#pragma mark sizes
//添加元素
-(BOOL) AddBean:(CmdSocketBean *) pCmdSocketBean
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
-(BOOL) AddWithType:(NSString *) pType mDataArray:(NSArray *) pDataArray
{
    
    @try {
        if ([self GetSize]==[self GetMaxSize]) {
            [self RemoveFirstObj];
            [dataList addObject:[CmdSocketBean initWithDataType:pType mData:pDataArray]];
        }else{
            [dataList addObject:[CmdSocketBean initWithDataType:pType mData:pDataArray]];
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
-(CmdSocketBean *) RemoveObjWithIndex:(int) pIndex
{
    
    CmdSocketBean * rObj=nil;
    if (pIndex<=dataList.count-1) {
        rObj= [dataList objectAtIndex:pIndex];
        [dataList removeObjectAtIndex:pIndex];
        size--;
    }
    return rObj;
}
//获取队列第一个元素
-(CmdSocketBean *) RemoveFirstObj
{
    CmdSocketBean * rObj=nil;
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
    CopyOnWriteArrayList *sharedInstance = nil;
    //static dispatch_once_t predicate;
    //dispatch_once(&predicate, ^{
    sharedInstance = [[self alloc] init];
    [sharedInstance initDataMaxSize:pMaxSize];
    //});
    return sharedInstance;
}

@end
