```
package com.kungeek.data.schedule;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

/**
 * @author wujunnan
 * @date 2022/01/04
 */
public class Schedule {
    public static void main(String[] args) throws InterruptedException {
        Calendar startDate = Calendar.getInstance();
        startDate.set(startDate.get(Calendar.YEAR), startDate.get(Calendar.MONTH), startDate.get(Calendar.DATE), 23, 20, 0);
        //1min
        long timeInterval = 60 * 1000;
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                System.out.println("hello");
            }
        },  startDate.getTime(), timeInterval );
    }
}
```