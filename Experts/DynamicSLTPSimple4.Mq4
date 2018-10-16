
#property copyright "Vicky - Mumbai - India. "
#property link      "Vicky - Mumbai - India. "
extern   double      Slippage                         =  0.0001;
extern   double      StopLossPips                     =  0.0001;
extern   double      TakeProfitPips                   =  0.0001;
extern   bool        UseTrailingStop                  =  True;
extern   double      ActivateTrailAfterProfitPips     =  0.00001;
extern   double      TrailingStopPips                 =  0.0001;
         double       158651616521474836452710 ;
         double       1953697357214748364226647 ;
         double       3650920921474836448123 ;
         double       406173678214748364124811 ;
         double       418123549214748364333873 ;
         double       168987184214748364045461 ;
         int          16740031492147483636239 ;
         int          1471260852214748363448298 ;
         int          34356336321474836371433 ;
         int          1620587271214748363534285 ;
         int          162869401421474836313991 ;
         int          111886897921474836337640 ;
         int          1279871946214748363245779 ;
         int          14686054214748363850515 ;
int init()
{
   return(0);
}
int deinit()
{
   ObjectsDeleteAll();
   return(0);
}
int start()
{
    162869401421474836313991   =  0;
    16740031492147483636239   =  0;
    1471260852214748363448298   =  0;
   for ( 111886897921474836337640  = 0;  111886897921474836337640  < OrdersTotal();  111886897921474836337640  ++)
   {
      OrderSelect( 111886897921474836337640 , SELECT_BY_POS);
      if (OrderSymbol() == Symbol())
      {
          162869401421474836313991   =  162869401421474836313991  + 1;
         if (OrderType() == OP_BUY)
         {
             16740031492147483636239   =  16740031492147483636239  + 1;
             34356336321474836371433   = OrderTicket();
         }
         if (OrderType() == OP_SELL)
         {
             1471260852214748363448298   =  1471260852214748363448298  + 1;
             1620587271214748363534285   = OrderTicket();
         }
      }
   }
   if ( 16740031492147483636239  == 1 && UseTrailingStop == True && TrailingStopPips > 0 &&  158651616521474836452710  > 0)
   {
      OrderSelect( 34356336321474836371433 , SELECT_BY_TICKET);
      if (OrderProfit() > 0 )
      {
         if (Bid - OrderOpenPrice() > ActivateTrailAfterProfitPips)
         {
            if ( 158651616521474836452710  < Bid - TrailingStopPips ||  158651616521474836452710  == 0)
            {
                158651616521474836452710  = Bid - TrailingStopPips;
            }
         }
      }
   }
   if ( 1471260852214748363448298  == 1 && UseTrailingStop == True && TrailingStopPips > 0 &&  1953697357214748364226647  > 0)
   {
      OrderSelect( 1620587271214748363534285 , SELECT_BY_TICKET);
      if (OrderProfit() > 0 )
      {
         if (OrderOpenPrice() - Ask > ActivateTrailAfterProfitPips)
         {
            if ( 1953697357214748364226647  > Ask + TrailingStopPips ||  1953697357214748364226647  == 0)
            {
                1953697357214748364226647  = Ask + TrailingStopPips;
            }
         }
      }
   }
   if ( 16740031492147483636239  == 1 &&  158651616521474836452710  > 0)
   {
      OrderSelect( 34356336321474836371433 , SELECT_BY_TICKET);
      if (Bid <  158651616521474836452710 )
      {
         RefreshRates();
         OrderClose(OrderTicket(),OrderLots(),Bid,Slippage/Point,DodgerBlue);
      }
   }
   if ( 1471260852214748363448298  == 1 &&  1953697357214748364226647  > 0)
   {
      OrderSelect( 1620587271214748363534285 , SELECT_BY_TICKET);
      if (Ask >  1953697357214748364226647 )
      {
         RefreshRates();
         OrderClose(OrderTicket(),OrderLots(),Ask,Slippage/Point,OrangeRed);
      }
   }
   if ( 16740031492147483636239  == 1 &&  3650920921474836448123  > 0)
   {
      OrderSelect( 34356336321474836371433 , SELECT_BY_TICKET);
      if (Bid >  3650920921474836448123 )
      {
         RefreshRates();
         OrderClose(OrderTicket(),OrderLots(),Bid,Slippage/Point,DodgerBlue);
      }
   }
   if ( 1471260852214748363448298  == 1 &&  406173678214748364124811  > 0)
   {
      OrderSelect( 1620587271214748363534285 , SELECT_BY_TICKET);
      if (Ask <  406173678214748364124811 )
      {
         RefreshRates();
         OrderClose(OrderTicket(),OrderLots(),Ask,Slippage/Point,OrangeRed);
      }
   }
   if ( 16740031492147483636239  == 1 &&  158651616521474836452710  == 0)
   {
      OrderSelect( 34356336321474836371433 , SELECT_BY_TICKET);
       158651616521474836452710  = OrderOpenPrice() - StopLossPips;
   }
   if ( 1471260852214748363448298  == 1 &&  1953697357214748364226647  == 0)
   {
      OrderSelect( 1620587271214748363534285 , SELECT_BY_TICKET);
       1953697357214748364226647  = OrderOpenPrice() + StopLossPips;
   }
   if ( 16740031492147483636239  == 1 &&  3650920921474836448123  == 0)
   {
      OrderSelect( 34356336321474836371433 , SELECT_BY_TICKET);
       3650920921474836448123  = OrderOpenPrice() + TakeProfitPips;
   }
   if ( 1471260852214748363448298  == 1 &&  406173678214748364124811  == 0)
   {
      OrderSelect( 1620587271214748363534285 , SELECT_BY_TICKET);
       406173678214748364124811  = OrderOpenPrice() - TakeProfitPips;
   }
   if ( 16740031492147483636239  == 1 &&  158651616521474836452710   > 0)
   {
       1596751872214748364643597 ("BuySL", 158651616521474836452710 ,DodgerBlue,1,STYLE_SOLID);
   }
   if ( 1471260852214748363448298  == 1 &&  1953697357214748364226647  > 0)
   {
       1596751872214748364643597 ("SellSL", 1953697357214748364226647 ,OrangeRed,1,STYLE_SOLID);
   }
   if ( 16740031492147483636239  == 1 &&  3650920921474836448123   > 0)
   {
       1596751872214748364643597 ("BuyTP", 3650920921474836448123 ,DodgerBlue,1,STYLE_DOT);
   }
   if ( 1471260852214748363448298  == 1 &&  406173678214748364124811  > 0)
   {
       1596751872214748364643597 ("SellTP", 406173678214748364124811 ,OrangeRed,1,STYLE_DOT);
   }
   if ( 16740031492147483636239  == 0)
   {
       158651616521474836452710  = 0;
       3650920921474836448123  = 0;
      ObjectDelete("BuySL");
      ObjectDelete("BuyTP");
      WindowRedraw();
      for ( 14686054214748363850515  = ObjectsTotal()-1;  14686054214748363850515  >= 0 ;  14686054214748363850515  --)
      {
         if (ObjectType(ObjectName( 14686054214748363850515 ))  == OBJ_TREND ||   ObjectType(ObjectName( 14686054214748363850515 ))  == OBJ_ARROW)
         {
            if (ObjectGet(ObjectName( 14686054214748363850515 ), OBJPROP_COLOR) == Blue || ObjectGet(ObjectName( 14686054214748363850515 ), OBJPROP_COLOR) == DodgerBlue )
            {
               ObjectDelete(ObjectName( 14686054214748363850515 ));
            }
         }
      }
      WindowRedraw();
   }
   if ( 1471260852214748363448298  == 0)
   {
       1953697357214748364226647  = 0;
       406173678214748364124811  = 0;
      ObjectDelete("SellSL");
      ObjectDelete("SellTP");
      WindowRedraw();
      for ( 14686054214748363850515  = ObjectsTotal()-1;  14686054214748363850515  >= 0 ;  14686054214748363850515  --)
      {
         if (ObjectType(ObjectName( 14686054214748363850515 ))  == OBJ_TREND ||   ObjectType(ObjectName( 14686054214748363850515 ))  == OBJ_ARROW)
         {
            if (ObjectGet(ObjectName( 14686054214748363850515 ), OBJPROP_COLOR) == Red || ObjectGet(ObjectName( 14686054214748363850515 ), OBJPROP_COLOR) == OrangeRed )
            {
               ObjectDelete(ObjectName( 14686054214748363850515 ));
            }
         }
      }
      WindowRedraw();
   }
   if ( 16740031492147483636239  > 1 ||  1471260852214748363448298  > 1)
   {
      Alert("More than One Buy or One Sell Order available in the same pair. Please check it. DynamicSL Closing.");
      return(0);
   }
}
void  1596751872214748364643597 (string  1216626379214748363913795  , double  127059777421474836305133  , color  2114319876214748364748749 , int  874297887214748362842826 , int  1970013357214748362911122 )
{
   if(ObjectFind( 1216626379214748363913795 )==-1)
   {
      ObjectCreate( 1216626379214748363913795 ,OBJ_HLINE,0,0, 127059777421474836305133 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_COLOR, 2114319876214748364748749 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_STYLE, 1970013357214748362911122 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_WIDTH, 874297887214748362842826 );
      WindowRedraw();
   }else
   {
      ObjectSet( 1216626379214748363913795 ,OBJPROP_TIME1,0);
      ObjectSet( 1216626379214748363913795 ,OBJPROP_PRICE1, 127059777421474836305133 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_COLOR, 2114319876214748364748749 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_STYLE, 1970013357214748362911122 );
      ObjectSet( 1216626379214748363913795 ,OBJPROP_WIDTH, 874297887214748362842826 );
      WindowRedraw();
   }
}
