/*

 */
package konk_gyak_4;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ogike
 */
public class SlowMethods {
    public static void main(String[] args) {
        Complex c = new Complex();
        new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                System.out.println("fib: " + i + " = " + c.fib(i));
            }
        }).start();
        new Thread(() -> {
            for (int i = 10; i > 0; i--) {
                System.out.println("factor: " + i + " = " + c.factor(i));
            }
        }).start();
    }
    
    //factor és fib nem dolgozik egymással
    private static class Complex {
        
        //creating empty objects to lock threads/execution based on them
        Object fibMonitor = new Object();
        Object factorMonitor = new Object();
        
        int min = Integer.MIN_VALUE;
        int max = Integer.MAX_VALUE;
        
        int factor(int n) {
            //synchronized (factorMonitor){
                if(n == 0){
                    return 1;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    throw new RuntimeException();
                }

                int result = n * factor(n-1);

                synchronized (factorMonitor){
                    if(min < result){
                        min = result;
                        System.out.println("min: " + min);
                    }
                }

                return result;
            //}
        }
        
        int fib(int n){
            //synchronized (fibMonitor) {
                if(n<2){
                    return 1;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    throw new RuntimeException();
                }

                int result = fib(n-1) + fib(n-2);

                synchronized (fibMonitor) {
                    if(max < result){
                        max = result;
                        System.out.println("max: " + max);
                    }
                }

                return result;
            //}
        }
    }
}
