//+------------------------------------------------------------------+
//|                                   UniZigZagChannel_v1.9 600+.mq4 |
//|                                Copyright © 2016, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2016, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"


#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 clrLightPink
#property indicator_color2 clrLightBlue
#property indicator_color3 clrCoral
#property indicator_color4 clrCornflowerBlue
#property indicator_color5 clrTurquoise
#property indicator_color6 clrTomato
#property indicator_color7 clrOrange
#property indicator_color8 clrOliveDrab

#property indicator_width1 0
#property indicator_width2 0
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 2
#property indicator_width6 2
#property indicator_style7 2
#property indicator_style8 2

enum ENUM_PRICE
{
   close,               // Close
   open,                // Open
   high,                // High
   low,                 // Low
   median,              // Median
   typical,             // Typical
   weightedClose,       // Weighted Close
   heikenAshiClose,     // Heiken Ashi Close
   heikenAshiOpen,      // Heiken Ashi Open
   heikenAshiHigh,      // Heiken Ashi High   
   heikenAshiLow,       // Heiken Ashi Low
   heikenAshiMedian,    // Heiken Ashi Median
   heikenAshiTypical,   // Heiken Ashi Typical
   heikenAshiWeighted   // Heiken Ashi Weighted Close   
};

enum ENUM_BREAK
{
   byclose,             // by Close
   byuplo               // by Up/Lo Band Price
};

enum ENUM_RETRACE
{
   channel,             // Price Channel
   pctprice,            // % of Price
   pips,                // Price Change in pips
   ratr                 // ATR Multiplier
};

enum ENUM_ZZCHANNEL
{
   off,                 // Off
   hilo,                // High/Low Channel
   chaos                // Chaos Bands
};




//---- input parameters
input ENUM_TIMEFRAMES   TimeFrame            =        0;       // Timeframe
input ENUM_PRICE        UpBandPrice          =        2;       // Upper Band Price
input ENUM_PRICE        LoBandPrice          =        3;       // Lower Band Price 
input ENUM_BREAK        BreakOutMode         =        0;       // Breakout Mode
input double            ReversalValue        =       12;       // Reversal Value according to Retrace Method
input ENUM_RETRACE      RetraceMethod        =        0;       // Retrace Method
input int               ATRperiod            =       50;       // ATR period (RetraceMethod=3)
input bool              ShowZigZag           =     true;       // Show ZigZag
input bool              ShowSignals          =     true;       // Show Signals 
input bool              ShowPriceChannel     =     true;       // ShowPriceChannel 
input ENUM_ZZCHANNEL    ZigZagChannelMode    =        1;       // ZigZag Channel Mode 

input string            alerts               = "==== Alerts & Emails: ====";
input bool              AlertOn              =    false;       //
input int               AlertShift           =        1;       // Alert Shift:0-current bar,1-previous bar
input int               SoundsNumber         =        5;       // Number of sounds after Signal
input int               SoundsPause          =        5;       // Pause in sec between sounds 
input string            UpTrendSound         = "alert.wav";
input string            DnTrendSound         = "alert2.wav";
input bool              EmailOn              =    false;       // 
input int               EmailsNumber         =        1;       //
input bool              PushNotificationOn   =    false;



double upZZ1[];
double dnZZ1[];  
double hiBuffer[];
double loBuffer[];
double upSignal[];
double dnSignal[];
double hiband[];
double loband[];
double upPrice[];
double loPrice[];


int      timeframe, trend[][3];  
datetime hiTime[][2], loTime[][2], prevtime[];
double   period[1], upBand[][2], loBand[][2], hiValue[][2], loValue[][2], _point;
string   short_name, TF, IndicatorName;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   timeframe = TimeFrame;
   if(timeframe <= Period()) timeframe = Period(); 
   TF = tf(timeframe);
   
   IndicatorDigits(Digits);
   
   IndicatorName = WindowExpertName();
     
   period[0] = ReversalValue;
   
   
   IndicatorBuffers(10);   
   SetIndexBuffer(0,   upZZ1); SetIndexStyle(0,DRAW_ZIGZAG);
   SetIndexBuffer(1,   dnZZ1); SetIndexStyle(1,DRAW_ZIGZAG);
   SetIndexBuffer(2,hiBuffer); SetIndexStyle(2,  DRAW_LINE); 
   SetIndexBuffer(3,loBuffer); SetIndexStyle(3,  DRAW_LINE); 
   SetIndexBuffer(4,upSignal); SetIndexStyle(4, DRAW_ARROW); SetIndexArrow(4,233);
   SetIndexBuffer(5,dnSignal); SetIndexStyle(5, DRAW_ARROW); SetIndexArrow(5,234);
   SetIndexBuffer(6,  hiband); if(ShowPriceChannel) SetIndexStyle(6,DRAW_LINE); else SetIndexStyle(6,DRAW_NONE); 
   SetIndexBuffer(7,  loband); if(ShowPriceChannel) SetIndexStyle(7,DRAW_LINE); else SetIndexStyle(7,DRAW_NONE);   
   SetIndexBuffer(8, upPrice);   
   SetIndexBuffer(9, loPrice);
   
   
   short_name = IndicatorName+"["+TF+"]("+UpBandPrice+","+LoBandPrice+","+DoubleToStr(ReversalValue,1)+","+RetraceMethod+")";
   IndicatorShortName(short_name);
   
   SetIndexLabel(0,"Upper ZigZag"); SetIndexEmptyValue(0,0.0);
   SetIndexLabel(1,"Lower ZigZag"); SetIndexEmptyValue(1,0.0);   
   SetIndexLabel(2,"UniZigZag Upper Band"); 
   SetIndexLabel(3,"UniZigZag Lower Band");
   SetIndexLabel(4,"UpSignal"); 
   SetIndexLabel(5,"DnSignal");
   SetIndexLabel(6,"Channel\'s Upper Band"); 
   SetIndexLabel(7,"Channel\'s Lower Band");
      
//---- 
   int draw_begin = Bars - iBars(NULL,timeframe)*timeframe/Period() + MathMax(ReversalValue,ATRperiod);
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
   SetIndexDrawBegin(2,draw_begin);
   SetIndexDrawBegin(3,draw_begin);
   SetIndexDrawBegin(4,draw_begin);
   SetIndexDrawBegin(5,draw_begin);
   SetIndexDrawBegin(6,draw_begin);
   SetIndexDrawBegin(7,draw_begin);
   
   
   ArrayResize(prevtime,1);
   ArrayResize(   trend,1);
   ArrayResize(  hiTime,1);
   ArrayResize(  loTime,1);
   ArrayResize(  upBand,1);
   ArrayResize(  loBand,1);
   ArrayResize( hiValue,1);
   ArrayResize( loValue,1);
   
   _point = _Point*MathPow(10,Digits%2);
   
   
   
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() { Comment(""); return(0);}
//+------------------------------------------------------------------+
//| UniZigZagChannel_v1.9 600+                                       |
//+------------------------------------------------------------------+
int start()
{
   int i,shift, counted_bars=IndicatorCounted(),limit;
   
   if (counted_bars > 0) limit = Bars - counted_bars - 1;     
   if (counted_bars < 1) 
   {
   limit = Bars - 1;    
      for(i=0;i<limit;i++)
      { 
      upZZ1[i]    = 0;
      dnZZ1[i]    = 0;
      hiBuffer[i] = 0;
      loBuffer[i] = 0;
      upSignal[i] = 0;
      dnSignal[i] = 0;
      hiband[i]   = 0;
      loband[i]   = 0;
      }
         
   SetIndexDrawBegin(0,period[0]);
   }
   	
   if(timeframe != Period())
	{
   
   int pivotshift = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                            ATRperiod,ShowZigZag,ShowSignals,false,ZigZagChannelMode,
                            "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,6,0);      
    
   limit = MathMax(limit,MathMax(pivotshift+1,1)*timeframe/Period());   
   
   
      for(shift=0;shift<limit;shift++) 
      {	
      int y = iBarShift(NULL,timeframe,Time[shift]);
      
      double upzz = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                            ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                            "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,0,y);   
      
      double dnzz = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                            ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                            "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,1,y);   
      
      datetime time = iTime(NULL,TimeFrame,y);
      upZZ1[shift] = 0;
      dnZZ1[shift] = 0;   
                  
         if(UpBandPrice <= 6) upPrice[shift] = iMA(NULL,0,1,0,0,(int)UpBandPrice,shift);   
         else
         if(UpBandPrice > 6 && UpBandPrice <= 13) upPrice[shift] = HeikenAshi(0,UpBandPrice-7,shift);
      
         if(LoBandPrice <= 6) loPrice[shift] = iMA(NULL,0,1,0,0,(int)LoBandPrice,shift);   
         else
         if(LoBandPrice > 6 && LoBandPrice <= 13) loPrice[shift] = HeikenAshi(1,LoBandPrice-7,shift);    
         
         
         
         if(time == Time[shift])
         {
         int mtfshift = iBarShift(NULL,0,time);    
         
            if(upzz > 0)
            {
            datetime uptime = time; 
                      
            if(y > 0) int uplen = mtfshift - iBarShift(NULL,0,iTime(NULL,TimeFrame,y-1))+1; 
            else uplen = mtfshift+1;
                        
            int upshift = 0;
            double maxvalue = 0;   
            
               for(i=0;i<uplen;i++)
               { 
               double upvalue = upPrice[shift-i];   
               if(upvalue > maxvalue) {maxvalue = upvalue; upshift = i;}
               }
   
            upZZ1[mtfshift-upshift] = upzz; 
            }
      
            if(dnzz > 0)
            {
            datetime dntime = time; 
                      
            if(y > 0) int dnlen = mtfshift - iBarShift(NULL,0,iTime(NULL,TimeFrame,y-1))+1; 
            else dnlen = mtfshift+1;
           
            int dnshift = 0;
            double minvalue = 10000000;   
            
               for(i=0;i<dnlen;i++)
               { 
               double dnvalue = loPrice[shift-i];   
               if(dnvalue < minvalue) {minvalue = dnvalue; dnshift = i;}
               }
      
            dnZZ1[mtfshift-dnshift] = dnzz; 
            }
         }
      
      hiBuffer[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,2,y);   
      
      loBuffer[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,3,y);        
      
      hiband[shift]   = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,6,y);       
      
      loband[shift]   = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,7,y);         
         
         if(ShowSignals)
         {
         upSignal[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                   ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                   "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,4,y);         
         
         dnSignal[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,UpBandPrice,LoBandPrice,BreakOutMode,ReversalValue,RetraceMethod,
                                   ATRperiod,ShowZigZag,ShowSignals,ShowPriceChannel,ZigZagChannelMode,
                                   "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpTrendSound,DnTrendSound,EmailOn,EmailsNumber,PushNotificationOn,5,y);         
         }
      }
      
         
   return(0);
   }
   else 
   if(period[0] > 0) _uniZigZag(upZZ1,dnZZ1,0,period[0],limit,counted_bars);
        
   return(0);   
}

void _uniZigZag(double& upZZ[],double& dnZZ[],int index,double retrace,int limit,int counted_bars)
{
   int i, nlow, nhigh;
  
     
   for(int shift=limit;shift>=0;shift--) 
   {	
      if(prevtime[index] != Time[shift])
      {
      hiTime[index][1]  = hiTime[index][0];
      loTime[index][1]  = loTime[index][0];
      upBand[index][1]  = upBand[index][0];
      loBand[index][1]  = loBand[index][0];
      hiValue[index][1] = hiValue[index][0];
      loValue[index][1] = loValue[index][0];
      trend[index][2]   = trend[index][1];
      trend[index][1]   = trend[index][0];
      prevtime[index]   = Time[shift];
      }
               
      if(shift < Bars - retrace)
      {
      hiTime[index][0]  = hiTime[index][1];
      loTime[index][0]  = loTime[index][1];
      upBand[index][0]  = upBand[index][1];
      loBand[index][0]  = loBand[index][1];   
      hiValue[index][0] = 0;
      loValue[index][0] = 0;   
      trend[index][0]   = trend[index][1];
      
      
      
         if(UpBandPrice <= 6) upPrice[shift] = iMA(NULL,0,1,0,0,(int)UpBandPrice,shift);   
         else
         if(UpBandPrice > 6 && UpBandPrice <= 13) upPrice[shift] = HeikenAshi(0,UpBandPrice-7,shift);
      
         if(LoBandPrice <= 6) loPrice[shift] = iMA(NULL,0,1,0,0,(int)LoBandPrice,shift);   
         else
         if(LoBandPrice > 6 && LoBandPrice <= 13) loPrice[shift] = HeikenAshi(1,LoBandPrice-7,shift);    
      
    
         
         switch(RetraceMethod)
         {
         case 0: upBand[index][0] = upPrice[HighestBar(retrace,shift,0)]; 
                 loBand[index][0] = loPrice[ LowestBar(retrace,shift,0)];  
                 break;
         
         case 1: if(upPrice[shift] > upBand[index][0])   
                 {
                 upBand[index][0] = upPrice[shift];
                 loBand[index][0] = upBand[index][0]*(1 - 0.01*retrace); 
                 }
                 
                 if(loPrice[shift] < loBand[index][0])  
                 {
                 loBand[index][0] = loPrice[shift];
                 upBand[index][0] = loBand[index][0]*(1 + 0.01*retrace); 
                 }
                 break;
         
         case 2: if(upPrice[shift] >= upBand[index][0])   
                 {
                 upBand[index][0] = upPrice[shift];
                 loBand[index][0] = upBand[index][0] - retrace*_point; 
                 }
                 
                 if(loPrice[shift] <= loBand[index][0])  
                 {
                 loBand[index][0] = loPrice[shift];
                 upBand[index][0] = loBand[index][0] + retrace*_point; 
                 }
                 break;
                     
         case 3: double atr = iATR(NULL,0,ATRperiod,shift);
                 
                 if(upPrice[shift] >= upBand[index][0])   
                 {
                 upBand[index][0] = upPrice[shift];
                 loBand[index][0] = upBand[index][0] - retrace*atr; 
                 }
                 
                 if(loPrice[shift] <= loBand[index][0])  
                 {
                 loBand[index][0] = loPrice[shift];
                 upBand[index][0] = loBand[index][0] + retrace*atr; 
                 }
                 break;        
         }
         
         upSignal[shift] = 0;
         dnSignal[shift] = 0;
         
         if(ShowPriceChannel)
         {  
         hiband[shift] = upBand[index][0];
         loband[shift] = loBand[index][0];
         }
         
         bool upbreak = false, dnbreak = false;
         
         switch(BreakOutMode)
         {
         case 1:  if(upPrice[shift] > upBand[index][1] && trend[index][0] <= 0) upbreak = true;  
                  if(loPrice[shift] < loBand[index][1] && trend[index][0] >= 0) dnbreak = true;
                  break;    
         
         default: if(Close[shift] > upBand[index][1] && trend[index][0] <= 0) upbreak = true;    
                  if(Close[shift] < loBand[index][1] && trend[index][0] >= 0) dnbreak = true;
                  break; 
         }
         
         
         if(upbreak && (loPrice[shift] >= loBand[index][1] ||(loPrice[shift] < loBand[index][1] && Close[shift] > Close[shift+1])) && upBand[index][1] > 0) 
         {
         trend[index][0] = 1; 
          
         int lobar = LowestBar(iBarShift(NULL,0,hiTime[index][0],FALSE) - shift,shift,1);
      
         loValue[index][0] = loPrice[lobar];
         loTime[index][0]  = Time[lobar];
         if(ShowSignals) upSignal[shift] = loValue[index][0];
         if(ShowZigZag ) dnZZ[lobar]     = loValue[index][0];
         }   
                 
         
         if(dnbreak && (upPrice[shift] <= upBand[index][1] ||(upPrice[shift] > upBand[index][1] && Close[shift] < Close[shift+1])) && loBand[index][1] > 0) 
         {
         trend[index][0] =-1; 
         
         int hibar = HighestBar(iBarShift(NULL,0,loTime[index][0],FALSE)-shift,shift,1);
         
         hiValue[index][0] = upPrice[hibar];
         hiTime[index][0]  = Time[hibar];
         if(ShowSignals) dnSignal[shift] = hiValue[index][0];
         if(ShowZigZag ) upZZ[hibar]     = hiValue[index][0]; 
         }
         
        
         
         
         if(shift == 0)
         { 
         upZZ[shift] = 0;
         dnZZ[shift] = 0;  
            
            if(trend[index][0] > 0) 
            {
            int hilen = iBarShift(NULL,0,loTime[index][0],FALSE);
            nhigh = HighestBar(hilen,0,1);
            for (i=hilen;i>=0;i--) upZZ[i] = 0; 
            
            if(ShowZigZag       ) upZZ[nhigh]   = upPrice[nhigh];
            if(!ShowPriceChannel) hiband[shift] = hilen;
            }   

            if(trend[index][0] < 0)
            { 
            int lolen = iBarShift(NULL,0,hiTime[index][0],FALSE);
            nlow = LowestBar(lolen,0,1);
            for (i=lolen;i>=0;i--) dnZZ[i] = 0; 
            
            if(ShowZigZag       ) dnZZ[nlow]    = loPrice[nlow];
            if(!ShowPriceChannel) hiband[shift] = lolen;
            }
         }
      
         if(ZigZagChannelMode > 0)
         { 
         hiBuffer[shift] = hiBuffer[shift+1];
         loBuffer[shift] = loBuffer[shift+1];
       
         if(hiValue[index][0] > 0) hiBuffer[shift] = hiValue[index][0];
         if(ZigZagChannelMode == 1) if(upPrice[shift] > hiBuffer[shift]) hiBuffer[shift] = upPrice[shift]; 
       
         if(loValue[index][0] > 0) loBuffer[shift] = loValue[index][0];    
         if(ZigZagChannelMode == 1) if(loPrice[shift] < loBuffer[shift]) loBuffer[shift] = loPrice[shift]; 
         }
      }
   }

   if(AlertOn || EmailOn || PushNotificationOn)
   {
   bool uptrend = trend[index][AlertShift] > 0 && trend[index][AlertShift+1] <= 0;                  
   bool dntrend = trend[index][AlertShift] < 0 && trend[index][AlertShift+1] >= 0;
         
      if(uptrend || dntrend)
      {
         if(isNewBar(timeframe))
         {
            if(AlertOn)
            {
            BoxAlert(uptrend," : BUY Signal @ " +DoubleToStr(Close[AlertShift],Digits));   
            BoxAlert(dntrend," : SELL Signal @ "+DoubleToStr(Close[AlertShift],Digits)); 
            }
                   
            if(EmailOn)
            {
            EmailAlert(uptrend,"BUY" ," : BUY Signal @ " +DoubleToStr(Close[AlertShift],Digits),EmailsNumber); 
            EmailAlert(dntrend,"SELL"," : SELL Signal @ "+DoubleToStr(Close[AlertShift],Digits),EmailsNumber); 
            }
         
            if(PushNotificationOn)
            {
            PushAlert(uptrend," : BUY Signal @ " +DoubleToStr(Close[AlertShift],Digits));   
            PushAlert(dntrend," : SELL Signal @ "+DoubleToStr(Close[AlertShift],Digits)); 
            }
         }
         else
         {
            if(AlertOn)
            {
            WarningSound(uptrend,SoundsNumber,SoundsPause,UpTrendSound,Time[AlertShift]);
            WarningSound(dntrend,SoundsNumber,SoundsPause,DnTrendSound,Time[AlertShift]);
            }
         }   
      }
   }   
}



//-------------------------------------------  

int LowestBar(int len,int k,int opt)
{
   double min = 10000000;   
   
   if(len <= 0) int lobar = k;
   else   
   for(int i=k+len-1;i>=k;i--)
   {
   double lo0 = loPrice[i];
   if(opt == 1) double lo1 = loPrice[i-1];
   if((opt == 1 && (i==0 || (i > 0/*&& lo0 < lo1*/)) && lo0 <= min) || (opt==0 && lo0 <= min)) {min = lo0; lobar = i;}
   }   
   
   return(lobar);
} 

//-------------------------------------------  

int HighestBar(int len,int k,int opt)
{
   double max = -10000000;   
   
   if(len <= 0) int hibar = k;
   else
   for (int i=k+len-1;i>=k;i--)
   {
   double hi0 = upPrice[i];
   if(opt==1) double hi1 = upPrice[i-1];  
   if((opt==1 && (i==0 || (i > 0 /*&& hi0 > hi1*/)) && hi0 >= max) || (opt==0 && hi0 >= max)) {max = hi0; hibar = i;}
   }   

   return(hibar);
} 
 
string tf(int itimeframe)
{
   string result = "";
   
   switch(itimeframe)
   {
   case PERIOD_M1:   result = "M1" ;
   case PERIOD_M5:   result = "M5" ;
   case PERIOD_M15:  result = "M15";
   case PERIOD_M30:  result = "M30";
   case PERIOD_H1:   result = "H1" ;
   case PERIOD_H4:   result = "H4" ;
   case PERIOD_D1:   result = "D1" ;
   case PERIOD_W1:   result = "W1" ;
   case PERIOD_MN1:  result = "MN1";
   default:          result = "N/A";
   }
   
   if(result == "N/A")
   {
   if(itimeframe <  PERIOD_H1 ) result = "M"  + itimeframe;
   if(itimeframe >= PERIOD_H1 ) result = "H"  + itimeframe/PERIOD_H1;
   if(itimeframe >= PERIOD_D1 ) result = "D"  + itimeframe/PERIOD_D1;
   if(itimeframe >= PERIOD_W1 ) result = "W"  + itimeframe/PERIOD_W1;
   if(itimeframe >= PERIOD_MN1) result = "MN" + itimeframe/PERIOD_MN1;
   }
   
   return(result); 
}
//------------------------------------------- 

// HeikenAshi Price
double   haClose[2][2], haOpen[2][2], haHigh[2][2], haLow[2][2];
datetime prevhatime[2];

double HeikenAshi(int index,int price,int bar)
{ 
   if(prevhatime[index] != Time[bar])
   {
   haClose[index][1] = haClose[index][0];
   haOpen [index][1] = haOpen [index][0];
   haHigh [index][1] = haHigh [index][0];
   haLow  [index][1] = haLow  [index][0];
   prevhatime[index] = Time[bar];
   }
   
   if(bar == Bars - 1) 
   {
   haClose[index][0] = Close[bar];
   haOpen [index][0] = Open [bar];
   haHigh [index][0] = High [bar];
   haLow  [index][0] = Low  [bar];
   }
   else
   {
   haClose[index][0] = (Open[bar] + High[bar] + Low[bar] + Close[bar])/4;
   haOpen [index][0] = (haOpen[index][1] + haClose[index][1])/2;
   haHigh [index][0] = MathMax(High[bar],MathMax(haOpen[index][0],haClose[index][0]));
   haLow  [index][0] = MathMin(Low [bar],MathMin(haOpen[index][0],haClose[index][0]));
   }
   
   switch(price)
   {
   case  0: return(haClose[index][0]); break;
   case  1: return(haOpen [index][0]); break;
   case  2: return(haHigh [index][0]); break;
   case  3: return(haLow  [index][0]); break;
   case  4: return((haHigh[index][0] + haLow[index][0])/2); break;
   case  5: return((haHigh[index][0] + haLow[index][0] +   haClose[index][0])/3); break;
   case  6: return((haHigh[index][0] + haLow[index][0] + 2*haClose[index][0])/4); break;
   default: return(haClose[index][0]); break;
   }
}     


datetime prevnbtime;

bool isNewBar(int tf)
{
   bool res = false;
   
   if(tf >= 0)
   {
      if(iTime(NULL,tf,0) != prevnbtime)
      {
      res   = true;
      prevnbtime = iTime(NULL,tf,0);
      }   
   }
   else res = true;
   
   return(res);
}

string prevmess;
 
bool BoxAlert(bool cond,string text)   
{      
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text;
   
   if (cond && mess != prevmess)
	{
	Alert (mess);
	prevmess = mess; 
	return(true);
	} 
  
   return(false);  
}

datetime pausetime;

bool Pause(int sec)
{
   if(TimeCurrent() >= pausetime + sec) {pausetime = TimeCurrent(); return(true);}
   
   return(false);
}

datetime warningtime;

void WarningSound(bool cond,int num,int sec,string sound,datetime curtime)
{
   static int i;
   
   if(cond)
   {
   if(curtime != warningtime) i = 0; 
   if(i < num && Pause(sec)) {PlaySound(sound); warningtime = curtime; i++;}       	
   }
}

string prevemail;

bool EmailAlert(bool cond,string text1,string text2,int num)   
{      
   string subj = "New " + text1 +" Signal from " + IndicatorName + "!!!";    
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text2;
   
   if (cond && mess != prevemail)
	{
	if(subj != "" && mess != "") for(int i=0;i<num;i++) SendMail(subj, mess);  
	prevemail = mess; 
	return(true);
	} 
  
   return(false);  
}

string prevpush;
 
bool PushAlert(bool cond,string text)   
{      
   string push = IndicatorName + "("+Symbol() + "," + TF + ")" + text;
   
   if(cond && push != prevpush)
	{
	SendNotification(push);
	
	prevpush = push; 
	return(true);
	} 
  
   return(false);  
}

