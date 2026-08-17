/*
1) The tables found in tables.sql were created.
2) I set AUTOCOMMIT to ON so that the tuples would be saved.
3) The tuples were inserted into the tables using the command START path\file.sql.
4) The 'plan' table, provided in the tutorial, was created.
*/

SET AUTOTRACE ON STATISTICS

SELECT year, count(*)
FROM movie
GROUP BY year
ORDER BY year desc;

SELECT companyID, count(*)
FROM distributedBy
GROUP BY companyID;

SELECT P1.value AS DB_BLOCK_GETS, 
P2.value AS CONSISTENT_GETS, 
P3.value AS PHYSICAL_READS 
FROM v$mystat P1, v$statname N1, v$mystat P2, v$statname N2, v$mystat P3, v$statname N3 
WHERE N1.name = 'db block gets' 
AND P1.statistic# = N1.statistic# 
AND N2.name = 'consistent gets' 
AND P2.statistic# = N2.statistic# 
AND N3.name = 'physical reads' 
AND P3.statistic# = N3.statistic#;

ALTER TABLE SYS.movie STORAGE (buffer_pool keep);

SELECT p.personID
FROM movie m, plays p
WHERE p.movieID = m.movieID and m.movieID = 0046790;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_A1' FOR SELECT p.personID FROM movie m, plays p WHERE p.movieID = m.movieID and m.movieID = 0046790;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_A1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 1; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query1; 
SELECT p.personID FROM movie m, plays p WHERE p.movieID = m.movieID and m.movieID = 0046790; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT
HASH JOIN
TABLE ACCESS FULL MOVIE
TABLE ACCESS FULL PLAYS;

SELECT DISTINCT p.personID
FROM movie m, plays p
WHERE p.movieID = m.movieID and m.movieID = 0046790;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_A2' FOR SELECT DISTINCT p.personID
FROM movie m, plays p WHERE p.movieID = m.movieID and m.movieID = 0046790;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_A2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 2; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query1; 
SELECT DISTINCT p.personID FROM movie m, plays p WHERE p.movieID = m.movieID and m.movieID = 0046790; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT
HASH UNIQUE
HASH JOIN
TABLE ACCESS FULL MOVIE
TABLE ACCESS FULL PLAYS;

CREATE CLUSTER movie_cluster (movieID numeric(7)) 
HASHKEYS 1000; 
CREATE TABLE movie (movieID numeric(7) not null, movieTitle char(110) not null, color char(45), language char(20), year numeric(4)) 
CLUSTER movie_cluster (movieID);

SELECT STATEMENT
MERGE JOIN CARTESIAN
TABLE ACCESS FULL PLAYS
BUFFER SORT TABLE ACCESS HASH MOVIE;

SELECT STATEMENT
HASH UNIQUE
MERGE JOIN CARTESIAN
TABLE ACCESS FULL PLAYS
BUFFER SORT TABLE ACCESS HASH MOVIE;

CREATE TABLE plays (personID char(50) not null, movieID numeric(7) not null) 
CLUSTER movie_cluster (movieID);

SELECT STATEMENT
HASH JOIN
TABLE ACCESS HASH MOVIE
TABLE ACCESS HASH PLAYS;

SELECT STATEMENT
HASH UNIQUE
HASH JOIN
TABLE ACCESS HASH MOVIE
TABLE ACCESS HASH PLAYS;

SELECT movieTitle
FROM movie
WHERE year > 1980;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_D1' FOR SELECT movieTitle FROM movie WHERE year > 1980;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_D1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

SELECT personName
FROM people
WHERE birthYear > 1950;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_D2' FOR SELECT personName FROM people WHERE birthYear > 1950;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_D2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS FULL PEOPLE;

CREATE INDEX unc_tree_movie ON movie(year); 
CREATE INDEX unc_tree_people ON people(birthYear);

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

SELECT STATEMENT 
TABLE ACCESS FULL PEOPLE;

SELECT movieID, movieTitle
FROM movie
WHERE movieID != 0046778 and year > 1980;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_Ε1' FOR SELECT movieID, movieTitle FROM movie WHERE movieID != 0046778 and year > 1980;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_Ε1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

SELECT movieID, movieTitle
FROM movie
WHERE movieID = 0046778 and year > 1980;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_Ε2' FOR SELECT movieID, movieTitle FROM movie WHERE movieID = 0046778 and year > 1980;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE
STATEMENT_ID='Z2_Ε2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS HASH MOVIE;

SELECT m.movieID, m.movieTitle, p.companyID
FROM movie m, producedBy p
WHERE m.movieID = p.movieID and m.movieID = 0046799 and m.movieTitle = 'Boot Polish (1954)';

CREATE UNIQUE INDEX unc_tree_movietitle ON movie(movieTitle);
EXPLAIN PLAN SET STATEMENT_ID = 'Z2_F' FOR SELECT m.movieID, m.movieTitle, p.companyID FROM movie m, producedBy p WHERE m.movieID = p.movieID and m.movieID = 0046790 and m.movieTitle = 'Boot Polish (1954)';
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_F' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
MERGE JOIN 
TABLE ACCESS BY INDEX ROWID MOVIE 
INDEX UNIQUE SCAN UNC_TREE_MOVIETITLE 
FILTER 
TABLE ACCESS FULL PRODUCEDBY;

SELECT /*+ ORDERED USE_HASH(p,pl) */ pl.movieID
FROM people p, plays pl
WHERE p.personID = pl.personID and p.birthYear > 1990;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_G1' FOR SELECT DISTINCT pl.movieID FROM people p, plays pl WHERE p.personID = pl.personID and p.birthYear > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_G1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query1; 
SELECT DISTINCT pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

drop index unc_tree_people;

SELECT STATEMENT 
HASH UNIQUE
TABLE ACCESS FULL PLAYS;

SET STATEMENT_ID = 'Z2_G1', WHERE STATEMENT_ID='Z2_G1;

CREATE BITMAP INDEX bitmap_birth_year ON people (birthYear);

SELECT STATEMENT
TABLE ACCESS FULL PLAYS
HASH JOIN 
BITMAP CONVERSION TO ROWIDS 
BITMAP INDEX RANGE SCAN BITMAP BITMAP_BIRTH_YEAR 
TABLE ACCESS BY INDEX ROWID BATCHED PEOPLE;

SET STATEMENT_ID = 'Z2_G2', WHERE STATEMENT_ID='Z2_G2;

CREATE CLUSTER clu_birthYear (birthYear numeric(4)); 
CREATE INDEX clu_tree_birth_year ON CLUSTER clu_birthYear; 
CREATE TABLE people (personID char(50) not null, personName char(50) not null, birthYear numeric(4), deathYear numeric(4)) CLUSTER clu_birthYear (birthYear);

STATEMENT_ID = 'Z2_Η', WHERE STATEMENT_ID='Z2_Η';

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS CLUSTER PEOPLE 
INDEX RANGE SCAN CLU_TREE_BIRTH_YEAR 
TABLE ACCESS FULL PLAYS;
