package edu.puj.sist.som

import scala.util.Random

object SomRunner {
  def main(args: Array[String]): Unit = {
    // 1. Create Dummy Data: 3D colors (R, G, B)
    // 500 "Reddish" points and 500 "Blueish" points
    val rnd = new Random()
    val redData = Array.fill(500)(Array(0.8 + rnd.nextDouble()*0.2, rnd.nextDouble()*0.2, rnd.nextDouble()*0.2))
    val blueData = Array.fill(500)(Array(rnd.nextDouble()*0.2, rnd.nextDouble()*0.2, 0.8 + rnd.nextDouble()*0.2))
    val data = redData ++ blueData

    // 2. Initialize SOM
    // 50x50 Grid, Input Dimension = 3 (RGB)
    val som = new BatchSOM(50, 50, 3)
    som.initialize()

    println("Training started...")
    
    // 3. Train
    // 200 Epochs, Sigma starts at 25.0 (half grid) and decays to 0.01
    som.train(data, epochs = 200, startSigma = 25.0, endSigma = 0.01)

    println("Training complete.")
    
    // 4. Verify - Check corner weights
    val cornerWeight = som.weights(0)
    println(f"Corner Node Weight: [R=${cornerWeight(0)}%.2f, G=${cornerWeight(1)}%.2f, B=${cornerWeight(2)}%.2f]")

    //som.printAsciiUMatrix(som.calculateUMatrix())

    som.exportToCSV("som_weights.txt")
    println("Weights saved to som_weights.txt")
  }
}
