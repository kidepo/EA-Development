//+------------------------------------------------------------------+
//|                                         VR-Engulfing Pattern.mq4 |
//|                              Copyright 2015, Trading-go Project. |
//|                                             http://trading-go.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Trading-go Project."
#property link      "http://trading-go.ru"
#property version   "1.00"
#property strict
#property indicator_chart_window
//---
datetime masstime[9]={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   for(int i=0; i<=8; i++)
     {
      datetime tim=iTime(Symbol(),TimeFrame(i),0);

      if(masstime[i]==NULL)
        {
         masstime[i]=tim;
         continue;
        }
      if(masstime[i]!=tim)
        {
         masstime[i]=tim;
         double op1=iOpen(Symbol(),TimeFrame(i),1);
         double cl1 = iClose(Symbol(),TimeFrame(i),1);
         double op2 = iOpen (Symbol(),TimeFrame(i),2);
         double cl2 = iClose(Symbol(),TimeFrame(i),2);

         if(op2<cl2 && op1>cl1 && op2>cl1)
            Alert(EnumToString(TimeFrame(i))," Engulfing pattern Bears ",TimeToString(tim));

         if(op2>cl2 && op1<cl1 && op2<cl1)
            Alert(EnumToString(TimeFrame(i))," Engulfing pattern Bulls ",TimeToString(tim));
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TimeFrame(int z)
  {
   ENUM_TIMEFRAMES time=NULL;
   switch(z)
     {
      case 0:time =PERIOD_M1; break;
      case 1:time =PERIOD_M5; break;
      case 2:time =PERIOD_M15; break;
      case 3:time =PERIOD_M30; break;
      case 4:time =PERIOD_H1; break;
      case 5:time =PERIOD_H4; break;
      case 6:time =PERIOD_D1; break;
      case 7:time =PERIOD_W1; break;
      case 8:time =PERIOD_MN1; break;
      default : time=PERIOD_CURRENT;
     }
   return time;
  }
//+------------------------------------------------------------------+
