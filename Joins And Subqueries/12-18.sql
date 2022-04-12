USE Geography

--12. Highest Peaks in Bulgaria
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
JOIN Mountains as m
ON mc.MountainId = m.Id
JOIN Peaks AS p
ON m.Id = p.MountainId
WHERE p.Elevation > 2835 AND mc.CountryCode = 'BG'
ORDER BY p.Elevation DESC

--13. Count Mountain Ranges
SELECT c.CountryCode, COUNT(m.MountainRange) AS MountainRanges
FROM Countries AS c
JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m
ON mc.MountainId = m.Id
GROUP BY c.CountryCode 
HAVING c.CountryCode IN('BG', 'RU', 'US') 

--14. Countries with Rivers
SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
LEFT JOIN Continents AS cc
ON c.ContinentCode = cc.ContinentCode
WHERE cc.ContinentName = 'Africa'
ORDER BY c.CountryName

--15. *Continents and Currencies
SELECT
			ut.[ContinentCode],
			ut.[CurrencyCode],
			ut.[CurrencyUsage]
FROM (
	SELECT
		c.[ContinentCode],
		c.[CurrencyCode],
		COUNT(c.[CurrencyCode]) AS [CurrencyUsage],
		DENSE_RANK() OVER (PARTITION BY c.[ContinentCode] ORDER BY COUNT(c.[CurrencyCode]) DESC) AS [Rank]
		FROM [Countries] AS c
		GROUP BY c.[ContinentCode], c.[CurrencyCode]
		HAVING COUNT(c.[CurrencyCode]) > 1) AS ut
		WHERE ut.[Rank] = 1
		ORDER BY ut.[ContinentCode]

--16. Countries without any Mountains
SELECT COUNT(c.CountryCode) AS CountryCode
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
WHERE mc.CountryCode IS NULL

--17. Highest Peak and Longest River by Country
SELECT TOP(5)
	ut.[CountryName],
	ut.[Elevation] AS [HighestPeakElevation],
	ut.[Length] AS [LongestRiverLength]
FROM(
	SELECT 
c.CountryName, p.Elevation, r.[Length],
DENSE_RANK() OVER (PARTITION BY c.[CountryName] ORDER BY p.[Elevation] DESC, r.[Length] DESC) AS [Rank]
FROM Countries AS c
LEFT JOIN MountainsCountries as mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks AS p
ON mc.MountainId = p.MountainId
LEFT JOIN CountriesRivers as cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
) AS ut
WHERE ut.[Rank] = 1
ORDER BY ut.Elevation DESC, ut.[Length] DESC

--18. * Highest Peak Name and Elevation by Country
	SELECT TOP(5) dt.CountryName,
		   ISNULL(dt.PeakName, '(no highest peak)'),
		   ISNULL(dt.MaxElevation, 0),
		   ISNULL(dt.MountainRange, '(no mountain)')
	FROM
	(
SELECT c.CountryName, MAX(p.Elevation) AS MaxElevation, p.PeakName, m.MountainRange,
	DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY MAX(p.Elevation) DESC)
	AS ElevationRank
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks AS p
ON mc.MountainId = p.MountainId
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
GROUP BY c.CountryName, p.PeakName, m.MountainRange) AS dt
WHERE dt.ElevationRank = 1
ORDER BY  dt.CountryName, dt.PeakName