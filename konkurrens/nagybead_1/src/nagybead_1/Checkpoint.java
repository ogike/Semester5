/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package nagybead_1;

import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author ogike
 */
public class Checkpoint implements Runnable{

        private int index;
        
        AtomicBoolean isOn;
        Map<Integer, Integer> scores;
        AtomicInteger[] checkpointScores;
        List<BlockingQueue<AtomicInteger>> checkpointQueues;

    public Checkpoint(int index, AtomicBoolean isOn, Map<Integer, Integer> scores,
            AtomicInteger[] checkpointScores, 
            List<BlockingQueue<AtomicInteger>> checkpointQueues) {
        this.index = index;
        this.isOn = isOn;
        this.scores = scores;
        this.checkpointScores = checkpointScores;
        this.checkpointQueues = checkpointQueues;
    }

        
        
        @Override
        public void run() {
            Random rand = new Random();
            while(isOn.get()){
                try {
                    AtomicInteger result = checkpointQueues.get(index).poll(2, TimeUnit.SECONDS);
                    if(result != null){
                        int reward = rand.nextInt(10, 101);
                        synchronized (result){
                            result.addAndGet(reward);
                            result.notify();
                        }
                    }
                } catch (InterruptedException ex) {
                    throw new RuntimeException(ex);
                }
            }
        }
        
    }
