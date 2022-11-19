import java.util.Random;
import java.util.concurrent.*;

public class TimeOutExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newCachedThreadPool();
        BlockingQueue<Integer> queue =
                //new SynchronousQueue<>();
                new ArrayBlockingQueue<>(10);
                //new LinkedBlockingQueue<>();
        Random random = new Random();
        executor.submit(()->{
            boolean run = true;
            while (run) {
                Thread.sleep(1_000);
                int generated = random.nextInt(100);
                boolean success = queue.offer(generated, 100L, TimeUnit.MILLISECONDS);
                System.out.println("generated: "+generated+" queue length: "+ queue.size()+"\t"+success);
                if(!success) {
                    run = false;
                    queue.put(-1);
                }
            }
            return 1;
        });
        executor.submit(()->{
            boolean run = true;
            while (run) {
               Integer value = queue.poll(300L, TimeUnit.MILLISECONDS);
               System.out.println("taken: " + value + " queue length: " + queue.size());
               Thread.sleep(2_000);
               if(value != null && value == -1) {
                   run = false;
               }
            }
            return 1;
        });
        executor.shutdown();
    }
}
