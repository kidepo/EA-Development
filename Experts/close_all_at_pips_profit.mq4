//------------------------------------------------------------------
//
//------------------------------------------------------------------
extern double CloseAtPipsProfit = 0;
extern bool   AllSymbols        = true;

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()
{
   return(0);
}

//
//
//
//
//

int start()
{
   if (CloseAtPipsProfit<=0) return(0);
   
   //
   //
   //
   //
   //
   
   int total  = OrdersTotal();

      for (int i = total-1; i>=0 ; i--)
      {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if (!AllSymbols && OrderSymbol()!=Symbol())      continue;
         if (OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;
      
         //
         //
         //
         //
         //
         
         double currentProfit = (OrderProfit()+OrderSwap()+OrderCommission())/MarketInfo(OrderSymbol(),MODE_TICKVALUE);
            if (MarketInfo(OrderSymbol(),MODE_DIGITS)==3 || MarketInfo(OrderSymbol(),MODE_DIGITS)==5)  currentProfit /= 10.0;
            
            //
            //
            //
            //
            //
      
            int ticket = OrderTicket();
               if (currentProfit >= CloseAtPipsProfit)
               for (int k=0; k<3; k++)
               {
                  RefreshRates();
                     double closePrice = MarketInfo(OrderSymbol(),MODE_ASK); if (OrderType()==OP_BUY) closePrice=MarketInfo(OrderSymbol(),MODE_BID);
                     if (OrderClose(ticket,OrderLots(),closePrice,0)) break;
               }
      }
   return(0);        
}