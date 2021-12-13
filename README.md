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
0 rows in set. Elapsed: 0.002 sec.
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
0 rows in set. Elapsed: 0.003 sec.
```