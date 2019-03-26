#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DarkTurquoise
#property indicator_color2 Orange
#property indicator_color3 Red

int G_width_76 = 3;
extern int SignalPeriod = 29;
int Gi_84 = 0;
int G_ma_method_88 = MODE_LWMA;
int G_applied_price_92 = PRICE_CLOSE;
double Gd_96 = 1.8;
bool Gi_104 = TRUE;
int Gi_108 = 0;
int Gi_112 = 10000;
bool Gi_116 = FALSE;
extern int aTake_Profit = 150;
extern int aStop_Loss = 150;
extern bool aAlerts = TRUE;
extern bool EmailOn = TRUE;
datetime G_time_136;
string Gs_148;
string Gs_156 = "Super Trend Profit";
double G_ibuf_164[];
double G_ibuf_168[];
double G_ibuf_172[];
double G_ibuf_176[];
int Gi_180;
string Gs_184;
int Gi_unused_192 = 0;
string G_name_196 = "informerR";
string Gs_signall_204 = "signalL";
extern int SignalTextSize = 14;
extern int InformerTextSize = 14;
extern color BuySignalColor = DarkTurquoise;
extern color SellSignalColor = Red;

// 4A3943D5FBF2CBD3EF4A02E976FC1018
string f0_4() {
   string timeframe_4;
   switch (Period()) {
   case PERIOD_M1:
      timeframe_4 = "M1";
      break;
   case PERIOD_M5:
      timeframe_4 = "M5";
      break;
   case PERIOD_M15:
      timeframe_4 = "M15";
      break;
   case PERIOD_M30:
      timeframe_4 = "M30";
      break;
   case PERIOD_H1:
      timeframe_4 = "H1";
      break;
   case PERIOD_H4:
      timeframe_4 = "H4";
      break;
   case PERIOD_D1:
      timeframe_4 = "D1";
      break;
   case PERIOD_W1:
      timeframe_4 = "W1";
      break;
   case PERIOD_MN1:
      timeframe_4 = "MN1";
      break;
   default:
      timeframe_4 = Period();
   }
   return (timeframe_4);
}

// EAC4E9E33F3538045A48AFD1169EE124
void f0_10(string As_0, double Ad_8, double Ad_16, double Ad_24) {
   string Ls_32;
   string Ls_40;
   string Ls_48;
   string Ls_56;
   if (Time[0] != G_time_136) {
      G_time_136 = Time[0];
      if (Gs_148 != As_0) {
         Gs_148 = As_0;
         if (Ad_8 != 0.0) Ls_48 = " @ Price " + DoubleToStr(Ad_8, 4);
         else Ls_48 = "";
         if (Ad_16 != 0.0) Ls_40 = ", TakeProfit   " + DoubleToStr(Ad_16, 4);
         else Ls_40 = "";
         if (Ad_24 != 0.0) Ls_32 = ", StopLoss   " + DoubleToStr(Ad_24, 4);
         else Ls_32 = "";
         Ls_56 = Gs_184 + "Super Trend Profit " + f0_3() + " Alert " + As_0 + "" + Ls_48 + Ls_40 + Ls_32 + " ";
         Alert(Ls_56, Symbol(), ", ", Period(), " minutes chart");
         PlaySound("alert.wav");
         if (EmailOn) SendMail(Gs_184, Ls_56);
      }
   }
}

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   IndicatorBuffers(4);
   if (!SetIndexBuffer(0, G_ibuf_164))
   Print("cannot set indicator buffers!");
   if (!SetIndexBuffer(1, G_ibuf_168))
   Print("cannot set indicator buffers!");
   if (!SetIndexBuffer(2, G_ibuf_172))
   Print("cannot set indicator buffers!");
   if (!SetIndexBuffer(3, G_ibuf_176))
    Print("cannot set indicator buffers!");
    
    if (Gi_104) {
      SetIndexStyle(0, DRAW_NONE, EMPTY, G_width_76 - 1);
      SetIndexStyle(1, DRAW_NONE, EMPTY, G_width_76 - 1);
      SetIndexStyle(2, DRAW_NONE, EMPTY, G_width_76 - 1);
      SetIndexArrow(0, 159);
      SetIndexArrow(1, 159);
      SetIndexArrow(2, 159);
   } else {
      SetIndexStyle(0, DRAW_NONE);
      SetIndexStyle(1, DRAW_NONE);
      SetIndexStyle(2, DRAW_NONE);
   }
   Gi_180 = SignalPeriod + MathFloor(MathSqrt(SignalPeriod));
   SetIndexDrawBegin(0, Gi_180);
   SetIndexDrawBegin(1, Gi_180);
   SetIndexDrawBegin(2, Gi_180);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS) + 1.0);
   IndicatorShortName("Super Trend Profit(" + SignalPeriod + ")");
   SetIndexLabel(0, "Super Trend Profit");
   Gs_184 = Symbol() + " (" + f0_4() + "):  ";
   Gs_148 = "";
   ArrayInitialize(G_ibuf_164, EMPTY_VALUE);
   ArrayInitialize(G_ibuf_172, EMPTY_VALUE);
   ArrayInitialize(G_ibuf_168, EMPTY_VALUE);
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   f0_7();
   ObjectsDeleteAll(0, OBJ_TEXT);
   ObjectsDeleteAll(0, OBJ_LABEL);
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double ima_on_arr_20;
   int Li_unused_28;
   int ind_counted_8 = IndicatorCounted();
   if (ind_counted_8 < 1) {
      for (int Li_4 = 0; Li_4 <= Gi_180; Li_4++) G_ibuf_176[Bars - Li_4] = 0;
      for (Li_4 = 0; Li_4 <= SignalPeriod; Li_4++) {
         G_ibuf_164[Bars - Li_4] = EMPTY_VALUE;
         G_ibuf_168[Bars - Li_4] = EMPTY_VALUE;
         G_ibuf_172[Bars - Li_4] = EMPTY_VALUE;
      }
   }
   int Li_0 = Bars - ind_counted_8;
   for (Li_4 = 1; Li_4 < Li_0; Li_4++) {
      G_ibuf_176[Li_4] = 2.0 * iMA(NULL, 0, MathFloor(SignalPeriod / Gd_96), Gi_84, G_ma_method_88, G_applied_price_92, Li_4) - iMA(NULL, 0, SignalPeriod, Gi_84, G_ma_method_88,
         G_applied_price_92, Li_4);
   }
   double ima_on_arr_12 = iMAOnArray(G_ibuf_176, 0, MathFloor(MathSqrt(SignalPeriod)), 0, G_ma_method_88, 1);
   for (Li_4 = 2; Li_4 < Li_0 + 1; Li_4++) {
      ima_on_arr_20 = iMAOnArray(G_ibuf_176, 0, MathFloor(MathSqrt(SignalPeriod)), 0, G_ma_method_88, Li_4);
      Li_unused_28 = 0;
      if (ima_on_arr_20 > ima_on_arr_12) {
         G_ibuf_172[Li_4 - 1] = ima_on_arr_12 - Gi_108 * Point;
         Li_unused_28 = 1;
      } else {
         if (ima_on_arr_20 < ima_on_arr_12) {
            G_ibuf_164[Li_4 - 1] = ima_on_arr_12 + Gi_108 * Point;
            Li_unused_28 = 2;
         } else {
            G_ibuf_164[Li_4 - 1] = EMPTY_VALUE;
            G_ibuf_168[Li_4 - 1] = ima_on_arr_12;
            G_ibuf_172[Li_4 - 1] = EMPTY_VALUE;
            Li_unused_28 = 3;
         }
      }
      if (ind_counted_8 > 0) {
      }
      ima_on_arr_12 = ima_on_arr_20;
   }
   if (Li_0 > Gi_112) Li_0 = Gi_112;
   for (Li_4 = 2; Li_4 <= Li_0; Li_4++) {
      if (G_ibuf_164[Li_4 - 1] != EMPTY_VALUE) {
         if (G_ibuf_164[Li_4] != EMPTY_VALUE) f0_9(Li_4 - 1, Li_4, 1);
         else {
            f0_9(Li_4 - 1, Li_4, 10);
            f0_2(Li_4, G_ibuf_172[Li_4], 0);
         }
      }
      if (G_ibuf_172[Li_4 - 1] != EMPTY_VALUE) {
         if (G_ibuf_172[Li_4] != EMPTY_VALUE) {
            f0_9(Li_4 - 1, Li_4, -1);
            continue;
         }
         f0_9(Li_4 - 1, Li_4, -10);
         f0_2(Li_4, G_ibuf_164[Li_4] + MathAbs(Close[Li_4] - iSAR(NULL, 0, 0.02, 0.2, Li_4)), 1);
      }
   }
   if (G_ibuf_172[1] != EMPTY_VALUE) f0_1(1);
   if (G_ibuf_164[1] != EMPTY_VALUE) f0_1(0);
   if (aAlerts) {
      if ((Gi_116 == FALSE && G_ibuf_172[1] != EMPTY_VALUE && G_ibuf_172[2] == EMPTY_VALUE) || (Gi_116 == TRUE && G_ibuf_172[1] != EMPTY_VALUE && G_ibuf_172[2] != EMPTY_VALUE &&
         G_ibuf_172[3] == EMPTY_VALUE)) f0_10("Sell signal", Close[1], f0_8(), f0_0());
      if ((Gi_116 == FALSE && G_ibuf_164[1] != EMPTY_VALUE && G_ibuf_164[2] == EMPTY_VALUE) || (Gi_116 == TRUE && G_ibuf_164[1] != EMPTY_VALUE && G_ibuf_164[2] != EMPTY_VALUE &&
         G_ibuf_164[3] == EMPTY_VALUE)) f0_10("Buy signal", Close[1], f0_6(), f0_5());
   }
   return (0);
}

// A175ED0148C846DCBD15C5151A4F0BAF
double f0_8() {
   return (Bid - aTake_Profit * Point);
}

// 8208878A4EC7F97E49E54D58CA29C1B1
double f0_6() {
   return (Ask + aTake_Profit * Point);
}

// 09F6C199E63778DA51A1332C863719B5
double f0_0() {
   return (Bid + aStop_Loss * Point);
}

// 639A219768B3E002B71140739E24DF1C
double f0_5() {
   return (Ask - aStop_Loss * Point);
}

// 2D323144BD979BFEF42292739B4C879E
int f0_3() {
   return (10000.0 * (SignalPeriod * Point));
}

// 8999422E13CFB690048C3B2961EC2F9D
void f0_7() {
   string name_0;
   int str_len_12;
   for (int Li_8 = ObjectsTotal() - 1; Li_8 >= 0; Li_8--) {
      name_0 = ObjectName(Li_8);
      str_len_12 = StringLen(Gs_156);
      if (StringSubstr(name_0, 0, str_len_12) == Gs_156) ObjectDelete(name_0);
   }
}

// D57E9CBE9D7040E8047D5B01FCD8A6F1
void f0_9(int Ai_0, int Ai_4, int Ai_8) {
   double price_20;
   double price_28;
   color color_36;
   if (Ai_8 > 0) {
      price_20 = G_ibuf_164[Ai_0];
      if (Ai_8 == 1) price_28 = G_ibuf_164[Ai_4];
      else price_28 = G_ibuf_172[Ai_4];
      color_36 = DarkTurquoise;
   } else {
      price_20 = G_ibuf_172[Ai_0];
      if (Ai_8 == -1) price_28 = G_ibuf_172[Ai_4];
      else price_28 = G_ibuf_164[Ai_4];
      color_36 = Red;
   }
   int time_12 = Time[Ai_0];
   int time_16 = Time[Ai_4];
   if (price_20 == EMPTY_VALUE || price_28 == EMPTY_VALUE) {
      Print("Empty value for price line encountered!");
      return;
   }
   string name_40 = Gs_156 + "_segment_" + color_36 + time_12 + "_" + time_16;
   ObjectDelete(name_40);
   ObjectCreate(name_40, OBJ_TREND, 0, time_12, price_20, time_16, price_28, 0, 0);
   ObjectSet(name_40, OBJPROP_WIDTH, G_width_76);
   ObjectSet(name_40, OBJPROP_COLOR, color_36);
   ObjectSet(name_40, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(name_40, OBJPROP_RAY, FALSE);
}

// 25648F908BDC21257A45044512A011C9
void f0_2(int Ai_0, double A_price_4, int Ai_12) {
   string text_16 = "BUY";
   color color_24 = BuySignalColor;
   if (Ai_12 == 1) {
      text_16 = "SELL";
      color_24 = SellSignalColor;
   }
   int time_28 = Time[Ai_0];
   string name_32 = Gs_signall_204 + DoubleToStr(time_28, 0);
   if (ObjectFind(name_32) != -1) ObjectDelete(name_32);
   ObjectCreate(name_32, OBJ_TEXT, 0, time_28, A_price_4);
   ObjectSetText(name_32, text_16, SignalTextSize);
   ObjectSet(name_32, OBJPROP_COLOR, color_24);
}

// 10A3AB1ECBA2B204BC0AA7FDB8382079
void f0_1(int Ai_0) {
   string text_4 = "Current trend is: UP";
   string text_12 = "Current trading signal: BUY";
   color color_20 = BuySignalColor;
   if (Ai_0 == 1) {
      text_4 = "Current trend is: DOWN";
      text_12 = "Current trading signal: SELL";
      color_20 = SellSignalColor;
   }
   if (ObjectFind(G_name_196) != -1) ObjectDelete(G_name_196);
   ObjectCreate(G_name_196, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(G_name_196, text_4, SignalTextSize);
   ObjectSet(G_name_196, OBJPROP_COLOR, color_20);
   ObjectSet(G_name_196, OBJPROP_XDISTANCE, 30);
   ObjectSet(G_name_196, OBJPROP_YDISTANCE, 30);
   string name_24 = G_name_196 + "LL";
   if (ObjectFind(name_24) != -1) ObjectDelete(name_24);
   ObjectCreate(name_24, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(name_24, text_12, SignalTextSize);
   ObjectSet(name_24, OBJPROP_COLOR, color_20);
   ObjectSet(name_24, OBJPROP_XDISTANCE, 30);
   ObjectSet(name_24, OBJPROP_YDISTANCE, InformerTextSize + 35);
}