//
//  CmdFileName.h
//  Printer3D
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdBase.h"

@interface CmdFileName :  CmdBase

@property(nonatomic,copy) NSString * filename;
@property(nonatomic,copy) NSString * size;
#pragma mark ctor
-(instancetype)initWithData:(NSString *) filename Size:(NSString *)size;
+(instancetype) GetDefValue;
@end
