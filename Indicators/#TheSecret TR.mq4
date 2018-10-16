/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  H T T P: / / www. M etA Quo Tes. NeT
   E-mail : sup p or t@ME T aQUOT e s .N E t
*/
#property copyright "Martin Lemire, phover "
#property link      "mlemire12@videotron.ca "

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 0.2
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 Crimson

string Gs_unused_76 = "TheSecretTR";
extern int ADX_period = 20;
extern int MOM_period = 20;
extern int MACD_fast_ema = 5;
extern int MACD_slow_ema = 15;
extern int MACD_signal_period = 9;
extern int MaxBarsOnGraph = 500;
double G_ibuf_108[];
double G_ibuf_112[];
double Gda_116[];
double Gda_120[];
double Gda_124[];
double Gda_128[];
double Gda_132[];
double Gda_136[];
double G_iadx_140;
double G_iadx_148;
double G_iadx_156;
double G_imomentum_164;
double G_imacd_172;
int G_bars_180;
int Gi_184;
int Gi_188;
int Gi_196;
int Gi_200;
int Gi_204;
int Gi_208;
int G_datetime_228;
int G_datetime_232;
int G_datetime_236;
int Gi_unused_240;
int Gi_244 = 0;
int Gi_248;
int Gi_256;
int Gi_unused_260 = -1;
string Gs_dummy_264;
string Gs_272 = "TheSecret Trend Reversal";
string Gs_dummy_280;

int init() {
   IndicatorShortName(Gs_272);
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 0);
   SetIndexArrow(0, 108);
   SetIndexBuffer(0, G_ibuf_108);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID, 0);
   SetIndexArrow(1, 108);
   SetIndexBuffer(1, G_ibuf_112);
   SetIndexEmptyValue(0, 0);
   SetIndexEmptyValue(1, 0);
   G_datetime_228 = 0;
   G_datetime_232 = 0;
   G_datetime_236 = 0;
   Gi_unused_240 = 0;
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   Gi_244++;
   Gi_248 = IndicatorCounted();
   if (Gi_248 < 0) return (-1);
   Gi_256 = WindowFind(Gs_272);
   if (G_bars_180 != Bars) NewBar();
   if (Gi_248 > 0) Gi_248--;
   Gi_184 = G_bars_180 - Gi_248 - 1;
   if (Gi_184 > MaxBarsOnGraph) Gi_184 = MaxBarsOnGraph;
   for (Gi_188 = Gi_184 - 1; Gi_188 >= 0; Gi_188--) {
      G_iadx_140 = iADX(NULL, 0, ADX_period, PRICE_CLOSE, MODE_PLUSDI, Gi_188);
      G_iadx_148 = iADX(NULL, 0, ADX_period, PRICE_CLOSE, MODE_MINUSDI, Gi_188);
      G_iadx_156 = iADX(NULL, 0, ADX_period, PRICE_CLOSE, MODE_MAIN, Gi_188);
      G_imomentum_164 = iMomentum(NULL, 0, MOM_period, PRICE_CLOSE, Gi_188);
      G_imacd_172 = iMACD(NULL, 0, MACD_fast_ema, MACD_slow_ema, MACD_signal_period, PRICE_CLOSE, MODE_MAIN, Gi_188);
      if (G_iadx_140 >= G_iadx_148) {
         Gda_116[Gi_188] = 0.1;
         if (Gi_196 == -1 || Gi_196 == 0) {
            Gi_196 = 1;
            G_datetime_228 = TimeCurrent();
         }
      }
      if (G_iadx_140 < G_iadx_148) {
         Gda_120[Gi_188] = 0.1;
         if (Gi_196 == 1 || Gi_196 == 0) {
            Gi_196 = -1;
            G_datetime_228 = TimeCurrent();
         }
      }
      if (G_imomentum_164 >= 100.0) {
         Gda_124[Gi_188] = 0.3;
         if (Gi_200 == -1 || Gi_200 == 0) {
            Gi_200 = 1;
            G_datetime_232 = TimeCurrent();
         }
      }
      if (G_imomentum_164 < 100.0) {
         Gda_128[Gi_188] = 0.3;
         if (Gi_200 == 1 || Gi_200 == 0) {
            Gi_200 = -1;
            G_datetime_232 = TimeCurrent();
         }
      }
      if (G_imacd_172 >= 0.0) {
         Gda_132[Gi_188] = 0.5;
         if (Gi_204 == -1 || Gi_204 == 0) {
            Gi_204 = 1;
            G_datetime_236 = TimeCurrent();
         }
      }
      if (G_imacd_172 < 0.0) {
         Gda_136[Gi_188] = 0.5;
         if (Gi_204 == 1 || Gi_204 == 0) {
            Gi_204 = -1;
            G_datetime_236 = TimeCurrent();
         }
      }
      if (Gi_196 == 1 && Gi_200 == 1 && Gi_204 == 1) Gi_208 = 1;
      if (Gi_196 == -1 && Gi_200 == -1 && Gi_204 == -1) Gi_208 = -1;
      if (Gi_208 == 1) G_ibuf_108[Gi_188] = 0.08;
      else G_ibuf_112[Gi_188] = 0.08;
   }
   WindowRedraw();
   return (0);
}

void NewBar() {
   G_bars_180 = Bars;
   Gi_248++;
}
