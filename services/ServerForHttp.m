//
//  ServerForHttp.m
//  Printer3D
//
//  Created by mac on 2017/1/18.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "ServerForHttp.h"
#import "PostKeyValue.h"
#import "DbDateHelper.h"
#define kPrinter3dModule @"Printer3D"
#define kImageDir @"app"

#import "HttpHelper.h"
//饮用服务
#import "ConfigService.h"
//JSonKit
#import "JSONKit.h"
#import "DbDateHelper.h"
//网站服务
@implementation ServerForHttp
//ServerHostAddr
+(NSString *) BaseServerURL
{

    //服务器主机
    return  [[[self class] alloc] BaseServerURL];
}
+(NSString *) BaseServerDownLoadURL:(NSString *)pRelactionDownLoadURL
{
     return  [NSString stringWithFormat:@"%@/%@",[ConfigService valueForName:@"ServerHostAddr"],pRelactionDownLoadURL];
}
+(NSString *) BaseServerDownLoadServerURL:(NSString *)pRId singkey:(NSString *)pSignkey
{
    return  [NSString stringWithFormat:@"%@/app/DownLoadRes.ashx?rid=%@&singkey=%@",[ConfigService valueForName:@"ServerHostAddr"],pRId,pSignkey];
}

+(NSString *) BaseImageServerURL
{
     return  [NSString stringWithFormat:@"%@/%@",[ConfigService valueForName:@"ServerHostAddr"],kImageDir];
}
-(NSString *) BaseServerURL
{
    return  [NSString stringWithFormat:@"%@/%@",[ConfigService valueForName:@"ServerHostAddr"],kPrinter3dModule];
}
+(NSString *) BaseServerURLSubURL:(NSString*) pSubURL
{
    return  [NSString stringWithFormat:@"%@%@",[ConfigService valueForName:@"ServerHostAddr"],pSubURL];
}

+(NSString *) GetResMainURL
{
    return [[[self class] alloc] GetResMainURL];
}
-(NSString *) GetResMainURL
{
// return  [NSString stringWithFormat:@"%@%@",[ConfigService valueForName:@"ServerHostAddr"],@"/ResMain.html"];
    return  [NSString stringWithFormat:@"%@?%@=%@",[ConfigService valueForName:@"ResMainURL"],@"Time",[DbDateHelper get1970Timestr]];
}

+(NSString *) BaseBannerImageServerURL:(NSString *) pIndex
{
    return  [NSString stringWithFormat:@"%@/%@?%@=%@",[ConfigService valueForName:@"ServerHostAddr"],kSubBannerURL,kSubBannerIndex,pIndex];
}
+(NSString *) BasePayQRcodeImageServerURL:(NSString *) pType
{
    return  [NSString stringWithFormat:@"%@/%@?%@=%@",[ConfigService valueForName:@"ServerHostAddr"],kSubPayQRCodeURL,kSubPayQRCodePayType,pType];
}


+(NSString *) URLWithTimeS:(NSString *) pURL
{
    return  [NSString stringWithFormat:@"%@&%@=%@",pURL,kSubImgTime,[DbDateHelper get1970Timestr]];
}
+(NSString *) GetBodyStrWithArray:(NSArray *)pPostKeyValueArr
{
    NSString * rStr=@"";
    
   __block NSMutableDictionary * tParamDic=[NSMutableDictionary dictionaryWithCapacity:pPostKeyValueArr.count];
    for (PostKeyValue * tDic in pPostKeyValueArr) {
//        tParamDic[tDic.mKey]=tParamDic[tDic.mValue];
        [tParamDic setObject:tDic.mValue forKey:tDic.mKey];
    }
    rStr= [tParamDic JSONString];
    return rStr;
}
-(NSString *) getURLStr:(NSString *) pStr
{
    if (nil!=pStr) {
         return [pStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}
+(NSString *) getURLStr:(NSString *) pStr
{
    if (nil!=pStr) {
        return [pStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}
+(NSString *) getURLConverStr:(NSString *) pStr
{
    if (nil!=pStr) {
        /*
         +    URL 中+号表示空格                                 %2B
         空格 URL中的空格可以用+号或者编码           %20
         /   分隔目录和子目录                                     %2F
         ?    分隔实际的URL和参数                             %3F
         %    指定特殊字符                                          %25
         #    表示书签                                                  %23
         &    URL 中指定的参数间的分隔符                  %26
         =    URL 中指定参数的值                                %3D
         */
        pStr=[pStr stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        pStr=[pStr stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        return pStr;
    }else{
        return @"";
    }
}

+(NSString *) getActivityURLWithDic:(NSDictionary *) pDic
{
    NSString *  rStr=@"";
    NSString * tParam=@"";
    if (![@""isEqualToString:pDic[kBanners_ImgLink]]) {
        rStr=[rStr stringByAppendingString:pDic[kBanners_ImgLink]];
        //参数
        if (![@""isEqualToString:pDic[kBanners_Par]]) {
            NSArray * tRawArray=[pDic[kBanners_Par] componentsSeparatedByString:kBanners_Par_Split];
            NSMutableArray *tArray=[NSMutableArray array];
            for (NSString * Obj in tRawArray) {
                if (![@"" isEqualToString:Obj]) {
                    [tArray addObject:Obj];
                }
            }
            if (tArray.count>0) {
                for (int i=0; i<tArray.count; i++) {
                    NSString * tValue=[ConfigService valueForName:tArray[i]];
                    //如果是空值
                    if ([@"" isEqualToString:tValue]) {
                        tValue=kStrDef_NULL;
                    }
                    //最后一个
                    if (i!=tArray.count-1) {
                        tParam=[ tParam stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",tArray[i],tValue]];
                    }else{
                        tParam=[ tParam stringByAppendingString:[NSString stringWithFormat:@"%@=%@",tArray[i],tValue]];
                    }
                }
            }
        }
        //填充参数
        if (![@"" isEqualToString:tParam]) {
            rStr=[NSString stringWithFormat:@"%@?%@",rStr,tParam];
        }
    }
    return rStr;
}


-(void) PostWithURL:(NSString *)pURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=pURL;//[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_Eroll];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:pDicParameters httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) GetWithURL:(NSString *)pURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=pURL;//[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_Eroll];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    tURL=[self getURLStr:tURL];
        NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doGetByAsynWithUrl:tURL parameters:nil success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
//post 请求
-(void) PostWithSubURL:(NSString *)pSubURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
     NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],pSubURL];
    [self PostWithURL:tURL DicArray:pParameters parameters:pDicParameters httpBody:pHttpBody success:^(id pResult) {
         pSuccessHandler(pResult);
    } error:^(NSError *pError) {
         pErrorHandler(pError);
    }];
}
//get 请求
-(void) GetWithSubURL:(NSString *)pSubURL DicArray:(NSMutableArray*)pParameters  parameters:(NSDictionary *)pDicParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],pSubURL];
    [self GetWithURL:tURL DicArray:pParameters parameters:pDicParameters httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
//获取参数数据
//-(NSMutableArray *)ConvertParamArratWithPostKeyValues:(PostKeyValue *)vString,...
//{
//    NSMutableArray * argsArray=[NSMutableArray array];
//    va_list varList;
//    id arg;
//    //NSMutableArray *argsArray = [[NSMutableArray alloc]inti];
//    if(vString){
//        va_start(varList,vString);
//        while((arg = va_arg(varList,id))){
//            [argsArray addObject:arg];
//        }
//        va_end(varList);
//    }
//    
//    return argsArray;
//}
#pragma mark 业务逻辑接口
-(void) ErollPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_Eroll DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ErollCheckPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_ErollCheck DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ErollSMSGetCodePostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler;
{
    [self PostWithSubURL:kPrinterAPI_ErollSMSGetCode DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) FindPwdPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_FindPwd DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) GetResByIdPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self GetWithSubURL:kPrinterAPI_GetResById DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) LoginPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_Login DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResAllListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self GetWithSubURL:kPrinterAPI_ResAllList DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResChildAllPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_ResChildAll DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResDelPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_ResDel DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResDownLoadPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
//    [self PostWithSubURL:kPrinterAPI_ResDownLoad DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
//        pSuccessHandler(pResult);
//    } error:^(NSError *pError) {
//        pErrorHandler(pError);
//    }];
    
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_ResDownLoad];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) UpdateUmarkPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_UpdateUmark];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResSearchListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_ResSearchList];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResSearchListTestPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    [self PostWithSubURL:kPrinterAPI_ResSearchListTest DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
}
-(void) ResultModelChildListPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_ResultModelChildList];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }

    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
/*
    [self PostWithSubURL:kPrinterAPI_ResultModelChildList DicArray:pParameters parameters:nil httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
 */
    
}

-(void) UpdateUserPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_UpdateUser];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];

    
}
-(void) GetUserInfoPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_GetUserInfo];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
    
    
}

-(void) MenoyAddPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_MenoyAdd];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
    
    
}
-(void) GetOrderStatusPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_GetOrderStatus];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
    
    
}
-(void) GetBannerArrayPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_GetBannerArray];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
    for (PostKeyValue * tDic in pParameters) {
        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];

}
-(void) CallBackMoneyAppPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_CallBackMoneyApp];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
//    for (PostKeyValue * tDic in pParameters) {
//        if ([@"" isEqualToString:tDic.mValue]) {
//            tDic.mValue=kStrDef_NULL;
//        }
//        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
//    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
    
}
-(void) CreateAppMoneyPayPostWithDicArray:(NSMutableArray*)pParameters httpBody:(id)pHttpBody success:(void(^)(id pResult)) pSuccessHandler error:(void(^)(NSError *pError))pErrorHandler
{
    NSString * tURL=[NSString stringWithFormat:@"%@/%@",[self BaseServerURL],kPrinterAPI_CreateAppMoneyPay];
    NSMutableDictionary * tParamDic=[NSMutableDictionary dictionary];
//    for (PostKeyValue * tDic in pParameters) {
//        if ([@"" isEqualToString:tDic.mValue]) {
//            tDic.mValue=kStrDef_NULL;
//        }
//        if (tDic.mIsEnCode) {
//            tDic.mValue=[self  getURLStr:tDic.mValue];
//        }
//        tURL=[tURL stringByAppendingString:[NSString stringWithFormat:@"/%@",tDic.mValue]];
//    }
    //tURL=[self getURLStr:tURL];
    NSLog(@"ServerURL:%@",tURL);
    [HttpHelper doPostByAsynWithUrl:tURL parameters:tParamDic httpBody:pHttpBody success:^(id pResult) {
        pSuccessHandler(pResult);
    } error:^(NSError *pError) {
        pErrorHandler(pError);
    }];
    
}

+(NSString *) GetErrorCodeString:(int) pStateCode
{
    NSString * rString =_LS_(@"kRES_STATE_CODE_ERR", nil);
    if (pStateCode==kRES_STATE_CODE_OK) {
        rString=_LS_(@"kRES_STATE_CODE_OK", nil);//@"成功";
    }else if (pStateCode==kRES_STATE_CODE_NUMBER_ERR) {
        rString=_LS_(@"kRES_STATE_CODE_NUMBER_ERR", nil);//@"电话号码错误";
    }else if (pStateCode==kRES_STATE_CODE_NUMBER_EXIST) {
        rString=_LS_(@"kRES_STATE_CODE_NUMBER_EXIST", nil);//@"号码已注册";
    }
    else if (pStateCode==kRES_STATE_CODE_NUMBER_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_NUMBER_EMPTY", nil);//@"号码为空";
    }
    else if (pStateCode==kRES_STATE_CODE_CODE_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_CODE_EMPTY", nil);//@"验证码为空";
    }
    else if (pStateCode==kRES_STATE_CODE_SERACH_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_SERACH_EMPTY", nil);//@"搜索关键字为空";
    }
    else if (pStateCode==kRES_STATE_CODE_DEL_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_DEL_EMPTY", nil);//@"删除为空";
    }
    else if (pStateCode==kRES_STATE_CODE_EMAIL_FORMAT_ERR) {
        rString=_LS_(@"kRES_STATE_CODE_EMAIL_FORMAT_ERR", nil);//@"邮箱格式不对";
    }
    else if (pStateCode==kRES_STATE_CODE_MSG_ERR) {
        rString=_LS_(@"kRES_STATE_CODE_MSG_ERR", nil);//@"短信验证码后台发送为空";
    }
    else if (pStateCode==kRES_STATE_CODE_MSG_NOT_MACTH) {
        rString=_LS_(@"kRES_STATE_CODE_MSG_NOT_MACTH", nil);//@"电话号码错误";
    }
    else if (pStateCode==kRES_STATE_CODE_MSG_SERVER_ERR) {
        rString=_LS_(@"kRES_STATE_CODE_MSG_SERVER_ERR", nil);//@"电话号码服务端错误";
    }else if (pStateCode==kRES_STATE_CODE_USER_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_USER_EMPTY", nil);//@"用户名为空";
    }else if (pStateCode==kRES_STATE_CODE_PASSWORD_EMPTY) {
        rString=_LS_(@"kRES_STATE_CODE_PASSWORD_EMPTY", nil);//@"用户名密码不能为空";
    }else if (pStateCode==kRES_STATE_CODE_PASSWORD_SURE) {
        rString=_LS_(@"kRES_STATE_CODE_PASSWORD_SURE", nil);//@"用户名密码与确认密码不一致";
    }else if (pStateCode==kRES_STATE_CODE_PASSWORD_USER) {
        rString=_LS_(@"kRES_STATE_CODE_PASSWORD_USER", nil);//@"用户名或密码错误";
    }else if (pStateCode==kRES_STATE_CODE_USER_EXIST) {
        rString=_LS_(@"kRES_STATE_CODE_USER_EXIST", nil);//@"用户已存在";
    }else if (pStateCode==kRES_STATE_CODE_USER_POWER) {
        rString=_LS_(@"kRES_STATE_CODE_USER_POWER", nil);//@"用户没有权限";
    }else if (pStateCode==kRES_STATE_CODE_USER_MARK) {
        rString=_LS_(@"kRES_STATE_CODE_USER_MARK", nil);//@"用户名积分不足";
    }else if (pStateCode==kRES_STATE_CODE_USER_NOT_EXIST) {
        rString=_LS_(@"kRES_STATE_CODE_USER_NOT_EXIST", nil);//@"用户不存在";
    }else if (pStateCode==kRES_STATE_CODE_USER_NOT_DEVELPING) {
        rString=_LS_(@"kRES_STATE_CODE_USER_NOT_DEVELPING", nil);//@"功能暂未开放";
    }else if (pStateCode==kRES_STATE_CODE_ERR) {
        rString=_LS_(@"kRES_STATE_CODE_ERR", nil);//@"错误";
    }

    
    return rString;
}
+(instancetype) GetInstance
{
    static ServerForHttp *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
