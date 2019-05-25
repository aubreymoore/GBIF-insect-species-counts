# GBIF-insect-species-counts

This little project was sparked by a post to ENTOMO-L asking about the number of insect species recorded for each of the United States. It occurred to me that GBIF species occurrence records could be used to get a lower bound estimate for each state. It was surprisingly easy to do this. Simply a matter of downloading all US insect occurrence records as a Darwin core archive (DwCA), importing the **occurrence** table into an SQLite database, and running a couple of queries.

## Step 1: Download all US insect occurrence records as a Darwin core archive (DwCA)

GBIF.org (25 May 2019) GBIF Occurrence Download https://doi.org/10.15468/dl.j62zyq

## Step 2: Import the DwCA occurence table into an SQLite database
```
sqlite3 sp.db
sqlite> .mode csv
sqlite> .separator "\t"
sqlite> .header on
sqlite> .import occurrence.txt occurrence
```

## Step 3: Query the Database

Create a table which contains names of states and all scientific names for insects with
occurrence records for the states. Note that **taxonRank** must be 'SPECIES'. Insects identified to genus and above 
and subspecies are not included.
```
sqlite> CREATE TABLE state_species AS
   ...> SELECT stateProvince, scientificName 
   ...> FROM occurrence
   ...> WHERE 
   ...>   taxonRank = 'SPECIES'
   ...>   AND stateProvince IN (
   ...>     'Alabama','Alaska','Arizona','Arkansas','California',
   ...>     'Colorado','Connecticut','Delaware','Florida','Georgia',
   ...>     'Hawaii','Idaho','Illinois','Indiana','Iowa',
   ...>     'Kansas','Kentucky','Louisiana','Maine','Maryland',
   ...>     'Massachusetts','Michigan','Minnesota','Mississippi','Missouri',
   ...>     'Montana','Nebraska','Nevada','New Hampshire','New Jersey',
   ...>     'New Mexico','New York','North Carolina','North Dakota','Ohio',
   ...>     'Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina',
   ...>     'South Dakota','Tennessee','Texas','Utah','Vermont',
   ...>     'Virginia','Washington','West Virginia','Wisconsin','Wyoming')
   ...> GROUP BY stateProvince, scientificName;
sqlite> -- count the number of species for each state
```

Count the number records for each state.
```
sqlite> -- count the number of species for each state
sqlite> .mode column
sqlite> .width 20 15
sqlite> SELECT stateProvince, count(*) AS species_count
   ...> FROM state_species
   ...> GROUP BY stateProvince; 
stateProvince         species_count  
--------------------  ---------------
Alabama               2093           
Alaska                1807           
Arizona               7746           
Arkansas              1529           
California            10313          
Colorado              5868           
Connecticut           1915           
Delaware              497            
Florida               7462           
Georgia               1901           
Hawaii                593            
Idaho                 1662           
Illinois              2562           
Indiana               1727           
Iowa                  1292           
Kansas                3692           
Kentucky              1080           
Louisiana             1672           
Maine                 1767           
Maryland              2232           
Massachusetts         2485           
Michigan              10258          
Minnesota             1255           
Mississippi           1833           
Missouri              1966           
Montana               1324           
Nebraska              945            
Nevada                1747           
New Hampshire         1380           
New Jersey            2378           
New Mexico            5006           
New York              4088           
North Carolina        2910           
North Dakota          647            
Ohio                  3377           
Oklahoma              3350           
Oregon                3056           
Pennsylvania          4025           
Rhode Island          607            
South Carolina        2032           
South Dakota          880            
Tennessee             1762           
Texas                 7584           
Utah                  3098           
Vermont               1452           
Virginia              2501           
Washington            2987           
West Virginia         1099           
Wisconsin             1998           
Wyoming               1511  
```
