//
//  ZeroPoint.h
//  Printer3D
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 原点<unuse>暂时没用</unuse>
 */
@interface ZeroPoint : NSObject
//x轴
@property(assign,nonatomic)int x;
//y轴
@property(assign,nonatomic)int y;
//z轴
@property(assign,nonatomic)int z;
//比例
@property(assign,nonatomic) double rate;

#pragma mark ctor
//构造
-(id) initWithDataX:(int) pX Y:(int)pY Z:(int) pZ rate:(double) pRate;
//默认构造
-(id) initWithDataDefX:(int) pX Y:(int)pY Z:(int) pZ;
+(instancetype) GetDefValue;

@end
