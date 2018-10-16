#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Crimson
#property indicator_color2 Lime


extern int PRECISION=10;
extern int PERIOD=6;
extern int MINBARS=10000;
extern bool GRAPHICAL_USER_INTERFACE=true;
extern bool SOUND_ALERT=true;
extern bool EMAIL_NOTIFICATION=false;
extern bool SMS_NOTIFICATION=false;

double BUY[];
double SELL[];



string COMMY;

string ACCOUNT_TYPE;

datetime ACTIME;
int ExtCountedBars=0;

double VEKTOR[];
double R2[];
double FACTOR;
int    PRICE_COUNTER[];
int    ARRANGE[];
double spread;




//////////////////////////////////////////////////////////////////////////////////////////////////\

double CORRELATOR(double Ranks[], int N)
  {
//----
   double res,z2;
   int i;
   for(i = 0; i < N; i++)
     {
       z2 += MathPow(Ranks[i] - i - 1, 2);
     }
   res = 1 - 6*z2 / (MathPow(N,3) - N);
//----
   return(res);
  }
  
//+------------------------------------------------------------------+
//| Ranking array of prices function                                 |
//+------------------------------------------------------------------+

void SET_GROUPER(int InitialArray[])
  {
//----
   int i, k, m, dublicat, counter, etalon;
   double dcounter, averageRank;
   double TrueRanks[];
   ArrayResize(TrueRanks, PERIOD);
   ArrayCopy(ARRANGE, InitialArray);
   for(i = 0; i < PERIOD; i++) 
       TrueRanks[i] = i + 1;

       ArraySort(ARRANGE, 0, 0, MODE_ASCEND);
   for(i = 0; i < PERIOD-1; i++)
     {
       if(ARRANGE[i] != ARRANGE[i+1]) 
           continue;
       dublicat = ARRANGE[i];
       k = i + 1;
       counter = 1;
       averageRank = i + 1;
       while(k < PERIOD)
         {
           if(ARRANGE[k] == dublicat)
             {
               counter++;
               averageRank += k + 1;
               k++;
             }
           else
               break;
         }
       dcounter = counter;
       averageRank = averageRank / dcounter;
       for(m = i; m < k; m++)
           TrueRanks[m] = averageRank;
       i = k;
     }
   for(i = 0; i < PERIOD; i++)
     {
       etalon = InitialArray[i];
       k = 0;
       while(k < PERIOD)
         {
           if(etalon == ARRANGE[k])
             {
               R2[i] = TrueRanks[k];
               break;
             }
           k++;
         }
     }
//----
   return;
  }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void init() {
  IndicatorBuffers(3);
  SetIndexBuffer(0, SELL);
  SetIndexBuffer(1, BUY);
  SetIndexBuffer(2, VEKTOR);
  

   
   ArrayResize(R2, PERIOD);
   ArrayResize(PRICE_COUNTER, PERIOD);
   ArrayResize(ARRANGE, PERIOD);
      if(MINBARS <= 0) 
       MINBARS = 10;

       IndicatorShortName("HOLY GRAIL V4.1");
 
   FACTOR = MathPow(PRECISION, Digits);

    SetIndexLabel(0, "SELL SIGN");
    SetIndexLabel(1, "BUY SIGN"); 
    SetIndexLabel(2, "VEKTOR"); 
   

    
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID,4,Crimson);
   SetIndexArrow(0, 218);

   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID,4,Lime);
   SetIndexArrow(1, 217);

  ACTIME=Time[0];
  



  COMMY="";
  
  return(0);
}


int deinit()
  {
//---- 
COMMY="";
ObjectsDeleteAll();
RefreshRates();
//----
   return(0);
  }

void start() 
{


   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=MathMin(Bars-ExtCountedBars-1,MINBARS);
  

  
if(GRAPHICAL_USER_INTERFACE==false)
COMMY="\n\nHOLY GRAIL INDICATOR V4.1";
 
if(GRAPHICAL_USER_INTERFACE==true){
//////////////////////////GHAPHICAL USER INTERFACE
spread=MathAbs(Bid-Ask);
if (IsDemo()==true) 
ACCOUNT_TYPE="DEMO";
if (IsDemo()==false) 
ACCOUNT_TYPE="REAL";


////////////////////////MARKET MAKER

if(MarketInfo(Symbol(),MODE_DIGITS)==4 || MarketInfo(Symbol(),MODE_DIGITS)==2  ){
COMMY = "\n\n" +
"HOLY GRAIL INDICATOR V4.1"+ 
"\n "+  
"\n LEVERAGE:   "+"1:"+AccountLeverage()+
"\n ACCOUNT CURRENCY:   "+AccountCurrency()+
"\n ACCOUNT TYPE:   "+ACCOUNT_TYPE+
"\n ------------------------------------------------------ "+ 
"\n BROKER TIME:   "+TimeToStr(TimeCurrent(), TIME_SECONDS)+      
"\n LOCAL TIME:   "+TimeToStr(TimeLocal(), TIME_SECONDS)+ 
"\n TIME DIFFERENCE:   "+TimeToStr(MathAbs(TimeLocal()-TimeCurrent()), TIME_SECONDS)+                                                
"\n ------------------------------------------------------ "+                                                       
"\n ASK:   "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS) )+
"\n BID:   "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS) )+
"\n SPREAD:   "+DoubleToStr(spread/Point,0)+" pips"+
"\n ------------------------------------------------------ "+ 
"\n SWAP LONG:   "+DoubleToStr(MarketInfo( Symbol(), MODE_SWAPLONG),MarketInfo(Symbol(),MODE_DIGITS)) +
"\n SWAP SHORT:   "+DoubleToStr(MarketInfo(Symbol(), MODE_SWAPSHORT),MarketInfo(Symbol(),MODE_DIGITS)) +
"\n ------------------------------------------------------ "+ 
"\n NR. OF ACTIVE ORDERS:   "+OrdersTotal()+
"\n ACCOUNT BALANCE:   "+DoubleToStr(AccountBalance(),2)+
"\n ACCOUNT EQUITY:   "+DoubleToStr(AccountEquity(),2)+
"\n FREE MARGIN:   "+DoubleToStr(AccountFreeMargin(),2)+
"\n USED MARGIN:   "+DoubleToStr(AccountBalance()-AccountFreeMargin(),2)+
"\n PENDING PROFIT/LOSS:   "+DoubleToStr(AccountProfit(),2)+
"\n ------------------------------------------------------ "; 
}

/////////////////////////STP/ECN

if(MarketInfo(Symbol(),MODE_DIGITS)==5 || MarketInfo(Symbol(),MODE_DIGITS)==3){
COMMY = "\n\n" +
"HOLY GRAIL INDICATOR V4.1"+ 
"\n "+  
"\n LEVERAGE:   "+"1:"+AccountLeverage()+
"\n ACCOUNT CURRENCY:   "+AccountCurrency()+
"\n ACCOUNT TYPE:   "+ACCOUNT_TYPE+
"\n ------------------------------------------------------ "+ 
"\n BROKER TIME:   "+TimeToStr(TimeCurrent(), TIME_SECONDS)+      
"\n LOCAL TIME:   "+TimeToStr(TimeLocal(), TIME_SECONDS)+ 
"\n TIME DIFFERENCE:   "+TimeToStr(MathAbs(TimeLocal()-TimeCurrent()), TIME_SECONDS)+                                                
"\n ------------------------------------------------------ "+                                                       
"\n ASK:   "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS) )+
"\n BID:   "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS) )+
"\n SPREAD:   "+DoubleToStr(spread/Point/10,1)+" pips"+
"\n ------------------------------------------------------ "+ 
"\n SWAP LONG:   "+DoubleToStr(MarketInfo( Symbol(), MODE_SWAPLONG),MarketInfo(Symbol(),MODE_DIGITS)) +
"\n SWAP SHORT:   "+DoubleToStr(MarketInfo(Symbol(), MODE_SWAPSHORT),MarketInfo(Symbol(),MODE_DIGITS)) +
"\n ------------------------------------------------------ "+ 
"\n NR. OF ACTIVE ORDERS:   "+OrdersTotal()+
"\n ACCOUNT BALANCE:   "+DoubleToStr(AccountBalance(),2)+
"\n ACCOUNT EQUITY:   "+DoubleToStr(AccountEquity(),2)+
"\n FREE MARGIN:   "+DoubleToStr(AccountFreeMargin(),2)+
"\n USED MARGIN:   "+DoubleToStr(AccountBalance()-AccountFreeMargin(),2)+
"\n PENDING PROFIT/LOSS:   "+DoubleToStr(AccountProfit(),2)+
"\n ------------------------------------------------------ "; 
}

//////////////////////////END  GHAPHICAL USER INTERFACE
}
  //-----
  Comment(COMMY);  
  
  /////////////////
   int counted_bars = IndicatorCounted();
     if(PERIOD > MINBARS) 
       return(-1);
   int i, k, limit;
   if(counted_bars == 0)
     {
       if(0 == 0)
           limit = Bars - PERIOD;
       else
           limit = 0;
     }
   if(counted_bars > 0)
       limit = Bars - counted_bars;
   for(i = limit; i >= 0; i--)
     {
       for(k = 0; k < PERIOD; k++) 
           PRICE_COUNTER[k] = Close[i+k]*FACTOR;
       SET_GROUPER(PRICE_COUNTER);
       VEKTOR[i] = CORRELATOR(R2,PERIOD);
     }
//----
  
  
     while(pos>=0)
	 {



//----
 double MA=iMA(Symbol(),0,55,0,MODE_SMA,PRICE_CLOSE,pos);
      
      
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
   ///////////////////////////SELL
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

if (  VEKTOR[pos]>0 && VEKTOR[pos+1]<=0 && Close[pos]<MA){ 
  
    SELL[pos] = High[pos]+45*Point;

////////////TEXT SYSTEM  --------ALWAYS FROM 0
ObjectDelete("BUY");
ObjectCreate("SELL", OBJ_LABEL, 0, 0,0);
ObjectSet("SELL", OBJPROP_CORNER, 1); 
ObjectSet("SELL", OBJPROP_XDISTANCE, 1);
ObjectSet("SELL", OBJPROP_YDISTANCE, 0);
ObjectSetText("SELL","SELL",32,"Arial Black",Crimson);
///////////      
     
    if(pos==0 && Time[0]>ACTIME){
    
    if(Period()<60)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");   
    if(Period()==60)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==240)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==1440)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==10080)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==43200)
    Alert("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
      
   if(EMAIL_NOTIFICATION==true)
   {
       if(Period()<60)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");   
    if(Period()==60)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==240)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==1440)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==10080)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==43200)
    SendMail("MT4 SELL TRADE SIGN!","SELL SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");   
   
   }
           
      if(SMS_NOTIFICATION==true)
   {
       if(Period()<60)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");   
    if(Period()==60)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==240)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==1440)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==10080)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");
    if(Period()==43200)
    SendNotification("SELL SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(BID): "+DoubleToStr(Bid,MarketInfo(Symbol(),MODE_DIGITS))+" ");   
   
   }   
      
      
      
      
    if(SOUND_ALERT==true)
    PlaySound("alert.wav");}
    ACTIME=Time[0];
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    
    
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      
   ///////////////////////////BUY
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
  
    if (VEKTOR[pos]<0 && VEKTOR[pos+1]>=0  && Close[pos]>MA){ 

    BUY[pos] =   Low[pos]-45*Point;
    
////////////TEXT SYSTEM  --------ALWAYS FROM 0
ObjectDelete("SELL");
ObjectCreate("BUY", OBJ_LABEL, 0, 0,0);
ObjectSet("BUY", OBJPROP_CORNER, 1); 
ObjectSet("BUY", OBJPROP_XDISTANCE, 1);
ObjectSet("BUY", OBJPROP_YDISTANCE, 0);
ObjectSetText("BUY","BUY",32,"Arial Black",Lime);
///////////      
    
    
    
    
    
    if(pos==0 && Time[0]>ACTIME){
    
   if(Period()<60)
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==60)
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==240)    
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==1440)
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==10080)
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==43200)
    Alert("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    
 
      if(EMAIL_NOTIFICATION==true)
   {     
        
     if(Period()<60)
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==60)
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==240)    
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==1440)
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==10080)
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==43200)
    SendMail("MT4 BUY TRADE SIGN!","BUY SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
        
        
     }   
      
      
   if(SMS_NOTIFICATION==true)
   {     
        
     if(Period()<60)
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: M"+Period()+"  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==60)
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==240)    
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: H4  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==1440)
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: D1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==10080)
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: W1  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
    if(Period()==43200)
    SendNotification("BUY SIGN: "+Symbol()+"  |  TIMEFRAME: MN  |  PRICE(ASK): "+DoubleToStr(Ask,MarketInfo(Symbol(),MODE_DIGITS))+" "); 
        
        
     }    
      

         
    if(SOUND_ALERT==true)
    PlaySound("alert.wav");}
    ACTIME=Time[0];
    
     } 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 

   
/////////////////////////////COUNTDOWN & END ~~~~~~~~~~~~~~~~`      
      
      pos--;
     }
 

   return(0);
  }



