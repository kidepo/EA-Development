//+------------------------------------------------------------------+
//|                                          Gann_Box_144_Alex_c.mq4 |
//|                                                      idea awk501 | 
//|                                                        DimDimych |                                                                  
//|                                            http://open-forex.org |
//+------------------------------------------------------------------+
#property copyright "DimDimych"
#property link      "dm34@mail.ru"

#property indicator_chart_window

extern int           Complect = 0;

extern int             prices = 360;
extern int              times = 360;
extern int          size_font = 8;
extern color        color_txt = AliceBlue;

extern string            txt1 = "---контур---";
extern color    h_v_lines_col = Silver;
extern int    h_v_lines_width = 1;
extern string            txt2 = "---33-66---";
extern bool        _1_3_2_3_  = true;
extern color     _1_3_2_3_col = Gold;
extern int     _1_3_2_3_width = 2;
extern int     _1_3_2_3_style = 0;
extern string            txt3 = "---25-50-75---";
extern bool       _25_50_75_  = true;
extern color    _25_50_75_col = DodgerBlue;
extern int    _25_50_75_width = 2;
extern int    _25_50_75_style = 0;
extern string            txt4 = "---угол-1_1---";
extern bool            _1_1_  = true;
extern color         _1_1_col = Red;
extern int         _1_1_width = 1;
extern int         _1_1_style = 0;
extern string            txt5 = "---угол-1_2---";
extern bool            _1_2_  = true;
extern color         _1_2_col = Blue;
extern int         _1_2_width = 1;
extern int         _1_2_style = 0;
extern string            txt6 = "---угол-1_4---";
extern bool            _1_4_  = true;
extern color         _1_4_col = PowderBlue;
extern int         _1_4_width = 1;
extern int         _1_4_style = 0;
extern string            txt7 = "---угол-1_8---";
extern bool            _1_8_  = true;
extern color         _1_8_col = YellowGreen;
extern int         _1_8_width = 1;
extern int         _1_8_style = 0;
extern string            txt8 = "---square---";
extern bool             _sq_  = true;
extern color          _sq_col = Lime;
extern int          _sq_width = 1;
extern int          _sq_style = 0;

extern bool            backgr = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   ObjectDelete("VLine1 "+Complect);
   ObjectDelete("VLine2 "+Complect);
   ObjectDelete("HLine1 "+Complect);
   ObjectDelete("HLine2 "+Complect);
   
   ObjectDelete("VLine3 "+Complect);
   ObjectDelete("VLine4 "+Complect);
   ObjectDelete("VLine5 "+Complect);
   ObjectDelete("HLine3 "+Complect);
   ObjectDelete("HLine4 "+Complect);
   ObjectDelete("HLine5 "+Complect);

   ObjectDelete("_1_1_angle "+Complect);
   ObjectDelete("_1_1_angle2 "+Complect);
   
   ObjectDelete("_1_2_angle "+Complect);   
   ObjectDelete("_1_2_angle2 "+Complect);
   ObjectDelete("_1_2_angle3 "+Complect);
   ObjectDelete("_1_2_angle4 "+Complect);      
   ObjectDelete("_1_2_angle5 "+Complect);
   ObjectDelete("_1_2_angle6 "+Complect);   
   ObjectDelete("_1_2_angle8 "+Complect);
   ObjectDelete("_1_2_angle7 "+Complect);
   
   ObjectDelete("_1_4_angle "+Complect);
   ObjectDelete("_1_4_angle1 "+Complect);
   ObjectDelete("_1_4_angle2 "+Complect);   
   ObjectDelete("_1_4_angle3 "+Complect);
   ObjectDelete("_1_4_angle4 "+Complect);
   ObjectDelete("_1_4_angle5 "+Complect); 
   ObjectDelete("_1_4_angle6 "+Complect);   
   ObjectDelete("_1_4_angle7 "+Complect);
   ObjectDelete("_1_4_angle8 "+Complect);      
   ObjectDelete("_1_4_angle9 "+Complect);
   ObjectDelete("_1_4_angle10 "+Complect);   
   ObjectDelete("_1_4_angle11 "+Complect);
               
   ObjectDelete("_1_8_angle "+Complect);
   ObjectDelete("_1_8_angle1 "+Complect);
   ObjectDelete("_1_8_angle2 "+Complect);
   ObjectDelete("_1_8_angle3 "+Complect);
   ObjectDelete("_1_8_angle4 "+Complect);
   ObjectDelete("_1_8_angle5 "+Complect);
   ObjectDelete("_1_8_angle6 "+Complect);
   ObjectDelete("_1_8_angle7 "+Complect);   
   
   ObjectDelete("_sq "+Complect);
   ObjectDelete("_sq1 "+Complect);
   ObjectDelete("_sq2 "+Complect);
   ObjectDelete("_sq3 "+Complect);
  
   ObjectDelete("FiboTimes "+Complect);
   ObjectDelete("Fibo "+Complect);
   ObjectDelete("Txt "+Complect);   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("VLine1 "+Complect);
   ObjectDelete("VLine2 "+Complect);
   ObjectDelete("HLine1 "+Complect);
   ObjectDelete("HLine2 "+Complect);
   
   ObjectDelete("VLine3 "+Complect);
   ObjectDelete("VLine4 "+Complect);
   ObjectDelete("VLine5 "+Complect);
   ObjectDelete("HLine3 "+Complect);
   ObjectDelete("HLine4 "+Complect);
   ObjectDelete("HLine5 "+Complect);

   ObjectDelete("_1_1_angle "+Complect);
   ObjectDelete("_1_1_angle2 "+Complect);
   
   ObjectDelete("_1_2_angle "+Complect);   
   ObjectDelete("_1_2_angle2 "+Complect);
   ObjectDelete("_1_2_angle3 "+Complect);
   ObjectDelete("_1_2_angle4 "+Complect);      
   ObjectDelete("_1_2_angle5 "+Complect);
   ObjectDelete("_1_2_angle6 "+Complect);   
   ObjectDelete("_1_2_angle8 "+Complect);
   ObjectDelete("_1_2_angle7 "+Complect);
   
   ObjectDelete("_1_4_angle "+Complect);
   ObjectDelete("_1_4_angle1 "+Complect);
   ObjectDelete("_1_4_angle2 "+Complect);   
   ObjectDelete("_1_4_angle3 "+Complect);
   ObjectDelete("_1_4_angle4 "+Complect);
   ObjectDelete("_1_4_angle5 "+Complect); 
   ObjectDelete("_1_4_angle6 "+Complect);   
   ObjectDelete("_1_4_angle7 "+Complect);
   ObjectDelete("_1_4_angle8 "+Complect);      
   ObjectDelete("_1_4_angle9 "+Complect);
   ObjectDelete("_1_4_angle10 "+Complect);   
   ObjectDelete("_1_4_angle11 "+Complect);
               
   ObjectDelete("_1_8_angle "+Complect);
   ObjectDelete("_1_8_angle1 "+Complect);
   ObjectDelete("_1_8_angle2 "+Complect);
   ObjectDelete("_1_8_angle3 "+Complect);
   ObjectDelete("_1_8_angle4 "+Complect);
   ObjectDelete("_1_8_angle5 "+Complect);
   ObjectDelete("_1_8_angle6 "+Complect);
   ObjectDelete("_1_8_angle7 "+Complect);   
   
   ObjectDelete("_sq "+Complect);
   ObjectDelete("_sq1 "+Complect);
   ObjectDelete("_sq2 "+Complect);
   ObjectDelete("_sq3 "+Complect);
   ObjectDelete("Fibo "+Complect);
   ObjectDelete("FiboTimes "+Complect);
   ObjectDelete("Txt "+Complect);
   //ObjectDelete("Point "+Complect);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int Date1, Date2, Date3,Date4,D1,D2,D3,D4,D5,D6,D7,D8,D9, nBP,D13,D14,D15,D16,D17;
   double Price1,Price2,P13;
   bool up;

//----    
   if(_1_1_style<0 || _1_1_style>4) _1_1_style=0;
   if(_1_2_style<0 || _1_2_style>4) _1_2_style=0;
   if(_1_4_style<0 || _1_4_style>4) _1_4_style=0;
//----
   ObjectDelete("VLine1 "+Complect);
   ObjectDelete("VLine2 "+Complect);
   ObjectDelete("HLine1 "+Complect);
   ObjectDelete("HLine2 "+Complect);
   
   ObjectDelete("VLine3 "+Complect);
   ObjectDelete("VLine4 "+Complect);
   ObjectDelete("VLine5 "+Complect);
   ObjectDelete("HLine3 "+Complect);
   ObjectDelete("HLine4 "+Complect);
   ObjectDelete("HLine5 "+Complect);

   ObjectDelete("_1_1_angle "+Complect);
   ObjectDelete("_1_1_angle2 "+Complect);
   
   ObjectDelete("_1_2_angle "+Complect);   
   ObjectDelete("_1_2_angle2 "+Complect);
   ObjectDelete("_1_2_angle3 "+Complect);
   ObjectDelete("_1_2_angle4 "+Complect);      
   ObjectDelete("_1_2_angle5 "+Complect);
   ObjectDelete("_1_2_angle6 "+Complect);   
   ObjectDelete("_1_2_angle8 "+Complect);
   ObjectDelete("_1_2_angle7 "+Complect);
   
   ObjectDelete("_1_4_angle "+Complect);
   ObjectDelete("_1_4_angle1 "+Complect);
   ObjectDelete("_1_4_angle2 "+Complect);   
   ObjectDelete("_1_4_angle3 "+Complect);
   ObjectDelete("_1_4_angle4 "+Complect);
   ObjectDelete("_1_4_angle5 "+Complect); 
   ObjectDelete("_1_4_angle6 "+Complect);   
   ObjectDelete("_1_4_angle7 "+Complect);
   ObjectDelete("_1_4_angle8 "+Complect);      
   ObjectDelete("_1_4_angle9 "+Complect);
   ObjectDelete("_1_4_angle10 "+Complect);   
   ObjectDelete("_1_4_angle11 "+Complect);
               
   ObjectDelete("_1_8_angle "+Complect);
   ObjectDelete("_1_8_angle1 "+Complect);
   ObjectDelete("_1_8_angle2 "+Complect);
   ObjectDelete("_1_8_angle3 "+Complect);
   ObjectDelete("_1_8_angle4 "+Complect);
   ObjectDelete("_1_8_angle5 "+Complect);
   ObjectDelete("_1_8_angle6 "+Complect);
   ObjectDelete("_1_8_angle7 "+Complect);   
   
   ObjectDelete("_sq "+Complect);
   ObjectDelete("_sq1 "+Complect);
   ObjectDelete("_sq2 "+Complect);
   ObjectDelete("_sq3 "+Complect);
   
   ObjectDelete("FiboTimes "+Complect);
   ObjectDelete("Fibo "+Complect); 
   ObjectDelete("Txt "+Complect);
   
if(ObjectFind("Point "+Complect)!=0) 
   ObjectCreate("Point "+Complect, OBJ_ARROW, 0, Time[20],Low[20]);
//----     
   ObjectSet("Point "+Complect,OBJPROP_ARROWCODE,241);
   ObjectSet("Point "+Complect,OBJPROP_COLOR,Blue);
   ObjectSet("Point "+Complect,OBJPROP_WIDTH,1);
//----    
   Price1=ObjectGet("Point "+Complect,OBJPROP_PRICE1);
   Date1=ObjectGet("Point "+Complect,OBJPROP_TIME1);

   D1=iBarShift(NULL,0,Date1,false);
//--------------
   ObjectCreate("Txt "+Complect, OBJ_TEXT, 0, ObjectGet("Point "+Complect,OBJPROP_TIME1), 0);
   ObjectSetText("Txt "+Complect, prices+"/"+times+"/"+DoubleToStr(NormalizeDouble(prices,4)/NormalizeDouble(times,4),2), size_font, "Verdana", color_txt); 
//--------------  

    if(Price1<=Low[D1])
     { 
      up=true;
      ObjectSet("Point "+Complect,OBJPROP_ARROWCODE,241);
      ObjectSet("Point "+Complect,OBJPROP_COLOR,Blue);
      Price1=Low[D1];
      ObjectSet("Point "+Complect,OBJPROP_PRICE1,Low[D1]-17*Point);
      ObjectSet("Txt "+Complect,OBJPROP_PRICE1,Low[D1]-10*Point);
     }
    else if(Price1>=High[D1])
     { 
      up=false;
      ObjectSet("Point "+Complect,OBJPROP_ARROWCODE,242);
      ObjectSet("Point "+Complect,OBJPROP_COLOR,Red);
      Price1=High[D1];
      ObjectSet("Point "+Complect,OBJPROP_PRICE1,High[D1]+17*Point);
      ObjectSet("Txt "+Complect,OBJPROP_PRICE1,High[D1]+10*Point);
     }
   if(up)
     Price2=Price1+prices*Point;
   else
     Price2=Price1-prices*Point;

Date2=D1-times; 
D2=D1-times/8;
D13=D1-times/3;
P13=prices/3*Point;
D14=D13-times/3;

D15=D1-times/4;
D16=D1-times/2;
D17=D16-times/4; 
//---- 
if(_1_3_2_3_)
{
   if(D13>=0)
   ObjectCreate("VLine1 "+Complect, OBJ_TREND, 0, Time[D13], Price1, Time[D13], Price2);
   else
   ObjectCreate("VLine1 "+Complect, OBJ_TREND, 0, Time[0]-D13*Period()*60, Price1, Time[0]-D13*Period()*60, Price2);        
//----
   if(D14>=0)
   ObjectCreate("VLine2 "+Complect, OBJ_TREND, 0, Time[D14], Price1, Time[D14], Price2);
   else
   ObjectCreate("VLine2 "+Complect, OBJ_TREND, 0, Time[0]-D14*Period()*60, Price1, Time[0]-D14*Period()*60, Price2);        
//---- 
   if(Date2>=0)
   ObjectCreate("HLine2 "+Complect, OBJ_TREND, 0, Date1, 0, Time[Date2], 0);
   else
   ObjectCreate("HLine2 "+Complect, OBJ_TREND, 0, Date1, 0, Time[0]-Date2*Period()*60, 0);
   if(up)
   {
   ObjectSet("HLine2 "+Complect, OBJPROP_PRICE1, Price2-P13);
   ObjectSet("HLine2 "+Complect, OBJPROP_PRICE2, Price2-P13);
   }
    else
   {
   ObjectSet("HLine2 "+Complect, OBJPROP_PRICE1, Price2+P13); 
   ObjectSet("HLine2 "+Complect, OBJPROP_PRICE2, Price2+P13);
   }   
//----
   if(Date2>=0)
   ObjectCreate("HLine1 "+Complect, OBJ_TREND, 0, Date1, 0, Time[Date2], 0);
   else
   ObjectCreate("HLine1 "+Complect, OBJ_TREND, 0, Date1, 0, Time[0]-Date2*Period()*60, 0);
   if(up)
   {
   ObjectSet("HLine1 "+Complect, OBJPROP_PRICE1, Price1+P13);
   ObjectSet("HLine1 "+Complect, OBJPROP_PRICE2, Price1+P13);
   }
    else
   {
   ObjectSet("HLine1 "+Complect, OBJPROP_PRICE1, Price1-P13); 
   ObjectSet("HLine1 "+Complect, OBJPROP_PRICE2, Price1-P13);
   }   
}   
    
//----- 
if(_25_50_75_)
{
   if(Date2>=0)
   ObjectCreate("HLine3 "+Complect, OBJ_TREND, 0, Date1, 0, Time[Date2], 0);
   else
   ObjectCreate("HLine3 "+Complect, OBJ_TREND, 0, Date1, 0, Time[0]-Date2*Period()*60, 0);
   if(up)
   {
   ObjectSet("HLine3 "+Complect, OBJPROP_PRICE1, Price1+prices/4*Point);
   ObjectSet("HLine3 "+Complect, OBJPROP_PRICE2, Price1+prices/4*Point);
   }
    else
   {
   ObjectSet("HLine3 "+Complect, OBJPROP_PRICE1, Price1-prices/4*Point); 
   ObjectSet("HLine3 "+Complect, OBJPROP_PRICE2, Price1-prices/4*Point);
   }    
//-----  
   if(Date2>=0)
   ObjectCreate("HLine4 "+Complect, OBJ_TREND, 0, Date1, 0, Time[Date2], 0);
   else
   ObjectCreate("HLine4 "+Complect, OBJ_TREND, 0, Date1, 0, Time[0]-Date2*Period()*60, 0);
   if(up)
   {
   ObjectSet("HLine4 "+Complect, OBJPROP_PRICE1, Price1+prices/2*Point);
   ObjectSet("HLine4 "+Complect, OBJPROP_PRICE2, Price1+prices/2*Point);
   }
    else
   {
   ObjectSet("HLine4 "+Complect, OBJPROP_PRICE1, Price1-prices/2*Point); 
   ObjectSet("HLine4 "+Complect, OBJPROP_PRICE2, Price1-prices/2*Point);
   }    
//----- 
   if(Date2>=0)
   ObjectCreate("HLine5 "+Complect, OBJ_TREND, 0, Date1, 0, Time[Date2], 0);
   else
   ObjectCreate("HLine5 "+Complect, OBJ_TREND, 0, Date1, 0, Time[0]-Date2*Period()*60, 0);
   if(up)
   {
   ObjectSet("HLine5 "+Complect, OBJPROP_PRICE1, Price2-prices/4*Point);
   ObjectSet("HLine5 "+Complect, OBJPROP_PRICE2, Price2-prices/4*Point);
   }
    else
   {
   ObjectSet("HLine5 "+Complect, OBJPROP_PRICE1, Price2+prices/4*Point); 
   ObjectSet("HLine5 "+Complect, OBJPROP_PRICE2, Price2+prices/4*Point);
   }
//---   
   if(D15>=0)
   ObjectCreate("VLine3 "+Complect, OBJ_TREND, 0, Time[D15], Price1, Time[D15], Price2);
   else
   ObjectCreate("VLine3 "+Complect, OBJ_TREND, 0, Time[0]-D15*Period()*60, Price1, Time[0]-D15*Period()*60, Price2);        
//----
   if(D16>=0)
   ObjectCreate("VLine4 "+Complect, OBJ_TREND, 0, Time[D16], Price1, Time[D16], Price2);
   else
   ObjectCreate("VLine4 "+Complect, OBJ_TREND, 0, Time[0]-D16*Period()*60, Price1, Time[0]-D16*Period()*60, Price2);        
//----
   if(D17>=0)
   ObjectCreate("VLine5 "+Complect, OBJ_TREND, 0, Time[D17], Price1, Time[D17], Price2);
   else
   ObjectCreate("VLine5 "+Complect, OBJ_TREND, 0, Time[0]-D17*Period()*60, Price1, Time[0]-D17*Period()*60, Price2);        
//----          
}
//----- 
 
   if(Date2>=0)
   ObjectCreate("Fibo "+Complect, OBJ_FIBO, 0, Date1, Price1, Time[Date2], Price2);
   else
   ObjectCreate("Fibo "+Complect, OBJ_FIBO, 0, Date1, Price1, Time[0]-Date2*Period()*60, Price2);

   ObjectSet("Fibo "+Complect, OBJPROP_LEVELCOLOR, h_v_lines_col);
   ObjectSet("Fibo "+Complect, OBJPROP_COLOR, _1_1_col);
   ObjectSet("Fibo "+Complect, OBJPROP_LEVELSTYLE, 0);   
   ObjectSet("Fibo "+Complect, OBJPROP_LEVELSTYLE, 0);
   ObjectSet("Fibo "+Complect, OBJPROP_FIBOLEVELS, 9);
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+0,0);
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+1,0.125); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+2,0.25); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+3,0.375); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+4,0.5); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+5,0.625); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+6,0.75); 
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+7,0.875);
   ObjectSet("Fibo "+Complect,OBJPROP_FIRSTLEVEL+8,1.0);
   ObjectSetFiboDescription("Fibo "+Complect, 0, "144 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 1, "126 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 2, "108 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 3, "90 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 4, "72 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 5, "54 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 6, "36 (%$)");
   ObjectSetFiboDescription("Fibo "+Complect, 7, "18 (%$)");   
   ObjectSetFiboDescription("Fibo "+Complect, 8, "0 (%$)");   
//----

   

   
   D3=2*D2-  D1;
   D4=3*D2-2*D1;
   D5=4*D2-3*D1;
   D6=5*D2-4*D1;
   D7=6*D2-5*D1;
   D8=7*D2-6*D1;
   D9=8*D2-7*D1;

//----
  if(D2>=0)
   ObjectCreate("FiboTimes "+Complect, OBJ_FIBOTIMES, 0, Date1, 0, Time[D2], 0);
    else
   ObjectCreate("FiboTimes "+Complect, OBJ_FIBOTIMES, 0, Date1, 0, Time[0]-D2*Period()*60,0);
  if(up)
   {
   ObjectSet("FiboTimes "+Complect, OBJPROP_PRICE1, Price1-20*Point);
   ObjectSet("FiboTimes "+Complect, OBJPROP_PRICE2, Price1-20*Point);
   }
    else
   {
   ObjectSet("FiboTimes "+Complect, OBJPROP_PRICE1, Price1+20*Point); 
   ObjectSet("FiboTimes "+Complect, OBJPROP_PRICE2, Price1+20*Point);
   }
   ObjectSet("FiboTimes "+Complect, OBJPROP_COLOR, _1_1_col);
   ObjectSet("FiboTimes "+Complect, OBJPROP_LEVELCOLOR, h_v_lines_col);
   ObjectSet("FiboTimes "+Complect, OBJPROP_LEVELSTYLE, 0);
   ObjectSet("FiboTimes "+Complect, OBJPROP_FIBOLEVELS, 9);
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+0,0);
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+1,1); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+2,2); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+3,3); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+4,4); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+5,5); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+6,6); 
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+7,7);
   ObjectSet("FiboTimes "+Complect,OBJPROP_FIRSTLEVEL+8,8);
   ObjectSetFiboDescription("FiboTimes "+Complect, 0, "0");
   ObjectSetFiboDescription("FiboTimes "+Complect, 1, "18");
   ObjectSetFiboDescription("FiboTimes "+Complect, 2, "36");
   ObjectSetFiboDescription("FiboTimes "+Complect, 3, "54"); 
   ObjectSetFiboDescription("FiboTimes "+Complect, 4, "72");
   ObjectSetFiboDescription("FiboTimes "+Complect, 5, "90");
   ObjectSetFiboDescription("FiboTimes "+Complect, 6, "108");
   ObjectSetFiboDescription("FiboTimes "+Complect, 7, "126"); 
   ObjectSetFiboDescription("FiboTimes "+Complect, 8, "144");          
//---1_1
if(_1_1_)
{
   if(ObjectFind("_1_1_angle "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_1_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[D9], Price2);
   else
      ObjectCreate("_1_1_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D9*Period()*60, Price2);
   }   
   if(ObjectFind("_1_1_angle2 "+Complect)!=0)
   {
    if(D9>=0)
      ObjectCreate("_1_1_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D9], Price1);
    else
      ObjectCreate("_1_1_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D9*Period()*60, Price1);
   }
}
//---1_2
if(_1_2_)
{   
   if(ObjectFind("_1_2_angle2 "+Complect)!=0)
   {
   if(D5>=0)
      ObjectCreate("_1_2_angle2 "+Complect,OBJ_TREND,0,Date1, Price1, Time[D5], Price2);
   else
      ObjectCreate("_1_2_angle2 "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D5*Period()*60, Price2);
   }   
   if(ObjectFind("_1_2_angle5 "+Complect)!=0)
   {
    if(D5>=0)
      ObjectCreate("_1_2_angle5 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D5], Price1);
    else
      ObjectCreate("_1_2_angle5 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D5*Period()*60, Price1);
   } 
    
   if(ObjectFind("_1_2_angle8 "+Complect)!=0)
   {
   ObjectCreate("_1_2_angle8 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_1_2_angle8 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_1_2_angle8 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_PRICE1,Price1);
   if(D9>=0)
      ObjectSet("_1_2_angle8 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_2_angle8 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_PRICE2,Price2);
   }
         
   if(ObjectFind("_1_2_angle7 "+Complect)!=0)
   {
   ObjectCreate("_1_2_angle7 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_1_2_angle7 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_1_2_angle7 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_PRICE1,Price2);
   if(D9>=0)
      ObjectSet("_1_2_angle7 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_2_angle7 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_PRICE2,Price1);
   }
   
   if(ObjectFind("_1_2_angle "+Complect)!=0)
   {
    if(D9>=0)
      ObjectCreate("_1_2_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[D9], Price1+(Price2-Price1)/2);
    else
      ObjectCreate("_1_2_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D9*Period()*60, Price1+(Price2-Price1)/2);
   }
   
   if(ObjectFind("_1_2_angle6 "+Complect)!=0)
   {
    if(D9>=0)
      ObjectCreate("_1_2_angle6 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D9], Price1+(Price2-Price1)/2);
    else
      ObjectCreate("_1_2_angle6 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D9*Period()*60, Price1+(Price2-Price1)/2);
   }
   if(ObjectFind("_1_2_angle3 "+Complect)!=0)
   {
    if(D9>=0)
      ObjectCreate("_1_2_angle3 "+Complect,OBJ_TREND,0,Time[D9], Price1, Date1, Price1+(Price2-Price1)/2);
    else
      ObjectCreate("_1_2_angle3 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price1, Date1, Price1+(Price2-Price1)/2);
   }

  if(ObjectFind("_1_2_angle4 "+Complect)!=0)
   {
    if(D9>=0)
      ObjectCreate("_1_2_angle4 "+Complect,OBJ_TREND,0,Time[D9], Price2, Date1, Price1+(Price2-Price1)/2);
    else
      ObjectCreate("_1_2_angle4 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price2, Date1, Price1+(Price2-Price1)/2);
   }
}
//---1_4
if(_1_4_)
{     
   if(ObjectFind("_1_4_angle6 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle6 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D7>=0)
      ObjectSet("_1_4_angle6 "+Complect,OBJPROP_TIME1,Time[D7]);
   else
      ObjectSet("_1_4_angle6 "+Complect,OBJPROP_TIME1,Time[0]-D7*Period()*60);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_PRICE1,Price1);
   if(D9>=0)
      ObjectSet("_1_4_angle6 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_4_angle6 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_PRICE2,Price2);
   }
   
   if(ObjectFind("_1_4_angle9 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle9 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D3>=0)
      ObjectSet("_1_4_angle9 "+Complect,OBJPROP_TIME1,Time[D3]);
   else
      ObjectSet("_1_4_angle9 "+Complect,OBJPROP_TIME1,Time[0]-D3*Period()*60);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_PRICE1,Price2);
   if(D5>=0)
      ObjectSet("_1_4_angle9 "+Complect,OBJPROP_TIME2,Time[D5]);
   else
      ObjectSet("_1_4_angle9 "+Complect,OBJPROP_TIME2,Time[0]-D5*Period()*60);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_PRICE2,Price1);
   }
   
   if(ObjectFind("_1_4_angle11 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle11 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_1_4_angle11 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_1_4_angle11 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_PRICE1,Price2);
   if(D7>=0)
      ObjectSet("_1_4_angle11 "+Complect,OBJPROP_TIME2,Time[D7]);
   else
      ObjectSet("_1_4_angle11 "+Complect,OBJPROP_TIME2,Time[0]-D7*Period()*60);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_PRICE2,Price1);
   }

   if(ObjectFind("_1_4_angle8 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle8 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D3>=0)
      ObjectSet("_1_4_angle8 "+Complect,OBJPROP_TIME1,Time[D3]);
   else
      ObjectSet("_1_4_angle8 "+Complect,OBJPROP_TIME1,Time[0]-D3*Period()*60);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_PRICE1,Price1);
   if(D5>=0)
      ObjectSet("_1_4_angle8 "+Complect,OBJPROP_TIME2,Time[D5]);
   else
      ObjectSet("_1_4_angle8 "+Complect,OBJPROP_TIME2,Time[0]-D5*Period()*60);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_PRICE2,Price2);
   }
   
   if(ObjectFind("_1_4_angle10 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle10 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_1_4_angle10 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_1_4_angle10 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_PRICE1,Price1);
   if(D7>=0)
      ObjectSet("_1_4_angle10 "+Complect,OBJPROP_TIME2,Time[D7]);
   else
      ObjectSet("_1_4_angle10 "+Complect,OBJPROP_TIME2,Time[0]-D7*Period()*60);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_PRICE2,Price2);
   }

   if(ObjectFind("_1_4_angle "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_4_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[D9], Price1+(Price2-Price1)/4);
   else
      ObjectCreate("_1_4_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D9*Period()*60, Price1+(Price2-Price1)/4);
   }   
   
   if(ObjectFind("_1_4_angle1 "+Complect)!=0)
   {
    if(D3>=0)
      ObjectCreate("_1_4_angle1 "+Complect,OBJ_TREND,0,Date1, Price1, Time[D3], Price2);
    else
      ObjectCreate("_1_4_angle1 "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D3*Period()*60, Price2);
   }
   
   if(ObjectFind("_1_4_angle7 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_4_angle7 "+Complect,OBJ_TREND,0,Time[D9], Price2, Date1, Price2-(Price2-Price1)/4);
   else
      ObjectCreate("_1_4_angle7 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price2, Date1, Price2-(Price2-Price1)/4);
   }
      
   if(ObjectFind("_1_4_angle3 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_4_angle3 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D9], Price2-(Price2-Price1)/4);
   else
      ObjectCreate("_1_4_angle3 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D9*Period()*60, Price2-(Price2-Price1)/4);
   }
      
   if(ObjectFind("_1_4_angle2 "+Complect)!=0)
   {
    if(D3>=0)
      ObjectCreate("_1_4_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D3], Price1);
    else
      ObjectCreate("_1_4_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D3*Period()*60, Price1);
   }
      
   if(ObjectFind("_1_4_angle4 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_4_angle4 "+Complect,OBJ_TREND,0,Time[D9], Price1, Date1, Price1+(Price2-Price1)/4);
   else
      ObjectCreate("_1_4_angle4 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price1, Date1, Price1+(Price2-Price1)/4);
   }        
   
   if(ObjectFind("_1_4_angle5 "+Complect)!=0)
   {
   ObjectCreate("_1_4_angle5 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D7>=0)
      ObjectSet("_1_4_angle5 "+Complect,OBJPROP_TIME1,Time[D7]);
   else
      ObjectSet("_1_4_angle5 "+Complect,OBJPROP_TIME1,Time[0]-D7*Period()*60);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_PRICE1,Price2);
   if(D9>=0)
      ObjectSet("_1_4_angle5 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_4_angle5 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_PRICE2,Price1);
   }   
}   
//---1_8 
if(_1_8_)
{  
   if(ObjectFind("_1_8_angle1 "+Complect)!=0)
   {
    if(D2>=0)
      ObjectCreate("_1_8_angle1 "+Complect,OBJ_TREND,0,Date1, Price1, Time[D2], Price2);
    else
      ObjectCreate("_1_8_angle1 "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D2*Period()*60, Price2);
   }   
   
   if(ObjectFind("_1_8_angle2 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_8_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D9], Price2-(Price2-Price1)/8);
   else
      ObjectCreate("_1_8_angle2 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D9*Period()*60, Price2-(Price2-Price1)/8);
   }   
   
   if(ObjectFind("_1_8_angle7 "+Complect)!=0)
   {
    if(D2>=0)
      ObjectCreate("_1_8_angle7 "+Complect,OBJ_TREND,0,Date1, Price2, Time[D2], Price1);
    else
      ObjectCreate("_1_8_angle7 "+Complect,OBJ_TREND,0,Date1, Price2, Time[0]-D2*Period()*60, Price1);
   } 
   if(ObjectFind("_1_8_angle4 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_8_angle4 "+Complect,OBJ_TREND,0,Time[D9], Price1,Date1 , Price1+(Price2-Price1)/8);
   else
      ObjectCreate("_1_8_angle4 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price1,Date1, Price1+(Price2-Price1)/8);
   }   
   
   if(ObjectFind("_1_8_angle3 "+Complect)!=0)
   {
   ObjectCreate("_1_8_angle3 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D8>=0)
      ObjectSet("_1_8_angle3 "+Complect,OBJPROP_TIME1,Time[D8]);
   else
      ObjectSet("_1_8_angle3 "+Complect,OBJPROP_TIME1,Time[0]-D8*Period()*60);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_PRICE1,Price2);
   if(D9>=0)
      ObjectSet("_1_8_angle3 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_8_angle3 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_PRICE2,Price1);
   }
   
   if(ObjectFind("_1_8_angle6 "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_8_angle6 "+Complect,OBJ_TREND,0,Time[D9], Price2,Date1 , Price2-(Price2-Price1)/8);
   else
      ObjectCreate("_1_8_angle6 "+Complect,OBJ_TREND,0,Time[0]-D9*Period()*60, Price2,Date1, Price2-(Price2-Price1)/8);
   }   
   
   if(ObjectFind("_1_8_angle5 "+Complect)!=0)
   {
   ObjectCreate("_1_8_angle5 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D8>=0)
      ObjectSet("_1_8_angle5 "+Complect,OBJPROP_TIME1,Time[D8]);
   else
      ObjectSet("_1_8_angle5 "+Complect,OBJPROP_TIME1,Time[0]-D8*Period()*60);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_PRICE1,Price1);
   if(D9>=0)
      ObjectSet("_1_8_angle5 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_1_8_angle5 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_PRICE2,Price2);
   }
   if(ObjectFind("_1_8_angle "+Complect)!=0)
   {
   if(D9>=0)
      ObjectCreate("_1_8_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[D9], Price1+(Price2-Price1)/8);
   else
      ObjectCreate("_1_8_angle "+Complect,OBJ_TREND,0,Date1, Price1, Time[0]-D9*Period()*60, Price1+(Price2-Price1)/8);
   }      
}   
//---sq
if(_sq_)
{ 
   if(ObjectFind("_sq "+Complect)!=0)
   {
   if(D5>=0)
      ObjectCreate("_sq "+Complect,OBJ_TREND,0,Date1, Price1+(Price2-Price1)/2, Time[D5], Price2);
   else
      ObjectCreate("_sq "+Complect,OBJ_TREND,0,Date1, Price1+(Price2-Price1)/2, Time[0]-D5*Period()*60, Price2);
   }
      
   if(ObjectFind("_sq1 "+Complect)!=0)
   {
   if(D5>=0)
      ObjectCreate("_sq1 "+Complect,OBJ_TREND,0,Time[D5], Price1, Date1, Price1+(Price2-Price1)/2);
   else
      ObjectCreate("_sq1 "+Complect,OBJ_TREND,0,Time[0]-D5*Period()*60, Price1, Date1, Price1+(Price2-Price1)/2);
   }
    
   if(ObjectFind("_sq2 "+Complect)!=0)
   {
   ObjectCreate("_sq2 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_sq2 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_sq2 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_sq2 "+Complect,OBJPROP_PRICE1,Price2);
   if(D9>=0)
      ObjectSet("_sq2 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_sq2 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_sq2 "+Complect,OBJPROP_PRICE2,Price1+(Price2-Price1)/2);
   }
   
   if(ObjectFind("_sq3 "+Complect)!=0)
   {
   ObjectCreate("_sq3 "+Complect,OBJ_TREND,0,0,0,0,0);
   if(D5>=0)
      ObjectSet("_sq3 "+Complect,OBJPROP_TIME1,Time[D5]);
   else
      ObjectSet("_sq3 "+Complect,OBJPROP_TIME1,Time[0]-D5*Period()*60);
   ObjectSet("_sq3 "+Complect,OBJPROP_PRICE1,Price1);
   if(D9>=0)
      ObjectSet("_sq3 "+Complect,OBJPROP_TIME2,Time[D9]);
   else
      ObjectSet("_sq3 "+Complect,OBJPROP_TIME2,Time[0]-D9*Period()*60);
   ObjectSet("_sq3 "+Complect,OBJPROP_PRICE2,Price1+(Price2-Price1)/2);
   }
}   
//------------------------ 

   ObjectSet("HLine3 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("HLine3 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("HLine3 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("HLine3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("HLine3 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("HLine4 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("HLine4 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("HLine4 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("HLine4 "+Complect,OBJPROP_RAY,false);
   ObjectSet("HLine4 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("HLine5 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("HLine5 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("HLine5 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("HLine5 "+Complect,OBJPROP_RAY,false);
   ObjectSet("HLine5 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("VLine3 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("VLine3 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("VLine3 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("VLine3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("VLine3 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("VLine4 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("VLine4 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("VLine4 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("VLine4 "+Complect,OBJPROP_RAY,false);
   ObjectSet("VLine4 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("VLine5 "+Complect,OBJPROP_COLOR,_25_50_75_col);
   ObjectSet("VLine5 "+Complect,OBJPROP_STYLE,_25_50_75_style);
   ObjectSet("VLine5 "+Complect,OBJPROP_WIDTH,_25_50_75_width);
   ObjectSet("VLine5 "+Complect,OBJPROP_RAY,false);
   ObjectSet("VLine5 "+Complect,OBJPROP_BACK,backgr);   
//------------------ 
   ObjectSet("HLine1 "+Complect,OBJPROP_COLOR,_1_3_2_3_col);
   ObjectSet("HLine1 "+Complect,OBJPROP_STYLE,_1_3_2_3_style);
   ObjectSet("HLine1 "+Complect,OBJPROP_WIDTH,_1_3_2_3_width);
   ObjectSet("HLine1 "+Complect,OBJPROP_RAY,false);
   ObjectSet("HLine1 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("HLine2 "+Complect,OBJPROP_COLOR,_1_3_2_3_col);
   ObjectSet("HLine2 "+Complect,OBJPROP_STYLE,_1_3_2_3_style);
   ObjectSet("HLine2 "+Complect,OBJPROP_WIDTH,_1_3_2_3_width);
   ObjectSet("HLine2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("HLine2 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("VLine1 "+Complect,OBJPROP_COLOR,_1_3_2_3_col);
   ObjectSet("VLine1 "+Complect,OBJPROP_STYLE,_1_3_2_3_style);
   ObjectSet("VLine1 "+Complect,OBJPROP_WIDTH,_1_3_2_3_width);
   ObjectSet("VLine1 "+Complect,OBJPROP_RAY,false);
   ObjectSet("VLine1 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("VLine2 "+Complect,OBJPROP_COLOR,_1_3_2_3_col);
   ObjectSet("VLine2 "+Complect,OBJPROP_STYLE,_1_3_2_3_style);
   ObjectSet("VLine2 "+Complect,OBJPROP_WIDTH,_1_3_2_3_width);
   ObjectSet("VLine2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("VLine2 "+Complect,OBJPROP_BACK,backgr);
//----                              
   ObjectSet("_1_1_angle "+Complect,OBJPROP_COLOR,_1_1_col);
   ObjectSet("_1_1_angle "+Complect,OBJPROP_STYLE,_1_1_style);
   ObjectSet("_1_1_angle "+Complect,OBJPROP_WIDTH,_1_1_width);
   ObjectSet("_1_1_angle "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_1_angle "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_1_angle2 "+Complect,OBJPROP_COLOR,_1_1_col);
   ObjectSet("_1_1_angle2 "+Complect,OBJPROP_STYLE,_1_1_style);
   ObjectSet("_1_1_angle2 "+Complect,OBJPROP_WIDTH,_1_1_width);
   ObjectSet("_1_1_angle2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_1_angle2 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle2 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle2 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle2 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle2 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle5 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle5 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle5 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle5 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle5 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle8 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle7 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_8_angle "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle "+Complect,OBJPROP_WIDTH, _1_8_width);
   ObjectSet("_1_8_angle "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle1 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle1 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle1 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle1 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle1 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_1_8_angle1 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle1 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle1 "+Complect,OBJPROP_WIDTH,_1_8_width);
   ObjectSet("_1_8_angle1 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle1 "+Complect,OBJPROP_BACK,backgr);
//----    
   ObjectSet("_1_4_angle3 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle3 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle3 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle3 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle6 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle6 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle6 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle6 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle6 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_8_angle2 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle2 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle2 "+Complect,OBJPROP_WIDTH, _1_8_width);
   ObjectSet("_1_8_angle2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle2 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle2 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle2 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle2 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle2 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_1_8_angle7 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle7 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle7 "+Complect,OBJPROP_WIDTH,_1_8_width);
   ObjectSet("_1_8_angle7 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle7 "+Complect,OBJPROP_BACK,backgr);
//----    
   ObjectSet("_1_4_angle4 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle4 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle4 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle4 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle4 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle3 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle3 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle3 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle3 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_8_angle4 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle4 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle4 "+Complect,OBJPROP_WIDTH, _1_8_width);
   ObjectSet("_1_8_angle4 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle4 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle5 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_WIDTH,_1_8_width);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle3 "+Complect,OBJPROP_BACK,backgr); 
//----    
   ObjectSet("_1_4_angle7 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle7 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle7 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle7 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle7 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_2_angle4 "+Complect,OBJPROP_COLOR,_1_2_col);
   ObjectSet("_1_2_angle4 "+Complect,OBJPROP_STYLE,_1_2_style);
   ObjectSet("_1_2_angle4 "+Complect,OBJPROP_WIDTH,_1_2_width);
   ObjectSet("_1_2_angle4 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_2_angle4 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_8_angle6 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle6 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle6 "+Complect,OBJPROP_WIDTH, _1_8_width);
   ObjectSet("_1_8_angle6 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle6 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle6 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_COLOR,_1_8_col);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_STYLE,_1_8_style);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_WIDTH,_1_8_width);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_8_angle5 "+Complect,OBJPROP_BACK,backgr);     
//----   
   ObjectSet("_sq "+Complect,OBJPROP_COLOR,_sq_col);
   ObjectSet("_sq "+Complect,OBJPROP_STYLE,_sq_style);
   ObjectSet("_sq "+Complect,OBJPROP_WIDTH,_sq_width);
   ObjectSet("_sq "+Complect,OBJPROP_RAY,false);
   ObjectSet("_sq "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_sq1 "+Complect,OBJPROP_COLOR,_sq_col);
   ObjectSet("_sq1 "+Complect,OBJPROP_STYLE,_sq_style);
   ObjectSet("_sq1 "+Complect,OBJPROP_WIDTH,_sq_width);
   ObjectSet("_sq1 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_sq1 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_sq2 "+Complect,OBJPROP_COLOR,_sq_col);
   ObjectSet("_sq2 "+Complect,OBJPROP_STYLE,_sq_style);
   ObjectSet("_sq2 "+Complect,OBJPROP_WIDTH,_sq_width);
   ObjectSet("_sq2 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_sq2 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_sq3 "+Complect,OBJPROP_COLOR,_sq_col);
   ObjectSet("_sq3 "+Complect,OBJPROP_STYLE,_sq_style);
   ObjectSet("_sq3 "+Complect,OBJPROP_WIDTH,_sq_width);
   ObjectSet("_sq3 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_sq3 "+Complect,OBJPROP_BACK,backgr);
//----    
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle9 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle11 "+Complect,OBJPROP_BACK,backgr);
//----
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle8 "+Complect,OBJPROP_BACK,backgr);
//----   
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_COLOR,_1_4_col);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_STYLE,_1_4_style);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_WIDTH,_1_4_width);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_RAY,false);
   ObjectSet("_1_4_angle10 "+Complect,OBJPROP_BACK,backgr);
   
   return(0);
  }