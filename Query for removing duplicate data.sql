SELECT Id, ActivityHour, StepTotal, COUNT(*) AS duplicateCount
FROM hourlySteps
GROUP BY Id, ActivityHour, StepTotal
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, ActivityHour, StepTotal ORDER BY (SELECT NULL)) AS RowNum
    FROM hourlySteps
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed, COUNT(*) AS duplicateCount
FROM sleepDay
GROUP BY Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed ORDER BY (SELECT NULL)) AS RowNum
    FROM sleepDay
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT Id, Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId, COUNT(*) AS duplicateCount
FROM weightLogInfo
GROUP BY Id, Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, Date, WeightKg, WeightPounds, Fat, BMI, IsManualReport, LogId ORDER BY (SELECT NULL)) AS RowNum
    FROM weightLogInfo
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT id, date, value, logid, COUNT(*) AS duplicateCount
FROM minuteSleep
GROUP BY id, date, value, logid
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id, date, value, logid ORDER BY (SELECT NULL)) AS RowNum
    FROM minuteSleep
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT Id, ActivityHour, TotalIntensity, AverageIntensity, COUNT(*) AS duplicateCount
FROM hourlyIntensities
GROUP BY Id, ActivityHour, TotalIntensity, AverageIntensity
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, ActivityHour, TotalIntensity, AverageIntensity ORDER BY (SELECT NULL)) AS RowNum
    FROM hourlyIntensities
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT Id, ActivityHour, Calories, COUNT(*) AS duplicateCount
FROM hourlyCalories
GROUP BY Id, ActivityHour, Calories
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, ActivityHour, Calories ORDER BY (SELECT NULL)) AS RowNum
    FROM hourlyCalories
)
DELETE FROM CTE
WHERE RowNum > 1;


SELECT Id, Time, Value, COUNT(*) AS duplicateCount
FROM heartrate_seconds
GROUP BY Id, Time, Value
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Id, Time, Value ORDER BY (SELECT NULL)) AS RowNum
    FROM heartrate_seconds
)
DELETE FROM CTE
WHERE RowNum > 1;