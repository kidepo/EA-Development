#property copyright "BB_AlertArrows.mq4"
#property link      "Copyright ©2010, admin@forexstrategiesbinaryoptions.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Yellow

extern int SignalGap = 3;
extern bool EnableSoundAlert = TRUE;
extern bool EnableMailAlert = FALSE;
int Gi_88 = 24;
double G_ibuf_92[];
double G_ibuf_96[];
int G_bars_100;
int G_count_104;
bool Gi_108;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexArrow(1, 233);
   SetIndexArrow(0, 234);
   SetIndexBuffer(0, G_ibuf_92);
   SetIndexBuffer(1, G_ibuf_96);
   G_bars_100 = Bars;
   G_count_104 = 0;
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int highest_20;
   int lowest_24;
   int Li_0 = IndicatorCounted();
   if (Li_0 < 0) return (-1);
   if (Li_0 > 0) Li_0--;
   int Li_16 = Bars - 1;
   if (Li_0 >= 1) Li_16 = Bars - Li_0 - 1;
   if (Li_16 < 0) Li_16 = 0;
   for (int Li_8 = Li_16; Li_8 >= 0; Li_8--) {
      highest_20 = iHighest(NULL, 0, MODE_HIGH, Gi_88, Li_8 - Gi_88 / 2);
      lowest_24 = iLowest(NULL, 0, MODE_LOW, Gi_88, Li_8 - Gi_88 / 2);
      if (Li_8 == highest_20) G_ibuf_92[Li_8] = High[highest_20] + SignalGap * Point;
      if (Li_8 == lowest_24) G_ibuf_96[Li_8] = Low[lowest_24] - SignalGap * Point;
   }
   Gi_108 = f0_1();
   if (Gi_108) G_count_104 = 0;
   if (G_count_104 == 0) {
      if (EnableSoundAlert) {
         if (G_ibuf_92[0] != EMPTY_VALUE && G_ibuf_92[0] > 0.0) {
            Alert(TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BB_Alert Arrows sell " + Symbol() + " " + f0_0(Period()));
            G_count_104++;
            if (EnableMailAlert) {
               SendMail(TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BO_Alert Arrows sell " + Symbol() + " " + f0_0(Period()), TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BO_Alert Arrows sell " + //Angel4x
                  Symbol() + " " + f0_0(Period()));
            }
         }
         if (G_ibuf_96[0] != EMPTY_VALUE && G_ibuf_96[0] > 0.0) {
            Alert(TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BB_Alert Arrows buy " + Symbol() + " " + f0_0(Period()));
            G_count_104++;
            SendMail(TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BB_Alert Arrows buy " + Symbol() + " " + f0_0(Period()), TimeToStr(Time[0], TIME_DATE|TIME_MINUTES) + " BO_Alert Arrows buy " +
               Symbol() + " " + f0_0(Period()));
         }
      }
   }
   return (0);
}

// DBF842DBCEACF4840EBF7C9B65F53790
int f0_1() {
   bool Li_ret_0 = FALSE;
   if (G_bars_100 != Bars) {
      Li_ret_0 = TRUE;
      G_bars_100 = Bars;
   }
   return (Li_ret_0);
}

// B69AE6435CA312EDB19A3B43ADC42BDE
string f0_0(int Ai_0) {
   if (Ai_0 == 1) return ("M1");
   if (Ai_0 == 5) return ("M5");
   if (Ai_0 == 15) return ("M15");
   if (Ai_0 == 30) return ("M30");
   if (Ai_0 == 60) return ("H1");
   if (Ai_0 == 240) return ("H4");
   if (Ai_0 == 1440) return ("D1");
   if (Ai_0 == 10080) return ("W1");
   if (Ai_0 == 43200) return ("MN1");
   return ("");
}
