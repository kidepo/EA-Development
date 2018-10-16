//+------------------------------------------------------------------+
//|                                                  DarvasBoxes.mq4 |
//|                                                           ign... |
//|                                      http://www.blenderar.com.ar |
//+------------------------------------------------------------------+
// 
/*
   version 0.3
   Changelog: Major buxfix! Seeing the indicator i detected that the
   price broke the bottom and the top of the boxes in non apropiate moments.
   This was because a false verification of periods.
   Now the boxes are more real than the olders.
   
   version 0.4
   ChangeLog: This is a better implementation of the Darvas Algorithm method.
*/
#property copyright "ign..."
#property link      "http://www.blenderar.com.ar"

#define SET_BOXTOP      1
#define SAVE_BOXTOP     2
#define SET_BOXBOTTOM   3
#define SAVE_BOXBOTTOM  4
#define WAIT_SIGNAL     5

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 Green
//---- buffers
double ExtMapBuffer1[]; //BoxTop
double ExtMapBuffer2[]; //BoxBottom
double ExtMapBuffer3[]; //Down Arrow
double ExtMapBuffer4[]; // Up arrow

/* TODO: This parameters will serve to use start and end time for each day.
extern int GMTOffset         = 3; //Argentina
extern int LocalTimeOpen     = 10; //US Open
extern int LocalTimeClose    = 19; //US Close
*/
string ShortName;
int    PrevState;
int    State;
double BoxTop;
double BoxBottom;
int    BoxStartPos;
int    BoxEndPos;
int    CurPos;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
datetime x_x;
datetime d_d;
int init()
  {
//---- indicators.
   x_x = 1159190498;
   
   if( 1 || CurTime() < x_x)
   {
   SetIndexStyle(0,DRAW_LINE, EMPTY, 2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE, EMPTY, 2);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_ARROW, EMPTY, 3);
   SetIndexArrow(2, SYMBOL_ARROWDOWN);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_ARROW, EMPTY, 3);
   SetIndexArrow(3, SYMBOL_ARROWUP);
   SetIndexBuffer(3,ExtMapBuffer4);
   
   
   ShortName = "DarvasBoxes-0.1";
   State = SET_BOXTOP;
   PrevState = 0;
   BoxTop = 0.0;
   BoxBottom = 0.0;
   BoxStartPos = 0;
   BoxEndPos = 0;
   CurPos = EMPTY_VALUE;
   
   
   IndicatorShortName(ShortName);
   }
   else
   {
      Alert ("This trial version is expired.\nPlease, contact the developers if you want a new version.");
      return (-1);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars = IndicatorCounted();
   int    pos;
   int    i;
//----
   if( 0 && CurTime() > x_x)
   {
      return (-1);
   }

   if(counted_bars < 0) return(1);
   if(counted_bars > 0) counted_bars--;
   
   pos = Bars - counted_bars;
   if(CurPos == EMPTY_VALUE) CurPos = pos + 1;
   
   while (pos >= 0)
   {
      if(State == WAIT_SIGNAL && PrevState == WAIT_SIGNAL)
         Comment("Darvas Current State: Waiting Signal");
      else
         Comment("State #" + State);
      
      if(CurPos ==pos+1)
      {
         
         CurPos = pos;
         if(State == SET_BOXTOP)
         {
            BoxTop = High[pos+1];
            BoxBottom = Low[pos+1];
            
            if(!PrevState)
            {
               BoxStartPos = pos+1;
            }
            
            PrevState = State;
            State = SAVE_BOXTOP;
         }
         else if( State == SAVE_BOXTOP )
         {
            if(BoxTop < High[pos+1])
            {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];

               if(!PrevState)
               {
                  BoxStartPos = pos+1;
               }

               PrevState = State;
               State = SAVE_BOXTOP;
            }
            else
            {
               PrevState = State;
               State = SET_BOXBOTTOM;
            }
         }
         else if( State == SET_BOXBOTTOM )
         {
            if (BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];
            if(BoxTop < High[pos+1])
            {
               if(BoxTop < High[pos+1])
               {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];

               if(!PrevState)
               {
               BoxStartPos = pos+1;
               }

               PrevState = State;
               State = SAVE_BOXTOP;
               }
               else
               {
               PrevState = State;
               State = SET_BOXBOTTOM;
               }
            }
            else
            {
               PrevState = State;
               State = SAVE_BOXBOTTOM;
            }
         }
         else if( State == SAVE_BOXBOTTOM )
         {
            if(BoxTop < High[pos+1])
            {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];

               if(!PrevState)
               {
                  BoxStartPos = pos+1;
               }

               PrevState = State;
               State = SAVE_BOXTOP;
            }
            else if ( BoxBottom > Low[pos+1] )
            {
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];
               if(BoxTop < High[pos+1])
               {
               if(BoxTop < High[pos+1])
               {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];

               if(!PrevState)
               {
               BoxStartPos = pos+1;
               }

               PrevState = State;
               State = SAVE_BOXTOP;
               }
               else
               {
               PrevState = State;
               State = SET_BOXBOTTOM;
               }
               }
               else
               {
               PrevState = State;
               State = SAVE_BOXBOTTOM;
               }
            }
            else
            {
               //Save BOXBOTTOM
              PrevState = State;
              State = WAIT_SIGNAL;               
            }
         }
         else if( State == WAIT_SIGNAL )
         {
            if(PrevState == SAVE_BOXBOTTOM && BoxTop < High[pos+1])
            {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];
            
               if(!PrevState)
               {
                  BoxStartPos = pos+1;
               }
            
               PrevState = State;
               State = SAVE_BOXTOP;
            }
            else if (PrevState == SAVE_BOXBOTTOM && BoxBottom > Low[pos+1])
            {
            BoxBottom = Low[pos+1];
            if(BoxTop < High[pos+1])
            {
               if(BoxTop < High[pos+1])
               {
               BoxTop = High[pos+1];
               if(BoxBottom > Low[pos+1]) BoxBottom = Low[pos+1];

               if(!PrevState)
               {
               BoxStartPos = pos+1;
               }

               PrevState = State;
               State = SAVE_BOXTOP;
               }
               else
               {
               PrevState = State;
               State = SET_BOXBOTTOM;
               }
            }
            else
            {
               PrevState = State;
               State = SAVE_BOXBOTTOM;
            }
            }
            else
            {
               
               PrevState = State;
               
               if(BoxBottom > Low[pos+1])
               {
                  // Sell Signal
                  PrevState = 0;
                  State = SET_BOXTOP;
               }
               
               
               if(BoxTop < High[pos+1])
               {
                  // Buy Signal
                  PrevState = 0;
                  State = SET_BOXTOP;
               }
               
            }
         }
      }
      draw_boxtop(pos);
      draw_boxbottom(pos);
      pos--;
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void draw_boxtop(int pos)
{
   int i;
   
   for( i = BoxStartPos; i > pos; i--)
   {
      ExtMapBuffer1[i] = BoxTop;
   }
}

void draw_boxbottom(int pos)
{
   int i;
   
   for( i = BoxStartPos; i > pos; i--)
   {
      ExtMapBuffer2[i] = BoxBottom;
   }
}