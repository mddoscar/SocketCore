//
//  ServerForDevices.m
//  Printer3D
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "ServerForDevices.h"

#define kTypeGCode 4 //0x4
//正则替换
#define kLineNumber @"&;;;;"
#define kLineStrSplit @"&----"
#define kLine_N @"0a"
#define kLine_N_int 10
#define kLine_StrSplit @"00"
//文件的分割
#define kFileNewSplit @"@" //文件
#define kFileNewTimeSplit '_' //文件
//定义100个0
#define kFile100Char @"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
#define kFile1Char @"0"
//
#import "AppDelegate.h"
#import "CmdBeanCahceHeader.h"
//json转换
#import "JSONKit.h"

@implementation ServerForDevices
//获取包头
+(NSString *) getSendPackHeader:(NSUInteger) pLength TypeCode:(int)pType
{
//    return [NSString stringWithFormat:@"%04lx%01x",(unsigned long)pLength,pType];
        return [NSString stringWithFormat:@"%01x",pType];
}
//获取通用的命令字符串
+(NSString *) getCommonStrTypeCode:(NSString *)pType cmdStr:(NSString *) pStr
{
    
    return [NSString stringWithFormat:@"%@\0%@\0\n",[[self class] getASCIIString:pType],pStr];
}
+(NSString *) getCommonStrNewTypeCode:(NSString*)pType cmdStr:(NSString *) pStr
{
    return [NSString stringWithFormat:@"%@\0%@\0\n",[[self class] getASCIIString:pType],[[self class] getASCIIString:pStr]];
}
//命令字符串数组
+(NSString *) getCommonStrArrTypeCode:(NSString*)pType cmdStrArr:(NSMutableArray *) pStrArr
{
    NSString * cmdStr=@"";
    for (int i=0; i<pStrArr.count; i++) {
        NSString * tStr=[pStrArr objectAtIndex:i];
        cmdStr=[cmdStr stringByAppendingString:[[self class] getASCIIString:tStr]];
        cmdStr=[cmdStr stringByAppendingString:@"\0"];
    }
     return [NSString stringWithFormat:@"%@\0%@\n",[[self class] getASCIIString:pType],cmdStr];
}
+(NSString *) getCommonStrArrTypeCode:(NSString*)pType cmdAsciiStrArr:(NSMutableArray *) pStrArr
{
    NSString * cmdStr=@"";
    for (int i=0; i<pStrArr.count; i++) {
        NSString * tStr=[pStrArr objectAtIndex:i];
        cmdStr=[cmdStr stringByAppendingString:tStr];
        cmdStr=[cmdStr stringByAppendingString:@"\0"];
    }
    return [NSString stringWithFormat:@"%@\0%@\n",[[self class] getASCIIString:pType],cmdStr];
}
+(NSData *) getCommonDataArrTypeCode:(NSString*)pType cmdDataArr:(NSMutableArray *) pDataArr
{

    NSMutableData * rData= [NSMutableData dataWithData:
                            [
                            [NSString stringWithFormat:@"%@\0",[[self class] getASCIIString:pType]]
                             dataUsingEncoding:NSUTF8StringEncoding
                             ]
                            ];
    for (NSData * ObjData in pDataArr) {
        [rData appendData:ObjData];
        [rData appendData:[[NSString stringWithFormat:@"\0"]dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [rData appendData:[[NSString stringWithFormat:@"\n"]dataUsingEncoding:NSUTF8StringEncoding]];
    return  rData;
}
+(NSString *) getASCIIString:(NSString *)pStr
{
    if (nil==pStr) {
        return nil;
    }else{
        NSString * rStr=@"";
        long lenth=pStr.length;
        for (long i=0; i<lenth; i++) {
            //NSLog(@"i:%ld",i);
            int asciiCode=[pStr characterAtIndex:i];
            rStr= [rStr stringByAppendingString:[NSString stringWithFormat:@"%c", asciiCode]];
        }
        return rStr;//[NSString stringWithFormat:@"%c", asciiCode];
    }
}
//获取比特
+(NSString *)intToBinary:(int)intValue
{
    int byteBlock = 8,    // 每个字节8位
    totalBits = sizeof(int) * byteBlock, // 总位数（不写死，可以适应变化）
    binaryDigit = 1;  // 当前掩（masked）位
    NSMutableString *binaryStr = [[NSMutableString alloc] init];   // 二进制字串
    do
    {
        // 检出下一位，然后向左移位，附加 0 或 1
        [binaryStr insertString:((intValue & binaryDigit) ? @"1" : @"0" ) atIndex:0];
        // 若还有待处理的位（目的是为避免在最后加上分界符），且正处于字节边界，则加入分界符|
        if (--totalBits && !(totalBits % byteBlock))
            [binaryStr insertString:@"|" atIndex:0];
        // 移到下一位
        binaryDigit <<= 1;
    } while (totalBits);
    // 返回二进制字串
    return binaryStr;
}
//获取数据包
+(NSData *)getDataPackFromStr:(NSString *)pDataStr
{
    return (nil!=pDataStr)?[pDataStr dataUsingEncoding:NSUTF8StringEncoding]:nil;
}
//获取数据包分包结构
+(NSMutableArray *)getDataPackFromData:(NSData * )pData blockLength:(long) pBlockLength
{
    NSMutableArray * rDataArr=[NSMutableArray array];
    long blockLenth= pBlockLength;//512*1024;
    long pagckageNum=pData.length/blockLenth;
    long lastLength=pData.length-pagckageNum*blockLenth;
    //大于1包
    if (blockLenth>0) {
        //前面完整的512*1024
        for (int i=0; i<pagckageNum-1; i++) {
            NSMutableData * Data=[NSMutableData dataWithData:[[[self class] getSendPackHeader:blockLenth TypeCode:kTypeGCode] dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *data1 = [pData subdataWithRange:NSMakeRange(i*blockLenth, blockLenth)];
            [Data appendData:data1];
            [rDataArr addObject:Data];
        }
        if(lastLength>0)
        {
            //不完整的最后一包
            NSMutableData * Data=[NSMutableData dataWithData:[[[self class] getSendPackHeader:blockLenth TypeCode:kTypeGCode] dataUsingEncoding:NSUTF8StringEncoding]];
//            [Data appendData:fileData];
            NSData *data1 = [pData subdataWithRange:NSMakeRange(pagckageNum*blockLenth, lastLength)];
            [Data appendData:data1];
            [rDataArr addObject:Data];
        }
    //一包能发完
    }else{
        NSMutableData * Data=[NSMutableData dataWithData:[[[self class] getSendPackHeader:blockLenth TypeCode:kTypeGCode] dataUsingEncoding:NSUTF8StringEncoding]];
        [Data appendData:pData];
        [rDataArr addObject:Data];
    }
    return rDataArr;
}
+(NSMutableArray *) decodeArrayNewWithData:(NSMutableData *)pData
{
    NSMutableArray * rArray=[NSMutableArray array];
    NSInteger a=0;
    for (NSInteger i=0; i<pData.length; i++) {
        NSData *data=[pData subdataWithRange:NSMakeRange(i,1)];
        
        if ([data isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
            [rArray addObject: [[NSString alloc]initWithData:[pData subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
            a=i+1;
        }
        if ([data isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            //             a+=1;
                    continue;
            //break;
            
        }
        
    }

    return rArray;
}

+(NSMutableArray *) decodeArrayOldWithData:(NSMutableData *)pData
{
    NSMutableArray * rArray=[NSMutableArray array];
    NSInteger a=0;
    for (NSInteger i=0; i<pData.length; i++) {
        NSData *data=[pData subdataWithRange:NSMakeRange(i,1)];
        
        if ([data isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
            [rArray addObject: [[NSString alloc]initWithData:[pData subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
            a=i+1;
        }
        if ([data isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            //             a+=1;
            //continue;
            //NSLog(@"a:%ld,pData:%ld",a,pData.length);
            break;
            
        }
        
    }
    
    return rArray;
}
+(NSMutableArray *) decodeArrayNowPackageWithData:(NSMutableData *)pData
{
//    NSMutableArray *rArrayNew=[NSMutableArray array];
    NSMutableArray * rArray=[NSMutableArray array];
//    NSMutableArray * rArray2=[NSMutableArray array];
    NSInteger a=0;
    for (NSInteger i=0; i<pData.length; i++) {
        NSData *data=[pData subdataWithRange:NSMakeRange(i,1)];
        if ([data isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
            NSData *oneData=[pData subdataWithRange:NSMakeRange(a,i-a)];
            [rArray addObject: [[NSString alloc]initWithData:oneData encoding:NSUTF8StringEncoding]];
            a=i+1;
//            if (oneData.length>4) {
//                NSLog(@"i:%ld>%ld, %@,StringData %@",(long)i,[[self class] bytes2long:oneData.bytes],oneData,rArray[rArray.count-1]);
//                [rArray2 addObject:[NSString stringWithFormat:@"%ld",[[self class] bytes2long:oneData.bytes]]];
//            }else{
//                NSLog(@"i:%ld>%ld, %@,StringData %@",(long)i,[[self class] bytesToInt:oneData.bytes offset:0],oneData,rArray[rArray.count-1]);
//                 [rArray2 addObject:[NSString stringWithFormat:@"%d",(int)[[self class] bytesToInt:oneData.bytes offset:0]]];
//            }
            
        }
        if ([data isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            //             a+=1;
            //continue;
            //NSLog(@"a:%ld,pData:%ld",a,pData.length);
            
            
            break;
            
        }
        
    }
//    if (rArray.count>0) {
//         [rArrayNew addObject:rArray[0]];
////         [rArrayNew addObject:[[self class]decodeArrayNewWithDataArray:[NSMutableArray arrayWithArray:rArray ]]];
////        NSMutableData * mData=[NSMutableData data];
////        for (NSString * obj in rArray) {
////            [mData appendData:[obj dataUsingEncoding:NSUTF8StringEncoding ]];
////        }
////        NSValue *value = [NSValue valueWithBytes:mData.bytes objCType:@encode(struct ScenePackage)];
////        struct ScenePackage * theTestStruct;
////        [value getValue:theTestStruct];
////
////        
////        NSValue *value1 = [NSValue valueWithBytes:pData.bytes objCType:@encode(struct ScenePackage)];
////        struct ScenePackage theTestStruct1;
////        [value1 getValue:&theTestStruct1];
////        [rArrayNew addObject:value];
////        //转换函数
//        
//    }

//    NSInteger a=0;
////    NSString *type=@"";
//    NSData * mDataType;
//    NSData * mDataPrtStatus;
//    NSData * mDataPrtCmd;
//    NSData * mDataPrtPara;
////    NSInteger index=[[self class] indexofLineWithData:pData];
//    
//    for (NSInteger i=0; i<pData.length; i++) {
//        NSData *data=[pData subdataWithRange:NSMakeRange(i,1)];
//        
//        if ([data isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
//            [rArray addObject: [[NSString alloc]initWithData:[pData subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
//            a=i+1;
//            break;
//            
//        }
//    }
//    mDataType=[pData subdataWithRange:NSMakeRange(0, a)];
//    mDataPrtStatus=[pData subdataWithRange:NSMakeRange(a, sizeof(PrtStatus))];
//    mDataPrtCmd=[pData subdataWithRange:NSMakeRange(a+sizeof(PrtStatus), sizeof(PrtCmd))];
//    mDataPrtPara=[pData subdataWithRange:NSMakeRange(a+sizeof(PrtStatus)+sizeof(PrtCmd),sizeof(PrtPara) )];
//    [rArray addObject:mDataPrtStatus];
//    [rArray addObject:mDataPrtCmd];
//    [rArray addObject:mDataPrtPara];
    return rArray;

}
+(struct ScenePackage) DeCodeScenePackageWithData:(NSData *) pData
{
      struct ScenePackage decodePackage;
    NSValue *value = [[NSValue valueWithBytes:pData.bytes objCType:@encode(struct ScenePackage)] mutableCopy];
    [value getValue:&decodePackage];
    return decodePackage;
}
+(struct ScenePackage) decodeArrayNewWithDataArray:(NSMutableArray *)pDataArray
{
//    NSMutableDictionary * rArrayDic=[NSMutableDictionary dictionary];
//    struct ScenePackage theTestStruct1;
    

    struct ScenePackage decodePackage;
    ServerForDevices * MySelf=[[ServerForDevices alloc] init];
    __weak __typeof(&*self)weakSelf = MySelf;
    decodePackage=[weakSelf decodeWithArray:pDataArray decodePackage:decodePackage];
//    int *pint=(int *)&decodePackage;
//    NSMutableArray * TArr=[pDataArray mutableCopy];
    
    
    
//    for (int i=1; i<TArr.count-1; i++) {
//        pint[i-1]=[TArr[i] doubleValue];
//        pint++;
//        //[TArr addObject:pDataArray[i] ];
//        
//    }
//    int * p = &theTestStruct1;
//    for (int i=1; i<pDataArray.count-1; i++) {
//        NSLog(@"%d:%@,p%hx",i,pDataArray[i],p);
//        if (i!=217) {
//            p[i]= [pDataArray[i] doubleValue];
//            p++;
//        }
//
//    }
//    if ( pDataArray.count>217) {
//        p[217]=[pDataArray[217] doubleValue];
//    }
//    NSData *data = [[NSData dataWithBytes:&decodePackage length:sizeof(struct ScenePackage)] mutableCopy];
//    NSString * tStr=@"Data:";
//    [tStr stringByAppendingString:[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding] ];
//    NSValue *value = [[NSValue valueWithBytes:data.bytes objCType:@encode(struct ScenePackage)] mutableCopy];
//    [rArrayDic setValue:data forKey:kScenePackage_Scene];
    return decodePackage;
}
+(NSMutableArray *) encodeArrayNewWithDataStruct:(struct ScenePackage)pStruct
{
    NSMutableArray * rArray=[NSMutableArray array];
//    struct ScenePackage tempSturct=[[self class] decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
//    kStructLength
    
    //命令
    [rArray addObject:kCmdType_now_req];
     unsigned int *pint=(unsigned int *)&pStruct;
    
    
    for (int i=0; i<sizeof(struct ScenePackage)/4; i++) {
//        NSLog(@"%d",pint[i]);
//        if ([[self class] IsZS:pint[i]]) {
            rArray[i+1]=[NSString stringWithFormat:@"%ld",pint[i]];
//        }else{
//            rArray[i+1]=[NSString stringWithFormat:@"%f",pint[i]];
//        }
        pint++;
        //[TArr addObject:pDataArray[i] ];
        
    }
    
    return rArray;
}

+(BOOL) IsZS:(double) n
{
    BOOL res= false;
    if(n>=0)
    if( (n-(int)n) < 1e-15 || (n-(int)n) > 0.999999999999999 )
        //双精度对应1e-15和15个9（单精度对应1e-6和6个9）
        res=true;
    else
         res=false;
    else
        if( -(n-(int)n) < 1e-15 || -(n-(int)n) > 0.999999999999999 )
            res=true;
        else
             res=false;
    return res;
}
-(struct ScenePackage)decodeWithArray:(NSMutableArray *)pDataArray decodePackage:(struct ScenePackage )pdecodePackage
{
    int *pint=( int *)&pdecodePackage;
    NSMutableArray * TArr=[pDataArray mutableCopy];
    
    for (int i=1; i<TArr.count; i++) {
        pint[i-1]=[TArr[i] integerValue];
        //pint++;
        //[TArr addObject:pDataArray[i] ];
        
    }
    return pdecodePackage;
}
+(NSMutableArray *) dataArrayWithData:(NSData *)data WithString:(NSString *)string
{
    NSMutableArray *dataArr=[NSMutableArray array];

//    NSMutableArray *muArr=[NSMutableArray array];
    
    NSData *strData=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    int a=0;
    int m=-1;
    for (int i=0; i<data.length; i++) {
        NSData *data1=[data subdataWithRange:NSMakeRange(i,1)];
        
        NSData *data2=[data subdataWithRange:NSMakeRange(a, string.length)];
    
    
        
        if ([data2 isEqualToData:[string dataUsingEncoding:NSUTF8StringEncoding]]) {
            
            m++;
    
            
            if ([data1 isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
                
                [dataArr addObject: [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(i-m,m)] encoding:NSUTF8StringEncoding]];
                m=-1;
                
            }
           
            
        }
        
        
        
        
//        if ([data1 isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
//            [_muArr addObject: [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
//            a=i+1;
//            
//        }
        if ([data1 isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            m=-1;
            a=i+1;
             NSData *data2=[data subdataWithRange:NSMakeRange(a, string.length)];
            if ([data2 isEqualToData:strData]) {
                
            }
  

            

            
        }
        
    }
    return dataArr;

}
+(NSMutableArray *) decodeFileArrayWithData:(NSMutableData *)pData
{
     NSMutableArray *dataArr=[NSMutableArray array];
    if (pData.length>0) {
       NSMutableData *data1 = [NSMutableData dataWithData:[pData subdataWithRange:NSMakeRange(0, kOnePackgeHeadLength)]];
        NSMutableData *data2 = [NSMutableData dataWithData:[pData subdataWithRange:NSMakeRange(kOnePackgeHeadLength, kOnePackgeTypeLength)]];
        NSMutableData *data3 = [NSMutableData dataWithData:[pData subdataWithRange:NSMakeRange(kOnePackgeHeadLength+kOnePackgeTypeLength, kOnePackgeDataLength)]];
                [dataArr addObject:data1];
                [dataArr addObject:data2];
                [dataArr addObject:data3];
    }
    return  dataArr;
}

//拆分
+(NSMutableArray *) decodeArrayWithData:(NSMutableData *)pData
{
//    int i=2;
//    [pData getBytes: &i length: sizeof(i)];
//    NSLog(@"pData====%d",i);
    NSMutableArray * mArray=[NSMutableArray array];
    NSMutableArray * rArray=[NSMutableArray array];
#if 1
    long a=0;
    for (long i=0; i<pData.length; i++) {
        NSData *data=[pData subdataWithRange:NSMakeRange(i,1)];

        if ([data isEqualToData:[@"\0" dataUsingEncoding:NSUTF8StringEncoding]]) {
            [rArray addObject: [[NSString alloc]initWithData:[pData subdataWithRange:NSMakeRange(a,i-a)] encoding:NSUTF8StringEncoding]];
            a=i+1;
         
        }
        if ([data isEqualToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setValue:rArray forKey:@"key"];
             a+=1;
            [mArray addObject:dic];
               NSLog(@"mArray==========%@",mArray);
            [rArray removeAllObjects];
            continue;
           
        }else{
//            NSLog(@"w----!");
        }
 
    }
    #else
    
    //替换字符串
//    [pData replaceBytesInRange:NSMakeRange (0, pData.length) withBytes:[[kLineNumber dataUsingEncoding:NSUTF8StringEncoding]bytes]];
//    NSData * tSplitData=[@"\n" dataUsingEncoding:NSUTF8StringEncoding];
//    NSData * tSplit0Data=[@"\0" dataUsingEncoding:NSUTF8StringEncoding];
    // 第二种方法

    NSMutableString *result = [NSMutableString string];
    const char *bytes = [pData bytes];
    for (int i = 0; i < [pData length]; i++)
    {
        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
//        [result appendFormat:@"%02d", (unsigned char)bytes[i]];
    }
    NSArray * tArr=[result componentsSeparatedByString:kLine_N];
    NSArray * tArrData=[tArr[0] componentsSeparatedByString:kLine_StrSplit];
//    NSLog(@"result:%@", result);
//    NSRange spData1= [pData rangeOfData:tSplitData options:NSDataSearchBackwards range:NSMakeRange (0, pData.length)];
//    NSData * SubData=[pData subdataWithRange:NSMakeRange(0,pData.length-spData1.length)];
//    NSRange spData2= [SubData rangeOfData:tSplit0Data options:NSDataSearchBackwards range:NSMakeRange (0, SubData.length)];
    for (int i=0; i<[tArrData count]; i++) {
        if(![@"" isEqualToString:tArrData[i]])
        {
            NSString * tStr=[[self class]convertHexStrToString:tArrData[i]];
            if (nil!=tStr) {
                            [rArray addObject:tStr];
            }
            else{
            
            }
        }
    }
    //NSString* aStr= [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
    
    
#endif
    return mArray;
    
}
+(NSString *) decodeASCIIStrWithData:(NSMutableData *)pData
{
    return [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
}
+(NSMutableString *) decodeHexMuStrWithData:(NSMutableData *)pData
{
    NSMutableString *result = [NSMutableString string];
    const char *bytes = [pData bytes];
    for (int i = 0; i < [pData length]; i++)
    {
        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
    }
    return result;
}
//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}
+(BOOL) isLineWithData:(NSData *)pData
{
    BOOL isLine=false;
    
    //NSMutableString *result = [NSMutableString string];
    const char *bytes = [pData bytes];
    for (int i = 0; i < [pData length]; i++)
    {
//        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
        if ([kLine_N isEqualToString:[NSString stringWithFormat:@"%02hhx",(unsigned char)bytes[i] ]]) {
            isLine=true;
            break;
        }
    }
    return isLine;
}
+(long long) indexofLineWithData:(NSData *)pData
{
    long long isLineNumber=-1;
    
    //NSMutableString *result = [NSMutableString string];
    const char *bytes = [pData bytes];
    for (long long i = 0; i < [pData length]; i++)
    {
        //        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
        
//        if ([kLine_N isEqualToString:[NSString stringWithFormat:@"%02hhx",(unsigned char)bytes[i]]])
        if (kLine_N_int ==(int)bytes[i])
        {
            isLineNumber=i;
            break;
        }
    }
    return isLineNumber;
}

+(NSMutableArray *)indexWithData:(NSData *)pData
{
    NSMutableArray *muArr=[NSMutableArray array];
    
    //NSMutableString *result = [NSMutableString string];
    const char *bytes = [pData bytes];
    for (NSInteger i = 0; i < [pData length]; i++)
    {
        //        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
        if ([kLine_N isEqualToString:[NSString stringWithFormat:@"%02hhx",(unsigned char)bytes[i]]]) {
            [muArr addObject:[NSString stringWithFormat:@"%ld",i]];
            break;
        }
    }
    return muArr;
}


+(NSMutableData *) decodeSubGCodeWithData:(NSMutableData *)pData
{
    NSString * tempStr=[[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"!@" withString:@"\r\n"];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"@" withString:@"\n"];
    return [NSMutableData dataWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding]];
}
+(NSMutableData *) decodeSubGCodeWithStr:(NSString *)pDataStr
{
    pDataStr= [pDataStr stringByReplacingOccurrencesOfString:@"!@" withString:@"\r\n"];
    pDataStr= [pDataStr stringByReplacingOccurrencesOfString:@"@" withString:@"\n"];
    return [NSMutableData dataWithData:[pDataStr dataUsingEncoding:NSUTF8StringEncoding]];
}
+(NSMutableData *) encodeSubGCodeWithData:(NSData *)pData
{
    NSString * tempStr=[[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"!"];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
    return [NSMutableData dataWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding]];
}
+(NSMutableData *) encodeSubGCodeWithStr:(NSString *)pDataStr
{
    NSString * tempStr=pDataStr;
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"!"];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
    return [NSMutableData dataWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding]];
}
+(NSString *) encodeSubGCodeStrWithData:(NSData *)pData
{
//    NSMutableString *result = [NSMutableString string];
//    const char *bytes = [pData bytes];
//    for (int i = 0; i < [pData length]; i++)
//    {
//        [result appendFormat:@"%d", (unsigned char)bytes[i]];
//    }
    NSString * tempStr=[[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"!"];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
    return tempStr;
}
+(NSData *) encodeSubGCodeDataWithData:(NSData *)pData
{
    NSString * tempStr=[[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    if (nil!=tempStr) {
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"!"];
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
    }else{
        tempStr=[pData description];
        //3C
//       tempStr= [tempStr stringByReplacingOccurrencesOfString:@"3c" withString:@""];// <
//        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"3e" withString:@""];// >
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"<" withString:@""];// <
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@">" withString:@""];// >
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"0d" withString:@"21"];
        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"0a" withString:@"40"];
        //!!!!!!!!
//        tempStr= [tempStr stringByReplacingOccurrencesOfString:@"000" withString:@"00"];
    }

    return [NSMutableData dataWithData:[tempStr dataUsingEncoding:NSUTF8StringEncoding]];

}
+(NSString *) encodeSubGCodeStrWithStr:(NSString *)pDataStr
{
    NSString * tempStr=pDataStr;
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"!"];
    tempStr= [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"@"];
    return tempStr;
}
+(NSString *) getDownloadRoot
{
    return @"Gcodes";//@"Download";
}
+(NSString *) getGcodeRoot
{
    return @"Gcodes";
}
+(NSString *) getGcodeFileName:(NSString *) pSubFileName
{
    return [NSString stringWithFormat:@"%@/%@",[[self class] getGcodeRoot],pSubFileName];
}
+(NSString *) getGcodeUserPath:(NSString *) pUserId{
    return [NSString stringWithFormat:@"%@/%@",[[self class] getGcodeRoot],pUserId];
}
+(NSString *) getDownloadUserPath:(NSString *) pUserId{
    return [NSString stringWithFormat:@"%@/%@",[[self class] getDownloadRoot],pUserId];
}

+(NSString *) getGcodeFileName:(NSString *) pSubFileName mUserId:(NSString *) pUserId
{
    return [NSString stringWithFormat:@"%@/%@/%@",[[self class] getGcodeRoot],pUserId,pSubFileName];
}
+(NSString *) getDownloadRootFileName:(NSString *) pSubFileName mUserId:(NSString *) pUserId
{
    return [NSString stringWithFormat:@"%@/%@/%@",[[self class] getDownloadRoot],pUserId,pSubFileName];
}


//获取数据包
+(NSData *) getFileDataWithFileData:(NSData *)pData
{
     NSMutableData * rOlData=[[NSMutableData alloc] initWithLength:kOnePackgeLength];
    NSMutableData * rData=[NSMutableData data];
    NSString * length=[NSString stringWithFormat:@"%ld",pData.length];
    char type=kCmdType_File_Data_req_Char;
    //标题
    [rData appendData:[self getByteData:[length integerValue]]];
    //类型
    [rData appendData:[self getCharData:type]];
    //正文
    [rData appendData:pData];
    
    [rOlData replaceBytesInRange:NSMakeRange(0, rData.length) withBytes:rData.bytes];
//    //
//    if(pData.length>=kOnePackgeDataLength)
//    {
//        
//    //字符不够，需要填充0
//    }else{
//        NSString * extStr=@"";
//        long long count=(kOnePackgeDataLength -pData.length);
//        for (long long i=0; i<count; i++) {
//            extStr=[extStr stringByAppendingString:@"0"];
//        }
//        [rData appendData:[[self getASCIIString:extStr] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
    return rOlData;
}
//获取文件名包
+(NSData *) getFileNameDataWithFileShortName:(NSString *)pShortName timestr:(NSString *)pTimestr FileLength:(NSInteger)pFileLength
{
    NSMutableData * rOlData=[[NSMutableData alloc] initWithLength:kOnePackgeLength];
    NSMutableData * rData=[NSMutableData data];
    NSString * length=@"0";
    char type=kCmdType_File_FileName_req_Char;
    NSString * content=@"";
    content=[NSString stringWithFormat:@"%@_%@%@%ld%@",pTimestr,pShortName,kFileNewSplit,pFileLength,kFileNewSplit];
    
    content=[self getASCIIString:content];
    length=[NSString stringWithFormat:@"%ld",content.length];
    //标题
    
    [rData appendData:[self getByteData:[length integerValue]]];
    //类型
    [rData appendData:[self getCharData:type]];
    //正文
    [rData appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [rOlData replaceBytesInRange:NSMakeRange(0, rData.length) withBytes:rData.bytes];
//    if(content.length>=kOnePackgeDataLength)
//    {
//        
//        //字符不够，需要填充0
//    }else{
//        NSString * extStr=@"";
//        long long count=(kOnePackgeDataLength -content.length);
//        for (long long i=0; i<count; i++) {
//            extStr=[extStr stringByAppendingString:@"0"];
//        }
//        [rData appendData:[[self getASCIIString:extStr] dataUsingEncoding:NSUTF8StringEncoding]];
//    }

    return rOlData;
}
+(NSData *) getFileNameDataWithFileShortName:(NSString *)pShortName timestr:(NSString *)pTimestr FileLength:(NSInteger)pFileLength index:(long) pIndex
{
    NSMutableData * rOlData=[[NSMutableData alloc] initWithLength:kOnePackgeLength];
    NSMutableData * rData=[NSMutableData data];
    NSString * length=@"0";
    char type=kCmdType_File_Index_resp_Char;
    NSString * content=@"";
    content=[NSString stringWithFormat:@"%@_%@%@%ld%@%ld%@",pTimestr,pShortName,kFileNewSplit,pFileLength,kFileNewSplit,pIndex,kFileNewSplit];
    
    content=[self getASCIIString:content];
    length=[NSString stringWithFormat:@"%ld",content.length];
    //标题
    
    [rData appendData:[self getByteData:[length integerValue]]];
    //类型
    [rData appendData:[self getCharData:type]];
    //正文
    [rData appendData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [rOlData replaceBytesInRange:NSMakeRange(0, rData.length) withBytes:rData.bytes];
    return rOlData;
}
+(NSData *) getByteData:(NSUInteger )pLength
{
    NSData * rData=[NSData data];
    long time = pLength;
    char *p_time = (char *)&time;
    char str_time[4] = {0};
    for(int i= 0 ;i < 4 ;i++)
    {
        str_time[i] = *p_time;
        p_time ++;
    }
    rData = [NSData dataWithBytes:str_time length:4];
    return rData;
}
+(NSData *) getCharData:(char )pChar
{
    NSData * rData=[NSData data];
    rData = [NSData dataWithBytes:&pChar length:1];
    return rData;
}
+(NSMutableData *) initDataWithLength:(NSInteger) pLength
{
    int block=100;
//kFile10Char
    long page=pLength/block;
    long restChar=pLength%block;
    NSString * str=@"";
    for (int i=0; i<page; i++) {
        str=[str stringByAppendingString:kFile100Char];
    }
    for (int j =0; j<restChar; j++) {
        str=[str stringByAppendingString:kFile1Char];
    }
    return [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

+(long) bytesToInt:(Byte[]) ary offset:(int) pOffset
{
    long value;
    value = (long) ((ary[pOffset]&0xFF)
                   | ((ary[pOffset+1]<<8) & 0xFF00)
                   | ((ary[pOffset+2]<<16)& 0xFF0000)
                   | ((ary[pOffset+3]<<24) & 0xFF000000));
    return value;
}
+(long) bytes2long:(Byte[] )b {
    long temp = 0;
    long res = 0;
    for (int i=0;i<8;i++) {
        res <<= 8;
        temp = b[i] & 0xff;
        res |= temp;
    }
    return res;
}
+(NSDictionary *) getFileDicWithInfoStr:(NSString *) pInfoStr
{
    NSMutableDictionary * rDic=[NSMutableDictionary dictionary];
    rDic[kFileCmdRaw]=pInfoStr;
    NSArray * tArr=[pInfoStr componentsSeparatedByString:kFileNewSplit];
    NSString * tStr=tArr[0];
    long long index=[[self class] indexofLineWithStr:tStr];
    
    rDic[kFileCmdTimeStr]=[tStr substringWithRange:NSMakeRange(0, index)];
    rDic[kFileCmdName]=[tStr substringWithRange:NSMakeRange(index+1, tStr.length-index-1)];
    rDic[kFileCmdLength]=tArr[1];
    rDic[kFileCmdLengthIndex]=tArr[2];
    return rDic;
}
+(long long) indexofLineWithStr:(NSString *)pDataStr
{
    long long isLineNumber=-1;
    
    for (long long i = 0; i < [pDataStr length]; i++)
    {
        if (kFileNewTimeSplit ==[pDataStr characterAtIndex:i])
        {
            isLineNumber=i;
            break;
        }
    }
    return isLineNumber;
}
+(void) DoGoableCacheWithCommand:(NSString *) tCmd WithArray:(NSArray *) pDataArray
{
    
    //如果是现场包
    if ([kCmdType_now_req isEqualToString:tCmd]) {
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]=pDataArray;
        struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
        
        [AppDelegate GetAppDelegate].mGoalDic[kDic_Mechanical_origin_now_dic]=[NSMutableArray arrayWithObjects:kDefDK,[NSString stringWithFormat:@"%d",sp.para.gui.XMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.YMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.ZMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_X],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Y],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Z], nil];
        //
        //缓存
//        [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_Mechanical_origin_resp]=[[CmdMechanicalOriginResp alloc] convertFromArray:pDataArray];

     
        [[self class] doCacheBedWithStr:sp WithArray: pDataArray];
        [[self class] doCacheHeaderWithStr:sp WithArray:pDataArray];
        [[self class] doCacheHeaderSetWithStr:sp WithArray:pDataArray];
        [[self class] doCacheAxisWithStr:sp WithArray:pDataArray];
        [[self class] doCacheBedNowWithStr:sp WithArray:pDataArray];
        [[self class] doCacheDefEWithStr:sp WithArray:pDataArray];
    }
    //如果是轴包
    else if ([kCmdType_axis_req_resp isEqualToString:tCmd]) {
        //缓存轴设置包
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayX]=[NSString stringWithFormat:@"%.3f",[pDataArray[1] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayY]=[NSString stringWithFormat:@"%.3f",[pDataArray[2] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZ]=[NSString stringWithFormat:@"%.3f",[pDataArray[3] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayC]=[NSString stringWithFormat:@"%.3f",[pDataArray[4] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayW]=[NSString stringWithFormat:@"%.3f",[pDataArray[5] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_X]=[NSString stringWithFormat:@"%.3f",[pDataArray[6] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Y]=[NSString stringWithFormat:@"%.3f",[pDataArray[7] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Z]=[NSString stringWithFormat:@"%.3f",[pDataArray[8] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_C]=[NSString stringWithFormat:@"%.3f",[pDataArray[9] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_W]=[NSString stringWithFormat:@"%.3f",[pDataArray[10] doubleValue]/1000.0f];
        if (pDataArray.count>=17) {
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[11] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[12] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZT]=[NSString stringWithFormat:@"%.3f",[pDataArray[13] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[14] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[15] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZT]=[NSString stringWithFormat:@"%.3f",[pDataArray[16] doubleValue]/1000.0f];
        }
        
        NSMutableArray * tArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray];
        //有接到过现场包
        if (tArray.count>0) {
            struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
            sp.status.CurPos.X_Int=[pDataArray[1] integerValue];
            sp.status.CurPos.Y_Int=[pDataArray[2] integerValue];
            sp.status.CurPos.Z_Int=[pDataArray[3] integerValue];
            sp.status.CurPos.C_Int=[pDataArray[4] integerValue];
            sp.status.CurPos.W_Int=[pDataArray[5] integerValue];
            sp.status.CurWorkPos.X_Int=[pDataArray[6] integerValue];
            sp.status.CurWorkPos.Y_Int=[pDataArray[7] integerValue];
            sp.status.CurWorkPos.Z_Int=[pDataArray[8] integerValue];
            sp.status.CurWorkPos.C_Int=[pDataArray[9] integerValue];
            sp.status.CurWorkPos.W_Int=[pDataArray[10] integerValue];
            
            if (pDataArray.count>=17) {
                sp.status.CurPos.ZP1_Int=[pDataArray[11] integerValue];
                sp.status.CurPos.ZP2_Int=[pDataArray[12] integerValue];
                sp.status.CurPos.ZT_Int=[pDataArray[13] integerValue];
                sp.status.CurWorkPos.ZP1_Int=[pDataArray[14] integerValue];
                sp.status.CurWorkPos.ZP2_Int=[pDataArray[15] integerValue];
                sp.status.CurWorkPos.ZT_Int=[pDataArray[16] integerValue];
                
//                sp.status.LittleZMechPos.ZP1SynthCoord=[pDataArray[11] integerValue];
//                sp.status.LittleZMechPos.ZP2SynthCoord=[pDataArray[12] integerValue];
//                sp.status.LittleZMechPos.ZTSynthCoord=[pDataArray[13] integerValue];
//                sp.status.LittleZWorkPos.ZP1SynthCoord=[pDataArray[14] integerValue];
//                sp.status.LittleZWorkPos.ZP2SynthCoord=[pDataArray[15] integerValue];
//                sp.status.LittleZWorkPos.ZTSynthCoord=[pDataArray[16] integerValue];
            }
            
            NSMutableArray * newArray=[ServerForDevices encodeArrayNewWithDataStruct:sp];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]=newArray;
        }
       [((CmdAxisResp *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_axis_req_resp])updateWithArray:pDataArray];
    }
    //轴设置全局参数
    else if([kCmdType_axisset_req isEqualToString:tCmd])
    {
#pragma mark modi
        //缓存轴设置包
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayX]=[NSString stringWithFormat:@"%.3f",[pDataArray[1] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayY]=[NSString stringWithFormat:@"%.3f",[pDataArray[2] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZ]=[NSString stringWithFormat:@"%.3f",[pDataArray[3] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayC]=[NSString stringWithFormat:@"%.3f",[pDataArray[4] doubleValue]/1000.0f];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayW]=[NSString stringWithFormat:@"%.3f",[pDataArray[5] doubleValue]/1000.0f];
        //
        if (pDataArray.count>=8) {
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",[pDataArray[6] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",[pDataArray[7] doubleValue]/1000.0f];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZT]=[NSString stringWithFormat:@"%.3f",[pDataArray[8] doubleValue]/1000.0f];
        }

        
        NSMutableArray * tArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray];
        //有接到过现场包
        if (tArray.count>0) {
            struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
            sp.status.CurPos.X_Int=[pDataArray[1] integerValue];
            sp.status.CurPos.Y_Int=[pDataArray[2] integerValue];
            sp.status.CurPos.Z_Int=[pDataArray[3] integerValue];
            sp.status.CurPos.C_Int=[pDataArray[4] integerValue];
            sp.status.CurPos.W_Int=[pDataArray[5] integerValue];
            //
            if (pDataArray.count>=8) {
                sp.status.CurPos.ZP1_Int=[pDataArray[6] integerValue];
                sp.status.CurPos.ZP2_Int=[pDataArray[7] integerValue];
                sp.status.CurPos.ZT_Int=[pDataArray[8] integerValue];
//                  sp.status.LittleZMechPos.ZP1SynthCoord=[pDataArray[6] integerValue];
//                 sp.status.LittleZMechPos.ZP2SynthCoord=[pDataArray[7] integerValue];
//                 sp.status.LittleZMechPos.ZTSynthCoord=[pDataArray[8] integerValue];
            }
            NSMutableArray * newArray=[ServerForDevices encodeArrayNewWithDataStruct:sp];
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]=newArray;
        }
        //
        [((CmdSetReq *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_axisset_req])updateWithArray:pDataArray];
    }
    //如果行号
    else if([kCmdType_linenumber_req_resp isEqualToString:tCmd])
    {
        struct ScenePackage sp= [ServerForDevices decodeArrayNewWithDataArray:[AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]];
        sp.status.CurModeCode.PrintLineNum=[pDataArray[1] integerValue];
        NSMutableArray * newArray=[ServerForDevices encodeArrayNewWithDataStruct:sp];
        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySceenArray]=newArray;
        //
       [((CmdLinenumberResp *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_linenumber_req_resp])updateWithArray:pDataArray];
    }
    //速率
    else if ([kCmdType_speed_resp isEqualToString:tCmd]) {
//        NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speedin];
        if ([kCmdType_speedset_commonTpye_in isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedin,pDataArray[2]]]=pDataArray[3];
            
            //
          CmdSpeedResp * FSpeed=  [((CmdSpeedResp*)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speed_resp][kCmdType_speedset_commonTpye_in]) updateWithArray:pDataArray];
            //这个不用
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetF]=  [NSString stringWithFormat:@"%.3f",[FSpeed.value integerValue]/1000.0];
            //加
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayF]=  [NSString stringWithFormat:@"%.3f",[FSpeed.value integerValue]/1000.0];
        }else if ([kCmdType_speedset_commonTpye_out isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedout,pDataArray[2]]]=pDataArray[3];
            //1,2,3,4->0,1,2,3
            int indexRaw= [pDataArray[2] integerValue];
            int index=indexRaw-1;
            
            NSMutableArray * tArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speed_resp][kCmdType_speedset_commonTpye_out];
            if (tArray.count>=(index-1)) {
                [((CmdSpeedReq *)tArray[index]) updateWithArray:pDataArray];
                //e值
                if(index==0)
                {
                    
                    //更新全局
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp1]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedResp *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==1)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp2]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedResp *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==2)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp3]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedResp *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==3)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp4]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedResp *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }
            }


        }
    }
    //速率设置
    else if([kCmdType_speedset_req isEqualToString:tCmd])
    {
//        NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speedout];
        if ([kCmdType_speedset_commonTpye_in isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedout,pDataArray[2]]]=pDataArray;
            
            //
            CmdSpeedReq * fSpeed= [((CmdSpeedReq*)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_in]) updateWithArray:pDataArray];
            
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetF]=fSpeed.value;
        }else if ([kCmdType_speedset_commonTpye_out isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedout,pDataArray[2]]]=pDataArray;
            
            //
            int indexRaw= [pDataArray[2] integerValue];
            int index=indexRaw-1;
            NSMutableArray * tArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_out];
            if (tArray.count>=(index-1)) {
                [((CmdSpeedReq *)tArray[index]) updateWithArray:pDataArray];
                //e值
                if(index==0)
                {
                    //更新全局
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp1]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedReq *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==1)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp2]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedReq *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==2)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp3]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedReq *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }else if(index==3)
                {
                    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp4]=[NSString stringWithFormat:@"%.3f",[((CmdSpeedReq *)tArray[index]).value integerValue]/1000.0f];//((CmdSpeedReq *)tArray[index]).value;
                }
            }
        }else if ([kCmdType_speedset_commonTpye_axis_zero isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedout,pDataArray[2]]]=pDataArray;
            
            //
            NSMutableArray * tArrayzero=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_axis_zero];
            int index= [pDataArray[2] integerValue];
            
//            NSMutableArray * tArrayzero=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_out];
            
            if (tArrayzero.count>=(index-1)) {
                [((CmdSpeedReq *)tArrayzero[index]) updateWithArray:pDataArray];
              
            }
            
        }else if ([kCmdType_speedset_commonTpye_axis_click isEqualToString:pDataArray[1]]) {
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_speedout,pDataArray[2]]]=pDataArray;
            //这个不用
        }
    }
    //温度
    else if([kCmdType_temp_req_resp isEqualToString:tCmd])
    {
        if ([kCmdType_temp_commonType_broad isEqualToString:pDataArray[1]]) {
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speed_temp_broad];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@",kDic_speed_temp_broad,pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            NSMutableArray * tArrayBroad=  [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_temp_req_resp][kCmdType_temp_commonType_broad];
            
            for (int i=0; i<tArrayBroad.count; i++) {
                CmdTempResp * itemObj=tArrayBroad[i];
                if ([itemObj.number isEqualToString:pDataArray[2]]&& [itemObj.offset isEqualToString:pDataArray[3]]) {
                    [itemObj updateWithArray:pDataArray];
                    break;
                }
            }
        }else if ([kCmdType_temp_commonType_printer isEqualToString:pDataArray[1]]) {
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speed_temp_printer];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@",kDic_speed_temp_printer,pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            NSMutableArray * tArrayPrinter=  [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_temp_req_resp][kCmdType_temp_commonType_printer];
            for (int i=0; i<tArrayPrinter.count; i++) {
                CmdTempResp * itemObj=tArrayPrinter[i];
                if ([itemObj.number isEqualToString:pDataArray[2]]&& [itemObj.offset isEqualToString:pDataArray[3]]) {
                    [itemObj updateWithArray:pDataArray];
                    break;
                }
            }
            
        }
//        [((CmdSpeedResp*)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speed_resp][kCmdType_speedset_commonTpye_in]) updateWithArray:pDataArray];
    }
    //温度设置
    else if([kCmdType_tempset_req isEqualToString:tCmd])
    {
        if ([kCmdType_temp_commonType_broad isEqualToString:pDataArray[1]]) {
//             NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speed_temp_req_broad];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@",kDic_speed_temp_req_broad,pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            NSMutableArray * tArrayBroad=  [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_tempset_req][kCmdType_temp_commonType_broad];
            for (int i=0; i<tArrayBroad.count; i++) {
//                NSLog(@"kCmdType_tempset_req pDataArray :%@",pDataArray);
                CmdTempReq * itemObj=tArrayBroad[i];
                if ([itemObj.number isEqualToString:pDataArray[2]]&& [itemObj.offset isEqualToString:pDataArray[3]]) {
                    [itemObj updateWithArray:pDataArray];
                    break;
                }
            }
        }else if ([kCmdType_temp_commonType_printer isEqualToString:pDataArray[1]]) {
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_speed_temp_req_printer];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@",kDic_speed_temp_req_printer,pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            NSMutableArray * tArrayPrinter=  [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_tempset_req][kCmdType_temp_commonType_printer];
            for (int i=0; i<tArrayPrinter.count; i++) {
                CmdTempReq * itemObj=tArrayPrinter[i];
                if ([itemObj.number isEqualToString:pDataArray[2]]&& [itemObj.offset isEqualToString:pDataArray[3]]) {
                    [itemObj updateWithArray:pDataArray];
                    break;
                }
            }
        }
        
    }
    //错误包
    else if([kCmdType_error_resp isEqualToString:tCmd])
    {
        if (pDataArray.count>0) {
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_NUMBER]=pDataArray[1];
        }
        if (pDataArray.count>1)
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_alert_Value]=pDataArray[2];
        if (pDataArray.count>2)
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_HOT_NUMBER]=pDataArray[3];
        if (pDataArray.count>3)
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_HOT_OFFSET]=pDataArray[4];
        if (pDataArray.count>4)
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_Head_NUMBER]=pDataArray[5];
        if (pDataArray.count>5)
            [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayERROR_Head_OFFSET]=pDataArray[6];
    }
    //打印头序列包
    else if([kCmdType_printerset_req isEqualToString:tCmd])
    {
        NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_printerset_req];
        tDc[[NSString stringWithFormat:@"%@_%@",kDic_printerset_req,pDataArray[1]]]=pDataArray;
    }
    //门
    else if([kCmdType_door_req isEqualToString:tCmd])
    {
        //前门
        if([kCmdType_door_CommonType_index_Font isEqualToString:pDataArray[1]])
        {
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Font_req];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Font_req,pDataArray[1]]]=pDataArray;
            //
             [((CmdIOReq *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][kCmdType_door_CommonType_index_Font])updateWithArray:pDataArray];
            //后面
        }else  if([kCmdType_door_CommonType_index_Back isEqualToString:pDataArray[1]]){
            
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Back_req];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Back_req,pDataArray[1]]]=pDataArray;
            //
            [((CmdIOReq *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][kCmdType_door_CommonType_index_Back])updateWithArray:pDataArray];
            //打印头上下
        }else if([pDataArray[1] integerValue]>kCmdType_mouth_CommonType_index_OffSet&&[pDataArray[1] integerValue]<=(kCmdType_mouth_CommonType_index_OffSet+16)){
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Font_req];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@_%@",kDic_door_Font_req,pDataArray[1],pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][pDataArray[1]]=[[CmdIOReq alloc]convertFromArray:pDataArray];
            //挤料
        }else if([pDataArray[1] integerValue]>kCmdType_mouth_Oil_CommonType_index_OffSet&&[pDataArray[1] integerValue]<=(kCmdType_mouth_Oil_CommonType_index_OffSet+16)){
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Back_req];
//            tDc[[NSString stringWithFormat:@"%@_%@_%@_%@",kDic_door_Back_req,pDataArray[1],pDataArray[2],pDataArray[3]]]=pDataArray;
            //
            [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Back_req][pDataArray[1]]=[[CmdIOReq alloc]convertFromArray:pDataArray];
        }
        
        
    }
    //门操作
    else if([kCmdType_door_resp isEqualToString:tCmd])
    {
        //前门
        if([kCmdType_door_CommonType_index_Font isEqualToString:pDataArray[1]])
        {
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Font_resp];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Font_resp,pDataArray[1]]]=pDataArray;
            //
            [((CmdIOResp *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Font_resp][kCmdType_door_CommonType_index_Font])updateWithArray:pDataArray];
            //后面
        }else  if([kCmdType_door_CommonType_index_Back isEqualToString:pDataArray[1]]){
            
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Back_resp];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Back_resp,pDataArray[1]]]=pDataArray;
            //
            [((CmdIOResp *) [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Font_resp][kCmdType_door_CommonType_index_Back])updateWithArray:pDataArray];
            //打印头上下
        }else if([pDataArray[1] integerValue]>kCmdType_mouth_CommonType_index_OffSet&&[pDataArray[1] integerValue]<=(kCmdType_mouth_CommonType_index_OffSet+16)){
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Font_resp];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Font_resp,pDataArray[1]]]=pDataArray;
            //
            [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Font_resp][pDataArray[1]]=[[CmdIOResp alloc]convertFromArray:pDataArray];
            //挤料
        }else if([pDataArray[1] integerValue]>kCmdType_mouth_Oil_CommonType_index_OffSet&&[pDataArray[1] integerValue]<=(kCmdType_mouth_Oil_CommonType_index_OffSet+16)){
//            NSMutableDictionary * tDc=[AppDelegate GetAppDelegate].mGoalDic[kDic_door_Back_resp];
//            tDc[[NSString stringWithFormat:@"%@_%@",kDic_door_Back_resp,pDataArray[1]]]=pDataArray;
            //
            [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Back_req][pDataArray[1]]=[[CmdIOResp alloc]convertFromArray:pDataArray];
        }
    }
    //机械原点
    else if([kCmdType_Mechanical_origin_resp isEqualToString:tCmd])
    {
        [AppDelegate GetAppDelegate].mGoalDic[kZeroPosArray]=pDataArray;
        //
        [((CmdMechanicalOriginResp *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Back_req][pDataArray[1]])updateWithArray:pDataArray];
    }
    
}
+(NSString *) GetGoableCacheJson
{
    NSString * rString=@"";
   NSDictionary * tDic=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache];
    rString=[tDic JSONString];
    return rString;
}
//缓存打印版温度
+(void)doCacheBedWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    int p=( int)(&sp);
    int pp;
    pp=( int)(&sp.controlCmd.CurTherBedCmd.section1.Resistor1);
    int offset=(pp -p)/4;
    //
    NSMutableArray * tBedArray= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_tempset_req][kCmdType_temp_commonType_broad];
    for (int i=0; i<tBedArray.count; i++) {
        CmdTempReq * obj=tBedArray[i];
        obj.value=pDataArray[i+offset+1];
        
    }
}
//调整温度
+(void)doCacheHeaderSetWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    int p=( int)(&sp);
    int pp;
    pp=( int)(&sp.controlCmd.CurTherHeaderCmd.section1.Resistor1);
    int offset=(pp -p)/4;
    //
    NSMutableArray * tBedArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_tempset_req][kCmdType_temp_commonType_printer];
    
    //一共13组
    int HeaderOne=8;
    int HeaderOneIO=4;
    int HeaderOneOut=1;
    //
    //
    //    for (int i=0; i<(4*(HeaderOne+HeaderOneIO+HeaderOneOut)); i++) {
    //
    //    }
    for (int i=0; i<tBedArray.count; i++) {
        int Line=i/HeaderOne;//第几行
        CmdTempReq * obj=tBedArray[i];
        
        
        int index=i+offset+1+Line*(HeaderOneIO+HeaderOneOut);
        //        NSLog(@"index:%d,index_raw:%d",index,index-offset);
        obj.value=pDataArray[index];
    }
    //顺序颠倒
    for (int i=0; i<tBedArray.count; i++) {
        //        int line=i/8;
        int restCount=i%(HeaderOne);
        //冒泡
        if (restCount<HeaderOneIO) {
            CmdTempReq * obj=tBedArray[i];
            tBedArray[i]=tBedArray[i+4];
            ((CmdTempReq*)tBedArray[i+4]).value=obj.value;
        }
        
    }
}

void doTestData()
{
    NSMutableArray * tArr=[NSMutableArray array];
    for (int i=0; i<32; i++) {
        [tArr addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    NSLog(@"%@",tArr);
    //0->4
    //1->5
    //2->6
    //3->7
    for (int i=0; i<32; i++) {
        //        int line=i/8;
        int restCount=i%(8);
        //冒泡
        if (restCount<4) {
            NSString * obj=tArr[i];
            tArr[i]=tArr[i+4];
            tArr[i+4]=obj;
        }
        
    }
    NSLog(@"%@",tArr);
}

+(void)doCacheHeaderWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    int p=( int)(&sp);
    int pp;
    pp=( int)(&sp.status.CurTherHeaderSts.section1.Resistor1);
    int offset=(pp -p)/4;
    //
    NSMutableArray * tBedArray= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_temp_req_resp][kCmdType_temp_commonType_printer];
    //打印头上下
//    NSMutableArray * tOutArray= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_tempset_req][kCmdType_temp_commonType_printer];

//     [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_resp][[NSString stringWithFormat:@"%d",(kCmdType_mouth_CommonType_index_OffSet+i+1)]]=[CmdIOReq GetDefValue];
    
    //一共13组
    int HeaderOne=8;
    int HeaderOneIO=4;
    int HeaderOneOut=1;
//    
//    
//    for (int i=0; i<(4*(HeaderOne+HeaderOneIO+HeaderOneOut)); i++) {
//        
//    }
    for (int i=0; i<tBedArray.count; i++) {
        int Line=i/HeaderOne;//第几行
        CmdTempResp * obj=tBedArray[i];
        int index=i+offset+1+Line*(HeaderOneIO+HeaderOneOut);
//        NSLog(@"index:%d,index_raw:%d",index,index-offset);
        obj.value=pDataArray[index];
    }
//顺序颠倒
    for (int i=0; i<tBedArray.count; i++) {
        //        int line=i/8;
        int restCount=i%(HeaderOne);
        //冒泡
        if (restCount<HeaderOneIO) {
            CmdTempResp * obj=tBedArray[i];
            tBedArray[i]=tBedArray[i+4];
            ((CmdTempResp*)tBedArray[i+4]).value=obj.value;
        }
        
    }

    
    int HeaderUpDown=4;
    //打印嘴上下
    for (int i=0; i<16; i++) {
        int Line=i/HeaderUpDown;
        int subOffet=i%HeaderUpDown;
        int index=HeaderOne+subOffet+offset+1+Line*(HeaderOne+HeaderOneIO+HeaderOneOut);
//        NSLog(@"index:%d,index_raw:%d",index,index-offset);
        CmdIOReq * req= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][[NSString stringWithFormat:@"%d",(kCmdType_mouth_CommonType_index_OffSet+i+1)]];
        req.value=pDataArray[index];
        
        //打印嘴出料
        CmdIOReq * reqOil= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][[NSString stringWithFormat:@"%d",(kCmdType_mouth_Oil_CommonType_index_OffSet+i+1)]];
        int indexoil=HeaderOne+HeaderOneIO+offset+1+Line*(HeaderOne+HeaderOneIO+HeaderOneOut);
        if (([pDataArray[indexoil] integerValue]==1)&&([req.value integerValue]==1)) {
            reqOil.value=pDataArray[indexoil];
        }else{
            reqOil.value=@"0";
        }

        
    }
    

//    for (int i=0; i<16; i++) {
//        int Line=i/HeaderUpDown;
//        int subOffet=i%HeaderUpDown;
//        int index=HeaderOne+subOffet+offset+1+Line*(HeaderOne+HeaderOneIO+HeaderOneOut);
//        NSLog(@"index:%d,index_raw:%d",index,index-offset);
//        CmdIOReq * req= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_door_req][[NSString stringWithFormat:@"%d",(kCmdType_mouth_Oil_CommonType_index_OffSet+i+1)]];
//        req.value=pDataArray[index];
//    }
    
}
+(void)doCacheAxisWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    //缓存轴设置包
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayX]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.X_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayY]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.Y_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZ]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.Z_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayC]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.C_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayW]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.W_Int/1000.0f];
    
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_X]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.X_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Y]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.Y_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_Z]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.Z_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_C]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.C_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWork_W]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.W_Int/1000.0f];
    //
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.ZP1_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.ZP2_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZT]=[NSString stringWithFormat:@"%.3f",sp.status.CurPos.ZT_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp1]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.ZP1_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp2]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.ZP2_Int/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZT]=[NSString stringWithFormat:@"%.3f",sp.status.CurWorkPos.ZT_Int/1000.0f];
//        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp1]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZMechPos.ZP1SynthCoord/1000.0f];
//        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZp2]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZMechPos.ZP2SynthCoord/1000.0f];
//        [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayZT]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZMechPos.ZTSynthCoord/1000.0f];
//    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp1]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZWorkPos.ZP1SynthCoord/1000.0f];
//    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZp2]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZWorkPos.ZP2SynthCoord/1000.0f];
//    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayWorkZT]=[NSString stringWithFormat:@"%.3f",sp.status.LittleZWorkPos.ZTSynthCoord/1000.0f];
    
    //开始暂停状态
    ((CmdCMReq *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_Cmd_req]).cmd=[NSString stringWithFormat:@"%d",sp.status.RunStatus];
;
    ((CmdCMResp *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_Cmd_resp]).cmd=[NSString stringWithFormat:@"%d",sp.status.RunStatus];

    ((CmdLinenumberResp *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_linenumber_req_resp]).number=[NSString stringWithFormat:@"%d",sp.status.CurModeCode.PrintLineNum];
    //现场
            [((CmdMechanicalOriginResp *)[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kDic_door_Back_req][pDataArray[1]])updateWithArray:pDataArray];
    //ef值显示
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayF]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.FeedMult/1000.0f];
    
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayE_ALL]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.ExtrudeMult_P01/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp1]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.ExtrudeMult_P01/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp2]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.ExtrudeMult_P02/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp3]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.ExtrudeMult_P03/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayEp4]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.ExtrudeMult_P04/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplayMoveG00]=[NSString stringWithFormat:@"%.3f",sp.status.CurMultSts.MovSpeedG00Mult/1000.0f];
    //ef调整值
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetF]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.FeedMult/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp1]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.ExtrudeMult_P01/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp2]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.ExtrudeMult_P02/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp3]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.ExtrudeMult_P03/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetEp4]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.ExtrudeMult_P04/1000.0f];
    [AppDelegate GetAppDelegate].mGoalDic[kGoalDisplaySetMoveG00]=[NSString stringWithFormat:@"%.3f",sp.controlCmd.CurMultCmd.MovSpeedG00Mult/1000.0f];
    
    //[AppDelegate GetAppDelegate].mGoalDic[kDic_Mechanical_origin_now_dic]=[NSMutableArray arrayWithObjects:kDefDK,[NSString stringWithFormat:@"%d",sp.para.gui.XMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.YMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.ZMOVEMENTRANGER],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_X],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Y],[NSString stringWithFormat:@"%d",sp.para.gui.MechanicalOriginOffset_Z], nil];
}
+(void)doCacheBedNowWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    int p=( int)(&sp);
    int pp;
    pp=( int)(&sp.status.CurTherBedSts.section1.Resistor1);
    int offset=(pp -p)/4;
    //
    NSMutableArray * tBedArray= [AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_temp_req_resp][kCmdType_temp_commonType_broad];
    for (int i=0; i<tBedArray.count; i++) {
        CmdTempResp * obj=tBedArray[i];
        obj.value=pDataArray[i+offset+1];
        
    }
    //轴清零的值
    NSMutableArray * tZeroArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_axis_zero];
//    for (int i=0; i<tZeroArray.count; i++) {
//        
//    }
    CmdSpeedReq * XSp=[tZeroArray objectAtIndex:0];
    XSp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.X_Int];
    
    CmdSpeedReq * YSp=[tZeroArray objectAtIndex:1];
    YSp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.Y_Int];
    
    CmdSpeedReq * Zp1Sp=[tZeroArray objectAtIndex:2];
    Zp1Sp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.ZP1_Int];
    
    CmdSpeedReq * CSp=[tZeroArray objectAtIndex:3];
    CSp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.C_Int];
    
    CmdSpeedReq * WSp=[tZeroArray objectAtIndex:4];
    WSp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.W_Int];
    
    if (tZeroArray.count>5) {
        CmdSpeedReq * Zp2Sp=[tZeroArray objectAtIndex:5];
        Zp2Sp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.ZP2_Int];
    }
    
    if (tZeroArray.count>6)
    {
    CmdSpeedReq * ZtSp=[tZeroArray objectAtIndex:6];
    ZtSp.value= [NSString stringWithFormat:@"%d",sp.para.WorkCoordOffset.ZT_Int];
    }

}
//默认E值
+(void)doCacheDefEWithStr:(struct ScenePackage) sp WithArray:(NSArray *) pDataArray
{
    int p=( int)(&sp);
    int pp;
    pp=( int)(&sp.status.CurMultSts.ExtrudeMult_P01);
    int offset=(pp -p)/4;
    
    NSMutableArray  * tEArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_out];
    for (int i=0; i<tEArray.count; i++) {
        CmdSpeedReq * obj=tEArray[i];
        obj.value=[NSString stringWithFormat:@"%f",[pDataArray[i+offset+1] integerValue]/1000.0f];
    }
      ((CmdSpeedReq *)[ AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speedset_req][kCmdType_speedset_commonTpye_in]).value=[NSString stringWithFormat:@"%f",sp.status.CurMultSts.FeedMult/1000.0f];
    
    int pp2;
    pp2=( int)(&sp.controlCmd.CurMultCmd.ExtrudeMult_P01);
    int offset2=(pp2 -p)/4;
    
    NSMutableArray  * tESetArray=[AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speed_resp][kCmdType_speedset_commonTpye_out];
    for (int i=0; i<tESetArray.count; i++) {
        CmdTempResp * obj=tESetArray[i];
        obj.value=[NSString stringWithFormat:@"%f",[pDataArray[i+offset2+1] integerValue]/1000.0f];
    }
    ((CmdTempResp *)[ AppDelegate GetAppDelegate].mGoalDic[kGoalBeanCache][kCmdType_speed_resp][kCmdType_speedset_commonTpye_in]).value=[NSString stringWithFormat:@"%f",sp.controlCmd.CurMultCmd.FeedMult/1000.0f];
    
    
}

@end
