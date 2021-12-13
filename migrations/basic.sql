
-----------------------------------------------------------------------------
-- Table I
-----------------------------------------------------------------------------

CREATE TABLE table_i (
    field_a String,
    field_c UInt64
)
ENGINE = MergeTree
ORDER BY field_a;


CREATE TABLE table_i_queue (
    field_a String,
    field_c UInt64
)
ENGINE = Kafka()
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'topic_i',
    kafka_group_name = 'click-house',
    kafka_format = 'JSONEachRow',
    kafka_skip_broken_messages = 100,
    input_format_null_as_default = 1,
    input_format_skip_unknown_fields = 1;


CREATE MATERIALIZED VIEW
    table_i_mv TO table_i AS
SELECT
    field_a,
    field_c
FROM
    table_i_queue;


-----------------------------------------------------------------------------
-- Table II
-----------------------------------------------------------------------------
CREATE TABLE table_ii (
    field_b String,
    field_c UInt64,
    field_datetime DateTime
)
ENGINE = MergeTree
ORDER BY field_c;

CREATE TABLE table_ii_queue (
    field_c UInt64,
    field_b String,
    field_datetime_raw String
)
ENGINE = Kafka()
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'topic_ii',
    kafka_group_name = 'click-house',
    kafka_format = 'JSONEachRow',
    kafka_skip_broken_messages = 100,
    input_format_null_as_default = 1,
    input_format_skip_unknown_fields = 1;

CREATE MATERIALIZED VIEW
    table_ii_mv TO table_ii AS
SELECT
    field_c as field_c,
    field_b as field_b,
    parseDateTimeBestEffort(field_datetime_raw) as field_datetime
FROM
    table_ii_queue;
