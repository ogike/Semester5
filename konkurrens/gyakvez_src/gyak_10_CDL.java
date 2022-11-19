package hu.elte.pp;

import java.util.Arrays;
import java.util.Random;
import java.util.concurrent.CountDownLatch;
import java.util.stream.IntStream;

public class CDL {
    public static void main(String[] args) {
        CountDownLatch cdl = new CountDownLatch(10);
        Matrix[] matrices = new Matrix[10];
        for(int i=0; i<10; ++i) {
            int id = i;
            new Thread(()->{
                System.out.println(id+" is generating...");
                matrices[id] = new Matrix();
                System.out.println(id+" has generated");
                cdl.countDown();
                try {
                    cdl.await();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                boolean iHaveTheGreatestColumnSum = true;
                int myColumnSum = matrices[id].maxColumSum();
                System.out.println(id+"'s max: "+myColumnSum);
                for(int j=0; j<matrices.length; ++j) {
                    if(j!=id) {
                        int otherMax = matrices[j].maxColumSum();
                        if(myColumnSum<=otherMax) {
                            iHaveTheGreatestColumnSum = false;
                        }
                    }
                }
                System.out.println(id+" is "+(iHaveTheGreatestColumnSum?"":"not ")+"the greatest!");
            }).start();
        }
    }

    private static class Matrix {
        int[] data;

        Matrix() {
            data = new int[10*10];
            Random random = new Random();
            for(int i=0; i<data.length; ++i) {
                data[i] = random.nextInt(10);
                try {
                    Thread.sleep(random.nextInt(100));
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }

        int[] getColumn(int j) {
            int[] result = new int[10];
            for(int i=0; i<result.length; ++i) {
                result[i] = data[i*10+j];
            }
            return result;
        }

        int sumOfColumn(int j) {
            return Arrays.stream(getColumn(j)).sum();
        }

        int maxColumSum() {
            return IntStream.range(0, 10).map(i->sumOfColumn(i)).max().orElseThrow();
        }
    }
}
