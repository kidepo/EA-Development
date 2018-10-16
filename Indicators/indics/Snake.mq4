//+------------------------------------------------------------------+
//|                                                        Snake.mq4 |
//|                                      "»Õƒ» ¿“Œ–€ ƒÀﬂ —¿ÃŒŒ¡Ã¿Õ¿" |
//|                           Bookkeeper, 2006, yuzefovich@gmail.com |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White
//+------------------------------------------------------------------+
extern int Snake_HalfCycle=7; // Snake_HalfCycle = 4...10 or other
//+------------------------------------------------------------------+
double Snake_Buffer[];
double Snake_Sum,Snake_Weight,Snake_Sum_Minus,Snake_Sum_Plus;
int Snake_FullCycle;
//----
int init()
  {
   int    draw_begin;
   Snake_FullCycle=Snake_HalfCycle*2+1;
   draw_begin=Snake_FullCycle+1;
   SetIndexDrawBegin(0,draw_begin);
   SetIndexBuffer(0,Snake_Buffer);
   SetIndexStyle(0,DRAW_LINE,0,2);
   return(0);
  }
//----
int start()
  {
   int FirstPos,ExtCountedBars=0;
   if(Bars<=150) return(0);
   if(Snake_HalfCycle<3) Snake_HalfCycle=3;
   ExtCountedBars=IndicatorCounted();
   if(ExtCountedBars<0) return(-1);
   if(ExtCountedBars>0) ExtCountedBars--;
   FirstPos=Bars-ExtCountedBars-1;
   if(FirstPos>Bars-Snake_HalfCycle-1) FirstPos=Bars-Snake_HalfCycle-1;
   Snake(FirstPos);
   return(0);
  }
//----
void Snake(int Pos)
  {
   if(Pos<=Snake_HalfCycle+1) Pos=Snake_HalfCycle+2;
   Snake_Buffer[Pos]=SnakeFirstCalc(Pos);
   Pos--;
   while(Pos>=Snake_HalfCycle)
     {
      Snake_Buffer[Pos]=SnakeNextCalc(Pos);
      Pos--;
     }
   while(Pos>0)
     {
      Snake_Buffer[Pos]=SnakeFirstCalc(Pos);
      Pos--;
     }
   if(Pos==0)
      Snake_Buffer[0]=iMA(NULL,0,Snake_HalfCycle,0,MODE_LWMA,PRICE_TYPICAL,0);
   return;
  }
//----
double SnakePrice(int Shift)
  {
   return((2*Close[Shift]+High[Shift]+Low[Shift])/4);
  }
//----
double SnakeFirstCalc(int Shift)
  {
   int i,j,w;
   Snake_Sum=0.0;
   Snake_Weight=0.0;
   if(Shift<Snake_HalfCycle)
     {
      i=0;
      w=Shift+Snake_HalfCycle;
      while(w>=Shift)
        {
         i++;
         Snake_Sum=Snake_Sum+i*SnakePrice(w);
         Snake_Weight=Snake_Weight+i;
         w--;
        }
      while(w>=0)
        {
         i--;
         Snake_Sum=Snake_Sum+i*SnakePrice(w);
         Snake_Weight=Snake_Weight+i;
         w--;
        }
     }
   else
     {
      Snake_Sum_Minus=0.0;
      Snake_Sum_Plus=0.0;
      for(j=Shift-Snake_HalfCycle,i=Shift+Snake_HalfCycle,w=1;
          w<=Snake_HalfCycle;
          j++,i--,w++)
        {
         Snake_Sum=Snake_Sum+w*(SnakePrice(i)+SnakePrice(j));
         Snake_Weight=Snake_Weight+2*w;
         Snake_Sum_Minus=Snake_Sum_Minus+SnakePrice(i);
         Snake_Sum_Plus=Snake_Sum_Plus+SnakePrice(j);
        }
      Snake_Sum=Snake_Sum+(Snake_HalfCycle+1)*SnakePrice(Shift);
      Snake_Weight=Snake_Weight+Snake_HalfCycle+1;
      Snake_Sum_Minus=Snake_Sum_Minus+SnakePrice(Shift);
     }
   return(Snake_Sum/ Snake_Weight);
  }
//----
double SnakeNextCalc(int Shift)
  {
   Snake_Sum_Plus=Snake_Sum_Plus+SnakePrice(Shift-Snake_HalfCycle);
   Snake_Sum=Snake_Sum-Snake_Sum_Minus+Snake_Sum_Plus;
   Snake_Sum_Minus=Snake_Sum_Minus-SnakePrice(Shift+Snake_HalfCycle+1)+SnakePrice(Shift);
   Snake_Sum_Plus=Snake_Sum_Plus-SnakePrice(Shift);
   return(Snake_Sum/Snake_Weight);
  }
//----
