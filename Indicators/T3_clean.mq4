//+------------------------------------------------------------------+
//|                                                     T3 clean.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Lime
#property indicator_width1 2
//+------------------------------------------------------------------+
extern int    T3Period  = 13;
extern int    T3Price   = PRICE_CLOSE;
extern double b         = 0.518;
extern string TimeFrame = "current time frame";
//+------------------------------------------------------------------+
double t3Array[];
double ae1[];
double ae2[];
double ae3[];
double ae4[];
double ae5[];
double ae6[];
int    timeFrame;
string IndicatorFileName;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int init()
  {
   IndicatorBuffers(7);
   SetIndexBuffer(0,t3Array);
   SetIndexBuffer(1,ae1);
   SetIndexBuffer(2,ae2);
   SetIndexBuffer(3,ae3);
   SetIndexBuffer(4,ae4);
   SetIndexBuffer(5,ae5);
   SetIndexBuffer(6,ae6);
   timeFrame=stringToTimeFrame(TimeFrame);
   IndicatorShortName("T3 Moving Average "+TimeFrameToString(timeFrame)+"("+T3Period+")");
   IndicatorFileName=WindowExpertName();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(timeFrame!=Period())
     {
      datetime TimeArray[];
      limit=MathMax(limit,timeFrame/Period());
      ArrayCopySeries(TimeArray,MODE_TIME,NULL,timeFrame);
      int y=0;
      for(i=0; i<limit; i++)
        {
         if(Time[i]<TimeArray[y]) y++;
         t3Array[i]=iCustom(NULL,timeFrame,IndicatorFileName,T3Period,T3Price,b,0,y);
        }
      return(0);
     }
   CalculateT3(limit,T3Period,T3Price);
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int    t3period;
double e1,e2,e3,e4,e5,e6;
double c1,c2,c3,c4;
double w1,w2,b2,b3;
void CalculateT3(int limit,int period,int priceType)
  {
   if(t3period!=period)
     {
      t3period=period;
      b2 = b*b;
      b3 = b2*b;

      c1 = -b3;
      c2 = (3*(b2+b3));
      c3 = -3*(2*b2+b+b3);
      c4 = (1+3*b+b3+3*b2);

      w1 = 2 / (2 + 0.5*(MathMax(1,period)-1));
      w2 = 1 - w1;
     }
   for(int i=limit; i>=0; i--)
     {
      double price=iMA(NULL,0,1,0,MODE_SMA,priceType,i);
      e1 = w1*price + w2*ae1[i+1];
      e2 = w1*e1    + w2*ae2[i+1];
      e3 = w1*e2    + w2*ae3[i+1];
      e4 = w1*e3    + w2*ae4[i+1];
      e5 = w1*e4    + w2*ae5[i+1];
      e6 = w1*e5    + w2*ae6[i+1];
      t3Array[i]=c1*e6+c2*e5+c3*e4+c4*e3;
      ae1[i] = e1;
      ae2[i] = e2;
      ae3[i] = e3;
      ae4[i] = e4;
      ae5[i] = e5;
      ae6[i] = e6;
     }
  }
//+------------------------------------------------------------------+
//|
//+------------------------------------------------------------------+
int stringToTimeFrame(string tfs)
  {
   int tf=0;
   tfs=StringTrimLeft(StringTrimRight(StringUpperCase(tfs)));
   if(tfs=="M1" || tfs=="1")     tf=PERIOD_M1;
   if(tfs=="M5" || tfs=="5")     tf=PERIOD_M5;
   if(tfs=="M15"|| tfs=="15")    tf=PERIOD_M15;
   if(tfs=="M30"|| tfs=="30")    tf=PERIOD_M30;
   if(tfs=="H1" || tfs=="60")    tf=PERIOD_H1;
   if(tfs=="H4" || tfs=="240")   tf=PERIOD_H4;
   if(tfs=="D1" || tfs=="1440")  tf=PERIOD_D1;
   if(tfs=="W1" || tfs=="10080") tf=PERIOD_W1;
   if(tfs=="MN" || tfs=="43200") tf=PERIOD_MN1;
   if(tf<Period()) tf=Period();
   return(tf);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TimeFrameToString(int tf)
  {
   string tfs="";

   if(tf!=Period())
      switch(tf) 
        {
         case PERIOD_M1:  tfs="M1"; break;
         case PERIOD_M5:  tfs="M5"; break;
         case PERIOD_M15: tfs="M15"; break;
         case PERIOD_M30: tfs="M30"; break;
         case PERIOD_H1:  tfs="H1"; break;
         case PERIOD_H4:  tfs="H4"; break;
         case PERIOD_D1:  tfs="D1"; break;
         case PERIOD_W1:  tfs="W1"; break;
         case PERIOD_MN1: tfs="MN1";
        }
   return(tfs);
  }
//+------------------------------------------------------------------+
string StringUpperCase(string str)
  {
   string   s=str;
   int      lenght=StringLen(str)-1;
   int      _char;

   while(lenght>=0)
     {
      _char=StringGetChar(s,lenght);
      if((_char>96 && _char<123) || (_char>223 && _char<256))
         s=StringSetChar(s,lenght,_char-32);
      else
      if(_char>-33 && _char<0)
         s=StringSetChar(s,lenght,_char+224);
      lenght--;
     }
   return(s);
  }
//+------------------------------------------------------------------+
