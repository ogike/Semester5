
package bead2;

import java.util.Random;

/**
 * Konkurens 2. beadandó
 * @author hm37uq
 * Feladat: Írj egy programot, 
 * ami egy tömb elemeit összegzi 2 szál felhasználásával.
 * (A tömb első felét az egyik, másik felét a másik szál összegzi.)
 */
public class Bead2 {

    /**
     * @param args the command line arguments
     * @throws java.lang.InterruptedException
     */
    public static void main(String[] args) throws InterruptedException {
        //Generating random sample numbers
        int n = 100;
        int halfInd = n/2;
        int maxRandBound = 100;
        int[] arr = new int[n];
        Random rand = new Random();
        
        for (int i = 0; i < n; i++) {
            arr[i] = rand.nextInt(maxRandBound);
        }
        
        //setup workers 
        ArraySummer workerFirst = new ArraySummer(arr, 0, halfInd);
        ArraySummer workerSecond = new ArraySummer(arr, halfInd, n);
        Thread threadFirst = new Thread(workerFirst);
        Thread threadSecond = new Thread(workerSecond);
        
        //do the work
        threadFirst.start();
        threadSecond.start();
        
        threadFirst.join();
        threadSecond.join();
        
        long finalSum = workerFirst.getSum() + workerSecond.getSum();
        System.out.println("Result from threads: " + finalSum);
        
        long checking = 0;
        for (int i = 0; i < n; i++) {
            checking += arr[i];
        }
        System.out.println("Redsult without threads: " + checking);
    }
    
    private static class ArraySummer implements Runnable {

        private int[] arr;
        private int minInd;
        private int maxInd;
        private long sum;
        
        public ArraySummer(int[] arr, int minInd, int maxInd) {
            this.arr = arr;
            this.minInd = minInd;
            this.maxInd = maxInd;
            sum = 0;
        }

        @Override
        public void run() {
            for (int i = minInd; i < maxInd; i++) {
                sum += arr[i];
            }
        }
        
        public long getSum(){
            return sum;
        }

        
        
    }
    
}
