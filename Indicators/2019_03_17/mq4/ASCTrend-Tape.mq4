/*------------------------------------------------------------------------------------
   Name: ASCTrend-Tape.mq4
   
   Description: MTF Tape chart of the ASCTrend1 indicator.

	Note:
	   Requires that the following indicators are installed and working:
	   ASCTrend1i.mq4,
   
   Change log:
       2014-02-17. Xaphod, v1.601
          - Fixed array out of range error
       2014-02-11. Xaphod, v1.600
          - Update for MT4.5
          - Removed custom indicator check which will not work with sub-folders
       2013-05-03. Xaphod, v1.01
         - Fixed updating of bars on all timeframes as new data is being downloaded.
         - Draw blank dot if there is not data for the bar.
       2012-??-??. Xaphod, v1.00
-------------------------------------------------------------------------------------*/
// Indicator properties
#property copyright "Copyright ©2012, xaphod.com"
#property link      "http://www.xaphod.com"
#property version    "1.601"
#property strict
#property description "MTF Tape chart of the ASCTrend1 indicator."
#property description "For information on the AscTrend indicator go to: "
#property description "    www.forex-tsd.com/move/598-asctrend-system.html"
#property description " "
#property description "Requirements: The following indicator must installed and working: ASCTrend1i.mq4"
#property description " "
#property description "Troubleshooting: Check the 'Journal' and 'Expert' tabs in the terminal window for errors."


#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 RoyalBlue
#property indicator_color2 Crimson
#property indicator_color3 Silver
#property indicator_width1  4
#property indicator_width2  4
#property indicator_width3  1
#property indicator_maximum 1
#property indicator_minimum 0

//#include <xPrint.mqh>

// Constant definitions
#define INDICATOR_NAME "ASCTrend"
#define DIVIDER_LINE 100000
#define IND_ASCTREND  "ASCTrend1i"

// indicator parameters
extern string    TimeFrame_Settings="——————————————————————————————"; /* TimeFrame Settings */
extern ENUM_TIMEFRAMES TimeFrame_Period=PERIOD_CURRENT;       /* TimeFrame Period */    // Timeframe: 0,1,5,15,30,60,240,1440 etc. Current Timeframe=0. 
extern bool      TimeFrame_Auto=True;      /* TimeFrame Auto Select */ // Automatically select higher TF. M15 and M30 -> H1. Off=0, 1st HTF=1, 2nd HTF=2
extern string    ASCTrend_Settings="——————————————————————————————"; /* ASCTrend Settings */
extern int       ASCTrend_Risk=6;          /* ASCTrend Risk */   // Risk level. WPR_Period=3+Risk*2 or WPR_Period=ALT_PERIOD for a large move 
extern int       ASCTrend_BarCount=0;      /* Number of Bars to Draw */ // 0 for full chart buffer

// indicator buffers
double gadUp[];
double gadDn[];
double gadLine[];

// Globals
int giRepaintBars;
int giTimeFrame;
bool gbInit;


//-----------------------------------------------------------------------------
// function: init()
// Description: Custom indicator initialization function.
//-----------------------------------------------------------------------------
int init() {
  IndicatorBuffers(3); 
  SetIndexStyle(0,DRAW_HISTOGRAM);
  SetIndexBuffer(0,gadUp);
  SetIndexLabel(0,NULL);
  SetIndexStyle(1,DRAW_HISTOGRAM);
  SetIndexBuffer(1,gadDn);
  SetIndexLabel(1,NULL);
  SetIndexStyle(2,DRAW_LINE);
  SetIndexBuffer(2,gadLine);
  SetIndexLabel(2,NULL);
  
  // Set Timeframe
  switch(TimeFrame_Auto) {
    case 1: 
      giTimeFrame=NextHigherTF(TimeFrame_Period); 
      giRepaintBars=giTimeFrame/Period()+2;
    break;
    case 2: 
      giTimeFrame=NextHigherTF(NextHigherTF(TimeFrame_Period));
      giRepaintBars=giTimeFrame/Period()+2;
    break;
    default: 
      if (TimeFrame_Period<1 || TimeFrame_Period==Period()) {
        giTimeFrame=Period();
        giRepaintBars=0;
      }
      else {
        giTimeFrame=TimeFrame_Period;
        giRepaintBars=giTimeFrame/Period()+2;
      }
    break;
  }
  
  IndicatorShortName("ASCTrend1("+(string)ASCTrend_Risk+")-"+TF2Str(giTimeFrame));
    
  gbInit=True;
  return(0);
}


//-----------------------------------------------------------------------------
// function: deinit()
// Description: Custom indicator deinitialization function.
//-----------------------------------------------------------------------------
int deinit() {
   return (0);
}


//-----------------------------------------------------------------------------
// function: start()
// Description: Custom indicator iteration function.
//-----------------------------------------------------------------------------
int start() {
  int i, j, iNewBars, iCountedBars;
  static int iDivider=-1;
  static int iHTFBar=-1;
  double dSig0;
  int iPeriodSec=giTimeFrame*60;  
  static datetime tNextBar;
  
  if (gbInit) {
    tNextBar=Time[Bars-1]/iPeriodSec;
    tNextBar=tNextBar*iPeriodSec+iPeriodSec;
    gbInit=False;
  }
  
  // Get unprocessed bars
  iCountedBars=IndicatorCounted();
  if(iCountedBars < 0) return (-1); 
  if(iCountedBars>0) iCountedBars--;
  if(iCountedBars==0) iCountedBars++;
  
  // Set bars to redraw
  if (NewBars(giTimeFrame)>1)
    iNewBars=Bars-1;
  else
    iNewBars=Bars-iCountedBars;
  if (iNewBars<giRepaintBars)
    iNewBars=giRepaintBars;
  
  for(i=iNewBars; i>=0; i--) {
    if (i>(Bars-ASCTrend_Risk*3))
      continue;
    // Shift index for higher time-frame
    if (giTimeFrame>Period() )
      j=iBarShift(Symbol(), giTimeFrame, Time[i], True);
    else
      j=i;
    
    // Calc indicator data
    if (iHTFBar!=j && j>=0) {
      iHTFBar=j;
      dSig0=iCustom(Symbol(),giTimeFrame,IND_ASCTREND,ASCTrend_Risk,ASCTrend_BarCount,2,j);
      if (gadLine[i]==EMPTY_VALUE) 
        if (giTimeFrame>Period())
          iDivider *=-1;
    }
    else if (j<0) {
      dSig0=0;
    }
    
    if (gadLine[i]==EMPTY_VALUE)
      if (giTimeFrame>Period())
        gadLine[i]=iDivider*DIVIDER_LINE;
    
    // Draw tape    
    gadUp[i]=EMPTY_VALUE;
    gadDn[i]=EMPTY_VALUE;
    if (dSig0==1)
      gadUp[i]=1;
    else if (dSig0==-1)
      gadDn[i]=1;
  }
  
  return(0);
}
//+------------------------------------------------------------------+


//-----------------------------------------------------------------------------
// function: NewBars()
// Description: Return nr of new bars on a TF
//-----------------------------------------------------------------------------
int NewBars(int iPeriod) {
  static int iPrevSize=0;
  int iNewSize;
  int iNewBars;
  datetime tTimeArray[];
  
  ArrayCopySeries(tTimeArray,MODE_TIME,Symbol(),iPeriod);
  iNewSize=ArraySize(tTimeArray);
  iNewBars=iNewSize-iPrevSize;
  iPrevSize=iNewSize;
  return(iNewBars);
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
  return("");
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


