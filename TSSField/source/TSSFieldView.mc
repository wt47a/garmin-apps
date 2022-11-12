import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
using Toybox.Math as Math;

class TSSFieldView extends WatchUi.SimpleDataField {
    var userFtpFactor;  // value required to calculate normalized power (power of ftp multipled by 3600s)
    
    var rollingAvg;
    var rollingAvgP4Sum;
    var rollingAvgP4SumCnt;
    var tss;

    // reste container if eny data has been added (based on counters)
    private function resetDataIfNOtEMpty(windowSize as Numeric) {
        if (rollingAvgP4SumCnt == null || rollingAvgP4SumCnt > 0) {
            rollingAvg = new RollingAvg(windowSize);
            rollingAvgP4Sum = 0l;
            rollingAvgP4SumCnt = 0;
            tss = "--";
        }
        
        userFtpFactor = null;   // reinitialize to next lazy load
    }

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        
        label = Application.loadResource( Rez.Strings.TSSFieldLabel) as String;

        resetDataIfNOtEMpty(30);
    }


    function lazyGetUserFtpFactor() as Long {
        if (userFtpFactor == null) {
            var userFTP = Application.getApp().getProperty("userFTP");
            userFtpFactor = 3600l * userFTP * userFTP;
        }
        return userFtpFactor;
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        var power = null;
      
        // System.println("timerState = " + info.timerState + "  FTPFactor = " + userFtpFactor);

        switch(info.timerState) {
            case Activity.TIMER_STATE_ON:
                power = info.currentPower;
                if (power == null) {
                    return tss; // do not count missed data
                }
                break;
            case Activity.TIMER_STATE_PAUSED:
            case Activity.TIMER_STATE_STOPPED:
                return tss;
            case Activity.TIMER_STATE_OFF:
                resetDataIfNOtEMpty(30);
                return tss;
            default:
                return tss;
        }

        // get curent power and make some computation
        var rAvg = rollingAvg.compute(power);
        if (rAvg != null) {
            // compute only on data present
            rollingAvgP4Sum +=  Math.pow(rAvg, 4).toLong();
            rollingAvgP4SumCnt ++;      // increase moving time

            var normalized_powerP2 = Math.sqrt(rollingAvgP4Sum / rollingAvgP4SumCnt);

            // intensity = 
            // tss = (moving_time * norm_power * intensity) / (ftp * 3600.0) * 100.0
            // ==>
            // tss = 100.0 * (moving_time * norm_power * norm_power) / (ftp * ftp * 3600.0)

            tss = Math.round(100.0d * rollingAvgP4SumCnt * normalized_powerP2 / lazyGetUserFtpFactor() ).toNumber();
        }
        return tss == null ? "--" : tss;
    }

}