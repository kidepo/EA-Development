//+------------------------------------------------------------------+
//|                                                e4_bibuka_1.1.mq4 |
//|                                                          valeryk |
//|                          https://login.mql5.com/ru/users/valeryk |
//+------------------------------------------------------------------+
#property copyright "valeryk"
#property link      "https://login.mql5.com/ru/users/valeryk"
#property version   "1.00"
#property strict
#define miz 0.00000001
#define EV  EMPTY_VALUE
//+------------------------------------------------------------------+
input int             Step = 200;
input int          Tprofit = 200;          // Тейкпрофит, 0 = откл.
input double           Lot = 0.01;         // Лот.
input bool      UseAutoDig = false;        // true = в старых пунктах.
input color         BayCol = clrLawnGreen; // Бай, NONE = по умолчанию.
input color         SelCol = clrOrangeRed; // Сел, NONE = по умолчанию.
input int            Magic = 104830;       // Маджик, не более 6 цифр.
input int           NamTry = 2;            // Количество попыток.
input int          Slipage = 10;           // Проскальзывание.
input string           Com = "e4_bibuka_1.1"; // Комментарий к ордерам советника.
input bool        ShowInfo = true;         // Отображать информацию.
input color           Gcol = clrGold;      // Позитивные показатели.
input color           Fcol = clrRed;       // Негативные показатели.
input int             Size = 8;            // Размер шрифта.
input int                X = 150;          // Дистанция по горизонтали для текста.
input int                Y = 20;           // Дистанция по вертикали для текста.
input string          Font = "Verdana";    // Шрифт.
input ENUM_BASE_CORNER Cor = 2;            // Угол привязки инфо.
//+------------------------------------------------------------------+
string textcom,prevtextcom;
datetime time;
int ydist=0,dig,slipag;
double lotstep,minlot,maxlot;
bool first,opnovis,useECNNDD;
//+------------------------------------------------------------------+
int OnInit()
  {
   time=TimeCurrent();
   first=true;
   prevtextcom="";
   if(ydist==0)ydist=Y;
   lotstep=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   minlot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   maxlot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   switch(int(SymbolInfoInteger(_Symbol,SYMBOL_TRADE_EXEMODE)))
     {case SYMBOL_TRADE_EXECUTION_MARKET:useECNNDD=true;slipag=0;break;default:useECNNDD=false;slipag=Slipage;break;}
   if(UseAutoDig){if(Digits==3 || Digits==5 || Digits==1)dig=10;else dig=1;}else dig=1;
   if(IsOptimization() || (IsTesting() && !IsVisualMode())){opnovis=false;}else opnovis=true;
   if(!IsOptimization() && !IsTesting())EventSetTimer(1);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void ObjButton(string name,int x,int y,int width,int height,string text,string font,int size,bool flag,
               color col,color clr=clrNONE,color border=clrNONE)
  {
   if(!opnovis)return;
   if(ObjectFind(name)<0)
     {
      if(!ObjectCreate(0,name,OBJ_BUTTON,0,0,0))return;
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_CORNER,1);
      ObjectSetString(0,name,OBJPROP_FONT,font);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0);     
     }
   ObjectSetString(0,name,OBJPROP_TEXT,text);//установим текст
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);//установим цвет текста
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clr);// установим цвет фона
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,border);// установим цвет границы  
   ObjectSetInteger(0,name,OBJPROP_STATE,flag);
   ChartRedraw();
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return;
  }
//+------------------------------------------------------------------+
void SetInt(string name,int id,long par,bool fl=false)
  {
   if(opnovis && ObjectFind(name)>-1)ObjectSetInteger(0,name,id,par);
   if(fl)ChartRedraw();
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
long GetInt(string name,int id)
  {
   long res=0;
   if(opnovis && ObjectFind(name)>-1)res=ObjectGetInteger(0,name,id);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
double GetDou(string name,int id)
  {
   double res=0.0;
   if(opnovis && ObjectFind(name)>-1)res=ObjectGetDouble(0,name,id);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
void OnTick()
  {
   time=TimeCurrent(); //if(time>StrToTime("2014.07.05 00:00")){Comment("Время демонстрации истекло.");return;}
   textcom="";
   double Ord[][12];
   Orders(Ord);
   if(first)
     {
      Info(Ord);
      if(ObjectFind(Com+"ButtB")<0)ObjButton(Com+"ButtB",Size*11,Size*8,Size*10,Size*3,"Start Buy?",Font,int(Size*1.2),false,Gcol,Fcol,Gcol);
      if(ObjectFind(Com+"ButtS")<0)ObjButton(Com+"ButtS",Size*11,Size*12,Size*10,Size*3,"Start Sell?",Font,int(Size*1.2),false,Gcol,Fcol,Gcol);
     }
   bool But[]={false,false};
   if(opnovis)
     {
      But[0]=GetInt(Com+"ButtB",OBJPROP_STATE);
      But[1]=GetInt(Com+"ButtS",OBJPROP_STATE);
      if(But[0])ObjButton(Com+"ButtB",Size*11,Size*8,Size*10,Size*3,"Stop Buy?",Font,int(Size*1.2),true,Fcol,Gcol,Fcol);
      else ObjButton(Com+"ButtB",Size*11,Size*8,Size*10,Size*3,"Start Buy?",Font,int(Size*1.2),false,Gcol,Fcol,Gcol); 
      if(But[1])ObjButton(Com+"ButtS",Size*11,Size*12,Size*10,Size*3,"Stop Sell?",Font,int(Size*1.2),true,Fcol,Gcol,Fcol);
      else ObjButton(Com+"ButtS",Size*11,Size*12,Size*10,Size*3,"Start Sell?",Font,int(Size*1.2),false,Gcol,Fcol,Gcol);
     } 
   //---
   int i=0,step=Step*dig;
   for(i=0;i<2;i++)
     {
      if(!But[i])continue;
      double pr=ValO(Ord,8,1,1,i);
      switch(i){case 0:pr=Ask;break;case 1:pr=Bid;break;}
      if(!FreePr(Ord,pr,step,i))continue;
      if(Op(i,Lot,pr,0,Tprofit*dig))Orders(Ord);
     }
   SLTP(Ord,0,Tprofit*dig,10);
   Info(Ord);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   if(textcom!="" && textcom!=prevtextcom){Print(textcom);if(opnovis)Comment(textcom);prevtextcom=textcom;}
   if(first)first=false;
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // идентификатор события  
                  const long& lparam,   // параметр события типа long
                  const double& dparam, // параметр события типа double
                  const string& sparam) // параметр события типа string
  {
   if(first && id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam==Com+"ButtB" || sparam==Com+"ButtS")OnTick();
     }
  }  
//+------------------------------------------------------------------+
void OnTimer()
  {
   string txt="";
   if(!TerminalInfoInteger(TERMINAL_CONNECTED))txt=StringConcatenate(txt,"Отсутствует связь с торговым сервером; ");
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))txt=StringConcatenate(txt,"Торговля запрещена; ");
   if(IsTradeContextBusy())txt=StringConcatenate(txt,"Поток для выполнения торговых операций занят");
   if(txt!="")GetText(Cor,Com+"98",txt,Fcol,X,Y,Size,Font,true);else DelObj(Com+"98",true);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(IsTesting() || IsOptimization())return;
   EventKillTimer();
   Comment("");
   int ur=UninitializeReason();
   if(ur==1 || ur==6){DelBP(Com);DelBP("100");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Op(int tip,double olo,double opr,int stop,int take,int ind=0)
  {
   bool res=false;
   long stoplevel=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   double sl=0.0,tp=0.0;
   if(MathMod(tip,2.0)==0.0){if(!useECNNDD){if(stop>0)sl=opr-NormE(stop)*Point;if(take>0)tp=opr+NormE(take)*Point;}}
   else{if(!useECNNDD){if(stop>0)sl=opr+NormE(stop)*Point;if(take>0)tp=opr-NormE(take)*Point;}}
   if(SendOrd(tip,olo,opr,sl,tp,Com,ind)>0)res=true;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SLTP(double &ar[][],int stop,int take,int tip=-1,int ind=-1,datetime st=0,datetime ft=EV)
  {
   if(!useECNNDD)return;
   if(stop<1 && take<1)return;
   int z=0,i=0;
   for(i=1;i<=int(ar[0][0]);i++)
     {
      if(tip>-1)
        {
         if(tip<6){if(int(ar[i][6])!=tip)continue;}
         else
           {
            if(tip==8 && MathMod(ar[i][6],2)!=0)continue;
            if(tip==9 && MathMod(ar[i][6],2)==0)continue;
            if(tip==10 && ar[i][6]>1)continue;
            if(tip==11 && ar[i][6]<2)continue;
           }
        }
      if(ind>-1){if(int(ar[i][9])!=ind)continue;}
      datetime ti=datetime(ar[i][8]);
      if(ti<st || ti>ft)continue;
      double sl=0.0,tp=0.0;
      if(MathMod(ar[i][6],2.0)==0.0)
        {
         if(stop>0){if(ar[i][2]==0.0)sl=ar[i][1]-NormE(stop)*Point;}
         if(take>0){if(ar[i][3]==0.0)tp=ar[i][1]+NormE(take)*Point;}
        }
      else
        {
         if(stop>0){if(ar[i][2]==0.0)sl=ar[i][1]+NormE(stop)*Point;}
         if(take>0){if(ar[i][3]==0.0)tp=ar[i][1]-NormE(take)*Point;}
        }
      if(sl==0.0){if(tp==0.0)continue;sl=ar[i][2];}
      if(tp==0.0){if(sl==0.0)continue;tp=ar[i][3];}
      if(MathAbs(NormD(sl-ar[i][2]))>miz)
        {
         if(MathAbs(NormD(tp-ar[i][3]))>miz)
           {if(ModOrd(int(ar[i][6]),int(ar[i][4]),ar[i][1],ar[i][2],ar[i][3],ar[i][1],sl,tp))z++;}
         else{if(ModOrd(int(ar[i][6]),int(ar[i][4]),ar[i][1],ar[i][2],ar[i][3],ar[i][1],sl,ar[i][3]))z++;}
        }
      else
        {
         if(MathAbs(NormD(tp-ar[i][3]))>miz)
           {if(ModOrd(int(ar[i][6]),int(ar[i][4]),ar[i][1],ar[i][2],ar[i][3],ar[i][1],ar[i][2],tp))z++;}
        }
     }
   if(z>0)Orders(ar);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ClosDel(double &ar[][],int tip=-1,int ind=-1,datetime st=0,datetime ft=EV)
  {
   bool res=true;
   int z=0,i=0;
   for(i=1;i<=ar[0][0];i++)
     {
      if(tip>-1)
        {
         if(tip<6){if(int(ar[i][6])!=tip)continue;}
         else
           {
            if(tip==8 && MathMod(ar[i][6],2)!=0.0)continue;
            if(tip==9 && MathMod(ar[i][6],2)==0.0)continue;
            if(tip==10 && ar[i][6]>1)continue;
            if(tip==11 && ar[i][6]<2)continue;
           }
        }
      if(ind>-1){if(int(ar[i][9])!=ind)continue;}
      datetime ti=datetime(ar[i][8]);
      if(ti<st || ti>ft)continue;
      if(ar[i][6]<2){if(ClosOrd(int(ar[i][6]),int(ar[i][4]),ar[i][2],ar[i][3],ar[i][5])>0)z++;else res=false;}
      if(ar[i][6]>1){if(DelOrd(int(ar[i][6]),int(ar[i][4]),ar[i][1])>0)z++;else res=false;}
     }
   if(z>0)Orders(ar);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool FreePr(double &ar[][],double pr,int step,int tip=-1,int ind=-1,datetime st=0,datetime ft=EV)
  {
   bool res=true;
   int i=0;
   double up=pr+(step*Point-Point),dn=pr-(step*Point-Point);
   for(i=1;i<=ar[0][0];i++)
     {
      if(tip>-1)
        {
         if(tip<6){if(int(ar[i][6])!=tip)continue;}
         else
           {
            if(tip==8 && MathMod(ar[i][6],2)!=0)continue;
            if(tip==9 && MathMod(ar[i][6],2)==0)continue;
            if(tip==10 && ar[i][6]>1)continue;
            if(tip==11 && ar[i][6]<2)continue;
           }
        }
      if(ind>-1){if(int(ar[i][9])!=ind)continue;}
      datetime ti=datetime(ar[i][8]);
      if(ti<st || ti>ft)continue;
      if(dn-ar[i][1]>miz || ar[i][1]-up>miz)continue;
      res=false;
      break;
     }
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ValO(double &ar[][],int val=1,int mod=1,int par=1,int tip=-1,int ind=-1,datetime st=0,datetime ft=EV,bool modcl=false)
  {
   double temp=0.0,res=0.0;
   int i=0;
   datetime ti=0,tim=0;
   if(mod<4){if(val==6 || val==9)res=-1;}
   for(i=1;i<=ar[0][0];i++)
     {
      if(tip>-1)
        {
         if(tip<6){if(int(ar[i][6])!=tip)continue;}
         else
           {
            if(tip==8 && MathMod(ar[i][6],2)!=0)continue;
            if(tip==9 && MathMod(ar[i][6],2)==0)continue;
            if(tip==10 && ar[i][6]>1)continue;
            if(tip==11 && ar[i][6]<2)continue;
           }
        }
      if(ind>-1){if(int(ar[i][9])!=ind)continue;}
      if(st>0 || ft<EV){if(modcl)ti=datetime(ar[i][11]);else ti=datetime(ar[i][8]);if(ti<st || ti>ft)continue;}
      switch(mod)
        {
         case 1:if(temp>0.0 && ar[i][val]>0.0 && !(ar[i][val]-temp>miz))break;temp=ar[i][val];res=ar[i][par];break;// max.
         case 2:if(temp>0.0 && ar[i][val]>0.0 && !(temp-ar[i][val]>miz))break;temp=ar[i][val];res=ar[i][par];break;// min.
         case 3:res+=ar[i][par];break;// summa.
         case 4:res+=1.0;break;// orders.
        }
     }
   return(res);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
double Lots(double lot,double risk)
  {
   double res=lot;
   if(res==0.0 && risk>0.0)res=(AccountBalance()/(100.0/risk))/MarketInfo(_Symbol,MODE_MARGINREQUIRED);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
bool TimeF(string st="",string fs="")
  {
   bool res=true;
   datetime s=0,f=time;
   if(st!="")s=StringToTime(st);
   if(fs!="")f=StringToTime(fs);
   if(s==f)return(res);
   else{if(s<f){if(time<s || time>=f)res=false;}if(s>f){if(time<s){if(time>=f)res=false;}}}
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
bool NewBar()
  {
   static datetime newbar;
   if(newbar==0)newbar=Time[0];
   bool res=false;
   if(newbar==Time[0])return(res);
   newbar=Time[0];
   res=true;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
void DelBP(string name)
  {
   if(!opnovis)return;
   int obj=ObjectsTotal();
   for(int i=obj-1;i>=0;i--)
     {if(StringFind(ObjectName(i),name,0)==0)ObjectDelete(ObjectName(i));}
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
double Spred()
  {
   long spread=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);
   double res=Ask-Bid;
   if(spread>0)res=spread*Point;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
void Info(double &ar[][])
  {
   if(!ShowInfo || !opnovis)return;
   GetText(3,"100","=Created by valeryk=",Gcol,100,15,6,"Verdana");
   long stoplevel=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   string txt="";
   color col=CLR_NONE;
   int y=Y;
   int ord=int(ValO(ar,6,4,0,8));
   if(ord>0)
     {
      y=int(y+Size*1.5);
      ord=int(ValO(ar,6,4,0,0));
      if(ord>0)txt=StringConcatenate("Buy = ",DoubleToString(ValO(ar,5,3,5,0),2)," [",IntegerToString(ord),"]");
      else txt="";
      ord=int(ValO(ar,6,4,0,2));
      if(ord>0)txt=StringConcatenate(txt,"BuyLimit = ",DoubleToString(ValO(ar,5,3,5,2),2)," [",IntegerToString(ord),"]");
      ord=int(ValO(ar,6,4,0,4));
      if(ord>0)txt=StringConcatenate(txt,"BuyStop = ",DoubleToString(ValO(ar,5,3,5,4),2)," [",IntegerToString(ord),"]");
      GetText(Cor,Com+"1",txt,Gcol,X,y,Size,Font);
     }
   else DelObj(Com+"1");
   ord=int(ValO(ar,6,4,0,9));
   if(ord>0)
     {
      y=int(y+Size*1.5);
      ord=int(ValO(ar,6,4,0,1));
      if(ord>0)txt=StringConcatenate("Sell = ",DoubleToString(ValO(ar,5,3,5,1),2)," [",IntegerToString(ord),"]");
      else txt="";
      ord=int(ValO(ar,6,4,0,3));
      if(ord>0)txt=StringConcatenate(txt,"SellLimit = ",DoubleToString(ValO(ar,5,3,5,3),2)," [",IntegerToString(ord),"]");
      ord=int(ValO(ar,6,4,0,5));
      if(ord>0)txt=StringConcatenate(txt,"SellStop = ",DoubleToString(ValO(ar,5,3,5,5),2)," [",IntegerToString(ord),"]");
      GetText(Cor,Com+"2",txt,Gcol,X,y,Size,Font);
     }
   else DelObj(Com+"2");
   y=int(y+Size*1.5);
   if(Tprofit==0){txt="Tprofit OFF";col=Gcol;}
   else
     {
      txt=StringConcatenate("Tprofit = ",IntegerToString(NormE(Tprofit*dig)));
      if(Tprofit*dig<stoplevel)col=Fcol;else col=Gcol;
     }
   GetText(Cor,Com+"3",txt,col,X,y,Size,Font);
   y=int(y+Size*1.5);
   double bal=AccountBalance();
   txt=StringConcatenate("Balance = ",DoubleToString(bal,2));
   GetText(Cor,Com+"8",txt,Gcol,X,y,Size,Font);
   y=int(y+Size*1.5);
   double eq=AccountEquity();
   txt=StringConcatenate("Equity = ",DoubleToString(eq,2));
   if(bal-eq>miz)col=Fcol;else col=Gcol;
   GetText(Cor,Com+"9",txt,col,X,y,Size,Font);
   y=int(y+Size*1.5);
   double prof=ValO(ar,7,3,7);
   txt=StringConcatenate("EA profit = ",DoubleToString(prof,2));
   if(prof<0.0)col=Fcol;else col=Gcol;
   GetText(Cor,Com+"10",txt,col,X,y,Size,Font);
   y=int(y+Size*1.5);
   txt=TimeToString(time);
   GetText(Cor,Com+"11",txt,Gcol,X,y,Size,Font,true);
   ydist=MathMax(int(y+Size*1.5),ydist);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
void GetText(int cor,string name,string text,color col,int x,int y,int size,string font,bool fl=false)
  {
   if(!opnovis)return;
   if(ObjectFind(name)<0){if(!ObjectCreate(name,OBJ_LABEL,0,0,0))return;}
   ObjectSetInteger(0,name,OBJPROP_CORNER,cor);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,col);
   if(fl)ChartRedraw();
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
void DelObj(string name,bool fl=false)
  {
   if(!opnovis)return;
   if(ObjectFind(name)<0)return;
   ObjectDelete(name);
   if(fl)ChartRedraw();
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
void Orders(double  &ar[][],bool his=false)
  {
   int q=0,i=0;
   int tot=0,pool;
   if(his){tot=OrdersHistoryTotal();pool=MODE_HISTORY;}else{tot=OrdersTotal();pool=MODE_TRADES;}
   if(tot>0)
     {
      ArrayResize(ar,tot+1);
      ArrayInitialize(ar,0.0);
      for(i=tot-1;i>=0;i--)
        {
         if(!OrderSelect(i,SELECT_BY_POS,pool))continue;
         if(OrderSymbol()!=_Symbol)continue;
         int mag=OrderMagicNumber();
         if(MathFloor(mag/1000)!=Magic)continue;
         q++;
         ar[q][1]=OrderOpenPrice();
         ar[q][2]=OrderStopLoss();
         ar[q][3]=OrderTakeProfit();
         ar[q][4]=OrderTicket();
         ar[q][5]=OrderLots();
         int tip=OrderType();
         ar[q][6]=tip;
         if(tip<2)ar[q][7]=OrderProfit()+OrderCommission()+OrderSwap();
         ar[q][8]=OrderOpenTime();
         ar[q][9]=mag-Magic*1000;
         ar[q][10]=OrderClosePrice();
         ar[q][11]=OrderCloseTime();
        }
      ar[0][0]=q;
      ArrayResize(ar,q+1);
     }
   else{ArrayResize(ar,1);ArrayInitialize(ar,0.0);}
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
bool FreeM(double lo)
  {
   bool res=true;
   if(lo*SymbolInfoDouble(_Symbol,SYMBOL_MARGIN_INITIAL)>AccountFreeMargin())res=false;
   if(!res)GetText(Cor,Com+"97","Недостаточно средств для открытия позиции",Fcol,X,ydist,Size,Font,true);
   else DelObj(Com+"97",true);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
bool Conect()
  {
   bool res=true;
   if(!TerminalInfoInteger(TERMINAL_CONNECTED))res=false;
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))res=false;
   if(IsTradeContextBusy())res=false;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
string StrTip(int tip)
  {
   string name;
   switch(tip)
     {
      case 1:name=" Sell ";break;case 2:name=" BuyLimit ";break;case 3:name=" SellLimit ";break;
      case 4:name=" BuyStop ";break;case 5:name=" SellStop ";break;default:name=" Buy ";
     }
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(name);
  }
//+------------------------------------------------------------------+
int NormE(int pr)
  {
   long res=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   //if(res<1)res=long((Spred()*2)/Point);
   res++;
   if(pr>res)res=pr;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(int(res));
  }
//+------------------------------------------------------------------+
double NormD(double pr)
  {
   double res=NormalizeDouble(pr,_Digits);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
double NormL(double lo)
  {
   double res=lo;
   int mf=int(MathCeil(lo/lotstep));
   res=mf*lotstep;
   res=MathMax(res,minlot);
   res=MathMin(res,maxlot);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
bool StopLev(double pr1,double pr2)
  {
   bool res=true;
   long par=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   if(long(MathCeil((pr1-pr2)/Point))<=par)res=false;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
bool Freez(double pr1,double pr2)
  {
   bool res=true;
   long par=SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL);
   if(long(MathCeil((pr1-pr2)/Point))<=par)res=false;
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
int SendOrd(int tip,double lo,double op,double sl,double tp,string com,int ind=0)
  {
   int i=0,tiket=0;
   if(!FreeM(lo))return(tiket);
   color col=SelCol;
   if(MathMod(tip,2.0)==0.0)col=BayCol;
   for(i=1;i<NamTry;i++)
     {
      if(!Conect())Sleep(4000);
      RefreshRates();
      switch(tip){case 0:op=Ask;break;case 1:op=Bid;break;}
      if(!ChekPar(tip,0.0,0.0,0.0,op,sl,tp,0))break;
      tiket=OrderSend(_Symbol,tip,NormL(lo),NormD(op),slipag,NormD(sl),NormD(tp),com,Magic*1000+ind,0,col);
      if(tiket>0){Comment("");break;}
      else
        {
         int er=GetLastError();
         textcom=StringConcatenate(textcom,"\n",__FUNCTION__,"Ошибка открытие позиции",StrTip(tip)," : ",
                                   ruError(er)," ,попытка ",IntegerToString(i),"  ",time);
         Err(er);
        }
     }
   return(tiket);
  }
//+------------------------------------------------------------------+
bool ClosOrd(int tip,int tik,double osl,double otp,double olo,double lo=-1.0)
  {
   bool res=false;
   int i=0;
   color col=SelCol;
   if(MathMod(tip,2.0)==0.0)col=BayCol;
   double lot=lo;
   if(lo<0.0)lot=olo;
   for(i=1;i<=NamTry;i++)
     {
      if(!Conect())Sleep(4000);
      RefreshRates();
      if(!ChekPar(tip,0.0,osl,otp,0.0,0.0,0.0,1))break;
      double pr=0.0;
      if(MathMod(tip,2.0)==0.0)pr=Bid;else pr=Ask;
      if(!OrderClose(tik,NormL(lot),NormD(pr),slipag,col))
        {
         int er=GetLastError();
         textcom=StringConcatenate(textcom,"\n",__FUNCTION__,"Ошибка удаления",StrTip(tip),IntegerToString(tik)," : ",
                                   ruError(er)," ,попытка ",IntegerToString(i),"  ",time);
         Err(er);
        }
      else{Comment("");break;}
     }
   return(res);
  }
//+------------------------------------------------------------------+
bool DelOrd(int tip,int tik,double oop)
  {
   bool res=false;
   int i=0;
   color col=SelCol;
   if(MathMod(tip,2.0)==0.0)col=BayCol;
   for(i=1;i<=NamTry;i++)
     {
      if(!Conect())Sleep(4000);
      RefreshRates();
      if(!ChekPar(tip,oop,0.0,0.0,0.0,0.0,0.0,2))break;
      if(!OrderDelete(tik,col))
        {
         int er=GetLastError();
         textcom=StringConcatenate(textcom,"\n",__FUNCTION__,"Ошибка удаления",StrTip(tip),IntegerToString(tik)," : ",
                                   ruError(er)," ,попытка ",IntegerToString(i),"  ",time);
         Err(er);
        }
      else{Comment("");break;}
     }
   return(res);
  }
//+------------------------------------------------------------------+
bool ModOrd(int tip,int tik,double oop,double osl,double otp,double op,double sl,double tp)
  {
   bool res=false;
   int i=0;
   color col=SelCol;
   if(MathMod(tip,2.0)==0.0)col=BayCol;
   for(i=1;i<=NamTry;i++)
     {
      if(!Conect())Sleep(4000);
      RefreshRates();
      if(!ChekPar(tip,oop,osl,otp,op,sl,tp,3))break;
      if(!OrderModify(tik,NormD(op),NormD(sl),NormD(tp),0,col))
        {
         int er=GetLastError();
         textcom=StringConcatenate(textcom,"\n",__FUNCTION__,"Ошибка модификации",StrTip(tip),IntegerToString(tik)," : ",
                                   ruError(er)," ,попытка ",IntegerToString(i),"  ",time);
         Err(er);
        }
      else{Comment("");break;}
     }
   return(res);
  }
//+------------------------------------------------------------------+
bool ChekPar(int tip,double oop,double osl,double otp,double op,double sl,double tp,int mod=0)
  {
   bool res=true;
   double pro=0.0,prc=0.0;
   if(MathMod(tip,2.0)==0.0){pro=Ask;prc=Bid;}else{pro=Bid;prc=Ask;}
   switch(mod)
     {
      case 0: // Открытие ордеров.
         switch(tip)
           {
            case 0:
            if(sl>0.0 && !StopLev(prc,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,prc)){res=false;break;}
            break;
            case 1:
            if(sl>0.0 && !StopLev(sl,prc)){res=false;break;}
            if(tp>0.0 && !StopLev(prc,tp)){res=false;break;}
            break;
            case 2:
            if(!StopLev(pro,op)){res=false;break;}
            if(sl>0.0 && !StopLev(op,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,op)){res=false;break;}
            break;
            case 3:
            if(!StopLev(op,pro)){res=false;break;}
            if(sl>0.0 && !StopLev(sl,op)){res=false;break;}
            if(tp>0.0 && !StopLev(op,tp)){res=false;break;}
            break;
            case 4:
            if(!StopLev(op,pro)){res=false;break;}
            if(sl>0.0 && !StopLev(op,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,op)){res=false;break;}
            break;
            case 5:
            if(!StopLev(pro,op)){res=false;break;}
            if(sl>0.0 && !StopLev(sl,op)){res=false;break;}
            if(tp>0.0 && !StopLev(op,tp)){res=false;break;}
            break;
           }
         break;
      case 1: // Закрытие рыночных.
         switch(tip)
           {
            case 0:
            if(osl>0.0 && !Freez(prc,osl)){res=false;break;}
            if(otp>0.0 && !Freez(otp,prc)){res=false;break;}
            break;
            case 1:
            if(osl>0.0 && !Freez(osl,prc)){res=false;break;}
            if(otp>0.0 && !Freez(prc,otp)){res=false;break;}
            break;
           }
         break;
      case 2: // Удаление отложенников.
      if(prc>oop){if(!Freez(prc,oop)){res=false;break;}}
      else{if(!Freez(oop,prc)){res=false;break;}}
      break;
      case 3: // Модификация.
         switch(tip)
           {
            case 0:
            if(osl>0.0 && !Freez(prc,osl)){res=false;break;}
            if(otp>0.0 && !Freez(otp,prc)){res=false;break;}
            if(sl>0.0 && !StopLev(prc,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,prc)){res=false;break;}
            break;
            case 1:
            if(osl>0.0 && !Freez(osl,prc)){res=false;break;}
            if(otp>0.0 && !Freez(prc,otp)){res=false;break;}
            if(sl>0.0 && !StopLev(sl,prc)){res=false;break;}
            if(tp>0.0 && !StopLev(prc,tp)){res=false;break;}
            break;
            case 2:
            if(sl>0.0 && !StopLev(op,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,op)){res=false;break;}
            if(!StopLev(pro,op) || !Freez(pro,op)){res=false;break;}
            break;
            case 3:
            if(sl>0.0 && !StopLev(sl,op)){res=false;break;}
            if(tp>0.0 && !StopLev(op,tp)){res=false;break;}
            if(!StopLev(op,pro) || !Freez(op,pro)){res=false;break;}
            break;
            case 4:
            if(sl>0.0 && !StopLev(op,sl)){res=false;break;}
            if(tp>0.0 && !StopLev(tp,op)){res=false;break;}
            if(!StopLev(op,pro) || !Freez(op,pro)){res=false;break;}
            break;
            case 5:
            if(sl>0.0 && !StopLev(sl,op)){res=false;break;}
            if(tp>0.0 && !StopLev(op,tp)){res=false;break;}
            if(!StopLev(pro,op) || !Freez(pro,op)){res=false;break;}
            break;
           }
         break;
     }
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
//|Обработка ошибок по коду в соответствии с рекомендациями          |
//+------------------------------------------------------------------+
void Err(int id)
  {
   if(id==6 || id==129 || id==130 || id==136)Sleep(5000);
   if(id==128 || id==142 || id==143 || id==4 || id==132)Sleep(60000);
   if(id==145)Sleep(15000);
   if(id==146)Sleep(10000);
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
  }
//+------------------------------------------------------------------+
//|Возвращает описание ошибки на русском                             |
//+------------------------------------------------------------------+
string ruError(int id)
  {
   string res="";
   switch(id)
     {
      case 0:    res=" Нет ошибок. ";break;
      case 1:    res=" Нет ошибки, но результат неизвестен. ";break;
      case 2:    res=" Общая ошибка. ";break;
      case 3:    res=" Неправильные параметры. ";break;
      case 4:    res=" Торговый сервер занят. ";break;
      case 5:    res=" Старая версия клиентского терминала. ";break;
      case 6:    res=" Нет связи с торговым сервером. ";break;
      case 7:    res=" Недостаточно прав. ";break;
      case 8:    res=" Слишком частые запросы. ";break;
      case 9:    res=" Недопустимая операция нарушающая функционирование сервера. ";break;
      case 64:   res=" Счет заблокирован. ";break;
      case 65:   res=" Неправильный номер счета. ";break;
      case 128:  res=" Истек срок ожидания совершения сделки. ";break;
      case 129:  res=" Неправильная цена. ";break;
      case 130:  res=" Неправильные стопы. ";break;
      case 131:  res=" Неправильный объем. ";break;
      case 132:  res=" Рынок закрыт. ";break;
      case 133:  res=" Торговля запрещена. ";break;
      case 134:  res=" Недостаточно денег для совершения операции. ";break;
      case 135:  res=" Цена изменилась. ";break;
      case 136:  res=" Нет цен. ";break;
      case 137:  res=" Брокер занят. ";break;
      case 138:  res=" Новые цены. ";break;
      case 139:  res=" Ордер заблокирован и уже обрабатывается. ";break;
      case 140:  res=" Разрешена только покупка. ";break;
      case 141:  res=" Слишком много запросов. ";break;
      case 145:  res=" Модификация запрещена, так как ордер слишком близок к рынку. ";break;
      case 146:  res=" Подсистема торговли занята. ";break;
      case 147:  res=" Использование даты истечения ордера запрещено брокером. ";break;
      case 148:  res=" Количество открытых и отложенных ордеров достигло предела, установленного брокером. ";break;
      case 149:  res=" Хеджирование запрещено ";break;
      case 150:  res=" Запрещено правилами FIFO ";break;
      case 4000: res=" Нет ошибки. ";break;
      case 4001: res=" Неправильный указатель функции. ";break;
      case 4002: res=" Индекс массива - вне диапазона. ";break;
      case 4003: res=" Нет памяти для стека функций. ";break;
      case 4004: res=" Переполнение стека после рекурсивного вызова. ";break;
      case 4005: res=" На стеке нет памяти для передачи параметров. ";break;
      case 4006: res=" Нет памяти для строкового параметра. ";break;
      case 4007: res=" Нет памяти для временной строки. ";break;
      case 4008: res=" Неинициализированная строка. ";break;
      case 4009: res=" Неинициализированная строка в массиве. ";break;
      case 4010: res=" Нет памяти для строкового массива. ";break;
      case 4011: res=" Слишком длинная строка. ";break;
      case 4012: res=" Остаток от деления на ноль. ";break;
      case 4013: res=" Деление на ноль. ";break;
      case 4014: res=" Неизвестная команда. ";break;
      case 4015: res=" Неправильный переход. ";break;
      case 4016: res=" Неинициализированный массив. ";break;
      case 4017: res=" Вызовы DLL не разрешены. ";break;
      case 4018: res=" Невозможно загрузить библиотеку. ";break;
      case 4019: res=" Невозможно вызвать функцию. ";break;
      case 4020: res=" Вызовы внешних библиотечных функций не разрешены. ";break;
      case 4021: res=" Недостаточно памяти для строки, возвращаемой из функции. ";break;
      case 4022: res=" Система занята. ";break;
      case 4023: res=" Критическая ошибка вызова DLL-функции ";break;
      case 4024: res=" Внутренняя ошибка ";break;
      case 4025: res=" Нет памяти ";break;
      case 4026: res=" Неверный указатель ";break;
      case 4027: res=" Слишком много параметров форматирования строки ";break;
      case 4028: res=" Число параметров превышает число параметров форматирования строки ";break;
      case 4029: res=" Неверный массив ";break;
      case 4030: res=" График не отвечает ";break;
      case 4050: res=" Неправильное количество параметров функции. ";break;
      case 4051: res=" Недопустимое значение параметра функции. ";break;
      case 4052: res=" Внутренняя ошибка строковой функции. ";break;
      case 4053: res=" Ошибка массива. ";break;
      case 4054: res=" Неправильное использование массива-таймсерии. ";break;
      case 4055: res=" Ошибка пользовательского индикатора. ";break;
      case 4056: res=" Массивы несовместимы. ";break;
      case 4057: res=" Ошибка обработки глобальныех переменных. ";break;
      case 4058: res=" Глобальная переменная не обнаружена. ";break;
      case 4059: res=" Функция не разрешена в тестовом режиме. ";break;
      case 4060: res=" Функция не разрешена. ";break;
      case 4061: res=" Ошибка отправки почты. ";break;
      case 4062: res=" Ожидается параметр типа string. ";break;
      case 4063: res=" Ожидается параметр типа integer. ";break;
      case 4064: res=" Ожидается параметр типа double. ";break;
      case 4065: res=" В качестве параметра ожидается массив. ";break;
      case 4066: res=" Запрошенные исторические данные в состоянии обновления. ";break;
      case 4067: res=" Ошибка при выполнении торговой операции. ";break;
      case 4068: res=" Ресурс не найден ";break;
      case 4069: res=" Ресурс не поддерживается ";break;
      case 4070: res=" Дубликат ресурса ";break;
      case 4071: res=" Ошибка инициализации пользовательского индикатора ";break;
      case 4099: res=" Конец файла. ";break;
      case 4100: res=" Ошибка при работе с файлом. ";break;
      case 4101: res=" Неправильное имя файла. ";break;
      case 4102: res=" Слишком много открытых файлов. ";break;
      case 4103: res=" Невозможно открыть файл. ";break;
      case 4104: res=" Несовместимый режим доступа к файлу. ";break;
      case 4105: res=" Ни один ордер не выбран. ";break;
      case 4106: res=" Неизвестный символ. ";break;
      case 4107: res=" Неправильный параметр цены для торговой функции. ";break;
      case 4108: res=" Неверный номер тикета. ";break;
      case 4109:
         res=" Торговля не разрешена. Необходимо включить опцию Разрешить советнику торговать в свойствах эксперта. ";
         break;
      case 4110: res=" Длинные позиции не разрешены. Необходимо проверить свойства эксперта. ";break;
      case 4111: res=" Короткие позиции не разрешены. Необходимо проверить свойства эксперта. ";break;
      case 4200: res=" Объект уже существует. ";break;
      case 4201: res=" Запрошено неизвестное свойство объекта. ";break;
      case 4202: res=" Объект не существует. ";break;
      case 4203: res=" Неизвестный тип объекта. ";break;
      case 4204: res=" Нет имени объекта. ";break;
      case 4205: res=" Ошибка координат объекта. ";break;
      case 4206: res=" Не найдено указанное подокно. ";break;
      case 4207: res=" Ошибка при работе с объектом ";break;
      case 4210: res=" Неизвестное свойство графика ";break;
      case 4211: res=" График не найден ";break;
      case 4212: res=" Не найдено подокно графика ";break;
      case 4213: res=" Индикатор не найден ";break;
      case 4220: res=" Ошибка выбора инструмента ";break;
      case 4250: res=" Ошибка отправки push-уведомления ";break;
      case 4251: res=" Ошибка параметров push-уведомления ";break;
      case 4252: res=" Уведомления запрещены ";break;
      case 4253: res=" Слишком частые запросы отсылки push-уведомлений ";break;
      case 5001: res=" Слишком много открытых файлов ";break;
      case 5002: res=" Неверное имя файла ";break;
      case 5003: res=" Слишком длинное имя файла ";break;
      case 5004: res=" Ошибка открытия файла ";break;
      case 5005: res=" Ошибка размещения буфера текстового файла ";break;
      case 5006: res=" Ошибка удаления файла ";break;
      case 5007: res=" Неверный хендл файла (файл закрыт или не был открыт) ";break;
      case 5008: res=" Неверный хендл файла (индекс хендла отсутствует в таблице) ";break;
      case 5009: res=" Файл должен быть открыт с флагом FILE_WRITE ";break;
      case 5010: res=" Файл должен быть открыт с флагом FILE_READ ";break;
      case 5011: res=" Файл должен быть открыт с флагом FILE_BIN ";break;
      case 5012: res=" Файл должен быть открыт с флагом FILE_TXT ";break;
      case 5013: res=" Файл должен быть открыт с флагом FILE_TXT или FILE_CSV ";break;
      case 5014: res=" Файл должен быть открыт с флагом FILE_CSV ";break;
      case 5015: res=" Ошибка чтения файла ";break;
      case 5016: res=" Ошибка записи файла ";break;
      case 5017: res=" Размер строки должен быть указан для двоичных файлов ";break;
      case 5018: res=" Неверный тип файла (для строковых массивов-TXT, для всех других-BIN)";break;
      case 5019: res=" Файл является директорией ";break;
      case 5020: res=" Файл не существует ";break;
      case 5021: res=" Файл не может быть перезаписан ";break;
      case 5022: res=" Неверное имя директории ";break;
      case 5023: res=" Директория не существует ";break;
      case 5024: res=" Указанный файл не является директорией ";break;
      case 5025: res=" Ошибка удаления директории ";break;
      case 5026: res=" Ошибка очистки директории ";break;
      case 5027: res=" Ошибка изменения размера массива ";break;
      case 5028: res=" Ошибка изменения размера строки ";break;
      case 5029: res=" Структура содержит строки или динамические массивы ";break;
      default :  res=" Неизвестная ошибка. ";
     }
   int er=GetLastError();
   if(er>0)textcom=StringConcatenate(textcom,"\n",__FUNCTION__,ruError(er),"  ",time);
   return(res);
  }
//+------------------------------------------------------------------+
