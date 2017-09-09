//
//  CommonMsgHeader.h
//  Printer3D
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#ifndef CommonMsgHeader_h
#define CommonMsgHeader_h
    //命令
//全局配置
//命令集合
/*
 心跳包（包总长7字节，由发送端主动发送）
 数据总长：2（字段长度4字节）	包类型：0（字段长度1字节）	心跳值（字段长度2个字节）
 心跳值:
 0-65535	本次心跳值是上次心跳值+1，累加到65535下一次从零开始
 */
#define kCmdType_Beat_req @"0" //0x0 //心跳包
/*
 心跳确认包（包总长7字节，由接受端发送）
 数据总长：2（字段长度4字节）	包类型：1（字段长度1字节）	心跳值（字段长度2个字节）
 心跳值:
 0-65535	本次确认包心跳值是收到的心跳包的心跳值
 */
#define kCmdType_Beat_resp @"1" //0x1 //心跳包回复
/*
 命令包（包总长6字节，可以移动端发送给控制板，也可以由控制板发送到移动端）
 数据总长：1（字段长度4字节）	包类型：2（字段长度1字节）	控制命令字（字段长度1个字节）
 控制命令字:
 1	打印开始命令
 2	打印暂停命令
 3	打印急停命令
 */
#define kCmdType_Cmd_req @"2" //0x2 //命令包发起
#define kCmdType_Cmd_req_str_start @"1" //开始
#define kCmdType_Cmd_req_str_puase @"2" //暂停
#define kCmdType_Cmd_req_str_stop @"3" //急停
/*
 命令确认包（包总长6字节）
 数据总长：1（字段长度4字节）	包类型：3（字段长度1字节）	确认的命令（字段长度1个字节）
 控制命令字:
 1	打印开始的确认
 2	打印暂停的确认
 3	打印急停的确认
 */
#define kCmdType_Cmd_resp @"3" //0x3 //命令包回复
#define kCmdType_Cmd_resp_str_start @"1" //开始
#define kCmdType_Cmd_resp_str_puase @"2" //暂停
#define kCmdType_Cmd_resp_str_stop @"3" //急停
/*
 G代码包（包总长最大524295字节 5+512K+2，最小7字节，代码在移动端由移动端发送给控制板，如果代码在控制板由控制板发送到移动端）
 数据总长：若干（字段长度4字节）代码数据字节+2字节包序号	包类型：4（字段1字节）	代码数据字节（0-524288个字节）	包序号(2个字节)
 代码数据字节:
 代码数据字节存放需发送的代码数据，如果剩下的代码还有1-524287个字节未发送，发送剩余的代码并接收到此包的确认包结束发送。如果剩下的代码刚好还有524288个字节未发送，发送剩余的代码并受到此包确认包后，再发送一个没有代码数据字段的代码包并接收到此包的确认包结束发送。
 包序号:
 当前包的序号0-65535。发送第一个512K，当前序号为0，下一个512K包序号为1，依次类推
 */
#define kCmdType_GCode_req @"4" //GCode包
/*
 G代码确认包（包总长7字节）
 数据总长：2（字段长度4字节）	包类型：5（字段长度1字节）	确认的包序号(2个字节)
 确认包序号：
 内容填写为收到的G代码包中的包序号内容
 */
#define kCmdType_GCode_resp @"5" //GCode包回复
/*
 文件名包（代码在移动端由移动端发送给控制板，如果代码在控制板由控制板发送到移动端）
 数据总长：若干（字段长度4字节）	包类型：6（字段长度1字节）	文件名若干字节
 文件名若干字节:
 文件的名称包括后缀名
 */
#define kCmdType_File_req @"6" //文件包
/*
 会话ID包（板由控制板发送到移动端）
 数据总长：4（字段长度4字节）	包类型：7（字段长度1字节）	ID值（当前时间离1970年的秒数，4字节）
 ID值（4字节）:
 距离1970年的秒数值
 
 */
#define kCmdType_Session_req @"7" //会话包
/*
 会话ID确认包
 包类型字符串：“8”	ID值字符串（当前时间离1970年的秒数，4字节）	结束符(\n)
 ID值字符串:
 为收到的会话ID包内的ID值字符串
 */
#define kCmdType_Session_resp @"8" //会话包
/*
 现场包（始终由控制板发送给移动端）
 包类型字符串：“9”	会话ID字段	当前轴坐标字段	行号字段	速率设置字段	温度设置字段	命令字段	结束符(\n)
 包数据长度为ID字段、轴坐标字段、行号字段、速率设置字段、命令字段和温度数值字段的字节总和
 会话ID字段（4个字节）：表示本次打印的唯一ID值，防止移动端掉线一段时间后重新连接后，实际上控制板已经开始了其他打印
 当前轴坐标字段（20个字节）：移动端掉线重连后告诉移动端当前轴的当前位置
 行号字段（4个字节）：移动端掉线重连后告诉移动端现在正在打印哪一行代码
 速率设置字段（12个字节）：移动端掉线重连后告诉移动端当前设置的速率值
 温度设置字段（128个字节）: 移动端掉线重连后告诉移动端当前设置的各个点温度
 命令字段（1个字节）：移动端掉线重连后告诉移动端当前设备是否处理开始、暂停或者急停状态

 */
#define kCmdType_now_req @"9" //现场
/*
 现场确认包（包总长5字节，由移动端发送到控制板）
 数据总长：0（字段长度4字节）	包类型：9（字段长度1字节）
 
 */
#define kCmdType_now_resp @"10" //现场回复
/*
 现场请求包（包总长5字节，由移动端发送到控制板请求现场数据）
 数据总长：0（字段长度4字节）	包类型：10（字段长度1字节）
 */
#define kCmdType_now_req_resp @"11" //现场请求包
/*
 轴位置包（始终由控制板发送给移动端）
 包类型字符串：“12”	X轴坐标值字符串	Y轴坐标值字符串	Z轴坐标值字符串	C轴坐标值字符串	W轴坐标值字符串	结束符(\n)
 红色字段为5个轴的坐标数据:
 X轴坐标
 Y轴坐标
 Z轴坐标
 C轴坐标
 W轴坐标
 
 
 */
#define kCmdType_axis_req_resp @"12" //轴位置包
/*
 轴位置设置包
 包类型字符串：“13”	设置X轴坐标值字符串	设置Y轴坐标值字符串	设置Z轴坐标值字符串	设置C轴坐标值字符串	设置W轴坐标值字符串	结束符(\n)
 红色字段为5个轴的坐标数据，每个轴坐标4个字节:
 X轴坐标
 Y轴坐标
 Z轴坐标
 C轴坐标
 W轴坐标
 行号包（始终由控制板发送给移动端）

 */
#define kCmdType_axisset_req @"13" //轴位置设置
/*
 行号包（始终由控制板发送给移动端）
 包类型字符串：“14”	代码行号字符串	结束符(\n)
 
 */
#define kCmdType_linenumber_req_resp @"14" //行号
/*
 速率包（始终由控制板发送给移动端）
 包类型字符串：“15”	速率类型字符串	速率序号	速率值	结束符(\n)
 速率类型字符串：
	“0”   	进给速率
	“1”	挤料速率
 
 */
#define kCmdType_speed_resp @"15" //速率包
/*
 设置速率包
 包类型字符串：“16”	速率类型字符串	速率序号	设置速率值	结束符(\n)
 速率类型字符串：
	“0”   	进给速率
	“1”	挤料速率
 “2”    轴清零
	“3”    单轴点动
 速率序号：
	类型为“0”时，速率序号只能为“1”，速率值代表设置进给的速率倍率值
 
	类型为“1”时，速率序号只能为“1”-“4”，速率值代表设置的挤料倍率值
 
	类型为“2”时， 速率序号代表要清零的轴的序号，这个时候速率值忽略
 “1” 为X，“2”为Y，“3”为Z，“4”为C，“5”为W “99”为全轴清零。
 
 类型为“3”时
 速率序号代表要控制哪个轴点动（“1”为X轴、“2”为Y轴、“3”为Z轴、“4”为C轴、“5”为W轴）
 设置速率值代表点动的倍率，“1”为0.01mm,“2”为0.1mm，“3”为1.0mm
 方向为“0”为正方向，“1”为负方向

 

 */
#define kCmdType_speedset_req @"16" //速率设置包
#define kCmdType_speedset_commonTpye_in @"0" //进给速率
#define kCmdType_speedset_commonTpye_out @"1" //挤料速率
#define kCmdType_speedset_commonTpye_axis_zero @"2" //轴清0
#define kCmdType_speedset_commonTpye_axis_click @"3" //轴点动

#define kCmdType_speedset_clear @"2" //清零
#define kCmdType_speedset_commonTpye_F_Index @"1" //F速率
#define kCmdType_speedset_commonTpye_E_Index_Offset 0 //E坐标开始
/*
 温度包（始终由控制板发送给移动端）
 包类型字符串：“17”	温度类型字符串	序号字符串	偏移字符串	温度值	结束符(\n)
 温度类型：“0”   加热板温度     “1” 打印头温度
 序号：
	字符串值代表具体哪一个温度板或者打印头
 偏移字符串：
	字符串值代表具体某个打印头或者温度板内部的某个加热丝
 温度值：
 发热丝温度值字符串
 
 */
#define kCmdType_temp_req_resp @"17" //温度包
#define kCmdType_temp_commonType_broad @"0" //加热板温度
#define kCmdType_temp_commonType_printer @"1" //打印头温度
/*
 温度设置包
 包类型字符串：“18”	温度类型字符串	序号字符串	偏移字符串	设置的温度值	结束符(\n)
 温度类型：“0”   加热板温度     “1” 打印头温度
 序号（从编号“1”开始）：
	字符串值代表具体哪一个温度板或者打印头
 偏移字符串（从编号“1”开始）：
	字符串值代表具体某个打印头或者温度板内部的某个加热丝
 设置的温度值：
 设置的发热丝温度值字符串
 
 */
#define kCmdType_tempset_req @"18" //温度设置

/*
 故障包（始终由控制板发送给移动端）
 包类型字符串：“19”	伺服序号	伺服报警值	热床序号	热床内偏移	打印头序号	打印头内偏移	结束符(\n)
 红色字段为报警故障码和报警序号
 所有的序号从编号1开始，如果编号为0代表对应没有报警
 
 */

#define kCmdType_error_resp @"19" //故障包
/*
 打印头序号设置包（待定）
 包类型字符串：“20”							结束符(\n)
 红色字段为报警故障码和报警序号

 */
#define kCmdType_printerset_req @"20" //打印头序号设置包
/*
IO开关控制包设置包
包类型字符串：“21”	IO开关编号	IO开关控制值	结束符(\n)
 */
#define kCmdType_door_req @"21" //开关
#define kCmdType_door_CommonType_index_Font @"1" //前门索引
#define kCmdType_door_CommonType_index_Back @"2" //后面索引

//打印嘴的索引号
#define kCmdType_mouth_CommonType_index_OffSet 100 //打印嘴索引起点
#define kCmdType_mouth_CommonType_index_1 @"101" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_2 @"102" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_3 @"103" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_4 @"104" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_5 @"105" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_6 @"106" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_7 @"107" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_8 @"107" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_9 @"109" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_10 @"110" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_11 @"111" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_12 @"112" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_13 @"113" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_14 @"114" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_15 @"115" //打印嘴索引
//#define kCmdType_mouth_CommonType_index_16 @"116" //打印嘴索引


#define kCmdType_mouth_CommonType_Cmd_Up @"0" //上
#define kCmdType_mouth_CommonType_Cmd_Down @"1" //下
//打印嘴出料
#define kCmdType_mouth_Oil_CommonType_index_OffSet 116 //打印嘴索引起点
#define kCmdType_mouth_Oil_CommonType_index_1 @"117" //打印嘴出料
//#define kCmdType_mouth_Oil_CommonType_index_2 @"118" //打印嘴出料
//#define kCmdType_mouth_Oil_CommonType_index_3 @"119" //打印嘴出料
//#define kCmdType_mouth_Oil_CommonType_index_4 @"120" //打印嘴出料
//#define kCmdType_mouth_Oil_CommonType_index_5 @"121" //打印嘴出料
//#define kCmdType_mouth_Oil_CommonType_index_6 @"122" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_7 @"123" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_8 @"124" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_9 @"125" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_10 @"126" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_11 @"127" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_12 @"128" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_13 @"129" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_14 @"130" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_15 @"131" //打印嘴索引
//#define kCmdType_mouth_Oil_CommonType_index_16 @"132" //打印嘴索引

#define kCmdType_mouth_CommonType_Cmd_Out @"0" //出料
#define kCmdType_mouth_CommonType_Cmd_Stop @"1" //停止出料


//
#define kCmdType_door_CommonType_Cmd_Stop @"0" //静止
#define kCmdType_door_CommonType_Cmd_Run @"1" //旋转
#define kCmdType_door_CommonType_Dir_Down @"0" //放下
#define kCmdType_door_CommonType_Dir_Up @"1" //合上
#define kCmdType_door_CommonType_Dir_NONE @"-1" //放下
#define kCmdType_door_CommonType_Status_Def @"0" //默认状态

#define kCmdType_font_door_CommonType_Close  @"1" // @"0" //关
#define kCmdType_font_door_CommonType_Open  @"0" // @"1" //开
/*
 IO开关控制包设置包
 包类型字符串：“22”	IO开关编号	IO开关值	结束符(\n)
 */
#define kCmdType_door_resp @"22" //回答

#define kCmdType_back_door_CommonType_Close @"0" //后门关
#define kCmdType_back_door_CommonType_Open @"1" //后门开
#define kCmdType_back_door_CommonType_Opening_1 @"2" //后门关
#define kCmdType_back_door_CommonType_Opening_2 @"3" //后门关
#define kCmdType_back_door_CommonType_Opening_3 @"4" //后门关
#define kCmdType_back_door_CommonType_Opening_4 @"5" //后门关
//空包
#define kCmdType_Empty_req @"100"
//空包刷新界面
#define kCmdType_Empty_UI_req @"101"
/*
 
 文件
 4+1+(512*1024)
 */
#define kCmdType_File_FileName_req @"1" //文件名
#define kCmdType_File_Data_req @"0" //数据
#define kCmdType_File_Index_req @"3" //qt接到数据返回3
#define kCmdType_File_Index_resp_Char '2' //app接到数据返回2
#define kCmdType_File_FileName_req_Char '1' //文件名
#define kCmdType_File_Data_req_Char '0' //数据
//添加命令
/*
 设置机械原点包
 包类型字符串：“23”	X	Y	Z	C	W	结束符(\n)
 设置机械原点的坐标
 */
#define kCmdType_Mechanical_origin_resp @"23" //回答

//引用底层代码
//#import "ShareData.h"
#import "ShareDataHeader.h"
//现场包ScenePackage
#define kScenePackage_Scene @"Scene" //现场
#define kScenePackage_PrtStatus @"PrtStatus" //现场状态
#define kScenePackage_PrtCmd @"PrtCmd" //命令
#define kScenePackage_PrtPara @"PrtPara" //参数
//现场包长度
//#define kStructLength 429 //结构体字段
//#define kStructLength 436 //结构体字段

#endif /* CommonMsgHeader_h */
