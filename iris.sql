-- Create a temporary table to hold the Iris dataset
CREATE TEMPORARY TABLE iris (
  sepal_length FLOAT,
  sepal_width FLOAT,
  petal_length FLOAT,
  petal_width FLOAT,
  species VARCHAR(255)
);

-- Load the Iris dataset into the temporary table
LOAD DATA LOCAL INFILE '/path/to/iris.csv' INTO TABLE iris
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

-- Calculate the mean, median, and standard deviation of each variable for each species
SELECT
  species,
  AVG(sepal_length) AS sepal_length_mean,
  AVG(sepal_width) AS sepal_width_mean,
  AVG(petal_length) AS petal_length_mean,
  AVG(petal_width) AS petal_width_mean,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_length) AS sepal_length_median,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sepal_width) AS sepal_width_median,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_length) AS petal_length_median,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY petal_width) AS petal_width_median,
  STDDEV_POP(sepal_length) AS sepal_length_stddev,
  STDDEV_POP(sepal_width) AS sepal_width_stddev,
  STDDEV_POP(petal_length) AS petal_length_stddev,
  STDDEV_POP(petal_width) AS petal_width_stddev
FROM iris
GROUP BY species;

-- Calculate the correlation between each pair of variables
SELECT
  'sepal_length' AS variable1,
  'sepal_width' AS variable2,
  CORR(sepal_length, sepal_width) AS correlation
FROM iris
UNION ALL
SELECT
  'sepal_length' AS variable1,
  'petal_length' AS variable2,
  CORR(sepal_length, petal_length) AS correlation
FROM iris
UNION ALL
SELECT
  'sepal_length' AS variable1,
  'petal_width' AS variable2,
  CORR(sepal_length, petal_width) AS correlation
FROM iris
UNION ALL
SELECT
  'sepal_width' AS variable1,
  'petal_length' AS variable2,
  CORR(sepal_width, petal_length) AS correlation
FROM iris
UNION ALL
SELECT
  'sepal_width' AS variable1,
  'petal_width' AS variable2,
  CORR(sepal_width, petal_width) AS correlation
FROM iris
UNION ALL
SELECT
  'petal_length' AS variable1,
  'petal_width' AS variable2,
  CORR(petal_length, petal_width) AS correlation
FROM iris;

-- Calculate the mean sepal length for each species and compare to the overall mean
SELECT
  species,
  AVG(sepal_length) AS mean_sepal_length,
  AVG(sepal_length) - (SELECT AVG(sepal_length) FROM iris) AS difference_from_overall_mean
FROM iris
GROUP BY species
ORDER BY mean_sepal_length DESC;
