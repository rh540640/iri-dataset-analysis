import scala.io.Source
import scala.collection.mutable.ListBuffer
import scala.math.sqrt
import breeze.linalg.{DenseMatrix, eig}

// Load the Iris dataset into a ListBuffer
val irisData = ListBuffer.empty[Array[Double]]
for (line <- Source.fromFile("/path/to/iris.csv").getLines().drop(1)) {
  val fields = line.split(",")
  val values = fields.take(4).map(_.toDouble)
  irisData += values
}

// Calculate the mean, median, and standard deviation of each variable for each species
def calculateMeansBySpecies(data: List[Array[Double]]): Map[String, Array[Double]] = {
  val speciesData = separateDataBySpecies(data)
  speciesData.mapValues { data =>
    val means = for (i <- data.head.indices) yield {
      val col = data.map(_(i))
      col.sum / col.length
    }
    means.toArray
  }
}

def calculateMediansBySpecies(data: List[Array[Double]]): Map[String, Array[Double]] = {
  val speciesData = separateDataBySpecies(data)
  speciesData.mapValues { data =>
    val medians = for (i <- data.head.indices) yield {
      val col = data.map(_(i)).sorted
      if (col.length % 2 == 0) {
        (col(col.length / 2 - 1) + col(col.length / 2)) / 2
      } else {
        col(col.length / 2)
      }
    }
    medians.toArray
  }
}

def calculateStdDevsBySpecies(data: List[Array[Double]]): Map[String, Array[Double]] = {
  val speciesData = separateDataBySpecies(data)
  speciesData.mapValues { data =>
    val stdDevs = for (i <- data.head.indices) yield {
      val col = data.map(_(i))
      val mean = col.sum / col.length
      sqrt(col.map(x => math.pow(x - mean, 2)).sum / col.length)
    }
    stdDevs.toArray
  }
}

def separateDataBySpecies(data: List[Array[Double]]): Map[String, List[Array[Double]]] = {
  val speciesData = ListBuffer.empty[(String, Array[Double])]
  for (row <- data) {
    val species = row(4).toInt match {
      case 0 => "Iris-setosa"
      case 1 => "Iris-versicolor"
      case 2 => "Iris-virginica"
    }
    speciesData += ((species, row.take(4)))
  }
  speciesData.groupBy(_._1).mapValues(_.map(_._2).toList)
}

val speciesMeans = calculateMeansBySpecies(irisData.toList)
val speciesMedians = calculateMediansBySpecies(irisData.toList)
val speciesStdDevs = calculateStdDevsBySpecies(irisData.toList)

// Combine the mean, median, and standard deviation into a single Map
val speciesStats = Map("Mean" -> speciesMeans, "Median" -> speciesMedians, "Std Dev" -> speciesStdDevs)

// Print out the mean, median, and standard deviation of each variable for each species
speciesStats.foreach { case (statType, stats) =>
  println(statType)
  stats.foreach { case (species, values) =>
    println(s"$species: ${values.mkString(", ")}")
  }
  println()
}

// Calculate the correlation matrix between each pair of variables
val corMatrix = DenseMatrix(irisData.toArray:_*).t *
