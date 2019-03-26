#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Black
#property indicator_color6 Black

extern string s1 = "General Settings";
extern string s2 = "========================";
extern string s3 = "Alert via sound:";
extern bool Alert.Sound = TRUE;
extern string s4 = "Alert via Email:";
extern bool Alert.Email = FALSE;
int g_period_116 = 45;
double g_ibuf_120[];
double g_ibuf_124[];
double g_ibuf_128[];
double g_ibuf_132[];
double g_ibuf_136[];
double g_ibuf_140[];
int gi_144 = 0;

int init() {
   if (ObjectType("FXUltraLabel") != 23) ObjectDelete("FXUltraLabel");
   if (ObjectFind("FXUltraLabel") == -1) ObjectCreate("FXUltraLabel", OBJ_LABEL, 0, Time[5], Close[5]);
   ObjectSetText("FXUltraLabel", "FXUltraTrend");
   ObjectSet("FXUltraLabel", OBJPROP_XDISTANCE, 20);
   ObjectSet("FXUltraLabel", OBJPROP_YDISTANCE, 20);
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexBuffer(0, g_ibuf_120);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexBuffer(1, g_ibuf_124);
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexBuffer(2, g_ibuf_128);
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexBuffer(3, g_ibuf_132);
   SetIndexEmptyValue(3, 0.0);
   SetIndexStyle(4, DRAW_NONE, STYLE_SOLID, 2, Blue);
   SetIndexBuffer(4, g_ibuf_136);
   SetIndexEmptyValue(4, 0.0);
   SetIndexStyle(5, DRAW_NONE, STYLE_SOLID, 2, Red);
   SetIndexBuffer(5, g_ibuf_140);
   SetIndexEmptyValue(5, 0.0);
   IndicatorShortName("FXUltraTrend");
   return (0);
}

int deinit() {
   ObjectDelete("FXUltraLabel");
   return (0);
}

int start() {
   double l_icci_0;
   double l_icci_8;
   double l_icci_16;
   if (ObjectType("FXUltraLabel") != 23) ObjectDelete("FXUltraLabel");
   if (ObjectFind("FXUltraLabel") == -1) ObjectCreate("FXUltraLabel", OBJ_LABEL, 0, Time[5], Close[5]);
   ObjectSetText("FXUltraLabel", "FXUltraTrend");
   ObjectSet("FXUltraLabel", OBJPROP_XDISTANCE, 20);
   ObjectSet("FXUltraLabel", OBJPROP_YDISTANCE, 20);
   int li_24 = Bars - 11;
   int li_28 = 0;
   RefreshRates();
   for (int li_32 = li_24; li_32 >= 0; li_32--) {
      g_ibuf_120[li_32] = 0.0;
      g_ibuf_124[li_32] = 0.0;
      g_ibuf_128[li_32] = 0.0;
      g_ibuf_132[li_32] = 0.0;
      g_ibuf_136[li_32] = 0.0;
      g_ibuf_140[li_32] = 0.0;
   }
   for (li_32 = li_24; li_32 >= 0; li_32--) {
      li_28 = 0;
      l_icci_0 = iCCI(NULL, 0, g_period_116, PRICE_TYPICAL, li_32);
      l_icci_8 = iCCI(NULL, 0, g_period_116, PRICE_TYPICAL, li_32 + 1);
      l_icci_16 = iCCI(NULL, 0, g_period_116, PRICE_TYPICAL, li_32 + 2);
      if (li_32 == 0 && l_icci_8 >= gi_144 && l_icci_16 < gi_144) li_28 = 1;
      if (li_32 == 0 && l_icci_8 <= gi_144 && l_icci_16 > gi_144) li_28 = -1;
      if (l_icci_0 >= gi_144 && l_icci_8 < gi_144) {
         g_ibuf_120[li_32] = Low[li_32];
         g_ibuf_124[li_32] = High[li_32];
      }
      if (l_icci_0 <= gi_144 && l_icci_8 > gi_144) {
         g_ibuf_128[li_32] = Low[li_32];
         g_ibuf_132[li_32] = High[li_32];
      }
      if (l_icci_0 >= gi_144) {
         g_ibuf_120[li_32] = Low[li_32];
         g_ibuf_124[li_32] = High[li_32];
      } else {
         if (l_icci_0 <= gi_144) {
            g_ibuf_128[li_32] = Low[li_32];
            g_ibuf_132[li_32] = High[li_32];
         }
      }
      if (li_28 == 1) {
         if (Open[0] == Close[0] && Open[0] == Low[0] && Open[0] == High[0]) {
            if (Alert.Sound) Alert("FXUltraTrend: Long signal on " + Symbol() + "!");
            if (Alert.Email) SendMail("FXUltraTrend", "FXUltraTrend: Long signal on " + Symbol() + "!");
         }
      }
      if (li_28 == -1) {
         if (Open[0] == Close[0] && Open[0] == Low[0] && Open[0] == High[0]) {
            if (Alert.Sound) Alert("FXUltraTrend: Short signal on " + Symbol() + "!");
            if (Alert.Email) SendMail("FXUltraTrend: Short Signal", "FXUltraTrend: Short signal on " + Symbol() + "!");
         }
      }
   }
   return (0);
}