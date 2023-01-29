package nagybead_2;

import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

public class PigMent {

  /* Global Constants */
  static final int TIC_MIN   = 50;  // Tickrate minimum time (ms)
  static final int TIC_MAX   = 200; // Tickrate maximum time (ms)
  static final int FEED      = 20;  // Mass gained through photosynthesis
  static final int BMR       = 10;  // Mass lost due to basal metabolic rate
  static final int MAX_POP   = 10;  // Maximum number of concurent pigs
  static final int INIT_POP  = 3;   // size of initial pig population
  static final int INIT_MASS = 20;  // starting mass of initial pigs

  // TODO: don't forget to make the pigs scream edgy stuff:
  // pigSay("Holy crap, I just ate light!");
  // pigSay("This vessel can no longer hold the both of us!");
  // pigSay("Beware world, for I'm here now!");
  // pigSay("Bless me, Father, for I have sinned.");
  // pigSay("I have endured unspeakable horrors. Farewell, world!");
  // pigSay("Look on my works, ye Mighty, and despair!");
  
  // TODO: globally accessible variables go here (id, pigPool, openArea)
  static AtomicInteger currentId = new AtomicInteger(0);
  static ExecutorService pigPool = Executors.newCachedThreadPool();
  
  // TODO: explicit locks and conditions also go here (Task2)
  static final Object maxPopLock = new Object();

  /* Implementing Awesomeness (a.k.a. the pigs) */
  static class PhotoPig implements Runnable {
    
    /* Take this, USA! */
    final int id;

    /* Watch your lines, piggie! */
    int mass;

    /* Sweet dreams (are made of this) */
    void pigSleep() {
      Random rand = new Random();
        try {
            Thread.sleep(rand.nextInt(TIC_MAX - TIC_MIN) + TIC_MIN);
        } catch (InterruptedException ex) {
            throw new RuntimeException(ex);
        }
      return;
    }

    /* Ensuring free speech */
    void pigSay(String msg) {
        System.out.println(msg);
    }

    /* Here comes the esoteric stuff */
    boolean eatLight() {
      pigSleep();
      mass += FEED; //anabolic
      mass -= mass / BMR; //catabolic
      
      if(mass / BMR > FEED / 2){
        pigSay("This vessel can no longer hold the both of us!");
        if(currentId.get() < MAX_POP - 1){ //véletlen se kelljen életre
            pigPool.submit( 
                    new PhotoPig(mass / 2) 
            );
        }
        mass = mass / 2;
      }
        
      pigSay("Holy crap, I just ate light!");
      return true; // TODO: replace this placeholder (task1 and task2)
    }

    /* Hey, this ain't vegan! */
    boolean aTerribleThingToDo() {
      return true; // TODO: replace this placeholder (task2)
    }

    /* Every story has a beginning */
    public PhotoPig(int mass) {
      this.mass = mass;
      this.id   = currentId.getAndAdd(1);
    }

    /* Live your life, piggie! */
    @Override public void run() {
      pigSay("Beware world, for I'm here now!");
       
      boolean living = true;
      while(living){
          living = eatLight();
      }
      
      pigSay("I have endured unspeakable horrors. Farewell, world!");
      return; // TODO: replace this placeholder (task1 and task2)
    }
  }

  /* Running the simulation */
  public static void main(String[] args) {
    for (int i = 0; i < INIT_POP; i++) {
      pigPool.submit(
          new PhotoPig(INIT_MASS)
      );   
    }

    while(true){
        synchronized(lock) {
            while(currentId.get() < )
        }
    }
      
    System.out.println("Hello PigMent!"); // TODO: replace this placeholder (task1)
  }
}
