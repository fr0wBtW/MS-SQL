USE Geography

SELECT CountryName, IsoCode
FROM Countries
WHERE UPPER (CountryName) LIKE '%A%A%A%'
ORDER BY IsoCode

SELECT PeakName, 
RiverName,
LOWER (PeakName) + LOWER(SUBSTRING(RiverName, 2, LEN(RiverName) - 1)) AS Mix
FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix
