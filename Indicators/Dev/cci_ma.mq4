//+------------------------------------------------------------------+
//|                                                 CCI Ma cross.mq4 |
//+------------------------------------------------------------------+
#property copyright "www,forex-tsd.com"
#property link      "www,forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers    4
#property indicator_color1     Yellow
#property indicator_color2     Red
#property indicator_color3     LimeGreen
#property indicator_color4     DeepPink
#property indicator_width1     2
#property indicator_width2     1
#property indicator_levelcolor Silver

//
//
//
//
//

extern int    CCIPeriod       = 14;
extern int    CCIPrice        = PRICE_TYPICAL;
extern int    MaPeriod        = 14;
extern int    MaType          = MODE_LWMA;
extern bool   ShowArrows      = false;
extern int    arrowSize       = 1;
extern double OverSold        = -150;
extern double OverBought      = 150;

extern string note            = "turn on Alert = true; turn off = false";
extern bool   alertsOn        = false;
extern bool   alertsOnCurrent = true;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert2.wav";

//
//
//
//
//

double cci[];
double ma[];
double arrowUp[];
double arrowDn[];
double prices[];
double trend[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(6);
      SetIndexBuffer(0,cci);
      SetIndexBuffer(1,ma);
      SetIndexBuffer(2,arrowUp); 
      SetIndexBuffer(3,arrowDn); 
      SetIndexBuffer(4,prices);
      SetIndexBuffer(5,trend);
      SetLevelValue(0,OverBought);
      SetLevelValue(1,OverSold);
      
      if (ShowArrows)
      {
        SetIndexStyle(2,DRAW_ARROW,0,arrowSize); SetIndexArrow(2,241);
        SetIndexStyle(3,DRAW_ARROW,0,arrowSize); SetIndexArrow(3,242);
      }
      else
      {
        SetIndexStyle(2,DRAW_NONE);
        SetIndexStyle(3,DRAW_NONE);
      }
      
   IndicatorShortName("Cci Ma Cross ("+CCIPeriod+","+MaPeriod+")");
return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,k,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

   //
   //
   //
   //
   //

   for(i=limit; i>=0; i--)
   {
      prices[i]  = iMA(NULL,0,1,0,MODE_SMA,CCIPrice,i);
      double avg = 0; for(k=0; k<CCIPeriod; k++) avg +=         prices[i+k];      avg /= CCIPeriod;
      double dev = 0; for(k=0; k<CCIPeriod; k++) dev += MathAbs(prices[i+k]-avg); dev /= CCIPeriod;
         if (dev!=0)
               cci[i] = (prices[i]-avg)/(0.015*dev);
         else  cci[i] = 0;          
   }
   
   for(i=limit; i>=0; i--)
   {
      ma[i] = iMAOnArray(cci,0,MaPeriod,0,MaType,i);
      trend[i]   = trend[i+1];
      arrowUp[i] = EMPTY_VALUE;
      arrowDn[i] = EMPTY_VALUE;
         if (cci[i]>ma[i]) trend[i] = 1;
         if (cci[i]<ma[i]) trend[i] =-1;
         if (trend[i] != trend[i+1])
         if (trend[i]==1) 
               arrowUp[i] = ma[i];
         else  arrowDn[i] = ma[i];
   }
   
   //
   //
   //
   //
   //
      
   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;

      if (trend[whichBar] != trend[whichBar+1])
      if (trend[whichBar] == 1)
            doAlert("Buy");
      else  doAlert("Sell");       
   }

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

void doAlert(string doWhat)
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

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Cci Ma Cross ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," Cci Ma Cross "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}