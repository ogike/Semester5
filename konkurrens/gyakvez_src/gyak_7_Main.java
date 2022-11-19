import java.util.Random;
import java.util.concurrent.*;

public class Main {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newCachedThreadPool();
        BlockingQueue<Integer> queue =
                //new SynchronousQueue<>();
                //new ArrayBlockingQueue<>(10);
                new LinkedBlockingQueue<>();
        Random random = new Random();
        executor.submit(()->{
            boolean run = true;
            while (run) {
                Thread.sleep(1_000);
                int generated = random.nextInt(100);
                queue.put(generated);
                System.out.println("generated: "+generated+" queue length: "+ queue.size());
            }
            return 1;
        });
        executor.submit(()->{
            boolean run = true;
            while (run) {
                int value = queue.take();
                System.out.println("taken: "+value+" queue length: "+queue.size());
                Thread.sleep(2_000);
            }
           return 1;
        });
    }
}