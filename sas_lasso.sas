/** �������ݣ�����SAS���ݼ�work.stock **/
proc import datafile="D:\�����ھ���Ӧ�ã����ݡ�����\data\ch8_stock.csv" out=stock dbms=DLM;
  delimiter=',';
  getnames=yes;
run;

/** ����Ԥ���� **/
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
  /* ����8��ָ���ͺ�һ������ı��� */
  drop SP DAX FTSE NIKKEI BOVESPA EU EM;
  /* ��7������ָ����ԭʼδ�ͺ�ı���ɾ������Ϊ֮��ķ��������õ���Щ���� */
run;

proc contents data=stock1;
run;




/** ����Lassoģ�� **/
proc glmselect data=stock1 plots=coefficients;
/*ʹ��glmselect���̶����ݼ�stock���з�����plotsָ��������Ա����Ļع�ϵ��
  �仯��ͼ��*/

  model ISE=ISE1 ISE2 SP1 SP2 DAX1 DAX2 FTSE1 FTSE2 
            NIKKEI1 NIKKEI2 BOVESPA1 BOVESPA2 EU1 EU2 EM1 EM2 /
        selection=lasso (choose=cv stop=none) cvmethod=random(10);
       
  output out=stock_out_lasso;
  
run;
