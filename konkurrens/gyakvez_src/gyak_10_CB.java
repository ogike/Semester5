package hu.elte.pp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

public class CB {
    public static void main(String[] args) {
        Random random = new Random();
        CyclicBarrier cb = new CyclicBarrier(5, ()->{
            System.out.println("All votes are casted");
        });
        CyclicBarrier startVoting = new CyclicBarrier(5);
        List<Boolean> votes = Collections.synchronizedList(new ArrayList<>(5));
        for(int i=0; i<5; ++i) {
            int id = i;
            new Thread(()->{
                while (true) {
                    try {
                        startVoting.await();
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    } catch (BrokenBarrierException e) {
                        throw new RuntimeException(e);
                    }
                    if(id == 0) {
                        System.out.println("please send your votes");
                    }
                    sleepRandom();
                    boolean myVote =random.nextBoolean();
                    votes.add(myVote);
                    System.out.println(id+" has voted: "+myVote);
                    try {
                        if(0 == cb.await()) {
                            synchronized (votes) {
                                int supporterCount = votes.stream().mapToInt(b -> b ? 1 : 0).sum();
                                if (supporterCount < 3) {
                                    System.err.println("rejected... :(");
                                } else {
                                    System.out.println("accepted!!!!!!");
                                }
                                votes.clear();
                            }
                        }
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    } catch (BrokenBarrierException e) {
                        throw new RuntimeException(e);
                    }
                }
            }).start();
        }

    }

    private static void sleepRandom() {
        try {
            Thread.sleep(new Random().nextInt(500, 2500));
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
