CREATE OR REPLACE FUNCTION bloc_acc_test(
    pdate1 IN DATE,
    pdate2   IN DATE
) RETURN bloc_acc_tab PIPELINED
IS
BEGIN
    FOR rec IN (
        WITH blok AS (
        SELECT al.account, MAX(al.set_date) AS set_date
        FROM rs.am_account_locks al
        WHERE al.unset_date IS NULL
          AND al.set_date BETWEEN pdate1 AND pdate2
        GROUP BY al.account
    ),
    intersect_result AS (
        SELECT DISTINCT cm.tax_number
        FROM rs.accounts a
        INNER JOIN rs.customers_main_info cm
            ON cm.customer_no = a.customer_no
        WHERE a.amount_loc >= 0
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
        WHERE a.amount_loc >= 0
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
    WHERE a.amount_loc >= 0
      AND a.acc_closed IS NULL
      AND cm.cust_class IN ('2','4')
    ORDER BY cm.tax_number
    ) LOOP
        PIPE ROW (bloc_acc_row(rec.branch,
                            rec.tax_number,
                            rec.cust_name,
                            rec.account_id,
                            rec.account_status,
                            rec.set_date));
    END LOOP;

    RETURN;
END;
