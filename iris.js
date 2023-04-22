// Create a new database and collection for the Iris dataset
use iris_dataset
db.createCollection("iris")

// Load the Iris dataset into the collection
mongoimport --db iris_dataset --collection iris --type csv --headerline --file /path/to/iris.csv

// Calculate the mean, median, and standard deviation of each variable for each species
db.iris.aggregate([
  { $group: {
      _id: "$species",
      sepal_length_mean: { $avg: "$sepal_length" },
      sepal_width_mean: { $avg: "$sepal_width" },
      petal_length_mean: { $avg: "$petal_length" },
      petal_width_mean: { $avg: "$petal_width" },
      sepal_length_median: { $median: "$sepal_length" },
      sepal_width_median: { $median: "$sepal_width" },
      petal_length_median: { $median: "$petal_length" },
      petal_width_median: { $median: "$petal_width" },
      sepal_length_stddev: { $stdDevPop: "$sepal_length" },
      sepal_width_stddev: { $stdDevPop: "$sepal_width" },
      petal_length_stddev: { $stdDevPop: "$petal_length" },
      petal_width_stddev: { $stdDevPop: "$petal_width" }
    }
  }
])

// Calculate the correlation between each pair of variables
db.iris.aggregate([
  { $group: {
      _id: null,
      sepal_length_sepal_width_correlation: { $corr: [ "$sepal_length", "$sepal_width" ] },
      sepal_length_petal_length_correlation: { $corr: [ "$sepal_length", "$petal_length" ] },
      sepal_length_petal_width_correlation: { $corr: [ "$sepal_length", "$petal_width" ] },
      sepal_width_petal_length_correlation: { $corr: [ "$sepal_width", "$petal_length" ] },
      sepal_width_petal_width_correlation: { $corr: [ "$sepal_width", "$petal_width" ] },
      petal_length_petal_width_correlation: { $corr: [ "$petal_length", "$petal_width" ] }
    }
  }
])

// Calculate the mean sepal length for each species and compare to the overall mean
db.iris.aggregate([
  { $group: {
      _id: "$species",
      mean_sepal_length: { $avg: "$sepal_length" }
    }
  },
  { $sort: { mean_sepal_length: -1 } },
  { $project: {
      _id: 0,
      species: "$_id",
      mean_sepal_length: 1,
      difference_from_overall_mean: { $subtract: [ "$mean_sepal_length", db.iris.aggregate([ { $group: { _id: null, mean_sepal_length: { $avg: "$sepal_length" } } } ]).toArray()[0].mean_sepal_length ] }
    }
  }
])
