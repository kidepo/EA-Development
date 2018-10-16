//+-----------------------------------------------------------------+
//+           Spearman,Rosh Bookkeeper, 2007, yuzefovich@gmail.com  +
//+           Leledc:added MaBuffer,alerts                          +
//+                                                                 +
//+-----------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers  6
#property indicator_color1   Lime
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2
#property indicator_color3 DodgerBlue
#property indicator_width3 1
#property indicator_color4 Magenta
#property indicator_width4 1
#property indicator_color5 White
#property indicator_width5 1
#property indicator_color6 White
#property indicator_width6 1
#property indicator_maximum 1.1
#property indicator_minimum -1.1
//---- input parameters
//---- Snake 
extern int    SnakeRange   =13; 
extern int    FilterPeriod =21; 
extern double MartFiltr    =2;
extern int    PriceConst   =6; 
extern int MaPeriod=5;
extern int MaMode=3;
extern double LevelsCross=0.95;
extern int Countbars=300;
extern bool   AlertOn=false;
extern int    ArrowUp=108;
extern int    ArrowDown=108;
                               
//---- buffers
double SRCBuffer[];
double Axis[];
double Mart[];
double Ma[];
double Up[],Down[];
double Up2[],Down2[];

//---- SpearmanRankCorrelation
int    rangeN = 14; //   = 30 maximum
double R2[];
double multiply;
int    PriceInt[];
int    SortInt[];
bool TurnedUp = false;
bool TurnedDown = false;


int init() { 
    IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));

IndicatorBuffers(8);
SetIndexBuffer(0,SRCBuffer); 
SetIndexStyle(0,DRAW_LINE);
SetIndexBuffer(1,Ma); 
SetIndexStyle(1,DRAW_LINE);
SetIndexBuffer(2,Up); 
SetIndexStyle(2,DRAW_ARROW);
SetIndexBuffer(3,Down); 
SetIndexStyle(3,DRAW_ARROW);
SetIndexArrow(2,ArrowUp);
SetIndexArrow(3,ArrowDown);
SetIndexBuffer(4,Up2); 
SetIndexStyle(4,DRAW_ARROW);
SetIndexBuffer(5,Down2); 
SetIndexStyle(5,DRAW_ARROW);

SetIndexBuffer(6,Axis); 
SetIndexStyle(6,DRAW_NONE);
SetIndexBuffer(7,Mart); 
SetIndexStyle(7,DRAW_NONE);
SetLevelValue(0,LevelsCross);
SetLevelValue(1,-LevelsCross);
SetLevelValue(2,0);

ArrayResize(R2,rangeN);
 ArrayResize(PriceInt,rangeN);
ArrayResize(SortInt,rangeN);
IndicatorShortName(WindowExpertName()+"( SR:"+SnakeRange+", FP:"+FilterPeriod+", MA:"+MaPeriod+" )");
multiply=MathPow(10,Digits); 
return(0); 

}
//+------------------------------------------------------------------+
int deinit() { 
return(0);
 }
//+------------------------------------------------------------------+
int start() {
   SetIndexDrawBegin(0,Bars-Countbars);
   SetIndexDrawBegin(1,Bars-Countbars);
   SetIndexDrawBegin(2,Bars-Countbars);
   SetIndexDrawBegin(3,Bars-Countbars);
   SetIndexDrawBegin(4,Bars-Countbars);
   SetIndexDrawBegin(5,Bars-Countbars);
 
int i,k,limit,limit2;
int LastSignal;
 int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
   return(-1);
    if(counted_bars > 0) 
   limit=Bars-counted_bars;
   if(counted_bars== 0)
   limit=Bars-SnakeRange-1; 
  if (i> limit2) 
   limit2= i;    
   if (limit2 <Countbars-1 )
   limit =Countbars-1;   
for(i=0;i<limit;i++) {
   Up[i]=EMPTY_VALUE;
Down[i]=EMPTY_VALUE;
Up2[i]=EMPTY_VALUE;
Down2[i]=EMPTY_VALUE;
SRCBuffer[i]=EMPTY_VALUE;
Ma[i]=EMPTY_VALUE;
}
for(i=0;i<limit;i++) 

MartAxis(i);
for(i=0;i<limit;i++) 
 SmoothOverMart(i);

 for(i=limit;i>=0;i--)   { 
 for(k=0;k<rangeN;k++)

  PriceInt[k]=MathRound(Mart[i+k]*multiply);
  RankPrices(PriceInt);
  SRCBuffer[i]=SpearmanRankCorrelation(R2,rangeN);
  if(SRCBuffer[i]>1.0)
   SRCBuffer[i]=1.0; 
  if(SRCBuffer[i]<-1.0)
   SRCBuffer[i]=-1.0;
  }
 for(i=limit;i>=0;i--)
  { 

  Ma[i]=iMAOnArray(SRCBuffer,0,MaPeriod,0,MaMode,i);
  
  }
   for(i=limit;i>=0;i--)
  { 
  if (SRCBuffer[i]>Ma[i]  && SRCBuffer[i]>-LevelsCross && SRCBuffer[i]<0&& Ma[i]<0&& i!=0 && LastSignal!=1){
   LastSignal=1;
  Up[i]=SRCBuffer[i];
    Down[i]=EMPTY_VALUE;

   if  (AlertOn   && i==1 && !TurnedUp )
           { 
            Alert(WindowExpertName()+" is crossing UP on"+" "+Symbol()," ",Period()+" "+"minute charts");
            TurnedUp = true;
            TurnedDown = false;
     }
  }
  else if 
  (SRCBuffer[i]<Ma[i]&& SRCBuffer[i]<LevelsCross&& SRCBuffer[i]>0&& Ma[i]>0&& i!=0 && LastSignal!=-1){
     LastSignal=-1;

  Down[i]=SRCBuffer[i];
  Up[i]=EMPTY_VALUE;
  if  (AlertOn  &&  i==1 &&!TurnedDown )
           { 
            Alert(WindowExpertName()+" is crossing DOWN on"+" "+Symbol()," ",Period()+" "+"minute charts");
                      
             TurnedUp =false ;
            TurnedDown = true;
     }       
  }
  }
   for(i=limit;i>=0;i--)
  { 

    if (SRCBuffer[i]>Ma[i]  && Ma[i]>-LevelsCross && SRCBuffer[i]<0&& Ma[i]<0&& i!=0 && LastSignal!=1){
   LastSignal=1;
  Up2[i]=SRCBuffer[i];
    Down2[i]=EMPTY_VALUE;
}
else if 
  (SRCBuffer[i]<Ma[i]&& Ma[i]<LevelsCross&& SRCBuffer[i]>0&& Ma[i]>0&& i!=0 && LastSignal!=-1){
     LastSignal=-1;

  Down2[i]=SRCBuffer[i];
  Up2[i]=EMPTY_VALUE;
  }
  }
    if (i> limit2) 
   limit2= i;

return(0);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void MartAxis(int Pos) { int SnakeWeight,i,w,ww,Shift;double SnakeSum;
switch(PriceConst) {
case  0: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_CLOSE,Pos);
  break;
case  1: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_OPEN,Pos);
  break;
case  2: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_HIGH,Pos);
  break;
case  3: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_LOW,Pos);
  break;
case  4: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_MEDIAN,Pos);
  break;
case  5: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_TYPICAL,Pos);
  break;
case  6: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_WEIGHTED,Pos);
  break;
default: 
  Axis[Pos]=iMA(NULL,0,SnakeRange+1,0,MODE_LWMA,PRICE_WEIGHTED,Pos);
  break; }
for(Shift=Pos+SnakeRange+2;Shift>Pos;Shift--) { SnakeSum=0.0;
SnakeWeight=0; i=0; w=Shift+SnakeRange; ww=Shift-SnakeRange;
if(ww<Pos) ww=Pos;
while(w>=Shift) { i++; SnakeSum=SnakeSum+i*SnakePrice(w); 
SnakeWeight=SnakeWeight+i; w--; }
while(w>=ww) { i--; SnakeSum=SnakeSum+i*SnakePrice(w);
SnakeWeight=SnakeWeight+i; w--; }
Axis[Shift]=SnakeSum/SnakeWeight; } return; }
//----
double SnakePrice(int Shift) {
switch(PriceConst) {
   case  0: return(Close[Shift]);
   case  1: return(Open[Shift]);
   case  2: return(High[Shift]);
   case  3: return(Low[Shift]);
   case  4: return((High[Shift]+Low[Shift])/2);
   case  5: return((Close[Shift]+High[Shift]+Low[Shift])/3);
   case  6: return((2*Close[Shift]+High[Shift]+Low[Shift])/4);
   default: return(Close[Shift]); } }
//+------------------------------------------------------------------+
void SmoothOverMart(int Shift) { double t,b;
t=Axis[ArrayMaximum(Axis,FilterPeriod,Shift)];
b=Axis[ArrayMinimum(Axis,FilterPeriod,Shift)];
Mart[Shift]=(2*(2+MartFiltr)*Axis[Shift]-(t+b))/2/(1+MartFiltr);
return; }
//+------------------------------------------------------------------+
//| calculate  RSP  function                                         |
//+------------------------------------------------------------------+
double SpearmanRankCorrelation(double Ranks[], int N)
  {
//----
   double res,z2;
   int i;
   for(i = 0; i < N; i++)
     {
       z2 += MathPow(Ranks[i] - i - 1, 2);
     }
   res = 1 - 6*z2 / (MathPow(N,3) - N);
//----
   return(res);
  }
//+------------------------------------------------------------------+
//| Ranking array of prices function                                 |
//+------------------------------------------------------------------+
void RankPrices(int InitialArray[])
  {
//----
   int i, k, m, dublicat, counter, etalon;
   double dcounter, averageRank;
   double TrueRanks[];
   ArrayResize(TrueRanks, rangeN);
   ArrayCopy(SortInt, InitialArray);
   for(i = 0; i < rangeN; i++) 
       TrueRanks[i] = i + 1;
  // if(direction)
       ArraySort(SortInt, 0, 0, MODE_DESCEND);
  // else
    //   ArraySort(SortInt, 0, 0, MODE_ASCEND);
   for(i = 0; i < rangeN-1; i++)
     {
       if(SortInt[i] != SortInt[i+1]) 
           continue;
       dublicat = SortInt[i];
       k = i + 1;
       counter = 1;
       averageRank = i + 1;
       while(k < rangeN)
         {
           if(SortInt[k] == dublicat)
             {
               counter++;
               averageRank += k + 1;
               k++;
             }
           else
               break;
         }
       dcounter = counter;
       averageRank = averageRank / dcounter;
       for(m = i; m < k; m++)
           TrueRanks[m] = averageRank;
       i = k;
     }
   for(i = 0; i < rangeN; i++)
     {
       etalon = InitialArray[i];
       k = 0;
       while(k < rangeN)
         {
           if(etalon == SortInt[k])
             {
               R2[i] = TrueRanks[k];
               break;
             }
           k++;
         }
     }
//----
   return;
  }
//+------------------------------------------------------------------+

/*
int Tma(int Tma){
int limit,j,k,i;
 for (i=limit; i>=0; i--)
   {
      double sum  = (rangeN+1)*iMA(NULL,0,1,0,MODE_SMA,0,i);
      double sumw = (rangeN+1);
      for(j=1, k=rangeN; j<=rangeN; j++, k--)
      {
         sum  += k*iMA(NULL,0,1,0,MODE_SMA,0,i+j);
         sumw += k;

         if (j<=i)
         {
            sum  += k*iMA(NULL,0,1,0,MODE_SMA,0,i-j);
            sumw += k;
         }
      }
      
            Tma = sum/sumw;
      
   }



}*/
//+------------------------------------------------------------------+