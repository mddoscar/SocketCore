//
//  ServerForPrinter3D.h
//  Printer3D
//
//  Created by mac on 2016/12/10.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


//打印机服务
@interface ServerForPrinter3D : NSObject

//获取打印机页面
-(NSMutableArray *) getPrintFuncList;
//获取打印头的数据
-(NSMutableArray *) getPrinterTouchArray;
//获取打印头的设备列表
-(NSMutableArray *) getPrinterGroupArray;
-(NSMutableArray *) getPrinterGroupArrayNew;
//轴校准
-(NSMutableArray *) getAxisCalibrationList;
//打印头轴
-(NSMutableArray *) getPrinterAxisArray;

+(NSString *) getStringWithDic:(NSDictionary *) pDic;

+(instancetype) shareNewInstance;


@end
