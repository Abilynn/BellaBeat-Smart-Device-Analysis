--combining all common files from both folders
SELECT *
INTO dailyActivity
FROM (
	SELECT * FROM dailyActivity_merged
	UNION ALL
	SELECT * FROM dailyActivity_merged2

	) AS combined_data

ALTER TABLE dailyActivity
ALTER COLUMN id BIGINT


SELECT *
INTO heartrate_seconds
FROM (
	SELECT * FROM heartrate_seconds_merged
	UNION ALL
	SELECT * FROM heartrate_seconds_merged2

	) AS combined_data

SELECT *
INTO hourlyCalories
FROM (
	SELECT * FROM hourlyCalories_merged
	UNION ALL
	SELECT * FROM hourlyCalories_merged2

	) AS combined_data


SELECT *
INTO hourlyIntensities
FROM (
	SELECT * FROM hourlyIntensities_merged
	UNION ALL
	SELECT * FROM hourlyIntensities_merged2

	) AS combined_data

SELECT *
INTO hourlySteps
FROM (
	SELECT * FROM hourlySteps_merged
	UNION ALL
	SELECT * FROM hourlySteps_merged2

	) AS combined_data

SELECT *
INTO minuteCaloriesNarrow
FROM (
	SELECT * FROM minuteCaloriesNarrow_merged
	UNION ALL
	SELECT * FROM minuteCaloriesNarrow_merged2

	) AS combined_data

SELECT *
INTO minuteIntensitiesNarrow
FROM (
	SELECT * FROM minuteIntensitiesNarrow_merged
	UNION ALL
	SELECT * FROM minuteIntensitiesNarrow_merged2

	) AS combined_data

SELECT *
INTO minuteMetsNarrow
FROM (
	SELECT * FROM minuteMetsNarrow_merged
	UNION ALL
	SELECT * FROM minuteMetsNarrow_merged2

	) AS combined_data

SELECT *
INTO minuteSleep
FROM (
	SELECT * FROM minuteSleep_merged
	UNION ALL
	SELECT * FROM minuteSleep_merged2

	) AS combined_data

SELECT *
INTO minuteStepsNarrow
FROM (
	SELECT * FROM minuteStepsNarrow_merged
	UNION ALL
	SELECT * FROM minuteStepsNarrow_merged2

	) AS combined_data

SELECT *
INTO weightLogInfo
FROM (
	SELECT * FROM weightLogInfo_merged
	UNION ALL
	SELECT * FROM weightLogInfo_merged2

	) AS combined_data

