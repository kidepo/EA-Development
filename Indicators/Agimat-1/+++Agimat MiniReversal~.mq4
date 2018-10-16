/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  H tT P://W WW.M e T A QUOT e S.net
   E-mail :  S U P P or T @M ETaQu O T es .NeT
*/
#property copyright "mmindicatorvisual"
#property link      "mmindicatorvisual"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Chocolate
#property indicator_color2 Chocolate
#property indicator_color3 MediumVioletRed
#property indicator_color4 MediumVioletRed
#property indicator_color5 Yellow
#property indicator_color6 Yellow

extern bool Sound.Alert = FALSE;
extern double Period1 = 5.0;
extern double Period2 = 13.0;
extern double Period3 = 34.0;
extern string Dev_Step_1 = "1,3";
extern string Dev_Step_2 = "8,5";
extern string Dev_Step_3 = "13,8";
extern int Symbol_1_Kod = 1;
extern int Symbol_2_Kod = 1;
extern int Symbol_3_Kod = 175;
double G_ibuf_140[];
double G_ibuf_144[];
double G_ibuf_148[];
double G_ibuf_152[];
double G_ibuf_156[];
double G_ibuf_160[];
int Gi_unused_164;
int Gi_unused_168;
int Gi_unused_172;
int Gi_176;
int Gi_180;
int Gi_184;
int Gi_188;
int Gi_192;
int Gi_196;
string Gs_200;
string Gs_208;
string Gs_216;
int G_digits_224;
int G_timeframe_228;
bool Gi_232;
bool Gi_236;
bool Gi_240;
int G_bars_244 = -1;
int Gi_unused_248 = 65535;

int init() {
   int Lia_8[];
   G_timeframe_228 = Period();
   Gs_208 = TimeFrameToString(G_timeframe_228);
   Gs_200 = Symbol();
   G_digits_224 = Digits;
   Gs_216 = "tbb" + Gs_200 + Gs_208;
   if (Period1 > 0.0) Gi_unused_164 = MathCeil(Period1 * Period());
   else Gi_unused_164 = 0;
   if (Period2 > 0.0) Gi_unused_168 = MathCeil(Period2 * Period());
   else Gi_unused_168 = 0;
   if (Period3 > 0.0) Gi_unused_172 = MathCeil(Period3 * Period());
   else Gi_unused_172 = 0;
   if (Period1 > 0.0) {
      SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 1);
      SetIndexArrow(0, Symbol_1_Kod);
      SetIndexBuffer(0, G_ibuf_140);
      SetIndexEmptyValue(0, 0.0);
      SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID, 1);
      SetIndexArrow(1, Symbol_1_Kod);
      SetIndexBuffer(1, G_ibuf_144);
      SetIndexEmptyValue(1, 0.0);
   }
   if (Period2 > 0.0) {
      SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 2);
      SetIndexArrow(2, Symbol_2_Kod);
      SetIndexBuffer(2, G_ibuf_148);
      SetIndexEmptyValue(2, 0.0);
      SetIndexStyle(3, DRAW_ARROW, STYLE_SOLID, 2);
      SetIndexArrow(3, Symbol_2_Kod);
      SetIndexBuffer(3, G_ibuf_152);
      SetIndexEmptyValue(3, 0.0);
   }
   if (Period3 > 0.0) {
      SetIndexStyle(4, DRAW_ARROW, STYLE_SOLID, 4);
      SetIndexArrow(4, Symbol_3_Kod);
      SetIndexBuffer(4, G_ibuf_156);
      SetIndexEmptyValue(4, 0.0);
      SetIndexStyle(5, DRAW_ARROW, STYLE_SOLID, 4);
      SetIndexArrow(5, Symbol_3_Kod);
      SetIndexBuffer(5, G_ibuf_160);
      SetIndexEmptyValue(5, 0.0);
   }
   int Li_unused_0 = 0;
   int Li_unused_4 = 0;
   int Li_12 = 0;
   if (IntFromStr(Dev_Step_1, Li_12, Lia_8) == 1) {
      Gi_180 = Lia_8[1];
      Gi_176 = Lia_8[0];
   }
   if (IntFromStr(Dev_Step_2, Li_12, Lia_8) == 1) {
      Gi_188 = Lia_8[1];
      Gi_184 = Lia_8[0];
   }
   if (IntFromStr(Dev_Step_3, Li_12, Lia_8) == 1) {
      Gi_196 = Lia_8[1];
      Gi_192 = Lia_8[0];
   }
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   if (Bars != G_bars_244) {
      Gi_232 = TRUE;
      Gi_236 = TRUE;
      Gi_240 = TRUE;
   }
   if (Period1 > 0.0) CountZZ(G_ibuf_140, G_ibuf_144, Period1, Gi_176, Gi_180);
   if (Period2 > 0.0) CountZZ(G_ibuf_148, G_ibuf_152, Period2, Gi_184, Gi_188);
   if (Period3 > 0.0) CountZZ(G_ibuf_156, G_ibuf_160, Period3, Gi_192, Gi_196);
   if (Gi_232 && Sound.Alert) {
      if (G_ibuf_140[0] != 0.0) {
         Gi_232 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 1 Lower " + DoubleToStr(Close[0], G_digits_224));
      }
      if (G_ibuf_144[0] != 0.0) {
         Gi_232 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 1 Upper " + DoubleToStr(Close[0], G_digits_224));
      }
   }
   if (Gi_236 && Sound.Alert) {
      if (G_ibuf_148[0] != 0.0) {
         Gi_236 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 2 Lower " + DoubleToStr(Close[0], G_digits_224));
      }
      if (G_ibuf_152[0] != 0.0) {
         Gi_236 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 2 Upper " + DoubleToStr(Close[0], G_digits_224));
      }
   }
   if (Gi_240 && Sound.Alert) {
      if (G_ibuf_156[0] != 0.0) {
         Gi_240 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 3 Lower " + DoubleToStr(Close[0], G_digits_224));
      }
      if (G_ibuf_160[0] != 0.0) {
         Gi_240 = FALSE;
         Alert(Gs_200, "  ", Gs_208, " Level 3 Upper " + DoubleToStr(Close[0], G_digits_224));
      }
   }
   G_bars_244 = Bars;
   return (0);
}

string TimeFrameToString(int Ai_0) {
   string Ls_ret_4;
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
      Ls_ret_4 = "MN";
   }
   return (Ls_ret_4);
}

int CountZZ(double &Ada_0[], double &Ada_4[], int Ai_8, int Ai_12, int Ai_16) {
   double Ld_36;
   double Ld_44;
   double Ld_52;
   double Ld_60;
   double Ld_68;
   double Ld_76;
   for (int Li_20 = Bars - Ai_8; Li_20 >= 0; Li_20--) {
      Ld_36 = Low[iLowest(NULL, 0, MODE_LOW, Ai_8, Li_20)];
      if (Ld_36 == Ld_76) Ld_36 = 0.0;
      else {
         Ld_76 = Ld_36;
         if (Low[Li_20] - Ld_36 > Ai_12 * Point) Ld_36 = 0.0;
         else {
            for (int Li_24 = 1; Li_24 <= Ai_16; Li_24++) {
               Ld_44 = Ada_0[Li_20 + Li_24];
               if (Ld_44 != 0.0 && Ld_44 > Ld_36) Ada_0[Li_20 + Li_24] = 0.0;
            }
         }
      }
      Ada_0[Li_20] = Ld_36;
      Ld_36 = High[iHighest(NULL, 0, MODE_HIGH, Ai_8, Li_20)];
      if (Ld_36 == Ld_68) Ld_36 = 0.0;
      else {
         Ld_68 = Ld_36;
         if (Ld_36 - High[Li_20] > Ai_12 * Point) Ld_36 = 0.0;
         else {
            for (Li_24 = 1; Li_24 <= Ai_16; Li_24++) {
               Ld_44 = Ada_4[Li_20 + Li_24];
               if (Ld_44 != 0.0 && Ld_44 < Ld_36) Ada_4[Li_20 + Li_24] = 0.0;
            }
         }
      }
      Ada_4[Li_20] = Ld_36;
   }
   Ld_68 = -1;
   int Li_28 = -1;
   Ld_76 = -1;
   int Li_32 = -1;
   for (Li_20 = Bars - Ai_8; Li_20 >= 0; Li_20--) {
      Ld_52 = Ada_0[Li_20];
      Ld_60 = Ada_4[Li_20];
      if (Ld_52 == 0.0 && Ld_60 == 0.0) continue;
      if (Ld_60 != 0.0) {
         if (Ld_68 > 0.0) {
            if (Ld_68 < Ld_60) Ada_4[Li_28] = 0;
            else Ada_4[Li_20] = 0;
         }
         if (Ld_68 < Ld_60 || Ld_68 < 0.0) {
            Ld_68 = Ld_60;
            Li_28 = Li_20;
         }
         Ld_76 = -1;
      }
      if (Ld_52 != 0.0) {
         if (Ld_76 > 0.0) {
            if (Ld_76 > Ld_52) Ada_0[Li_32] = 0;
            else Ada_0[Li_20] = 0;
         }
         if (Ld_52 < Ld_76 || Ld_76 < 0.0) {
            Ld_76 = Ld_52;
            Li_32 = Li_20;
         }
         Ld_68 = -1;
      }
   }
   for (Li_20 = Bars - 1; Li_20 >= 0; Li_20--) {
      if (Li_20 >= Bars - Ai_8) Ada_0[Li_20] = 0.0;
      else {
         Ld_44 = Ada_4[Li_20];
         if (Ld_44 != 0.0) Ada_4[Li_20] = Ld_44;
      }
   }
   return (0);
}

int Str2Massive(string As_0, int &Ai_8, int &Aia_12[]) {
   int Li_20;
   int str2int_16 = StrToInteger(As_0);
   if (str2int_16 > 0) {
      Ai_8++;
      Li_20 = ArrayResize(Aia_12, Ai_8);
      if (Li_20 == 0) return (-1);
      Aia_12[Ai_8 - 1] = str2int_16;
      return (1);
   }
   return (0);
}

int IntFromStr(string As_0, int &Ai_8, int Aia_12[]) {
   string Ls_28;
   if (StringLen(As_0) == 0) return (-1);
   string Ls_16 = As_0;
   int Li_24 = 0;
   Ai_8 = 0;
   ArrayResize(Aia_12, Ai_8);
   while (StringLen(Ls_16) > 0) {
      Li_24 = StringFind(Ls_16, ",");
      if (Li_24 > 0) {
         Ls_28 = StringSubstr(Ls_16, 0, Li_24);
         Ls_16 = StringSubstr(Ls_16, Li_24 + 1, StringLen(Ls_16));
      } else {
         if (StringLen(Ls_16) > 0) {
            Ls_28 = Ls_16;
            Ls_16 = "";
         }
      }
      if (Str2Massive(Ls_28, Ai_8, Aia_12) == 0) return (-2);
   }
   return (1);
}
