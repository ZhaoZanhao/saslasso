/** 读入数据，生成SAS数据集work.stock **/
proc import datafile="D:\数据挖掘与应用：数据、代码\data\ch8_stock.csv" out=stock dbms=DLM;
  delimiter=',';
  getnames=yes;
run;

/** 数据预处理 **/
data stock1;
  set stock;
  ISE1=lag(ISE);
  ISE2=lag(lag(ISE));
  SP1=lag(SP);
  SP2=lag(lag(SP));
  DAX1=lag(DAX);
  DAX2=lag(lag(DAX));
  FTSE1=lag(FTSE);
  FTSE2=lag(lag(FTSE));
  NIKKEI1=lag(NIKKEI);
  NIKKEI2=lag(lag(NIKKEI));
  BOVESPA1=lag(BOVESPA);
  BOVESPA2=lag(lag(BOVESPA));
  EU1=lag(EU);
  EU2=lag(lag(EU));
  EM1=lag(EM);
  EM2=lag(lag(EM));
  /* 创建8个指数滞后一至两天的变量 */
  drop SP DAX FTSE NIKKEI BOVESPA EU EM;
  /* 将7个国际指数的原始未滞后的变量删除，因为之后的分析不会用到这些变量 */
run;

proc contents data=stock1;
run;




/** 建立Lasso模型 **/
proc glmselect data=stock1 plots=coefficients;
/*使用glmselect过程对数据集stock进行分析，plots指定输出各自变量的回归系数
  变化的图像*/

  model ISE=ISE1 ISE2 SP1 SP2 DAX1 DAX2 FTSE1 FTSE2 
            NIKKEI1 NIKKEI2 BOVESPA1 BOVESPA2 EU1 EU2 EM1 EM2 /
        selection=lasso (choose=cv stop=none) cvmethod=random(10);
       
  output out=stock_out_lasso;
  
run;
