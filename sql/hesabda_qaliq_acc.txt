CREATE OR REPLACE FUNCTION hesabda_qaliq_acc (PDATE1 IN DATE, PDATE2 IN DATE)
    RETURN SYS_REFCURSOR
IS
    result_cursor   SYS_REFCURSOR;
    V_STARTED       DATE;
    V_LOG_DESC      VARCHAR2 (500);
BEGIN
    V_STARTED := SYSDATE;
    OPEN result_cursor FOR 
   select 
case 
  when cm.cust_class=2 then 'Huquqi sexs'
when cm.cust_class=4 then 'Ferdi sahibkar' end cust_class,
 case
               when a.subledger in ('35290',
                                    '35300',
                                    '35510',
                                    '35520',
                                    '35270',
                                    '31110',
                                    '31120',
                                    '31210',
                                    '31220',
                                    '35210',
                                    '35215',
                                    '35220',
                                    '35225',
                                    '35240',
                                    '35260',
                                    '35265',
                                    '35275',
                                    '35295',
                                    '35305',
                                    '35430',
                                    '35435',
                                    '35440',
                                    '35445',
                                    '35460',
                                    '35480',
                                    '35485',
                                    '35490',
                                    '35495',
                                    '35515',
                                    '35525',
                                    '36110',
                                    '36115',
                                    '36120',
                                    '36125',
                                    '36140',
                                    '36145',
                                    '36150',
                                    '36155',
                                    '36310',
                                    '36315',
                                    '36320',
                                    '36325',
                                    '36340',
                                    '36345',
                                    '36350',
                                    '36355',
                                    '37054',
                                    '38310',
                                    '38320',
                                    '38330',
                                    '38340',
                                    '38350',
                                    '38360',
                                    '38370',
                                    '38380',
                                    '38390',
                                    '38410',
                                    '38420',
                                    '38430',
                                    '38440',
                                    '38450',
                                    '38460',
                                    '38470',
                                    '38480',
                                    '38490',
                                    '38610',
                                    '38620',
                                    '38630',
                                    '38640',
                                    '38650',
                                    '38660',
                                    '38670',
                                    '38680',
                                    '38690',
                                    '38710',
                                    '38720',
                                    '38730',
                                    '38740',
                                    '38750',
                                    '38760',
                                    '38770',
                                    '38780',
                                    '38790',
                                    '39100',
                                    '39110',
                                    '39130',
                                    '39140',
                                    '39160',
                                    '39170',
                                    '39190',
                                    '39200',
                                    '39220',
                                    '39230',
                                    '39250',
                                    '39260',
                                    '40310',
                                    '40315',
                                    '40320',
                                    '40325',
                                    '40330',
                                    '40335',
                                    '40340',
                                    '40345',
                                    '40350',
                                    '40355',
                                    '40360',
                                    '40365',
                                    '40370',
                                    '40375',
                                    '40380',
                                    '40385',
                                    '40390',
                                    '40395',
                                    '40410',
                                    '40415',
                                    '40420',
                                    '40425',
                                    '40430',
                                    '40435',
                                    '40440',
                                    '40445',
                                    '40450',
                                    '40456',
                                    '40460',
                                    '40466',
                                    '40470',
                                    '40475',
                                    '40480',
                                    '40485',
                                    '40490',
                                    '40495',
                                    '40610',
                                    '40615',
                                    '40620',
                                    '40625',
                                    '40630',
                                    '40635',
                                    '40640',
                                    '40645',
                                    '40650',
                                    '40655',
                                    '40660',
                                    '40665',
                                    '40670',
                                    '40675',
                                    '40680',
                                    '40685',
                                    '40690',
                                    '40695',
                                    '40710',
                                    '40715',
                                    '40720',
                                    '40725',
                                    '40730',
                                    '40735',
                                    '40740',
                                    '40745',
                                    '40750',
                                    '40755',
                                    '40760',
                                    '40765',
                                    '40770',
                                    '40775',
                                    '40780',
                                    '40785',
                                    '40790',
                                    '40795') then
                'deposit'
               else
                'cari'
             end acc_name,
cm.TAX_NUMBER,
cm.CUST_NAME,
cm.BRANCH,
a.ACCOUNT_ID,
substr(a.ACCOUNT_ID,-6,3) as valyuta,
trunc(avg(nvl(ab.AMOUNT_LOC,0)),2) as orta_qalıq_azn,
trunc(avg(nvl(ab.AMOUNT_CUR,0)),2) as orta_qaliq_currency 
from RS.CUSTOMERS_MAIN_INFO cm
join
RS.CUSTOMERS_RELATION_INFO cr on cm.CLIENTNO=cr.CLIENTNO and cm.CUST_CLASS in (2,4) /*and cm.CUST_CLOSED is null*/ 
join
RS.ACCOUNTS a on a.BRANCH = cr.BRANCH and a.CUSTOMER_NO = cr.CUSTOMER_NO and a.acc_created < PDATE2
and nvl(a.acc_closed, trunc(sysdate)) >= PDATE1
join
rs.acc_subledger_for_reporting t on t.SUBLEDGER=a.SUBLEDGER and t.report_code = 'rlg2_058'
left join
RS.ACCOUNTS_BALANCES_V ab on ab.ACC_CUR_NUM = a.ACC_CUR_NUM and ab.AMOUNT_DATE 
between PDATE1
and PDATE2
group by  cm.TAX_NUMBER,cm.CUST_NAME,cm.BRANCH,a.ACCOUNT_ID,cm.cust_class,a.subledger;
    INSERT INTO CBDD_TIBCO.REPORTS_USAGE_LOGS
             VALUES (
                        'hesabda_qaliq_acc',
                        v_started,
                        SYSDATE,
                           TO_CHAR (pdate1, 'dd.mm.yyyy')
                        || ';'
                        || TO_CHAR (pdate2, 'dd.mm.yyyy'),
                        'OK');
    COMMIT;
    RETURN result_cursor;
EXCEPTION
    WHEN OTHERS
    THEN
        V_LOG_DESC := 'Error message: ' || SQLERRM;
        INSERT INTO CBDD_TIBCO.REPORTS_USAGE_LOGS
                 VALUES (
                            'hesabda_qaliq_acc',
                            v_started,
                            SYSDATE,
                               TO_CHAR (pdate1, 'dd.mm.yyyy')
                            || ';'
                            || TO_CHAR (pdate2, 'dd.mm.yyyy'),
                            v_log_desc);
        COMMIT;
END hesabda_qaliq_acc;
