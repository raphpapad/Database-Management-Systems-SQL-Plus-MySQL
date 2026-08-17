drop table people;
create table people
(
	personID char(50) not null,
	personName char(50) not null,
	birthYear numeric(4),
	deathYear numeric(4)
);

drop table movie;
create table movie
(
	movieID numeric(7) not null,
	movieTitle char(110) not null,                                                                    
	color char(45),
	language char(20),
	year numeric(4)
);

drop table plays;
create table plays
(
	personID char(50) not null,
	movieID numeric(7) not null
);

drop table producedBy;
create table producedBy
(
	companyID char(285) not null,
	movieID numeric(7) not null
);

drop table distributedBy;
create table distributedBy
(
	companyID char(285) not null,
	movieID numeric(7) not null
);
