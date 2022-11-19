package hu.elte.inf.pp;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class DeadLock {
    private record Philisopher(Lock left, Lock right, String name) implements Runnable {
        @Override
        public void run() {
            while (true) {
                System.out.println(name+" is thinking...");
                sleep(1_000);
                System.out.println(name+" wants to eat");
                left.lock();
                try {
                    sleep(1_200);
                    try {
                        if (!right.tryLock(100, TimeUnit.MILLISECONDS)) {
                            System.out.println(name+" goes back to think hungry");
                        } else {
                            try{
                                System.out.println(name+" is eating");
                                sleep(300);
                                System.out.println(name+" is finished");
                            }finally {
                                right.unlock();
                            }
                        }
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                } finally {
                    left.unlock();
                }
            }
        }

        private void sleep(long time) {
            try {
                Thread.sleep(time);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public static void main(String[] args) {
        List<String> names = List.of("Alex", "Berci", "Csilla", "Dora", "Fanni");
        List<Lock> locks = new ArrayList<>();
        for(String name: names) {
            locks.add(new ReentrantLock());
        }
        for (int i=0; i<names.size(); ++i) {
            //if(i<4) {
                new Thread(
                        new Philisopher(locks.get(i), locks.get((i + 1) % locks.size()), names.get(i))
                ).start();
            //} else {
            //    new Thread(
            //            new Philisopher(locks.get((i + 1) % locks.size()), locks.get(i), names.get(i))
            //    ).start();
            //}
        }
        System.out.println("he?");
    }
}
