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
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author ogike
 */
public class FieldRace {

    public static int PLAYER_COUNT = 5;
    public static int CHECKPOINT_COUNT = 10;
    
    static AtomicBoolean isOn = new AtomicBoolean(true);
    static Map<Integer, Integer> scores = new ConcurrentHashMap<>(); //should be enough to be filled by player
    static AtomicInteger[] checkpointScores = new AtomicInteger[PLAYER_COUNT];
    static List<BlockingQueue<AtomicInteger>> checkpointQueues = 
            Collections.synchronizedList(
                    new ArrayList<>(CHECKPOINT_COUNT)
            );
    
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws InterruptedException {
        ExecutorService ex = Executors.newCachedThreadPool();
        
        //setting the data up
        for (int i = 0; i < PLAYER_COUNT; i++) {
            scores.put(i, 0);
            checkpointScores[i] = new AtomicInteger(0);
        }
        for (int i = 0; i < CHECKPOINT_COUNT; i++) {
            checkpointQueues.add( new LinkedBlockingDeque<>() );
        }
        
        //runnables
        for (int i = 0; i < PLAYER_COUNT; i++) {
            final int playerIndex = i;
            ex.submit(new Player(playerIndex, isOn, scores, checkpointScores, checkpointQueues));
        }
        
        for (int i = 0; i < CHECKPOINT_COUNT; i++) {
            final int checkpointIndex = i;
            ex.submit(new Checkpoint(checkpointIndex, isOn, scores, checkpointScores, checkpointQueues));
        }
        
        ex.submit(new Referee(isOn, scores));
        
        Thread.sleep(10_000);
        
        isOn.set(false);
        ex.shutdown();
        ex.awaitTermination(3, TimeUnit.SECONDS);
        ex.shutdownNow();
        
        System.out.println("Final scores: " + scores.toString());
    }
    
}


