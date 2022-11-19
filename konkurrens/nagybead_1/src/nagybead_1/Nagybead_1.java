/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package nagybead_1;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * TODO: this should be the FieldRace class
 * @author ogike
 */
public class Nagybead_1 {

    static int PLAYER_COUNT = 5;
    static int CHECKPOINT_COUNT = 10;
    
    static AtomicBoolean isOn = new AtomicBoolean(true);
    static Map<Integer, Integer> scores = new ConcurrentHashMap<>(); //should be enough to be filled by player
    static AtomicInteger[] checkpointScores = new AtomicInteger[PLAYER_COUNT];
    static List<BlockingQueue<AtomicInteger>> checkpointQueues = 
            Collections.synchronizedList(
                    new ArrayList<BlockingQueue<AtomicInteger>>(CHECKPOINT_COUNT)
            );
    
    
    /**
     * @param args the command line arguments
     * TODO: handle exception
     */
    public static void main(String[] args) throws InterruptedException {
        ExecutorService ex = Executors.newCachedThreadPool();
        
        //setting the data up
        for (int i = 0; i < PLAYER_COUNT; i++) {
            scores.put(i, 0);
        }
        
        //runnables
        for (int i = 0; i < PLAYER_COUNT; i++) {
            final int playerIndex = i;
            ex.submit(new Player(playerIndex));
        }
        
        for (int i = 0; i < CHECKPOINT_COUNT; i++) {
            final int checkpointIndex = i;
            ex.submit(new Checkpoint(checkpointIndex));
        }
        
        ex.submit(new Referee());
        
        Thread.sleep(10_000);
        
        isOn.set(false);
        ex.shutdown();
        ex.awaitTermination(3, TimeUnit.SECONDS);
        ex.shutdownNow();
        
        System.out.println("Final scores: " + scores.toString());
    }
    
    
    private static class Player implements Runnable{

        private int index;
        
        public Player(int index) {
            this.index = index;
        }
        
        @Override
        public void run() {
            Random rand = new Random();
            while(isOn.get()){
                try {
                    int chosenCheckpoint = rand.nextInt(CHECKPOINT_COUNT);
                    Thread.sleep( rand.nextInt(500, 2_001) );
                    
                    System.out.println("Player " + index + " went to checkpoint " + chosenCheckpoint);
                    System.out.println("    the checkpoints cap: " + checkpointQueues.get(chosenCheckpoint).remainingCapacity());
                    checkpointQueues.get(chosenCheckpoint).put( checkpointScores[index] );
                    System.out.println("Player " + index + " added to checkpoint " + chosenCheckpoint);
                    
                    do{  //wait until checkpoint notifies
                        if(isOn.get() == false){
                            //exit if exiting
                            return;
                        }
                        checkpointScores[index].wait(3_000);
                        System.out.println("Player " + index + " waiting for checkpoint...");
                    } while(checkpointScores[index].get() == 0);
                    int reward = checkpointScores[index].get();
                    System.out.println("Player " + (index+1) + "got " + reward 
                            + "points at checkpoint " + chosenCheckpoint);
                    
                    checkpointScores[index].set(0);
                    scores.compute(index, (key, value) -> (value == null) ? reward : value + reward);
                    
                } catch (InterruptedException ex) {
                    Logger.getLogger(Nagybead_1.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
    }
    
    private static class Checkpoint implements Runnable{

        private int index;

        public Checkpoint(int index) {
            this.index = index;
        }
        
        @Override
        public void run() {
            Random rand = new Random();
            while(isOn.get()){
                try {
                    System.out.println("Checkpoint " + index + " waiting for poll...");
                    AtomicInteger result = checkpointQueues.get(index).poll(2, TimeUnit.SECONDS);
                    if(result != null){
                        int reward = rand.nextInt(10, 101);
                        result.addAndGet(reward);
                        result.notify();
                    }
                } catch (InterruptedException ex) {
                    throw new RuntimeException(ex);
                }
            }
        }
        
    }
    
    public static class Referee implements Runnable {

        @Override
        public void run() {
            while(isOn.get()){
                System.out.println("Scores: " + scores.toString());
                try {
                    Thread.sleep(1_000);
                } catch (InterruptedException ex) {
                    throw new RuntimeException(ex);
                }
            }
        }
        
    }
    
}


