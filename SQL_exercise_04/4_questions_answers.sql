-- https://en.wikibooks.org/wiki/SQL_Exercises/Movie_theatres
-- 4.1 Select the title of all movies.
SELECT Title
FROM movies;

-- 4.2 Show all the distinct ratings in the database.
SELECT DISTINCT Rating
FROM movies;

-- 4.3  Show all unrated movies.
SELECT *
FROM movies
WHERE rating IS NULL;

-- 4.4 Select all movie theaters that are not currently showing a movie.
SELECT Name
FROM movietheaters
WHERE movie IS NULL;

-- 4.5 Select all data from all movie theaters 
SELECT *
FROM movietheaters;
    -- and, additionally, the data from the movie that is being shown in the theater (if one is being shown).
SELECT *
FROM movietheaters a JOIN movies b 
ON a.movie = b.code;

-- 4.6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
SELECT *
FROM movies a LEFT JOIN movietheaters b
ON a.code = b.movie;

-- 4.7 Show the titles of movies not currently being shown in any theaters.
SELECT a.Title
FROM movies a LEFT JOIN movietheaters b
ON a.code = b.movie
WHERE b.Name IS NULL;

-- 4.8 Add the unrated movie "One, Two, Three".
SELECT *
FROM movies;

INSERT INTO Movies(Code,Title,Rating)
VALUES(9,"One, Two, Three",Null);

-- 4.9 Set the rating of all unrated movies to "G".
UPDATE movies
SET Rating = "G"
WHERE Rating IS NULL; 

SELECT *
FROM movies;

-- 4.10 Remove movie theaters projecting movies rated "NC-17".
DELETE FROM movietheaters
WHERE Movie IN (
	SELECT Code
	FROM Movies
	WHERE Rating = "NC-17");

SELECT *
FROM movietheaters