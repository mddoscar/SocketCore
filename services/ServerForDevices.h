//
//  ServerForDevices.h
//  Printer3D
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>



//#ifndef ServerForDevicesHeader_h
//#define ServerForDevicesHeader_h
//
//#endif /* ServerForDevicesHeader_h */
#import "CommonMsgHeader.h"
//#import "ShareData.h"
#import "ShareDataHeader.h"
//一包长度
#define kOnePackgeHeadLength 4
#define kOnePackgeTypeLength 1
#define kOnePackgeDataLength (512*1024)

#define kOnePackgeLength (kOnePackgeDataLength+kOnePackgeHeadLength+kOnePackgeTypeLength)
//时间戳
#define kFileCmdTimeStr @"FileCmdTimeStr" //时间戳
#define kFileCmdName @"FileCmdName" //文件名
#define kFileCmdLength @"FileCmdLength" //长度
#define kFileCmdLengthIndex @"FileCmdLengthIndex" //进度值
#define kFileCmdRaw @"FileCmdRaw" //原始字符
/*
 数据报工具服务
 */
@interface ServerForDevices : NSObject
#pragma mark 组包方法
//获取包头
+(NSString *) getSendPackHeader:(NSUInteger) pLength TypeCode:(int)pType;
//获取通用的命令字符串
+(NSString *) getCommonStrTypeCode:(NSString*)pType cmdStr:(NSString *) pStr;
+(NSString *) getCommonStrNewTypeCode:(NSString*)pType cmdStr:(NSString *) pStr;
//命令字符串数组
+(NSString *) getCommonStrArrTypeCode:(NSString*)pType cmdStrArr:(NSMutableArray *) pStrArr;
//获取命令字符串
+(NSString *) getCommonStrArrTypeCode:(NSString*)pType cmdAsciiStrArr:(NSMutableArray *) pStrArr;
//获取命令的比特nsdata
+(NSData *) getCommonDataArrTypeCode:(NSString*)pType cmdDataArr:(NSMutableArray *) pDataArr;
//丢包处理
//获取比特
+(NSString *)intToBinary:(int)intValue;
//获取数据包
+(NSData *)getDataPackFromStr:(NSString *)pDataStr;
//获取数据包分包结构
+(NSMutableArray *)getDataPackFromData:(NSData * )pData blockLength:(long) pBlockLength;
#pragma mark 拆包方法
+(NSMutableArray *) decodeArrayNewWithData:(NSMutableData *)pData;
//获取现场包的结构体
+(struct ScenePackage) decodeArrayNewWithDataArray:(NSMutableArray *)pDataArray;
//结构体转换回原始数组
+(NSMutableArray *) encodeArrayNewWithDataStruct:(struct ScenePackage)pStruct;

-(struct ScenePackage)decodeWithArray:(NSMutableArray *)pDataArray decodePackage:(struct ScenePackage )decodePackage;
//解析一个完整包>type,data
+(NSMutableArray *) decodeArrayWithData:(NSMutableData *)pData;
+(NSMutableArray *) decodeArrayOldWithData:(NSMutableData *)pData;
//单独解析现场包
+(NSMutableArray *) decodeArrayNowPackageWithData:(NSMutableData *)pData;
+(struct ScenePackage) DeCodeScenePackageWithData:(NSData *) pData;
//字符解析成16进制
+(NSMutableString *) decodeHexMuStrWithData:(NSMutableData *)pData;
//16进制转10进制
+(NSString *)convertHexStrToString:(NSString *)str;
+(NSString *) decodeASCIIStrWithData:(NSMutableData *)pData;
//转ascii
+(NSString *) getASCIIString:(NSString *)pStr;
//是否接收到换行符号
+(BOOL) isLineWithData:(NSData *)pData;
//获取换行符号的位置
+(long long) indexofLineWithData:(NSData *)pData;
//拆包(边写边替换)
+(NSMutableData *) decodeSubGCodeWithData:(NSMutableData *)pData;
+(NSMutableData *) decodeSubGCodeWithStr:(NSString *)pDataStr;
//转码装包
+(NSMutableData *) encodeSubGCodeWithData:(NSData *)pData;
+(NSMutableData *) encodeSubGCodeWithStr:(NSString *)pDataStr;
//拆包字符串
+(NSString *) encodeSubGCodeStrWithData:(NSData *)pData;
//新增方法
+(NSData *) encodeSubGCodeDataWithData:(NSData *)pData;
+(NSString *) encodeSubGCodeStrWithStr:(NSString *)pDataStr;
#pragma mark 文件相关
+(NSString *) getDownloadRoot;
+(NSString *) getGcodeRoot;
+(NSString *) getGcodeFileName:(NSString *) pSubFileName;
+(NSString *) getGcodeUserPath:(NSString *) pUserId;
+(NSString *) getDownloadUserPath:(NSString *) pUserId;
//doc/gcodes/userid/filename
+(NSString *) getGcodeFileName:(NSString *) pSubFileName mUserId:(NSString *) pUserId;
//doc/Download/userid/filename
+(NSString *) getDownloadRootFileName:(NSString *) pSubFileName mUserId:(NSString *) pUserId;
+(NSMutableArray *)indexWithData:(NSData *)pData;

+(NSMutableArray *) dataArrayWithData:(NSData *)data WithString:(NSString *)string;
//解析新的文件包
+(NSMutableArray *) decodeFileArrayWithData:(NSMutableData *)pData;
//获取数据包
+(NSData *) getFileDataWithFileData:(NSData *)pData;

//获取文件名包
+(NSData *) getFileNameDataWithFileShortName:(NSString *)pShortName timestr:(NSString *)pTimestr FileLength:(NSInteger)pFileLength;
//文件接收进度
+(NSData *) getFileNameDataWithFileShortName:(NSString *)pShortName timestr:(NSString *)pTimestr FileLength:(NSInteger)pFileLength index:(long) pIndex;
+(NSMutableData *) initDataWithLength:(NSInteger) pLength;
//反解析
+(long) bytesToInt:(Byte[]) ary offset:(int) pOffset;
//获取简介time_filename.zip@size@
+(NSDictionary *) getFileDicWithInfoStr:(NSString *) pInfoStr;
#pragma mark 全局缓存
//进行全局缓存
+(void) DoGoableCacheWithCommand:(NSString *) tCmd WithArray:(NSArray *) pDataArray;
+(NSString *) GetGoableCacheJson;
@end
