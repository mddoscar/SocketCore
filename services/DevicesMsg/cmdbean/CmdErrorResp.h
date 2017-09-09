//
//  CmdErrorResp.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdErrorResp :  CmdBase
@property(nonatomic,copy) NSString * sfindex;
@property(nonatomic,copy) NSString * sfvalue;
@property(nonatomic,copy) NSString * offset;
@property(nonatomic,copy) NSString * value;
#pragma mark ctor
-(instancetype)initWithDataSfindex:(NSString *) sfindex mSfvalue:(NSString *) sfvalue mOffset:(NSString *) offset mValue:(NSString *) value;
+(instancetype) GetDefValue;
@end
