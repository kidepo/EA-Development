

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Yellow
#property indicator_color2 Magenta
#property indicator_color3 Magenta
#property indicator_color4 Aqua
#property indicator_color5 Aqua
#property indicator_color6 Yellow
#property indicator_color7 Yellow

//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];
double P5Buffer[];
double P6Buffer[];
double P7Buffer[];

int myPeriod=PERIOD_D1;

double PP,R1,S1,R2,S2,R3,S3,Q;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,P1Buffer);
   SetIndexBuffer(1,P2Buffer);
   SetIndexBuffer(2,P3Buffer);
   SetIndexBuffer(3,P4Buffer);
   SetIndexBuffer(4,P5Buffer);
   SetIndexBuffer(5,P6Buffer);
   SetIndexBuffer(6,P7Buffer);

   SetIndexStyle(0,DRAW_LINE,STYLE_DASHDOTDOT,0);
   SetIndexStyle(1,DRAW_LINE,STYLE_DASHDOTDOT,2);
   SetIndexStyle(2,DRAW_LINE,STYLE_DASHDOTDOT,2);
   SetIndexStyle(3,DRAW_LINE,STYLE_DASHDOTDOT,2);
   SetIndexStyle(4,DRAW_LINE,STYLE_DASHDOTDOT,2);
   SetIndexStyle(5,DRAW_LINE,STYLE_DASHDOTDOT,2);
   SetIndexStyle(6,DRAW_LINE,STYLE_DASHDOTDOT,2);
  
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("WeekP");
   ObjectDelete("WeekR1");
   ObjectDelete("WeekR2");
   ObjectDelete("WeekR3");
   ObjectDelete("WeekS1");
   ObjectDelete("WeekS2");
   ObjectDelete("WeekS3");
   ObjectDelete("txtWeekP");
   ObjectDelete("txtWeekR1");
   ObjectDelete("txtWeekR2");
   ObjectDelete("txtWeekR3");
   ObjectDelete("txtWeekS1");
   ObjectDelete("txtWeekS2");
   ObjectDelete("txtWeekS3");
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,dayi,counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;  
   int limit=Bars-counted_bars;
   
   for(i=limit-1; i>=0; i--)
    {
       dayi=iBarShift(Symbol(), myPeriod, Time[i],false);
       
       Q=(iHigh(Symbol(), myPeriod,dayi+1)-iLow(Symbol(), myPeriod,dayi+1));
       
       PP=(iHigh(Symbol(), myPeriod,dayi+1) + 
           iLow(Symbol(), myPeriod,dayi+1) +
           iClose(Symbol(), myPeriod,dayi+1)) / 3;
                     
           
       R1=PP + (Q * 0.38);
       S1=PP - (Q * 0.38);

       R2=PP + (Q * 1.00);
       S2=PP - (Q * 1.00);

       R3=PP + (Q * 1.38);
       S3=PP - (Q * 1.38);

       P1Buffer[i]=PP;
       SetPrice("WeekP",Time[i],PP,Yellow);
       SetText("txtWeekP","WP",Time[i],PP,Yellow);

       P2Buffer[i]=R1;
       SetPrice("WeekR1",Time[i],R1,Magenta);
       SetText("txtWeekR1","W-R38%",Time[i],R1,Magenta);

       P3Buffer[i]=S1;
       SetPrice("WeekS1",Time[i],S1,Magenta);
       SetText("txtWeekS1","W-S38%",Time[i],S1,Magenta);

       P4Buffer[i]=R2;
       SetPrice("WeekR2",Time[i],R2,Aqua);
       SetText("txtWeekR2","W-R100%",Time[i],R2,Aqua);

       P5Buffer[i]=S2;
       SetPrice("WeekS2",Time[i],S2,Aqua);
       SetText("txtWeekS2","W-S100%",Time[i],S2,Aqua);

       P6Buffer[i]=R3;
       SetPrice("WeekR3",Time[i],R3,Yellow);
       SetText("txtWeekR3","W-R138%",Time[i],R3,Yellow);

       P7Buffer[i]=S3;
       SetPrice("WeekS3",Time[i],S3,Yellow);
       SetText("txtWeekS3","W-S138%",Time[i],S3,Yellow);

    }
//----
   return(0);
  }

void SetPrice(string name,datetime Tm,double Prc,color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_ARROW, 0, Tm, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 2);
       ObjectSet(name, OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 2);
       ObjectSet(name, OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
     } 
  }

void SetText(string name,string txt,datetime Tm,double Prc,color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_TEXT, 0, Tm, Prc);
       ObjectSetText(name,txt, 9, "Arial", clr);
       ObjectSet(name, OBJPROP_CORNER,2);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSetText(name,txt, 9, "Arial", clr);
       ObjectSet(name, OBJPROP_CORNER,2);
     } 
  }

//+------------------------------------------------------------------+