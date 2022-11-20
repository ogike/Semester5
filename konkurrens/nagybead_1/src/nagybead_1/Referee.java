/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package nagybead_1;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import static nagybead_1.FieldRace.isOn;
import static nagybead_1.FieldRace.scores;

/**
 *
 * @author ogike
 */
public class Referee implements Runnable {

    AtomicBoolean isOn;
    Map<Integer, Integer> scores;

    public Referee(AtomicBoolean isOn, Map<Integer, Integer> scores) {
        this.isOn = isOn;
        this.scores = scores;
    }
    
    @Override
    public void run() {
        while(isOn.get()){
            List<Map.Entry<Integer, Integer>> sortedScores = new ArrayList<>(
                  scores.entrySet()
                );
            Collections.sort(sortedScores, (o1, o2) -> o2.getValue().compareTo(o1.getValue()));
            System.out.println("Scores: " + sortedScores.toString());
            try {
                Thread.sleep(1_000);
            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
        }
    }

}
