
class RollingAvg {
    
    var data;
    var dataSum;
    var dataCount;
    var wSize;
    

    function initialize(windowSize as Numeric) {
        data = new[windowSize];
        dataSum = 0;
        dataCount = 0;
        wSize = windowSize;
    }
    
    // put new power data to collection and return mean (or null if window is not full)
    function compute(power as Numeric or Long or Float or Double) as Double or Null {
        // substract from sum (for mean calculation) before overriding by new data
        if (dataCount >= wSize) {
            dataSum -= data[dataCount % wSize];
        }
        // override buffer with new data
        data[dataCount % wSize] = power;
        dataSum += power;
        dataCount++;

        if (dataCount < wSize) {
            // window is not full
            data[dataCount] = power;
            return null;
        } else {
            return dataSum / wSize;
        }
    }
}