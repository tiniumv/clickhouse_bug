## This branch works as intended

All migrations are applied during creation of containers, first in ```kafka-init``` (topic creation), then in ```clickhouse-client``` (everything else).


* wait for migrations to be applied

```docker-compose logs --tail 1 clickhouse-client```
```
clickhouse-client_1  | {"offsets":[{"partition":0,"offset":0,"error_code":null,"error":null},{"partition":0,"offset":1,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}{"offsets":[{"partition":0,"offset":0,"error_code":null,"error":null},{"partition":0,"offset":1,"error_code":null,"error":null},{"partition":0,"offset":2,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}Data posted to topics
```


* acces clickhouse container

```docker-compose exec clickhouse-client bash```


* open clickhouse client

```clickhouse-client --host=clickhouse --user=default --password=default```


* inspect data

```select * from causing_problems_mv;```
```
┌─field_a─┬─field_b─┬─field_c─┬──max_field_datetime─┐
│ 1       │ type_a  │       1 │ 2021-12-01 14:00:00 │
│ 2       │ type_a  │       2 │ 2021-12-01 13:00:00 │
└─────────┴─────────┴─────────┴─────────────────────┘
```

```select * from table_i;```
```
┌─field_a─┬─field_c─┐
│ 1       │       1 │
│ 2       │       2 │
└─────────┴─────────┘
```

```select * from table_ii;```
```
┌─field_b─┬─field_c─┬──────field_datetime─┐
│ type_a  │       1 │ 2021-12-01 12:00:00 │
│ type_a  │       1 │ 2021-12-01 14:00:00 │
│ type_a  │       2 │ 2021-12-01 13:00:00 │
└─────────┴─────────┴─────────────────────┘
```