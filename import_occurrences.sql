-- Usage: 

-- sqlite3 sp.db < import_occurrences.sql

.mode csv
.separator "\t"
.header on
.import occurrence_fixed.txt occurrence
