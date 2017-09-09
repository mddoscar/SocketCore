//
//  ServerForHttp.h
//  Printer3D
//
//  Created by mac on 2017/1/18.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpParamHeader.h"
#import "PostKeyValue.h"
@class PostKeyValue;
/*
 访问服务端
 */
@interface ServerForHttp : NSObject
//服务根目录
+(NSString *) BaseServerURL;
+(NSString *) BaseServerDownLoadURL:(NSString *)pRelactionDownLoadURL;
+(NSString *) BaseServerDownLoadServerURL:(NSString *)pRId singkey:(NSString *)pSignkey;
+(NSString *) BaseImageServerURL;
-(NSString *) BaseServerURL;
//获取资源库网址
+(NSString *) GetResMainURL;
-(NSString *) GetResMainURL;
//获取子地址
+(NSString *) BaseServerURLSubURL:(NSString*) pSubURL;
//获取地址简介图片
+(NSString *) BaseBannerImageServerURL:(NSString *) pIndex;
//支付地址
+(NSString *) BasePayQRcodeImageServerURL:(NSString *) pType;
+(NSString *) URLWithTimeS:(NSString *) pURL;
//获取参数字符串
+(NSString *) GetBodyStrWithArray:(NSArray *)pPostKeyValueArr;
#pragma mark common
//post 请求
-(void) PostWithURL:(NSString *)pURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
//get 请求
-(void) GetWithURL:(NSString *)pURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;

//post 请求
-(void) PostWithSubURL:(NSString *)pSubURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
//get 请求
-(void) GetWithSubURL:(NSString *)pSubURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
-(NSString *) getURLStr:(NSString *) pStr;
+(NSString *) getURLConverStr:(NSString *) pStr;
//获取banner的数据
+(NSString *) getActivityURLWithDic:(NSDictionary *) pDic;
//获取参数数据
//-(NSMutableArray *)ConvertParamArratWithPostKeyValues:(PostKeyValue *)vString,... ;
#pragma mark 用户接口
/*
 注册
 Uri	方法	描述
 /Eroll/{tel}/{pWd}/{puWd}	POST	http://www.wonwin-im.com/Printer3d/Eroll/{TEL}/{PWD}/{PUWD} 处的服务
 */
-(void) ErollPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ErollCheck/{tel}	POST	http://www.wonwin-im.com/Printer3d/ErollCheck/{TEL} 处的服务
 */
-(void) ErollCheckPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ErollSMSGetCode/{tel}	POST	http://www.wonwin-im.com/Printer3d/ErollSMSGetCode/{TEL} 处的服务
 */
-(void) ErollSMSGetCodePostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /FindPwd/{tel}/{pwd}/{code}	POST	http://www.wonwin-im.com/Printer3d/FindPwd/{TEL}/{PWD}/{CODE} 处的服务
 */
-(void) FindPwdPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /GetResById/{rid}	POST	http://www.wonwin-im.com/Printer3d/GetResById/{RID} 处的服务
 */
-(void) GetResByIdPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /Login/{name}/{pWd}	POST	http://www.wonwin-im.com/Printer3d/Login/{NAME}/{PWD} 处的服务
 */
-(void) LoginPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
#define mark 查询接口
/*
 /ResAllList	GET	http://www.wonwin-im.com/Printer3d/ResAllList 处的服务
 */
-(void) ResAllListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
/ResChildAll/{tyid}	POST	http://www.wonwin-im.com/Printer3d/ResChildAll/{TYID} 处的服务
 */
-(void) ResChildAllPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ResDel/{signkey}/{rid}	POST	http://www.wonwin-im.com/Printer3d/ResDel/{SIGNKEY}/{RID} 处的服务
 */
-(void) ResDelPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ResDownLoad/{signkey}/{rid}	POST	http://www.wonwin-im.com/Printer3d/ResDownLoad/{SIGNKEY}/{RID} 处的服务
 */
-(void) ResDownLoadPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;

/*
 /UpdateUmark/{signkey}/{rid}	POST	http://www.wonwin-im.com/Printer3d/UpdateUmark/{SIGNKEY}/{RID} 处的服务
 */
-(void) UpdateUmarkPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ResSearchList/{tyid}/{key}/{siginKey}	POST	http://www.wonwin-im.com/Printer3d/ResSearchList/{TYID}/{KEY}/{SIGINKEY}  处的服务
*/
-(void) ResSearchListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /ResSearchListTest	POST	http://www.wonwin-im.com/Printer3d/ResSearchListTest 处的服务
*/
-(void) ResSearchListTestPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
/ResultModelChildList/{tyid}/{cid}	POST	http://www.wonwin-im.com/Printer3d/ResultModelChildList/{TYID}/{CID} 处的服务
 */
-(void) ResultModelChildListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /UpdateUser/{signkey}/{name}/{email}／{tel} 	POST	http://www.wonwin-im.com/Printer3d/UpdateUser/{SIGNKEY}/{NAME}/{TEL}/{EMAIL} 处的服务
 */
-(void) UpdateUserPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 
  /GetUserInfo/{signkey}	POST	http://www.wonwin-im.com/Printer3d/GetUserInfo/{SIGNKEY}处的服务
 */
-(void) GetUserInfoPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;

/*
 /MenoyAdd/{signkey}/{u_name}/{u_mark}/{u_Info}/{u_module}/{type}	POST	http://www.wonwin-im.com/Printer3d/MenoyAdd/{SIGNKEY}/{U_NAME}/{U_MARK}/{U_INFO}/{U_MODULE}/{TYPE} 处的服务
 */
-(void) MenoyAddPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /GetOrderStatus/{signkey}/{oid}	POST	http://www.wonwin-im.com/Printer3d/GetOrderStatus/{SIGNKEY}/{OID} 处的服务
 */
-(void) GetOrderStatusPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;

/*
 /GetBannerArray	POST	http://www.wonwin-im.com/Printer3d/GetBannerArray 处的服务
 */
-(void) GetBannerArrayPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /CallBackMoneyApp/{uid}/{siginKey}/{time}/{orderid}	POST	http://www.wonwin-im.com/Printer3d/CallBackMoneyApp/{UID}/{SIGINKEY}/{TIME}/{ORDERID} 处的服务
 */
-(void) CallBackMoneyAppPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
/*
 /CreateAppMoneyPay/{uid}/{siginKey}/{mark}/{price}/{title}/{mondle}/{body}/{type}/{amount}	POST	http://www.wonwin-im.com/Printer3d/CreateAppMoneyPay/{UID}/{SIGINKEY}/{MARK}/{PRICE}/{TITLE}/{MONDLE}/{BODY}/{TYPE}/{AMOUNT} 处的服务
 */
-(void) CreateAppMoneyPayPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
//错误码服务
+(NSString *) GetErrorCodeString:(int) pStateCode;
//全局单例
+(instancetype) GetInstance;

@end
