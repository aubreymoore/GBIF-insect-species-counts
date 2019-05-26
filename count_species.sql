-- Usage: 

-- sqlite3 sp.db < count_species.sql

.mode column
.width 20 15

SELECT stateProvince, count(*) AS species_count
FROM state_species
GROUP BY stateProvince; 
