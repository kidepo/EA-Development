/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website: h t t p :// W W W.m E t aq UOT e S.n ET
   E-mail : S uPpO R t @ mE tAQU o te s .n et
*/
#property copyright "mladen"
#property link      ""

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 100.0
#property indicator_levelcolor DarkSlateGray
#property indicator_buffers 3
#property indicator_color1 DimGray
#property indicator_color2 LimeGreen
#property indicator_color3 Red
#property indicator_level1 70.0
#property indicator_width2 2
#property indicator_level2 50.0
#property indicator_width3 2
#property indicator_level3 30.0

string Gs_76;
extern int RSIPeriod = 14;
extern int PriceType = 5;
extern string timeFrame = "Current time frame";
extern int OverBought = 70;
extern int OverSold = 30;
extern bool showArrows = TRUE;
extern color ArrowUpColor = LimeGreen;
extern color ArrowDnColor = Maroon;
extern int UpDnArrowSize = 0;
extern color RevUpColor = MediumSeaGreen;
extern color RevDnColor = Red;
extern int RevArrowSize = 1;
extern double Signal_Gap = 1.3;
extern bool alertsOn = FALSE;
extern bool OBOS_Level_crossAlert = FALSE;
extern bool Level_50_crossAlert = TRUE;
extern bool alertsMessage = TRUE;
extern bool alertsSound = FALSE;
extern bool alertsEmail = FALSE;
extern int repaintSignalStep = 0;
extern int repaintSignalPrice = 0;
extern int MaxArrowsScreensX = 3;
extern string TimeFrames = "M1;5,15,30,H160;H4240;D11440;W110080;MN43200|0-CurrentTF";
double G_ibuf_188[];
double G_ibuf_192[];
double G_ibuf_196[];
double Gda_unused_200[];
int G_timeframe_204;
int Gia_208[];
int Gi_212;
int Gi_216;
string Gs_220;
int Gi_228;
string Gs_nothing_232 = "nothing";
datetime G_time_240;

int init() {
   string Ls_0 = "RSI (";
   SetIndexBuffer(0, G_ibuf_188);
   SetIndexBuffer(1, G_ibuf_192);
   SetIndexBuffer(2, G_ibuf_196);
   SetIndexLabel(0, "RSI");
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, NULL);
   Ls_0 = "RSI (" + RSIPeriod + ") ";
   G_timeframe_204 = stringToTimeFrame(timeFrame);
   if (G_timeframe_204 != Period()) Ls_0 = Ls_0 + "[" + TimeFrameToString(G_timeframe_204) + "] ";
   Ls_0 = Ls_0 + PriceTypeToString(PriceType) + " | ";
   if (OverBought < OverSold) OverBought = OverSold;
   if (OverBought < 100) Ls_0 = Ls_0 + OverBought + ",";
   if (OverSold > 0) Ls_0 = Ls_0 + OverSold + ":";
   IndicatorShortName(Ls_0);
   Gs_76 = MakeUniqueName("", "RSIsignal");
   return (0);
}

int deinit() {
   DeleteArrows();
   return (0);
}

int start() {
   double ima_16;
   double ima_24;
   int Li_0 = IndicatorCounted();
   if (Li_0 < 0) return (-1);
   if (Li_0 > 0) Li_0--;
   int Li_4 = MathMax(Bars - Li_0, G_timeframe_204 / Period());
   ArrayCopySeries(Gia_208, 5, NULL, G_timeframe_204);
   int Li_8 = 0;
   for (int Li_12 = 0; Li_8 < Li_4; Li_8++) {
      if (Time[Li_8] < Gia_208[Li_12]) Li_12++;
      G_ibuf_188[Li_8] = iRSI(NULL, G_timeframe_204, RSIPeriod, PriceType, Li_12);
   }
   for (Li_8 = Li_4; Li_8 >= 0; Li_8--) {
      if (G_ibuf_188[Li_8] > OverBought) {
         G_ibuf_192[Li_8] = G_ibuf_188[Li_8];
         G_ibuf_192[Li_8 + 1] = G_ibuf_188[Li_8 + 1];
      } else {
         G_ibuf_192[Li_8] = EMPTY_VALUE;
         if (G_ibuf_192[Li_8 + 2] == EMPTY_VALUE) G_ibuf_192[Li_8 + 1] = EMPTY_VALUE;
      }
      if (G_ibuf_188[Li_8] < OverSold) {
         G_ibuf_196[Li_8] = G_ibuf_188[Li_8];
         G_ibuf_196[Li_8 + 1] = G_ibuf_188[Li_8 + 1];
      } else {
         G_ibuf_196[Li_8] = EMPTY_VALUE;
         if (G_ibuf_196[Li_8 + 2] == EMPTY_VALUE) G_ibuf_196[Li_8 + 1] = EMPTY_VALUE;
      }
   }
   DeleteArrows();
   if (showArrows) {
      Gi_216 = MathCeil(iATR(NULL, 0, 9, 0) / Point);
      for (Li_8 = WindowBarsPerChart() * MaxArrowsScreensX; Li_8 >= 0; Li_8--) {
         if (G_ibuf_188[Li_8] > OverBought && G_ibuf_188[Li_8 + 1] < OverBought) DrawArrow(Li_8, "up");
         if (G_ibuf_188[Li_8] < OverBought && G_ibuf_188[Li_8 + 1] > OverBought) DrawArrow(Li_8, "ReversDn");
         if (G_ibuf_188[Li_8] < OverSold && G_ibuf_188[Li_8 + 1] > OverSold) DrawArrow(Li_8, "dn");
         if (G_ibuf_188[Li_8] > OverSold && G_ibuf_188[Li_8 + 1] < OverSold) DrawArrow(Li_8, "ReversUp");
         if (G_timeframe_204 == Period() && repaintSignalStep > 0) {
            if (Gi_228 == Li_8 + 1) {
               ima_16 = iMA(NULL, 0, 1, 0, MODE_SMA, repaintSignalPrice, Li_8);
               ima_24 = iMA(NULL, 0, 1, 0, MODE_SMA, repaintSignalPrice, Li_8 + 1);
               if (Gs_220 == "dn") {
                  if (G_ibuf_188[Li_8] < OverSold) {
                     if ((ima_24 - ima_16) / Point >= repaintSignalStep) {
                        ObjectSet(StringConcatenate(Gs_76, Gi_212), OBJPROP_TIME1, Time[Li_8]);
                        ObjectSet(StringConcatenate(Gs_76, Gi_212), OBJPROP_PRICE1, Low[Li_8] - Gi_216 * Point);
                     }
                  }
               }
               if (Gs_220 == "up") {
                  if (G_ibuf_188[Li_8] > OverBought) {
                     if ((ima_16 - ima_24) / Point >= repaintSignalStep) {
                        ObjectSet(StringConcatenate(Gs_76, Gi_212), OBJPROP_TIME1, Time[Li_8]);
                        ObjectSet(StringConcatenate(Gs_76, Gi_212), OBJPROP_PRICE1, High[Li_8] + Gi_216 * Point);
                     }
                  }
               }
            }
         }
      }
   }
   if (alertsOn) {
      if (OBOS_Level_crossAlert) {
         if (G_ibuf_188[0] > OverBought && G_ibuf_188[1] < OverBought) doAlert(OverBought + " Level crossed Up");
         if (G_ibuf_188[0] < OverBought && G_ibuf_188[1] > OverBought) doAlert(OverBought + " Level crossed Down");
         if (G_ibuf_188[0] < OverSold && G_ibuf_188[1] > OverSold) doAlert(OverSold + " Level crossed Down");
         if (G_ibuf_188[0] > OverSold && G_ibuf_188[1] < OverSold) doAlert(OverSold + " Level crossed Up");
      }
      if (Level_50_crossAlert) {
         if (G_ibuf_188[0] > 50.0 && G_ibuf_188[1] < 50.0) doAlert("Level 50 crossed Up");
         if (G_ibuf_188[0] < 50.0 && G_ibuf_188[1] > 50.0) doAlert("Level 50 crossed Down");
      }
   }
   return (0);
}

void DrawArrow(int Ai_0, string As_4) {
   Gi_212++;
   string str_concat_12 = StringConcatenate(Gs_76, Gi_212);
   ObjectCreate(str_concat_12, OBJ_ARROW, 0, Time[Ai_0], 0);
   if (Signal_Gap == 0.0) Signal_Gap = 1;
   if (As_4 == "up") {
      ObjectSet(str_concat_12, OBJPROP_PRICE1, High[Ai_0] + Gi_216 * Signal_Gap * (UpDnArrowSize + 1) * Point);
      ObjectSet(str_concat_12, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
      ObjectSet(str_concat_12, OBJPROP_COLOR, ArrowUpColor);
      ObjectSet(str_concat_12, OBJPROP_WIDTH, UpDnArrowSize);
   }
   if (As_4 == "dn") {
      ObjectSet(str_concat_12, OBJPROP_PRICE1, Low[Ai_0] - Gi_216 * Signal_Gap * (UpDnArrowSize + 1) * Point);
      ObjectSet(str_concat_12, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
      ObjectSet(str_concat_12, OBJPROP_COLOR, LimeGreen);
      ObjectSet(str_concat_12, OBJPROP_COLOR, ArrowDnColor);
      ObjectSet(str_concat_12, OBJPROP_WIDTH, UpDnArrowSize);
   }
   if (As_4 == "ReversUp") {
      ObjectSet(str_concat_12, OBJPROP_PRICE1, Low[Ai_0] - Gi_216 * Signal_Gap * (RevArrowSize + 1) * Point);
      ObjectSet(str_concat_12, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
      ObjectSet(str_concat_12, OBJPROP_COLOR, LimeGreen);
      ObjectSet(str_concat_12, OBJPROP_COLOR, RevUpColor);
      ObjectSet(str_concat_12, OBJPROP_WIDTH, RevArrowSize);
   }
   if (As_4 == "ReversDn") {
      ObjectSet(str_concat_12, OBJPROP_PRICE1, High[Ai_0] + Gi_216 * Signal_Gap * (RevArrowSize + 1) * Point);
      ObjectSet(str_concat_12, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
      ObjectSet(str_concat_12, OBJPROP_COLOR, RevDnColor);
      ObjectSet(str_concat_12, OBJPROP_WIDTH, RevArrowSize);
   }
   Gs_220 = As_4;
   Gi_228 = Ai_0;
}

void DeleteArrows() {
   while (Gi_212 > 0) {
      ObjectDelete(StringConcatenate(Gs_76, Gi_212));
      Gi_212--;
   }
}

void doAlert(string As_0) {
   string str_concat_8;
   if (Gs_nothing_232 != As_0 || G_time_240 != Time[0]) {
      Gs_nothing_232 = As_0;
      G_time_240 = Time[0];
      str_concat_8 = StringConcatenate(Symbol(), ", ", TimeToStr(TimeLocal(), TIME_SECONDS), "; ColorRSI (TF ", TimeFrameToString(G_timeframe_204), " at M", Period(), " chart): ",
         As_0);
      if (alertsMessage) Alert(str_concat_8);
      if (alertsSound) PlaySound("alert2.wav");
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), " RSI crossing"), str_concat_8);
   }
}

string PriceTypeToString(int Ai_0) {
   string Ls_ret_4;
   switch (Ai_0) {
   case 0:
      Ls_ret_4 = "Close";
      break;
   case 1:
      Ls_ret_4 = "Open";
      break;
   case 2:
      Ls_ret_4 = "High";
      break;
   case 3:
      Ls_ret_4 = "Low";
      break;
   case 4:
      Ls_ret_4 = "Median";
      break;
   case 5:
      Ls_ret_4 = "Typical";
      break;
   case 6:
      Ls_ret_4 = "Wighted";
      break;
   default:
      Ls_ret_4 = "Invalid price field requested";
      Alert(Ls_ret_4);
   }
   return (Ls_ret_4);
}

int stringToTimeFrame(string As_0) {
   int timeframe_8 = 0;
   As_0 = StringUpperCase(As_0);
   if (As_0 == "M1" || As_0 == "1") timeframe_8 = 1;
   if (As_0 == "M5" || As_0 == "5") timeframe_8 = 5;
   if (As_0 == "M15" || As_0 == "15") timeframe_8 = 15;
   if (As_0 == "M30" || As_0 == "30") timeframe_8 = 30;
   if (As_0 == "H1" || As_0 == "60") timeframe_8 = 60;
   if (As_0 == "H4" || As_0 == "240") timeframe_8 = 240;
   if (As_0 == "D1" || As_0 == "1440") timeframe_8 = 1440;
   if (As_0 == "W1" || As_0 == "10080") timeframe_8 = 10080;
   if (As_0 == "MN" || As_0 == "43200") timeframe_8 = 43200;
   if (timeframe_8 < Period()) timeframe_8 = Period();
   return (timeframe_8);
}

string TimeFrameToString(int Ai_0) {
   string Ls_ret_4 = "Current time frame";
   switch (Ai_0) {
   case 1:
      Ls_ret_4 = "M1";
      break;
   case 5:
      Ls_ret_4 = "M5";
      break;
   case 15:
      Ls_ret_4 = "M15";
      break;
   case 30:
      Ls_ret_4 = "M30";
      break;
   case 60:
      Ls_ret_4 = "H1";
      break;
   case 240:
      Ls_ret_4 = "H4";
      break;
   case 1440:
      Ls_ret_4 = "D1";
      break;
   case 10080:
      Ls_ret_4 = "W1";
      break;
   case 43200:
      Ls_ret_4 = "MN1";
   }
   return (Ls_ret_4);
}

string StringUpperCase(string As_0) {
   int Li_20;
   string Ls_ret_8 = As_0;
   for (int Li_16 = StringLen(As_0) - 1; Li_16 >= 0; Li_16--) {
      Li_20 = StringGetChar(Ls_ret_8, Li_16);
      if ((Li_20 > '`' && Li_20 < '{') || (Li_20 > 'ß' && Li_20 < 256)) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 - 32);
      else
         if (Li_20 > -33 && Li_20 < 0) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 + 224);
   }
   return (Ls_ret_8);
}

string MakeUniqueName(string As_0, string As_8) {
   for (string Ls_ret_16 = As_0 + (MathRand() % 1001) + As_8; WindowFind(Ls_ret_16) >= 0; Ls_ret_16 = As_0 + (MathRand() % 1001) + As_8) {
   }
   return (Ls_ret_16);
}
