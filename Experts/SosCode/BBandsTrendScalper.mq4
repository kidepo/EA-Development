//+------------------------------------------------------------------+
//|                                                    PerfectEA.mq4 |
//|                                    Copyright 2018, SoSCode Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//Main signals based on XFormula
//Need to include Holy grail exists and entries 
//Or use the above to take the first profits when we hv multiple entries
//either include holy grail closure of solar wind closure for major closure
//inlcude current current cracked indicator value to confirm trend
//may need to look on other time frames to check the trend*

//Need to switch to main trend, plus also number of trends cound switched to main trend//
#property copyright "Copyright 2018, SoSCode Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <stdlib.mqh>
#include <LotSizeLib.mqh>
//#property strict
//+------------------------------------------------------------------
extern bool MyAutoLotSize = true;
extern string ______________ = "___________________";
extern bool DynamicLotSize = true;
extern double EquityPercent = 2;
extern double FixedLotSize = 0.1;
extern double StopLoss = 0;// this was used in lot size calculation
extern double TakeProfit = 0;// 1 = 10$ @ 1 lot
extern int TrailingStop = 0;
extern int MinimumProfit = 0;
extern int Slippage = 5;
//extern int MagicNumber = 123;
//---------new futures----------
extern bool tradeOncePerCandle = true;

extern bool CloseOnMiniReversals = false;
extern bool SignalsOnly = false;
extern bool LimitTradesPerTrend = true;
extern int  TradesPerTrend = 1;
extern bool ContinueTrading = true;
extern bool AllowSuperSignal = false;
extern bool FollowTrend = false;
extern bool UseAllHullMA = true;
extern bool MustProfit = false;

//+------------------------------------------------------------------
//Globals
//-----------
int indexCount;
datetime LastActiontime;
string currentOrderType;
string WaitMode= "off";

int BuyTicket;
int SellTicket;
double UsePoint;
int UseSlippage;
datetime TrackNewBarTime;
datetime TrackTime3;
datetime TrackTime4;
datetime TrackTime5;
datetime TrackTime6;
datetime TrackTime7;
datetime TrackNewBarTime2;
string lastTradeTypeAttempt;
double LotSize;
string Comment_= "No Trade placed";
//-----------indicators----------------------------------------------
string SSRC_21_sg;
string SSRC_14_sg;
string CrackedMegaFx_sg;
string bbAlert_sg;
string bbAlert_close;
string GrailSignal;
string SolarWindsjoy_sg;
string SuperPoint_sg;
string ConfirmedTrend;
string SSRC_close;
string t1,t2,t3,t4,t5,t6,t7,t8,t9;// for monitoring
string firstTradeCount;
string signalData;
int MagicNumber;// this time we auto generate it
//string xmasterSignal;
string mainTrend_H4_sg;
bool  inbuiltLock = false;
string AllHullMA_sg;
string xFormula_sg;
string HalfTrend_sg;
string Big_Trend_sg;


//+------------------------------------------------------------------



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//--
   //Generating Magic number
   MagicNumber = MathRand();
   printf("Perfect Expert initiated successfully Glory to God!");
   UsePoint = PipPoint(Symbol());
   UseSlippage = GetSlippage(Symbol(),Slippage);
   //check to see if its start of an new bar to rest the wait mode to off
   //set trades per trend
   // will need to use this to avoid late entries in trades
   GlobalVariableSet("TradeOnTrend_"+MagicNumber,TradesPerTrend); 
   printf("New value of TradeOnTrend *initialized* to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
   LastActiontime = Time[0];
   firstTradeCount = 1;// also set currentTrade based on higher time frames
   printf("First  order count {"+Symbol()+" "+MagicNumber+"} = "+firstTradeCount+" #CD011");

     
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //return (0);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  { 
    //printf("My God ruins!");
    // rechecking if magic number is set
    if(MagicNumber <= 0){
         MagicNumber = MathRand();
      }

    // Calculate lot size
    //use my own method for lot size
    if(MyAutoLotSize != true){
      LotSize = CalcLotSize(DynamicLotSize,EquityPercent,StopLoss,FixedLotSize);
      LotSize = VerifyLotSize(LotSize);
      }else{
      LotSize = LotSize();
      //printf("New value of TradeOnTrend *currently is* ===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
      }
       Comment("Magic No:"+ MagicNumber +", Recommeded Lot size: "+DoubleToStr(LotSize,2)+", Signals Only=>"+SignalsOnly +", Allow Live Trade=>"+ContinueTrading+", Trades No. Left: "+GlobalVariableGet("TradeOnTrend_"+MagicNumber)+", Inside Lock=>"+inbuiltLock +", Main Trend(H4)=>"+mainTrend_H4_sg);
     
      
      if(ContinueTrading){
         TradeSignalGenerate();
         checkOrderClose();
         
         
      }
              
    
  // return (0); 
 }
//+------------------------------------------------------------------+
//My custum methods
//+------------------------------------------------------------------+
void callTrade(string orderType){

if (LastActiontime != Time[0]){// will remove this
         if(WaitMode == "off"){
             //if(CheckOpenOrders())
                  checkBar(orderType);
              //else placeOrder(orderType) ; 
           }else{
           lastTradeTypeAttempt = orderType;
           }
   
         //Check if new bar started
         if(WaitMode == "On"){
         checkNewBar();
          }
    }
}

void checkBar(string orderType){
   if(orderType == "buy"){

//same bar
   if(LastActiontime == Time[0] && currentOrderType == "buy"){
         
         //-- just ingnore
         //--
         LastActiontime=Time[0];
    }
    else if ( LastActiontime != Time[0] && currentOrderType == "buy"){
    //-- just ingnore for now  but you may open new trade
    
    //*****I need to look at this more
      //placeOrder(orderType);
         if(!CheckOpenOrders())
          placeOrder(orderType);
    
    
    }
    //same bar
    else if(LastActiontime == Time[0] && currentOrderType == "sell"){
      //--get the current sell and close it.
      //--then wait and open a trade on the next bar after determining the right signal
      //set wait mode to on
      WaitMode = "On";
      /* you  may not close here, set wait to "On",
      then on open of the next candle, checf if waitMode is on
      then check if the current trade is same as the signal of the previous candle...dont close up then and reset WaitMode
      else if the previous is not corrensponding to the current trade, close it and immediately open a trade in the right direction*/
      // Close sell orders
      if(tradeOncePerCandle == true){
         if (SellMarketCount(Symbol(), MagicNumber) > 0) {
          CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
          TrackNewBarTime = Time[0];
       }else{
          placeOrder(orderType);
       }
       
      }
           
    
    }
    //different bar and this is the normal flow
    else if (LastActiontime != Time[0] && currentOrderType == "sell"){
       //--get the current sell and close it.
       //--immediately open a new buy
       if(!CheckOpenOrders())
          placeOrder(orderType);
       
    }else if(firstTradeCount == 1){
       if(!CheckOpenOrders())
          placeOrder(orderType);
    }
   
    
    
}
   
else if(orderType == "sell"){
   
//same bar
   if(LastActiontime == Time[0] && currentOrderType == "sell"){
         
         //-- just ingnore
         //--
         LastActiontime=Time[0];
    }
    else if ( LastActiontime != Time[0] && currentOrderType == "sell"){
    //-- just ingnore for now  but you may open new trade
     //*****I need to look at this more
        if(!CheckOpenOrders())
          placeOrder(orderType);
    
    
    }
    //same bar
    else if(LastActiontime == Time[0] && currentOrderType == "buy"){
      //--get the current buy and close it.
      //--then wait and open a trade on the next bar after determining the right signal
      //set wait mode to on
      WaitMode = "On";
      /* you  may not close here, set wait to "On",
      then on open of the next candle, checf if waitMode is on
      then check if the current trade is same as the signal of the previous candle...dont close up then and reset WaitMode
      else if the previous is not corrensponding to the current trade, close it and immediately open a trade in the right direction*/
      if(tradeOncePerCandle == true){
         if (BuyMarketCount(Symbol(), MagicNumber) > 0) {
          CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
          TrackNewBarTime = Time[0];
       }else{
          placeOrder(orderType);
       }
       
      }
      
      
    
    }
    //different bar and this is the normal flow
    else if (LastActiontime != Time[0] && currentOrderType == "buy"){
       //--get the current buy and close it.
       //--immediately open a new buy
       if(!CheckOpenOrders())
         placeOrder(orderType);
       
    }else if(firstTradeCount == 1){
       if(!CheckOpenOrders())
          placeOrder(orderType);
    }
   
 }
   
}


void placeOrder(string orderType){
   if(orderType == "buy"){
   
    printf("God given Expert buying....");
   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

      // Close sell orders
      if (SellMarketCount(Symbol(), MagicNumber) > 0) {
       //CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
      }
      // Open buy order
      BuyTicket = OpenBuyOrder(Symbol(), LotSize, UseSlippage, MagicNumber);
      // Order modification
      if (BuyTicket > 0 && (StopLoss > 0 || TakeProfit > 0)) {
       OrderSelect(BuyTicket, SELECT_BY_TICKET);
       double OpenPrice = OrderOpenPrice();
       // Calculate and verify stop loss and take profit
       double BuyStopLoss = CalcBuyStopLoss(Symbol(), StopLoss, OpenPrice);
       if (BuyStopLoss > 0)
        BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss, 5);
       double BuyTakeProfit = CalcBuyTakeProfit(Symbol(), TakeProfit, OpenPrice);
       if (BuyTakeProfit > 0)
        BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit, 5);
       // Add stop loss and take profit
       AddStopProfit(BuyTicket, BuyStopLoss, BuyTakeProfit);
      }
    //-----------------------------------------------------------------------------

    
   }
   else if(orderType == "sell"){
   
   printf("God given Expert selling....");
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   //Close all buy orders
   if (BuyMarketCount(Symbol(), MagicNumber) > 0) {
       //CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
      }
      SellTicket = OpenSellOrder(Symbol(), LotSize, UseSlippage, MagicNumber);
      if (SellTicket > 0 && (StopLoss > 0 || TakeProfit > 0)) {
       OrderSelect(SellTicket, SELECT_BY_TICKET);
       OpenPrice = OrderOpenPrice();
       double SellStopLoss = CalcSellStopLoss(Symbol(), StopLoss, OpenPrice);
       if (SellStopLoss > 0) SellStopLoss = AdjustAboveStopLevel(Symbol(),
        SellStopLoss, 5);
       double SellTakeProfit = CalcSellTakeProfit(Symbol(), TakeProfit,
        OpenPrice);
       if (SellTakeProfit > 0) SellTakeProfit = AdjustBelowStopLevel(Symbol(),
        SellTakeProfit, 5);
       AddStopProfit(SellTicket, SellStopLoss, SellTakeProfit);
      }
      
      //-------------------------------------------------------------------------
      
      // Adjust trailing stops
      if(BuyMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
      {
      BuyTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
      }
      if(SellMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
      {
      SellTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
      }

   
   }
}
//-------------------------------------------------------------------------
int SellMarketCount(string argSymbol, int argMagicNumber) {
 int OrderCount;
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_SELL) {
   OrderCount++;
  }
 }
 return (OrderCount);
}

int BuyMarketCount(string argSymbol, int argMagicNumber) {
 int OrderCount;
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_BUY) {
   OrderCount++;
  }
 }
 return (OrderCount);
}

// Pip Point Function
double PipPoint(string Currency)
{
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 3) double CalcPoint = 0.01;
   else if(CalcDigits == 4 || CalcDigits == 5) CalcPoint = 0.0001;
   return(CalcPoint);
}
// Get Slippage Function
int GetSlippage(string Currency, int SlippagePips)
{
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 4) double CalcSlippage = SlippagePips;
   else if(CalcDigits == 3 || CalcDigits == 5) CalcSlippage = SlippagePips * 10;
   return(CalcSlippage);
}

int OpenSellOrder(string argSymbol, double argLotSize, double argSlippage, double argMagicNumber, string argComment = "Sell Order") {
 while (IsTradeContextBusy()) Sleep(10);
 // Place Sell Order
 int Ticket = OrderSend(argSymbol, OP_SELL, argLotSize, MarketInfo(argSymbol, MODE_BID),
  argSlippage, 0, 0, argComment, argMagicNumber, 0, Red);
 // Error Handling
 if (Ticket == -1) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Open Sell Order - Error ", ErrorCode,
   ": ", ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID),
   " Ask: ", MarketInfo(argSymbol, MODE_ASK), " Lots: ", argLotSize);
  Print(ErrLog);
  //++Please sleep and retry here
 }
 else{ 
 
// if successful sell trade placed
      currentOrderType = "sell";
      LastActiontime=Time[0];
      Comment_ = "CHG Sell Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
      drawVerticalLine(0, clrRed, STYLE_SOLID);
      sendNotification("SELL");
      if(LimitTradesPerTrend){
      GlobalVariableSet("TradeOnTrend_"+MagicNumber,GlobalVariableGet("TradeOnTrend_"+MagicNumber)-1);
      printf("New value of TradeOnTrend *set* to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
      } 
      GrailSignal = "none";
      if(firstTradeCount == 1){
         firstTradeCount = 0;
         printf("First  Sell order {"+Symbol()+" "+MagicNumber+"} filled #CD010");
      }
      printf("Order filled at=>" + signalData);
 }
 return (Ticket);
}

int OpenBuyOrder(string argSymbol, double argLotSize, double argSlippage,
 double argMagicNumber, string argComment = "Buy Order") {
 while (IsTradeContextBusy()) Sleep(10);
 // Place Buy Order
 int Ticket = OrderSend(argSymbol, OP_BUY, argLotSize, MarketInfo(argSymbol, MODE_ASK),
  argSlippage, 0, 0, argComment, argMagicNumber, 0, Green);

 // Error Handling
 if (Ticket == -1) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Open Buy Order – Error ", ErrorCode, ": ",
   ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(argSymbol, MODE_BID),
   " Ask: ", MarketInfo(argSymbol, MODE_ASK), " Lots: ", argLotSize);
  Print(ErrLog);
  //Please, sleep and may be retry
 }else{
// if successful buy trade placed
    currentOrderType = "buy";
    LastActiontime=Time[0];
    Comment_ = "CHG Buy Order Place on: "+ argSymbol + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
    drawVerticalLine(0, clrBlue, STYLE_SOLID);
    sendNotification("BUY");
    if(LimitTradesPerTrend){
    GlobalVariableSet("TradeOnTrend_"+MagicNumber,GlobalVariableGet("TradeOnTrend_"+MagicNumber)-1);
    printf("New value of TradeOnTrend *set* to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
    }
    GrailSignal = "none";
    if(firstTradeCount == 1){
         firstTradeCount = 0;
         printf("First  Buy order {"+Symbol()+" "+MagicNumber+"} filled #CD010");
    }
    printf("Order filled at=>" + signalData);
 }
 return (Ticket);
}

 double CalcLotSize(bool argDynamicLotSize, double argEquityPercent, double argStopLoss,
  double argFixedLotSize) {
  double LotSize;
  if (argDynamicLotSize == true && argStopLoss > 0) {
   double RiskAmount = AccountEquity() * (argEquityPercent / 100);
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   if (Point == 0.001 || Point == 0.00001) TickValue *= 10;
     LotSize = (RiskAmount / argStopLoss) / TickValue;
  } else LotSize = argFixedLotSize;
  return (LotSize);
 }
 
 double VerifyLotSize(double argLotSize) {
    if (argLotSize < MarketInfo(Symbol(), MODE_MINLOT)) {
     argLotSize = MarketInfo(Symbol(), MODE_MINLOT);
    } else if (argLotSize > MarketInfo(Symbol(), MODE_MAXLOT)) {
     argLotSize = MarketInfo(Symbol(), MODE_MAXLOT);
    }
    if (MarketInfo(Symbol(), MODE_LOTSTEP) == 0.1) {
     argLotSize = NormalizeDouble(argLotSize, 1);
    } else argLotSize = NormalizeDouble(argLotSize, 2);
    return (argLotSize);
}

void CloseAllSellOrders(string argSymbol, int argMagicNumber, int argSlippage) {
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol && OrderType() == OP_SELL) {
   // Close Order
   int CloseTicket = OrderTicket();
   double CloseLots = OrderLots();
   while (IsTradeContextBusy()) Sleep(10);
   double ClosePrice = MarketInfo(argSymbol, MODE_ASK);
   bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, Red);
   // Error Handling
   if (Closed == false) {
    int ErrorCode = GetLastError();
    string ErrDesc = ErrorDescription(ErrorCode);
    string ErrAlert = StringConcatenate("Close All Sell Orders - Error ",
     ErrorCode, ": ", ErrDesc);
    Alert(ErrAlert);
    string ErrLog = StringConcatenate("Ask: ",
     MarketInfo(argSymbol, MODE_ASK), " Ticket: ", CloseTicket, " Price: ",
     ClosePrice);
    Print(ErrLog);
    
    //+--- Please, sleep and retry again
   } else {
   Counter--;
   drawVerticalLine(0, clrRed, STYLE_DOT);
   sendNotification("CLOSE SELL @ <<data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >>");
   
   
   }
  }
 }
}

void CloseAllBuyOrders(string argSymbol, int argMagicNumber, int argSlippage) {
 for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
  OrderSelect(Counter, SELECT_BY_POS);
  if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
   OrderType() == OP_BUY) {
   // Close Order
   int CloseTicket = OrderTicket();
   double CloseLots = OrderLots();
   while (IsTradeContextBusy()) Sleep(10);
   double ClosePrice = MarketInfo(argSymbol, MODE_BID);
   bool Closed = OrderClose(CloseTicket, CloseLots, ClosePrice, argSlippage, Red);
   // Error Handling
   if (Closed == false) {
    int ErrorCode = GetLastError();
    string ErrDesc = ErrorDescription(ErrorCode);
    string ErrAlert = StringConcatenate("Close All Buy Orders - Error ",
     ErrorCode, ": ", ErrDesc);
    Alert(ErrAlert);
    string ErrLog = StringConcatenate("Bid: ",
     MarketInfo(argSymbol, MODE_BID), " Ticket: ", CloseTicket, " Price: ",
     ClosePrice);
    Print(ErrLog);
    
     //+--- Please, sleep and retry again
   } else {
   Counter--;
   drawVerticalLine(0, clrBlue, STYLE_DOT);//clrBlue,clrRed//STYLE_SOLID//STYLE_DOT
   sendNotification("CLOSE BUY @ <<data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >>");
   
   }
  }
 }
}

double CalcBuyStopLoss(string argSymbol, int argStopLoss, double argOpenPrice) {
 if (argStopLoss == 0) return (0);
 double BuyStopLoss = argOpenPrice - (argStopLoss * PipPoint(argSymbol));
 return (BuyStopLoss);
}
double CalcSellStopLoss(string argSymbol, int argStopLoss, double argOpenPrice) {
 if (argStopLoss == 0) return (0);
 double SellStopLoss = argOpenPrice + (argStopLoss * PipPoint(argSymbol));
 return (SellStopLoss);
}
double CalcBuyTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice) {
 if (argTakeProfit == 0) return (0);
 double BuyTakeProfit = argOpenPrice + (argTakeProfit * PipPoint(argSymbol));
 return (BuyTakeProfit);
}
double CalcSellTakeProfit(string argSymbol, int argTakeProfit, double argOpenPrice) {
 if (argTakeProfit == 0) return (0);
 double SellTakeProfit = argOpenPrice - (argTakeProfit * PipPoint(argSymbol));
 return (SellTakeProfit);
}

double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0) {
    double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
    if (argOpenPrice == 0) double OpenPrice = MarketInfo(argSymbol, MODE_ASK);
    else OpenPrice = argOpenPrice;
    double UpperStopLevel = OpenPrice + StopLevel;
    if (argAdjustPrice <= UpperStopLevel) double AdjustedPrice = UpperStopLevel +
     (argAddPips * PipPoint(argSymbol));
    else AdjustedPrice = argAdjustPrice;
    return (AdjustedPrice);
}

double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0) {
    double StopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
    if (argOpenPrice == 0) double OpenPrice = MarketInfo(argSymbol, MODE_BID);
    else OpenPrice = argOpenPrice;
    double LowerStopLevel = OpenPrice - StopLevel;
    if (argAdjustPrice >= LowerStopLevel) double AdjustedPrice = LowerStopLevel -
     (argAddPips * PipPoint(argSymbol));
    else AdjustedPrice = argAdjustPrice;
    return (AdjustedPrice);
}

bool AddStopProfit(int argTicket, double argStopLoss, double argTakeProfit) {
 OrderSelect(argTicket, SELECT_BY_TICKET);
 double OpenPrice = OrderOpenPrice();
 while (IsTradeContextBusy()) Sleep(10);
 // Modify Order
 bool TicketMod = OrderModify(argTicket, OrderOpenPrice(), argStopLoss, argTakeProfit, 0);
 // Error Handling
 if (TicketMod == false) {
  int ErrorCode = GetLastError();
  string ErrDesc = ErrorDescription(ErrorCode);
  string ErrAlert = StringConcatenate("Add Stop/Profit - Error ", ErrorCode,
   ": ", ErrDesc);
  Alert(ErrAlert);
  string ErrLog = StringConcatenate("Bid: ", MarketInfo(OrderSymbol(), MODE_BID),
   " Ask: ", MarketInfo(OrderSymbol(), MODE_ASK), " Ticket: ", argTicket, " Stop: ",
   argStopLoss, " Profit: ", argTakeProfit);
  Print(ErrLog);
  //--Please, sleep and try
 }
 return (TicketMod);
}

void BuyTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit,
  int argMagicNumber) {
  for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
   OrderSelect(Counter, SELECT_BY_POS);
   // Calculate Max Stop and Min Profit
   double MaxStopLoss = MarketInfo(argSymbol, MODE_BID) -
    (argTrailingStop * PipPoint(argSymbol));
   MaxStopLoss = NormalizeDouble(MaxStopLoss,
    MarketInfo(OrderSymbol(), MODE_DIGITS));
   double CurrentStop = NormalizeDouble(OrderStopLoss(),
    MarketInfo(OrderSymbol(), MODE_DIGITS));
   double PipsProfit = MarketInfo(argSymbol, MODE_BID) - OrderOpenPrice();
   double MinProfit = argMinProfit * PipPoint(argSymbol);
   // Modify Stop
   if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
    OrderType() == OP_BUY && CurrentStop < MaxStopLoss &&
    PipsProfit >= MinProfit) {
    bool Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss,
     OrderTakeProfit(), 0);
    // Error Handling
    if (Trailed == false) {
     int ErrorCode = GetLastError();
     string ErrDesc = ErrorDescription(ErrorCode);
     string ErrAlert = StringConcatenate("Buy Trailing Stop – Error ",",ErrorCode," ",ErrDesc");
      Alert(ErrAlert); string ErrLog = StringConcatenate("Bid: ",
      MarketInfo(argSymbol, MODE_BID), " Ticket: ", OrderTicket(), " Stop: ",
      OrderStopLoss(), " Trail: ", MaxStopLoss); Print(ErrLog);
      //Please sleep and retry
     }
    }
   }
  }
  void SellTrailingStop(string argSymbol, int argTrailingStop, int argMinProfit,
   int argMagicNumber) {
   for (int Counter = 0; Counter <= OrdersTotal() - 1; Counter++) {
    OrderSelect(Counter, SELECT_BY_POS);
    // Calculate Max Stop and Min Profit
    double MaxStopLoss = MarketInfo(argSymbol, MODE_ASK) +
     (argTrailingStop * PipPoint(argSymbol));
    MaxStopLoss = NormalizeDouble(MaxStopLoss,
     MarketInfo(OrderSymbol(), MODE_DIGITS));
    double CurrentStop = NormalizeDouble(OrderStopLoss(),
     MarketInfo(OrderSymbol(), MODE_DIGITS));
    double PipsProfit = OrderOpenPrice() - MarketInfo(argSymbol, MODE_ASK);
    double MinProfit = argMinProfit * PipPoint(argSymbol);
    // Modify Stop
    if (OrderMagicNumber() == argMagicNumber && OrderSymbol() == argSymbol &&
     OrderType() == OP_SELL && (CurrentStop > MaxStopLoss || CurrentStop == 0) &&
     PipsProfit >= MinProfit) {
     bool Trailed = OrderModify(OrderTicket(), OrderOpenPrice(), MaxStopLoss,
      OrderTakeProfit(), 0);
     // Error Handling
     if (Trailed == false) {
      int ErrorCode = GetLastError();
      string ErrDesc = ErrorDescription(ErrorCode);
      string ErrAlert = StringConcatenate("Sell Trailing Stop - Error ",
       ErrorCode, ": ", ErrDesc);
      Alert(ErrAlert);
      string ErrLog = StringConcatenate("Ask: ",
       MarketInfo(argSymbol, MODE_ASK), " Ticket: ", OrderTicket(), " Stop: ",
       OrderStopLoss(), " Trail: ", MaxStopLoss);
       //Please sleep and retry
      Print(ErrLog);
     }
    }
   }
  }
  
//We declare a function CheckOpenOrders of type boolean and we want to return
//True if there are open orders for the currency pair, false if these isn't any
bool CheckOpenOrders(){
   //We need to scan all the open and pending orders to see if there is there is any
   //OrdersTotal return the total number of market and pending orders
   //What we do is scan all orders and check if they are of the same symbol of the one where the EA is running
   for( int i = 0 ; i < OrdersTotal() ; i++ ) {
      //We select the order of index i selecting by position and from the pool of market/pending trades
      OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      //If the pair of the order (OrderSymbol() is equal to the pair where the EA is running (Symbol()) then return true
      if( OrderSymbol() == Symbol() ) return(true);
   }
   //If the loop finishes it mean there were no open orders for that pair
   return(false);
}

void EAComment(){
  Comment(Comment_);
}
void sendNotification(string OrderType){
   string Ls_104 = Symbol() + ", TF:" + f0_0(Period());
   string Ls_112 = Ls_104 + ", Trend Trader EA "+OrderType+"SIGNAL: ";
   string Ls_120 = Ls_112 + " @ " + TimeToStr(TimeLocal(), TIME_SECONDS)+"\nSignal Data: "+signalData;
   
    SendMail(Ls_120, Ls_112);
    SendNotification(Ls_120);
}

void checkNewBar(){
if( TrackNewBarTime == Time[0]){//still the same bar


    TrackNewBarTime = Time[0];
}else{//new bar just started

      WaitMode = "off";//This can be enough, at the next tick,it can place a trade basing on the last
                        //values in the globals which where last.
     //lines below can be left
     //checkBar(lastTradeTypeAttempt);
      
}

}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Trade Tests

void TestEA(){
   int random_ = MathRand();
}

//---------------------------------------------------------------------------------
void drawVerticalLine(int barsBack, double _color, double style) {
      if( TrackNewBarTime2 == Time[0]){//still the same bar
         
       }else{
          
            string lineName = "Line"+MathRand();
         
            if (ObjectFind(lineName) != 0) {
               ObjectCreate(lineName,OBJ_VLINE,0,Time[barsBack],0);
               ObjectSet(lineName,OBJPROP_COLOR, _color);//clrBlue,clrRed
               ObjectSet(lineName,OBJPROP_WIDTH,1);
               ObjectSet(lineName,OBJPROP_STYLE, style);//STYLE_SOLID//STYLE_DOT
              
            }
         TrackNewBarTime2 = Time[0];
       }
   

}

void TradeSignalGenerate(){

    /*********************** Trending indicators *************************/
    
     double   bbAlertUpTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 0 );
     double   bbAlertDownTrendCur = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 0 );
     
     double   bbAlertUpTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 4, 1 );//for exit sell
     double   bbAlertDownTrend = iCustom(NULL, 0, "BBands Stop Alert", 8, 1,1.0,1,1,1000,false, 5, 1 );//for exit buy
 
     double   HalfTrend = iCustom(NULL, 0, "HalfTrend-1.02", 2, false,true, true,false,true,true, false, 0, 2 );
     //double   Big_TrendBuy = iCustom(NULL, 0, "(T_S_R)-Big Trend", 80, 3, 0, 0, 0 );
     //double   Big_TrendSell = iCustom(NULL, 0, "(T_S_R)-Big Trend", 80, 3, 0, 1, 0 );
     
     
     if((bbAlertDownTrend > 0 && bbAlertDownTrend != EMPTY_VALUE) && (bbAlertDownTrendCur > 0 && bbAlertDownTrendCur != EMPTY_VALUE)/* &&bbAlertUpTrend == EMPTY_VALUE*/){

          bbAlert_sg = "sell";      
          } else if((bbAlertUpTrend > 0 && bbAlertUpTrend != EMPTY_VALUE) && (bbAlertUpTrendCur > 0 && bbAlertUpTrendCur != EMPTY_VALUE)/* && ( bbAlertDownTrend == EMPTY_VALUE)*/){

          bbAlert_sg = "buy";
      } 
     if((bbAlertUpTrend > 0 && bbAlertUpTrend != EMPTY_VALUE) && (bbAlertDownTrendCur > 0 && bbAlertDownTrendCur != EMPTY_VALUE)/* &&bbAlertUpTrend == EMPTY_VALUE*/){
          bbAlert_sg = "halfSell";      
     }else if((bbAlertDownTrend > 0 && bbAlertDownTrend != EMPTY_VALUE) && (bbAlertUpTrendCur > 0 && bbAlertUpTrendCur != EMPTY_VALUE)/* && ( bbAlertDownTrend == EMPTY_VALUE)*/){
          bbAlert_sg = "halfBuy";
     } 
    
        //Hald Trend indicator
     if((HalfTrend ==  0 || HalfTrend == EMPTY_VALUE)){
          HalfTrend_sg = "sell";  
          ConfirmedTrend = "sell";
          
              if(TrackTime7 != Time[0]){
                  GlobalVariableSet("TradeOnTrend_"+MagicNumber,TradesPerTrend);
                  printf("New value of TradeOnTrend reset to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
                  TrackTime7 = Time[0];
                  inbuiltLock = true; //can continue to check if first trade has not been filled yet
               }
     
       }else if( (HalfTrend > 0 && HalfTrend != EMPTY_VALUE)){
          HalfTrend_sg = "buy";
          ConfirmedTrend = "buy";
          
              if(TrackTime7 != Time[0]){
                  GlobalVariableSet("TradeOnTrend_"+MagicNumber,TradesPerTrend);
                  printf("New value of TradeOnTrend reset to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
                  TrackTime7 = Time[0];
                  inbuiltLock = true; //can continue to check if first trade has not been filled yet
               }
           
      }
      //Big Trend
      inbuiltLock = true;
     /* if((Big_TrendBuy >  0 &&  Big_TrendBuy != EMPTY_VALUE)){
         
         
             if(TrackTime7 != Time[0] && Big_Trend_sg == "sell"){
                  GlobalVariableSet("TradeOnTrend_"+MagicNumber,TradesPerTrend);
                  printf("New value of TradeOnTrend reset to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
                  TrackTime7 = Time[0];
                  inbuiltLock = true; //can continue to check if first trade has not been filled yet
               }
         Big_Trend_sg= "buy";
         ConfirmedTrend = "buy";
               
      }else if( (Big_TrendSell > 0 && Big_TrendSell != EMPTY_VALUE)){
    
         
             if(TrackTime7 != Time[0] && Big_Trend_sg == "buy"){
                  GlobalVariableSet("TradeOnTrend_"+MagicNumber,TradesPerTrend);
                  printf("New value of TradeOnTrend reset to===>" +GlobalVariableGet("TradeOnTrend_"+MagicNumber));
                  TrackTime7 = Time[0];
                  inbuiltLock = true; //can continue to check if first trade has not been filled yet
               }
               
         Big_Trend_sg= "sell";
         ConfirmedTrend = "sell";
      }
      
      */   
       
       // .. -----------Do main entries signal Here--------- .. //
       // checkOrderClose();
     if(FollowTrend) { 
       if(HalfTrend_sg == "buy"){
            //main buy entry
              GrailSignal = "buy";
              if(inbuiltLock){TradeSignalCheck("HGbuy");}
              checkOrderClose();//closing sells
              t1=0;
              //generating signal data
            // signalData = "HG:"+GrailSignal+"|BBands:"+ bbAlert_sg +",|Cracked indic:"+CrackedMegaFx+"|AllHullMA:"+AllHullMA+",|AllHullMA Cur:"+AllHullMA_cur+",|AllHullMA sg:"+AllHullMA_sg;
        }
   
            
       if(HalfTrend_sg == "sell"){
         //main sell entry
             GrailSignal = "sell";
             if(inbuiltLock){
            TradeSignalCheck("HGsell");
            }
            checkOrderClose();//selling and closing buys
            t1=1;
            //generating signal data
           //signalData = "HG:"+GrailSignal+"|BBands:"+ bbAlert_sg +",|Cracked indic:"+CrackedMegaFx+"|AllHullMA:"+AllHullMA+",|AllHullMA Cur:"+AllHullMA_cur+",|AllHullMA sg:"+AllHullMA_sg;

         }
      }else{
        if(HalfTrend_sg == "buy" && (bbAlert_sg == "buy") ){
            //main buy entry
              GrailSignal = "buy";
              if(inbuiltLock){TradeSignalCheck("HGbuy");}
              checkOrderClose();//closing sells
              t1=0;
              //generating signal data
             //signalData = "HG:"+GrailSignal+"|BBands:"+ bbAlert_sg +",|Cracked indic:"+CrackedMegaFx+"|AllHullMA:"+AllHullMA+",|AllHullMA Cur:"+AllHullMA_cur+",|AllHullMA sg:"+AllHullMA_sg;
           }
            
       if(HalfTrend_sg == "sell" && (bbAlert_sg == "sell" )){
         //main sell entry
             GrailSignal = "sell";
             if(inbuiltLock){
            TradeSignalCheck("HGsell");
            }
            checkOrderClose();//selling and closing buys
            t1=1;
            //generating signal data
         //signalData = "HG:"+GrailSignal+"|BBands:"+ bbAlert_sg +",|Cracked indic:"+CrackedMegaFx+"|AllHullMA:"+AllHullMA+",|AllHullMA Cur:"+AllHullMA_cur+",|AllHullMA sg:"+AllHullMA_sg;

      } 
  
   }  


}

void TradeSignalCheck(string orderType){

if(orderType == "HGsell" && ConfirmedTrend == "sell"){//selling here
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if(SignalsOnly && LastActiontime != Time[0]){
      currentOrderType = "sell";
      LastActiontime=Time[0];
      Comment_ = "Sell Order Place on: "+ Symbol() + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
      drawVerticalLine(0, clrRed, STYLE_SOLID);
      sendNotification("Signals Only: SELL <Turn on Trade>");
      printf("Need to Turn trade on {"+Symbol()+" "+MagicNumber+"}");
      GrailSignal = "none";
      
      }else if(!SignalsOnly){
      
         if(LimitTradesPerTrend == true && GlobalVariableGet("TradeOnTrend_"+MagicNumber) <= 0){
            //ignore
         }else if(LimitTradesPerTrend == true && GlobalVariableGet("TradeOnTrend_"+MagicNumber) > 0){
               callTrade("sell");
               
               if(TrackTime4 != Time[0]){
                  printf("sell order {"+Symbol()+" "+MagicNumber+"} initiated from holly signal immediate #CD001 trace=>"+GlobalVariableGet("TradeOnTrend_"+MagicNumber));
               TrackTime4 = Time[0];
               }
         }else if(LimitTradesPerTrend == false ){
               callTrade("sell");
               
               if(TrackTime4 != Time[0]){
                  printf("sell order {"+Symbol()+" "+MagicNumber+"} initiated from holly signal immediate #CD002");
               TrackTime4 = Time[0];
               }
         }
         
      }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

}else if(orderType == "HGsell" && ConfirmedTrend != "sell"){
   GrailSignal = "waitingSell";
   t1=9;
    if(TrackTime4 != Time[0]){
      printf("Grail {"+Symbol()+" "+MagicNumber+"} set to waiting sell #CD003");
      TrackTime4 = Time[0];
      }
}

if(orderType == "HGbuy" && ConfirmedTrend == "buy"){//buying here
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       if(SignalsOnly && LastActiontime != Time[0]){
         currentOrderType = "buy";
         LastActiontime=Time[0];
         Comment_ = "Buy Order Place on: "+ Symbol() + " TF: "+Period()+  " @ " + TimeToStr(TimeLocal(), TIME_SECONDS); 
         drawVerticalLine(0, clrBlue, STYLE_SOLID);
         sendNotification("Signals Only:  BUY <Turn on Trade>");
         printf("Need to Turn trade on {"+Symbol()+" "+MagicNumber+"}");
         GrailSignal = "none";
      
      }else if(!SignalsOnly){
         if(LimitTradesPerTrend == true && GlobalVariableGet("TradeOnTrend_"+MagicNumber) <= 0){
            //ignore
         }else if(LimitTradesPerTrend == true && GlobalVariableGet("TradeOnTrend_"+MagicNumber) > 0){
               callTrade("buy");
               
               if(TrackTime4 != Time[0]){
                  printf("Buy order {"+Symbol()+" "+MagicNumber+"} initiated from holly signal immediate #CD001");
               TrackTime4 = Time[0];
               }
         }else if(LimitTradesPerTrend == false ){
               callTrade("buy");
                
                 if(TrackTime4 != Time[0]){
                   printf("Buy order {"+Symbol()+" "+MagicNumber+"} initiated from holly signal immediate #CD002");
               TrackTime4 = Time[0];
               }
         }
         
      }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}else if (orderType == "HGbuy" && ConfirmedTrend != "buy"){
    GrailSignal = "waitingBuy";
     t1=9;
     if(TrackTime4 != Time[0]){
     printf("Grail {"+Symbol()+" "+MagicNumber+"} set to waiting buy #CD003");
     TrackTime4 = Time[0];
     }
}

}


//avoid closing trade if long term tren (H4) is still on
//atleast make the trade to stay warned and may be can close once minimal profit has been got

void checkOrderClose(){

if(SignalsOnly == false){
   
       if (currentOrderType == "buy"){
       
          if(CloseOnMiniReversals == true){ 
      
             if(HalfTrend_sg == "sell" || (bbAlert_sg == "sell" || bbAlert_sg == "halfSell")){
             //close all buys here and draw a line 
             if(MustProfit){
                  
                  if(checkProfit("closeBuy") == "True"){
                     CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
                  }else sendNotification("ATTEMPTED CLOSE BUY, but No profit yet: data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> ");
             
             }else{
               CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
             }
             
             if(TrackTime5 != Time[0]){
                  printf("Close Buy orders {"+Symbol()+" "+MagicNumber+"} initiated from Minimal reversals :data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> #CD008");
                  TrackTime5 = Time[0];
                 }
             
             
             }
          }
          else{
              if(HalfTrend_sg == "sell" || bbAlert_sg == "sell" || (bbAlert_sg == "halfSell" && HalfTrend_sg == "sell")){
             //close all buys here and draw a line 
             if(MustProfit){
              if(checkProfit("closeBuy") == "True"){
                     CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
                  }else sendNotification("ATTEMPTED CLOSE BUY, but No profit yet: data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> ");
             
             }else{
               CloseAllBuyOrders(Symbol(), MagicNumber, Slippage);
             }
             
             if(TrackTime5 != Time[0]){
                  printf("Close Buy orders {"+Symbol()+" "+MagicNumber+"} initiated from Major Grail :data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> #CD009");
                   TrackTime5 = Time[0];
                 }
             
             }  
          }
      }
   
      if(currentOrderType == "sell"){
           if(CloseOnMiniReversals == true){
             if(HalfTrend_sg == "buy" || (bbAlert_sg == "buy" || bbAlert_sg == "halfBuy")){
                //close all sells here and draw a line 
                //if main signal still on and profit not locked yet dont close
                
                if(MustProfit){
             
                     if(checkProfit("closeSell") == "True"){
                        CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
                     }else sendNotification("ATTEMPTED CLOSE SELL, but No profit yet: data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> ");
                }else{
                  CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
                }
                
                if(TrackTime5 != Time[0]){
                  printf("Close Sell orders {"+Symbol()+" "+MagicNumber+"} initiated from Minimal reversals: data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> #CD008");
                   TrackTime5 = Time[0];
                 }
                }
           }else{
                if(HalfTrend_sg == "buy" || bbAlert_sg == "buy" || (bbAlert_sg == "halfBuy" && HalfTrend_sg == "buy")){
                //close all sells here and draw a line 
                if(MustProfit){
                   if(checkProfit("closeSell") == "True"){
                           CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
                        }else sendNotification("ATTEMPTED CLOSE SELL, but No profit yet: data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> ");
             
                }else{
                  CloseAllSellOrders(Symbol(), MagicNumber, Slippage);
                }
                if(TrackTime5 != Time[0]){
                    printf("Close Sell orders {"+Symbol()+" "+MagicNumber+"} initiated from Major Grail :data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >> #CD009");
                    TrackTime5 = Time[0];
                 }
           }    
         }
      }
   }
   /********would be the esle for only signals but I need to get closing notifications  **************/
  else
   
   {//if signals only
      if(currentOrderType == "sell" && TrackTime3 != Time[0] ){
        if(bbAlert_sg == "buy" || bbAlert_sg == "halfBuy" || SuperPoint_sg == "buy" || AllHullMA_sg == "buy"){
            drawVerticalLine(0, clrRed, STYLE_DOT);
            sendNotification("CLOSE SELL :data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >>>> ");
            TrackTime3 = Time[0];
            }
         }
      else if (currentOrderType == "buy" && TrackTime3 != Time[0] ){
       if(bbAlert_sg == "sell" || bbAlert_sg == "halfSell" || SuperPoint_sg == "sell" || AllHullMA_sg == "sell"){
            drawVerticalLine(0, clrBlue, STYLE_DOT);
            sendNotification("CLOSE BUY :data{bbAlert_sg:"+bbAlert_sg+"|AllHullMA_sg:"+AllHullMA_sg+"} >>>> ");
            TrackTime3 = Time[0];
           } 
       
       }
   
   
   }
}
//Time frame to string
string f0_0(int Ai_0) {
   switch (Ai_0) {
   case 1:
      return ("M1");
   case 5:
      return ("M5");
   case 15:
      return ("M15");
   case 30:
      return ("M30");
   case 60:
      return ("H1");
   case 240:
      return ("H4");
   case 1440:
      return ("D1");
   case 10080:
      return ("W1");
   case 43200:
      return ("MN1");
   }
   WindowRedraw();
   return (Period());
}

string checkProfit(string closeType)
{
   int total=OrdersTotal();
   int i;
   double profit = 0;
   for(i=0; i<total; i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){
         profit+= (OrderProfit() + OrderCommission() + OrderSwap());
      }   
      
   }
   
   if(profit > 0 ){
     return "True";
   }else if (profit < 0 && (HalfTrend_sg == "sell") && closeType == "closeSell" ){
      //need to set minimal take profit  on the trade
     return "False";
     
   }else if (profit < 0 && (HalfTrend_sg == "sell") && closeType == "closeBuy" ){
     return "True";
   }else if (profit < 0 && (HalfTrend_sg == "buy") && closeType == "closeSell" ){
     return "True";
   }else if (profit < 0 && (HalfTrend_sg == "buy") && closeType == "closeBuy" ){
      //need to set minimal take profit here on the trade
     return "False";
   }
}