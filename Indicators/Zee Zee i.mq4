//+------------------------------------------------------------------+
//|                                                    Zee Zee i.mq4 |
//|                                Copyright © 2007, Carlos J. Rivas |
//|                                                 carlos@vealo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Carlos J. Rivas"
#property link      "carlos@vealo.com"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color5 Red
#property indicator_color4 CLR_NONE
#property indicator_color3 CLR_NONE
#property indicator_color2 CLR_NONE
#property indicator_color1 Gainsboro
#property indicator_color6 Blue
#property indicator_level1 100
#property indicator_level2 -100
#property indicator_levelcolor Gainsboro

//---- input parameters
extern int CCIPeriod=14;
//---- buffers
double CCIBuffer[];
double CCIBufferHi[];
double CCIBufferLow[];
double RelBuffer[];
double DevBuffer[];
double MovBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   
    
//---- 3 additional buffers are used for counting.
   //IndicatorBuffers(6);
   SetIndexBuffer(1, RelBuffer);
   SetIndexBuffer(2, DevBuffer);
   SetIndexBuffer(3, MovBuffer);
   SetIndexBuffer(4, CCIBufferHi);
   SetIndexBuffer(5, CCIBufferLow);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,CCIBuffer);

   SetIndexStyle(4,DRAW_LINE,0,3);
   SetIndexBuffer(4,CCIBufferHi);

   SetIndexStyle(5,DRAW_LINE,0,3);
   SetIndexBuffer(5,CCIBufferLow);

//---- name for DataWindow and indicator subwindow label
   short_name=" ("+CCIPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   //SetIndexDrawBegin(0,CCIPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Commodity Channel Index                                          |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k,counted_bars=IndicatorCounted();
   double price,sum,mul;
   if(Bars<=CCIPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=CCIPeriod;i++) CCIBuffer[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod;i++) DevBuffer[Bars-i]=0.0;
      for(i=1;i<=CCIPeriod;i++) MovBuffer[Bars-i]=0.0;
     }
//---- last counted bar will be recounted
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
//---- moving average
   for(i=0; i<limit; i++)
      MovBuffer[i]=iMA(NULL,0,CCIPeriod,0,MODE_SMA,PRICE_OPEN,i);
//---- standard deviations
   i=Bars-CCIPeriod+1;
   if(counted_bars>CCIPeriod-1) i=Bars-counted_bars-1;
   mul=0.010/CCIPeriod;
   while(i>=0)
     {
      sum=0.0;
      k=i+CCIPeriod-1;
      while(k>=i)
       {
         price=(Open[k])/1;
         sum+=MathAbs(price-MovBuffer[i]);
         k--;
       }
      DevBuffer[i]=sum*mul;
      i--;
     }
   i=Bars-CCIPeriod+1;
   if(counted_bars>CCIPeriod-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      price=(Open[i])/1;
      RelBuffer[i]=price-MovBuffer[i];
      i--;
     }
//---- cci counting
   i=Bars-CCIPeriod+1;
   if(counted_bars>CCIPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      if(DevBuffer[i]==0.0) CCIBuffer[i]=0.0;
      else CCIBuffer[i]=RelBuffer[i]/DevBuffer[i];
      
      if (CCIBuffer[i] >= 200) {
        CCIBufferHi[i]=CCIBuffer[i];
        //CCIBuffer[i]=0.0;
      } 

      if (CCIBuffer[i] <= -200) {
        CCIBufferLow[i]=CCIBuffer[i];
        //CCIBuffer[i]=0.0;
      } 

      
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+