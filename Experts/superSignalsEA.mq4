//+------------------------------------------------------------------+
//|                                                supersignalEA.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

extern double Lots = 0.1;
extern string Symbol_1 = "EURUSD";
extern bool S1_Buy = true;
extern double S1_Lots = 0.1;
extern string Symbol_2 = "EURUSD";
extern bool S2_Buy = false;
extern double S2_Lots = 0.1;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int magic=9502;
  
   return(0);
  
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

 
int start()
{ 
 
double ArrowUp = iCustom(NULL,0,"supersignals",0,1);
double ArrowDown = iCustom(NULL,0,"supersignals",1,1);

if (ArrowDown != EMPTY_VALUE)
  {
    OrderSend(Symbol_1,OP_BUY, S1_Lots, MarketInfo(Symbol_1,MODE_ASK), 2, NULL, NULL, "RapidFire", magic, NULL, LimeGreen); 
  }
if (ArrowUp != EMPTY_VALUE)
 {
  OrderSend(Symbol_2,OP_SELL, S2_Lots, MarketInfo(Symbol_1,MODE_BID), 2, NULL, NULL, "RapidFire", magic, NULL, FireBrick);   
  }
return(0);
}