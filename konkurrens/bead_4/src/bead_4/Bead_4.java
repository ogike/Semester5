
package bead_4;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Írj egy programot, amiben két szál közösen kezel egy listát.
 * Az egyik szál, másodpercenként 1 véletlen számot ír a listába a [0, 100) intervallumról.
 * A számot véletlenszerűen szúrja be a lista valamelyik értékeként.
 * (Azaz használd az void add(int index, E element) metódust a sima add(E element) helyett.) 
 * A másik szál 2 másodpercenként kitöröl a listából minden páros elemet. 
 * (Garantáld, hogy a a program nem fut hibára párhuzamos környezetben. 
 *  A helyes párhuzamos működés a tárgy összes számonkérésben feltétel,
 *  akkor is, ha nem szerepel explicit a megemlített követelmények között.)
 * @author ogike
 */
public class Bead_4 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<>();
        
        //generating thread
        new Thread(() -> {
            Random rand = new Random();
            while (true) {
                synchronized (list) {
                    int num = rand.nextInt(100);
                    int ind = list.size() > 0 ? rand.nextInt(0, list.size()) : 0;
                    System.out.println("adding: " + num);
                    list.add(ind, num);
                }
                try {
                    Thread.sleep(10);
                } catch (InterruptedException ex) {
                    throw new RuntimeException();
                }
            }
        }).start();
        
        //remover thread
        new Thread(() -> {
            while (true) {
                synchronized (list) {
                    for (int i = list.size()-1; i >=0; i--) {
                        if(list.get(i) % 2 == 0){
                            System.out.println("removing: " + list.remove(i));
                        }
                    }
                }
                try {
                    Thread.sleep(20);
                } catch (InterruptedException ex) {
                    throw new RuntimeException();
                }
            }
        }).start();
    }
    
}
