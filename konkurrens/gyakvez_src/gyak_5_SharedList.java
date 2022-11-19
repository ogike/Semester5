package hu.elte.pp;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class SharedList {

    public static void main(String[] args) {
        List<Integer> list = Collections.synchronizedList(new ArrayList<>());
        Map<Integer, String> map = new ConcurrentHashMap<>();
        map.compute(10, (key, currentValue) ->  currentValue+" hejj "+key);

        

        new Thread(()->{
            Random r = new Random();
            while (true) {
                //synchronized (list) {
                    list.add(r.nextInt(100));
                    System.out.println("generated. List.size() == "+list.size());
                //}
                /*
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }*/
            }
        }).start();

        new Thread(()->{
            Set<Integer> seen = new HashSet<>();
            while (true) {
                synchronized (list) {
                    for (int i : list) {
                        if (!seen.contains(i)) {
                            System.out.println("found: " + i);
                            seen.add(i);
                        }
                    }
                    list.clear();
                }
                try {
                    Thread.sleep(2_000);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();

    }
}
