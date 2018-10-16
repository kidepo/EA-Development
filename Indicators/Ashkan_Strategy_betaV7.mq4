//+------------------------------------------------------------------+
//|                                 60_Second_HH/LL_Break.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

//V1.2
//Change candle break BB Line instead of Close outside


   #property copyright   "Copyright © 2014 // BO_Tutor_Germany // Facebook.de/BO_Tutor"
   #property description  "V7 (Rev 2.0) Updated by Roman // My (Roman's) Attempt to play with a code - nothing guaranteed // Updated accordingly to new RSI rules Ashkan's NewCombination V7"
   #property description "Medium Signal: RSI(14) os/ob(30,70) + RSI(4) ob/os(10,90)"
   #property description "High Signal: RSI(14) os/ob(30,70) + RSI(4) ob/os(10,90) + RSI(22) ob/os(35,65)"
   #property description "Excellent Signal: RSI(14) os/ob(29,71) + RSI(4) ob/os(9,91) + RSI(22) ob/os(34,66) + RSI(32) ob/os(34,66)"
   #property description "Facebook Discussion Group for Binary Options & Forex Traders: http://tinyurl.com/Binary-Options-Facebook "



#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_width1 1
#property indicator_color2 White
#property indicator_width2 1


extern double Arrow_space = 4.5;
extern int    ArrowsUpCode       = 233;
extern int    ArrowsDnCode       = 234;
extern bool   AlertOnCurrent = True;
extern string __Signal_break_BB__="<<= VertexSignal must break VertexBollingerBands ?=>>";
extern bool Use_VTSignal=true;
extern bool VBB_break = true;
extern bool Use_RSI1 = true;
extern bool Use_RSI2 = true;
extern bool Use_RSI3 = true;
extern bool Use_RSI4 = true;
extern bool Use_VC = true;
extern string __Arrow_Filter__="<<= Dont Show Arrows on counter-candles ?=>>";
extern bool candle_filter = false;
extern string __Bollinger_Bands__="<<= Bollinger Bands Settings =>>";
extern bool    Use_BB       =  true;
extern int BB_Period=20;
extern double BB_Deviations=2.0;
 int BB_Shift=0;

extern string __Vertex__="<<= Vertex Settings =>>";


extern int Processed        = 2000;
extern int Control_Period   = 14;

extern int Signal_Period    = 5;
extern int Signal_Method    = MODE_SMA;

extern int BB_Up_Period     = 12;
extern int BB_Up_Deviation  = 2;

extern int BB_Dn_Period     = 12;
extern int BB_Dn_Deviation  = 2;

extern double levelOb       = 6;
extern double levelOs       = -6;
extern string ______RSI1_____="<<=== RSI 1 Settings ===>>";

extern int RSI_Period1=14;
extern double RSI_Lower_Value1=29;
extern double RSI_Upper_Value1=71;
 int RSI_Applied_Price1=0;
extern string ______RSI2_____="<<=== RSI 2 Settings ===>>";

extern int RSI_Period2=4;
extern double RSI_Lower_Value2=9;
extern double RSI_Upper_Value2=91;
 int RSI_Applied_Price2=0;
extern string ______RSI3_____="<<=== RSI 3 Settings ===>>";

extern int RSI_Period3=22;
extern double RSI_Lower_Value3=34;
extern double RSI_Upper_Value3=66;
 int RSI_Applied_Price3=0;
 extern string ______RSI4_____="<<=== RSI 4 Settings ===>>";

extern int RSI_Period4=32;
extern double RSI_Lower_Value4=34;
extern double RSI_Upper_Value4=66;
 int RSI_Applied_Price4=0;
extern string ___CHT_Value_Chart___="<<== CHT Value Chart Settings ==>>";

 int VC_Period = 0;
 int VC_NumBars = 5;
extern int VC_Bars2Check = 25;
extern bool VC_UseDynamicSRLevels = false;
 int VC_DynamicSRPeriod = 60;
 double VC_DynamicSRCut = 0.02;
extern double VC_Overbought = 8;
extern double VC_Oversold = -8;

 color VC_UpColor = SeaGreen;
 color VC_DownColor = Tomato;
 int VC_WickWidth = 1;
 int VC_BodyWidth = 4;
 color VC_ResistanceColor = Tomato;
 color VC_SupportColor = SeaGreen;

bool VC_DisplayChart = false;
bool VC_AlertON = false;
double VC_AlertSRAnticipation = 1.0;




 bool   alertsOn        = true;
 bool   alertsOnCurrent = true;
 bool   alertsMessage   = true;
 bool   alertsSound     = true;
 bool   alertsEmail     = false;
 string soundfile       = "alert2.wav";


bool show_arrow = true;
bool enable_alert = true;

double arr_up[];
double arr_dn[];

double     myPoint;
int        myDigits;

int gAlertShift = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
   myPoint     =  MarketInfo(Symbol(),MODE_POINT);
   myDigits    =  MarketInfo(Symbol(),MODE_DIGITS);
   if(myDigits==3 || myDigits==5)
   {
      myPoint     =  myPoint  *  10;
      myDigits    =  myDigits -1;
   }    
  
   if(show_arrow)
   {
//---- indicators
      SetIndexBuffer(0, arr_up);
      SetIndexBuffer(1, arr_dn);  
//---- drawing settings
      SetIndexStyle(0, DRAW_ARROW);
      SetIndexArrow(0, ArrowsUpCode);
      SetIndexStyle(1, DRAW_ARROW);
      SetIndexArrow(1, ArrowsDnCode);
      
      SetIndexLabel(0, "BUY Signal");
      SetIndexLabel(1, "SELL Signal");

      IndicatorDigits(Digits);
   }
   
   gAlertShift = 1;
   if(AlertOnCurrent) gAlertShift = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("EntryLine11");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{

   int    counted_bars=IndicatorCounted();
   //----   
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   
   int j;
   for(int i=limit; i>=0; i--)
   {
      arr_up[i] = EMPTY_VALUE; arr_dn[i] = EMPTY_VALUE;      
      
      j=i;
      double var1 = 0;
      double var2 = 0;
      for (j = i; j <= i + 9; j++) var2 += MathAbs(High[j] - Low[j]);
      var1 = var2 / 10.0;


               double VTSignal =(iCustom(Symbol(), 0, "!vertex_mod_3 alerts",Processed,Control_Period,Signal_Period,Signal_Method,BB_Up_Period,BB_Up_Deviation,BB_Dn_Period,BB_Dn_Deviation,levelOb,levelOs, 0, i) ) ;
            double VTBBup = (iCustom(Symbol(), 0, "!vertex_mod_3 alerts",Processed,Control_Period,Signal_Period,Signal_Method,BB_Up_Period,BB_Up_Deviation,BB_Dn_Period,BB_Dn_Deviation,levelOb,levelOs, 2, i) ) ;
                  double VTBBdn = (iCustom(Symbol(), 0, "!vertex_mod_3 alerts",Processed,Control_Period,Signal_Period,Signal_Method,BB_Up_Period,BB_Up_Deviation,BB_Dn_Period,BB_Dn_Deviation,levelOb,levelOs, 3, i) ) ;

      double vhc_high=iCustom(Symbol(),0,"CHT_Value_chart_v2.5.3",VC_Period,VC_NumBars,VC_Bars2Check,VC_DisplayChart,VC_UseDynamicSRLevels,VC_DynamicSRPeriod,VC_DynamicSRCut,VC_Overbought,VC_Oversold,VC_AlertON,VC_AlertSRAnticipation,VC_UpColor,VC_DownColor,VC_WickWidth,VC_BodyWidth,VC_ResistanceColor,VC_SupportColor,0,i);
      double vhc_low=iCustom(Symbol(),0,"CHT_Value_chart_v2.5.3",VC_Period,VC_NumBars,VC_Bars2Check,VC_DisplayChart,VC_UseDynamicSRLevels,VC_DynamicSRPeriod,VC_DynamicSRCut,VC_Overbought,VC_Oversold,VC_AlertON,VC_AlertSRAnticipation,VC_UpColor,VC_DownColor,VC_WickWidth,VC_BodyWidth,VC_ResistanceColor,VC_SupportColor,1,i);           
      double rsi1=iRSI(Symbol(),0,RSI_Period1,RSI_Applied_Price1,i);
      double rsi2=iRSI(Symbol(),0,RSI_Period2,RSI_Applied_Price2,i);
      double rsi3=iRSI(Symbol(),0,RSI_Period3,RSI_Applied_Price3,i);
      double rsi4=iRSI(Symbol(),0,RSI_Period4,RSI_Applied_Price4,i);
      double bbup1=iBands(Symbol(),0,BB_Period,BB_Deviations,BB_Shift,0,MODE_UPPER,i);
      double bbdn1=iBands(Symbol(),0,BB_Period,BB_Deviations,BB_Shift,0,MODE_LOWER,i);
      double low1=iLow(Symbol(),0,i);
      double high1=iHigh(Symbol(),0,i);
      double close1=iClose(Symbol(),0,i);


      
      if(
      
        VTSignal <=levelOs && (!candle_filter || Open[i]>=Close[i]) && (!VBB_break || VTSignal < VTBBdn)
        && (!Use_RSI1 || rsi1<RSI_Lower_Value1)
        && (!Use_RSI2 || rsi2<RSI_Lower_Value2)
        && (!Use_RSI3 || rsi3<RSI_Lower_Value3)
        && (!Use_RSI4 || rsi4<RSI_Lower_Value4)
                    && (!Use_VC || vhc_low<VC_Oversold)
                        && (!Use_BB || close1<=bbdn1)
                    
           
         
        )
      {
         arr_up[i]=iLow(Symbol(),0,i) - (var1/Arrow_space);
           
      }
      else if(
       
       VTSignal>=levelOb && (!candle_filter || Open[i]<=Close[i]) && (!VBB_break || VTSignal > VTBBup)
               && (!Use_RSI1 || rsi1>RSI_Upper_Value1)
               && (!Use_RSI2 || rsi2>RSI_Upper_Value2)
               && (!Use_RSI3 || rsi3>RSI_Upper_Value3)
               && (!Use_RSI4 || rsi3>RSI_Upper_Value4)
                              &&(!Use_VC || vhc_high>VC_Overbought)
                                 && (!Use_BB || close1>=bbup1)
               
        )
      {
         arr_dn[i]=iHigh(Symbol(),0,i) + (var1/Arrow_space);      
             
      }        
   }
   
   static datetime dtlboai11;
   
   if(dtlboai11!=iTime(Symbol(),0,0))
   {
      string stralert;
      if(arr_up[gAlertShift]!=EMPTY_VALUE)
      {
         stralert="Vertex Long Signal"+ Symbol()+ " " + strtf(Period()) + "Time: "+TimeToStr(TimeCurrent(),TIME_MINUTES) + "";
         Alert(stralert);
         dtlboai11=iTime(Symbol(),0,0);
      }
      else if(arr_dn[gAlertShift]!=EMPTY_VALUE)
      {
         stralert="Vertex Short Signal"+ Symbol()+ " " + strtf(Period()) + "Time: "+TimeToStr(TimeCurrent(),TIME_MINUTES) + "";
         Alert(stralert);
         dtlboai11=iTime(Symbol(),0,0);
      }
   }
   
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

string strtf(int tf)
{
   switch(tf)
   {
      case PERIOD_M1: return("M1");
      case PERIOD_M5: return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H4: return("H4");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN1");
      default:return("Unknown timeframe");
   }
}


void DrawLine(string sName, double dPrice,color cLineClr=CLR_NONE)
{
    int iWidth=1;
    string sObjName = sName;

    if(ObjectFind(sObjName) == -1){
        // create object 
        ObjectCreate(sObjName,OBJ_HLINE, 0, 0,0);
    }

    ObjectSet(sObjName,OBJPROP_PRICE1,dPrice);
    ObjectSet(sObjName, OBJPROP_COLOR, cLineClr);
    ObjectSet(sObjName, OBJPROP_WIDTH, iWidth);
    ObjectSet(sObjName, OBJPROP_STYLE, STYLE_DOT);
}
