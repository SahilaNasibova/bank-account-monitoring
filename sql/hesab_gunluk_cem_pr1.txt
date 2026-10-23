CREATE OR REPLACE PROCEDURE hesab_gunluk_cem_pr1 IS
    v_started       DATE;
    v_log_desc      VARCHAR2(500);
  BEGIN
    v_started := SYSDATE;
  
  --delete from cbdd_admin.acc_amount_daily_sum
 -- where tarix = trunc(sysdate)-1;
  commit;
    
  INSERT INTO cbdd_TIBCO.hesab_gunluk_cem_pr
SELECT  distinct ab.amount_date    AS tarix,
            cm.branch,
            cm.TAX_NUMBER  ,
            cm.CUST_NAME,
             a.ACCOUNT_ID   ,
                              CASE
                                  WHEN cm.cust_class = 2
                                  THEN
                                      N'Hüquqi şəxs'
                                  WHEN cm.cust_class = 4
                                  THEN
                                      N'Fərdi sahibkar'
                                  WHEN cm.cust_class = 3
                                  THEN
                                      N'Kredit təşkilatı'
                                  WHEN cm.cust_class = 1
                                  THEN
                                      N'Fiziki şəxs'
                                  ELSE
                                      NULL
                              END               AS cust_class,
                              CASE
                                  WHEN a.subledger IN ('35290',
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
                                                       '40795')
                                  THEN
                                      'deposit'
                                  ELSE
                                      'cari'
                              END               acc_name,        --hesabin adi
                             
                              
                              c.code            AS valyuta,
                              CASE
                                  WHEN a."BRANCH" IN ('BKS',
                                                      'DNG',
                                                      'GAR',
                                                      'NAR',
                                                      'UBM',
                                                      'YSM',
                                                      'SDR')
                                  THEN
                                      '1. Corporate'
                                  WHEN a."BRANCH" IN ('SUM')
                                  THEN
                                      '2. SUM'
                                  WHEN a."BRANCH" IN ('BANK')
                                  THEN
                                      '3. BANK'
                                  WHEN a."BRANCH" IN ('KPZ',
                                                      'SHEK',
                                                      'ADJ',
                                                      'AHM',
                                                      'INSH',
                                                      'GNDJ',
                                                      'NFT',
                                                      'LKN',
                                                      'BRD')
                                  THEN
                                      '4. Retail (Corporate)'
                                  WHEN a."BRANCH" IN ('CNTR',
                                                      'BKX',
                                                      'STB2',
                                                      'MDK',
                                                      'MNG',
                                                      'QUBA',
                                                      'SLY',
                                                      'XCHZ',
                                                      'XRD',
                                                      'ISML',
                                                      'SMKR',
                                                      'TVZ')
                                  THEN
                                      '5. Retail'
                                  WHEN a."BRANCH" IN ('FIL8')
                                  THEN
                                      '6.Digital'
                                  ELSE
                                      a."BRANCH"
                              END               AS filial,
                              br.branch_name    AS Filial_adi,
                              CASE
                                  WHEN UPPER (a.acc_inserted_by) IN
                                           ('JAMILF',
                                            'ROYALN',
                                            'RUSLANJAM',
                                            'MOBILH',
                                            'MAHABBATI',
                                            'GNDJ_FARIZG',
                                            'TALEHH',
                                            'NAVAIS',
                                            'IBRAHIMH',
                                            'ORKHANIS',
                                            'KAMRANI',
                                            'ILKINMA',
                                            'HASANG',
                                            'RASULAGA',
                                            'ROVSHANBA',
                                            'GARIBK',
                                            'HAJIM',
                                            'TOGRULAB',
                                            'GINYAZM',
                                            'ELFANH',
                                            'MOHTASHAMSH',
                                            'ASIMANH',
                                            'VUSALBA',
                                            'SLY_BALASHG',
                                            'KHAYYAMAS',
                                            'HAJIALIH',
                                            'ISAS',
                                            'JALILJ',
                                            'AKBARI',
                                            'ISML_TARLANH',
                                            'TALEHMI',
                                            'GUDRATA',
                                            'AMRAHV',
                                            'ABULFARZN',
                                            'FARIDKA',
                                            'TOGRULI',
                                            'ALIZAMINK',
                                            'TABRIZM',
                                            'ORKHANJM',
                                            'IBADATB',
                                            'ASADS',
                                            'AMILA',
                                            'FIRUZM',
                                            'RAMILABD',
                                            'SHEK_ELVINFE',
                                            'TALEHA',
                                            'RASHIDSH',
                                            'TURGUTG',
                                            'QUBA_HASANA',
                                            'VAHIDG',
                                            'TOGRULSAM',
                                            'AZADB',
                                            'QUBA_PARVINSE',
                                            'SAMIRS',
                                            'FARIDHA',
                                            'UMIDS',
                                            'ELNURHU',
                                            'NAMAZALIH',
                                            'JEYHUNMAMMADO',
                                            'ELNURO',
                                            'KANANT',
                                            'MEHDIHU',
                                            'ASADM',
                                            'SAMADM',
                                            'AZAYCH',
                                            'FARIDK',
                                            'KAMALGU',
                                            'CHINGIZB',
                                            'AZARAL',
                                            'GALBINURH',
                                            'PARVINHA',
                                            'ARASTUNJ',
                                            'UMUDT',
                                            'ABBASAL',
                                            'NIJATV',
                                            'HUSEYNT',
                                            'RAMIZAB',
                                            'VUSALJ',
                                            'ILGARM',
                                            'RUSLANAG',
                                            'VASIFM',
                                            'KANANISM',
                                            'SHAIGAD',
                                            'AZARH',
                                            'AMILJ',
                                            'RUSLANMAMM',
                                            'FIRDOVSIS',
                                            'ALIALIY',
                                            'SADIQAL',
                                            'ELGUNMA',
                                            'ELSHANAH',
                                            'ASGARI',
                                            'KANANABB',
                                            'TURALS',
                                            'EYYUBV',
                                            'MDK_GURBANGULUM',
                                            'RASULRA',
                                            'SHAHRIYARI',
                                            'JEYHUNMAMM',
                                            'ELGUNK',
                                            'TURALRZ',
                                            'SHAHRAMBA',
                                            'EMINVE',
                                            'MEHTIM',
                                            'JAMILAB',
                                            'VALEHS',
                                            'ORKHANBA',
                                            'TURALZ',
                                            'SAGIG',
                                            'OMARA',
                                            'LACHINA',
                                            'ELGIZY',
                                            'SHAMKHALM',
                                            'AFSANN',
                                            'BRD_RASHADH',
                                            'BAHLULG',
                                            'VUSALAB',
                                            'BAKHTIYARALI',
                                            'MAMMADALIB',
                                            'TURALAY',
                                            'MURADH',
                                            'ELNURP',
                                            'ARIFB',
                                            'FARIDAH',
                                            'OKTAYA',
                                            'TURALJ',
                                            'NURLANIS',
                                            'JAVADN',
                                            'ELVING',
                                            'MAHARATH',
                                            'RENATK',
                                            'DASHGINM',
                                            'AGILS',
                                            'AYDINB',
                                            'GAHIRG',
                                            'AZERA',
                                            'ORKHANZA',
                                            'JAMILY',
                                            'KAMRANMAM',
                                            'FAKHRIMIR',
                                            'FARIDAL',
                                            'ALIMUR',
                                            'SHUKURT',
                                            'AYDINHA',
                                            'ILKINS',
                                            'ZAURMA',
                                            'ISMAYILM',
                                            'AZADT',
                                            'ELGUNB',
                                            'TURALGUL',
                                            'NAHMADM',
                                            'NAMIKO',
                                            'KAMALKA',
                                            'KANANMA',
                                            'BRD_VUSALAB',
                                            'HABILN',
                                            'MURADO',
                                            'MAYISH',
                                            'KPZ_ISLAMG',
                                            'TOGRULZ',
                                            'SAMIRGUL',
                                            'RASIMM',
                                            'PEYMANA',
                                            'MAJIDH',
                                            'TAPDIGA',
                                            'JEYHUNGU',
                                            'SARDARR',
                                            'SAMIRT',
                                            'BAKHTIYARMA',
                                            'ELTUNABI',
                                            'ELTUNG',
                                            'ZAHIDAS',
                                            'EMINZ',
                                            'SADIGN',
                                            'METANETB',
                                            'GUNAYPA',
                                            'NUSHABAA',
                                            'AYNURALI',
                                            'GUMRUR',
                                            'SABIRAM',
                                            'TURKANAN',
                                            'JALAAZIZ',
                                            'GUNELMI',
                                            'ULKARAD',
                                            'AFSANAA',
                                            'NIGARRZ',
                                            'RUGAYAA',
                                            'JALAM',
                                            'FIRUZAI',
                                            'SMKR_GULNARZ',
                                            'SAMIRAV',
                                            'NARMINS',
                                            'LAMANAS',
                                            'GUNAYNA')
                                  THEN
                                      'MICRO'
                                  WHEN LOWER (a.acc_inserted_by) = 'oa'
                                  THEN
                                      'online'
                                  WHEN a.acc_inserted_by = 'OPEN_API'
                                  THEN
                                      'leo'
                                  ELSE
                                      'filial'
                              END               AS tip,
                              CASE
                                  WHEN     cid.card_id IS NOT NULL
                                       AND pa.ACCOUNT_TYPE = 'POS'
                                  THEN
                                      'kart_and_pos'
                                  WHEN     cid.card_id IS NOT NULL
                                       AND pa.ACCOUNT_TYPE <> 'POS'
                                  THEN
                                      'kart'
                                  WHEN     pa.ACCOUNT_TYPE = 'POS'
                                       AND cid.card_id IS NULL
                                  THEN
                                      'POS'
                                  ELSE
                                      'Cari'
                              END               kart_pos,
                              ab.amount_cur     amount_rub,
                              ab.amount_loc     amount_azn
                FROM rs.customers_main_info        cm,
                     rs.customers_relation_info    cr,
                     rs.accounts                   a,
                     rs.accounts_balances_v        ab,
                     rs.acc_subledger_for_reporting t,
                     rs.branch_info                br,
                     rs.currencies                 c,
                     RS.CARD_INFO_DICT             cid,
                     RS.PC_ACCOUNTS                pa
               WHERE cm.clientno = cr.clientno
                     AND cm.cust_class IN ('2', '4')
                     AND cr.branch = a.branch(+)
                     AND cr.customer_no = a.customer_no
                     AND a.acc_cur_num = ab.acc_cur_num(+)
                     AND a.acc_created < TRUNC (SYSDATE) - 1
                     AND NVL (a.acc_closed, TRUNC (SYSDATE)) >=TRUNC (SYSDATE) - 1
                     AND ab.amount_date = TRUNC (SYSDATE) - 1
                     AND t.report_code = 'rlg2_058'
                     AND a.subledger = t.subledger
                     AND br.branch_code(+) = a.branch
                     AND a.currency_no = c.no
                     AND a.ACCOUNT_ID = cid.ACNT_ID(+)
                     AND A.ACCOUNT_ID = pa.ACCOUNT(+)
                     AND A.BRANCH = pA.BRANCH(+)
                     order by ab.amount_loc desc fetch first 100 rows only;
      COMMIT;
      
    
    
  INSERT INTO CBDD_TIBCO.reports_usage_logs
    VALUES
      ('hesab_gunluk_cem_pr1',
       v_started,
       SYSDATE,
       trunc(sysdate)-1,
       'OK');
    COMMIT;
    
 EXCEPTION
    WHEN OTHERS THEN
      v_log_desc := 'Error message: ' || SQLERRM;
      INSERT INTo CBDD_TIBCO.reports_usage_logs
      VALUES
        ('hesab_gunluk_cem_pr1',
         v_started,
         SYSDATE,
         trunc(sysdate)-1,
         v_log_desc);
      COMMIT;
      
      /*     
       INSERT INTO RS.REPORTS_USAGE_LOGS
    VALUES
      ('hesab_gunluk_cem_pr1',
       V_STARTED,
       SYSDATE,
      trunc(sysdate)-1,
       'OK');
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      V_LOG_DESC := 'Error message: ' || SQLERRM;
      INSERT INTO RS.REPORTS_USAGE_LOGS
      VALUES
        ('hesab_gunluk_cem_pr1',
         V_STARTED,
         SYSDATE,
         trunc(sysdate)-1,
         V_LOG_DESC);
      COMMIT;*/

  END hesab_gunluk_cem_pr1;
