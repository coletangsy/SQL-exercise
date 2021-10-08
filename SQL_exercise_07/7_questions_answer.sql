-- https://en.wikibooks.org/wiki/SQL_Exercises/Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".
SELECT Name
FROM client
WHERE AccountNumber IN (
	SELECT Recipient
	FROM Package
	WHERE Weight = 1.5
	);
-- employee , client, has_clearance, Shipment, Package, Planet --
    
-- 7.2 What is the total weight of all the packages that he sent?

SELECT SUM(Weight) AS Total_weight
FROM Package
WHERE Sender IN (
	SELECT Recipient
	FROM Package
	WHERE Weight = 1.5
    )