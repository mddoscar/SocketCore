//
//  CmdSocketBean.h
//  Printer3D
//
//  Created by mac on 2017/2/13.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
命令结构体
 */
@interface CmdSocketBean : NSObject
//命令类型
@property(nonatomic,copy) NSString * type;
//命令数据
@property(nonatomic,strong) NSArray * data;

-(instancetype) initWithDataType:(NSString *) pType mData:(NSArray *) pDataArray;
+(instancetype) initWithDataType:(NSString *) pType mData:(NSArray *) pDataArray;
@end
