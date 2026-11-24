-- 1. Count all imported chart-week rows
SELECT COUNT(*) AS TotalRows
FROM dbo.charts;


-- 2. Check the earliest and latest chart dates
SELECT
    MIN([date]) AS EarliestDate,
    MAX([date]) AS LatestDate
FROM dbo.charts;


-- 3. Count missing values in each column
SELECT
    SUM(CASE WHEN [date] IS NULL THEN 1 ELSE 0 END) AS MissingDates,
    SUM(CASE WHEN rank IS NULL THEN 1 ELSE 0 END) AS MissingRanks,
    SUM(CASE WHEN song IS NULL THEN 1 ELSE 0 END) AS MissingSongs,
    SUM(CASE WHEN artist IS NULL THEN 1 ELSE 0 END) AS MissingArtists,
    SUM(CASE WHEN last_week IS NULL THEN 1 ELSE 0 END) AS MissingLastWeek,
    SUM(CASE WHEN peak_rank IS NULL THEN 1 ELSE 0 END) AS MissingPeakRank,
    SUM(CASE WHEN weeks_on_board IS NULL THEN 1 ELSE 0 END) AS MissingWeeksOnBoard
FROM dbo.charts;


-- 4. See how missing last_week values relate to weeks on the chart
SELECT
    weeks_on_board,
    COUNT(*) AS RowsMissingLastWeek
FROM dbo.charts
WHERE last_week IS NULL
GROUP BY weeks_on_board
ORDER BY weeks_on_board;


-- 5. Inspect up to 20 examples where last_week is missing
--    even though the song has charted before
SELECT TOP (20)
    [date], rank, song, artist, last_week, weeks_on_board
FROM dbo.charts
WHERE last_week IS NULL
  AND weeks_on_board > 1
ORDER BY [date], rank;


-- 6. Trace one example song's chart history
SELECT [date], rank, last_week, weeks_on_board
FROM dbo.charts
WHERE song = 'Hey Girl - Hey Boy'
  AND artist = 'Oscar McLollie and Jeanette Baker'
ORDER BY [date];


-- 7. Find chart dates that don't have exactly 100 rows
SELECT [date], COUNT(*) AS SongsOnChart
FROM dbo.charts
GROUP BY [date]
HAVING COUNT(*) <> 100
ORDER BY [date];

-- Only 13 dates dont have exactly 100 rows instead they are all at 99 
-- I am going to leave this alone as 13 out of 330,000 rows is negligible 