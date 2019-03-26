//+------------------------------------------------------------------+
//|                                      Morning_Fibonacci_v_1_1.mq4 |
//|                                                              MVS |
//|             ICQ  588-948-516    ПИШУ    СОВЕТНИКИ    НА    ЗАКАЗ |
//+------------------------------------------------------------------+
#property copyright "MVS"
#property link      "ICQ  588-948-516    ПИШУ    СОВЕТНИКИ    НА    ЗАКАЗ"

//+-------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Magenta
#property indicator_color2 Magenta
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Yellow
#property indicator_color6 Yellow
#property indicator_color7 Aqua
#property indicator_color8 Aqua
//+------------------------------------------------------------------- 
extern string OpenTime    = "01:00";     // Временная точка 1                               
extern string CloseTime   = "08:00";     // Временная точка 2
extern int    DaysBack    = 4;           // Количество дней назад ( 0-все )
extern bool   HLine       = true;        // Показывать трендовые линии
extern color  colorLine   = Brown;       // Цвет трендовой линии флэта
extern color  colorMiddle = White;       // Цвет трендовой линии середины флэта
extern int    style_line  = 0;           // Стиль трендовых линий
extern bool   DrawLabel   = true;        // Показывать ценовые уровни
extern int    width       = 1;           // Размер значка
extern int    LR          = 5;           // 5 левая метка||6 правая метка 
//+-------------------------------------------------------------------                          
double buf0[];
double buf100[];
double buf161[];
double buf261[];
double buf200[];
double buf_261[];
double buf_0_618[];
double buf_200[];
//+-------------------------------------------------------------------
void init() {
   SetIndexBuffer(0, buf0);
   SetIndexStyle (0, DRAW_LINE, STYLE_SOLID,2);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexLabel(0,"morning_channel");
   SetIndexBuffer(1, buf100);
   SetIndexStyle (1, DRAW_LINE, STYLE_SOLID,2);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexLabel(1,"morning_channel");
   SetIndexBuffer(2, buf_0_618);
   SetIndexStyle (2, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(2, EMPTY_VALUE);
   SetIndexLabel(2,"161");
   SetIndexBuffer(3, buf161);
   SetIndexStyle (3, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(3, EMPTY_VALUE);
   SetIndexLabel(3,"161");
   SetIndexBuffer(4, buf_261);
   SetIndexStyle (4, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(4, EMPTY_VALUE);
   SetIndexLabel(4,"261"); 
   SetIndexBuffer(5, buf261);
   SetIndexStyle (5, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(5, EMPTY_VALUE);
   SetIndexLabel(5,"261");
   SetIndexBuffer(6, buf200);
   SetIndexStyle (6, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(6, EMPTY_VALUE);
   SetIndexLabel(6,"200"); 
   SetIndexBuffer(7, buf_200);
   SetIndexStyle (7, DRAW_LINE, STYLE_SOLID,2 );
   SetIndexEmptyValue(7, EMPTY_VALUE);
   SetIndexLabel(7,"200");
   DeleteLines(); 
if(DaysBack==0) DaysBack=200;
  else DaysBack=DaysBack;    
for(int a=0; a<DaysBack+1; a++) 
   {
   LineMiddle("Middle"+(string)a);
   }}
void LineMiddle(string no) {
   ObjectCreate(no,OBJ_TREND,0,0,0,0,0);
   ObjectSet(no,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(no,OBJPROP_WIDTH,1);
   ObjectSet(no,OBJPROP_COLOR,colorMiddle);
   ObjectSet(no,OBJPROP_RAY,False);
   }
//+-------------------------------------------------------------------
void deinit() 
   {
   DeleteLines();
   Comment("");
   }
//+-------------------------------------------------------------------
void DeleteLines() 
   {
   for(int i=0; i<9; i++) 
   {
   ObjectDelete("Line"+(string)i);
   }
   for (i=0;i<DaysBack+1;i++) 
   {
   ObjectDelete("Middle"+(string)i);
   }
   for( i=0; i<9; i++) 
   {
   ObjectDelete("Label"+(string)i);
   }}  
//+-------------------------------------------------------------------
void start() {
   double t1,t2,t3,d1,d2,d3,d4,d5,d6,d7,d8,d9;
   datetime y1,y2;
   int amount,prevday=0,d=0,td=0,h1,h2,b1,b2;
if(Period()>60) 
   {
   Comment("Индикатору Morning_Fibonacci_v_1_1 нужен TF младше H4!"); return;
   }
//------------------
if(DaysBack==0) amount=Bars-10;
   else 
   amount=DaysBack*1440/Period();
   amount=MathMin(Bars-10,amount);
for(int i=0; i<amount; i++) 
   {
if(td!=TimeDay (Time[i])) 
   {
   td =TimeDay (Time[i]);
   d++;      
if(d>DaysBack && DaysBack>0) return;
   y1=StrToTime(TimeToStr(Time[i], TIME_DATE)+" "+OpenTime);
   y2=StrToTime(TimeToStr(Time[i], TIME_DATE)+" "+CloseTime)+(Period()*60);
   h1=iBarShift(NULL, 0, y1 );
   h2=iBarShift(NULL, 0, y2 );
   t1=High[iHighest(NULL, 0, MODE_HIGH, h1-h2, h2+1)];
   t2=Low [iLowest (NULL, 0, MODE_LOW , h1-h2, h2+1)];
   t3=(t1+t2)/2; 
   ObjectSet("Middle"+(string)d, OBJPROP_TIME1 ,y1);
   ObjectSet("Middle"+(string)d, OBJPROP_PRICE1,t3);
   ObjectSet("Middle"+(string)d, OBJPROP_TIME2 ,y2+(Period()*60));
   ObjectSet("Middle"+(string)d, OBJPROP_PRICE2,t3);
   }  
if((h1>=i&&i>h2)||(h2>=i&&i>h1)) 
   {
if(prevday!=TimeDay(Time[i])) 
   {  
   buf0[i]=t1-(t1-t2)*0;
   buf100[i]=t1-(t1-t2)*1;
   buf_0_618[i]=t1-(t1-t2)*(-0.618);
   buf161[i]=t1-(t1-t2)*1.618;
   buf_261[i]=t1-(t1-t2)*(-1.618);
   buf261[i]=t1-(t1-t2)*2.618;
   buf_200[i]=t1-(t1-t2)*(-1);
   buf200[i]=t1-(t1-t2)*2;  
   }
   b1=iBarShift(NULL,0,StrToTime(TimeToStr(CurTime(),TIME_DATE)+" "+OpenTime));
   b2=iBarShift(NULL,0,StrToTime(TimeToStr(CurTime(),TIME_DATE)+" "+CloseTime));
   d1=High[iHighest(NULL,0,MODE_HIGH,b1-b2+1,b2)];
   d2=Low [iLowest (NULL,0,MODE_LOW ,b1-b2+1,b2)];
   d3=d1-(d1-d2)*(-0.618);
   d4=d1-(d1-d2)*1.618;
   d5=d1-(d1-d2)*(-1.618);
   d6=d1-(d1-d2)*2.618;
   d7=d1-(d1-d2)*(-1);
   d8=d1-(d1-d2)*2;
   d9=(d1+d2)/2;  
   SetLine(0,d1);DrawLabel(0,indicator_color1,d1);
   SetLine(1,d2);DrawLabel(1,indicator_color2,d2);
   SetLine(2,d3);DrawLabel(2,indicator_color3,d3);
   SetLine(3,d4);DrawLabel(3,indicator_color4,d4);
   SetLine(4,d5);DrawLabel(4,indicator_color5,d5);
   SetLine(5,d6);DrawLabel(5,indicator_color6,d6);
   SetLine(6,d7);DrawLabel(6,indicator_color7,d7);
   SetLine(7,d8);DrawLabel(7,indicator_color8,d8);
   SetLine(8,d9);DrawLabel(8,colorMiddle,d9);
   }}}
//-----
void SetLine(int n,double dd) 
   {
int _style_line=0;
if (HLine==true)   
if (dd!=EMPTY_VALUE) 
   {
   switch(style_line)
   {
   case 0: _style_line=STYLE_SOLID; break; 
   case 1: _style_line=STYLE_DOT; break;
   case 2: _style_line=STYLE_DASH; break;
   case 3: _style_line=STYLE_DASHDOT; break;
   case 4: _style_line=STYLE_DASHDOTDOT; break;
   } 
   ObjectCreate("Line"+(string)n,OBJ_HLINE,0,0,0);
   ObjectSet("Line"+(string)n,OBJPROP_PRICE1,dd);
   ObjectSet("Line"+(string)n,OBJPROP_COLOR,colorLine);
   ObjectSet("Line"+(string)n,OBJPROP_STYLE,_style_line);
   }}
void DrawLabel(int n,color cl,double pr=0) 
   {
if (DrawLabel==true)   
   ObjectCreate("Label"+(string)n,OBJ_ARROW,0,0,0);
   ObjectSet("Label"+(string)n,OBJPROP_TIME1,Time[0]);
   ObjectSet("Label"+(string)n,OBJPROP_PRICE1,pr);
   ObjectSet("Label"+(string)n,OBJPROP_ARROWCODE,LR);
   ObjectSet("Label"+(string)n,OBJPROP_COLOR,cl);
   ObjectSet("Label"+(string)n,OBJPROP_WIDTH,width);
   }
//------------------------------------------------------------------------------  