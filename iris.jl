using DelimitedFiles

# Load the Iris dataset into a Matrix
irisData = readdlm("/path/to/iris.csv", ',', skipstart=1)

# Calculate the mean, median, and standard deviation of each variable for each species
function calculateMeansBySpecies(data)
    speciesMeans = Dict{String, Vector{Float64}}()
    speciesData = separateDataBySpecies(data)
    for species in keys(speciesData)
        data = speciesData[species]
        means = Float64[]
        for i in 1:size(data, 2)
            col = data[:, i]
            meanValue = mean(col)
            push!(means, meanValue)
        end
        speciesMeans[species] = means
    end
    return speciesMeans
end

function calculateMediansBySpecies(data)
    speciesMedians = Dict{String, Vector{Float64}}()
    speciesData = separateDataBySpecies(data)
    for species in keys(speciesData)
        data = speciesData[species]
        medians = Float64[]
        for i in 1:size(data, 2)
            col = data[:, i]
            medianValue = median(col)
            push!(medians, medianValue)
        end
        speciesMedians[species] = medians
    end
    return speciesMedians
end

function calculateStdDevsBySpecies(data)
    speciesStdDevs = Dict{String, Vector{Float64}}()
    speciesData = separateDataBySpecies(data)
    for species in keys(speciesData)
        data = speciesData[species]
        stdDevs = Float64[]
        for i in 1:size(data, 2)
            col = data[:, i]
            stdDevValue = std(col)
            push!(stdDevs, stdDevValue)
        end
        speciesStdDevs[species] = stdDevs
    end
    return speciesStdDevs
end

function separateDataBySpecies(data)
    speciesData = Dict{String, Matrix{Float64}}()
    for row in eachrow(data)
        species = row[end]
        if !(species in keys(speciesData))
            speciesData[species] = Matrix{Float64}()
        end
        push!(speciesData[species], row[1:end-1])
    end
    return speciesData
end

speciesMeans = calculateMeansBySpecies(irisData)
speciesMedians = calculateMediansBySpecies(irisData)
speciesStdDevs = calculateStdDevsBySpecies(irisData)

# Combine the mean, median, and standard deviation into a single Dict
speciesStats = Dict("Mean" => speciesMeans, "Median" => speciesMedians, "Std Dev" => speciesStdDevs)

# Print out the mean, median, and standard deviation of each variable for each species
for (statType, stats) in speciesStats
    println(statType)
    for (species, values) in stats
        println("$species: $values")
    end
    println()
end

# Calculate the correlation matrix between each pair of variables
corMatrix = cor(irisData[:, 1:end-1])

# Print out the correlation matrix
println("Correlation Matrix")
println(corMatrix)

# TODO: Create a scatter plot matrix of the variables
