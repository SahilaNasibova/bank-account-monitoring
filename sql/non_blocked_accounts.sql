CREATE OR REPLACE FUNCTION non_blocked_accounts(pdate1 DATE, pdate2 DATE)
RETURN SYS_REFCURSOR
IS
    result_cursor SYS_REFCURSOR;
    V_STARTED       DATE;
     V_LOG_DESC      VARCHAR2 (500);
BEGIN
  V_STARTED := SYSDATE;
    OPEN result_cursor FOR
    WITH blok AS (
        SELECT al.account, MAX(al.set_date) AS set_date
        FROM rs.am_account_locks al
        WHERE al.unset_date IS NULL
          AND al.set_date BETWEEN pdate1  AND pdate2  
        GROUP BY al.account
    ),
    intersect_result AS (
        SELECT DISTINCT cm.tax_number
        FROM rs.accounts a
        INNER JOIN rs.customers_main_info cm
            ON cm.customer_no = a.customer_no
        WHERE a.amount_loc < 0
          AND a.subledger = '99270'
          AND a.acc_closed IS NULL

        INTERSECT

        SELECT DISTINCT cm.tax_number
        FROM rs.accounts a
        INNER JOIN rs.customers_main_info cm
            ON cm.customer_no = a.customer_no
        INNER JOIN blok
            ON a.account_id = blok.account
        INNER JOIN cbdd_user.cari_hesablarin_balans_kodlari cd
            ON a.subledger = cd.sub
        WHERE a.amount_loc < 0
          AND a.acc_closed IS NULL
    )

    SELECT
        cm.branch,
        cm.tax_number,
        cm.cust_name,
        a.account_id,
        CASE
            WHEN b.account IS NOT NULL THEN 'Blocked'
            ELSE 'Not Blocked'
        END AS account_status,
        b.set_date
    FROM rs.accounts a
    INNER JOIN rs.customers_main_info cm
        ON cm.customer_no = a.customer_no
    INNER JOIN intersect_result ir
        ON ir.tax_number = cm.tax_number
    INNER JOIN cbdd_user.cari_hesablarin_balans_kodlari cd
        ON a.subledger = cd.sub
    LEFT JOIN blok b
        ON a.account_id = b.account
    WHERE a.amount_loc < 0
      AND a.acc_closed IS NULL
      AND cm.cust_class IN ('2','4')
    ORDER BY cm.tax_number;

INSERT INTO CBDD_TIBCO.REPORTS_USAGE_LOGS
             VALUES (
                        'non_blocked_accounts',
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
                            'non_blocked_accounts',
                            v_started,
                            SYSDATE,
                               TO_CHAR (pdate1, 'dd.mm.yyyy')
                            || ';'
                            || TO_CHAR (pdate2, 'dd.mm.yyyy'),
                            v_log_desc);
        COMMIT;
END non_blocked_accounts;
