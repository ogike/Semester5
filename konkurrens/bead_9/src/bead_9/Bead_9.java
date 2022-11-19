/*
 * Készíts egy programot, amiben 5 szál van. 
 *  Mindegyik szál alszik 3-5 másodpercet (véletlen érték), 
        majd az időt, amit aludt, hozzáadja egy megosztott AtomicInteger-hez. 
 *  Amikor mindegyik szál végzett, az utolsó szál kiírja a képernyőre az összeget. 
        (Csak egy összeg kiírása szerepeljen a programban!)
 */
package bead_9;

import java.util.Random;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ogike
 */
public class Bead_9 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        CountDownLatch cdl = new CountDownLatch(5);
        AtomicInteger sum = new AtomicInteger(0);
        
        for (int i = 0; i < 5; i++) {
            new Thread(() -> {
                try{
                    int sleepTime = new Random().nextInt(3000, 5000);
                    Thread.sleep(sleepTime);
                    
                    sum.addAndGet(sleepTime);
                    if(cdl.getCount() == 1){ //we are the last to add
                        System.out.println("THe sum is: " + sum.toString());
                    }
                    cdl.countDown();
                    cdl.await();
                    //System.out.println("Thread " + Thread.currentThread().getName() + " shutting down...");
                    
                } catch (InterruptedException ex) {
                    throw new RuntimeException(ex);
                }
                
            }).start();
        }
        
    }
    
}
