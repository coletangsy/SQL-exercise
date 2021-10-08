-- https://en.wikibooks.org/wiki/SQL_Exercises/Pieces_and_providers
-- 5.1 Select the name of all the pieces. 
SELECT Name
FROM pieces;

-- 5.2  Select all the providers' data. 
SELECT *
FROM providers;

-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
SELECT Piece, AVG(Price)
FROM provides
GROUP BY Piece;

-- 5.4  Obtain the names of all providers who supply piece 1.
SELECT a.Name
FROM providers a JOIN provides b
ON a.code = b.Provider
WHERE Piece = 1;

-- 5.5 Select the name of pieces provided by provider with code "HAL".
SELECT *
FROM pieces
WHERE Code IN 
(
	SELECT Piece
	FROM provides
	WHERE Provider = "HAL"
);
    
-- 5.6
-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Interesting and important one.
-- For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
-- (note that there could be two providers who supply the same piece at the most expensive price).
-- ---------------------------------------------
SELECT Pieces.Name AS Pieces, Providers.Name AS Providers, MAX(Provides.Price) AS Price
FROM Pieces JOIN provides ON Pieces.Code = provides.Piece
			JOIN providers ON Provides.Provider = providers.Code
GROUP BY Pieces.Code;

-- 5.7 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
SELECT *
FROM provides;

INSERT INTO provides
VALUES(1,"TNBC",7);

-- 5.8 Increase all prices by one cent.
UPDATE provides
SET Price = Price + 1;

-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
DELETE FROM provides
WHERE Provider = "RBT" AND Piece = 4;

-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces 
    -- (the provider should still remain in the database).
DELETE FROM provides
WHERE Provider = "RBT"