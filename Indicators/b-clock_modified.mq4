//+------------------------------------------------------------------+
//|                                                      b-clock.mq4 |
//|                                     Core time code by Nick Bilak |
//|        http://metatrader.50webs.com/         beluck[at]gmail.com |
//|                                  modified by adoleh2000 and dwt5 | 
//+------------------------------------------------------------------+

#property copyright "Copyright © 2005, Nick Bilak"
#property link      "http://metatrader.50webs.com/"

#property indicator_chart_window
//----
extern color BClockClr = Gray;
extern bool ShowComment = True;
//---- buffers
double s1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
    return(0);   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
	 double i;
    int m, s, k;
    string ss, tiempo;
    m = Time[0] + Period()*60 - CurTime();
    i = m / 60.0;
    s = m % 60;
    m = (m - m % 60) / 60;
    ss = s;
    if (s < 10) { ss = "0" + s; }  
    tiempo = "               < " + m + ":" + ss;  
    if (ShowComment == true) {
      Comment(m + " minutes " + ss + " seconds left to bar end");
    }
    
    ObjectDelete("time");   
//----
    if(ObjectFind("time") != 0)
      {
        ObjectCreate("time", OBJ_TEXT, 0, Time[0], Close[0] + 0.000);
        ObjectSetText("time",tiempo, 8, "Verdana", BClockClr); 
      }
    else
      {
        ObjectMove("time", 0, Time[0], Close[0] + 0.0005);
      }
    return(0);
  }
//+------------------------------------------------------------------+


