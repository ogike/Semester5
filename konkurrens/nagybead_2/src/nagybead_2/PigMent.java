package nagybead_2;

import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.atomic.AtomicBoolean;
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
  static final AtomicInteger currentId = new AtomicInteger(0);
  static final ExecutorService pigPool = Executors.newCachedThreadPool();
  static final BlockingQueue<PhotoPig> openArea = new PriorityBlockingQueue<>(
                        MAX_POP, 
                        (a,b) -> a.mass - b.mass
  );
  
  // TODO: explicit locks and conditions also go here (Task2)
  static final Object maxPopLock = new Object(); //TODO: write canvas comment to say this isnt used
  
  //Task3
  static CyclicBarrier newDayBarrier; //barrier thats created anew every dawn
  static final AtomicInteger alivePigCount = new AtomicInteger(INIT_POP); //number of pigs alive for the next day
  static final Object newBarrierLock = new Object();
  static final AtomicBoolean started = new AtomicBoolean(false);

  /* Implementing Awesomeness (a.k.a. the pigs) */
  static class PhotoPig implements Runnable {
    
    /* Take this, USA! */
    final int id;

    /* Watch your lines, piggie! */
    int mass;

    /* Sweet dreams (are made of this) */
    void pigSleep() throws InterruptedException {
      Random rand = new Random();
      Thread.sleep(rand.nextInt(TIC_MAX - TIC_MIN) + TIC_MIN);
      return;
    }

    /* Ensuring free speech */
    void pigSay(String msg) {
        synchronized(PigMent.class){
            System.out.println("<Pig#" + this.id + 
                    "," + this.mass +
                    ">: " + msg);
        }
    }

    /* Here comes the esoteric stuff */
    boolean eatLight() throws InterruptedException {
      openArea.add(this);
      pigSleep();
      if(openArea.remove(this) == false){
          return false; //died while eating light
      }
      
      mass += FEED; //anabolic
      mass -= mass / BMR; //catabolic
      pigSay("Holy crap, I just ate light!");
      
      if(mass / BMR > FEED / 2){
        pigSay("This vessel can no longer hold the both of us!");
        new PhotoPig(mass / 2); //új disznó születik, magát kelti életre
        mass = mass / 2;
      }
      
      return true; // TODO: replace this placeholder (task1 and task2)
    }

    /* Hey, this ain't vegan! */
    boolean aTerribleThingToDo() throws InterruptedException {
        PhotoPig prey = openArea.peek();
        if(prey == null || prey.getMass() > this.mass) 
            return true; //no prey found
        
        openArea.add(this);
        pigSleep();
        if(openArea.remove(this)){
            if(openArea.remove(prey)){
                pigSay("Bless me, Father, for I have sinned.");
                this.mass += prey.getMass();
            }
            return true; //survived
        }
        return false; //we got hunted
    }

    /* Every story has a beginning */
    public PhotoPig(int mass) {
      this.mass = mass;
      synchronized(currentId){
        this.id   = currentId.getAndAdd(1);
        if(this.id >= MAX_POP){
            currentId.notifyAll();
        } else{
            pigPool.submit(this); //életre kelti magát
        }
      }
    }
    
    public int getMass(){
        return mass;
    }

    /* Live your life, piggie! */
    @Override public void run() {
      pigSay("Beware world, for I'm here now!");
       
      if(started.get() == true){
          //a newly instantiated pig should wait until it can be included in the cb
          synchronized(newBarrierLock){
              try {
                  alivePigCount.incrementAndGet();
                  newBarrierLock.wait();
                  pigSay("First day on the job as not part of the INIT gang");
              } catch (InterruptedException ex) {
                  pigSay("Oh dear, this happened before my first day :(");
              }
          }
      }
      
      boolean living = true;
      while(living){
          try {
              pigSay("Waiting for my mates to start the day too...");
              if(newDayBarrier.await() == 0){
                  replaceBarrier();
                  synchronized(newBarrierLock){
                    newBarrierLock.notifyAll();
                  }
                  synchronized(started){
                    if(started.get() == false)
                      started.set(true);
                  }
              }
              else{
                  synchronized(newBarrierLock){
                    newBarrierLock.wait();
                  }
              }
              pigSay("Started new day!");
              living = aTerribleThingToDo() && eatLight();
              if(living){
                  alivePigCount.incrementAndGet();
              } else{
                  //notifying the barrier that we have ended our daz before dying
                  newDayBarrier.await(); 
              }
              
          } catch (InterruptedException ex) {
              pigSay("Look on my works, ye Mighty, and despair!");
              break;
          } catch (BrokenBarrierException ex) {
              pigSay("Oh dear, this should not have happened.");
              break;
          }
      }
      
      if(!living)
        pigSay("I have endured unspeakable horrors. Farewell, world!");
      return;
    }
  }
  
  public static void replaceBarrier(){
      //try {
          //ensuring this happens after all the parties of the existing cb have started,
          // but before it's possible that a pig has finished it's day
      //    Thread.sleep(TIC_MIN / 2);
      //} catch (InterruptedException ex) {
      //    System.out.println("this REALLY shouldnt have happened");
      //}

    int beforeCount = alivePigCount.get();
    System.out.println("Replacing barrier with new count: " + beforeCount);
    newDayBarrier = new CyclicBarrier( beforeCount );
    alivePigCount.set(0);
  }

  /* Running the simulation */
  public static void main(String[] args) throws InterruptedException {
    newDayBarrier = new CyclicBarrier(INIT_POP);
     
    for (int i = 0; i < INIT_POP; i++) {
        new PhotoPig(INIT_MASS);
    }
    
    //starting the first day and the cycled
    synchronized(newBarrierLock){
        newBarrierLock.notifyAll();
    }

    synchronized(currentId) {
        while(currentId.get() < MAX_POP){
            currentId.wait();
        }
    }

    pigPool.shutdownNow();
    
    return;
  }
}
