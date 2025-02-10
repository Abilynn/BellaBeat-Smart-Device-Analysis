--calculating the average daily step counts, and how do they vary across users

SELECT
	Id,
	AVG(TotalSteps) AvgDailySteps,
	Max(TotalSteps) MaxDailySteps,
	MIN(TotalSteps) MinDailySteps

FROM dailyActivity
GROUP BY Id
ORDER BY AvgDailySteps DESC


--which days of the week show the highest and lowest physical activity levels?

SELECT
    DATENAME(WEEKDAY, ActivityDate) DayOfWeek,
    AVG(TotalSteps) AvgSteps,
    SUM(TotalSteps) TotalSteps, 
    COUNT(Id) NumberOfUsers
FROM dailyActivity
GROUP BY DATENAME(WEEKDAY, ActivityDate)
ORDER BY 
    CASE DATENAME(WEEKDAY, ActivityDate)
        WHEN 'Sunday' THEN 1
        WHEN 'Monday' THEN 2
        WHEN 'Tuesday' THEN 3
        WHEN 'Wednesday' THEN 4
        WHEN 'Thursday' THEN 5
        WHEN 'Friday' THEN 6
        WHEN 'Saturday' THEN 7
END


--how do activity levels vary by time of day

SELECT 
    Id,
    CASE 
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 18 AND 23 THEN 'Evening'
    END AS TimeOfDay,
    AVG(StepTotal) AS AvgSteps
FROM hourlySteps
GROUP BY Id,
	CASE 
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 18 AND 23 THEN 'Evening'
    END
ORDER BY Id, AvgSteps DESC


--most common activity patterns among users?

SELECT Id,
	COUNT(*) ActivityRecords,
	AVG(StepTotal) Steps
FROM hourlySteps
GROUP BY Id
ORDER BY ActivityRecords DESC, Steps DESC


--how do Activity levels differ weekdays and weekends

SELECT
	CASE
		WHEN DATENAME(WEEKDAY, ActivityDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
		ELSE 'Weekday'
		END DayType,
		AVG(TotalSteps) AvgSteps,
		SUM(TotalSteps) TotalSteps,
		COUNT(DISTINCT Id) NumofUsers
FROM dailyActivity
GROUP BY
	CASE 
        WHEN DATENAME(WEEKDAY, ActivityDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY DayType

--average sleep duration across users

SELECT
	Id,
	AVG(TotalMinutesAsleep) AvgSleepDuration,
	MIN(TotalMinutesAsleep) MinSleepDuration,
	MAX(TotalMinutesAsleep) MaxSleepDuration
FROM sleepDay
GROUP BY Id
ORDER BY AvgSleepDuration DESC

--Overall average sleep duration across users

SELECT
	AVG(TotalMinutesAsleep) OverallSleepDuration
FROM sleepDay


--correlations between sleep quality (deep sleep vs. light sleep) and activity levels

SELECT
	sd.Id,
	AVG(sd.TotalMinutesAsleep) AvgMinutesAsleep,
	AVG(sd.TotalTimeInBed - sd.TotalMinutesAsleep) AvgMinutesAwake,
	AVG(da.TotalSteps) AvgSteps,
	AVG(da.VeryActiveMinutes) AvgVeryActiveMinutes,
	AVG(da.Calories) AvgCalories
FROM sleepDay sd
JOIN dailyActivity da
	ON sd.Id = da.Id
	AND CAST(sd.SleepDay AS DATE) = da.ActivityDate
GROUP BY sd.Id
ORDER BY AvgMinutesAsleep DESC


--sleep trends across weekdays and weekends

SELECT
    CASE
        WHEN DATENAME(WEEKDAY, SleepDay) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END DayType,
    AVG(TotalMinutesAsleep) AS AvgMinutesAsleep,
    AVG(TotalTimeInBed) AS AvgTimeInBed,
    COUNT(DISTINCT Id) AS NumofUsers
FROM sleepDay
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, SleepDay) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY DayType


--trends in daily calorie expenditure across users

SELECT
	Id,
	ActivityDate,
	CASE
        WHEN DATENAME(WEEKDAY, ActivityDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END DayType,
	Calories,
	AVG(Calories) OVER (PARTITION BY Id) AvgCaloriesPerUser,
	SUM(Calories) OVER (PARTITION BY Id) TotalCaloriesPerUser
FROM dailyActivity
ORDER BY Id, ActivityDate


--identifying common traits of highly active users vs. less active users

WITH UserActivity AS (
	SELECT
		Id,
		AVG(TotalSteps) AvgDailySteps,
		AVG(Calories) AvgDailyCalories,
		AVG(VeryActiveMinutes) AvgVeryActiveMinutes,
		AVG(LightlyActiveMinutes) AvgLightlyActiveMinutes,
		AVG(SedentaryMinutes) AvgSedentaryMinutes
	FROM dailyActivity
	GROUP BY Id
),
UserSegment AS (
	SELECT
		Id,
		AvgDailySteps,
		AvgDailyCalories,
		AvgVeryActiveMinutes,
		AvgLightlyActiveMinutes,
		AvgSedentaryMinutes,
		CASE
			WHEN AvgDailySteps >= 8000 THEN 'Highly Active'
			ELSE 'Less Active'
		END AS ActivityLevel
	FROM UserActivity
)
SELECT
	 ActivityLevel,
    COUNT(Id) NumOfUsers,
    AVG(AvgDailySteps) AverageSteps,
    AVG(AvgDailyCalories) AverageCalories,
    AVG(AvgVeryActiveMinutes) AverageVeryActiveMinutes,
    AVG(AvgLightlyActiveMinutes) AverageLightlyActiveMinutes,
    AVG(AvgSedentaryMinutes) AverageSedentaryMinutes
FROM UserSegment
GROUP BY ActivityLevel
ORDER BY 
    CASE ActivityLevel
        WHEN 'Highly Active' THEN 1
        WHEN 'Less Active' THEN 2
    END



/*Analyzing correlation between Sleep Consistency and Health Metrics
Defined as:
Consistent Sleep-Users with a standard deviation in their total sleep duration lower than 60.
Inconsistent Sleep-Users with a standard deviation in their total sleep duration higher than 60.*/

WITH sleepConsistency AS (
	SELECT
		Id,
		ROUND(STDEV(TotalMinutesAsleep),2) SleepConsistencyScore,
		AVG(TotalMinutesAsleep) AvgMinutesAsleep,
		AVG(TotalTimeinBed) AvgTimeinBed
	FROM sleepDay
	GROUP BY Id
),
healthMetrics AS (
	SELECT
		Id,
		AVG(TotalSteps) AvgSteps,
		AVG(Calories) AvgCalories,
		AVG(VeryActiveMinutes) AvgVeryActiveMinutes
	FROM dailyActivity
	GROUP BY Id
)
SELECT
	s.Id,
	CASE
		WHEN SleepConsistencyScore < 60 THEN 'Consistent Sleep'
		ELSE 'Inconsistent Sleep'
	END SleepPattern,
	s.AvgMinutesAsleep,
	s.SleepConsistencyScore,
	h.AvgSteps,
	h.AvgCalories,
	h.AvgVeryActiveMinutes
FROM sleepConsistency s
JOIN healthMetrics h
ON s.Id = h.Id
ORDER BY SleepPattern, AvgSteps



--most active time frames for users

SELECT
	DATEPART(HOUR,ActivityHour) HourofDay,
	AVG(StepTotal) AvgSteps,
	SUM(StepTotal) TotalSteps,
	COUNT(DISTINCT Id) NumofUsers
FROM hourlySteps
GROUP BY DATEPART(HOUR,ActivityHour)
ORDER BY AvgSteps DESC


--Highly/Less Active UserContribution
WITH UserSteps AS (
SELECT
	Id,
	SUM(TotalSteps) SumofTotalSteps
FROM dailyActivity
GROUP BY Id
),
UserActivity AS (
SELECT
	Id,
	SumofTotalSteps,
	CASE
			WHEN SumofTotalSteps >= 250000 THEN 'Highly Active'
			ELSE 'Less Active'
		END AS ActivityLevel
FROM UserSteps
)
SELECT
	ActivityLevel,
	SUM(SumofTotalSteps) ActivityTotalSteps
FROM UserActivity
GROUP BY ActivityLevel

--
