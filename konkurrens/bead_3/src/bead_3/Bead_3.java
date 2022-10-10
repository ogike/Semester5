package bead_3;

import java.util.Random;

/**
 * Írj egy programot, ami egy tömb elemeinek maximumát keresi meg 2 szál felhasználásával.
 * (A tömb első felét az egyik, másik felét a másik szál összegzi.)
 * Az eredményt a szálak egy közösen kezelt változóba írják be.
 * @author ogike
 */
public class Bead_3 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws InterruptedException {
        //Generating random sample numbers
        int n = 100;
        int halfInd = n/2;
        int maxRandBound = 999;
        int[] arr = new int[n];
        Random rand = new Random();
        int cheatingMax = 0;
        
        //testing
        for (int i = 0; i < n; i++) {
            arr[i] = rand.nextInt(maxRandBound);
            if(arr[i] > cheatingMax){
                cheatingMax = arr[i];
            }
        }
        
        //find the max
        IntBox box = new IntBox(0);
        Thread t1 = new Thread(() -> {
            for (int i = 0; i <halfInd; i++) {
                box.compareAndUpdate(arr[i]);
            }
        });
        t1.start();
        
        Thread t2 = new Thread(() -> {
            for (int i = 50; i <100; i++) {
                box.compareAndUpdate(arr[i]);
            }
        });
        t2.start();
        
        t1.join();
        t2.join();
        
        System.out.println("calculated max: " + box.getValue() + ", actual max: " + cheatingMax);
    }
    
    private static class IntBox{
        int v;

        public IntBox(int v) {
            this.v = v;
        }
        
        public int getValue() {
            return v;
        }

        public void setValue(int v) {
            this.v = v;
        }
        
        public synchronized void compareAndUpdate (int i){
            if(i > this.v){
                this.v = i;
            }
        }
    }
    
}
