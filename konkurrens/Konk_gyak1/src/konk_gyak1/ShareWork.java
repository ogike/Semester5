/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package konk_gyak1;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 *
 * @author ogike
 */
public class ShareWork {
    public static void main(String[] args) throws InterruptedException {
        Random random = new Random();
        List<Integer> list = new ArrayList<>(1000);
        for (int i = 0; i < 100; i++) {
            list.add(random.nextInt(100)+1);
        }
        System.out.println(list);
        var sum1 = new HalfSum(list, 0, 50);
        var sum2 = new HalfSum(list, 50, 100);
        var t1 = new Thread(sum1);
        var t2 = new Thread(sum2);
        t1.join();
        t2.join();
        System.out.println(sum1.getResult() + sum2.getResult());
    }
    
    private static class HalfSum implements Runnable {
        List<Integer> list;
        int lower;
        int upper;
        int result;

        public HalfSum(List<Integer> list, int lower, int upper) {
            this.list = list;
            this.lower = lower;
            this.upper = upper;
        }
        public int getResult() {
            return result;
        }

        @Override
        public void run() {
            //TODO: sum
            for (int i = lower; i < upper; i++) {
                result += list.get(i);
            }
        }
        
        

        
        
    }
    
}
