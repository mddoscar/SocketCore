/*
 * ShareData.h
 *
 *  Created on: 2016ƒÍ11‘¬30»’
 *  Author: Administrator
 *  version:2017-5-22-09-25
 */

#ifndef SHAREDATA_H_
#define SHAREDATA_H_

//
#include <string.h>
#include <stdio.h>

//------------------

 typedef struct{
	int X_Int;
	int Y_Int;
	int Z_Int;
	int C_Int;
	int W_Int;
	int ZP1_Int;
	int ZP2_Int;
	int ZT_Int;
 
 }AxisPosInt;    //÷·◊¯±Í
 
// typedef struct{
//	double X_Float;
//	double Y_Float;
//	double Z_Float;
//	double C_Float;
//	double W_Float;
//	double ZP1_Float;
//	double ZP2_Float;
//	double ZT_Float;
// }AxisPosFloat;    //÷·◊¯±Í



typedef struct{
    int Axis_X1;
    int Axis_X2;
    int Axis_X3;
    int Axis_X4;
    int Axis_Y1;
    int Axis_Y2;
    int Axis_BIGZ1;
    int Axis_BIGZ2;
    int Axis_BIGZ3;
    int Axis_BIGZ4;
    int Axis_ZP1;
    int Axis_ZP2;
    int Axis_ZT;
    int Axis_C;
    int Axis_W;
    int Printer1;
    int Printer2;
}ServoArray;

typedef struct{
    ServoArray Coord;
    ServoArray Speed;
    ServoArray Torque;
    ServoArray ErrNum;
    
}ServoInfo;

typedef struct{
    int Resistor1;
    int Resistor2;
    int Resistor3;
    int Resistor4;
    int Resistor5;   //thermal value cmd
    
}BedSection;          //√øøÈº”»»∞Â”–5∏ˆº”»»Àø


typedef struct{
    int Resistor1;   //thermal value cmd
    int Resistor2;
    int Resistor3;
    int Resistor4;
    int Resistor5;
    int Resistor6;
    int Resistor7;
    int Resistor8;
    int Injector1;   // injector switch   0:close  1:open
    int Injector2;
    int Injector3;
    int Injector4;
    int Extrude; 	   // extrued motor switch  0:stop  1: extrued
    
}HeaderSection;

typedef struct{
    unsigned int FeedMult;
    unsigned int MovSpeedG00Mult;
    unsigned int ExtrudeMult_P01;
    unsigned int ExtrudeMult_P02;
    unsigned int ExtrudeMult_P03;
    unsigned int ExtrudeMult_P04;
    
}MultData;


typedef struct{
    unsigned int FrontDoor;  //inout
    unsigned int BackDoor;   //inout
    unsigned int MaterialFeed; //input
    unsigned int ExtrudeMult;   // input
    unsigned int EmergStop;	//input
    unsigned int ServoErrIn;   //input
    unsigned int lubrication;   //input
    unsigned int Lighting;// input
    
    
    
}GPIOCtrl;
//----------◊¥Ã¨ ˝æ›Ω·ππ∂®“Âº∞Ω‚ Õ----------------------
typedef struct{
    
    unsigned int  PrintLineNum;    //line num in all code
    unsigned int  LayerLineNum; //line num in layer
    unsigned int  CurPValue;	  //Pƒ£Ã¨
    unsigned int  CurTValue;	  //Tƒ£Ã¨
    unsigned int  CurEValue;     //E÷µ
    unsigned int  CurFValue;     //F÷µ
    unsigned int  CurGValue;
    
    
}ModeCode;  //µ±«∞ƒ£Ã¨÷∏¡Ó/œ÷≥°–≈œ¢



typedef struct{
    BedSection section1;
    BedSection section2;
    BedSection section3;
    BedSection section4;
    BedSection section5;
    BedSection section6;
    BedSection section7;
    BedSection section8;
    
}TherBedSts;      //»»¥≤”–∞ÀøÈ



typedef struct{
    HeaderSection section1;
    HeaderSection section2;
    HeaderSection section3;
    HeaderSection section4;
    
}TherHeaderSts;

typedef struct{
    unsigned int CurErrNum;  //0 ’˝≥£  1 À≈∑˛±®æØ  2 ¥Ú”°Õ∑Œ¬∂»±®æØ 3 ∂¡»°FIFO ˝æ›¥ÌŒÛ 4£∫≤Â≤πÀŸ∂»πÊªÆ≥ˆ¥Ì 5°£°£
    unsigned int CurErrServo;       //±®æØ«˝∂Ø∆˜–Ú∫≈ £®∞¥’’XYZCWµƒƒ⁄≤øÀ≥–Ú£©
    unsigned int ServoErrNum;       //À≈∑˛±®æØ∫≈   £®≤Œ’’À≈∑˛ ÷≤·£©
    unsigned int CurWarning;    //0:NO WARNING  1:»ÌœﬁŒª       2;≥ı º…œµÁZP1 ZP2  ZT –°÷· ¥¶‘⁄…Ë∂®µƒªÓ∂Ø∑∂Œß÷ÆÕ‚ £¨¥˝∏¥Œª
    unsigned int CurErrBedReisitos; //π ’œº”»»Àø–Ú∫≈  1-5
    unsigned int CurErrBedSetion; // π ’œº”»»øÈ–Ú∫≈  1-8
    unsigned int CurErrHeaderResistor;//π ’œº”»»Àø–Ú∫≈  1-6
    unsigned int CurErrHeaderSetion;//π ’œº”»»øÈ–Ú∫≈  1-4
    
}SystemErr;

typedef struct{
    int Data1;
    int Data2;
    int Data3;
    int Data4;
    int Data5;
}DisTestData;

typedef struct{
    int Data1;
    int Data2;
    int Data3;
    int Data4;
    int Data5;
    int Data6;
    int Data7;
    int Data8;
    
}RsvStatusGroup;

typedef struct{
    RsvStatusGroup Group1;
    RsvStatusGroup Group2;
    RsvStatusGroup Group3;
    RsvStatusGroup Group4;
    RsvStatusGroup Group5;
    RsvStatusGroup Group6;
    RsvStatusGroup Group7;
    RsvStatusGroup Group8;
    
    
}RsvStatusPage;


typedef struct{
    
    
    unsigned int  SystemMode;  // 0 hand mode (include wheel and phone move,preemption mechanism  internal )  1 code  free  run mode   2 phone shift mode  3 : mdi
    unsigned int  RunStatus;   // 0 stop  1 run  2  pause
    unsigned int  DragStatus;  // 0: not run    1:runing
    SystemErr CurSystemErr;
    AxisPosInt  CurPos;
    AxisPosInt  CurWorkPos;
    unsigned int CurrentLittleZ;  //0: zp1   1:zp2   2:ZT
    ModeCode CurModeCode;
    TherBedSts  CurTherBedSts;
    TherHeaderSts CurTherHeaderSts;
    RsvStatusPage CurRsvStatusPage;
    DisTestData CurDisTestData;
    GPIOCtrl CurGPIOCtrlSts;
    unsigned int ZynqRunFlag;       //  0x55aa :zynq init ok
    unsigned int HandInterpRunFlag; //0:idle; 1:running
    unsigned int ServoCtrlMode;      //0: //---XYZCW ctrl  mode  1:X Y Z ZP1 ZP2 ZT CW ctrl mode   2: servo debug mode
    MultData CurMultSts;
    unsigned int RealG00MovSpeed;
    unsigned int RealG01MovSpeed;
    ServoInfo AllServoInfo;
    AxisPosInt  WorkCoordOffset;
} PrtStatus;

//--------------√¸¡Ó ˝æ›Ω·ππ∂®“Âº∞Ω‚ Õ------------------



typedef struct{
    
    //---¬ˆ≥Âƒ£ Ω
    unsigned int QepCnt;     //√ø¥´ÀÕ“ª¥Œ£¨«Â0£¨Œ¿€º”
    unsigned int QepDir;     //∑ΩœÚ  0£∫∏∫  1  ’˝
    unsigned int HandMult;   //±∂¬   1/10/100
    unsigned int AxisChan;   //÷·—°‘Ò  XYZCW
    
    
    
}MoveCmd;                   //“∆∂Øœ‡πÿ√¸¡Ó



typedef struct{
    unsigned int  RunCmd;       	//pulse only
    unsigned int  StopCmd;      	//pulse only
    unsigned int  PauseCmd;     	//pulse only
    unsigned int  ResetCmd;     	//pulse only
    unsigned int  ResetFifoCmd;    //pulse only
    unsigned int  ModeSelect;  // 0:reserve   1 code  free  run mode   2 phone shift mode  3 : mid    4 axis  calibration mode
    
    
    
}AutoModeCmd;

typedef struct{
    unsigned int  AxisXSetCmd;       	//pulse only
    unsigned int  AxisYSetCmd;      	//pulse only
    unsigned int  AxisZSetCmd;     	   //pulse only
    unsigned int  AxisCSetCmd;     	   //pulse only
    unsigned int  AxisWSetCmd;        //pulse only
    unsigned int  AxisZP1SetCmd;      //pulse only
    unsigned int  AxisZP2SetCmd;       //pulse only
    unsigned int  AxisZTSetCmd;       //pulse only
    
}AxisSetCmd;

typedef struct{
    BedSection section1;
    BedSection section2;
    BedSection section3;
    BedSection section4;
    BedSection section5;
    BedSection section6;
    BedSection section7;
    BedSection section8;
    
}TherBedCmd;      //»»¥≤”–∞ÀøÈ



typedef struct{
    HeaderSection  section1;
    HeaderSection  section2;
    HeaderSection  section3;
    HeaderSection  section4;
    
}TherHeaderCmd;




typedef struct{
    MoveCmd CurMoveCmd;
    AutoModeCmd   CurAutoModeCmd;
    TherBedCmd CurTherBedCmd;
    TherHeaderCmd CurTherHeaderCmd;
    GPIOCtrl CurGPIOCtrlCmd;
    AxisSetCmd CurAxisSetCmd;
    MultData  CurMultCmd;
    unsigned int  ServoONCmd;      //pulse only
    unsigned int  ServoOffCmd;     //pulse only
    
    
    
} PrtCmd;

//-----------≤Œ ˝ ˝æ›Ω·ππ∂®“Âº∞Ω‚ Õ-----------------------
//
typedef struct{
    int OffsetX;
    int OffsetY;
    int OffsetZ;
    int PrinterIndex;
    
} AxisOffset;

typedef struct{
    AxisOffset Injector1;
    AxisOffset Injector2;
    AxisOffset Injector3;
    AxisOffset Injector4;
}HeaderOffset;

typedef struct{
    HeaderOffset Header1;
    HeaderOffset Header2;
    HeaderOffset Header3;
    HeaderOffset Header4;
    AxisOffset Knife;
} OffsetPara;


typedef struct{
    int Data1;
    int Data2;
    int Data3;
    int Data4;
    int Data5;
    int Data6;
    int Data7;
    int Data8;
    
    
}RsvParaGroup;

typedef struct{
    RsvParaGroup Group1;
    RsvParaGroup Group2;
    RsvParaGroup Group3;
    RsvParaGroup Group4;
    RsvParaGroup Group5;
    RsvParaGroup Group6;
    RsvParaGroup Group7;
    RsvParaGroup Group8;
}RsvParaPage;

typedef struct{
    
    int XMOVEMENTRANGER;
    int YMOVEMENTRANGER;
    int ZMOVEMENTRANGER;
    int MechanicalOriginOffset_X;
    int MechanicalOriginOffset_Y;
    int MechanicalOriginOffset_Z;
    
}Gui;

typedef struct{
    
    OffsetPara  CurOffsetPara;
    RsvParaPage CurRsvParaPage;
    AxisPosInt  WorkCoordOffset;
    unsigned int  MovSpeedG00;		  //G00 “∆∂ØÀŸ∂»
    unsigned int  MovSpeedG01;		  //G01 Ω¯∏¯ÀŸ∂»
    Gui gui;
    
    
}PrtPara;

//---------G¥˙¬Î ˝æ›Ω·ππ∂®“Âº∞Ω‚ Õ-------------------------

typedef struct{
    unsigned int  code_start;  // 0x55aa
    unsigned int  line_num;
    unsigned int  codedata[32]; //“ª∏ˆ32Œªunsigned int ◊∞4∏ˆchar,
    
} PrtCodeFifo;



typedef struct{
    
    unsigned int WriteFifo;
    unsigned int FifoNum;   // zynq »°”√÷∏ æ±‰¡ø
    
} PrtCodeBlock;


//--------------------------------------------
#define INTFC_BASEADDR    (0x40000000)
#define STATUS_ADDR   ( PrtStatus *) (INTFC_BASEADDR)
#define CMD_ADDR      ( PrtCmd *) (INTFC_BASEADDR+0x400)
#define PARA_ADDR     ( PrtPara *) (INTFC_BASEADDR+0x800)
#define CODE_ADDR     ( PrtCodeBlock *) (INTFC_BASEADDR+0x1000)


//----------------------------------
void ShareDataTask(void);
void ShareDataInit(void);





#endif /* SHAREDATA_H_ */
