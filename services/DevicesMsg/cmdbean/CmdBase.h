//
//  CmdBase.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ShareData.h"
#import "ShareDataHeader.h"

#import "CommonMsgHeader.h"
//
#define kDefInitValue @"0"
#import "JSONKit.h"

@protocol CmdBaseDelegate
@optional
//转换函数
-(instancetype) convertFromStruct:(struct ScenePackage )pValue;
-(instancetype)convertFromArray:(NSArray * )pDataArray;
-(instancetype)updateWithArray:(NSArray * )pDataArray;
-(NSMutableArray *) toCmdArray;
@end


/*
类型
 */
@interface CmdBase : NSObject<CmdBaseDelegate>
{
    id<CmdBaseDelegate> mddDelegate;
}
@property(nonatomic,strong) id<CmdBaseDelegate> mddDelegate;
//类型
@property(nonatomic,copy) NSString * type;

+(instancetype) GetDefValue;
-(instancetype)convertFromArray:(NSArray * )pDataArray;
//重写转json方法
-(NSString *)description;
@end
