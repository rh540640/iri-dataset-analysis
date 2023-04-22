# Load the Iris dataset into a data frame
iris_df <- read.csv("/path/to/iris.csv", header = TRUE)

# Calculate the mean, median, and standard deviation of each variable for each species
species_means <- aggregate(iris_df[,1:4], by = list(species = iris_df$Species), FUN = mean)
species_medians <- aggregate(iris_df[,1:4], by = list(species = iris_df$Species), FUN = median)
species_stddevs <- aggregate(iris_df[,1:4], by = list(species = iris_df$Species), FUN = sd)

# Combine the mean, median, and standard deviation into a single data frame
species_stats <- merge(species_means, species_medians, by = "species")
species_stats <- merge(species_stats, species_stddevs, by = "species", suffixes = c("_mean", "_median", "_stddev"))

# Calculate the correlation matrix between each pair of variables
cor_matrix <- cor(iris_df[,1:4])

# Create a heatmap of the correlation matrix
library(ggplot2)
library(reshape2)
melted_cor_matrix <- melt(cor_matrix)
ggplot(melted_cor_matrix, aes(x = variable, y = variable2, fill = value)) + geom_tile() + scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) + theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Create a scatter plot matrix of the variables
pairs(iris_df[,1:4], main = "Scatter Plot Matrix of Iris Variables")

# Calculate the mean sepal length for each species and compare to the overall mean
mean_sepal_length_by_species <- aggregate(iris_df$Sepal.Length, by = list(species = iris_df$Species), FUN = mean)
overall_mean_sepal_length <- mean(iris_df$Sepal.Length)
mean_sepal_length_by_species$difference_from_overall_mean <- mean_sepal_length_by_species$x - overall_mean_sepal_length
mean_sepal_length_by_species
