/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package konk_gyak1;

import java.time.Duration;
import java.time.Instant;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ogike
 */
public class konk_gyak2 {
        public static void main(String[] args) throws InterruptedException {
            Instant start = Instant.now();
            System.out.println("in main before start (" + Thread.currentThread().getName() + ")");
            Thread t = new Thread(() -> {
                long sum = 0L;
                for (int i = 0; i < 5; i++) {
                    System.out.println("step: " + i + " (" + Thread.currentThread().getName() + ")" );
                    try {
                        //Thread.sleep(1000);
                        sum += slow();
                    } catch (InterruptedException ex) {
                        System.out.println("Was interrupt requested? " + );
                        ex.printStackTrace();
                    }
                }
                System.out.println("sum: " +  sum);
            });
            //t.setDaemon(true);
            t.start();
            //t.stop(): deprecated, ne használd!!
            
            Thread.sleep(2000);
            t.interrupt();
            
            System.out.println("in main after start");
            
            Instant end = Instant.now();
            System.out.println(Duration.between(start, end).toMillis());
        }
        
        private static long slow() throws InterruptedException{
            long L = 0L;
            String temp = "";
            for (int i = 0; i < 50_000; i++) {
                L += i;
                temp += " " + L;
                //if(Thread.currentThread().isInterrupted()){
                if(Thread.interrupted() && i < 32_000){
                    throw new InterruptedException("interrupted at: " + i);
                }
            }
            return L;     
        }
}
        
