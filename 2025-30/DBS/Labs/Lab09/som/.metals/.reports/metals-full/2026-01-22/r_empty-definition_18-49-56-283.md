error id: file://<WORKSPACE>/src/main/scala/BatchSOM.scala:
file://<WORKSPACE>/src/main/scala/BatchSOM.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -scala/collection/parallel/CollectionConverters.weights.
	 -scala/collection/parallel/CollectionConverters.weights#
	 -scala/collection/parallel/CollectionConverters.weights().
	 -weights.
	 -weights#
	 -weights().
	 -scala/Predef.weights.
	 -scala/Predef.weights#
	 -scala/Predef.weights().
offset: 4986
uri: file://<WORKSPACE>/src/main/scala/BatchSOM.scala
text:
```scala
package edu.puj.sist.som

import scala.collection.parallel.CollectionConverters._ // Required for .par in Scala 2.13+
import scala.util.Random
import java.io.PrintWriter

/**
 * A parallel-ready implementation of Batch SOM.
 * @param xDim Width of the grid
 * @param yDim Height of the grid
 * @param inputDim Dimension of the input vectors (e.g., 4 for Iris data)
 */
class BatchSOM(xDim: Int, yDim: Int, inputDim: Int) {

  // 1. The Map (The Codebook)
  // Flattened grid of weight vectors
  var weights: Array[Array[Double]] = Array.ofDim[Double](xDim * yDim, inputDim)
  
  // Pre-computed grid coordinates for distance calculations
  val gridCoords: Array[(Int, Int)] = (for {
    y <- 0 until yDim
    x <- 0 until xDim
  } yield (x, y)).toArray

  /**
   * Random initialization of weights
   */
  def initialize(): Unit = {
    val rnd = new Random(42) // Fixed seed for reproducibility
    for (i <- weights.indices; j <- 0 until inputDim) {
      weights(i)(j) = rnd.nextDouble()
    }
  }

  /**
   * Train the SOM using Batch Algorithm
   * * @param data The input dataset (N x inputDim)
   * @param epochs Number of iterations
   * @param startSigma Initial neighborhood radius
   * @param endSigma Final neighborhood radius
   */
  def train(data: Array[Array[Double]], epochs: Int, startSigma: Double, endSigma: Double): Unit = {
    
    for (epoch <- 1 to epochs) {
      // Linear decay of sigma
      val currentSigma = startSigma + (endSigma - startSigma) * (epoch.toDouble / epochs)
      
      // --- PHASE 1: PARALLEL MAP (The "Voting" Step) ---
      // We process data points in parallel to find their BMUs.
      // Returns: Array of (BMU_Index, Data_Vector)
      val assignments = data.par.map { x => 
        val bmuIndex = findBMU(x)
        (bmuIndex, x)
      }

      // --- PHASE 2: ACCUMULATE (The "Census" Step) ---
      // Aggregate the parallel results into local sums and counts per node.
      // Note: In Spark, this would be a `reduceByKey`.
      val nodeSums = Array.fill(xDim * yDim)(new Array[Double](inputDim))
      val nodeCounts = new Array[Double](xDim * yDim)

      for ((bmu, x) <- assignments.seq) { // Back to sequential for aggregation
        nodeCounts(bmu) += 1.0
        for (d <- 0 until inputDim) {
          nodeSums(bmu)(d) += x(d)
        }
      }

      // --- PHASE 3: UPDATE (The "Smoothing" Step) ---
      // Apply the neighborhood function to update weights
      updateWeights(nodeSums, nodeCounts, currentSigma)
      
      if (epoch % 10 == 0) println(f"Epoch $epoch/$epochs completed. Sigma: $currentSigma%.2f")
    }
  }

  /**
   * Helper: Find Best Matching Unit (Euclidean distance)
   */
  private def findBMU(x: Array[Double]): Int = {
    var minDist = Double.MaxValue
    var bmuIdx = -1
    
    // Optimization: Iterate over flattened array directly
    var i = 0
    while (i < weights.length) {
      val d = distSqEuclidean(x, weights(i))
      if (d < minDist) {
        minDist = d
        bmuIdx = i
      }
      i += 1
    }
    bmuIdx
  }

  /**
   * Helper: Update weights based on neighborhood influence
   */
  private def updateWeights(nodeSums: Array[Array[Double]], nodeCounts: Array[Double], sigma: Double): Unit = {
    val newWeights = Array.ofDim[Double](weights.length, inputDim)
    
    // Pre-calculate Gaussian decay coefficient
    // h = exp( -dist^2 / (2 * sigma^2) )
    val coeff = -1.0 / (2.0 * sigma * sigma)

    // Parallelize the update of the grid nodes themselves
    // (Since each node update is independent of others given the fixed nodeSums)
    for (i <- weights.indices) { // 'i' is the target node we are updating
      val numerator = new Array[Double](inputDim)
      var denominator = 0.0
      
      // Iterate over all OTHER nodes 'k' to see how they influence 'i'
      for (k <- weights.indices) {
        // Only process if node 'k' actually captured data
        if (nodeCounts(k) > 0) {
          // Calculate grid distance between target 'i' and neighbor 'k'
          val distSq = distSqGrid(i, k)
          
          // Gaussian Neighborhood
          val h = math.exp(distSq * coeff)
          
          // Accumulate influence
          denominator += h * nodeCounts(k)
          for (d <- 0 until inputDim) {
            numerator(d) += h * nodeSums(k)(d)
          }
        }
      }
      
      // Assign new weight
      if (denominator > 0) {
        for (d <- 0 until inputDim) {
          newWeights(i)(d) = numerator(d) / denominator
        }
      } else {
        // Handle "orphan" nodes (no nearby data). 
        // Strategy: Keep old weight.
        newWeights(i) = weights(i) 
      }
    }
    
    // Commit the update
    weights = newWeights
  }

  // Visualization Helpers

  def exportToCSV(filename: String): Unit = {
    val pw = new PrintWriter(filename)
    pw.println("x,y,variable_index,value") // Header

    for (y <- 0 until yDim; x <- 0 until xDim) {
      val idx = y * xDim + x
      val w = weight@@s(idx)
      // Export each dimension of the weight vector
      for (d <- w.indices) {
        pw.println(f"$x,$y,$d,${w(d)}")
      }
    }
    pw.close()
  }

  def printAsciiUMatrix(uMatrix: Array[Array[Double]]): Unit = {
  // 1. Normalize values to 0.0 - 1.0 range for mapping
  val flat = uMatrix.flatten
  val min = flat.min
  val max = flat.max
  val range = if (max - min > 0) max - min else 1.0

  // darker = low distance (cluster center), lighter = high distance (boundary)
  val chars = "█▓▒░ ".toCharArray 

  println(f"\n--- U-Matrix (Min: $min%.2f, Max: $max%.2f) ---")
  for (row <- uMatrix) {
    for (valVal <- row) {
      val normalized = (valVal - min) / range
      val charIdx = ((chars.length - 1) * normalized).toInt
      print(f"${chars(charIdx)} ") // Space for aspect ratio
    }
    println()
  }
}

/**
 * Calculates the U-Matrix (Average distance to neighbors).
 * Returns a 2D array [y][x] of distance values.
 */
def calculateUMatrix(): Array[Array[Double]] = {
  val uMatrix = Array.ofDim[Double](yDim, xDim)

  for (y <- 0 until yDim; x <- 0 until xDim) {
    val currentIdx = y * xDim + x
    val currentWeight = weights(currentIdx)
    
    var sumDist = 0.0
    var count = 0

    // Check all 4 immediate neighbors (Up, Down, Left, Right)
    // (Note: For Hexagonal grids, you would check 6 neighbors)
    val neighbors = List((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))

    for ((nx, ny) <- neighbors) {
      if (nx >= 0 && nx < xDim && ny >= 0 && ny < yDim) {
        val neighborIdx = ny * xDim + nx
        sumDist += math.sqrt(distSqEuclidean(currentWeight, weights(neighborIdx)))
        count += 1
      }
    }
    
    // Average distance to neighbors
    uMatrix(y)(x) = if (count > 0) sumDist / count else 0.0
  }
  uMatrix
}
  
  // Math Helpers
  private def distSqEuclidean(v1: Array[Double], v2: Array[Double]): Double = {
    var sum = 0.0
    var i = 0
    while(i < v1.length) {
      val d = v1(i) - v2(i)
      sum += d * d
      i += 1
    }
    sum
  }

  private def distSqGrid(idx1: Int, idx2: Int): Double = {
    val (x1, y1) = gridCoords(idx1)
    val (x2, y2) = gridCoords(idx2)
    val dx = x1 - x2
    val dy = y1 - y2
    (dx * dx + dy * dy).toDouble
  }
}
```


#### Short summary: 

empty definition using pc, found symbol in pc: 