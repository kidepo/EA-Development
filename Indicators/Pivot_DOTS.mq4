

#property indicator_chart_window

extern int   GMTshift          = 0;
extern bool  Plot_PIVOTS       = true;
extern bool  Plot_M_Levels     = true;
extern int   DOT_Type          = 6;//174
extern int   Shift_DOTS        = -5;
extern color Central_PIVOT     = Lime;
extern int   PIVOT_Size        = 1;
extern color R1_R2_R3          = DodgerBlue;
extern color S1_S2_S3          = Red;
extern int   S_R_Levels_Size   = 1; 
extern color M0_M1_M2          = FireBrick;
extern color M3_M4_M5          = RoyalBlue; 
extern int   MLevelS_Size      = 1;
extern bool  ShowPivotLables   = true;
extern int   ShiftPivotLabels  = -12;
extern int   AdjustLabel_UP_DN = 3;
extern bool  Show_StartTime    = true; 
extern color StartTime_color   = Red;
extern bool  DeleteStartLabel  = true;

#define DailyStart "DailyStart"

double day_high;
double day_low;
double yesterday_open;
double today_open;
double cur_day;
double prev_day;

double yesterday_high=0;
double yesterday_low=0;
double yesterday_close=0;

   datetime time1;
   datetime time2;
   double open,close,high,low;
   double P,R1,R2,R3,S1,S2,S3,M0,M1,M2,M3,M4,M5;
   double H1,H2,H3,H4,L1,L2,L3,L4,Range;
   int shift, num;
     
   void ObjDel()
   {
      for (;num<=0;num++)
      {
      ObjectDelete("PP["+num+"]");
      ObjectDelete("R1["+num+"]");
      ObjectDelete("R2["+num+"]");
      ObjectDelete("R3["+num+"]");
      ObjectDelete("S1["+num+"]");
      ObjectDelete("S2["+num+"]");
      ObjectDelete("S3["+num+"]");
      
      ObjectDelete("M0["+num+"]");
      ObjectDelete("M1["+num+"]");
      ObjectDelete("M2["+num+"]");
      ObjectDelete("M3["+num+"]");
      ObjectDelete("M4["+num+"]");
      ObjectDelete("M5["+num+"]");
      
      }
      
      //---- Get new daily prices & calculate pivots
   day_high=0;
   day_low=0;
   yesterday_open=0;
   today_open=0;
   cur_day=0;
   prev_day=0;
   
   int cnt=1440;

   while (cnt!= 0)
   {
	  if (TimeDayOfWeek(Time[cnt]) == 0)
	  {
        cur_day = prev_day;
	  }
	  else
	  {
        cur_day = TimeDay(Time[cnt]- (GMTshift*3600));
	  }
	
  	  if (prev_day != cur_day)
	  {
		 yesterday_close = Close[cnt+1];
		 today_open = Open[cnt];
		 yesterday_high = day_high;
		 yesterday_low = day_low;

		 day_high = High[cnt];
		 day_low  = Low[cnt];

		 prev_day = cur_day;
	  }
   
     if (High[cnt]>day_high)
     {
       day_high = High[cnt];
     }
   
     if (Low[cnt]<day_low)
     {
       day_low = Low[cnt];
     }
	
	  cnt--;

  }
   }

   void PlotLine(string name,double value,double line_color,double style)
   {
   ObjectCreate(name,OBJ_ARROW,0,customTime(Shift_DOTS),value,customTime(Shift_DOTS),value);
   ObjectSet(name, OBJPROP_ARROWCODE,DOT_Type);
   ObjectSet(name, OBJPROP_WIDTH, S_R_Levels_Size);
   ObjectSet(name, OBJPROP_STYLE, style);
   ObjectSet(name, OBJPROP_COLOR, line_color);
    }        
    
     void PlotLinemm(string namemm,double value,double line_color,double style)
   {
   ObjectCreate(namemm,OBJ_ARROW,0,customTime(Shift_DOTS),value,customTime(Shift_DOTS),value);
   ObjectSet(namemm, OBJPROP_ARROWCODE,DOT_Type);
   ObjectSet(namemm, OBJPROP_WIDTH, MLevelS_Size);
   ObjectSet(namemm, OBJPROP_STYLE, style);
   ObjectSet(namemm, OBJPROP_COLOR, line_color);
    }
    
     void PlotLinep(string namep,double value,double line_color,double style)
   {
   ObjectCreate(namep,OBJ_ARROW,0,customTime(Shift_DOTS),value,customTime(Shift_DOTS),value);
   ObjectSet(namep, OBJPROP_ARROWCODE,DOT_Type);
   ObjectSet(namep, OBJPROP_WIDTH, PIVOT_Size);
   ObjectSet(namep, OBJPROP_STYLE, style);
   ObjectSet(namep, OBJPROP_COLOR, line_color);
    }
    
      
int init()
  {

  return(0);
  }
   
   
int deinit()
  {
  ObjectDelete("Pivot");
  ObjectDelete("R1"); ObjectDelete("R2");ObjectDelete("R3");
  ObjectDelete("S1");ObjectDelete("S2"); ObjectDelete("S3");
  ObjectDelete("M0");ObjectDelete("M1");
  ObjectDelete("M2");ObjectDelete("M3");
  ObjectDelete("M4");ObjectDelete("M5");
  ObjectsDeleteAll(0,OBJ_ARROW);
   ObjDel();
   DeleteCreateObj();
   Comment("");
   return(0);
  }

int start()
  {
  
  CreateHL();
}

void CreateObj(string objName, double start, double end, color clr)
  {
   ObjectCreate(objName, OBJ_VLINE, 0, iTime(NULL,1440,0)+GMTshift*3600, start, Time[0], end);
   ObjectSet(objName, OBJPROP_COLOR, clr);
   ObjectSet(objName, OBJPROP_BACK, DeleteStartLabel);

  }
   void DeleteCreateObj()
   {
   ObjectDelete(DailyStart);
   }
   void CreateHL()
   {
   DeleteCreateObj();
   
   
   double DHI = iHigh(NULL,PERIOD_D1,0);
   double DLO = iLow(NULL,PERIOD_D1,0);
     
    if (Show_StartTime==true)
    {  
   CreateObj(DailyStart,0,0, StartTime_color);
    }    
  int i;
     
  ObjDel();
  num=0;
  
  //for (shift=CountDays-1;shift>=0;shift--)
  {
  time1=iTime(NULL,PERIOD_D1,shift);
  i=shift-1;
  if (i<0) 
  time2=Time[0];
  else
  time2=iTime(NULL,PERIOD_D1,i)-Period()*60;
  
   double P = (yesterday_high + yesterday_low + yesterday_close)/3;//Pivot
  

    //Pivots & M Pivots
    double R3 = ( 2 * P ) + ( yesterday_high - ( 2 * yesterday_low ));
    double R2 = P + ( yesterday_high - yesterday_low );
    double R1 = ( 2 * P ) - yesterday_low;
    double S1 = ( 2 * P ) - yesterday_high;
    double S2 = P - ( yesterday_high- yesterday_low);
    double S3 = ( 2 * P ) - ( ( 2 * yesterday_high ) - yesterday_low );
         
    double M0 = (S2 + S3)/2;
    double M1 = (S1 + S2)/2;
    double M2 = (P + S1)/2;
    double M3 = (P + R1)/2; 
    double M4 = (R1 + R2)/2;
    double M5 = (R2 + R3)/2; 
         
        
  time2=time1+PERIOD_D1*8;
 
  num=shift;
       
  PlotLinep("PP["+num+"]",P,Central_PIVOT,0);
  if(Plot_PIVOTS)
  {
        
   PlotLine("R1["+num+"]",R1,R1_R2_R3,0);
   PlotLine("R2["+num+"]",R2,R1_R2_R3,0);
   PlotLine("R3["+num+"]",R3,R1_R2_R3,0);
               
   PlotLine("S1["+num+"]",S1,S1_S2_S3,0);
   PlotLine("S2["+num+"]",S2,S1_S2_S3,0);
   PlotLine("S3["+num+"]",S3,S1_S2_S3,0);
  }
         
  if(Plot_M_Levels)
  {
   PlotLinemm("M0["+num+"]",M0,M0_M1_M2,0);
   PlotLinemm("M1["+num+"]",M1,M0_M1_M2,0);
   PlotLinemm("M2["+num+"]",M2,M0_M1_M2,0);
   PlotLinemm("M3["+num+"]",M3,M3_M4_M5,0);
   PlotLinemm("M4["+num+"]",M4,M3_M4_M5,0);
   PlotLinemm("M5["+num+"]",M5,M3_M4_M5,0);
  }
  if(ShowPivotLables){
  ObjectCreate("Pivot", OBJ_TEXT, 0, 0,0);
  ObjectSetText("Pivot", "                             Pivot Point",10,"Arial Bold",Central_PIVOT);
  ObjectMove("Pivot", 0, customTime(ShiftPivotLabels),P+AdjustLabel_UP_DN *Point);
  
  ObjectCreate("R1", OBJ_TEXT, 0, 0,0);
  ObjectSetText("R1", "                R1",10,"Arial Bold",R1_R2_R3);
  ObjectMove("R1", 0, customTime(ShiftPivotLabels),R1+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("R2", OBJ_TEXT, 0, 0,0);
  ObjectSetText("R2", "                R2",10,"Arial Bold",R1_R2_R3);
  ObjectMove("R2", 0, customTime(ShiftPivotLabels),R2+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("R3", OBJ_TEXT, 0, 0,0);
  ObjectSetText("R3", "                R3",10,"Arial Bold",R1_R2_R3);
  ObjectMove("R3", 0, customTime(ShiftPivotLabels),R3+AdjustLabel_UP_DN*Point);
  
   ObjectCreate("S1", OBJ_TEXT, 0, 0,0);
  ObjectSetText("S1", "                S1",10,"Arial Bold",S1_S2_S3);
  ObjectMove("S1", 0, customTime(ShiftPivotLabels),S1+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("S2", OBJ_TEXT, 0, 0,0);
  ObjectSetText("S2", "                S2",10,"Arial Bold",S1_S2_S3);
  ObjectMove("S2", 0, customTime(ShiftPivotLabels),S2+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("S3", OBJ_TEXT, 0, 0,0);
  ObjectSetText("S3", "                S3",10,"Arial Bold",S1_S2_S3);
  ObjectMove("S3", 0, customTime(ShiftPivotLabels),S3+AdjustLabel_UP_DN*Point);
 
   ObjectCreate("M0", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M0", "                M0",10,"Arial Bold",M0_M1_M2);
  ObjectMove("M0", 0, customTime(ShiftPivotLabels),M0+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("M1", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M1", "                M1",10,"Arial Bold",M0_M1_M2);
  ObjectMove("M1", 0, customTime(ShiftPivotLabels),M1+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("M2", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M2", "                M2",10,"Arial Bold",M0_M1_M2);
  ObjectMove("M2", 0, customTime(ShiftPivotLabels),M2+AdjustLabel_UP_DN*Point);
  
   ObjectCreate("M3", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M3", "                M3",10,"Arial Bold",M3_M4_M5);
  ObjectMove("M3", 0, customTime(ShiftPivotLabels),M3+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("M4", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M4", "                M4",10,"Arial Bold",M3_M4_M5);
  ObjectMove("M4", 0, customTime(ShiftPivotLabels),M4+AdjustLabel_UP_DN*Point);
  
  ObjectCreate("M5", OBJ_TEXT, 0, 0,0);
  ObjectSetText("M5", "                M5",10,"Arial Bold",M3_M4_M5);
  ObjectMove("M5", 0, customTime(ShiftPivotLabels),M5+AdjustLabel_UP_DN*Point);
  }
 
  }
   return(0);
  }
    int customTime(int a)
{
if(a<0)
return(Time[0]+Period()*60*MathAbs(a));
else return(Time[a]); 
}
//+------------------------------------------------------------------+