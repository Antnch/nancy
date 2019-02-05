#!/bin/bash

readSql="
\set aid random_zipfian(1, 100000 * :scale, 1.07)
BEGIN;
SELECT abalance FROM pgbench_accounts WHERE aid = :aid;
END;
"
scanSql="
\set aid random_zipfian(1, 100000 * :scale, 1.07)
\SET limit random(1, 100)
BEGIN;
SELECT abalance FROM pgbench_accounts WHERE aid > :aid ORDER BY aid LIMIT :limit;
END;
"

writeSql="
\set aid random_zipfian(1, 100000 * :scale, 1.07)
\set bid random_zipfian(1, 1 * :scale, 1.07)
\set tid random_zipfian(1, 10 * :scale, 1.07)
\set delta random(-5000, 5000)
BEGIN;
UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;
UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;
UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);
END;
"

mkdir -p /storage/zipfian
echo "$readSql" > /storage/zipfian/read.sql
echo "$scanSql" > /storage/zipfian/scan.sql
echo "$writeSql" > /storage/zipfian/write.sql