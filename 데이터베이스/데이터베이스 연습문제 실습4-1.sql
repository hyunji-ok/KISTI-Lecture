USE movie_db;

CREATE TABLE Movie(
	title CHAR(50),
	year INT,
	length INT,
	isColor BOOLEAN DEFAULT TRUE,
	studioName CHAR(30),
	producerID CHAR(6) );

INSERT INTO Movie VALUES('Star wars', 1977, 124, TRUE, 'Fox', 'ME-001');
INSERT INTO Movie VALUES('Mighty Ducks', 1991, 104, TRUE, 'Disney', 'ME-002');
INSERT INTO Movie VALUES('Wayne''s World', 1992, 95, TRUE, 'Paramount', 'ME-003');
INSERT INTO Movie VALUES('Pretty Woman', 1990, 119, FALSE, 'Disney', 'ME-002');
INSERT INTO Movie VALUES('The Maltese Falcon', 1980, 70, TRUE, 'MGM', 'ME-004');
INSERT INTO Movie VALUES('Spider-Man', 2002, NULL, TRUE, 'MGM', 'ME-004');
INSERT INTO Movie VALUES('Star wars', 2004, 150, TRUE, 'Bluesky', 'ME-005');
INSERT INTO Movie VALUES('Tarzan', 2004, 130, TRUE, 'Starking', 'ME-006');




CREATE TABLE MovieStar(
	name CHAR(30),
	address VARCHAR(255),
	gender CHAR(1),
	birthdate DATE DEFAULT '1900-01-01');

INSERT INTO MovieStar VALUES ('Carrie Fisher', 'Hollywood', 'M', '1950-05-05');
INSERT INTO MovieStar VALUES ('Mark Hamill', 'Hollywood', 'M', '1946-04-06');
INSERT INTO MovieStar VALUES ('Harrison Ford', 'Beverly Hills', 'M', '1948-04-08');
INSERT INTO MovieStar VALUES ('Emilio Esteves', 'Beverly Hills', 'F', '1948-10-15');
INSERT INTO MovieStar VALUES ('Dana Carvey', 'Manhattan', 'F', '1947-07-07');
INSERT INTO MovieStar VALUES ('Mike Meyers', 'Manhattan', 'F', '1946-06-06');
INSERT INTO MovieStar VALUES ('Sydney Greenstreet', 'Hollywood', 'F', '1953-05-03');




CREATE TABLE StarsIn(
	movietitle CHAR(50),
	movieyear INT,
	starname CHAR(30) );

INSERT INTO StarsIn VALUES ('Star wars', 1977, 'Carrie Fisher');
INSERT INTO StarsIn VALUES ('Star wars', 1977, 'Mike Meyers');
INSERT INTO StarsIn VALUES ('Star wars', 1977, 'Harrison Ford');
INSERT INTO StarsIn VALUES ('Mighty Ducks', 1991, 'Emilio Esteves');
INSERT INTO StarsIn VALUES ('Wayne''s World', 1992, 'Dana Carvey');
INSERT INTO StarsIn VALUES ('Wayne''s World', 1992, 'Mark Hamill');
INSERT INTO StarsIn VALUES ('Pretty Woman', 1990, 'Harrison Ford');
INSERT INTO StarsIn VALUES ('The Maltese Falcon', 1980, 'Sydney Greenstreet');
INSERT INTO StarsIn VALUES ('Spider-Man', 2002, 'Harrison Ford');
INSERT INTO StarsIn VALUES ('Star wars', 2004, 'Mike Meyers');
INSERT INTO StarsIn VALUES ('Star wars', 2004, 'Dana Carvey');




CREATE TABLE MovieExec(
	name CHAR(30),
	address VARCHAR(255),
	certID CHAR(6),
	netWorth INT);

INSERT INTO MovieExec VALUES ('David Nutter', 'Hollywood', 'ME-001', 20000000);
INSERT INTO MovieExec VALUES ('Paul Newman', 'Manhattan', 'ME-002', 3000000);
INSERT INTO MovieExec VALUES ('Dana Carvey', 'Manhattan', 'ME-003', 30000000);
INSERT INTO MovieExec VALUES ('Gary Ross', 'Buena Vista', 'ME-004', 15000000);
INSERT INTO MovieExec VALUES ('Tom Frank', 'Malibu', 'ME-005', 9000000);




CREATE TABLE Studio(
	name CHAR(30),
	address VARCHAR(255),
	presID CHAR(6) );

INSERT INTO Studio VALUES ('Fox', 'Hollywood', 'ME-001');
INSERT INTO Studio VALUES ('Disney', 'Buena Vista', 'ME-002');
INSERT INTO Studio VALUES ('Paramount', 'Manhattan', 'ME-003');
INSERT INTO Studio VALUES ('MGM', 'Hollywood', 'ME-004');
INSERT INTO Studio VALUES ('Bluesky', 'Malibu', 'ME-005');

####################################################################

SELECT * FROM Movie WHERE studioName = 'Disney' AND YEAR =1990;

SELECT title, length FROM Movie WHERE studioName = 'Disney' AND YEAR =1990;

SELECT title AS name, length AS 'duration' FROM Movie WHERE studioName = 'Disney' AND YEAR =1990;

SELECT title AS name, length AS 'duration' FROM Movie WHERE studioName = 'disney' AND YEAR =1990;

SELECT title AS name, length AS 'duration' FROM Movie WHERE BINARY studioName = 'disney' AND YEAR =1990;

SELECT title , LENGTH*0.0167 AS duration, 'hrs.' AS inHours FROM Movie WHERE studioName = 'Disney' AND YEAR =1990;

SELECT title FROM Movie WHERE YEAR>1970 AND NOT isColor;

SELECT title 
FROM movie 
WHERE (YEAR>1970 OR LENGTH<90) AND studioName='MGM';

SELECT title 
FROM movie 
WHERE title LIKE 'Star%';

SELECT title 
FROM movie 
WHERE title LIKE '%''s%';

SELECT title 
FROM movie 
WHERE YEAR>1980 AND LENGTH IS NOT NULL ORDER BY LENGTH, title;

SELECT title 
FROM movie 
WHERE YEAR>1980 AND LENGTH IS NOT NULL ORDER BY LENGTH DESC , title;






#################################################################

SELECT address 
FROM studio 
WHERE NAME='MGM';

SELECT birthdate 
FROM moviestar 
WHERE name='Harrison Ford';

SELECT starname
FROM starsIn 
WHERE movieyear=1990 OR movietitle LIKE '%world%';

SELECT name
FROM movieexec 
WHERE networth>=10000000;

SELECT name 
FROM moviestar 
WHERE gender='M' OR address='Hollywood';


############################################################

SELECT name 
FROM movie, movieexec 
WHERE title='star wars' AND producerid=certid;

SELECT moviestar.name, movieexec.name 
FROM moviestar, movieexec 
WHERE moviestar.address = movieexec.address;

SELECT star1.name, star2.name 
FROM moviestar AS Star1, moviestar AS Star2 
WHERE star1.address = star2.address AND star1.name<star2.name;


################################################################

SELECT moviestar.name 
FROM starsin, moviestar 
WHERE movie.title='star wars' AND starsin.starname=moviestar.name and moviestar.gender='M';

SELECT starsin.starname 
FROM studio, movie, starsin
WHERE studio.name='MGM' AND studio.presid = movie.producerid AND movie.year=1980 AND movie.title=starsin.movietitle;

SELECT movie2.title 
FROM movie AS movie1, movie AS movie2 
WHERE movie1.title='Wayne''s World' AND movie1.length < movie2.length ;

########################################################################

SELECT NAME
FROM movieexec
WHERE certid = 
	(SELECT producerid
	FROM movie
	WHERE title = 'star wars' AND YEAR = 1977);
	
	
SELECT NAME
FROM movieexec
WHERE certid IN
	(SELECT producerid
	FROM movie
	WHERE (title, YEAR) in
		(SELECT movietitle, movieyear
		FROM starsin
		WHERE starname = 'harrison ford'));
		
		
SELECT NAME
FROM movieexec, movie, starsin
WHERE certid = producerid AND
	title = movietitle and
	YEAR = movieyear and
	starname = 'harrison ford';


#######################################

SELECT *
FROM movie INNER JOIN starsin ON
	title = movietitle AND YEAR = movieyear;

SELECT *
FROM movie cross JOIN starsin 

#########################################

SELECT DISTINCT title FROM movie;

SELECT title FROM movie;

SELECT COUNT(*)
FROM movieexec;

SELECT COUNT(DISTINCT NAME)
FROM movieexec;

SELECT AVG(networth)
FROM movieexec;

SELECT studioname, SUM(LENGTH)
FROM movie
GROUP BY studioname;







