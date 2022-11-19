package hu.elte.pp;

public class VolatilisGond {

    private static volatile boolean ready = false;
    private static volatile int number = -1;

    public static void main(String[] args) throws InterruptedException {
        System.out.println("Getting ready...");
        new Thread(()->{
            while (!ready) {
                Thread.yield();
            }
            System.out.println(number);
        }).start();


        Thread.sleep(5_000);
        System.out.println("Ready to set values");
        number = 42;
        ready = true;
    }
}
