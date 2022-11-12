import Toybox.Test;
// import RollingAvg;

class TestRollingAvg {
    
    (:test)
    function testAvgStarFromEmpty1 (logger as Logger) as Boolean {
        var d = new RollingAvg(3);
        
        var r = d.compute(11); logger.debug("r = " + r);
        return (r == null); // returning true indicates pass, false indicates failure
    }


    (:test)
    function testAvgStarFromEmpty2 (logger as Logger) as Boolean {
        var d = new RollingAvg(3);
        
        var r = d.compute(11); logger.debug("r = " + r);
        r = d.compute(12); logger.debug("r = " + r);
        return (r == null); // returning true indicates pass, false indicates failure
    }

    (:test)
    function testAvgStarFromEmpty3 (logger as Logger) as Boolean {
        var d = new RollingAvg(3);
        
        var r = d.compute(11); logger.debug("r = " + r);
        r = d.compute(12); logger.debug("r = " + r);
        r = d.compute(13); logger.debug("r = " + r);
        return (r == 12); // returning true indicates pass, false indicates failure
    }

    (:test)
    function testAvgStarFromEmpty4 (logger as Logger) as Boolean {
        var d = new RollingAvg(3);
        
        var r = d.compute(11); logger.debug("r = " + r);
        r = d.compute(12); logger.debug("r = " + r);
        r = d.compute(13); logger.debug("r = " + r);
        r = d.compute(14); logger.debug("r = " + r);
       return (r == 13); // returning true indicates pass, false indicates failure
    }

    (:test)
    function testAvgStarFromEmpty5 (logger as Logger) as Boolean {
        var d = new RollingAvg(3);
        
        var r = d.compute(11); logger.debug("r = " + r);
        r = d.compute(12); logger.debug("r = " + r);
        r = d.compute(13); logger.debug("r = " + r);
        r = d.compute(14); logger.debug("r = " + r);
        r = d.compute(15); logger.debug("r = " + r);
       return (r == 14); // returning true indicates pass, false indicates failure
    }

}