//
//  ServerForAccount.h
//  Printer3D
//
//  Created by mac on 2016/12/13.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 账号服务
 */
@interface ServerForAccount : NSObject

-(NSMutableArray *) getAccountArrayList;
//设置界面
-(NSMutableArray *) getSettingArrayList;
//old set
-(NSMutableArray *) getServerSetList;
//修改用户资料
-(NSMutableArray *) getUpdateUserArrayList;
//http://www.wonwin-im.com/Printer3D/help
@end
