
#property copyright "FX_Nostradamus"
#property link      "FX_Nostradamus"

#include <WinUser32.mqh>

#import "shell32.dll"
   int ShellExecuteA(int a0, string a1, string a2, string a3, string a4, int a5);
#import

extern int TakeProfit = 10;
extern int StopLoss = 10;
extern int MagicNumber = D'14.02.2009 00:31:30';
extern int PipStep = 6;
extern int MaxOrders = 10;
extern int TrailingStop = 30;
extern int TimeToWait = 12;
extern double Lots = 0.6;
extern bool UseRiskPercent = TRUE;
extern double RiskPercent = 1.0;
extern double MaxOrderLot = 0.0;
double gda_132[50];
int gia_136[50];
bool gi_140 = TRUE;
double gd_144 = 40.0;
int g_slippage_152 = 3;
bool gi_156 = TRUE;
int gi_160 = -1;
int gi_164;
string gs_unused_168 = "";
double gd_176;
bool gi_184 = FALSE;

int init() 
{
   bool li_0;
   int mb_code_4;
   gi_164 = MarketInfo(Symbol(), MODE_STOPLEVEL);
   if (gi_164 > TrailingStop && TrailingStop != 0) TrailingStop = gi_164;
   gd_176 = f0_1();
   return (0);
}



int deinit() 
{
   return (0);
}

int start() 
{
   string str_concat_0;
   int li_8;
   string ls_unused_12;
   string ls_unused_20;
   string ls_unused_28;
   Comment("Советник FX_Nostradamus успешно запущен и сейчас работает");
   f0_7(gia_136);
   gia_136[0] = TimeCurrent();
   f0_4(gia_136);
   int li_36 = f0_9(gia_136);
   f0_14(gda_132);
   gda_132[0] = Bid;
   if (TrailingStop != 0) f0_11();
   if (Ask - Bid > gd_144 * gd_176) return (0);
   if (f0_13() < MaxOrders) f0_2(gda_132, PipStep, li_36);
   return (0);
}

double f0_1(string a_symbol_0 = "0") 
{
   if (a_symbol_0 == "0") a_symbol_0 = Symbol();
   int digits_8 = MarketInfo(a_symbol_0, MODE_DIGITS);
   double ld_ret_12 = 0.0;
   double ld_20 = MarketInfo(a_symbol_0, MODE_POINT);
   if (digits_8 == 5 || digits_8 == 3) ld_ret_12 = 10.0 * ld_20;
   else ld_ret_12 = ld_20;
   return (ld_ret_12);
}

void f0_11() 
{
   double ld_0;
   int li_8 = TrailingStop;
   for (int pos_12 = 0; pos_12 < OrdersTotal(); pos_12++) 
   {
      if (OrderSelect(pos_12, SELECT_BY_POS) != FALSE) 
      {
         if (OrderSymbol() == Symbol()) 
         {
            if (OrderMagicNumber() >= MagicNumber && OrderMagicNumber() <= MagicNumber) 
            {
               if (OrderType() == OP_BUY) 
               {
                  ld_0 = Bid - gd_176 * li_8;
                  if (!(OrderStopLoss() < ld_0 && OrderOpenPrice() < Bid - li_8 * gd_176)) continue;
                  f0_8(ld_0, OrderTicket());
                  continue;
               }
               ld_0 = Ask + gd_176 * li_8;
               if (OrderStopLoss() > ld_0 && OrderOpenPrice() > Ask + li_8 * gd_176) f0_8(ld_0, OrderTicket());
            }
         }
      }
   }
}

void f0_8(double a_price_0, int a_ticket_8) 
{
   gi_164 = MarketInfo(Symbol(), MODE_STOPLEVEL);
   if (OrderModify(a_ticket_8, OrderOpenPrice(), a_price_0, OrderTakeProfit(), 0, Red) == -1)
      if (gi_156) f0_10();
}

void f0_4(int &aia_0[50]) 
{
   int arr_size_4 = ArraySize(aia_0);
   int li_8 = TimeCurrent() - (aia_0[f0_9(aia_0) - 1]);
   while (li_8 > TimeToWait) 
   {
      aia_0[f0_9(aia_0) - 1] = 0;
      li_8 = TimeCurrent() - (aia_0[f0_9(aia_0) - 1]);
      if (f0_9(aia_0) < 2) break;
   }
}

int f0_9(int aia_0[50]) 
{
   int arr_size_4 = ArraySize(aia_0);
   for (int index_8 = 0; index_8 < arr_size_4; index_8++)
      if (!(aia_0[index_8] > 0)) return (index_8);
   return (arr_size_4 - 1);
}

void f0_14(double &ada_0[50]) 
{
   int li_4 = ArraySize(ada_0);
   for (int li_8 = li_4; li_8 > 0; li_8--) ada_0[li_8] = ada_0[li_8 - 1];
   ada_0[0] = 0;
}

void f0_7(int &aia_0[50]) 
{
   int li_4 = ArraySize(aia_0);
   for (int li_8 = li_4; li_8 > 0; li_8--) aia_0[li_8] = aia_0[li_8 - 1];
   aia_0[0] = 0;
}

void f0_2(double ada_0[50], int ai_4, int ai_8) 
{
   double lots_12;
   double ld_20 = ada_0[ArrayMaximum(ada_0, ai_8)] - ada_0[ArrayMinimum(ada_0, ai_8)];
   if (ld_20 > ai_4 * gd_176) {
      if (UseRiskPercent) lots_12 = f0_3();
      else lots_12 = Lots;
      if (Bid == ada_0[ArrayMaximum(ada_0, ai_8)]) f0_0(TakeProfit, StopLoss, lots_12, OP_BUY);
      if (Bid == ada_0[ArrayMinimum(ada_0, ai_8)]) f0_0(TakeProfit, StopLoss, lots_12, OP_SELL);
   }
}

int f0_13() 
{
   int li_ret_0;
   for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) 
   {
      if (OrderSelect(pos_4, SELECT_BY_POS) != FALSE) 
      {
         if (OrderSymbol() == Symbol())
            if (OrderMagicNumber() >= MagicNumber && OrderMagicNumber() <= MagicNumber) li_ret_0++;
      }
   }
   return (li_ret_0);
}

int f0_0(int ai_0, int ai_4, double a_lots_8, int a_cmd_16, int ai_20 = 0) 
{
   int li_24;
   double price_28;
   double price_36;
   double price_44;
   color color_52;
   string ls_56 = "FX_Nostradamus";
   if (a_cmd_16 % 2 == 0) 
   {
      if (a_cmd_16 == OP_BUYLIMIT) price_28 = Ask + li_24 * gd_176;
      else price_28 = Ask + li_24 * gd_176;
      if (ai_4 != 0) price_36 = price_28 - (ai_4 + li_24) * gd_176;
      if (ai_0 != 0) price_44 = price_28 + (ai_0 + li_24) * gd_176;
      color_52 = CLR_NONE;
   }
   if (a_cmd_16 % 2 == 1) 
   {
      if (a_cmd_16 == OP_SELLLIMIT) price_28 = Bid + li_24 * gd_176;
      else price_28 = Bid + li_24 * gd_176;
      if (ai_4 != 0) price_36 = price_28 - ((-ai_4) - li_24) * gd_176;
      if (ai_0 != 0) price_44 = price_28 - (ai_0 - li_24) * gd_176;
      color_52 = CLR_NONE;
   }
   double price_64 = price_36;
   double price_72 = price_44;
   if (gi_140) price_36 = 0;
   if (gi_140) price_44 = 0;
   int ticket_80 = OrderSend(Symbol(), a_cmd_16, a_lots_8, price_28, g_slippage_152, price_36, price_44, ls_56 + "-" + Symbol() + "-" + MagicNumber, MagicNumber + ai_20, 0, color_52);
   bool bool_84 = OrderSelect(ticket_80, SELECT_BY_TICKET);
   if (bool_84 == TRUE) OrderModify(OrderTicket(), OrderOpenPrice(), price_64, price_72, 0, Blue);
   return (0);
}

double f0_3() 
{
   double ld_0 = Lots;
   if (UseRiskPercent) ld_0 = f0_12(MathAbs(RiskPercent));
   if (ld_0 > MaxOrderLot && MaxOrderLot != 0.0) ld_0 = MaxOrderLot;
   ld_0 = f0_6(ld_0);
   return (ld_0);
}

double f0_12(double ad_0) 
{
   bool li_8 = TRUE;
   double minlot_12 = MarketInfo(Symbol(), MODE_MINLOT);
   double ld_20 = MarketInfo(Symbol(), MODE_LOTSIZE) / AccountLeverage();
   double ld_28 = ad_0 / 100.0 * AccountBalance() / ld_20;
   double ld_ret_36 = MathFloor(ld_28);
   while (li_8) 
   {
      ld_ret_36 += minlot_12;
      if (ld_ret_36 > ld_28) 
      {
         li_8 = FALSE;
         ld_ret_36 -= minlot_12;
      }
   }
   return (ld_ret_36);
}

double f0_6(double ad_0) 
{
   if (ad_0 > MarketInfo(Symbol(), MODE_MAXLOT)) ad_0 = MarketInfo(Symbol(), MODE_MAXLOT);
   else
      if (ad_0 < MarketInfo(Symbol(), MODE_MINLOT)) ad_0 = MarketInfo(Symbol(), MODE_MINLOT);
   return (ad_0);
}

void f0_10() 
{
   string ls_0;
   if (gi_156) 
   {
      if (gi_160 > 0) 
      {
         ls_0 = "Error:" + GetLastError() + " OrderType:" + OrderType() + " Ticket:" + OrderTicket();
         ls_0 = TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS) + " " + ls_0;
         FileWrite(gi_160, ls_0);
      }
   }
}