// _advanced expert advisor template.mq4
// Copyright © 2009, TradingSystemForex
// http://www.tradingsystemforex.com/

#property copyright "Copyright © 2009, TradingSystemForex"
#property link "http://www.tradingsystemforex.com/"

extern string comment="";                // comment to display in the order
extern int magic=1234;                   // magic number required if you use different settings on a same pair, same timeframe
extern int magic2=4321;

extern string moneymanagement="Money Management";

extern double lots=0.1;                  // lots size
extern bool lotsoptimized=false;         // enable risk management
extern double risk=1;                    // risk in percentage of the account
extern bool martingale=false;            // enable the martingale
extern double multiplier=2.0;            // multiplier used for the martingale
extern double minlot=0.01;               // minimum lot allowed by the expert
extern double maxlot=10;                 // maximum lot allowed by the expert
extern double lotdigits=2;               // 1 for minilot, 2 for microlot
extern bool basketpercent=false;         // enable the basket percent
extern double profit=10;                 // close all orders if a profit of 10 percents has been reached
extern double loss=30;                   // close all orders if a loss of 30 percents has been reached

extern string ordersmanagement="Order Management";

extern bool oppositeclose=false;          // close the orders on an opposite signal
extern bool reversesignals=false;        // reverse the signals, long if short, short if long
extern int maxtrades=99;                // maximum trades allowed by the traders
extern int tradesperbar=1;               // maximum trades per bar allowed by the expert
extern bool hidestop=false;              // hide stop loss
extern bool hidetarget=false;            // hide take profit
extern int buystop=50;                    // buy stop loss
extern int buytarget=0;                  // buy take profit
extern int sellstop=50;                   // sell stop loss
extern int selltarget=0;                 // buy take profit
extern int trailingstart=0;              // profit in pips required to enable the trailing stop
extern int trailingstop=0;               // trailing stop
extern int trailingstep=1;               // margin allowed to the market to enable the trailing stop
extern int breakevengain=0;              // gain in pips required to enable the break even
extern int breakeven=0;                  // break even
extern int expiration=240;                      // expiration in minutes for pending orders
extern int slippage=5;                   // maximum difference in pips between signal and order
extern double maxspread=20;              // maximum spread allowed by the expert

extern string entrylogics="Entry Logics";

extern int steps=20;
extern int grids=1;
extern bool usemttrendline=true;
extern int High_period=70;
extern int Low_period=21;
extern int Trigger_Sens=2;
extern bool usez1=true;
extern bool usez1asfilter=false;
extern int ExtDepth=25;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
extern int barn=1500;
extern int from=0;
extern int shift=1;                      // bar in the past to take in consideration for the signal

extern string timefilter="Time Filter";

extern int gmtshift=2;                   // gmt offset of the broker
extern bool filter=false;                // enable time filter
extern int start=7;                      // start to trade after this hour
extern int end=21;                       // stop to trade after this hour
extern bool tradesunday=true;            // trade on sunday
extern bool fridayfilter=false;          // enable special time filter on friday
extern int fridayend=24;                 // stop to trade after this hour

datetime t0,t1,lastbuyopentime,lastsellopentime;
double cb=0,lastbuyopenprice=0,lastsellopenprice=0;
double sl,tp,pt,mt,min,max,lastprofit;
int i,j,k,l,dg,bc=-1,tpb=0,tpb2=0,total,ticket;
int buyopenposition=0,sellopenposition=0;
int totalopenposition=0,buyorderprofit=0;
int sellorderprofit=0,cnt=0;
double lotsfactor=1,ilots;
double initiallotsfactor=1;
int istart,iend;

double instance=0;
double firstbar=0;
double firstbarvalue=0;

int init(){
   t0=Time[0];t1=Time[0];dg=Digits;
   if(dg==3 || dg==5){pt=Point*10;mt=10;}else{pt=Point;mt=1;}
   
   //|---------martingale initialization
   int tempfactor,total=OrdersTotal();
   if(tempfactor==0 && total>0){
      for(int cnt=0;cnt<total;cnt++){
         if(OrderSelect(cnt,SELECT_BY_POS)){
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2)){
               tempfactor=NormalizeDouble(OrderLots()/lots,1+(MarketInfo(Symbol(),MODE_MINLOT)==0.01));
               break;
            }
         }
      }
   }
   int histotal=OrdersHistoryTotal();
   if(tempfactor==0&&histotal>0){
      for(cnt=0;cnt<histotal;cnt++){
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY)){
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2)){
               tempfactor=NormalizeDouble(OrderLots()/lots,1+(MarketInfo(Symbol(),MODE_MINLOT)==0.01));
               break;
            }
         }
      }
   }
   if(tempfactor>0)
   lotsfactor=tempfactor;

   return(0);
}

int start(){

   /*Comment("\n Developed by WWW.TRADINGSYSTEMFOREX.COM");*/
   
   /*GlobalVariableSet("vGrafBalance",AccountBalance());
   GlobalVariableSet("vGrafEquity",AccountEquity());*/
   
   total=OrdersTotal();
   
   if(breakevengain>0){
      for(int b=0;b<total;b++){
         OrderSelect(b,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2)){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble((Bid-OrderOpenPrice()),dg)>=NormalizeDouble(breakevengain*pt,dg)){
                  if(NormalizeDouble((OrderStopLoss()-OrderOpenPrice()),dg)<NormalizeDouble(breakeven*pt,dg)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+breakeven*pt,dg),OrderTakeProfit(),0,Blue);
                     return(0);
                  }
               }
            }
            else{
               if(NormalizeDouble((OrderOpenPrice()-Ask),dg)>=NormalizeDouble(breakevengain*pt,dg)){
                  if(NormalizeDouble((OrderOpenPrice()-OrderStopLoss()),dg)<NormalizeDouble(breakeven*pt,dg)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-breakeven*pt,dg),OrderTakeProfit(),0,Red);
                     return(0);
                  }
               }
            }
         }
      }
   }
   if(trailingstop>0){
      for(int a=0;a<total;a++){
         OrderSelect(a,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2)){
            if(OrderType()==OP_BUY){
               if(NormalizeDouble(Ask,dg)>NormalizeDouble(OrderOpenPrice()+trailingstart*pt,dg)
               && (NormalizeDouble(OrderStopLoss(),dg)<NormalizeDouble(Bid-(trailingstop+trailingstep)*pt,dg))||(OrderStopLoss()==0)){
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-trailingstop*pt,dg),OrderTakeProfit(),0,Blue);
                  return(0);
               }
            }
            else{
               if(NormalizeDouble(Bid,dg)<NormalizeDouble(OrderOpenPrice()-trailingstart*pt,dg)
               && (NormalizeDouble(OrderStopLoss(),dg)>(NormalizeDouble(Ask+(trailingstop+trailingstep)*pt,dg)))||(OrderStopLoss()==0)){                 
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+trailingstop*pt,dg),OrderTakeProfit(),0,Red);
                  return(0);
               }
            }
         }
      }
   }
   if(basketpercent){
      double ipf=profit*(0.01*AccountBalance());double ilo=loss*(0.01*AccountBalance());
      cb=AccountEquity()-AccountBalance();
      if(cb>=ipf||cb<=(ilo*(-1))){
         for(i=total-1;i>=0;i--){
            OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_BUY){
               OrderClose(OrderTicket(),OrderLots(),Bid,slippage*pt);
            }
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_SELL){
               OrderClose(OrderTicket(),OrderLots(),Ask,slippage*pt);
            }
         }
         return(0);
      }
   }
   /*
   totalopenposition=0;
   buyopenposition=0;
   sellopenposition=0;
   
   for(cnt=0;cnt<total;cnt++){
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderCloseTime()==0){
         totalopenposition++;
         lastprofit=OrderProfit();
         if(OrderType()==OP_BUY){
            buyopenposition++;lastbuyopenprice=OrderOpenPrice();buyorderprofit=OrderProfit();lastbuyopentime=OrderOpenTime();
         }
         if(OrderType()==OP_SELL){
            sellopenposition++;lastsellopenprice=OrderOpenPrice();sellorderprofit=OrderProfit();lastsellopentime=OrderOpenTime();
         }
      }
   }*/
   
   //double ZZ=0;
   //int ZZbar=0;
   //for(cnt=1;cnt<500;cnt++){
   //   if(ZZ!=0)continue;
   //   if(iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,0,cnt)!=0){
   //   ZZ=iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,0,cnt);ZZbar=cnt;}
   //}
   //if(firstbar==0)firstbarvalue=ZZ;
   //if(firstbarvalue!=0)firstbar=1;
   
   double ZZ=0;
   int ZZbar=0;
   for(cnt=1;cnt<500;cnt++){
      if(ZZ!=0)continue;
      if(iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt)!=0){
      ZZ=iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt);ZZbar=cnt;}
   }
   if(firstbar==0)firstbarvalue=ZZ;
   if(firstbarvalue!=0)firstbar=1;
   
   int mtsignal=0;
   
   for(cnt=1;cnt<500;cnt++){
      if(mtsignal!=0)continue;
      if(iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt)!=0
      && iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt)<=Low[cnt]){mtsignal=1;}
      if(iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt)!=0
      && iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,cnt)>=High[cnt]){mtsignal=2;}
   }
   
   double z1=iCustom(Symbol(),0,"Z1",ExtDepth,ExtDeviation,ExtBackstep,barn,from,0,shift);
   
   //double mt=iCustom(Symbol(),0,"#MT TrendLine",High_period,Low_period,Trigger_Sens,1,shift);

   int z1signal=0;
   if(z1>0 && z1<=Low[shift])z1signal=1;
   if(z1>0 && z1>=High[shift])z1signal=2;

   bool openbuy=true;bool opensell=true;
   bool closebuy=false;bool closesell=false;

   //if()
   //{openbuy=false;opensell=false;}
   
   if(lotsoptimized && (martingale==false || (martingale && lastprofit>=0)))lots=NormalizeDouble((AccountBalance()/1000)*minlot*risk,lotdigits);
   if(lots<minlot)lots=minlot;if(lots>maxlot)lots=maxlot;
   
   if(tradesperbar==1 && (((TimeCurrent()-lastbuyopentime)<Period()) || ((TimeCurrent()-lastsellopentime)<Period()))){tpb=1;tpb2=1;}
   
   bool buy=false;bool sell=false;

   if(((usemttrendline && usez1asfilter==false && ZZ>0 && ZZ!=EMPTY_VALUE && ZZ<=Low[ZZbar] && ZZ!=instance && ZZ!=firstbarvalue)
   || (usemttrendline && usez1asfilter && mtsignal==1))
   && (usez1asfilter==false || (usez1asfilter && z1signal==1))
   && openbuy){if(reversesignals)sell=true;else buy=true;instance=ZZ;}
   
   if(((usemttrendline && usez1asfilter==false && ZZ>0 && ZZ!=EMPTY_VALUE && ZZ>=High[ZZbar] && ZZ!=instance && ZZ!=firstbarvalue)
   || (usemttrendline && usez1asfilter && mtsignal==2))
   && (usez1asfilter==false || (usez1asfilter && z1signal==2))
   && opensell){if(reversesignals)buy=true;else sell=true;instance=ZZ;}
   
   //if((usemttrendline==false || (usemttrendline && mt>0 && mt!=EMPTY_VALUE && mt<(Close[1]+1*pt)))
   //&& (usez1asfilter==false && (usez1asfilter && z1>0 && z1!=EMPTY_VALUE && z1<(Close[1]+1*pt)))
   //&& openbuy){if(reversesignals)sell=true;else buy=true;}
   
   //if((usemttrendline==false || (usemttrendline && mt>0 && mt!=EMPTY_VALUE && mt>(Close[1]-1*pt)))
   //&& (usez1asfilter==false && (usez1asfilter && z1>0 && z1!=EMPTY_VALUE && z1>(Close[1]-1*pt)))
   //&& opensell){if(reversesignals)buy=true;else sell=true;}
   
   bool buy2=false;bool sell2=false;
   
   if(usez1 && z1signal==1
   && openbuy){if(reversesignals)sell2=true;else buy2=true;}
   
   if(usez1 && z1signal==2
   && openbuy){if(reversesignals)buy2=true;else sell2=true;}
   
   if(bc!=Bars){tpb=0;tpb2=0;bc=Bars;}
   //Comment("\nmtsignal  =  " + DoubleToStr(mtsignal,4),"\nz1signal  =  " + DoubleToStr(z1signal,4));

   if((oppositeclose && sell)||(closebuy)){
      for(i=total-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==OP_BUY){
            OrderClose(OrderTicket(),OrderLots(),Bid,slippage*pt);
         }
      }
   }
   if((oppositeclose && buy)||(closesell)){
      for(j=total-1;j>=0;j--){
         OrderSelect(j,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==OP_SELL){
            OrderClose(OrderTicket(),OrderLots(),Ask,slippage*pt);
         }
      }
   }
   if((oppositeclose && sell2)||(closebuy)){
      for(i=total-1;i>=0;i--){
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic2 && OrderType()==OP_BUY){
            OrderClose(OrderTicket(),OrderLots(),Bid,slippage*pt);
         }
      }
   }
   if((oppositeclose && buy2)||(closesell)){
      for(j=total-1;j>=0;j--){
         OrderSelect(j,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic2 && OrderType()==OP_SELL){
            OrderClose(OrderTicket(),OrderLots(),Ask,slippage*pt);
         }
      }
   }
   if(hidestop){
      for(k=total-1;k>=0;k--){
         OrderSelect(k,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_BUY && buystop>0 && Bid<(OrderOpenPrice()-buystop*pt)){
            OrderClose(OrderTicket(),OrderLots(),Bid,slippage*pt);
         }
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_SELL && sellstop>0 && Ask>(OrderOpenPrice()+sellstop*pt)){
            OrderClose(OrderTicket(),OrderLots(),Ask,slippage*pt);
         }
      }
   }
   if(hidetarget){
      for(l=total-1;l>=0;l--){
         OrderSelect(l,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_BUY && buytarget>0 && Bid>(OrderOpenPrice()+buytarget*pt)){
            OrderClose(OrderTicket(),OrderLots(),Bid,slippage*pt);
         }
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2) && OrderType()==OP_SELL && selltarget>0 && Ask<(OrderOpenPrice()-selltarget*pt)){
           OrderClose(OrderTicket(),OrderLots(),Ask,slippage*pt);
         }
      }
   }

   istart=start+(gmtshift);if(istart>23)istart=istart-24;
   iend=end+(gmtshift);if(iend>23)iend=iend-24;
   
   if((tradesunday==false&&DayOfWeek()==0)
   ||(filter&&DayOfWeek()>0&&
   (
   (istart<=iend && !(Hour()>=(istart)&&Hour()<=(iend)))||
   (istart>iend && !((Hour()>=(istart)&&Hour()<=23)||(Hour()>=0&&Hour()<=(iend))))))
   ||(fridayfilter&&DayOfWeek()==5&&!(Hour()<(fridayend+(gmtshift))))){
      return(0);
   }
   if((Ask-Bid)>maxspread*pt)return(0);
   
   int expire=0;
   if(expiration>0)expire=TimeCurrent()+(expiration*60)-5;
   
   int cpt=0;
   double InitialPrice=0;
   if((count(OP_BUY,magic)+count(OP_SELL,magic))<maxtrades){  
      if(buy && tpb<tradesperbar && IsTradeAllowed()){
         while(IsTradeContextBusy())Sleep(3000);
         //if(hidestop==false&&buystop>0){sl=Ask+distance*pt-buystop*pt;}else{sl=0;}
         //if(hidetarget==false&&buytarget>0){tp=Ask+distance*pt+buytarget*pt;}else{tp=0;}
         if(martingale)ilots=NormalizeDouble(lots*martingalefactor(),2);else ilots=lots;
         if(ilots<minlot)ilots=minlot;if(ilots>maxlot)ilots=maxlot;
         InitialPrice=Ask;
            for(cpt=1;cpt<=grids;cpt++){
               if(hidestop==false&&buystop>0){sl=InitialPrice+cpt*steps*pt-buystop*pt;}else{sl=0;}
               if(hidetarget==false&&buytarget>0){tp=InitialPrice+cpt*steps*pt+buytarget*pt;}else{tp=0;}
               RefreshRates();ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,InitialPrice+cpt*steps*pt,2,sl,tp,comment+". Magic: "+DoubleToStr(magic,0),magic,expire,Blue);
            }
         if(ticket<=0){Print("Error Occured : "+errordescription(GetLastError()));}
         else{tpb++;Print("Order opened : "+Symbol()+" Buy @ "+Ask+" SL @ "+sl+" TP @"+tp+" ticket ="+ticket);}
      }
      if(sell && tpb<tradesperbar && IsTradeAllowed()){
         while(IsTradeContextBusy())Sleep(3000);
         //if(hidestop==false&&sellstop>0){sl=Bid-distance*pt+sellstop*pt;}else{sl=0;}
         //if(hidetarget==false&&selltarget>0){tp=Bid-distance*pt-selltarget*pt;}else{tp=0;}
         if(martingale)ilots=NormalizeDouble(lots*martingalefactor(),2);else ilots=lots;
         if(ilots<minlot)ilots=minlot;if(ilots>maxlot)ilots=maxlot;
         InitialPrice=Bid;
            for(cpt=1;cpt<=grids;cpt++){
               if(hidestop==false&&sellstop>0){sl=InitialPrice-cpt*steps*pt+sellstop*pt;}else{sl=0;}
               if(hidetarget==false&&selltarget>0){tp=InitialPrice-cpt*steps*pt-selltarget*pt;}else{tp=0;}
               RefreshRates();ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,InitialPrice-cpt*steps*pt,2,sl,tp,comment+". Magic: "+DoubleToStr(magic,0),magic,expire,Red);
            }
         if(ticket<=0){Print("Error Occured : "+errordescription(GetLastError()));}
         else{tpb++;Print("Order opened : "+Symbol()+" Sell @ "+Bid+" SL @ "+sl+" TP @"+tp+" ticket ="+ticket);}
      }
   }
   
   
   cpt=0;
   InitialPrice=0;
   //if((count(OP_BUY,magic2)+count(OP_SELL,magic2))<maxtrades){  
      if(buy2 && tpb2<tradesperbar && IsTradeAllowed() && count(OP_BUYSTOP,magic2)<maxtrades){
         while(IsTradeContextBusy())Sleep(3000);
         //if(hidestop==false&&buystop>0){sl=Ask+distance*pt-buystop*pt;}else{sl=0;}
         //if(hidetarget==false&&buytarget>0){tp=Ask+distance*pt+buytarget*pt;}else{tp=0;}
         if(martingale)ilots=NormalizeDouble(lots*martingalefactor(),2);else ilots=lots;
         if(ilots<minlot)ilots=minlot;if(ilots>maxlot)ilots=maxlot;
         InitialPrice=Ask;
            for(cpt=1;cpt<=grids;cpt++){
               if(hidestop==false&&buystop>0){sl=InitialPrice+cpt*steps*pt-buystop*pt;}else{sl=0;}
               if(hidetarget==false&&buytarget>0){tp=InitialPrice+cpt*steps*pt+buytarget*pt;}else{tp=0;}
               RefreshRates();ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,InitialPrice+cpt*steps*pt,2,sl,tp,comment+". Magic: "+DoubleToStr(magic2,0),magic2,expire,Blue);
            }
         if(ticket<=0){Print("Error Occured : "+errordescription(GetLastError()));}
         else{tpb2++;Print("Order opened : "+Symbol()+" Buy @ "+Ask+" SL @ "+sl+" TP @"+tp+" ticket ="+ticket);}
      }
      if(sell2 && tpb2<tradesperbar && IsTradeAllowed() && count(OP_SELLSTOP,magic2)<maxtrades){
         while(IsTradeContextBusy())Sleep(3000);
         //if(hidestop==false&&sellstop>0){sl=Bid-distance*pt+sellstop*pt;}else{sl=0;}
         //if(hidetarget==false&&selltarget>0){tp=Bid-distance*pt-selltarget*pt;}else{tp=0;}
         if(martingale)ilots=NormalizeDouble(lots*martingalefactor(),2);else ilots=lots;
         if(ilots<minlot)ilots=minlot;if(ilots>maxlot)ilots=maxlot;
         InitialPrice=Bid;
            for(cpt=1;cpt<=grids;cpt++){
               if(hidestop==false&&sellstop>0){sl=InitialPrice-cpt*steps*pt+sellstop*pt;}else{sl=0;}
               if(hidetarget==false&&selltarget>0){tp=InitialPrice-cpt*steps*pt-selltarget*pt;}else{tp=0;}
               RefreshRates();ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,InitialPrice-cpt*steps*pt,2,sl,tp,comment+". Magic: "+DoubleToStr(magic2,0),magic2,expire,Red);
            }
         if(ticket<=0){Print("Error Occured : "+errordescription(GetLastError()));}
         else{tpb2++;Print("Order opened : "+Symbol()+" Sell @ "+Bid+" SL @ "+sl+" TP @"+tp+" ticket ="+ticket);}
      }
   //}
   
   return(0);
}

int count(int type,int magic){
   int cnt;cnt=0;
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderType()==type && ((OrderMagicNumber()==magic)||magic==0)){
         cnt++;
      }
   }
   return(cnt);
}

//|---------martingale

int martingalefactor(){
   int histotal=OrdersHistoryTotal();
   if (histotal>0){
      for(int cnt=histotal-1;cnt>=0;cnt--){
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY)){
            if(OrderSymbol()==Symbol() && (OrderMagicNumber()==magic||OrderMagicNumber()==magic2)){
               if(OrderProfit()<0){
                  lotsfactor=lotsfactor*multiplier;
                  return(lotsfactor);
               }
               else{
                  lotsfactor=initiallotsfactor;
                  if(lotsfactor<=0){
                     lotsfactor=1;
                  }
                  return(lotsfactor);
               }
            }
         }
      }
   }
   return(lotsfactor);
}

string errordescription(int code){
   string error;
   switch(code){
      case 0:
      case 1:error="no error";break;
      case 2:error="common error";break;
      case 3:error="invalid trade parameters";break;
      case 4:error="trade server is busy";break;
      case 5:error="old version of the client terminal";break;
      case 6:error="no connection with trade server";break;
      case 7:error="not enough rights";break;
      case 8:error="too frequent requests";break;
      case 9:error="malfunctional trade operation";break;
      case 64:error="account disabled";break;
      case 65:error="invalid account";break;
      case 128:error="trade timeout";break;
      case 129:error="invalid price";break;
      case 130:error="invalid stops";break;
      case 131:error="invalid trade volume";break;
      case 132:error="market is closed";break;
      case 133:error="trade is disabled";break;
      case 134:error="not enough money";break;
      case 135:error="price changed";break;
      case 136:error="off quotes";break;
      case 137:error="broker is busy";break;
      case 138:error="requote";break;
      case 139:error="order is locked";break;
      case 140:error="long positions only allowed";break;
      case 141:error="too many requests";break;
      case 145:error="modification denied because order too close to market";break;
      case 146:error="trade context is busy";break;
      case 4000:error="no error";break;
      case 4001:error="wrong function pointer";break;
      case 4002:error="array index is out of range";break;
      case 4003:error="no memory for function call stack";break;
      case 4004:error="recursive stack overflow";break;
      case 4005:error="not enough stack for parameter";break;
      case 4006:error="no memory for parameter string";break;
      case 4007:error="no memory for temp string";break;
      case 4008:error="not initialized string";break;
      case 4009:error="not initialized string in array";break;
      case 4010:error="no memory for array\' string";break;
      case 4011:error="too long string";break;
      case 4012:error="remainder from zero divide";break;
      case 4013:error="zero divide";break;
      case 4014:error="unknown command";break;
      case 4015:error="wrong jump (never generated error)";break;
      case 4016:error="not initialized array";break;
      case 4017:error="dll calls are not allowed";break;
      case 4018:error="cannot load library";break;
      case 4019:error="cannot call function";break;
      case 4020:error="expert function calls are not allowed";break;
      case 4021:error="not enough memory for temp string returned from function";break;
      case 4022:error="system is busy (never generated error)";break;
      case 4050:error="invalid function parameters count";break;
      case 4051:error="invalid function parameter value";break;
      case 4052:error="string function internal error";break;
      case 4053:error="some array error";break;
      case 4054:error="incorrect series array using";break;
      case 4055:error="custom indicator error";break;
      case 4056:error="arrays are incompatible";break;
      case 4057:error="global variables processing error";break;
      case 4058:error="global variable not found";break;
      case 4059:error="function is not allowed in testing mode";break;
      case 4060:error="function is not confirmed";break;
      case 4061:error="send mail error";break;
      case 4062:error="string parameter expected";break;
      case 4063:error="integer parameter expected";break;
      case 4064:error="double parameter expected";break;
      case 4065:error="array as parameter expected";break;
      case 4066:error="requested history data in update state";break;
      case 4099:error="end of file";break;
      case 4100:error="some file error";break;
      case 4101:error="wrong file name";break;
      case 4102:error="too many opened files";break;
      case 4103:error="cannot open file";break;
      case 4104:error="incompatible access to a file";break;
      case 4105:error="no order selected";break;
      case 4106:error="unknown symbol";break;
      case 4107:error="invalid price parameter for trade function";break;
      case 4108:error="invalid ticket";break;
      case 4109:error="trade is not allowed";break;
      case 4110:error="longs are not allowed";break;
      case 4111:error="shorts are not allowed";break;
      case 4200:error="object is already exist";break;
      case 4201:error="unknown object property";break;
      case 4202:error="object is not exist";break;
      case 4203:error="unknown object type";break;
      case 4204:error="no object name";break;
      case 4205:error="object coordinates error";break;
      case 4206:error="no specified subwindow";break;
      default:error="unknown error";
   }
   return(error);
}  