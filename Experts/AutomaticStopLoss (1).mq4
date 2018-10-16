//+------------------------------------------------------------------+
//|                                            AutomaticStopLoss.mq4 |
//|                                     Ivan @ forexfctory.com forum |
//|
//+------------------------------------------------------------------+
#property copyright "Ivan @ forexfactory.com forum "
#property link      ""

extern int StopLoss = 10, TakeProfit = 25;

int init()
  {
  if(Digits == 5 || Digits ==3)
  {
  StopLoss=StopLoss*10;
  TakeProfit=TakeProfit*10;
  }
   return(0);
  }
int deinit()
  {
   return(0);
  }
int start()
  {
  static bool OneTimeModify= true;
  if(OneTimeModify)
    for(int a=0;a<OrdersTotal();a++)
      if(OrderSelect(a,0,0))
        if(OrderSymbol()==Symbol())
        {
          if(OrderType()==OP_BUY)
            OrderModify(OrderTicket(),OrderOpenPrice(),Bid-StopLoss*Point,Ask+TakeProfit*Point,0,Green);
          if(OrderType() == OP_SELL)
            OrderModify(OrderTicket(),OrderOpenPrice(),Ask+StopLoss*Point,Bid-TakeProfit*Point,0,Green);
            OneTimeModify=false;
        }
    
   Comment("\n","  Your stop loss is ", StopLoss,"\n","  Your take profit is ", TakeProfit); 
   return(0);
  }
//+------------------------------------------------------------------+