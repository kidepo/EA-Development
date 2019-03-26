
#property copyright ""
#property link      ""

#property indicator_separate_window
//---- input parameters
extern double  Risk_to_Reward_ratio =  3.0;
int nDigits;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
IndicatorShortName("AVR");
   if(Symbol()=="GBPJPY" || Symbol()=="EURJPY" || Symbol()=="USDJPY" || Symbol()=="GOLD" || Symbol()=="USDMXN") nDigits = 2;
   if(Symbol()=="GBPUSD" || Symbol()=="EURUSD" || Symbol()=="NZDUSD" || Symbol()=="USDCHF"  ||
   Symbol()=="USDCAD" || Symbol()=="AUDUSD" || Symbol()=="EURUSD" || Symbol()=="EURCHF"  || Symbol()=="EURGBP"
   || Symbol()=="EURCAD" || Symbol()=="EURAUD" || Symbol()=="AUDNZD")nDigits = 4;

   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //----
   int R1=0,R5=0,R10=0,R20=0,RAvg=0;
   int RoomUp=0,RoomDown=0,StopLoss_Long=0,StopLoss_Short=0;
   double   SL_Long=0,SL_Short=0;
   double   low0=0,high0=0;
   string   Text="";
   int i=0;

   R1 =  (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   for(i=1;i<=5;i++)
      R5    =    R5  +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=10;i++)
      R10   =    R10 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=20;i++)
      R20   =    R20 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;

   R5 = R5/5;
   R10 = R10/10;
   R20 = R20/20;
   RAvg  =  (R1+R5+R10+R20)/4;    

   low0  =  iLow(NULL,PERIOD_D1,0);
   high0 =  iHigh(NULL,PERIOD_D1,0);
   RoomUp   =  RAvg - (Bid - low0)/Point;
   RoomDown =  RAvg - (high0 - Bid)/Point;
   StopLoss_Long  =  RoomUp/Risk_to_Reward_ratio;
   SL_Long        =  Bid - StopLoss_Long*Point;
   StopLoss_Short =  RoomDown/Risk_to_Reward_ratio;
   SL_Short       =  Bid + StopLoss_Short*Point;


   Text =   "Average Day  Range: " +  RAvg + "\n"  + 
            "Prev 01  Day  Range: " +  R1   + "\n" + 
            "Prev 05  Days Range: " +  R5   + "\n" + 
            "Prev 10  Days Range: " +  R10  + "\n" +
            "Prev 20  Days Range: " +  R20  + "\n";
   Text =   Text +
            "Room Up:     " + RoomUp              + "\n" +
            "Room Down: " + RoomDown            + "\n" +
            "Maximum StopLosses :"  + "\n" +
            "Long:  " + StopLoss_Long  + " Pips at " + DoubleToStr(SL_Long,nDigits)  + "\n" +
            "Short: " + StopLoss_Short + " Pips at " + DoubleToStr(SL_Short,nDigits) + "\n" ;

   Comment(Text);
  
   string P=Period();
  
   
        ObjectCreate("AVR", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR",StringSubstr(Symbol(),0),12, "Arial Bold", CadetBlue);
        ObjectSet("AVR", OBJPROP_CORNER, 0);
        ObjectSet("AVR", OBJPROP_XDISTANCE, 25);
        ObjectSet("AVR", OBJPROP_YDISTANCE, 2);
        ObjectCreate("AVR1", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR1",StringSubstr(P,0),12, "Arial Bold", CadetBlue);
        ObjectSet("AVR1", OBJPROP_CORNER, 0);
        ObjectSet("AVR1", OBJPROP_XDISTANCE, 100);
        ObjectSet("AVR1", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("AVR2", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR2","Average Daily Range:", 10, "Arial Bold", CadetBlue);
        ObjectSet("AVR2", OBJPROP_CORNER, 0);
        ObjectSet("AVR2", OBJPROP_XDISTANCE, 150);
        ObjectSet("AVR2", OBJPROP_YDISTANCE, 2);
        ObjectCreate("AVR3", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR3",DoubleToStr(RAvg ,0),12, "Arial Bold", Orange);
        ObjectSet("AVR3", OBJPROP_CORNER, 0);
        ObjectSet("AVR3", OBJPROP_XDISTANCE, 300);
        ObjectSet("AVR3", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("AVR4", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR4","Prev 01 Day Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR4", OBJPROP_CORNER, 0);
        ObjectSet("AVR4", OBJPROP_XDISTANCE, 25);
        ObjectSet("AVR4", OBJPROP_YDISTANCE, 20);
        ObjectCreate("AVR5", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR5",DoubleToStr(R1,0),12, "Arial Bold", Orange);
        ObjectSet("AVR5", OBJPROP_CORNER, 0);
        ObjectSet("AVR5", OBJPROP_XDISTANCE, 160);
        ObjectSet("AVR5", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("AVR6", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR6","Prev 05 Days Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR6", OBJPROP_CORNER, 0);
        ObjectSet("AVR6", OBJPROP_XDISTANCE, 25);
        ObjectSet("AVR6", OBJPROP_YDISTANCE, 35);
        ObjectCreate("AVR7", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR7",DoubleToStr(R5,0),12, "Arial Bold", Orange);
        ObjectSet("AVR7", OBJPROP_CORNER, 0);
        ObjectSet("AVR7", OBJPROP_XDISTANCE, 160);
        ObjectSet("AVR7", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("AVR8", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR8","Prev 10 Days Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR8", OBJPROP_CORNER, 0);
        ObjectSet("AVR8", OBJPROP_XDISTANCE, 220);
        ObjectSet("AVR8", OBJPROP_YDISTANCE, 20);
        ObjectCreate("AVR9", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR9",DoubleToStr(R10,0),12, "Arial Bold", Orange);
        ObjectSet("AVR9", OBJPROP_CORNER, 0);
        ObjectSet("AVR9", OBJPROP_XDISTANCE, 355);
        ObjectSet("AVR9", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("AVR10", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR10","Prev 20 Days Range:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR10", OBJPROP_CORNER, 0);
        ObjectSet("AVR10", OBJPROP_XDISTANCE, 220);
        ObjectSet("AVR10", OBJPROP_YDISTANCE, 35);
        ObjectCreate("AVR11", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR11",DoubleToStr(R20,0),12, "Arial Bold", Orange);
        ObjectSet("AVR11", OBJPROP_CORNER, 0);
        ObjectSet("AVR11", OBJPROP_XDISTANCE, 355);
        ObjectSet("AVR11", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("AVR12", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR12","Room UP:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR12", OBJPROP_CORNER, 0);
        ObjectSet("AVR12", OBJPROP_XDISTANCE, 420);
        ObjectSet("AVR12", OBJPROP_YDISTANCE, 20);
        ObjectCreate("AVR13", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR13",DoubleToStr(RoomUp,0),12, "Arial Bold", Orange);
        ObjectSet("AVR13", OBJPROP_CORNER, 0);
        ObjectSet("AVR13", OBJPROP_XDISTANCE, 490);
        ObjectSet("AVR13", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("AVR14", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR14","Room DN:", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR14", OBJPROP_CORNER, 0);
        ObjectSet("AVR14", OBJPROP_XDISTANCE, 420);
        ObjectSet("AVR14", OBJPROP_YDISTANCE, 35);
        ObjectCreate("AVR15", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR15",DoubleToStr(RoomDown,0),12, "Arial Bold", Orange);
        ObjectSet("AVR15", OBJPROP_CORNER, 0);
        ObjectSet("AVR15", OBJPROP_XDISTANCE, 490);
        ObjectSet("AVR15", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("AVR16", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR16","Maximum StopLosses;",10, "Arial Bold", CadetBlue);
        ObjectSet("AVR16", OBJPROP_CORNER, 0);
        ObjectSet("AVR16", OBJPROP_XDISTANCE, 560);
        ObjectSet("AVR16", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("AVR17", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR17","Long:             Pips at", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR17", OBJPROP_CORNER, 0);
        ObjectSet("AVR17", OBJPROP_XDISTANCE, 560);
        ObjectSet("AVR17", OBJPROP_YDISTANCE, 20);
        ObjectCreate("AVR18", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR18",DoubleToStr(StopLoss_Long,0),12, "Arial Bold", Orange);
        ObjectSet("AVR18", OBJPROP_CORNER, 0);
        ObjectSet("AVR18", OBJPROP_XDISTANCE, 600);
        ObjectSet("AVR18", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("AVR19", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR19","Short:             Pips at", 10, "Arial ", LightSteelBlue);
        ObjectSet("AVR19", OBJPROP_CORNER, 0);
        ObjectSet("AVR19", OBJPROP_XDISTANCE, 560);
        ObjectSet("AVR19", OBJPROP_YDISTANCE, 35);
        ObjectCreate("AVR20", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR20",DoubleToStr(StopLoss_Short,0),12, "Arial Bold", Orange);
        ObjectSet("AVR20", OBJPROP_CORNER, 0);
        ObjectSet("AVR20", OBJPROP_XDISTANCE, 600);
        ObjectSet("AVR20", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("AVR21", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR21",DoubleToStr(SL_Long,nDigits),12, "Arial Bold", SteelBlue);
        ObjectSet("AVR21", OBJPROP_CORNER, 0);
        ObjectSet("AVR21", OBJPROP_XDISTANCE, 690);
        ObjectSet("AVR21", OBJPROP_YDISTANCE, 20);
        ObjectCreate("AVR22", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR22",DoubleToStr(SL_Short,nDigits),12, "Arial Bold",SteelBlue);
        ObjectSet("AVR22", OBJPROP_CORNER, 0);
        ObjectSet("AVR22", OBJPROP_XDISTANCE, 690);
        ObjectSet("AVR22", OBJPROP_YDISTANCE, 35);
        
        ObjectCreate("AVR23", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR23","Risk to Reward Ratio:", 10, "Arial Bold", CadetBlue);
        ObjectSet("AVR23", OBJPROP_CORNER, 0);
        ObjectSet("AVR23", OBJPROP_XDISTANCE, 350);
        ObjectSet("AVR23", OBJPROP_YDISTANCE, 2);
        ObjectCreate("AVR24", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("AVR24",DoubleToStr( Risk_to_Reward_ratio ,0),12, "Arial Bold", Orange);
        ObjectSet("AVR24", OBJPROP_CORNER, 0);
        ObjectSet("AVR24", OBJPROP_XDISTANCE, 500);
        ObjectSet("AVR24", OBJPROP_YDISTANCE, 2);
        
     
        double HIDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_HIGH,PRICE_HIGH,0);
        double LOWDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_LOW,PRICE_LOW,0); 
        double YEST_HIDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_HIGH,PRICE_HIGH,1);
        double YEST_LOWDaily = iMA(Symbol(),PERIOD_D1,1,0,MODE_LOW,PRICE_LOW,1); 
   
        ObjectCreate("high", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("high",DoubleToStr(HIDaily,Digits), 12, "Arial Bold", Orange);
        ObjectSet("high", OBJPROP_CORNER, 0);
        ObjectSet("high", OBJPROP_XDISTANCE, 890);
        ObjectSet("high", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("high2", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("high2","DailyHigh", 9, "Arial Bold", CadetBlue);
        ObjectSet("high2", OBJPROP_CORNER, 0);
        ObjectSet("high2", OBJPROP_XDISTANCE, 890);
        ObjectSet("high2", OBJPROP_YDISTANCE, 2);
        
        ObjectCreate("low", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("low",DoubleToStr(LOWDaily,Digits), 12, "Arial Bold", Orange);
        ObjectSet("low", OBJPROP_CORNER, 0);
        ObjectSet("low", OBJPROP_XDISTANCE, 830);
        ObjectSet("low", OBJPROP_YDISTANCE, 20);
        
        ObjectCreate("low2", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("low2","DailyLow", 9, "Arial Bold", CadetBlue);
        ObjectSet("low2", OBJPROP_CORNER, 0);
        ObjectSet("low2", OBJPROP_XDISTANCE, 830);
        ObjectSet("low2", OBJPROP_YDISTANCE, 2);
        
         double CURR = iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
   
           
        ObjectCreate("high3", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("high3",DoubleToStr(CURR,Digits), 12, "Arial Bold", Coral);
        ObjectSet("high3", OBJPROP_CORNER, 0);
        ObjectSet("high3", OBJPROP_XDISTANCE, 890);
        ObjectSet("high3", OBJPROP_YDISTANCE,35 );
            
        ObjectCreate("high4", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("high4",DoubleToStr(CURR,Digits), 12, "Arial Bold", Coral);
        ObjectSet("high4", OBJPROP_CORNER, 0);
        ObjectSet("high4", OBJPROP_XDISTANCE, 830);
        ObjectSet("high4", OBJPROP_YDISTANCE,35 );
        
        ObjectCreate("low4", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("low4","T/Day", 9, "Arial ", LightSteelBlue);
        ObjectSet("low4", OBJPROP_CORNER, 0);
        ObjectSet("low4", OBJPROP_XDISTANCE, 790);
        ObjectSet("low4", OBJPROP_YDISTANCE, 20);
        ObjectCreate("low5", OBJ_LABEL, WindowFind("AVR"), 0, 0);
        ObjectSetText("low5","Price", 9, "Arial ", LightSteelBlue);
        ObjectSet("low5", OBJPROP_CORNER, 0);
        ObjectSet("low5", OBJPROP_XDISTANCE, 790);
        ObjectSet("low5", OBJPROP_YDISTANCE, 37);
   
   


   return(0);
  }
//+------------------------------------------------------------------+