/*

 */
package konk_gyak_4;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ogike
 */
public class Konk_gyak_4 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws InterruptedException {
        List<Integer> numbers = new ArrayList();
        for (int i = 1; i <= 100; i++) {
            numbers.add(i);
        }
        
        //párhuzamos összegző program
        IntBox box = new IntBox(0);
        Thread t1 = new Thread(() -> {
            for (int i = 0; i <50; i++) {
                //synchronized (box) { //másik szál ne nyúlhasson a box objekhez mikor ez fut
                //    box.setV(box.getV() + numbers.get(i));
                //}
                box.add(numbers.get(i));
            }
        });
        t1.start();
        
        Thread t2 = new Thread(() -> {
            for (int i = 50; i <100; i++) {
                //synchronized (box) { //másik szál ne nyúlhasson a box objekhez mikor ez fut
                //    box.setV(box.getV() + numbers.get(i));
                //}
                box.add(numbers.get(i));
            }
        });
        
        t2.start();
        
        t1.join();
        t2.join();
        
        System.out.println(box.getV());
    }
    
    private static class IntBox{
        int v;

        public IntBox(int v) {
            this.v = v;
        }
        
        

        public int getV() {
            return v;
        }

        public void setV(int v) {
            this.v = v;
        }
        
        public synchronized void add (int i){
            this.v += i;
        }
    }
    
    
}
