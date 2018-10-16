// This version Pipmaker_V13_1 by Enforcer has been modified from the PipMakerV10.
// All orders are now closed when ProfitTarget is reached to eliminate outlying orders from building up negative equity.
// Multiplier/CounterTrendMultiplier now acts as Martingale - doubling lot size at Spacing pips away in opposite trend from initial order (CounterTrendMultiplier) or
// at TrendSpacing intervals in same direction of initial order if set to "1".
// Added option for a stop loss on each order but not profitable when used in backtests.
// This EA allows for both Buy and Sell orders at the same time in the same currency which will act as a hedge until the prevailing trend resumes thus limiting
// drawdown.  This obviously won't work if your broker does not allow hedging.
//Enforcer's addons/changes/fixes (v10 to v15_3):
//- Loss Management - orders that fall below max alowed loss are closed and optionally a recovery order is placed
//- Added iTrend indicator
//- Added reverse signal option
// - Added more take profit methods - close all orders when profit reach profit target (old mode), close if buys or sells reach 
// profit target and mixed mode, which one comes first (best)
// - Added MoneyManagement, wii calculate lot size, lot increment and profit target
// - Replaced DPO with Fisher (triple moving average)
// - Reworked CCI to trigger at specified level
// - Added Forced start option
// - Added AutoSpacing, default spacing will be calculated by StdDev
// - removed VarySpacing by number of orders
// - Added ARSI indicator (Adaptive RSI - external)
// - Added ProfitTrailing option
// - added ProfitSkew option - will modify default ProfitTarget when MoneyManagement=true
// - added ATR as option for ARSI trigger
//Enforcer's addons/changes/fixes (v15_5 - september 2009):
// - Added TP (take profit)
// - Added MinSpacing for AutoSpacing. If auto calculated spacing is less than MinSpacing is automatically set = MinSpacing
// - Added OneDirectionOnly: won't allow buy and sell at same time
// - Added compatibility with 5 digits brokers
// - Added compatibility to ECN/STP brokers
// - Changed time filter to not depend on day, only on hour and minute. Also rewrite of function.
// - Removed Reference thing as is completely useless and added MagicNumber. 
//   MagicNumber should define a EA, not a pair. Anyway all checks are done with MagicNumber AND Symbol so no problem here.
// - Added ExclusiveMode: will not trade if any other open order is found, either same symbol and different magic, either other symbol no matter magic
// - Rearange external variables to more logic order
// - Some code cleanup
// - v16 - september 2009
// - Added also Slippage compatible 5digits
// - Added TradeWaitTime - minimum time interval between trades in minutes
// - Added CycleWaitTime - minimum time interval in minutes for open a new trade after last trade was colsed and there are no open orders
// - Visual confirmation for indicators and direction
// - Added checks for Allow live trading and Experts enabled
// - Removed ProfitSkew - use ProfitTarget instead
// - Minimum lot check - if MoneyManagement=true  and lot size is < min lot, lot is set to min lot
// - IncrementProfitTarget - if true and MoneyManagement=true ProfitTarget will increase according to total traded lots
// - Replaced TMA with Fisher indicator
// - Further code optimization/clenup
// - v17 - november 2009
// - added MACD default and ZeroLag_MACD_v1
// - Added new TMA
// - Added Stochastic indicator
// - Added NonLagMA
// - Reworked iTrend
// - Added reverse option for each indicator
// - v17_1
// - addded trailing stop
// - ProfitTarget disabled if is set=0
// - Removed from external variables recovery orders stuff
// - v17_2
// - fixed lots for manual lot size
// - v17_3
// - added stochastic as overbought/oversold filter

#include <stdlib.mqh>
#include <stderror.mqh>
#define  NL    "\n"
string   EA_name  = "PipMaker_v17_3";

//Global options
extern int     MagicNumber             = 801999;
extern int     Slippage                = 2;
extern bool    OneDirectionOnly        = true; // will not allow buy and sell at same time
extern bool    ExclusiveMode           = true; //will not trade if any other open order is found, either same symbol and different magic, either other symbol no matter magic
extern bool    TradeShort              = true; //Allow place sell ordes
extern bool    TradeLong               = true; //Allow place buy orders
extern bool    ReverseDirection        = false; // true = will trade long when price is low and short and price is high. false = will trade long when price is high and short when price is low
extern int     TradeWaitTime           = 30;
extern int     CycleWaitTime           = 60;

//Filters

extern bool    Use_Fisher              = true;
extern int     FisherPeriod            = 240; //Fisher TF
extern int     Fisher_Bars             = 10; //Fisher indicator bars
extern double  Fisher_price_smooth     = 0.5;
extern double  Fisher_index_smooth     = 0.5;
extern double  Fisher_Level            = 1.2; //Buy enter level
extern bool    Fisher_rev              = false;

extern bool    UseARSI                 = false;  //Adaptive RSI
extern int     RSI_period              = 60;    // TF for ARSI
extern int     RSI_bars                = 14;    // lenght of ARSI
extern double  ARSI_trigger            = 0.008; // level to trigger trade. If = 0 will be used ATR as automatic trigger level
extern bool    ARSI_rev                = false;

extern bool    UseCCI                  = false;
extern int     CCI_Period              = 60; // CCi time frame
extern int     CCI_lenght              = 14; //CCI bars
extern int     cci_trigger             = 100; // +/- level. lower value = enter in trade faster
extern bool    CCI_rev                 = false;

extern bool    Use_iTrend              = false;
extern int     iTrendPeriod            = 60; //iTrend TF
extern int     Bands_Mode              = 0;  // =0-2 MODE_MAIN, MODE_LOW, MODE_HIGH
extern int     Power_Price             = 0; // =0-6 PRICE_CLOSE,PRICE_OPEN,PRICE_HIGH,PRICE_LOW,PRICE_MEDIAN,PRICE_TYPICAL,PRICE_WEIGHTED
extern int     Price_Type              = 0;  // =0-3 PRICE_CLOSE,PRICE_OPEN,PRICE_HIGH,PRICE_LOW
extern int     Bands_Period            = 20;
extern int     Bands_Deviation         = 2;
extern int     Power_Period            = 13;
extern int     CountBars               = 300;
extern bool    iTrend_rev              = false;

extern bool    Use_MACD                = false;
extern int     MacdTF                  = 60;// MACD time frame
extern int     Fast_EMA                = 12;
extern int     Slow_EMA                = 26;
extern int     Signal_SMA              = 9;
extern int     MACD_Price              = 1;// 0:Close 1:Open 2:High 3:Low 4:Median 5:Typical 6:Weighted
extern double  MACD_mode               = 0;// = 0 - default MACD, != 0 - ZeroLag_MACD_v1
extern bool    MACD_rev                = false;

extern bool    UseStoch                = false;
extern int     STOCH_TF                = 60;
extern int     K                       = 5;
extern int     D                       = 3;
extern int    Slowing                  = 3;
extern int    Stoch_mode               = 0;     // 0:Simple 1:Exponential 2:Smoothed 3:Linear 4:Weighted
extern int    Stoch_price              = 0;     // 0:High/Low 1:Close/Close
extern double sto_buy                  = 80;
extern double sto_sell                 = 20;
extern bool   Stoch_rev                = false;

extern bool    UseTMA                  = false; //Triple moving average
extern int     TMA_TF                  = 240;
extern int     TMA_Method              = 3;//0 SMA, 1 EMA, 2 SMMA, 3 LWMA
extern int     TMA_Price               = PRICE_CLOSE; //0 close, 1 open, 2 high, 3 low, 4 median, 5 typical, 6 weighted
extern int     Short_MA_Period         = 3;
extern int     Med_MA_Period           = 20;
extern int     Long_MA_Period          = 50;
extern bool    TMA_rev                 = false;

extern bool    UseNLMA                 = false;
extern int     NLMA_TF                 = 240;
extern int     NLMA_Price              = 0; //Apply to Price(0-Close;1-Open;2-High;3-Low;4-Median price;5-Typical price;6-Weighted Close) 
extern int     NLMA_Length             = 9;  //Period of NonLagMA
extern int     NLMA_Displace           = 0;  //DispLace or Shift 
extern double  NLMA_PctFilter          = 0;  //Dynamic filter in decimal
extern bool    NLMA_rev                = false;

//Filters
extern bool    UseStochFilter          = false;
extern int     STOCH_Filter_TF         = 60;
extern int     K_Filter                = 5;
extern int     D_Filter                = 3;
extern int    Slowing_Filter           = 3;
extern int    Stoch_Filter_mode        = 0;     // 0:Simple 1:Exponential 2:Smoothed 3:Linear 4:Weighted
extern int    Stoch_Filter_price       = 0;     // 0:High/Low 1:Close/Close
extern double sto_Filter_up            = 80;
extern double sto_Filter_down          = 20;

//Money Mangement
extern bool    MoneyMangement          = true; //will autocalculate lot size, lot increment and profit target
extern bool    MicroAccount            = true; //will divide LotSize by 10
extern double  MaximumRisk             = 0.5;  // 1 mean 0.1% of balance
//Lots setup
extern double  LotSize                 = 0.01; //NULL if MoneyMangement is true
extern double  LotIncrement            = 0.01; //NULL if MoneyMangement is true
extern double  Multiplier              = 0;  // Will increase orders in Martingale fashion in direction of trend if set to "1". Used with TrendSpacing only.
extern double  CounterTrendMultiplier  = 0;  // Will increase orders in Martingale fashion in opposite direction of trend if set to "1". Used with Spacing only.
//Profit settings
extern double  ProfitTarget            = 1;  // All orders closed when this profit target amount (in deposit currency) is reached. set=0 to disable profit target
extern bool    IncrementProfitTarget   = true; //if true ProfitTarget will increase according to total traded lots
extern int     ProfitMode              = 1;  // 1= mixed mode, 2= global mode, 3= split mode
extern bool    ProfitTrailing          = true;  // Will try to allow profit grow beyond ProfitTarget
extern double  MaxRetrace              = 5;  // Maximum percent of MaxProfit allowed to decrease before close all orders

//send orders setup
extern double  SL                      = 0;  // Set 0 to disable.Performs better with no initial stoploss.
extern double  TP                      = 0;  //Set 0 to disable.
//trailing stop
extern int     TrailingStop           = 0; // set = 0 to disable trailing stop
extern int     TSstep                 = 1;

extern int     MaximumBuyOrders        = 100;
extern int     MaximumSellOrders       = 100;

//orders spacing options
extern bool    AutoSpacing             = true;  //Spacing will be calculated using stdDev
extern int     StDevTF                 = 1440;    // TF for StDev
extern int     StDevPer                = 14;    // lenght of StDev
extern int     StDevMode               = MODE_SMA; // mode of StDev - 0=SMA, 1=EMA, 2=SMMA, 3=LWMA 
extern int     MinSpacing              = 50; //Minimum spacing for AutoSpacing
extern int     Spacing                 = 25; // Minimum distance of orders placed against the trend of the initial order, In effect only if AutoSpacing=false
extern int     TrendSpacing            = 1000; // Minimum distance of orders placed with the trend of the initial order (set to 1000 to disable )

//closing options
extern int     CloseDelay              = 91; // Minimum close time for IBFX to not be considered scalping
extern bool    CeaseTrading            = false;

//time filter
extern string  PauseTrading            = "Pause Trading at Timeinterval";
extern int     PauseStart              = 0; //Example: Trading pause starts at hour 14, minute 30 (server time)--> input= 1430
extern int     PauseEnd                = 0; //Example: Trading pause ends at hour 15, minute 10 (server time)--> input= 1510
extern string  QuitTrading             = "Quit Trading at Time";
extern int     endDayHourMinute        = 0; //Example: Quit trading on day 17 hour 21 minute 59 (server time)-->input=172159
//other options
extern int     ForcedStart             = 0;  // 1 = New cycle will start if signal is for long, 2 = New cycle will start if signal is for short, 0 = disabled
extern bool    RightSideLabel          = false;
extern int     SessionTarget           = 100000000; //Trading will be stopped if this amount has been earned in this session

//loss management 
extern string  LossManagement         = "What to do if things are going wrong";
//extern string  Warning                = "This feature is in early stage and is not finished!";
extern bool    EquityStop             = false;   //enable/disable EquityStop
extern double  MaxLossPercent         = 50;      //maximum loss in balance procents 1=1% max loss
extern bool    ExitAllTrades          = true;   //Close all open orders
extern bool    StopTrading            = true;   //stop trading if EquityStop was triggered
bool    PlaceRecoveryOrders    = false;   //Use counter orders to get in profit
int     MaxRecoveryOrders      = 2;      //max extra orders to use for recovery
double  RecoveryTakeProfit     = 5;      //take profit in points
double  RecoveryStopLoss       = 200;     //stop loss in points
double  RecoveryLotMultiplier  = 1;     //lot size is auto calculated for USD based pairs. Increase or decrease according to pair used.
bool    RecReverse             = false;  // reverse direction of recovery trading

// Internal settings

double         stoploss       = 0;
double         takeprofit     = 0;
int            Error          = 0;
int            Order          = 0;


string         TradeComment;
int            MaxBuys        = 0;
int            MaxSells       = 0;
double         MaxProfit      = 0;
bool           Auditing       = false;
string         Filename;
double         initialBalance;
int            lotPrecision;
bool           TradeAllowed   = true;
bool           CloseBuysNOW; 
bool           CloseSellsNOW; 
bool           CloseAllNOW;
int            digit_correction=1;
//----------------------------------------------------------------------------
int init()
{
   if(Digits == 3 || Digits == 5)
   {
      Slippage *=10;
      Spacing *=10;
      TrendSpacing *=10;
      SL *=10;
      TP *=10;
      TrailingStop=TrailingStop*10;
      MinSpacing *=10;
      digit_correction = 10;
   }
   if(!IsExpertEnabled())
   {
      Alert(EA_name+" "+Symbol()+" Experts are disabled! Please enable experts.");
      return;
   }
   if(!IsTradeAllowed())
   {
      Alert(EA_name+" "+Symbol()+" Trade is not allowed!  Please allow live trading.");
      return;
   }
   initialBalance = AccountBalance();   
   TradeComment   = StringConcatenate(Symbol()," ",Period()," ",EA_name);      
   Filename       = StringConcatenate(EA_name+"_",Symbol(),"_",Period(),"_M",".txt");
   lotPrecision=LotPrecision();
   CloseBuysNOW  = false; CloseSellsNOW = false; CloseAllNOW = false;
   return(0);
}
//----------------------------------------------------------------------------
int deinit()
{

   int Total = ObjectsTotal();
   string String;

   for(int i = Total-1; i >= 0; i--)
   {
      String = ObjectName(i);
      if (StringFind(String, "pmk_",0) >= 0) ObjectDelete(String);
   }
   
   Comment("");
   return(0);
}
//----------------------------------------------------------------------------
int start()
{
   RefreshRates();
   double         MarginPercent;
   static double  LowMarginPercent = 10000000, LowEquity = 10000000;
   double         profit_target;
   int            SellOrders, BuyOrders;
   double         BuyPips, SellPips, BuyLots, SellLots;
   double         LowestBuy = 999, HighestBuy = 0.000001, LowestSell = 999, HighestSell = 0.000001, HighPoint, MidPoint, LowPoint;
   double         Profit = 0, BuyProfit = 0, SellProfit = 0, PosBuyProfit = 0, PosSellProfit = 0;
   int            HighestBuyTicket, LowestBuyTicket, HighestSellTicket, LowestSellTicket;
   double         HighestBuyProfit, LowestBuyProfit, HighestSellProfit, LowestSellProfit;
   bool           SELLme = false;
   bool           BUYme = false;
   double         Margin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   string         Message;
   
   if(TrailingStop > 0) TrailingStop();

   for (Order = OrdersTotal() - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            
            Profit = OrderProfit() + OrderSwap() + OrderCommission();
            
            if (OrderType() == OP_BUY)
            {
               if (OrderOpenPrice() >= HighestBuy)
               {
                  HighestBuy = OrderOpenPrice();
                  HighestBuyTicket = OrderTicket();
                  HighestBuyProfit = Profit;
               }

               if (OrderOpenPrice() <= LowestBuy)
               {
                  LowestBuy = OrderOpenPrice();
                  LowestBuyTicket = OrderTicket();
                  LowestBuyProfit = Profit;
               }

               BuyOrders++;
               if (BuyOrders > MaxBuys) MaxBuys = BuyOrders;
               BuyLots += OrderLots();

               BuyProfit += Profit;
               if (Profit > 0) PosBuyProfit += Profit; 
               
            }

            if (OrderType() == OP_SELL)
            {
               if (OrderOpenPrice() <= LowestSell)
               {
                  LowestSell = OrderOpenPrice();
                  LowestSellTicket = OrderTicket();
                  LowestSellProfit = Profit;
               }

               if (OrderOpenPrice() >= HighestSell)
               {
                  HighestSell = OrderOpenPrice();
                  HighestSellTicket = OrderTicket();
                  HighestSellProfit = Profit;
               }

               SellOrders++;
               if (SellOrders > MaxSells) MaxSells = SellOrders;
               SellLots += OrderLots();

               SellProfit += Profit;
               if (Profit > 0) PosSellProfit += Profit; 
            }
         }
      }
   }
   if (SellOrders==0)CloseSellsNOW=false;
   if (BuyOrders==0)CloseBuysNOW=false;
   if (SellOrders + BuyOrders==0) CloseAllNOW=false;

   if (HighestBuy >= HighestSell)
      HighPoint = HighestBuy;
   else
      HighPoint = HighestSell;

   if (LowestBuy <= LowestSell)
      LowPoint = LowestBuy;
   else
      LowPoint = LowestSell;

   MidPoint = (HighPoint + LowPoint) / 2;

//   if ((SellOrders > 1 && BuyOrders > 0) || (SellOrders > 0 && BuyOrders > 1)) MidPoint = (HighPoint + LowPoint) / 2;  

// ---------------------------------- Take Profit code --------------------------------------

 double TotalProfit = BuyProfit + SellProfit;
 double TotalOrders = BuyOrders + SellOrders; 
 if(ProfitTarget > 0)
 {
  if(MoneyMangement)
  {
  profit_target = NormalizeDouble((AutoLot()*100*ProfitTarget),2);

   if(IncrementProfitTarget && TotalOrders > 1)
   {
      profit_target = NormalizeDouble(((BuyLots+SellLots)*100*ProfitTarget),2);
   }
 }
 else profit_target=ProfitTarget;
 
  if(TotalProfit > MaxProfit) MaxProfit =TotalProfit;
  if(TotalOrders == 0 || TotalProfit<=0)MaxProfit = 0; 
  if (CloseAllNOW)ExitAllTradesNOW(Aqua, "");
//------------------------------------
  if(ProfitTrailing)
  {
   ProfitMode=0;
   if(TotalProfit >=profit_target  && TotalProfit <= (MaxProfit-(MaxProfit*MaxRetrace)/100))
      {
      CloseAllNOW=True; 
      ExitAllTradesNOW(Lime,"Max profit reached");
      }
  }
//------------------------------------
 if (ProfitMode==1 || ProfitMode==3)
 {
      if(BuyProfit>=profit_target)CloseBuysNOW=True;
      if(SellProfit>=profit_target)CloseSellsNOW=True;
 }
 if (ProfitMode==1 || ProfitMode==2 && BuyProfit + SellProfit >= profit_target) {CloseAllNOW=True; ExitAllTradesNOW(Lime,"Max target reached");}
 if (CloseBuysNOW)CloseAllBuyProfit();
 if (CloseSellsNOW)CloseAllSellProfit();
}
// ----------------------------------End Take Profit code --------------------------------------
   int Direction = Direction();
 
   if(ReverseDirection)  Direction = -Direction;    

// ---------------------------------- Loss Management code --------------------------------------
   bool NoBuy=false;
   bool NoSell=false;
   
   if(EquityStop)
   {
      int returnValue;
 	   if(iMA(Symbol(),5,10,0,MODE_SMA,PRICE_CLOSE,0) < iMA(Symbol(),5,10,1,MODE_SMA,PRICE_CLOSE,1)) {returnValue=-1;} // Trade Direction Short
	   if(iMA(Symbol(),5,10,0,MODE_SMA,PRICE_OPEN,0) > iMA(Symbol(),5,10,1,MODE_SMA,PRICE_OPEN,1)) {returnValue=1;} // Trade Direction Long 
      if(RecReverse) returnValue=-returnValue; //If for some reason consider necessary to invert direction
       
      double MaxLoss = AccountBalance()/100*MaxLossPercent;
         
      if(SellProfit<=-MaxLoss)
      {
            NoSell=true; //Do not allow to place more losing orders
            NoBuy=false;
          
          if(ExitAllTrades) {CloseAllNOW=True; ExitAllTradesNOW(Aqua,"Sell profit going under max allowed loss");}
          
          if(PlaceRecoveryOrders && RecoveryOrders() < MaxRecoveryOrders)
          {
             //Calculate recovery lot size
          double totalSLoss=SellProfit-profit_target;
          double pointSValue=(-totalSLoss/RecoveryTakeProfit);
          double recoverySLot=pointSValue/10 * RecoveryLotMultiplier;
          if(returnValue == 1) OrderSend(Symbol(), OP_BUY,  recoverySLot, Ask, Slippage, Ask - RecoveryStopLoss * Point, Ask + RecoveryTakeProfit * Point, "Rec", MagicNumber*2,0, Green);
          if(returnValue == -1)OrderSend(Symbol(), OP_SELL, recoverySLot, Bid, Slippage, Bid + RecoveryStopLoss * Point, Bid - RecoveryTakeProfit * Point, "Rec", MagicNumber*2,0, Red);

          if(StopTrading) CeaseTrading=true;
          }
        }

         if(BuyProfit<=-MaxLoss)
         {
           NoBuy=true; //Do not allow to place more losing orders
           NoSell=false;
          
          if(ExitAllTrades){CloseAllNOW=True; ExitAllTradesNOW(Aqua,"Buy profit going under max allowed loss");}
          
          if(PlaceRecoveryOrders && RecoveryOrders() < MaxRecoveryOrders){
             //Calculate recovery lot size
          double totalBLoss=BuyProfit-profit_target;
          double pointBValue=(-totalBLoss/RecoveryTakeProfit);
          double recoveryBLot=pointBValue/10 * RecoveryLotMultiplier;
          if(returnValue == -1)OrderSend(Symbol(), OP_SELL, recoveryBLot, Bid, Slippage, Bid + RecoveryStopLoss * Point, Bid - RecoveryTakeProfit *  Point, "Rec", MagicNumber*2,0, Red);
          if(returnValue == 1) OrderSend(Symbol(), OP_BUY,  recoveryBLot, Ask, Slippage, Ask - RecoveryStopLoss * Point, Ask + RecoveryTakeProfit * Point,  "Rec", MagicNumber*2,0, Green);

          if(StopTrading) CeaseTrading=true;          
          }
         }
      }
// ----------------------------------End Loss Management code -------------------------------------   

// ----------------------------------Forced cycle start code -------------------------------------- 

   if(ForcedStart>0 && BuyOrders+SellOrders==0){
      if(ForcedStart==1 && Direction==-1 || ForcedStart==2 && Direction==1) TradeAllowed=false;
}
// ----------------------------------End Forced cycle start code ----------------------------------

// ----------------------------------Variable spacing code ----------------------------------------

   if (AutoSpacing == 1){
      double stddev = iStdDev(Symbol(),StDevTF,StDevPer,0,StDevMode,PRICE_OPEN,0)/Point;
      Spacing = stddev;
      if(Spacing<MinSpacing) Spacing=MinSpacing;
      if(TrendSpacing != 1000*digit_correction)  TrendSpacing=stddev;
      else TrendSpacing = 1000*digit_correction;
      if(TrendSpacing<MinSpacing) TrendSpacing=MinSpacing;
   }
// ----------------------------------End Variable spacing code ------------------------------------- 


  
// ----------------------------------Open Trade code -----------------------------------------------
if(TradeAllowed)
{
   // BUY Trade Criteria
   if (HighestBuy > 0 && LowestBuy < 1000)
   {
      if (Ask <= LowestBuy - (Spacing * Point) || Ask >= HighestBuy + (TrendSpacing * Point))
      {
         BUYme = true;
      }         
      if((Direction != 1)                    ||
         (CeaseTrading && BuyOrders == 0)    ||
          NoBuy                              ||
          PauseAtTime()==1                   ||
          TradeWait()==1                     ||
          CycleWait()==1                     ||
          CloseBuysNOW                       ||
          CloseAllNOW                        ||
         (OneDirectionOnly && SellOrders>0)  ||
         (ExclusiveMode && GetOtherOrders()))
          BUYme = false;
      if (BUYme && TradeLong==true) PlaceBuyOrder();
   }

   // SELL Trade Criteria
   if (HighestSell > 0 && LowestSell < 1000)
   {
      if (Bid >= HighestSell + (Spacing * Point) || Bid <= LowestSell - (TrendSpacing * Point))
      {
         SELLme = true;
      }         
      if((Direction != -1)                   ||
         (CeaseTrading && SellOrders == 0)   ||
          NoSell                             ||
          PauseAtTime()==1                   ||
          TradeWait()==1                     ||
          CycleWait()==1                     ||
          CloseSellsNOW                      ||
          CloseAllNOW                        ||
         (OneDirectionOnly && BuyOrders>0)   ||
         (ExclusiveMode && GetOtherOrders()))
          SELLme = false;
      if (SELLme && TradeShort==true) PlaceSellOrder();
   }
 }  
// ----------------------------------End Open Trade code --------------------------------------   

   if(AccountMargin()!=0)
   {
      MarginPercent = MathRound((AccountEquity() / AccountMargin()) * 100);
   }   

   if (LowMarginPercent > MarginPercent && MarginPercent!=0) LowMarginPercent = MarginPercent;
   if (AccountEquity() < LowEquity) LowEquity = AccountEquity();

if(IsVisualMode() || !IsTesting())
{
   Message = " "+NL+EA_name + NL +
             " ProfitTarget           " + DoubleToStr(profit_target, 2) + NL +
             " MaxProfit              " + DoubleToStr(MaxProfit, 2) + NL +
             " Floating PL            " + DoubleToStr(TotalProfit, 2) + NL +
             " Buys                    " + BuyOrders + "  Highest: " + MaxBuys + NL +
             " BuyLots                " + DoubleToStr(BuyLots, 2) + NL +
             " BuyProfit              " + DoubleToStr(BuyProfit, 2) + NL +
             " Highest Buy           " + DoubleToStr(HighestBuy, Digits) + " #" + DoubleToStr(HighestBuyTicket, 0) + "  Profit: " + DoubleToStr(HighestBuyProfit, 2) + NL +
             " Highest Sell           " + DoubleToStr(HighestSell, Digits) + " #" + DoubleToStr(HighestSellTicket, 0) + "  Profit: " + DoubleToStr(HighestSellProfit, 2) + NL + NL +
             " Sells                     " + SellOrders + "  Highest: " + MaxSells + NL +
             " SellLots                 " + DoubleToStr(SellLots, 2) + NL +
             " SellProfit               " + DoubleToStr(SellProfit, 2) + NL +
             " Lowest Buy            " + DoubleToStr(LowestBuy, Digits) + " #" + DoubleToStr(LowestBuyTicket, 0) + "  Profit: " + DoubleToStr(LowestBuyProfit, 2) + NL +
             " Lowest Sell            " + DoubleToStr(LowestSell, Digits) + " #" + DoubleToStr(LowestSellTicket, 0) + "  Profit: " + DoubleToStr(LowestSellProfit, 2) + NL + NL +
             " Spacing                " + Spacing + NL +
             " Trend Spacing       " + TrendSpacing + NL +NL+
             " Balance                " + DoubleToStr(AccountBalance(), 2) + NL +
             " Equity                  " + DoubleToStr(AccountEquity(), 2) + "  Lowest: " + DoubleToStr(LowEquity, 2) + NL + NL +
             " Margin                  " + DoubleToStr(AccountMargin(), 2) + NL +
             " MarginPercent        " + DoubleToStr(MarginPercent, 2) + NL +
             " LowMarginPercent  " + DoubleToStr(LowMarginPercent, 2) + NL +
             " Current Time is      " +  TimeToStr(TimeCurrent(), TIME_SECONDS);
   Comment(Message);
 
 //------------------------------------------------------------------------------------------------  
   if (RightSideLabel) 
   {
      string MarPercent = DoubleToStr(MarginPercent, 0);
      string LowMarPercent = DoubleToStr(LowMarginPercent, 0);

      string AcctBalance = DoubleToStr(AccountBalance(), 0);
      ObjectDelete("pmk_MarginPercent");

      if (ObjectFind("pmk_MarginPercent") != 0)
      {
         ObjectCreate("pmk_MarginPercent", OBJ_TEXT, 0, Time[0], Close[0]);
         ObjectSetText("pmk_MarginPercent", MarPercent + "%  " + LowMarPercent + "%  $" + AcctBalance, 10, "Arial Black", DodgerBlue);
      }
      else
      {
         ObjectMove("pmk_MarginPercent", 0, Time[0], Close[0]);
      }
   }

   if (ObjectFind("pmk_MidPoint") != 0)
   {
      ObjectCreate("pmk_MidPoint", OBJ_HLINE, 0, Time[0], MidPoint);
      ObjectSet("pmk_MidPoint", OBJPROP_COLOR, Gold);
      ObjectSet("pmk_MidPoint", OBJPROP_WIDTH, 2);
   }
   else
   {
      ObjectMove("pmk_MidPoint", 0, Time[0], MidPoint);
   }
}
 //------------------------------------------------------------------------------------------------    
   //QuitTrading(SellOrders);
   getSessionTarget();
   QuitAtTime(endDayHourMinute);
   return(0);
}
//------------------------------------------------------------------------------------------------
int LotPrecision(){
   double lotstep=MarketInfo(Symbol(),MODE_LOTSTEP);
   if(lotstep==1)     return(0);
   if(lotstep==0.1)   return(1);
   if(lotstep==0.01)  return(2);
   if(lotstep==0.001) return(3);
}
//----------------------------------------------------------------------------
double AutoLot()
  {
   double lot, minlot;
   //lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/10000.0,2);
   lot=NormalizeDouble(AccountBalance()/10000,lotPrecision)*MaximumRisk;
   if(MicroAccount)lot=NormalizeDouble(lot/10,lotPrecision);
   minlot=MarketInfo(Symbol(),MODE_MINLOT);
   if(lot<minlot) lot=minlot;
   return(lot);
  }


int RecoveryOrders(){
int RecTotal=0;
int cnt;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderMagicNumber() == MagicNumber * 2 && OrderComment()=="Rec" && OrderSymbol()==Symbol())
      RecTotal++;
   }
   return (RecTotal);
}

//----------------------------------------------------------------------------
void PlaceBuyOrder()
{
   double BuyOrders, Lots;
   double LowestBuy = 1000, HighestBuy, lot_size=0, lot_increment=0;
   int ticket=0;
   if(MoneyMangement)
   {
      lot_size = AutoLot();
      if(LotIncrement > 0) lot_increment = lot_size;
   }
   else
   {
      lot_size = LotSize;
      lot_increment = LotIncrement;
   }

   RefreshRates();
   for (Order = OrdersTotal() - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)
         {
            if (OrderOpenPrice() < LowestBuy) LowestBuy = OrderOpenPrice();
            if (OrderOpenPrice() > HighestBuy) HighestBuy = OrderOpenPrice();
            BuyOrders++;
         }
      }
   }
   if(BuyOrders == 0)
   {
      if(MoneyMangement) Lots = AutoLot();
      else Lots = lot_size;
   }
   else
   {
      if (Ask >= HighestBuy + (TrendSpacing * Point))
      {
         if (Multiplier == 1) Lots = NormalizeDouble(MathPow(2,BuyOrders)*lot_size, lotPrecision);
         else Lots = NormalizeDouble(lot_size + (lot_increment * BuyOrders), lotPrecision);
      }

      if (Ask <= LowestBuy - (Spacing * Point))
      {
         if (CounterTrendMultiplier == 1) Lots = NormalizeDouble(MathPow(2,BuyOrders)*lot_size, lotPrecision);
         else  Lots = NormalizeDouble(lot_size + (lot_increment * BuyOrders), lotPrecision);
      }
   }
   
   if(IsTradeAllowed() && BuyOrders < MaximumBuyOrders)
   {
      if (SL == 0) stoploss   = 0; else stoploss   = Ask - (SL * Point);
      if (TP == 0) takeprofit = 0; else takeprofit = Ask + (TP * Point);
      ticket=OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, 0, 0, TradeComment, MagicNumber,0, Blue);
      Sleep(500);
      if(ticket>0 && (stoploss>0 || takeprofit>0)) OrderModify(ticket,OrderOpenPrice(),stoploss,takeprofit,0,Blue);
   }

   Error = GetLastError();
   if (Error != 0) Write("Error opening BUY order: " + ErrorDescription(Error) + " (C" + Error + ")  Ask:" + Ask + "  Slippage:" + Slippage);
}
//----------------------------------------------------------------------------
void PlaceSellOrder()
{
   double SellOrders, Lots;
   double HighestSell, LowestSell = 1000, lot_size=0, lot_increment=0;
   int ticket=0;
   if(MoneyMangement)
   {
      lot_size = AutoLot();
      if(LotIncrement > 0) lot_increment = lot_size;
   }
   else
   {
      lot_size = LotSize;
      lot_increment = LotIncrement;
   }
   
   RefreshRates();
   for (Order = OrdersTotal() - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL)
         {
            if (OrderOpenPrice() > HighestSell) HighestSell = OrderOpenPrice();
            if (OrderOpenPrice() < LowestSell) LowestSell = OrderOpenPrice();
            SellOrders++;
         }
      }
   }
   if(SellOrders==0)
   {
      if(MoneyMangement)Lots =AutoLot();
      else Lots = lot_size;
   }
   else
   {
      if (Bid <= LowestSell - (TrendSpacing * Point))
      {
         if (Multiplier == 1) Lots = NormalizeDouble(MathPow(2,SellOrders)*lot_size, lotPrecision);
         else  Lots = NormalizeDouble(lot_size + (lot_increment * SellOrders), lotPrecision);
      }
   
      if (Bid >= HighestSell + (Spacing * Point))
      {
         if (CounterTrendMultiplier == 1) Lots = NormalizeDouble(MathPow(2,SellOrders)*lot_size, lotPrecision);
         else Lots = NormalizeDouble(lot_size + (lot_increment * SellOrders), lotPrecision);
      }
   }
   
   if(IsTradeAllowed() && SellOrders < MaximumSellOrders)
   {  
      if (SL == 0) stoploss = 0; else stoploss = Bid + (SL * Point); 
      if (TP == 0) takeprofit = 0; else takeprofit = Bid - (TP * Point);
      ticket=OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, 0, 0,TradeComment,MagicNumber,0, Red);
      Sleep(500);
      if(ticket>0 && (stoploss>0 || takeprofit>0)) OrderModify(ticket,OrderOpenPrice(),stoploss,takeprofit,0,Blue);
   }
   
   Error = GetLastError();
   if (Error != 0) Write("Error opening SELL order: " + ErrorDescription(Error) + " (D" + Error + ")  Bid:" + Bid + "  Slippage:" + Slippage);
}
//----------------------------------------------------------------------------
void CloseAllBuyProfit()
{
int spread=MarketInfo(Symbol(),MODE_SPREAD);
   for(int i = OrdersTotal()-1; i >=0; i--)
       {
       OrderSelect(i, SELECT_BY_POS);
       bool result = false;
       if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)  
         {
            int Retry=0; while (Retry<5 && !IsTradeAllowed()) { Retry++; Sleep(2000); }
            if (TimeCurrent()-OrderOpenTime() >= CloseDelay) result = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), Slippage, Aqua );
         }
       }
     
  return; 
}
//----------------------------------------------------------------------------
void CloseAllSellProfit()
{
int spread=MarketInfo(Symbol(),MODE_SPREAD);
   for(int i = OrdersTotal()-1; i >=0; i--)
      {
      OrderSelect(i, SELECT_BY_POS);
      bool result = false;
      if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) 
       {
         int Retry=0; while (Retry<5 && !IsTradeAllowed()) { Retry++; Sleep(2000); }
         if (TimeCurrent()-OrderOpenTime() >= CloseDelay) result = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), Slippage, Lime);
       }
     }
 
  return; 
}
//----------------------------------------------------------------------------
void Write(string String)
{
   int Handle;

   if (!Auditing) return;

   Handle = FileOpen(Filename, FILE_READ|FILE_WRITE|FILE_CSV, "/t");
   if (Handle < 1)
   {
      Print("Error opening audit file: Code ", GetLastError());
      return;
   }

   if (!FileSeek(Handle, 0, SEEK_END))
   {
      Print("Error seeking end of audit file: Code ", GetLastError());
      return;
   }

   if (FileWrite(Handle, TimeToStr(CurTime(), TIME_DATE|TIME_SECONDS) + "  " + String) < 1)
   {
      Print("Error writing to audit file: Code ", GetLastError());
      return;
   }

   FileClose(Handle);
}

//------------------------------------------------------------------------------------------------
int Direction() //tradeDirection=1: long, tradeDirection=-1: short 
{
int tradeDirection=0;
color c=Yellow;
  if (((Use_Fisher && FisherDecision() == 1)    || !Use_Fisher)
  && ((UseCCI && CCIDecision()  == 1)           || !UseCCI) 
  && ((UseARSI && ARSIDecision()  == 1)         || !UseARSI) 
  && ((Use_iTrend && iTrendDecision()  == 1)    || !Use_iTrend)
  && ((Use_MACD && MACDDecision() == 1)         || !Use_MACD)
  && ((UseStoch && StochDecision() == 1)        || !UseStoch)
  && ((UseTMA && TMADecision() == 1)            || !UseTMA)
  && ((UseNLMA && NLMADecision() == 1)          || !UseNLMA)
  && ((UseStochFilter && StochFilter() == 1)    || !UseStochFilter))
   {tradeDirection=1;c=Green;}
   
  if(((Use_Fisher && FisherDecision() == -1)    || !Use_Fisher)
  && ((UseCCI && CCIDecision()  == -1)          || !UseCCI) 
  && ((UseARSI && ARSIDecision() == -1)         || !UseARSI) 
  && ((Use_iTrend && iTrendDecision()  == -1)   || !Use_iTrend)
  && ((Use_MACD && MACDDecision() == -1)        || !Use_MACD)
  && ((UseStoch && StochDecision() == -1)       || !UseStoch)
  && ((UseTMA && TMADecision() == -1)           || !UseTMA)
  && ((UseNLMA && NLMADecision() == -1)         || !UseNLMA)
  && ((UseStochFilter && StochFilter() == 1)    || !UseStochFilter))
      {tradeDirection=-1;c=Red;}
 
    if((FisherDecision()==0 && CCIDecision()==0 && iTrendDecision()==0 && ARSIDecision()==0 && MACDDecision()==0 && TMADecision()==0 && StochDecision() ==0 && NLMADecision() ==0) 
    || (!Use_Fisher && !UseCCI && !Use_iTrend && !UseARSI && !Use_MACD && !UseTMA && !UseStoch && !UseNLMA))
      {tradeDirection=0;c=Yellow;}
 if(IsVisualMode() || !IsTesting())
 {
       if (ObjectFind("pmk_Direction") != 0)
      {
         ObjectCreate("pmk_Direction", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_Direction", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_Direction", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_Direction", OBJPROP_YDISTANCE, 10);
      }
         else
         ObjectSetText("pmk_Direction","Direction",10,"Arial Bold",c); 
 
 }
   return (tradeDirection);  
}
//------------------------------------------------------------------------------------------------
int FisherDecision()
{
int tradeDirection=0;
color c = Silver;
   if(Use_Fisher==true)
   {
      double fish1 = iCustom(NULL,FisherPeriod,"Fisher_m11",Fisher_Bars,Fisher_price_smooth,Fisher_index_smooth,0,1);
      double fish0 = iCustom(NULL,FisherPeriod,"Fisher_m11",Fisher_Bars,Fisher_price_smooth,Fisher_index_smooth,0,0);
   
      if (
      fish0>fish1 && 
      fish0 >= Fisher_Level) {tradeDirection=1;c=Green;}
      else if (
      fish0<fish1 && 
      fish0 <= -Fisher_Level) {tradeDirection=-1;c=Red;}
      else {tradeDirection=0;c=Yellow;}
      if(Fisher_rev) tradeDirection = -tradeDirection;
   }     
   if(IsVisualMode() || !IsTesting())
	{
	  if (ObjectFind("pmk_Fisher") != 0)
      {
         ObjectCreate("pmk_Fisher", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_Fisher", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_Fisher", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_Fisher", OBJPROP_YDISTANCE, 130);
      }
         else
         ObjectSetText("pmk_Fisher","Fisher",8,"Arial Bold",c);
	}
   return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
int CCIDecision()
{
 int tradeDirection=0;
 color c=Silver;

   if(UseCCI==true)
   {
      double cci=0;
      cci=iCCI( NULL, CCI_Period, CCI_lenght, PRICE_TYPICAL, 0);
      if(cci < -cci_trigger){tradeDirection=-1;c=Red;}
      else if(cci > cci_trigger){tradeDirection=1;c=Green;}
      else {tradeDirection=0;c=Yellow;}
      if(CCI_rev) tradeDirection = -tradeDirection;
   }
   if(IsVisualMode() || !IsTesting())
   {   
      if (ObjectFind("pmk_CCI") != 0)
      {
         ObjectCreate("pmk_CCI", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_CCI", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_CCI", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_CCI", OBJPROP_YDISTANCE, 115);
      }
         else
         ObjectSetText("pmk_CCI","CCI",8,"Arial Bold",c);  
   }
   return(tradeDirection);         
}
//----------------------------------------------------------------------------
int ARSIDecision()
{
 int tradeDirection=0;
 color c=Silver;
double RSI_1, RSI_2, RSIT;
   if(UseARSI==true)
   {
      RSI_1 = iCustom(NULL, RSI_period,"Adaptive RSI", RSI_bars, 0, 0)*10;
      RSI_2 = iCustom(NULL, RSI_period,"Adaptive RSI", RSI_bars, 0, 1)*10;
      if(ARSI_trigger==0) RSIT = iATR(NULL,1,13, 0)*10;
      if(ARSI_trigger>0)  RSIT = ARSI_trigger;
      
      if ( RSI_1 > RSI_2 && RSI_1 - RSI_2 > RSIT) {tradeDirection=1;c=Green;}
      else if ( RSI_1 < RSI_2 && RSI_2 - RSI_1 > RSIT) {tradeDirection=-1;c=Red;}
      else {tradeDirection=0;c=Yellow;}
      
      if(ARSI_rev) tradeDirection = -tradeDirection;
   }
   if(IsVisualMode() || !IsTesting())
   {
      if (ObjectFind("pmk_ARSI") != 0)
      {
         ObjectCreate("pmk_ARSI", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_ARSI", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_ARSI", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_ARSI", OBJPROP_YDISTANCE, 100);
      }
         else
         ObjectSetText("pmk_ARSI","ARSI",8,"Arial Bold",c);  
   }
   return(tradeDirection);         
}
//----------------------------------------------------------------------------
int iTrendDecision()
{
int tradeDirection=0;
color c=Silver;

   if(Use_iTrend==true)
   {
  	   double B1_1 = iCustom(NULL, iTrendPeriod, "i_Trend", Bands_Mode, Power_Price, Price_Type, Bands_Period, Bands_Deviation, Power_Period, CountBars, 0, 0);
      double B1_2 = iCustom(NULL, iTrendPeriod, "i_Trend", Bands_Mode, Power_Price, Price_Type, Bands_Period, Bands_Deviation, Power_Period, CountBars, 1, 0);
      double B2_2 = iCustom(NULL, iTrendPeriod, "i_Trend", Bands_Mode, Power_Price, Price_Type, Bands_Period, Bands_Deviation, Power_Period, CountBars, 0, 1);
   
      if (B1_1 > B1_2 && B1_1 > B2_2) {tradeDirection=1;c=Green;}
      else if (B1_1 < B1_2 && B1_1 < B2_2) {tradeDirection=-1;c=Red;}
      else {tradeDirection=0;c=Yellow;}
      
      if(iTrend_rev) tradeDirection = -tradeDirection;
 
   }     
   if(IsVisualMode() || !IsTesting())
   {
      if (ObjectFind("pmk_iTrend") != 0)
      {
         ObjectCreate("pmk_iTrend", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_iTrend", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_iTrend", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_iTrend", OBJPROP_YDISTANCE, 85);
      }
         else
         ObjectSetText("pmk_iTrend","iTrend",8,"Arial Bold",c);   
   }
   return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
int MACDDecision()
{
int tradeDirection = 0;
double MacdCurrent,MacdPrevious,SignalCurrent,SignalPrevious;
color c=Silver;
 if(Use_MACD==true)
 {

   if(MACD_mode==0)
   { 
      MacdCurrent=iMACD(NULL,MacdTF,Fast_EMA,Slow_EMA,Signal_SMA,MACD_Price,MODE_MAIN,0);
      MacdPrevious=iMACD(NULL,MacdTF,Fast_EMA,Slow_EMA,Signal_SMA,MACD_Price,MODE_MAIN,1);
      SignalCurrent=iMACD(NULL,MacdTF,Fast_EMA,Slow_EMA,Signal_SMA,MACD_Price,MODE_SIGNAL,0);
      SignalPrevious=iMACD(NULL,MacdTF,Fast_EMA,Slow_EMA,Signal_SMA,MACD_Price,MODE_SIGNAL,1); 
   }
   else
   { 
      MacdCurrent=iCustom(NULL,MacdTF,"ZeroLag_MACD_v1",Fast_EMA,Slow_EMA,Signal_SMA,0,0,0);
      MacdPrevious=iCustom(NULL,MacdTF,"ZeroLag_MACD_v1",Fast_EMA,Slow_EMA,Signal_SMA,0,0,1);
      SignalCurrent=iCustom(NULL,MacdTF,"ZeroLag_MACD_v1",Fast_EMA,Slow_EMA,Signal_SMA,0,1,0);
      SignalPrevious=iCustom(NULL,MacdTF,"ZeroLag_MACD_v1",Fast_EMA,Slow_EMA,Signal_SMA,0,1,1);
   } 
   if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious )
   {tradeDirection=1;c=Green;}
   else if( MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious)
   {tradeDirection=-1;c=Red;}
   else {tradeDirection=0;c=Yellow;}
   
   if(MACD_rev) tradeDirection = -tradeDirection;
 }
 if(IsVisualMode() || !IsTesting())
 {
   if (ObjectFind("pmk_MACD") != 0)
   {
      ObjectCreate("pmk_MACD", OBJ_LABEL, 0, 0, 0);
      ObjectSet("pmk_MACD", OBJPROP_CORNER, 3);
      ObjectSet("pmk_MACD", OBJPROP_XDISTANCE, 10);
      ObjectSet("pmk_MACD", OBJPROP_YDISTANCE, 70);
   }
   else ObjectSetText("pmk_MACD","MACD",8,"Arial Bold",c);   
 }
 return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
int TMADecision() //tradeDirection=1: long, tradeDirection=-1: short 
{
  int tradeDirection=0;
   color c=Silver;
   if(UseTMA==True)
   {
      double MA3_0 = iMA(NULL, TMA_TF, Short_MA_Period, 0, TMA_Method, TMA_Price, 0);
      double MA3_1 = iMA(NULL, TMA_TF, Short_MA_Period, 0, TMA_Method, TMA_Price, 1);
      double MA20_0 = iMA(NULL, TMA_TF, Med_MA_Period, 0, TMA_Method, TMA_Price, 0);
      double MA20_1 = iMA(NULL, TMA_TF, Med_MA_Period, 0, TMA_Method, TMA_Price, 1);
      double MA50_0 = iMA(NULL, TMA_TF, Long_MA_Period, 0, TMA_Method, TMA_Price, 0);
      double MA50_1 = iMA(NULL, TMA_TF, Long_MA_Period, 0, TMA_Method, TMA_Price, 1);
      
     
      if (MA50_0<MA50_1 && MA20_0<MA20_1 && MA3_0<MA3_1 && MA3_0<MA20_0) {tradeDirection=-1;c=Red;}
      else if (MA50_0>MA50_1 && MA20_0>MA20_1 && MA3_0>MA3_1 && MA3_0>MA20_0) {tradeDirection=1;c=Green;}
      else {tradeDirection=0;c=Yellow;}
      
      if(TMA_rev) tradeDirection = -tradeDirection;
	}
	
	if(IsVisualMode() || !IsTesting())
	{
	  if (ObjectFind("pmk_TMA") != 0)
      {
         ObjectCreate("pmk_TMA", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_TMA", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_TMA", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_TMA", OBJPROP_YDISTANCE, 55);
      }
         else
         ObjectSetText("pmk_TMA","TMA",8,"Arial Bold",c);
	}
	return(tradeDirection);
}
//------------------------------------------------------------------------------------------------
int StochDecision()
{
   int tradeDirection=0;
    color c=Silver;
   if(UseStoch==true)
   {

      double main_cur    = iStochastic(NULL, STOCH_TF, K, D, Slowing,Stoch_mode, Stoch_price, MODE_MAIN, 0);
      double main_prev   = iStochastic(NULL, STOCH_TF, K, D, Slowing,Stoch_mode, Stoch_price, MODE_MAIN, 1);
      double signal_cur  = iStochastic(NULL, STOCH_TF, K, D, Slowing,Stoch_mode, Stoch_price, MODE_SIGNAL, 0);
      double signal_prev = iStochastic(NULL, STOCH_TF, K, D, Slowing,Stoch_mode, Stoch_price, MODE_SIGNAL, 1);
    
      if((main_cur > signal_cur) && (main_prev < signal_prev) && main_cur >= sto_buy)   {tradeDirection=1;c=Green;}    
      else if((main_cur < signal_cur) && (main_prev > signal_prev) &&  main_cur <=sto_sell)  {tradeDirection=-1;c=Red;}
      else {tradeDirection=0;c=Yellow;}
      
      if(Stoch_rev) tradeDirection = -tradeDirection;
  }
  else
     tradeDirection=0;
     if(IsVisualMode() || !IsTesting())
	{
	  if (ObjectFind("pmk_Stoch") != 0)
      {
         ObjectCreate("pmk_Stoch", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_Stoch", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_Stoch", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_Stoch", OBJPROP_YDISTANCE, 40);
      }
         else
         ObjectSetText("pmk_Stoch","Stoch",8,"Arial Bold",c);
	}  
   return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
int NLMADecision()
{
   int tradeDirection=0;
    color c=Silver;
   double ma1=0,ma2=0;
   if(UseNLMA==true)
   {

      ma1=iCustom(NULL,NLMA_TF,"NonLagMA_v7.1.1",NLMA_Price,NLMA_Length,NLMA_Displace,NLMA_PctFilter,1,3,0);
      ma2=iCustom(NULL,NLMA_TF,"NonLagMA_v7.1.1",NLMA_Price,NLMA_Length,NLMA_Displace,NLMA_PctFilter,1,3,1);    
      if(ma1==1 && ma2==-1)      {tradeDirection=1;c=Green;}
      else if(ma1==-1 && ma2==1) {tradeDirection=-1;c=Red;}
      else {tradeDirection=0;c=Yellow;}
      
      if(NLMA_rev) tradeDirection = -tradeDirection;    
  }
  else
  tradeDirection=0;
  if(IsVisualMode() || !IsTesting())
	{
	  if (ObjectFind("pmk_NLMA") != 0)
      {
         ObjectCreate("pmk_NLMA", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_NLMA", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_NLMA", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_NLMA", OBJPROP_YDISTANCE, 25);
      }
         else
         ObjectSetText("pmk_NLMA","NLMA",8,"Arial Bold",c);
	}
  return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
int StochFilter()
{
   int tradeDirection;
    color c=Silver;
   if(UseStochFilter==true)
   {

      double main_cur    = iStochastic(NULL, STOCH_Filter_TF, K_Filter, D_Filter, Slowing_Filter,Stoch_Filter_mode, Stoch_Filter_price, MODE_MAIN, 0);
      double signal_cur  = iStochastic(NULL, STOCH_Filter_TF, K_Filter, D_Filter, Slowing_Filter,Stoch_Filter_mode, Stoch_Filter_price, MODE_SIGNAL, 0);
    
      if(main_cur >= sto_Filter_up || main_cur <=sto_Filter_down)  {tradeDirection=0;c=Red;}
      else {tradeDirection=1;c=Green;}
      
      if(Stoch_rev) tradeDirection = -tradeDirection;
  }
  else
     tradeDirection=1;
     if(IsVisualMode() || !IsTesting())
	{
	  if (ObjectFind("pmk_StochF") != 0)
      {
         ObjectCreate("pmk_StochF", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("pmk_StochF", OBJPROP_CORNER, 3);
      	ObjectSet("pmk_StochF", OBJPROP_XDISTANCE, 10);
         ObjectSet("pmk_StochF", OBJPROP_YDISTANCE, 145);
      }
         else
         ObjectSetText("pmk_StochF","StochFilter",8,"Arial Bold",c);
	}  
   return(tradeDirection); 
}
//------------------------------------------------------------------------------------------------
void QuitAtTime(int endDayHour)//input example: close trading tomorrow at 20:59. Today: 14. April, toworrow:15.April. 142059
{
   int t=TimeDay(TimeCurrent())*10000+TimeHour(TimeCurrent())*100+TimeMinute(TimeCurrent());
   if(t>=endDayHour && endDayHour!=0)
   {
      CeaseTrading=true;CloseAllNOW=True;
      ExitAllTradesNOW(Gold, "Stopped Trading because PauseEnd reached!");
   }
}
//----------------------------------------------------------------------------
int PauseAtTime()
{
   if(PauseStart>0 && PauseEnd>0)
   {
      int t=TimeHour(TimeCurrent())*100+TimeMinute(TimeCurrent());
      if(t>=PauseStart && t<=PauseEnd) 
      {
         return (1);
      }
      else return (0);
   }
    return (0);
}
//----------------------------------------------------------------------------
double SessionProfit()
{
   double profitHistory;
   double profitOpenP;
   double returnValue;
     
   for(int i = OrdersHistoryTotal()-1; i>=0; i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
      {
         if(OrderComment()==TradeComment)
         {
            profitHistory +=OrderProfit(); 
         }
      }
   }
   
   for(int j=OrdersTotal()-1;j>=0;j--)
   {
      OrderSelect(j,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
      {
         if(OrderComment()==TradeComment)
         {
            profitOpenP +=OrderProfit(); 
         }
      }      
   }
   
   returnValue=profitHistory+profitOpenP;   
   return(returnValue);         
}
//------------------------------------------------------------------------------------------------
void getSessionTarget()
{
   if(SessionTarget>0){
      if(SessionProfit()>=SessionTarget)
      {
         CeaseTrading=true; CloseAllNOW=true;
         ExitAllTradesNOW(Aqua, "Session Target Achieved. YUHUUI!");
      }
   }   
}
//------------------------------------------------------------------------------------------------
void ExitAllTradesNOW(color Color, string reason){
   if (CloseAllNOW)
   {
      bool success;
      for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt --){
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber){
            success=OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Slippage, Color);
            if(success==true){
            if(!IsTesting())   Print("Closed all positions because ",reason);
            }
         } 
      }     
   }
}   
//------------------------------------------------------------------------------------------------
bool GetOtherOrders()
{
   int cnt = OrdersTotal();
   if(cnt>0)
   {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt --)
      {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if((OrderSymbol() != Symbol()) ||(OrderSymbol() == Symbol() && OrderMagicNumber() != MagicNumber))
         return(true);   
      }
   }
   return(false);
}

//------------------------------------------------------------------------------------------------  
int TradeWait(){
   int wait=0;
   int total=OrdersTotal();

      for (int i = total - 1; i >= 0; i --)
      {
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if(OrderMagicNumber() == MagicNumber && OrderSymbol()==Symbol())
         {
            if(OrderOpenTime() + (TradeWaitTime*60) > TimeCurrent()) wait=1;
         }
      }
   return (wait);
}
//------------------------------------------------------------------------------------------------  
int CycleWait(){
   int wait=0;
   int total=OrdersHistoryTotal();

      for (int i = total - 1; i >= 0; i --)
      {
         OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderMagicNumber() == MagicNumber && OrderSymbol()==Symbol())
         {
            if(OrderCloseTime() + (CycleWaitTime*60) > TimeCurrent()) wait=1;
         }
      }
   return (wait);
}
//------------------------------------------------------------------------------------------------
void TrailingStop()
{
if(TSstep<1) TSstep=1;
   RefreshRates();
    for(int i=0;i<OrdersTotal();i++)
    {
       OrderSelect(i, SELECT_BY_POS,MODE_TRADES);
       if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
       {
         if(OrderType() == OP_BUY)
         {
            if(Bid-OrderOpenPrice()>Point*TrailingStop && (OrderStopLoss()+(Point*TSstep)<Bid-(Point*TrailingStop)||OrderStopLoss()==0))
               OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(Point*TrailingStop),OrderTakeProfit(),0,Blue);
         }
         else if(OrderType() == OP_SELL)
         { 
            if(OrderOpenPrice()-Ask>Point*TrailingStop && (OrderStopLoss()-(Point*TSstep)>Ask+(Point*TrailingStop)||OrderStopLoss()==0))
               OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(Point*TrailingStop),OrderTakeProfit(),0,Red);
         }
       }
    }
    return;
}
//-----------------------------------------END-----------------------------------------------------