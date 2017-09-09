//
//  ServerForAccount.m
//  Printer3D
//
//  Created by mac on 2016/12/13.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "ServerForAccount.h"
#import "AccountCellData.h"
#import "SettingBean.h"
#import "SettingBoolBean.h"
//
#import "AppDelegate.h"
//头像

@implementation ServerForAccount

-(NSMutableArray *) getAccountArrayList
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[AccountCellData alloc] initWithData:@"" icon:kBaseUSER_ICON type:MddAccountTypeTop mInfoDic:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",kAccountCellDataMark, nil]]];
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_ArrayList_set", nil) icon:@"" type:MddAccountCenter mInfoDic:nil info:_LS_(@"kMdd_str_ServerForAccount_ArrayList_set_info", nil)]];
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_ArrayList_help", nil) icon:@"" type:MddAccountCenter  mInfoDic:nil info:_LS_(@"kMdd_str_ServerForAccount_ArrayList_help_info", nil)]];
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_ArrayList_linkus", nil) icon:@"" type:MddAccountCenter  mInfoDic:nil info:_LS_(@"kMdd_str_ServerForAccount_ArrayList_linkus_info", nil)]];
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_ArrayList_payqrcode", nil) icon:@"" type:MddAccountCenter  mInfoDic:nil info:_LS_(@"kMdd_str_ServerForAccount_ArrayList_payqrcode_info", nil)]];
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMddMoudleSetting_Title_About", nil) icon:@"" type:MddAccountCenter  mInfoDic:nil info:_LS_(@"kMddMoudleSetting_Title_AboutEN", nil)]];
        //
    [rArray addObject:[[AccountCellData alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_ArrayList_logout", nil) icon:@"" type:MddAccountBottomText  mInfoDic:nil info:_LS_(@"kMdd_str_ServerForAccount_ArrayList_logout_info", nil)]];

    return rArray;
}
-(NSMutableArray *) getSettingArrayList
{
     NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_ipset", nil) mValue:@"" mIcon:@""]];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_portset", nil) mValue:@"" mIcon:@""]];
    
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_Fileportset", nil) mValue:@"" mIcon:@""]];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_reset_IpPort", nil) mValue:@"" mIcon:@""]];

    
    [rArray addObject:[[SettingBoolBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_touchlock", nil) mValue:@"" mIcon:@"" mIsOpen:@"Y"]];
//    [rArray addObject:[[SettingBoolBean alloc] initWithData:@"九宫格解锁" mValue:@"" mIcon:@"" mIsOpen:@"Y"]];
    
    
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_serverset", nil) mValue:@"" mIcon:@""]];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_resmainset", nil) mValue:@"" mIcon:@""]];
    return rArray;
}
-(NSMutableArray *) getServerSetList
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_SettingArrayList_serverset", nil) mValue:@"" mIcon:@""]];
    
    return rArray;
}
-(NSMutableArray *) getUpdateUserArrayList
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_UpdateUserArrayList_username", nil) mValue:[AppDelegate GetAppDelegate].mCurrentUser mIcon:@""]];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_UpdateUserArrayList_tel", nil) mValue:[AppDelegate GetAppDelegate].mCurrentUser mIcon:@""]];
    [rArray addObject:[[SettingBean alloc] initWithData:_LS_(@"kMdd_str_ServerForAccount_UpdateUserArrayList_email", nil) mValue:@"" mIcon:@""]];
     return rArray;
}
@end
