//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "www,forex-tsd.com"
#property link      "www,forex-tsd.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 DeepSkyBlue
#property indicator_color2 PaleVioletRed
#property indicator_color3 DeepSkyBlue
#property indicator_color4 PaleVioletRed
#property indicator_width3 3
#property indicator_width4 3

//
//
//
//
//

extern int    Price           = 0;
extern double SmoothLength    = 10;
extern double SmoothPhase     = 0;
extern bool   SmoothDouble    = true;
extern int    AtrLength       = 10; 
extern double Kv              = 4;  
extern double MoneyRisk       = 1; 
extern int    VisualMode      = 1;  

//
//
//
//
//

double UpLine[];
double DnLine[]; 
double UpArrow[];
double DnArrow[]; 
double smax[];
double smin[];
double trend[];

//
//
//
//
//

int init()
{
   IndicatorBuffers(7);
      SetIndexBuffer(0,UpLine);  
      SetIndexBuffer(1,DnLine);  
      SetIndexBuffer(2,UpArrow); 
      SetIndexBuffer(3,DnArrow); 
      SetIndexBuffer(4,smax);
      SetIndexBuffer(5,smin);
      SetIndexBuffer(6,trend);
      
      if(VisualMode==0)
      {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexStyle(1,DRAW_LINE);
      }
      else
      {
      SetIndexStyle(0,DRAW_ARROW);SetIndexArrow(0,159);
      SetIndexStyle(1,DRAW_ARROW);SetIndexArrow(1,159);
      }
      SetIndexStyle(2,DRAW_ARROW);SetIndexArrow(2,108);
      SetIndexStyle(3,DRAW_ARROW);SetIndexArrow(3,108);
      
      //
      //
      // 
      //
      //
      
      IndicatorShortName("Volty Channel Stop");
      return(0);
}
      
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

   //
   //
   //
   //
   //
   
   for(i=limit; i>=0; i--)
   { 
   
         if(Price==2 || Price==3)
         {
         double bprice = iDSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_HIGH,i),SmoothLength,SmoothPhase,SmoothDouble,i, 0);
         double sprice = iDSmooth(iMA(NULL,0,1,0,MODE_SMA,PRICE_LOW, i),SmoothLength,SmoothPhase,SmoothDouble,i,20);
         }
         else
         {
         bprice = iDSmooth(iMA(NULL,0,1,0,MODE_SMA,Price,i),SmoothLength,SmoothPhase,SmoothDouble,i, 0);
         sprice = iDSmooth(iMA(NULL,0,1,0,MODE_SMA,Price,i),SmoothLength,SmoothPhase,SmoothDouble,i,20);
         }
         smin[i]    = sprice - Kv * iATR(NULL,0,AtrLength,i); 
	      smax[i]    = bprice + Kv * iATR(NULL,0,AtrLength,i);
         UpLine[i]  = EMPTY_VALUE;
         DnLine[i]  = EMPTY_VALUE;
         UpArrow[i] = EMPTY_VALUE;
         DnArrow[i] = EMPTY_VALUE;
         trend[i]   = trend[i+1]; 
   
         //
         //
         //
         //
         //
         
	      if (bprice > smax[i+1]) trend[i] =  1;
         if (sprice < smin[i+1]) trend[i] = -1;
	      if (trend[i] > 0 && smin[i] < smin[i+1]) smin[i] = smin[i+1];
	      if (trend[i] < 0 && smax[i] > smax[i+1]) smax[i] = smax[i+1];
         if (trend[i] == 1)
            {  
               UpLine[i] = smin[i] - (MoneyRisk - 1) * iATR(NULL,0,AtrLength,i); if (trend[i+1]!= 1) UpArrow[i] = UpLine[i];
            }
         if (trend[i] ==-1)
            {  
               DnLine[i] = smax[i] + (MoneyRisk - 1) * iATR(NULL,0,AtrLength,i); if (trend[i+1]!=-1) DnArrow[i] = DnLine[i];
            }
      }
      
      return(0);
      }

//
//
//
//
//

double wrk[][40];

#define bsmax  5
#define bsmin  6
#define volty  7
#define vsum   8
#define avolty 9

//
//
//
//
//

double iDSmooth(double price, double length, double phase, bool isDouble, int i, int s=0)
{
   if (isDouble)
         return (iSmooth(iSmooth(price,MathSqrt(length),phase,i,s),MathSqrt(length),phase,i,s+10));
   else  return (iSmooth(price,length,phase,i,s));
}

//
//
//
//
//

double iSmooth(double price, double length, double phase, int i, int s=0)
{
   if (length <=1) return(price);
   if (ArrayRange(wrk,0) != Bars) ArrayResize(wrk,Bars);
   
   int r = Bars-i-1; 
      if (r==0) { for(int k=0; k<7; k++) wrk[r][k+s]=price; for(; k<10; k++) wrk[r][k+s]=0; return(price); }

   //
   //
   //
   //
   //
   
      double len1   = MathMax(MathLog(MathSqrt(0.5*(length-1)))/MathLog(2.0)+2.0,0);
      double pow1   = MathMax(len1-2.0,0.5);
      double del1   = price - wrk[r-1][bsmax+s];
      double del2   = price - wrk[r-1][bsmin+s];
      double div    = 1.0/(10.0+10.0*(MathMin(MathMax(length-10,0),100))/100);
      int    forBar = MathMin(r,10);
	
         wrk[r][volty+s] = 0;
               if(MathAbs(del1) > MathAbs(del2)) wrk[r][volty+s] = MathAbs(del1); 
               if(MathAbs(del1) < MathAbs(del2)) wrk[r][volty+s] = MathAbs(del2); 
         wrk[r][vsum+s] =	wrk[r-1][vsum+s] + (wrk[r][volty+s]-wrk[r-forBar][volty+s])*div;
         
         //
         //
         //
         //
         //
   
         wrk[r][avolty+s] = wrk[r-1][avolty+s]+(2.0/(MathMax(4.0*length,30)+1.0))*(wrk[r][vsum+s]-wrk[r-1][avolty+s]);
            if (wrk[r][avolty+s] > 0)
               double dVolty = wrk[r][volty+s]/wrk[r][avolty+s]; else dVolty = 0;   
	               if (dVolty > MathPow(len1,1.0/pow1)) dVolty = MathPow(len1,1.0/pow1);
                  if (dVolty < 1)                      dVolty = 1.0;

      //
      //
      //
      //
      //
	        
   	double pow2 = MathPow(dVolty, pow1);
      double len2 = MathSqrt(0.5*(length-1))*len1;
      double Kv   = MathPow(len2/(len2+1), MathSqrt(pow2));

         if (del1 > 0) wrk[r][bsmax+s] = price; else wrk[r][bsmax+s] = price - Kv*del1;
         if (del2 < 0) wrk[r][bsmin+s] = price; else wrk[r][bsmin+s] = price - Kv*del2;
	
   //
   //
   //
   //
   //
      
      double R     = MathMax(MathMin(phase,100),-100)/100.0 + 1.5;
      double beta  = 0.45*(length-1)/(0.45*(length-1)+2);
      double alpha = MathPow(beta,pow2);

         wrk[r][0+s] = price + alpha*(wrk[r-1][0+s]-price);
         wrk[r][1+s] = (price - wrk[r][0+s])*(1-beta) + beta*wrk[r-1][1+s];
         wrk[r][2+s] = (wrk[r][0+s] + R*wrk[r][1+s]);
         wrk[r][3+s] = (wrk[r][2+s] - wrk[r-1][4+s])*MathPow((1-alpha),2) + MathPow(alpha,2)*wrk[r-1][3+s];
         wrk[r][4+s] = (wrk[r-1][4+s] + wrk[r][3+s]); 

   //
   //
   //
   //
   //

   return(wrk[r][4+s]);
}