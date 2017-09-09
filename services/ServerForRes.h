//
//  ServerForRes.h
//  Printer3D
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


//资源相关服务
@interface ServerForRes : NSObject

-(NSMutableArray *) getResListbyUser:(NSString *) pUser mKeyWord:(NSString *) pKeyWord;

@end
