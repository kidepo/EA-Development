//------------------------------------------------------------------
#property copyright "mladen"
#property link      "www.forex-tsd.cm"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1  LimeGreen
#property indicator_color2  PaleVioletRed
#property indicator_color3  LimeGreen
#property indicator_color4  PaleVioletRed
#property indicator_color5  LimeGreen
#property indicator_color6  PaleVioletRed
#property indicator_color7  LimeGreen
#property indicator_color8  PaleVioletRed
#property indicator_minimum 0
#property indicator_maximum 5

//
//
//
//
//

extern string TimeFrame1            = "Current time frame";
extern string TimeFrame2            = "next1";
extern string TimeFrame3            = "next2";
extern string TimeFrame4            = "next3";
extern int    Lb                    = 10;
extern int    AdaptPeriod           = 20;
extern string UniqueID              = "4 Time frame assm";
extern bool   alertsOn              = false;
extern int    alertsLevel           = 3;
extern bool   alertsMessage         = true;
extern bool   alertsSound           = false;
extern bool   alertsEmail           = false;
extern int    LinesWidth            =  0;
extern color  LabelsColor           = DarkGray;
extern int    LabelsHorizontalShift = 5;
extern double LabelsVerticalShift   = 1.5;

//
//
//
//
//

double ST1u[];
double ST1d[];
double ST2u[];
double ST2d[];
double ST3u[];
double ST3d[];
double ST4u[];
double ST4d[];

int    timeFrames[4];
bool   returnBars;
bool   calculateValue;
string indicatorFileName;

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()
{
   SetIndexBuffer(0,ST1u);
   SetIndexBuffer(1,ST1d);
   SetIndexBuffer(2,ST2u);
   SetIndexBuffer(3,ST2d);
   SetIndexBuffer(4,ST3u);
   SetIndexBuffer(5,ST3d);
   SetIndexBuffer(6,ST4u);
   SetIndexBuffer(7,ST4d);
      indicatorFileName = WindowExpertName();
      returnBars        = (TimeFrame1=="returnBars");     if (returnBars)     return(0);
      calculateValue    = (TimeFrame1=="calculateValue"); if (calculateValue) return(0);
      
      //
      //
      //
      //
      //
      
      for (int i=0; i<8; i++) 
      {
         SetIndexStyle(i,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(i,110); 
      }
      timeFrames[0] = stringToTimeFrame(TimeFrame1);
      timeFrames[1] = stringToTimeFrame(TimeFrame2);
      timeFrames[2] = stringToTimeFrame(TimeFrame3);
      timeFrames[3] = stringToTimeFrame(TimeFrame4);
      alertsLevel = MathMin(MathMax(alertsLevel,3),4);
      IndicatorShortName(UniqueID);
   return(0);
}
int deinit()
{
   for (int t=0; t<4; t++) ObjectDelete(UniqueID+t);
   return(0); 
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

double trend[][2];
#define _up 0
#define _dn 1
int start()
{
   int i,r,counted_bars=IndicatorCounted();
      if(counted_bars < 0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
         if (returnBars) { ST1u[0] = limit+1; return(0); }
         if (calculateValue) { calculateByST(limit); return(0); }

         if (timeFrames[0] != Period()) limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrames[0],indicatorFileName,"returnBars",0,0)*timeFrames[0]/Period()));
         if (timeFrames[1] != Period()) limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrames[1],indicatorFileName,"returnBars",0,0)*timeFrames[1]/Period()));
         if (timeFrames[2] != Period()) limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrames[2],indicatorFileName,"returnBars",0,0)*timeFrames[2]/Period()));
         if (timeFrames[3] != Period()) limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrames[3],indicatorFileName,"returnBars",0,0)*timeFrames[3]/Period()));
         if (ArrayRange(trend,0)!=Bars) ArrayResize(trend,Bars);

         //
         //
         //
         //
         //
         
         bool initialized = false;
         if (!initialized)
         {
            initialized = true;
            int window = WindowFind(UniqueID);
            for (int t=0; t<4; t++)
            {
               string label = timeFrameToString(timeFrames[t]);
               ObjectCreate(UniqueID+t,OBJ_TEXT,window,0,0);
                  ObjectSet(UniqueID+t,OBJPROP_COLOR,LabelsColor);
                  ObjectSet(UniqueID+t,OBJPROP_PRICE1,t+LabelsVerticalShift);
                  ObjectSetText(UniqueID+t,label,8,"Arial");
            }               
         }
         for (t=0; t<4; t++) ObjectSet(UniqueID+t,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);

   //
   //
   //
   //
   //
    
   for(i = limit, r=Bars-i-1; i >= 0; i--,r++)
   {
      trend[r][_up] = 0;
      trend[r][_dn] = 0;
      for (int k=0; k<4; k++)
      {
         int y = iBarShift(NULL,timeFrames[k],Time[i]);
            double ssmv = iCustom(NULL,timeFrames[k],indicatorFileName,"calculateValue","","","",Lb,AdaptPeriod,7,y);
            bool   isUp  = (ssmv>0);
            switch (k)
            {
               case 0 : if (isUp) { ST1u[i] = k+1; ST1d[i] = EMPTY_VALUE;}  else { ST1d[i] = k+1; ST1u[i] = EMPTY_VALUE; } break;
               case 1 : if (isUp) { ST2u[i] = k+1; ST2d[i] = EMPTY_VALUE;}  else { ST2d[i] = k+1; ST2u[i] = EMPTY_VALUE; } break;
               case 2 : if (isUp) { ST3u[i] = k+1; ST3d[i] = EMPTY_VALUE;}  else { ST3d[i] = k+1; ST3u[i] = EMPTY_VALUE; } break;
               case 3 : if (isUp) { ST4u[i] = k+1; ST4d[i] = EMPTY_VALUE;}  else { ST4d[i] = k+1; ST4u[i] = EMPTY_VALUE; } break;
            }
            if (isUp)
                  trend[r][_up] += 1;
            else  trend[r][_dn] += 1;
      }
   }
   manageAlerts();
   return(0);
}


//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

void calculateByST(int limit)
{
    for (int i=limit; i>=0; i--) 
    {
        double dev = iStdDev(NULL,0,AdaptPeriod,0,MODE_SMA,PRICE_CLOSE,i);
        double avg = iSma(dev,AdaptPeriod,i,0);
         if (dev!=0) 
                double period = Lb*avg/dev;
         else          period = Lb; 
         if (period<3) period = 3;
         
         //
         //
         //
         //
         //
         
         double close = Close[i];
         double hi    = iSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_HIGH,i+1),period,i+1,0);
         double lo    = iSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_LOW, i+1),period,i+1,1);
         
           ST4d[i]  = ST4d[i+1];
         
        if (close > hi) ST4d[i]  =  1;
        if (close < lo) ST4d[i]  = -1;
    }
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

double workSmooth[][10];
double iSmooth(double price, double length, int r, int instanceNo=0)
{
   if (ArrayRange(workSmooth,0)!=Bars) ArrayResize(workSmooth,Bars); instanceNo *= 5; r = Bars-r-1;
 	if(r<=2) { workSmooth[r][instanceNo] = price; workSmooth[r][instanceNo+2] = price; workSmooth[r][instanceNo+4] = price; return(price); }
   
   //
   //
   //
   //
   //
   
	double alpha = 0.45*(length-1.0)/(0.45*(length-1.0)+2.0);
   	  workSmooth[r][instanceNo+0] =  price+alpha*(workSmooth[r-1][instanceNo]-price);
	     workSmooth[r][instanceNo+1] = (price - workSmooth[r][instanceNo])*(1-alpha)+alpha*workSmooth[r-1][instanceNo+1];
	     workSmooth[r][instanceNo+2] =  workSmooth[r][instanceNo+0] + workSmooth[r][instanceNo+1];
	     workSmooth[r][instanceNo+3] = (workSmooth[r][instanceNo+2] - workSmooth[r-1][instanceNo+4])*MathPow(1.0-alpha,2) + MathPow(alpha,2)*workSmooth[r-1][instanceNo+3];
	     workSmooth[r][instanceNo+4] =  workSmooth[r][instanceNo+3] + workSmooth[r-1][instanceNo+4]; 
   return(workSmooth[r][instanceNo+4]);
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

double workSma[][2];
double iSma(double price, int period, int r, int instanceNo=0)
{
   if (ArrayRange(workSma,0)!= Bars) ArrayResize(workSma,Bars); instanceNo *= 2; r = Bars-r-1;

   //
   //
   //
   //
   //
      
   workSma[r][instanceNo] = price;
   if (r>=period)
          workSma[r][instanceNo+1] = workSma[r-1][instanceNo+1]+(workSma[r][instanceNo]-workSma[r-period][instanceNo])/period;
   else { workSma[r][instanceNo+1] = 0; for(int k=0; k<period && (r-k)>=0; k++) workSma[r][instanceNo+1] += workSma[r-k][instanceNo];  
          workSma[r][instanceNo+1] /= k; }
   return(workSma[r][instanceNo+1]);
}

//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------
//
//
//
//
//

void manageAlerts()
{
   if (alertsOn)
   {
      int whichBar = Bars-1;
      if (trend[whichBar][_up] >= alertsLevel || trend[whichBar][_dn] >= alertsLevel)
      {
         if (trend[whichBar][_up] >= alertsLevel) doAlert("up"  ,trend[whichBar][_up]);
         if (trend[whichBar][_dn] >= alertsLevel) doAlert("down",trend[whichBar][_dn]);
      }
   }
}

//
//
//
//
//

void doAlert(string doWhat, int howMany)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[0]) {
       previousAlert  = doWhat;
       previousTime   = Time[0];

       //
       //
       //
       //
       //

       message =  Symbol()+" at "+TimeToStr(TimeLocal(),TIME_SECONDS)+" "+howMany+" time frames of adaptive smoother Gann HiLo are aligned "+doWhat;
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(Symbol()+" 4 time frame adaptive smoother Gann HiLo ",message);
          if (alertsSound)   PlaySound("alert2.wav");
   }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int toInt(double value) { return(value); }
int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   int max = ArraySize(iTfTable)-1, add=0;
   int nxt = (StringFind(tfs,"NEXT1")>-1); if (nxt>0) { tfs = ""+Period(); add=1; }
       nxt = (StringFind(tfs,"NEXT2")>-1); if (nxt>0) { tfs = ""+Period(); add=2; }
       nxt = (StringFind(tfs,"NEXT3")>-1); if (nxt>0) { tfs = ""+Period(); add=3; }

      //
      //
      //
      //
      //
         
      for (int i=max; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[toInt(MathMin(max,i+add))],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}