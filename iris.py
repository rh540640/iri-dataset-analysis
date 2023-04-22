import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the Iris dataset into a pandas DataFrame
iris_df = pd.read_csv('/path/to/iris.csv')

# Calculate the mean, median, and standard deviation of each variable for each species
species_means = iris_df.groupby('Species').mean()
species_medians = iris_df.groupby('Species').median()
species_stddevs = iris_df.groupby('Species').std()

# Combine the mean, median, and standard deviation into a single DataFrame
species_stats = pd.concat([species_means, species_medians, species_stddevs], axis=1, keys=['Mean', 'Median', 'Std Dev'])

# Calculate the correlation matrix between each pair of variables
cor_matrix = iris_df.corr()

# Create a heatmap of the correlation matrix
sns.heatmap(cor_matrix, annot=True, cmap='coolwarm')

# Create a scatter plot matrix of the variables
sns.pairplot(iris_df, hue='Species')

# Calculate the mean sepal length for each species and compare to the overall mean
mean_sepal_length_by_species = iris_df.groupby('Species')['Sepal.Length'].mean()
overall_mean_sepal_length = iris_df['Sepal.Length'].mean()
mean_sepal_length_by_species_difference_from_overall_mean = mean_sepal_length_by_species - overall_mean_sepal_length
mean_sepal_length_by_species
