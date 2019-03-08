//+------------------------------------------------------------------+
//|                                             mn CloseAtProfit.mq4 |
//+------------------------------------------------------------------+
#property copyright "mn"
#include <stdlib.mqh>
#include <stderror.mqh>

extern double mTargetProf = 100.0;
extern int    mMagicN     = 123,
              mMagicN2    = 0;

//+------------------------------------------------------------------+
int OnInit()
  {

   return(0);
  }

//+------------------------------------------------------------------+
void deinit()
  {
   
   return;
  }

//+------------------------------------------------------------------+
int Start()
  {
    CheckProfit();

    return(0);
  }

//+------------------------------------------------------------------+
void CheckProfit()
 {
   int k, mOrdTotal;
   double mProf = 0, mAllPips = 0;
   bool mCheck = true;
   mOrdTotal = OrdersTotal();
      
   for(k = mOrdTotal - 1; k >= 0; k--)   
    {
      mCheck = OrderSelect(k, SELECT_BY_POS, MODE_TRADES);
      if((OrderType() == OP_BUY || OrderType() == OP_SELL) && 
         (OrderMagicNumber() == mMagicN || OrderMagicNumber() == mMagicN2))
        {
          mProf += (OrderProfit() + OrderCommission() + OrderSwap());
        }
    }   // for k

   if(mProf >= mTargetProf)   
     { 
        Alert("Closing trades for $ ", mProf);
        CloseAll();
     }
   
   return;
 }
 
//+------------------------------------------------------------------+
void CloseAll()
 {
   int z, mOrdTotal, mErr, mTkt, mErrors;
   bool mOS;
   mOrdTotal = OrdersTotal();
   for(z = mOrdTotal - 1; z >= 0; z--)
    {
      mOS = OrderSelect(z, SELECT_BY_POS);
      
      if(mOS && (OrderMagicNumber() == mMagicN || OrderMagicNumber() == mMagicN2))
        {
         if(OrderType() == OP_BUY)
           {
              mTkt = OrderTicket();
              mErr = OrderClose(mTkt, OrderLots(), Bid, 0, CLR_NONE);
           }
         
         else if(OrderType() == OP_SELL)
            {
              mTkt = OrderTicket();
              mErr = OrderClose(mTkt, OrderLots(), Ask, 0, CLR_NONE);
            }
        }

      if(mErr != true) 
       { 
        mErrors = GetLastError(); 
        Print(Symbol(), " LastError in Close = ", ErrorDescription(mErrors)); 
       }
    } // for z
    
   return;
 }
 
 //+-------------------------------------------------------------------------------------------+  
