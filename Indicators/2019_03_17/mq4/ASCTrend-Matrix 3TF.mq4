/*------------------------------------------------------------------------------------
   Name: ASCTrend-Matrix 3TF.mq4
   
   Description: Three timeframe ASCTrend Matrix:

	Note:
	   Requires that the following indicators are installed and working:
	   ASCTrend1i.mq4,
   
   Change log:
       2014-02-11. Xaphod, v1.600
          - Update for MT4.5
          - Added alert sounds for buy and sell
          - Removed custom indicator check which will not work with sub-folders
       2013-11-28. Xaphod, v1.10
          - Upgraded code to support MT4 build 550 and greater and retain compatiblilty with build 500
       2013-05-03. Xaphod, v1.01
         - Fixed updating of bars on all timeframes as new data is being downloaded.
         - Draw blank dot if there is not data for the bar.
       2013-04-??. Xaphod, v1.00
-------------------------------------------------------------------------------------*/
// Indicator properties
#property copyright "Copyright © 2012, Xaphod"
#property link      "http://www.xaphod.com"
#property version    "1.600"
#property strict
#property description "3 TimeFrame Matrix Chart of the ASCTrend1 indicator."
#property description "For information on the AscTrend indicator go to: "
#property description "    www.forex-tsd.com/move/598-asctrend-system.html"
#property description " "
#property description "Requirements: The following indicator must installed and working: ASCTrend1i.mq4"
#property description " "
#property description "Troubleshooting: Check the 'Journal' and 'Expert' tabs in the terminal window for errors."
#property description " "
#property description "Misc: To use the 'Alert_Sound' together with the 'Alert_Popup', disable the alert sound in the"
#property description "          'Tools/Options/Events' tab, otherwise the Alert_Sound will not play."

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 DodgerBlue
#property indicator_color4 Red
#property indicator_color5 DodgerBlue
#property indicator_color6 Red
#property indicator_minimum 0
#property indicator_maximum 1.4

//#include <xDebug.mqh>

// Constant definitions
#define INDICATOR_NAME "ASCTrend-3TF"
#define INDICATOR_VERSION "1.600"
#define MATRIX_CHAR 110

#define IND_ASCTREND  "ASCTrend1i"

#define MATRIX_ROWS 3  // Max rows in the Matrix
#define IDX_R1 0  // TF1
#define IDX_R2 1  // TF2
#define IDX_R3 2  // TF2
 
// Indicator parameters
extern string    TimeFrame_Settings="——————————————————————————————"; /* TimeFrame Settings */
extern ENUM_TIMEFRAMES TimeFrame1_Period=PERIOD_CURRENT;       /* TimeFrame1 Period */ // Timeframe: 0,1,5,15,30,60,240,1440 etc. Current Timeframe=0. 
extern ENUM_TIMEFRAMES TimeFrame2_Period=PERIOD_CURRENT;       /* TimeFrame2 Period */ // Timeframe: 0,1,5,15,30,60,240,1440 etc. Current Timeframe=0. 
extern ENUM_TIMEFRAMES TimeFrame3_Period=PERIOD_CURRENT;       /* TimeFrame3 Period */ 
extern ENUM_TIMEFRAMES TimeFrame4_Period=PERIOD_CURRENT;       /* TimeFrame4 Period */ 
extern bool      TimeFrame_Auto=True;       /* TimeFrame Auto Select */ // Automatically select higher TF for second line
extern string    ASCTrend_Settings="——————————————————————————————"; /* Indicator Settings */
extern int       ASCTrend_Risk=6;           /* ASCTrend Risk */ // ASCTrend1 risk setting
extern string    Alert_Settings="——————————————————————————————"; /* Alert Settings */
extern bool      Alert_OnBarClose=True;     /* Alert - On Bar Close */ // Alert only when an open bar closes
extern int       Alert_MatrixLine=0;        /* Alert - Matrix Line For Bar Close */ // Use the bar close of this line
extern bool      Alert_Popup=False;         /* Alert - Popup Msg */ // Enable popup window & sound on alert
extern string    Alert_Sound_Buy="";        /* Alert - Play Sound File on Buy Signal */ // Play sound on alert. Wav files only
extern string    Alert_Sound_Sell="";       /* Alert - Play Sound File on Sell Signal */ // Play sound on alert. Wav files only
extern bool      Alert_Email=False;         /* Alert - Send eMail */ // Enable send email on alert
extern string    Alert_Subject="";          /* Alert - eMail Subject */ // Email Subject. Null string ("") will result in a preconfigured subject.
extern string    Label_Settings="——————————————————————————————";   /* Label Settings */
extern color     Label_Color=White;         /* Label Color */ // Color of Histogram Id labels
extern string    PDLine_Settings="——————————————————————————————"; /* Period Divider Line Settings */
extern int       PDLine_Bars=1000;          /* Period Divider Line Bars Back */ 
extern color     PDLine1_Color=Yellow;      /* Period Divider Line TF1 Color */ // Color of the TF1 period divider line
extern int       PDLine1_Style=STYLE_DOT;   /* Period Divider Line TF1 Style */ // Style of the TF1 period divider line: SOLID=0, DASH=1, DOT=2, DASHDOT=3, DASTDOTDOT=4
extern int       PDLine1_Size=1;            /* Period Divider Line TF1 Size */ // Size of the TF1 period divider line. Set to 0 to not show the line.
extern color     PDLine2_Color=Silver;      /* Period Divider Line TF2 Color */ // Color of the TF2 period divider line
extern int       PDLine2_Style=STYLE_DOT;   /* Period Divider Line TF2 Style */ // Style of the TF2 period divider line: SOLID=0, DASH=1, DOT=2, DASHDOT=3, DASTDOTDOT=4
extern int       PDLine2_Size=1;            /* Period Divider Line TF2 Size */ // Size of the TF2 period divider line. Set to 0 to not show the line.
extern color     PDLine3_Color=Silver;      /* Period Divider Line TF3 Color */ // Color of the TF3 period divider line
extern int       PDLine3_Style=STYLE_SOLID; /* Period Divider Line TF3 Style */ // Style of the TF3 period divider line: SOLID=0, DASH=1, DOT=2, DASHDOT=3, DASTDOTDOT=4
extern int       PDLine3_Size=1;            /* Period Divider Line TF3 Size */ // Size of the TF3 period divider line. Set to 0 to not show the line.

// Global module varables
// Histogram
double gadR1Up[];
double gadR1Dn[];
double gadR2Up[];
double gadR2Dn[];
double gadR3Up[];
double gadR3Dn[];

// Labels
double gadGap[MATRIX_ROWS];

// Globals
int giRepaintBars[MATRIX_ROWS];
int giTimeFrame[MATRIX_ROWS];
string gsIndicatorName;
bool gbInit;

//-----------------------------------------------------------------------------
// function: init()
// Description: Custom indicator initialization function.
//-----------------------------------------------------------------------------
int init() {
  
  // Init indicator buffers
  IndicatorBuffers(6);
  SetIndexStyle(0,DRAW_ARROW);
  SetIndexBuffer(0,gadR1Up);
  SetIndexStyle(1,DRAW_ARROW);
  SetIndexBuffer(1,gadR1Dn);
  SetIndexStyle(2,DRAW_ARROW);
  SetIndexBuffer(2,gadR2Up);
  SetIndexStyle(3,DRAW_ARROW);
  SetIndexBuffer(3,gadR2Dn);
  SetIndexStyle(4,DRAW_ARROW);
  SetIndexBuffer(4,gadR3Up);
  SetIndexStyle(5,DRAW_ARROW);
  SetIndexBuffer(5,gadR3Dn);

  for (int i=0; i<6; i++) {
    SetIndexLabel(i,NULL);
    SetIndexEmptyValue(i,0.0);
    SetIndexArrow(i,MATRIX_CHAR);
  }
  
  // Set Timeframe
  if (TimeFrame_Auto) {
    giTimeFrame[IDX_R1]=Period();
    giRepaintBars[IDX_R1]=0;
    giTimeFrame[IDX_R2]=NextHigherTF(giTimeFrame[IDX_R1]);
    giRepaintBars[IDX_R2]=giTimeFrame[IDX_R2]/Period()+2;
    giTimeFrame[IDX_R3]=NextHigherTF(giTimeFrame[IDX_R2]); 
    giRepaintBars[IDX_R3]=giTimeFrame[IDX_R3]/Period()+2;
  }
  else {
    giTimeFrame[IDX_R1]=TimeFrame1_Period;
    giRepaintBars[IDX_R1]=giTimeFrame[IDX_R1]/Period()+2;
    giTimeFrame[IDX_R2]=TimeFrame2_Period;
    giRepaintBars[IDX_R2]=giTimeFrame[IDX_R2]/Period()+2;
    giTimeFrame[IDX_R3]=TimeFrame3_Period;
    giRepaintBars[IDX_R3]=giTimeFrame[IDX_R3]/Period()+2;
  }  
  
  // Set histogram positions
  gadGap[IDX_R1]=1.2;
  gadGap[IDX_R2]=0.7;
  gadGap[IDX_R3]=0.2;
  
  // Misc
  gsIndicatorName=INDICATOR_NAME;
  IndicatorShortName(gsIndicatorName);
  gbInit=True;
  return(0);
}


//-----------------------------------------------------------------------------
// function: deinit()
// Description: Custom indicator deinitialization function.
//-----------------------------------------------------------------------------
int deinit() {
  // Clear text objects
  for(int i=ObjectsTotal()-1; i>-1; i--)
    if (StringFind(ObjectName(i),gsIndicatorName)>=0)  ObjectDelete(ObjectName(i));
  return (0);
}


//-----------------------------------------------------------------------------
// function: start()
// Description: Custom indicator iteration function.
//-----------------------------------------------------------------------------
int start() {
  int i, iNewBars, iCountedBars, iDrawLines=0;
  static datetime tCurBar;
  
  // Get unprocessed bars
  iCountedBars=IndicatorCounted();
  if(iCountedBars < 0) return (-1); 
  if(iCountedBars>0) iCountedBars--;

  // Timeframe 1
  // Set bars to redraw
  iNewBars=MathMax(RedrawBars(giTimeFrame[IDX_R1],IDX_R1,iCountedBars),giRepaintBars[IDX_R1]);
  iDrawLines=MathMax(iDrawLines,iNewBars);
  // Calc indicator data and update matrix
  ProcessASCTrend(iNewBars, giTimeFrame[IDX_R1], ASCTrend_Risk, 0, gadR1Up, gadR1Dn,IDX_R1); 

  // Timeframe 2
  // Set bars to redraw
  iNewBars=MathMax(RedrawBars(giTimeFrame[IDX_R2],IDX_R2,iCountedBars),giRepaintBars[IDX_R2]);
  iDrawLines=MathMax(iDrawLines,iNewBars);
  // Calc indicator data and update matrix
  ProcessASCTrend(iNewBars, giTimeFrame[IDX_R2], ASCTrend_Risk, 0, gadR2Up, gadR2Dn,IDX_R2);
      
  // Timeframe 3
  // Set bars to redraw
  iNewBars=MathMax(RedrawBars(giTimeFrame[IDX_R3],IDX_R3,iCountedBars),giRepaintBars[IDX_R3]);
  iDrawLines=MathMax(iDrawLines,iNewBars);
  // Calc indicator data and update matrix
  ProcessASCTrend(iNewBars, giTimeFrame[IDX_R3], ASCTrend_Risk, 0, gadR3Up, gadR3Dn,IDX_R3);

  // Alerts
  CheckAlert();
    
  // Tasks to execute on bar close
  if (tCurBar!=Time[0] || iDrawLines>PDLine_Bars) {
    tCurBar=Time[0];
    
    // Write/Update bar labels
    Writelabel(TF2Str(giTimeFrame[IDX_R1]),gadGap[IDX_R1]+0.2,Time[0]+Period()*60*2);
    Writelabel(TF2Str(giTimeFrame[IDX_R2]),gadGap[IDX_R2]+0.2,Time[0]+Period()*60*2);
    Writelabel(TF2Str(giTimeFrame[IDX_R3]),gadGap[IDX_R3]+0.2,Time[0]+Period()*60*2);
    
    // Update time-frame divider lines
    for (i=MathMin(iDrawLines,MathMin(PDLine_Bars,Bars-1));i>=0;i--) {
      if (iBarShift(Symbol(), giTimeFrame[IDX_R3], Time[i]) != iBarShift(Symbol(), giTimeFrame[IDX_R3], Time[i+1]) && PDLine3_Size>0)
        DrawDividerLine(i,i,PDLine3_Style,PDLine3_Size,PDLine3_Color);
      else if (iBarShift(Symbol(), giTimeFrame[IDX_R2], Time[i]) != iBarShift(Symbol(), giTimeFrame[IDX_R2], Time[i+1]) && PDLine2_Size>0)
        DrawDividerLine(i,i,PDLine2_Style,PDLine2_Size,PDLine2_Color); 
      else if (iBarShift(Symbol(), giTimeFrame[IDX_R1], Time[i]) != iBarShift(Symbol(), giTimeFrame[IDX_R1], Time[i+1]) && PDLine1_Size>0 &&  giTimeFrame[IDX_R1]>Period())
        DrawDividerLine(i,i,PDLine1_Style,PDLine1_Size,PDLine1_Color);           
    }
                
    // Clear the init flag   
    if (gbInit) 
      gbInit=False;
    }
  
  return(0);
}


//-----------------------------------------------------------------------------
// function: RedrawBars()
// Description: Return nr of bars to draw/redraw bars on a TF
//-----------------------------------------------------------------------------
int RedrawBars(int iPeriod, int idx, int iCountedBars) {
  static int iPrevSize[MATRIX_ROWS];
  int iNewSize;
  int iNewBars;
  datetime tTimeArray[];
  
  ArrayCopySeries(tTimeArray,MODE_TIME,Symbol(),iPeriod);
  iNewSize=ArraySize(tTimeArray);
  iNewBars=iNewSize-iPrevSize[idx];
  iPrevSize[idx]=iNewSize;
  if (iNewBars>0)
    return(Bars-1);
  //PrintD("Idx="+idx+", Bars="+iNewBars+", Time="+TimeToStr(Time[0]));
  return(Bars-iCountedBars);
}


//-----------------------------------------------------------------------------
// function: ProcessTVI()
// Description: Calc TVI data and update matrix
//-----------------------------------------------------------------------------
int ProcessASCTrend(int iNewBars, int iTimeFrame, int iRisk, int iBarCount, double& vdUp[], double& vdDn[], int iRow) {
  int i,j;
  double dAscTrend=0;
  int iHTFBar=-1;
  
  for (i=iNewBars;i>=0;i--) {
    if (i>(Bars-ASCTrend_Risk*3))
      continue;
    // Get index for higher timeframe bar
    if (iTimeFrame>Period())
      j=iBarShift(Symbol(), iTimeFrame, Time[i], True);
    else
      j=i;
          
    // Calc ASCTrend  
    if (iHTFBar!=j && j>=0) {
      iHTFBar=j;
      dAscTrend=iCustom(Symbol(),iTimeFrame,IND_ASCTREND,iRisk,iBarCount,2,j);
    }
    else if (j<0) {
      dAscTrend=0;
    }
    
    // Bull signal
    if (dAscTrend==1) {
      vdUp[i]=gadGap[iRow];
      vdDn[i]=0;
    }
    // Bear signal
    else if (dAscTrend==-1) {
      vdDn[i]=gadGap[iRow];
      vdUp[i]=0;
    }
    else {
      vdUp[i]=0;
      vdDn[i]=0;
    }  
  }
  return(0);
}


//-----------------------------------------------------------------------------
// function: CheckAlert()
// Description: Check for new alerts
//-----------------------------------------------------------------------------
void CheckAlert() {
  static datetime tAlertBar;
  static int iPrevAlert=0;
  
  if (Alert_Popup || Alert_Email || Alert_Sound_Buy!="" || Alert_Sound_Sell!="") {
    
    // Alert on the close of the current bar
    if (Alert_OnBarClose && tAlertBar<Time[iBarShift(Symbol(), giTimeFrame[Alert_MatrixLine], Time[0])]) {
      
      tAlertBar=Time[iBarShift(Symbol(), giTimeFrame[Alert_MatrixLine], Time[0])];
      // Clear alert flag
      if (iPrevAlert==1 && !UpSignal(1))
         iPrevAlert=0;
      else if (iPrevAlert==-1 && !DnSignal(1))
         iPrevAlert=0;
      // Alert and set alert flag
      if (UpSignal(1) && iPrevAlert!=1) {
         AlertNow(Symbol()+", "+TF2Str(giTimeFrame[Alert_MatrixLine])+": ASCTrend1 Matrix Buy Signal.", Alert_Sound_Buy);
         iPrevAlert=1;
      }  
      else if (DnSignal(1) && iPrevAlert!=-1) {
         AlertNow(Symbol()+", "+TF2Str(giTimeFrame[Alert_MatrixLine])+": ASCTrend1 Matrix Sell Signal.", Alert_Sound_Sell);
         iPrevAlert=-1;
      }
    }
  
    // Alert while the current bar is open
    if (!Alert_OnBarClose && tAlertBar<Time[iBarShift(Symbol(), giTimeFrame[Alert_MatrixLine], Time[0])]) {
      // Clear alert flag
      if (iPrevAlert==1 && !UpSignal(0))
         iPrevAlert=0;
      else if (iPrevAlert==-1 && !DnSignal(0))
         iPrevAlert=0;      
      // Alert and set alert flag
      if (UpSignal(0) && iPrevAlert!=1) {
         AlertNow(Symbol()+", "+TF2Str(giTimeFrame[Alert_MatrixLine])+": ASCTrend1 Matrix Buy Signal.", Alert_Sound_Buy);
         iPrevAlert=1;
         tAlertBar=Time[iBarShift(Symbol(), giTimeFrame[Alert_MatrixLine], Time[0])];
      }  
      else if (DnSignal(0) && iPrevAlert!=-1) {
         AlertNow(Symbol()+", "+TF2Str(giTimeFrame[Alert_MatrixLine])+": ASCTrend1 Matrix Sell Signal.", Alert_Sound_Sell);
         iPrevAlert=-1;
         tAlertBar=Time[iBarShift(Symbol(), giTimeFrame[Alert_MatrixLine], Time[0])];
      }
    }
  }
  return;
}


//-----------------------------------------------------------------------------
// function: AlertNow()
// Description: Signal the popup and email alerts
//-----------------------------------------------------------------------------
void AlertNow(string sAlertMsg, string sAlertSnd="") {
  //Popup Alert 
  if (Alert_Popup) 
    Alert(INDICATOR_NAME, ", ", sAlertMsg);
  if (sAlertSnd!="")
    PlaySound(sAlertSnd);
  //Email Alert
  if (Alert_Email) {
    if (Alert_Subject=="")
      SendMail( sAlertMsg, "MT4 Alert!\n"+INDICATOR_NAME+"\n" + TimeToStr(Time[0],TIME_DATE|TIME_SECONDS )+"\n"+sAlertMsg);
    else 
      SendMail( Alert_Subject, "MT4 Alert!\n"+INDICATOR_NAME+"\n" + TimeToStr(Time[0],TIME_DATE|TIME_SECONDS )+"\n"+sAlertMsg);          
  }
  
  return;
}


//-----------------------------------------------------------------------------
// function: UpSignal()
// Description: Return true if there is an up signal
//-----------------------------------------------------------------------------
bool UpSignal(int i) {
  if (gadR1Up[i]>0 && gadR2Up[i]>0 && gadR3Up[i]>0)
    return(True);
  else
    return(False);
}


//-----------------------------------------------------------------------------
// function: DnSignal()
// Description: eturn true if there is a down signal
//-----------------------------------------------------------------------------
bool DnSignal(int i) {
  if (gadR1Dn[i]>0 && gadR2Dn[i]>0 && gadR3Dn[i]>0)
    return(True);
  else
    return(False);
}


//-----------------------------------------------------------------------------
// function: Writelabel()
// Description: Write a label for a bar
//-----------------------------------------------------------------------------
int Writelabel(string sLabel,double dPrice, datetime tTime) {
  string sObjId;
  sObjId=gsIndicatorName+"_"+sLabel;
  if(ObjectFind(sObjId) < 0) 
    ObjectCreate(sObjId, OBJ_TEXT, WindowFind(gsIndicatorName), tTime+Period()*60*2, dPrice);
  ObjectSetText(sObjId, sLabel, 6, "Lucida Console", Label_Color);
  ObjectMove(sObjId,0,tTime, dPrice);
  return(0);
}


//-----------------------------------------------------------------------------
// function: DrawDividerLine()
// Description: Draw a horizontal divider line to show when a new bar starts
//----------------------------------------------------------------------------- 
int DrawDividerLine(int iBar, int iLineNr, int iLineStyle=STYLE_SOLID, int iLineWidth=1, color cLineColor=White) {
  string sLineId;
  
  // Set Line object ID  
  sLineId=gsIndicatorName+"_Divider_"+(string)iLineNr;
  
  // Delete line if it exists
  if (ObjectFind(sLineId)>=0 ) 
    ObjectDelete(sLineId);
  
  // Create and Draw line
  ObjectCreate(sLineId, OBJ_TREND, WindowFind(gsIndicatorName), Time[iBar], -90, Time[iBar+1], 80); 
  ObjectSet(sLineId, OBJPROP_STYLE, iLineStyle);     
  ObjectSet(sLineId, OBJPROP_WIDTH, iLineWidth);
  ObjectSet(sLineId, OBJPROP_BACK, False);
  ObjectSet(sLineId, OBJPROP_COLOR, cLineColor);
  ObjectSet(sLineId, OBJPROP_RAY, False);
  ObjectSet(sLineId, OBJPROP_TIME1, Time[iBar]);
  ObjectSet(sLineId, OBJPROP_TIME2, Time[iBar+1]);
  return(0);
}


//-----------------------------------------------------------------------------
// function: TF2Str()
// Description: Convert time-frame to a string
//-----------------------------------------------------------------------------
string TF2Str(int iPeriod) {
  switch(iPeriod) {
    case PERIOD_M1: return("M1");
    case PERIOD_M5: return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1: return("H1");
    case PERIOD_H4: return("H4");
    case PERIOD_D1: return("D1");
    case PERIOD_W1: return("W1");
    case PERIOD_MN1: return("MN1");
    default: return("M"+(string)iPeriod);
  }
  return("M?");
}


//-----------------------------------------------------------------------------
// function: NextHigherTF()
// Description: Select the next higher time-frame. 
//              Note: M15 and M30 both select H1 as next higher TF. 
//-----------------------------------------------------------------------------
int NextHigherTF(int iPeriod) {
  if (iPeriod==0) iPeriod=Period();
  switch(iPeriod) {
    case PERIOD_M1: return(PERIOD_M5);
    case PERIOD_M5: return(PERIOD_M15);
    case PERIOD_M15: return(PERIOD_H1);
    case PERIOD_M30: return(PERIOD_H1);
    case PERIOD_H1: return(PERIOD_H4);
    case PERIOD_H4: return(PERIOD_D1);
    case PERIOD_D1: return(PERIOD_W1);
    case PERIOD_W1: return(PERIOD_MN1);
    case PERIOD_MN1: return(PERIOD_MN1);
    
    default: return(Period());
  }
  return(Period());
}




