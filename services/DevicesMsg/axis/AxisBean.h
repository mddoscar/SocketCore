//
//  AxisBean.h
//  Printer3D
//
//  Created by mac on 2017/4/6.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

//原点
@class ZeroPoint;
/*
 坐标对象<unuse>暂时没用</unuse>
 */
@interface AxisBean : NSObject

#pragma mark data
//x轴坐标
@property(nonatomic,assign) int rawX;
//y坐标
@property(nonatomic,assign) int rawY;
//z坐标
@property(nonatomic,assign) int rawZ;
//c轴
@property(nonatomic,assign) int rawC;
//w轴
@property(nonatomic,assign) int rawW;
//比例
@property(nonatomic,assign) double rate;
//原点
@property(nonatomic,strong) ZeroPoint * mZeroPos;

#pragma mark data
-(id) initWithDataRawX:(int) pRawX rawY:(int) pRawY rawZ:(int) pRawZ rawC:(int) pRawC rawW:(int) pRawW rate:(double) pRate ZeroPos:(ZeroPoint *)pZeroPoint;
-(id) initWithDataDefRawX:(int) pRawX rawY:(int) pRawY rawZ:(int) pRawZ rawC:(int) pRawC rawW:(int) pRawW;
-(id) initWithDataDef;
-(id) initWithDataBean:(AxisBean *) pAxisBean;
//映射
#pragma mark convert
/*
 T-1平移
 [1 0 -tx]
 [0 1 -ty]
 [0 0 1]
 S放大
 [Sx 0 0]
 [0 Sy 0]
 [0 0 1]
 S缩小
 [1/Sx 0 0]
 [0 1/Sy 0]
 [0 0 1]
 
 __________
 [Sx 0 tx]
 [0 Sy ty]
 [0 0 1]
 Y轴对称
 ______________
 [1 0 0]
 [0 -1 0]
 [0 0 1]
 X轴对称
 ______________
 [-1 0 0]
 [0 1 0]
 [0 0 1]
 原点对称
 ______________
 [-1 0 0]
 [0 -1 0]
 [0 0 1]
 原点对称
 ______________
 [-1 0 0]
 [0 -1 0]
 [0 0 1]
 
 XY对调
 ______________
 [0 1 0]
 [1 0 0]
 [0 0 1]
 
 Y=-X关于对称
 ______________
 [0 -1 0]
 [-1 0 0]
 [0 0 1]
 */
-(AxisBean *) ConvertX2Y;
//
+(CGPoint) ConvertX2YWithPoint:(CGPoint) pPos;
@end
