//
//  ServerForPrinter3D.m
//  Printer3D
//
//  Created by mac on 2016/12/10.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "ServerForPrinter3D.h"
//
#import "MddDeskItem.h"
#import "PrinterTouchData.h"
//
#import "GroupDevsHeader.h"

//文字颜色
#define kTitleLabelColor [UIColor whiteColor] //前面字体
#define kValueLabelColor [UIColor greenColor] //正文字体
#define kTitleLabelFont [UIFont fontWithName:@"Arial" size:16.0] //前面字体
#define kValueLabelFont [UIFont fontWithName:@"Arial" size:14.0] //前面字体
#define kTitleLabelKey @"TitleLabelKey" //标题
#define kValueLabelKey @"ValueLabelKey" //值
#define kSplitLength 1 //分割符长度
#define kSplitLineLength 1 //换行符长度

@implementation ServerForPrinter3D
-(NSMutableArray *) getPrintFuncList
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_frontdoor_title", nil) icon:@"前门-100X100.png" badge:@"" vcName:@"FrontDoorViewController" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_backdoor_title", nil) icon:@"Back-opening" badge:@"" vcName:@"BackDoorViewController" isStoryBoard:NO isModal:NO]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_printerhead_title", nil) icon:@"参数设置的logo.png" badge:@"" vcName:@"PrinterTouchExpendViewController" isStoryBoard:NO  isModal:NO]];
    

    //新版本
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_printerhead_title", nil) icon:@"打印头-100x100.png" badge:@"" vcName:@"PrinterHeaderNew2ViewController" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_printertable_title", nil) icon:@"打印台加热台logo-100X100.png" badge:@"" vcName:@"PrinterTableViewController" isStoryBoard:NO   isModal:NO]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_CodeEncoder_title", nil) icon:@"轴控制器-100X100.png" badge:@"" vcName:@"AxisViewController" isStoryBoard:NO isModal:NO]];
    
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_CodeEncoder_title", nil) icon:@"轴控制器-100X100.png" badge:@"" vcName:@"XYZViewController" isStoryBoard:NO isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_Start_title", nil) icon:@"播放按钮-100X100.png" badge:@"" vcName:@"StartGCodeViewController" isStoryBoard:NO isModal:NO]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_AxisCalibration_title", nil) icon:@"startLogo" badge:@"" vcName:@"AxisCalibrationViewController" isStoryBoard:NO isModal:NO]];
    //执行按钮
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_ResetSocket_Title", nil) icon:@"btn_refresh" badge:@"" vcName:@"doResetSocket:" isStoryBoard:NO isModal:NO isButton:YES  ParamDic:[NSDictionary dictionary]]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddUiAlertSocketLink", nil) icon:@"btn_linked" badge:@"" vcName:@"doConncetEnd:" isStoryBoard:NO isModal:NO isButton:YES  ParamDic:[NSDictionary dictionary]]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddUiAlertSocketDisLink", nil) icon:@"btn_dislinked" badge:@"" vcName:@"doDisConncetEnd:" isStoryBoard:NO isModal:NO isButton:YES  ParamDic:[NSDictionary dictionary]]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddMoudleSetting_Title_LocalFileManager", nil) icon:@"doc_zip.png" badge:@"" vcName:@"MddFileManangerViewController" isStoryBoard:NO   isModal:NO]];
    //test
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_Start_title", nil) icon:@"播放按钮-100X100.png" badge:@"" vcName:@"TestCollViewController" isStoryBoard:NO isModal:NO]];
    
    
    //
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddUiAlertSocketDisLink", nil) icon:@"btn_dislinked" badge:@"" vcName:@"doTestWebWeb:" isStoryBoard:NO isModal:NO isButton:YES  ParamDic:[NSDictionary dictionary]]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_printertable_title", nil) icon:@"打印台加热台logo-100X100.png" badge:@"" vcName:@"TestNewWebViewController" isStoryBoard:NO   isModal:NO]];
    
    //TestLoggerViewController
#ifdef DEBUG
// [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"调试日志" icon:@"轴控制器-100X100.png" badge:@"" vcName:@"TestLoggerViewController" isStoryBoard:NO isModal:NO]];
#else
    //不用
#endif
//     [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"wifi" icon:@"轴控制器-100X100.png" badge:@"" vcName:@"TestWifiViewController" isStoryBoard:NO isModal:NO]];
    
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_Start_title", nil) icon:@"开始的logo-100x100.png" badge:@"" vcName:@"ResourceMainNewViewController" isStoryBoard:NO isModal:NO]];
//        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"阿里支付" icon:@"startLogo" badge:@"" vcName:@"TestAliPayViewController" isStoryBoard:NO isModal:NO]];
    
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"piano" icon:@"开始的logo-100x100.png" badge:@"" vcName:@"doTestPiano" isStoryBoard:NO isModal:NO isButton:YES ParamDic:nil]];
    
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"TestSwift" icon:@"startLogo" badge:@"" vcName:@"SwiftTableViewController" isStoryBoard:NO isModal:NO isSwift:YES]];
    //[rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"Test" icon:@"startLogo" badge:@"" vcName:@"TestCircleViewController" isStoryBoard:NO isModal:NO]];
//     [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"二维码" icon:@"startLogo" badge:@"" vcName:@"TestQRCodeViewController" isStoryBoard:NO isModal:NO]];
    
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"服务端" icon:@"startLogo" badge:@"" vcName:@"TestHttpServerViewController" isStoryBoard:NO isModal:NO]];
    //    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"全局参数" icon:@"startLogo" badge:@"" vcName:@"TestGoableViewController" isStoryBoard:NO isModal:NO]];
    
    //
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"Test" icon:@"startLogo" badge:@"" vcName:@"TestTouchViewController" isStoryBoard:NO isModal:NO]];
//
//        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"OPENGL" icon:@"startLogo" badge:@"" vcName:@"TestOpenGLViewController" isStoryBoard:NO isModal:NO]];
////    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"Test" icon:@"startLogo" badge:@"" vcName:@"TestHeatMapViewController" isStoryBoard:NO isModal:NO]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"TestCode" icon:@"startLogo" badge:@"" vcName:@"TestQRCodeViewController" isStoryBoard:NO isModal:NO]];
//    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:@"9宫格解锁" icon:@"startLogo" badge:@"" vcName:@"TestNigitViewController" isStoryBoard:NO isModal:NO]];
//    TestQRCodeViewController
    
//        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMddPrintMain_printerhead_title", nil) icon:@"打印头-100x100.png" badge:@"" vcName:@"TestOpenGL2ViewController" isStoryBoard:NO  isModal:NO]];
    return rArray;
}

-(NSMutableArray *) getPrinterTouchArray
{
    NSMutableArray * rArray=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        PrinterTouchData * tData=[[PrinterTouchData alloc] initWithDataIndex:[NSString stringWithFormat:@"%d",i]  mSelectItemIndex:@"0" mTopBackground:@"" mTopPrinterBg:@"Printer-top" mCenterPrinterBg:@"Printer-media" mBottomPrinterBg:@"Printer-bottom" mBototmTouch1:@"Printer-touch" mBototmTouch2:@"Printer-touch" mBototmTouch3:@"Printer-touch" mBototmTouch4:@"Printer-touch"];
        [rArray addObject:tData];
    }
    return rArray;
}

//获取打印头的设备列表
-(NSMutableArray *) getPrinterGroupArray
{
    NSMutableArray * rArray=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSMutableArray * itemArray=[NSMutableArray array];
        for (int j=0; j<8; j++) {
            [itemArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",j],kSubDevicesId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_PrinterLine", nil),j+1],kSubDevicesName,@"192.168.1.1",kSubDevicesIp,@"18888",kSubDevicesPort,@"",kSubDevicesIcon,@"",kSubDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeLine],kSubDevicesType,@"0",kSubDevicesTemp,@"0",kSubDevicesTempReal, nil]];
        }
        for (int k=0; k<4; k++) {
            [itemArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",k],kSubDevicesId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_Printer_mouth", nil),k+1],kSubDevicesName,@"192.168.1.1",kSubDevicesIp,@"18888",kSubDevicesPort,@"",kSubDevicesIcon,@"",kSubDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeTouch],kSubDevicesType,@"0",kSubDevicesTemp,@"0",kSubDevicesTempReal, nil]];
        }
        //设置数组Id
        for (int w=0; w<itemArray.count; w++) {
            [[itemArray objectAtIndex:w] setObject:[NSString stringWithFormat:@"%d",w] forKey:kSubArrayId];
            [[itemArray objectAtIndex:w] setObject:[NSString stringWithFormat:@"%d",i] forKey:kFatherGroupId];
        }
        NSMutableDictionary * tDicBig=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],kGroupId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_Printer_Head", nil),[NSString stringWithFormat:@"%c",(char)((int)'A'+i)]],kGroupName,@"192.168.1.1",kDevicesIp,@"18888",kDevicesPort,@"18888",kDevicesIcon,@"",kDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeBig],kDevicesType,itemArray,kSubDevices, nil];
        [rArray addObject:tDicBig];
    }
    return rArray;
}
-(NSMutableArray *) getPrinterGroupArrayNew
{
    NSMutableArray * rArray=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSMutableArray * itemArray=[NSMutableArray array];
        for (int j=0; j<4; j++) {
            [itemArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",j],kSubDevicesId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_PrinterLine", nil),j+1],kSubDevicesName,@"192.168.1.1",kSubDevicesIp,@"18888",kSubDevicesPort,@"",kSubDevicesIcon,@"",kSubDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeLine],kSubDevicesType,@"0",kSubDevicesTemp,@"0",kSubDevicesTempReal, nil]];
        }
        for (int k=0; k<4; k++) {
            [itemArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",k],kSubDevicesId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_Printer_mouth", nil),k+1],kSubDevicesName,@"192.168.1.1",kSubDevicesIp,@"18888",kSubDevicesPort,@"",kSubDevicesIcon,@"",kSubDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeTouch],kSubDevicesType,@"0",kSubDevicesTemp,@"0",kSubDevicesTempReal, nil]];
        }
        //设置数组Id
        for (int w=0; w<itemArray.count; w++) {
            [[itemArray objectAtIndex:w] setObject:[NSString stringWithFormat:@"%d",w] forKey:kSubArrayId];
            [[itemArray objectAtIndex:w] setObject:[NSString stringWithFormat:@"%d",i] forKey:kFatherGroupId];
        }
        NSMutableDictionary * tDicBig=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],kGroupId,[NSString stringWithFormat:_LS_(@"kMddPrintMain_Printer_Head", nil),[NSString stringWithFormat:@"%c",(char)((int)'A'+i)]],kGroupName,@"192.168.1.1",kDevicesIp,@"18888",kDevicesPort,@"18888",kDevicesIcon,@"",kDevicesInfo,[NSString stringWithFormat:@"%lu",(unsigned long)MddPrinterTypeBig],kDevicesType,itemArray,kSubDevices,@"0",kDevicesAllSpeedF,[NSString stringWithFormat:@"EP%d",i+1],kDevicesSpeedEName,@"0",kDevicesSpeedE, nil];
        [rArray addObject:tDicBig];
    }
    return rArray;
}
-(NSMutableArray *) getAxisCalibrationList
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_X", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    //
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_X1", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_X2", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_X3", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_X4", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    
    //
    
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Y", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    
     [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Y1", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
     [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Y2", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Z", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    
//
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Zp1", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Zp2", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_C", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO  isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_W", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO   isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_A", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_B", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    //
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_F", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_E", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Ep1", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
        [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Ep2", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Ep3", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    [rArray addObject:[[MddDeskItem alloc]initMenuItemWithText:@"" info:_LS_(@"kMdd_str_AxisCalibration_Ep4", nil) icon:@"Icon-XYZ-Set" badge:@"" vcName:@"" isStoryBoard:NO isModal:NO]];
    return rArray;
}
-(NSMutableArray *) getPrinterAxisArray
{
    NSMutableArray * rArray=[NSMutableArray array];
    [rArray addObject:@"F"];
    [rArray addObject:@"EP1"];
    [rArray addObject:@"EP2"];
    [rArray addObject:@"EP3"];
    [rArray addObject:@"EP4"];
    return rArray;
}
+(NSMutableAttributedString *) getStringWithDic:(NSDictionary *) pDic
{
    //NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String，try your best to test attributed string text"];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(0, 5)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(6, 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:NSMakeRange(19, 6)];
    NSString * rStr=@"";
    NSMutableArray * tArray=[NSMutableArray array];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayProcess mValue:pDic[kGoalDisplayProcess]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayX mValue:pDic[kGoalDisplayX]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayY mValue:pDic[kGoalDisplayY]]];
    
//    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayZ mValue:pDic[kGoalDisplayZ]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayZp1 mValue:pDic[kGoalDisplayZp1]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayZp2 mValue:pDic[kGoalDisplayZp2]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayZT mValue:pDic[kGoalDisplayZT]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayC mValue:pDic[kGoalDisplayC]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayW mValue:pDic[kGoalDisplayW]]];
    

    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWork_X mValue:pDic[kGoalDisplayWork_X]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWork_Y mValue:pDic[kGoalDisplayWork_Y]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWorkZp1 mValue:pDic[kGoalDisplayWorkZp1]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWorkZp2 mValue:pDic[kGoalDisplayWorkZp2]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWorkZT mValue:pDic[kGoalDisplayWorkZT]]];
//    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWork_Z mValue:pDic[kGoalDisplayWork_Z]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWork_C mValue:pDic[kGoalDisplayWork_C]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayWork_W mValue:pDic[kGoalDisplayWork_W]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayE_ALL mValue:pDic[kGoalDisplayE_ALL]]];
    //E
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayEp1 mValue:pDic[kGoalDisplayEp1]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayEp2 mValue:pDic[kGoalDisplayEp2]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayEp3 mValue:pDic[kGoalDisplayEp3]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayEp4 mValue:pDic[kGoalDisplayEp4]]];
    
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayF mValue:[NSString stringWithFormat:@"%.3f",[pDic[kGoalDisplayF] doubleValue]]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayLineNumber mValue:pDic[kGoalDisplayLineNumber]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayPT mValue:pDic[kGoalDisplayPT]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR mValue:pDic[kGoalDisplayERROR]]];
    [tArray addObject:[self getAttrDicWithKey:_LS_(@"kMddUiStateConnect", nil) mValue:pDic[kGoalDisplayConncet]]];
    [tArray addObject:[self getAttrDicWithKey:_LS_(@"kMddUiStateFileConnect", nil) mValue:pDic[kGoalDisplayFileConncet]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayMoveG00 mValue:pDic[kGoalDisplayMoveG00]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_NUMBER mValue:pDic[kGoalDisplayERROR_NUMBER]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_alert_Value mValue:pDic[kGoalDisplayERROR_alert_Value]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_HOT_NUMBER mValue:pDic[kGoalDisplayERROR_HOT_NUMBER]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_HOT_OFFSET mValue:pDic[kGoalDisplayERROR_HOT_OFFSET]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_Head_NUMBER mValue:pDic[kGoalDisplayERROR_Head_NUMBER]]];
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayERROR_Head_OFFSET mValue:pDic[kGoalDisplayERROR_Head_OFFSET]]];
    //log
    [tArray addObject:[self getAttrDicWithKey:[NSString stringWithFormat:@"%@:struct:%lu,now:%lu",kGoalDisplayDataLog,(sizeof( struct ScenePackage))/4,(unsigned long)((NSMutableArray *)pDic[kGoalDisplaySceenArray]).count] mValue:pDic[kGoalDisplayDataLog]]];
    //控制台日志输出
    [tArray addObject:[self getAttrDicWithKey:kGoalDisplayConsleLog mValue:pDic[kGoalDisplayConsleLog]]];
    
    
    
    for (int i=0; i<tArray.count; i++) {
        NSDictionary  * tStrDic=[tArray objectAtIndex:i];
        rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",tStrDic[kTitleLabelKey],tStrDic[kValueLabelKey]]];
    }
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc] initWithString:rStr];
    int textIndex=0;
    for (int i=0; i<tArray.count; i++) {
        NSDictionary  * tStrDic=[tArray objectAtIndex:i];
        int startIndex1=textIndex;
        int startIndex2=textIndex+kSplitLength+[tStrDic[kTitleLabelKey] length];
        int EndIndex1=textIndex+kSplitLength+[tStrDic[kTitleLabelKey] length];
        int EndIndex2=textIndex+[tStrDic[kTitleLabelKey] length]+kSplitLength+[tStrDic[kValueLabelKey] length];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kTitleLabelColor range:NSMakeRange(startIndex1,[tStrDic[kTitleLabelKey] length])];
        [attrStr addAttribute:NSFontAttributeName value:kTitleLabelFont range:NSMakeRange(startIndex1,[tStrDic[kTitleLabelKey] length])];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kValueLabelColor range:NSMakeRange(EndIndex1,[tStrDic[kValueLabelKey] length])];
        [attrStr addAttribute:NSFontAttributeName value:kValueLabelFont range:NSMakeRange(EndIndex1,[tStrDic[kValueLabelKey] length])];
        textIndex+=[tStrDic[kValueLabelKey] length]+kSplitLength+[tStrDic[kTitleLabelKey] length]+kSplitLineLength;
    }
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayProcess,pDic[kGoalDisplayProcess]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayX,pDic[kGoalDisplayX]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayY,pDic[kGoalDisplayY]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayZ,pDic[kGoalDisplayZ]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayZp1,pDic[kGoalDisplayZp1]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayZp2,pDic[kGoalDisplayZp2]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayZT,pDic[kGoalDisplayZT]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWorkZp1,pDic[kGoalDisplayWorkZp1]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWorkZp2,pDic[kGoalDisplayWorkZp2]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWorkZT,pDic[kGoalDisplayWorkZT]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayC,pDic[kGoalDisplayC]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayW,pDic[kGoalDisplayW]]];
//    //
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWork_X,pDic[kGoalDisplayWork_X]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWork_Y,pDic[kGoalDisplayWork_Y]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWork_Z,pDic[kGoalDisplayWork_Z]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWork_C,pDic[kGoalDisplayWork_C]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayWork_W,pDic[kGoalDisplayWork_W]]];
//    //
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayE_ALL,pDic[kGoalDisplayE_ALL]]];
//    //
////    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayEp1,pDic[kGoalDisplayEp1]]];
////    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayEp2,pDic[kGoalDisplayEp2]]];
////    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayEp3,pDic[kGoalDisplayEp3]]];
////    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayEp4,pDic[kGoalDisplayEp4]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayF,pDic[kGoalDisplayF]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayLineNumber,pDic[kGoalDisplayLineNumber]]];
//        rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayPT,pDic[kGoalDisplayPT]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",kGoalDisplayERROR,pDic[kGoalDisplayERROR]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",_LS_(@"kMddUiStateConnect", nil),pDic[kGoalDisplayConncet]]];
//    rStr=[rStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n",_LS_(@"kMddUiStateFileConnect", nil),pDic[kGoalDisplayFileConncet]]];
    //调试日志


    return attrStr;
    
}
+(NSDictionary *) getAttrDicWithKey:(NSString *) pKey mValue:(NSString *) pValue
{
    NSMutableDictionary * rDic=[NSMutableDictionary dictionary];
    [rDic setValue:pKey forKey:kTitleLabelKey];
    [rDic setValue:pValue forKey:kValueLabelKey];
    return rDic;
}
+(instancetype) shareNewInstance
{
    return [[self class] new];
}
@end
