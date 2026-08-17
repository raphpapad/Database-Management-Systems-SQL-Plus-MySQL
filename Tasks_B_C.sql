/*
1) The tables, clusters, etc., from the first exercise were dropped.
2) The tables defined in tables.sql were created.
3) I set AUTOCOMMIT ON to save the tuples.
4) The tuples were inserted into the tables using the command START path\file.sql.
*/

ALTER SESSION SET OPTIMIZER_MODE = ALL_ROWS;

CREATE CLUSTER movie_cluster (movieID numeric(7)) HASHKEYS 1000;
CREATE TABLE movie (movieID numeric(7) not null, movieTitle char(110) not null, color char(45), language char(20), year numeric(4)) 
CLUSTER movie_cluster (movieID);

SELECT movieTitle
FROM movie
WHERE year > 1990;

EXPLAIN PLAN SET STATEMENT_ID = 'Z1_B1' FOR 
SELECT movieTitle FROM movie WHERE year > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_B1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 1; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query1; 
SELECT movieTitle FROM movie WHERE year > 1990; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

SELECT personName
FROM people
WHERE birthYear > 1945;

EXPLAIN PLAN SET STATEMENT_ID = 'Z1_B2' FOR SELECT personName FROM people 
WHERE birthYear > 1945;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_B2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 2; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query2; 
SELECT personName FROM people 
WHERE birthYear > 1945; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT 
TABLE ACCESS FULL PEOPLE;

CREATE INDEX unc_tree_movie ON movie(year); 
CREATE INDEX unc_tree_people ON people(birthYear);
EXPLAIN PLAN SET STATEMENT_ID = 'Z1_C1' FOR SELECT movieTitle FROM movie 
WHERE year > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_C1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

EXPLAIN PLAN SET STATEMENT_ID = 'Z1_C2' FOR SELECT personName FROM people 
WHERE birthYear > 1945;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_C2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
TABLE ACCESS FULL PEOPLE;

SELECT movieID, movieTitle
FROM movie
WHERE movieID != 0046778 and year > 1985;

EXPLAIN PLAN SET STATEMENT_ID = 'Z1_E1' FOR SELECT movieID, movieTitle FROM movie 
WHERE movieID != 0046778 and year > 1985;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_E1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 1; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query1; 
SELECT movieID, movieTitle FROM movie 
WHERE movieID != 0046778 and year > 1985; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT 
TABLE ACCESS FULL MOVIE;

SELECT movieID, movieTitle
FROM movie
WHERE movieID = 0046778 and year > 1985;

EXPLAIN PLAN SET STATEMENT_ID = 'Z1_E2' FOR SELECT movieID, movieTitle FROM movie 
WHERE movieID = 0046778 and year > 1985;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z1_E2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 2; 
set termout off; 
variable n number 
exec :n := dbms_utility.get_time 
timing start query2; 
SELECT movieID, movieTitle FROM movie 
WHERE movieID = 0046778 and year > 1985; 
set termout on; 
exec :n := (dbms_utility.get_time - :n)/100 
exec dbms_output.put_line(:n) 
timing stop;

SELECT STATEMENT 
TABLE ACCESS HASH MOVIE;

drop table plays;

CREATE TABLE plays (personID char(50) not null, movieID numeric(7) not null) 
CLUSTER movie_cluster (movieID);

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_B1' FOR SELECT movieTitle
FROM movie WHERE year > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z2_B1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

prompt run query 1; set termout off; variable n number exec :n := dbms_utility.get_time timing start query1; SELECT movieTitle FROM movie 
WHERE year > 1990; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
TABLE ACCESS BY INDEX ROWID MOVIE 
INDEX RANGE SCAN UNC_TREE_MOVIE;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_B2' FOR SELECT personName FROM people WHERE birthYear > 1945;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_B2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; set termout off; variable n number exec :n := dbms_utility.get_time timing start query2; SELECT personName FROM people 
WHERE birthYear > 1945; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
TABLE ACCESS BY INDEX ROWID PEOPLE 
INDEX RANGE SCAN UNC_TREE_PEOPLE;

SELECT m.movieID, m.movieTitle, p.companyID
FROM movie m, producedBy p
WHERE m.movieID = p.movieID and m.movieID = 0046799 and m.movieTitle = 'Boot Polish (1954)';

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_E1' FOR SELECT movieID, movieTitle FROM movie WHERE movieID != 0046778 and year > 1985;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z2_E1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 1; set termout off; variable n number exec :n := dbms_utility.get_time timing start query1; SELECT movieID, movieTitle FROM movie 
WHERE movieID != 0046778 and year > 1985; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
TABLE ACCESS BY INDEX ROWID MOVIE 
INDEX RANGE SCAN UNC_TREE_MOVIE;

EXPLAIN PLAN SET STATEMENT_ID = 'Z2_E2' FOR SELECT movieID, movieTitle FROM movie WHERE movieID = 0046778 and year > 1985;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z2_E2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; set termout off; variable n number exec :n := dbms_utility.get_time timing start query2; SELECT movieID, movieTitle FROM movie 
WHERE movieID = 0046778 and year > 1985; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
TABLE ACCESS HASH MOVIE;

CREATE UNIQUE INDEX unc_tree_movietitle ON movie(movieTitle);
EXPLAIN PLAN SET STATEMENT_ID = 'Z2_F' FOR SELECT m.movieID, m.movieTitle, p.companyID FROM movie m, producedBy p 
WHERE m.movieID = p.movieID and m.movieID = 0046790 and m.movieTitle = 'Boot Polish (1954)';
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z2_F' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;

SELECT STATEMENT 
MERGE JOIN 
HASH ACCESS HASH MOVIE 
FILTER 
TABLE ACCESS FULL PRODUCEDBY;

drop index unc_tree_movieTitle;

SELECT /*+ ORDERED USE_HASH(p,pl) */ pl.movieID
FROM people p, plays pl
WHERE p.personID = pl.personID and p.birthYear > 1990;

ALTER SESSION SET OPTIMIZER_MODE = RULE;

EXPLAIN PLAN SET STATEMENT_ID = 'Z3_A1' FOR SELECT /*+ ORDERED USE_HASH(p,pl) */ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE WHERE STATEMENT_ID='Z3_A1' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; set termout off; variable n number exec :n := dbms_utility.get_time timing start query2; 
SELECT /*+ ORDERED USE_HASH(p,pl)*/ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

ALTER SESSION SET OPTIMIZER_MODE = FIRST_ROWS;

EXPLAIN PLAN SET STATEMENT_ID = 'Z3_A2' FOR SELECT /*+ ORDERED USE_HASH(p,pl)*/ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z3_A2' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; set termout off; variable n number exec :n := dbms_utility.get_time timing start query2; SELECT /*+ ORDERED USE_HASH(p,pl)*/ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS BY INDEX ROWID BATCHED PEOPLE 
INDEX RANGE SCAN UNC_TREE_PEOPLE 
TABLE ACCESS FULL PLAYS;

ALTER SESSION SET OPTIMIZER_MODE = ALL_ROWS;

EXPLAIN PLAN SET STATEMENT_ID = 'Z3_A3'
FOR SELECT /*+ ORDERED USE_HASH(p,pl)*/ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990;
SELECT ID||' '||PARENT_ID||' '||LPAD(' ', 2*(LEVEL-1))||OPERATION||' '||OPTIONS||' '||OBJECT_NAME "QUERY PLAN" FROM PLAN_TABLE 
WHERE STATEMENT_ID='Z3_A3' START WITH ID = 0 CONNECT BY PRIOR ID=PARENT_ID;
prompt run query 2; set termout off; variable n number exec :n := dbms_utility.get_time timing start query2; SELECT /*+ ORDERED USE_HASH(p,pl)*/ pl.movieID FROM people p, plays pl 
WHERE p.personID = pl.personID and p.birthYear > 1990; set termout on; exec :n := (dbms_utility.get_time - :n)/100 exec dbms_output.put_line(:n) timing stop;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

drop index unc_tree_people;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

CREATE BITMAP INDEX bitmap_birth_year ON people (birthYear);

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

SELECT STATEMENT HASH JOIN TABLE ACCESS BY INDEX ROWID BATCHED PEOPLE BITMAP CONVERSION TO ROWIDS BITMAP INDEX RANGE SCAN BITMAP_BIRTH_YEAR TABLE ACCESS FULL PLAYS;

SELECT STATEMENT 
HASH JOIN 
TABLE ACCESS FULL PEOPLE 
TABLE ACCESS FULL PLAYS;

CREATE CLUSTER clu_people_cluster (birthYear numeric(4)); CREATE INDEX clu_tree_people ON CLUSTER clu_people_cluster; CREATE TABLE people (personID char(50) not null, personName char(50) not null, birthYear numeric(4), deathYear numeric(4)) CLUSTER clu_people_cluster(birthYear);
SELECT STATEMENT HASH JOIN TABLE ACCESS CLUSTER PEOPLE
INDEX RANGE SCAN CLU_TREE_PEOPLE TABLE ACCESS FULL PLAYS


SELECT STATEMENT HASH JOIN TABLE ACCESS CLUSTER PEOPLE INDEX RANGE SCAN CLU_TREE_PEOPLE TABLE ACCESS FULL PLAYS;
