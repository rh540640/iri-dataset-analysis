import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IrisAnalysis {

    public static void main(String[] args) {
        // Load the Iris dataset into a List of double arrays
        List<double[]> irisData = loadIrisData("/path/to/iris.csv");

        // Calculate the mean, median, and standard deviation of each variable for each species
        Map<String, double[]> speciesMeans = calculateMeansBySpecies(irisData);
        Map<String, double[]> speciesMedians = calculateMediansBySpecies(irisData);
        Map<String, double[]> speciesStdDevs = calculateStdDevsBySpecies(irisData);

        // Combine the mean, median, and standard deviation into a single Map
        Map<String, Map<String, double[]>> speciesStats = new HashMap<>();
        speciesStats.put("Mean", speciesMeans);
        speciesStats.put("Median", speciesMedians);
        speciesStats.put("Std Dev", speciesStdDevs);

        // Print out the mean, median, and standard deviation of each variable for each species
        for (String statType : speciesStats.keySet()) {
            System.out.println(statType);
            for (String species : speciesStats.get(statType).keySet()) {
                double[] values = speciesStats.get(statType).get(species);
                System.out.println(species + ": " + Arrays.toString(values));
            }
            System.out.println();
        }

        // Calculate the correlation matrix between each pair of variables
        double[][] corMatrix = calculateCorrelationMatrix(irisData);

        // Print out the correlation matrix
        System.out.println("Correlation Matrix");
        for (double[] row : corMatrix) {
            System.out.println(Arrays.toString(row));
        }
        System.out.println();

        // TODO: Create a scatter plot matrix of the variables
    }

    private static List<double[]> loadIrisData(String filename) {
        List<double[]> irisData = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                double[] doubleValues = new double[values.length - 1];
                for (int i = 0; i < doubleValues.length; i++) {
                    doubleValues[i] = Double.parseDouble(values[i]);
                }
                irisData.add(doubleValues);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return irisData;
    }

    private static Map<String, double[]> calculateMeansBySpecies(List<double[]> irisData) {
        Map<String, double[]> speciesMeans = new HashMap<>();
        Map<String, List<double[]>> speciesData = separateDataBySpecies(irisData);
        for (String species : speciesData.keySet()) {
            List<double[]> data = speciesData.get(species);
            double[] means = new double[data.get(0).length];
            for (int i = 0; i < data.get(0).length; i++) {
                double sum = 0.0;
                for (double[] row : data) {
                    sum += row[i];
                }
                means[i] = sum / data.size();
            }
            speciesMeans.put(species, means);
        }
        return speciesMeans;
    }

    private static Map<String, double[]> calculateMediansBySpecies(List<double[]> irisData) {
        Map<String, double[]> speciesMedians = new HashMap<>();
        Map<String, List<double[]>> species
