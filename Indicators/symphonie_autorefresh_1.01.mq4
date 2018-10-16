#property copyright "coded by Christian Jungen"
#property link      "christian.jungen@gmx.de"
#property indicator_chart_window

#include <WinUser32.mqh>

int hWindow = 0;
int oldBars = 0;

//+------------------------------------------------------------------+
//| indicator initialization function
//+------------------------------------------------------------------+
int init()
{
  hWindow = WindowHandle( Symbol(), Period() );
  oldBars = Bars; // we need that for 

	return (0);
}

//+------------------------------------------------------------------+
//| indicator start function
//+------------------------------------------------------------------+
int start()
{
//  if ( oldBars < Bars && hWindow != 0 )
  if ( hWindow != 0 )
  {
    int message;

    switch( Period() )
    {
      case 1:
        message = 33137;
        break;
      case 5:
        message = 33138;
        break;
      case 15:
        message = 33139;
        break;
      case 30:
        message = 33140;
        break;
      case 60:
        message = 33135;
        break;
      case 240:
        message = 33136;
        break;
      case 1440:
        message = 33134;
        break;
      case 10080:
        message = 33141;
        break;
      default:
        message = 33137; // m1, if we can't identify current TF
        break;
    }

    PostMessageA( hWindow, WM_COMMAND, 33141, 0 ); // switch to weekly TF
    PostMessageA( hWindow, WM_COMMAND, message, 0 ); // switch to original TF
    oldBars = Bars;
  }
	return (0);
}



