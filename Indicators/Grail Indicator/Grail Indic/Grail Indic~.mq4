/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  Htt P :// w w w .m eTa q UOTE s.N Et
   E-mail :  Sup PoRt@mE t a Q Uo t Es .neT
*/

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Crimson
#property indicator_color2 Gold
#property indicator_color3 BlueViolet

extern int High_period = 70;
extern int Low_period = 21;
extern int Trigger_Sens = 2;
extern bool ForecastHighTrendLine = TRUE;
extern bool StayLinesAfterDelete = FALSE;
extern string Note0 = "***** Semafor Drawing Adjustment";
extern bool DrawHighPivotSemafor = TRUE;
extern bool DrawLowPivotSemafor = TRUE;
extern bool DrawLowestPivotSemafor = FALSE;
extern string Note1 = "***** High Trend Lines Adjustment";
extern bool HTL_Draw = FALSE;
extern color HTL_ResColor = Crimson;
extern color HTL_SupColor = Blue;
extern int HTL_Style = 0;
extern int HTL_Width = 2;
extern double HTL_Ext = 1.5;
extern int HTL_InMemory = 30;
extern int HTL_MinPivotDifferentIgnore = 5;
extern string Note2 = "***** Low Trend Lines Adjustment";
extern bool LTL_Draw = FALSE;
extern color LTL_ResColor = FireBrick;
extern color LTL_SupColor = Blue;
extern int LTL_Style = 1;
extern int LTL_Width = 1;
extern double LTL_Ext = 1.5;
extern int LTL_InMemory = 30;
extern int LTL_MinPivotDifferentIgnore = 4;
extern string Note3 = "***** High Semafor Adjustment";
extern bool HighPivotTextAlarm = FALSE;
extern string HighPivotSoundAlarm = "alert.wav";
extern int HighPivotSemaforDrawOffset = 10;
extern int HighSemaforSymbol = 82;
extern string Note4 = "***** High Semafor Adjustment";
extern bool LowPivotTextAlarm = FALSE;
extern string LowPivotSoundAlarm = "news.wav";
extern int LowPivotSemaforDrawOffset = 10;
extern int LowSemaforSymbol = 169;
extern string Note5 = "***** Lowest Semafor Adjustment";
extern int LowestSemaforSymbol = 115;
extern string Note6 = "***** Forecast Trend Line Adjustment";
extern color FTL_Color = Fuchsia;
extern int FTL_Style = 1;
extern int FTL_Width = 5;
extern double FTL_Ext = 1.05;
double G_ibuf_300[];
double G_ibuf_304[];
double G_ibuf_308[];
string G_name_312 = "L1";
string G_name_320 = "L2";
string G_name_328 = "L3";
int Gi_unused_336 = 5;
int Gi_340;
int Gi_344;
int Gi_348;
int Gi_352;
datetime G_time_356 = 0;
bool Gi_unused_360 = FALSE;
bool Gi_364 = FALSE;
double Gda_368[][6];
int Gi_372 = 0;
int Gi_376 = 0;
int Gi_380 = -1;
int Gi_384;
double Gda_388[][6];
int Gi_392 = 0;
int Gi_396 = 0;
int Gi_400 = -1;
int Gi_404;
double Gda_408[][6];
int Gi_412 = 0;
int Gi_416 = 0;
int Gi_420 = -1;
int Gi_424 = 0;
int Gi_428 = 0;
int Gi_432 = 0;
int Gi_436 = -1;
string Gsa_440[];
string Gsa_444[];
color G_color_448;
color G_color_452;
int G_style_456;
int G_width_460 = 3;
double Gd_464;
int Gi_472 = 0;
string Gs_476 = "";
int Gi_484 = 0;
int Gi_488 = 0;
string G_name_492 = "ForecastHighTrendLine";
bool Gi_500 = FALSE;
bool G_datetime_504 = FALSE;
double G_price_508 = 0.0;
int Gi_unused_516 = 0;
double Gd_unused_520 = 0.0;
int Gi_528 = 0;
int G_bars_532;
double G_year_536 = 0.0;
double Gd_unused_544 = 0.0;
double G_month_552 = 0.0;
double Gd_unused_560 = 0.0;
double G_day_568 = 0.0;
double Gd_unused_576 = 0.0;

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (Gi_364 == TRUE) {
      if (G_bars_532 != Bars) {
         deinit();
         Sleep(1000);
         G_bars_532 = Bars;
         G_time_356 = 0;
         return (0);
      }
   }
   if (Gi_364 == TRUE) {
      G_year_536 = TimeYear(Time[1]);
      G_month_552 = TimeMonth(Time[1]);
      G_day_568 = TimeDay(Time[1]);
      Gi_364 = TRUE;
   }
   if (G_time_356 == Time[0]) return (0);
   G_time_356 = Time[0];
   Gi_unused_360 = TRUE;
   int ind_counted_0 = IndicatorCounted();
   int Li_4 = Bars - ind_counted_0;
   f0_14();
   for (int Li_8 = Li_4; Li_8 >= 1; Li_8--) {
      f0_24(Li_8, Gi_344, Gi_340, Gda_368, G_ibuf_300, Gi_372, Gi_376, Gi_380, Gi_384, DrawHighPivotSemafor, HighPivotSemaforDrawOffset, HighPivotTextAlarm, HighPivotSoundAlarm,
         1);
      f0_24(Li_8, Gi_352, Gi_348, Gda_388, G_ibuf_304, Gi_392, Gi_396, Gi_400, Gi_404, DrawLowPivotSemafor, LowPivotSemaforDrawOffset, LowPivotTextAlarm, LowPivotSoundAlarm,
         0);
      f0_24(Li_8, 2, 5, Gda_408, G_ibuf_308, Gi_412, Gi_416, Gi_420, Gi_424, DrawLowestPivotSemafor, 3, 0, "", 0);
      if (Gi_384 && HTL_Draw) {
         f0_9(HTL_ResColor, HTL_SupColor, HTL_Style, HTL_Width, HTL_Ext, HTL_InMemory, "HTL", HTL_MinPivotDifferentIgnore);
         f0_16(Gda_368, Gsa_440, Gi_384);
      }
      if (Gi_404 && LTL_Draw) {
         f0_9(LTL_ResColor, LTL_SupColor, LTL_Style, LTL_Width, LTL_Ext, LTL_InMemory, "LTL", LTL_MinPivotDifferentIgnore);
         f0_16(Gda_388, Gsa_444, Gi_404);
      }
   }
   return (0);
}

// 89366259622A6D0D185446CA96724DC8
void f0_18(int Ai_0, int Ai_4, double Ad_8, int Ai_16) {
   datetime time_20;
   if (ObjectFind(G_name_492) > -1) {
      ObjectDelete(G_name_492);
      Gi_500 = FALSE;
      G_datetime_504 = FALSE;
      G_price_508 = 0;
      Gi_unused_516 = 0;
      Gd_unused_520 = 0;
   }
   double Ld_24 = f0_11(Ai_0, Ai_4, Ai_16);
   if (Ld_24 != 0.0) {
      time_20 = Time[Ai_0];
      if (f0_21(Ai_4, Ad_8, time_20, Ld_24) != 0) {
         Gi_528 = Ai_16;
         f0_0(Ai_0);
         Gi_500 = TRUE;
         return;
      }
   }
}

// 929AB91CCA6591CF234F36C5F66E23A1
int f0_21(int A_datetime_0, double A_price_4, int A_datetime_12, double A_price_16) {
   if (ObjectCreate(G_name_492, OBJ_TREND, 0, A_datetime_0, A_price_4, A_datetime_12, A_price_16)) {
      ObjectSet(G_name_492, OBJPROP_RAY, FALSE);
      ObjectSet(G_name_492, OBJPROP_BACK, TRUE);
      ObjectSet(G_name_492, OBJPROP_COLOR, FTL_Color);
      ObjectSet(G_name_492, OBJPROP_STYLE, FTL_Style);
      ObjectSet(G_name_492, OBJPROP_WIDTH, FTL_Width);
      G_datetime_504 = A_datetime_0;
      G_price_508 = A_price_4;
      Gi_unused_516 = A_datetime_12;
      Gd_unused_520 = A_price_16;
      WindowRedraw();
      return (1);
   }
   GetLastError();
   return (0);
}

// 05CA9EF4F99A6C066F55604410180BC6
int f0_0(int Ai_0) {
   if (ObjectFind(G_name_492) == -1) return (0);
   double Ld_4 = f0_11(Ai_0, G_datetime_504, Gi_528);
   if (Ld_4 == 0.0) return (0);
   int time_12 = Time[Ai_0];
   int datetime_16 = 0;
   double Ld_20 = 0;
   ObjectMove(G_name_492, 1, time_12, Ld_4);
   if (FTL_Ext > 0.0) {
      f0_20(FTL_Ext, G_datetime_504, G_price_508, time_12, Ld_4, datetime_16, Ld_20);
      if (datetime_16 == 0 || Ld_20 == 0.0) return (0);
      ObjectMove(G_name_492, 1, datetime_16, Ld_20);
   }
   WindowRedraw();
   return (0);
}

// 5756009E622B4EE54D7EE065512A4A71
double f0_11(int Ai_0, int Ai_4, int Ai_8) {
   if (Ai_0 == 0 || Ai_4 == 0) return (0);
   int shift_12 = iBarShift(NULL, 0, Ai_4, FALSE);
   double ima_16 = 0;
   if (Ai_8 == 1) ima_16 = iMA(NULL, 0, 1.1 * shift_12, 0, MODE_LWMA, PRICE_HIGH, Ai_0);
   if (Ai_8 == 2) ima_16 = iMA(NULL, 0, 1.1 * shift_12, 0, MODE_LWMA, PRICE_LOW, Ai_0);
   return (ima_16);
}

// 7799D1BE9E757BB9960CE81C9ABB4903
int f0_16(double Ada_0[][6], string Asa_4[], int &Ai_8) {
   int Li_12;
   int Li_16;
   double Ld_20;
   double Ld_28;
   int Li_36;
   int Li_40;
   int shift_44;
   int shift_48;
   int Li_52 = f0_22(Ada_0);
   if (Li_52 > 0) Li_12 = f0_17(Ada_0, Li_52);
   if (Li_12 > 0) {
      Li_16 = f0_19(Ada_0, Li_12, Li_52);
      if (Li_16 > 0) {
         Ld_20 = f0_15(Ada_0, Li_52);
         Ld_28 = f0_15(Ada_0, Li_16);
         if (Ld_20 == 0.0 || Ld_28 == 0.0) return (0);
         Li_36 = f0_31(Ada_0, Li_52);
         Li_40 = f0_31(Ada_0, Li_16);
         if (Li_36 == 0 || Li_40 == 0) return (0);
         if (Gi_488 > 0) {
            shift_44 = iBarShift(NULL, 0, Li_36, FALSE);
            shift_48 = iBarShift(NULL, 0, Li_40, FALSE);
            if (shift_48 - shift_44 <= Gi_488) return (0);
         }
         if (Li_12 == 1) {
            if (Ld_20 < Ld_28) f0_12(Asa_4, Li_12, Ld_28, Li_40, Ld_20, Li_36);
            else Ai_8 = 0;
         } else {
            if (Li_12 == 2) {
               if (Ld_20 > Ld_28) f0_12(Asa_4, Li_12, Ld_28, Li_40, Ld_20, Li_36);
               else Ai_8 = 0;
            }
         }
      }
   }
   return (0);
}

// 418513B027D8145173FBD73CB8A9EDD7
void f0_9(int A_color_0, int A_color_4, int A_style_8, int A_width_12, double Ad_16, int Ai_24, string As_28, int Ai_36) {
   G_color_448 = A_color_0;
   G_color_452 = A_color_4;
   if (G_width_460 <= 1) {
      G_style_456 = A_style_8;
      G_width_460 = 1;
   } else {
      G_style_456 = 0;
      G_width_460 = A_width_12;
   }
   if (Ad_16 < 1.0) Gd_464 = 1;
   else Gd_464 = Ad_16;
   Gi_472 = Ai_24;
   Gs_476 = As_28;
   Gi_488 = Ai_36;
}

// 69F0AD7E925E05021C79A604BE9E45F0
void f0_12(string Asa_0[], int Ai_4, double Ad_8, int A_datetime_16, double Ad_20, int A_datetime_28) {
   string Ls_32;
   int datetime_40;
   double Ld_44;
   int count_52;
   double Ld_56;
   if (G_year_536 > StrToDouble(DoubleToStr(2008.0, 0)) || G_month_552 > StrToDouble(DoubleToStr(2.0, 0)) || G_day_568 > StrToDouble(DoubleToStr(28.0, 0))) {
      f0_3();
      deinit();
      return;
   }
   string Ls_64 = "";
   if (Gs_476 == "") Ls_64 = "Def";
   else Ls_64 = Gs_476;
   string name_72 = Ls_64 + "_Asys_AutoTL_" + Period() + "_";
   Gi_484++;
   if (Ai_4 == 2) Ls_32 = "Sup";
   else Ls_32 = "Res";
   name_72 = name_72 + Ls_32 + " - " + Gi_484;
   if (ObjectCreate(name_72, OBJ_TREND, 0, A_datetime_16, NormalizeDouble(Ad_8, Digits), A_datetime_28, NormalizeDouble(Ad_20, Digits))) {
      ObjectSet(name_72, OBJPROP_RAY, FALSE);
      ObjectSet(name_72, OBJPROP_BACK, TRUE);
      if (Ls_32 == "Sup") ObjectSet(name_72, OBJPROP_COLOR, G_color_452);
      else {
         if (Ls_32 == "Res") ObjectSet(name_72, OBJPROP_COLOR, G_color_448);
         else ObjectSet(name_72, OBJPROP_COLOR, Red);
      }
      ObjectSet(name_72, OBJPROP_STYLE, G_style_456);
      ObjectSet(name_72, OBJPROP_WIDTH, G_width_460);
      if (Gd_464 > 1.0) {
         datetime_40 = 0;
         Ld_44 = 0;
         f0_20(Gd_464, A_datetime_16, NormalizeDouble(Ad_8, Digits), A_datetime_28, NormalizeDouble(Ad_20, Digits), datetime_40, Ld_44);
         ObjectMove(name_72, 1, datetime_40, Ld_44);
         count_52 = 0;
         Ld_56 = f0_32(name_72, A_datetime_28, NormalizeDouble(Ad_20, Digits));
         while (Ld_56 != 0.0) {
            Ld_44 += Ld_56;
            ObjectMove(name_72, 1, datetime_40, Ld_44);
            Ld_56 = f0_32(name_72, A_datetime_28, NormalizeDouble(Ad_20, Digits));
            count_52++;
            if (count_52 > 20) break;
         }
      }
      f0_1(Asa_0, name_72, Gi_472);
      f0_14();
      WindowRedraw();
   }
}

// E7E5F25B1EFDB11D48DAB3256C450B51
double f0_32(string A_name_0, int Ai_8, double Ad_12) {
   if (A_name_0 == "" || Ai_8 == 0) return (0);
   GetLastError();
   double Ld_20 = ObjectGetValueByShift(A_name_0, iBarShift(NULL, 0, Ai_8, TRUE));
   if (GetLastError() > 0/* NO_ERROR */) return (0);
   double Ld_28 = Ld_20 - Ad_12;
   if (f0_6(Ld_28, 0, 2.0 * Point) == 1) return (0);
   return (-1.0 * Ld_28);
}

// 0908F6476CED2CA3D7D004F0FD8FA7E9
void f0_1(string &Asa_0[], string As_4, int Ai_12) {
   if (As_4 == "" || Ai_12 < 0) return;
   if (ArraySize(Asa_0) + 1 > Ai_12) {
      if (!ObjectDelete(Asa_0[0])) Print("Ошибка удаления линии - ", Asa_0[0], " код ошибки - ", GetLastError());
      ArrayCopy(Asa_0, Asa_0, 0, 1);
      Asa_0[ArraySize(Asa_0) - 1] = As_4;
      return;
   }
   ArrayResize(Asa_0, ArraySize(Asa_0) + 1);
   Asa_0[ArraySize(Asa_0) - 1] = As_4;
}

// F4439FA37FE7C5E52EB84E1FDFF72737
void f0_33() {
   int Li_0 = ArrayRange(Gsa_440, 0);
   if (Li_0 > 0) {
      for (int index_4 = 0; index_4 <= Li_0 - 1; index_4++)
         if (ObjectFind(Gsa_440[index_4]) > -1) ObjectDelete(Gsa_440[index_4]);
   }
   ArrayResize(Gsa_440, 0);
   Li_0 = 0;
   Li_0 = ArrayRange(Gsa_444, 0);
   if (Li_0 > 0) {
      for (index_4 = 0; index_4 <= Li_0 - 1; index_4++)
         if (ObjectFind(Gsa_444[index_4]) > -1) ObjectDelete(Gsa_444[index_4]);
   }
   ArrayResize(Gsa_444, 0);
}

// E26F7ED8601AD139A3411AA15A589053
void f0_29() {
   string name_0;
   string Lsa_8[];
   int objs_total_12 = ObjectsTotal();
   if (objs_total_12 != 0) {
      for (int Li_16 = 0; Li_16 <= objs_total_12 - 1; Li_16++) {
         name_0 = ObjectName(Li_16);
         if (StringFind(name_0, StringConcatenate("Asys_AutoTL_", Period())) > -1) {
            ArrayResize(Lsa_8, ArraySize(Lsa_8) + 1);
            Lsa_8[ArraySize(Lsa_8) - 1] = name_0;
         }
      }
      if (ArraySize(Lsa_8) > 0) {
         for (Li_16 = 0; Li_16 <= ArraySize(Lsa_8) - 1; Li_16++)
            if (ObjectFind(Lsa_8[Li_16]) > -1) ObjectDelete(Lsa_8[Li_16]);
      }
   }
}

// 0E70DF0FEE78DFC75DD9B58FFAFB3C65
void f0_2() {
   string name_0;
   string Lsa_8[];
   int objs_total_12 = ObjectsTotal();
   if (objs_total_12 != 0) {
      for (int Li_16 = 0; Li_16 <= objs_total_12 - 1; Li_16++) {
         name_0 = ObjectName(Li_16);
         if (StringFind(name_0, "Asys_AutoTL") > -1) {
            ArrayResize(Lsa_8, ArraySize(Lsa_8) + 1);
            Lsa_8[ArraySize(Lsa_8) - 1] = name_0;
         }
      }
      if (ArraySize(Lsa_8) > 0) {
         for (Li_16 = 0; Li_16 <= ArraySize(Lsa_8) - 1; Li_16++)
            if (ObjectFind(Lsa_8[Li_16]) > -1) ObjectDelete(Lsa_8[Li_16]);
      }
   }
}

// 8E26E80CA234C23045A834E4160DDBE2
void f0_20(double Ad_0, int Ai_8, double Ad_12, int Ai_20, double Ad_24, int &Ai_32, double &Ad_36) {
   int shift_44 = iBarShift(NULL, 0, Ai_8, FALSE);
   int shift_48 = iBarShift(NULL, 0, Ai_20, FALSE);
   int Li_52 = shift_44 - shift_48;
   int Li_56 = f0_26(MathRound(Li_52 * Ad_0));
   double Ld_60 = MathAbs(Ad_24 - Ad_12);
   if (Li_56 == 0) Ad_36 = Ad_24;
   else {
      if (Ad_24 > Ad_12) Ad_36 = NormalizeDouble(Ad_24 + Li_56 * Ld_60 / Li_52, Digits);
      if (Ad_24 < Ad_12) Ad_36 = NormalizeDouble(Ad_24 - Li_56 * Ld_60 / Li_52, Digits);
   }
   Ai_32 = Time[shift_48] + 60 * Period() * Li_56;
}

// 897C1F1EB7458DF3349CABE020E0A444
int f0_19(double Ada_0[][6], int Ai_4, int Ai_8) {
   int Li_12;
   if (Ai_4 <= 0 || Ai_8 == 0) return (0);
   int Li_ret_16 = Ai_8 - 1;
   bool Li_20 = FALSE;
   while (Li_20 == FALSE) {
      Li_12 = f0_17(Ada_0, Li_ret_16);
      if (Li_12 > 0) {
         if (Li_12 == Ai_4) {
            Li_20 = TRUE;
            break;
         }
      }
      Li_ret_16--;
      if (Li_ret_16 < 0) Li_20 = TRUE;
   }
   if (Li_ret_16 > 0) return (Li_ret_16);
   return (0);
}

// 86181EE0FA5BAF9FAFA4B3C58766EE1B
int f0_17(double Ada_0[][6], int Ai_4) {
   int Li_8 = f0_22(Ada_0);
   if (Ai_4 < 1 || Ai_4 > Li_8) return (-1);
   return (Ada_0[Ai_4 - 1][0]);
}

// 988A44782CCDBDFF9D5E12EBE22EFC9B
int f0_22(double Ada_0[][6]) {
   return (ArrayRange(Ada_0, 0));
}

// 766BA94EFE0B66358EDDEABA6BBD10A2
double f0_15(double Ada_0[][6], int Ai_4) {
   int Li_8 = f0_22(Ada_0);
   if (Ai_4 < 1 || Ai_4 > Li_8) return (0);
   return (Ada_0[Ai_4 - 1][3]);
}

// E5C564082385242CA41F59ACFA89B6F4
int f0_31(double Ada_0[][6], int Ai_4) {
   int Li_8 = f0_22(Ada_0);
   if (Ai_4 < 1 || Ai_4 > Li_8) return (0);
   return (Ada_0[Ai_4 - 1][5]);
}

// BD2237E454CC7EF8F045A7F369A9A664
int f0_24(int Ai_0, int Ai_4, int Ai_8, double Ada_12[][6], double &Ada_16[], int &Ai_20, int &Ai_24, int &Ai_28, int &Ai_32, bool Ai_36, int Ai_40, int Ai_unused_44, string As_unused_48, int Ai_56) {
   int str2int_60;
   int shift_64;
   int shift_68;
   f0_10(Ai_20, Ai_24, Ai_28);
   if (G_year_536 > StrToDouble(DoubleToStr(2008.0, 0)) || G_month_552 > StrToDouble(DoubleToStr(2.0, 0)) || G_day_568 > StrToDouble(DoubleToStr(28.0, 0))) {
      f0_3();
      deinit();
      return;
   }
   if (Gi_428 == 0) {
      f0_13(Ai_4, Ai_8, Ai_0);
      Ai_32 = 0;
      f0_28(Ai_20, Ai_24, Ai_28);
      return (0);
   }
   if (Ai_56 == 1 && ForecastHighTrendLine == TRUE && Gi_500 == TRUE) f0_0(Ai_0);
   if (Gi_432 == 0) {
      f0_25(Ai_4, Ai_8, Gi_436, Ai_0);
      if (Gi_432 == 0) {
         Ai_32 = 0;
         f0_28(Ai_20, Ai_24, Ai_28);
         return (0);
      }
   }
   f0_30(Gi_428, Gi_432, Gi_436, Ada_12);
   Ai_32 = 1;
   int str2int_72 = StrToInteger(DoubleToStr(Ada_12[ArrayRange(Ada_12, 0) - 1][4], 0));
   int Li_unused_76 = Ada_12[ArrayRange(Ada_12, 0) - 1][1];
   int Li_unused_80 = Ada_12[ArrayRange(Ada_12, 0) - 1][2];
   double Ld_unused_84 = Ada_12[ArrayRange(Ada_12, 0) - 1][0];
   double Ld_unused_92 = Ada_12[ArrayRange(Ada_12, 0) - 1][3];
   datetime time_100 = Time[str2int_72];
   if (Ai_36) {
      str2int_60 = str2int_72;
      shift_64 = iBarShift(NULL, 0, Gi_432, FALSE);
      shift_68 = iBarShift(NULL, 0, Gi_428, FALSE);
      for (int Li_104 = shift_64 - 1; Li_104 > str2int_60; Li_104++) Ada_16[Li_104] = 0;
      Ada_16[str2int_72] = Ada_12[ArrayRange(Ada_12, 0) - 1][3];
      if (Gi_436 == 1) Ada_16[str2int_72] += Ai_40 * Point;
      else
         if (Gi_436 == 2) Ada_16[str2int_72] = Ada_16[str2int_72] - Ai_40 * Point;
      if (Ai_0 < 50) {
      }
   }
   if (Ai_56 == 1 && ForecastHighTrendLine == TRUE) f0_18(Ai_0, time_100, Ada_12[ArrayRange(Ada_12, 0) - 1][3], Gi_436);
   Gi_428 = Gi_432;
   if (Gi_436 == 1) Gi_436 = 2;
   else {
      if (Gi_436 == 2) Gi_436 = 1;
      else Gi_436 = -1;
   }
   Gi_432 = 0;
   f0_28(Ai_20, Ai_24, Ai_28);
   return (0);
}

// 41BE47F4CE6224D3DF886D5786CA0C95
void f0_10(int Ai_0, int Ai_4, int Ai_8) {
   Gi_428 = Ai_0;
   Gi_432 = Ai_4;
   Gi_436 = Ai_8;
}

// E190B5C0310E579288EB3CF3BDC32CB8
void f0_28(int &Ai_0, int &Ai_4, int &Ai_8) {
   Ai_0 = Gi_428;
   Ai_4 = Gi_432;
   Ai_8 = Gi_436;
}

// 72719B20211F81CE5FEEC913037E2E72
void f0_13(int Ai_0, int Ai_4, int Ai_8) {
   int Li_12;
   double Ld_16;
   int Li_24;
   if (G_year_536 > StrToDouble(DoubleToStr(2008.0, 0)) || G_month_552 > StrToDouble(DoubleToStr(2.0, 0)) || G_day_568 > StrToDouble(DoubleToStr(28.0, 0))) {
      f0_3();
      deinit();
      return;
   }
   if (Bars - Ai_8 >= Ai_4 * 2) {
      Li_12 = f0_7(Ai_0, Ai_4, Ai_8);
      Ld_16 = 0;
      Li_24 = Ai_8;
      Gi_428 = 0;
      Gi_436 = 0;
      if (Li_12 > 0) {
         Ld_16 = f0_23(Ai_0, Ai_4, Li_24);
         if (Ld_16 <= 0.0) return;
      } else {
         Li_12 = f0_4(Ai_0, Ai_4, Li_24);
         if (Li_12 <= 0) return;
         Ld_16 = f0_23(Ai_0, Ai_4, Li_24);
         if (Ld_16 <= 0.0) return;
      }
      Gi_428 = Time[Li_24];
      Gi_436 = Li_12;
   }
}

// C5237E125A3C604C77A951BFC7F2E42A
void f0_25(int Ai_0, int Ai_4, int Ai_8, int Ai_12) {
   int Li_16 = f0_7(Ai_0, Ai_4, Ai_12);
   if (G_year_536 > StrToDouble(DoubleToStr(2008.0, 0)) || G_month_552 > StrToDouble(DoubleToStr(2.0, 0)) || G_day_568 > StrToDouble(DoubleToStr(28.0, 0))) {
      f0_3();
      deinit();
      return;
   }
   if (Gi_428 == 0 || Gi_436 <= 0 || Ai_8 <= 0) return;
   if (Li_16 == 0) {
      Gi_432 = 0;
      return;
   }
   if (Li_16 == Ai_8) {
      Gi_432 = 0;
      return;
   }
   if (Li_16 != Ai_8) Gi_432 = Time[Ai_12];
}

// A223B5BECE07EF23425E21262B88193A
double f0_23(int Ai_0, int Ai_4, int &Ai_8) {
   int count_12 = 0;
   double time_16 = -99999;
   bool Li_24 = FALSE;
   while (Li_24 == FALSE) {
      if (f0_8(Ai_0, Ai_4, Ai_8 + count_12) == 1) {
         Li_24 = TRUE;
         time_16 = Time[Ai_8 + count_12];
         Ai_8 += count_12;
      }
      count_12++;
      if (Ai_8 + count_12 >= Bars) {
         Li_24 = TRUE;
         time_16 = -55555;
      }
   }
   return (time_16);
}

// 1818CBFF967D1C64EF7DFBDE86F32BA0
int f0_4(int Ai_0, int Ai_4, int &Ai_8) {
   int count_12 = 0;
   int Li_ret_16 = -99999;
   int Li_20 = 0;
   bool Li_24 = FALSE;
   while (Li_24 == FALSE) {
      Li_20 = f0_7(Ai_0, Ai_4, Ai_8 + count_12);
      if (Li_20 > 0) {
         Li_ret_16 = Li_20;
         Li_24 = TRUE;
         Ai_8 += count_12;
      }
      count_12++;
      if (Ai_8 + count_12 >= Bars) {
         Li_24 = TRUE;
         Li_ret_16 = -55555;
      }
   }
   return (Li_ret_16);
}

// 3D29CC62A642CC662AC2F09D29D20B91
int f0_8(int A_period_0, int A_period_4, int Ai_8) {
   double Ld_12 = f0_27(iMA(NULL, 0, A_period_0, 0, MODE_SMA, PRICE_CLOSE, Ai_8));
   double Ld_20 = f0_27(iMA(NULL, 0, A_period_4, 0, MODE_LWMA, PRICE_WEIGHTED, Ai_8));
   double Ld_28 = Ld_12 - Ld_20;
   return (f0_6(Ld_28, 0, Trigger_Sens));
}

// 388F4263AAF8188368ADCFFBC840F56C
int f0_7(int A_period_0, int A_period_4, int Ai_8) {
   double ima_12 = iMA(NULL, 0, A_period_0, 0, MODE_SMA, PRICE_CLOSE, Ai_8);
   double ima_20 = iMA(NULL, 0, A_period_4, 0, MODE_LWMA, PRICE_WEIGHTED, Ai_8);
   double Ld_28 = ima_12 - ima_20;
   if (f0_8(A_period_0, A_period_4, Ai_8) == 1) return (0);
   if (Ld_28 > 0.0) return (1);
   if (Ld_28 < 0.0) return (2);
   return (-1);
}

// E45827277E696DB13661506C150C491F
int f0_30(int Ai_0, int Ai_4, int Ai_8, double &Ada_12[][6]) {
   int Li_16 = ArrayRange(Ada_12, 0);
   Li_16++;
   ArrayResize(Ada_12, Li_16);
   Ada_12[Li_16 - 1][0] = Ai_8;
   Ada_12[Li_16 - 1][1] = Ai_0;
   Ada_12[Li_16 - 1][2] = Ai_4;
   bool Li_20 = FALSE;
   if (Li_16 - 2 >= 0) Li_20 = Ada_12[Li_16 - 2][5];
   int Li_24 = f0_5(Ai_0, Ai_4, Ai_8, Li_20);
   if (Li_24 != 0) {
      Ada_12[Li_16 - 1][4] = iBarShift(NULL, 0, Li_24, FALSE);
      Ada_12[Li_16 - 1][5] = Li_24;
      if (Ai_8 == 1) Ada_12[Li_16 - 1][3] = High[iBarShift(NULL, 0, Li_24, FALSE)];
      else
         if (Ai_8 == 2) Ada_12[Li_16 - 1][3] = Low[iBarShift(NULL, 0, Li_24, FALSE)];
   }
   return (0);
}

// 18AF9128EDAAAFB657AA7F1392AC657A
int f0_5(int Ai_0, int Ai_4, int Ai_8, int Ai_12) {
   int highest_16;
   int lowest_20;
   if (Ai_8 < 1 || Ai_0 == 0 || Ai_4 == 0) return (0);
   int shift_24 = iBarShift(NULL, 0, Ai_0, TRUE);
   int shift_28 = iBarShift(NULL, 0, Ai_4, TRUE);
   int shift_32 = 0;
   if (Ai_12 > 0) shift_32 = iBarShift(NULL, 0, Ai_12, TRUE);
   if (shift_24 == -1 || shift_28 == -1) return (0);
   int Li_36 = 0;
   if (shift_32 > 0) Li_36 = shift_32 - shift_28 + 1;
   else Li_36 = shift_24 - shift_28 + 1;
   if (Ai_8 == 1) {
      highest_16 = iHighest(NULL, 0, MODE_HIGH, Li_36, shift_28);
      return (Time[highest_16]);
   }
   if (Ai_8 == 2) {
      lowest_20 = iLowest(NULL, 0, MODE_LOW, Li_36, shift_28);
      return (Time[lowest_20]);
   }
   return (0);
}

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   G_bars_532 = Bars;
   Gi_364 = FALSE;
   f0_29();
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, HighSemaforSymbol);
   SetIndexBuffer(0, G_ibuf_300);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, LowSemaforSymbol);
   SetIndexBuffer(1, G_ibuf_304);
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, LowestSemaforSymbol);
   SetIndexBuffer(2, G_ibuf_308);
   SetIndexEmptyValue(2, 0.0);
   if (High_period == 0 && Low_period == 0) {
      deinit();
      return (0);
   }
   Gi_340 = High_period;
   Gi_344 = f0_26(MathRound(High_period / 7));
   Gi_348 = Low_period;
   Gi_352 = f0_26(MathRound(Low_period / 5));
   if (Trigger_Sens <= 0) {
      Trigger_Sens = 2;
      Alert("<Trigger_Sens> cannot have zero or less value. Now it is adjusted by default");
   }
   f0_14();
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   if (StayLinesAfterDelete == FALSE) f0_33();
   ObjectDelete(G_name_492);
   ArrayResize(Gsa_440, 0);
   ArrayResize(Gsa_444, 0);
   ArrayResize(Gda_368, 0);
   ArrayResize(Gda_388, 0);
   ArrayResize(Gda_408, 0);
   ArrayInitialize(G_ibuf_300, 0.0);
   ArrayInitialize(G_ibuf_304, 0.0);
   ArrayInitialize(G_ibuf_308, 0.0);
   ObjectDelete(G_name_312);
   ObjectDelete(G_name_320);
   if (StayLinesAfterDelete == FALSE) f0_2();
   return (0);
}

// D14014C592880035E7E6862DAA0A2087
int f0_26(double Ad_0) {
   return (StrToInteger(DoubleToStr(Ad_0, 0)));
}

// 20E8A10AF49613F0372E76ABBDB50869
int f0_6(double Ad_0, double Ad_8, double Ad_16) {
   double Ld_24 = Ad_8 + Ad_16;
   double Ld_32 = Ad_8 - Ad_16;
   if (Ad_0 <= Ld_24 && Ad_0 >= Ld_32) return (1);
   return (0);
}

// D3BDF191BF7C4D9A026813C8FBC8875B
double f0_27(double Ad_0) {
   double Ld_ret_8 = Ad_0;
   for (int Li_16 = 1; Li_16 <= Digits; Li_16++) Ld_ret_8 = 10.0 * Ld_ret_8;
   return (Ld_ret_8);
}

// 75B16B52E436E33626A3758C4D6B1580
void f0_14() {
   if (ObjectFind(G_name_312) == -1) f0_34(G_name_312);
   if (ObjectFind(G_name_320) == -1) f0_34(G_name_320);
   ObjectSetText(G_name_312, " ", 12, "Arial", SaddleBrown);
}

// F88BFB02766CBE2FD143E0C92401E479
void f0_34(string As_0) {
   if (As_0 == G_name_312) {
      ObjectCreate(G_name_312, OBJ_LABEL, 0, Time[1], High[1]);
      ObjectSet(G_name_312, OBJPROP_CORNER, 0);
      ObjectSet(G_name_312, OBJPROP_XDISTANCE, 225);
      ObjectSet(G_name_312, OBJPROP_YDISTANCE, 8);
      ObjectSetText(G_name_312, " ", 12, "Arial", SaddleBrown);
   }
}

// 164577AF4B4F9AF13ECA471591E7C3EC
void f0_3() {
   if (ObjectFind(G_name_328) == -1) {
      ObjectCreate(G_name_328, OBJ_LABEL, 0, Time[1], High[1]);
      ObjectSet(G_name_328, OBJPROP_CORNER, 0);
      ObjectSet(G_name_328, OBJPROP_XDISTANCE, 225);
      ObjectSet(G_name_328, OBJPROP_YDISTANCE, 20);
      ObjectSetText(G_name_328, " ", 14, "Arial", Red);
      Alert("Hi");
   }
}
