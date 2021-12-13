-----------------------------------------------------------------------------
-- View That Breaks Everything
-----------------------------------------------------------------------------
CREATE MATERIALIZED VIEW
    causing_problems_mv
    ENGINE=ReplacingMergeTree(max_field_datetime)
    ORDER BY (field_b, field_a)
POPULATE AS SELECT
   field_a,
   field_b,
   argMax(field_c, field_datetime) as field_c,
   max(field_datetime) as max_field_datetime
FROM
    (
        SELECT
            field_a,
            field_b,
            field_c,
            field_datetime
        FROM
            table_ii
        LEFT JOIN
            table_i USING field_c
    )
GROUP BY
    (field_b, field_a);
