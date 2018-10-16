//------------------------------------------------------------------
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property strict

extern int PeriodMiliSeconds=250;  // Period in miliseconds

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void OnInit()                { EventSetMillisecondTimer((int)MathMax(PeriodMiliSeconds,16)); }
void OnDeinit(const int Des) { EventKillTimer();                                             }
int OnCalculate(const int rates_total,const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]  )
{
   return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

#import "user32.dll"
   int RegisterWindowMessageW(string lpString);
   int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
#import
#define WM_COMMAND 0x0111

//
//
//
//
//

void OnTimer()
{
   static bool inUpdate=false;
           if (inUpdate) return;
               inUpdate = true;
       
      //
      //
      //
      //
      //
       
      static int handle =  0; 
              if (handle == 0) handle = RegisterWindowMessageW("MetaTrader4_Internal_Message");
              if (handle != 0)
              {
                  int whandle = WindowHandle(Symbol(), Period());
                     PostMessageW (whandle, WM_COMMAND, 33324, 0);
                     PostMessageW (whandle, handle, 2, 1);
              }             
   inUpdate=false;
}