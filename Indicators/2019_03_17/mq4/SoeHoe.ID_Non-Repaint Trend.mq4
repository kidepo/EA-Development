/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  H T T P: / / Ww W . me t Aq UoTE S. neT
   E-mail :  S upP or t @ m E T AQu ot E S. NEt
*/
#property copyright "Copyright © 2012, Marketcalls."
#property link      "http://www.marketcalls.in"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Red

double G_ibuf_76[];
double G_ibuf_80[];
double G_ibuf_84[];
double G_ibuf_88[];
bool Gi_92;
extern int Nbr_Periods = 10;
extern double Multiplier = 3.0;
extern bool Alert_ = TRUE;
extern int TimeSleep_Alert = 240;
int Gi_116 = 0;
datetime G_time_120 = 0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   SetIndexBuffer(0, G_ibuf_76);
   SetIndexStyle(0, DRAW_LINE, STYLE_DASH, 1);
   SetIndexLabel(0, "Trend Up");
   SetIndexBuffer(1, G_ibuf_80);
   SetIndexStyle(1, DRAW_LINE, STYLE_DASH, 1);
   SetIndexLabel(1, "Trend Down");
   SetIndexStyle(2, DRAW_ARROW, EMPTY);
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexBuffer(2, G_ibuf_84);
   SetIndexBuffer(3, G_ibuf_88);
   SetIndexArrow(2, 233);
   SetIndexArrow(3, 234);
   SetIndexLabel(3, "Up Signal");
   SetIndexLabel(4, "Down Signal");
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   bool Li_8;
   bool Li_12;
   int Lia_16[5000];
   double Lda_20[5000];
   double Lda_24[5000];
   double Ld_28;
   double iatr_36;
   int Li_44 = IndicatorCounted();
   if (Li_44 < 0) return (-1);
   if (Li_44 > 0) Li_44--;
   int Li_0 = Bars - Li_44;
   for (int bars_4 = Bars; bars_4 >= 1; bars_4--) {
      G_ibuf_76[bars_4] = EMPTY_VALUE;
      G_ibuf_80[bars_4] = EMPTY_VALUE;
      iatr_36 = iATR(NULL, 0, Nbr_Periods, bars_4);
      Ld_28 = (High[bars_4] + Low[bars_4]) / 2.0;
      Lda_20[bars_4] = Ld_28 + Multiplier * iatr_36;
      Lda_24[bars_4] = Ld_28 - Multiplier * iatr_36;
      Lia_16[bars_4] = 1;
      if (Close[bars_4] > Lda_20[bars_4 + 1]) {
         Lia_16[bars_4] = 1;
         if (Lia_16[bars_4 + 1] == -1) Gi_92 = TRUE;
      } else {
         if (Close[bars_4] < Lda_24[bars_4 + 1]) {
            Lia_16[bars_4] = -1;
            if (Lia_16[bars_4 + 1] == 1) Gi_92 = TRUE;
         } else {
            if (Lia_16[bars_4 + 1] == 1) {
               Lia_16[bars_4] = 1;
               Gi_92 = FALSE;
            } else {
               if (Lia_16[bars_4 + 1] == -1) {
                  Lia_16[bars_4] = -1;
                  Gi_92 = FALSE;
               }
            }
         }
      }
      if (Lia_16[bars_4] < 0 && Lia_16[bars_4 + 1] > 0) Li_8 = TRUE;
      else Li_8 = FALSE;
      if (Lia_16[bars_4] > 0 && Lia_16[bars_4 + 1] < 0) Li_12 = TRUE;
      else Li_12 = FALSE;
      if (Lia_16[bars_4] > 0 && Lda_24[bars_4] < Lda_24[bars_4 + 1]) Lda_24[bars_4] = Lda_24[bars_4 + 1];
      if (Lia_16[bars_4] < 0 && Lda_20[bars_4] > Lda_20[bars_4 + 1]) Lda_20[bars_4] = Lda_20[bars_4 + 1];
      if (Li_8 == TRUE) Lda_20[bars_4] = Ld_28 + Multiplier * iatr_36;
      if (Li_12 == TRUE) Lda_24[bars_4] = Ld_28 - Multiplier * iatr_36;
      if (Lia_16[bars_4] == 1) {
         G_ibuf_76[bars_4] = Lda_24[bars_4];
         if (Gi_92 == TRUE) {
            G_ibuf_76[bars_4 + 1] = G_ibuf_80[bars_4 + 1];
            Gi_92 = FALSE;
         }
      } else {
         if (Lia_16[bars_4] == -1) {
            G_ibuf_80[bars_4] = Lda_20[bars_4];
            if (Gi_92 == TRUE) {
               G_ibuf_80[bars_4 + 1] = G_ibuf_76[bars_4 + 1];
               Gi_92 = FALSE;
            }
         }
      }
      if (Lia_16[bars_4] == 1 && Lia_16[bars_4 + 1] == -1) {
         G_ibuf_84[bars_4] = iLow(Symbol(), 0, bars_4) - 3.0 * Point;
         G_ibuf_88[bars_4] = EMPTY_VALUE;
      }
      if (Lia_16[bars_4] == -1 && Lia_16[bars_4 + 1] == 1) {
         G_ibuf_84[bars_4] = EMPTY_VALUE;
         G_ibuf_88[bars_4] = iHigh(Symbol(), 0, bars_4) + 3.0 * Point;
      }
   }
   WindowRedraw();
   if (Time[0] <= G_time_120 && 1) return (0);
   G_time_120 = Time[0];
   if (Gi_116 <= 0) {
      if (Lia_16[1] == 1 && Lia_16[2] == -1) {
         if (Alert_) Alert(Symbol(), " ", Period(), "MIN Supertrend BUY ");
         Gi_116 = 1;
      }
   }
   if (Gi_116 >= 0) {
      if (Lia_16[1] == -1 && Lia_16[2] == 1) {
         if (Alert_) Alert(Symbol(), " ", Period(), "MIN Supertrend SELL ");
         Gi_116 = -1;
      }
   }
   return (0);
}
