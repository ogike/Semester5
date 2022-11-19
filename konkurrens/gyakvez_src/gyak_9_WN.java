package hu.elte.inf.pp;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

public class WN {
    public static void main(String[] args) {
        Random random = new Random();
        List<Integer> numbers = new ArrayList<>();
        new Thread(() -> {
            while (true) {
                synchronized (numbers) {
                    numbers.add(random.nextInt(10, 100));
                    numbers.notifyAll();
                    System.out.println("element added");
                }
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
            }
        }).start();

        new Thread(() -> {
            while (true) {
                synchronized (numbers) {
                    while (numbers.size() < 10) {
                        try {
                            numbers.wait();
                            System.out.println("I am awake");
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    System.out.println("size: " + numbers.size());
                    System.out.println(
                            numbers.stream().map(i -> i.toString()).collect(Collectors.joining(" : "))
                    );
                    numbers.clear();
                }
            }
        }).start();
    }
}
