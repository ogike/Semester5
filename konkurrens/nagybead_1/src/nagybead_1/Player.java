/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package nagybead_1;

import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ogike
 */
public class Player implements Runnable{

    private int index;
    
    AtomicBoolean isOn;
    Map<Integer, Integer> scores;
    AtomicInteger[] checkpointScores;
    List<BlockingQueue<AtomicInteger>> checkpointQueues;

    public Player(int index, AtomicBoolean isOn, Map<Integer, Integer> scores,
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
                int chosenCheckpoint = rand.nextInt(FieldRace.CHECKPOINT_COUNT);
                AtomicInteger checkpointScore = checkpointScores[index];
                Thread.sleep( rand.nextInt(500, 2_001) );

                checkpointQueues.get(chosenCheckpoint)
                                .put(checkpointScores[index]);

                do{  //wait until checkpoint notifies
                    if(isOn.get() == false){
                        //exit if exiting
                        return;
                    }
                    synchronized(checkpointScore){
                        checkpointScore.wait(3_000);
                    }
                } while(checkpointScore.get() == 0);
                int reward = checkpointScores[index].get();
                System.out.println("Player " + (index+1) + " got " + reward 
                        + " points at checkpoint " + chosenCheckpoint);

                checkpointScores[index].set(0);
                scores.compute(index, (key, value) -> (value == null) ? reward : value + reward);

            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
        }
    }

}
