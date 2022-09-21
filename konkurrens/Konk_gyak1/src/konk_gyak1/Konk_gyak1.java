/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package konk_gyak1;

/**
 *
 * @author ogike
 */
public class Konk_gyak1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //Thread t = new Thread(new MyRunnable());
        //Thread t = new Thread(Konk_gyak1::sayHello); //lambda hívással átadva a fgv-t
                                                    //ez a háttérben létrehoz egy megfelelő runnable objketumot
        Thread t = new Thread(() -> {
            System.out.println("Hello from my thread: " + Thread.currentThread().getName());
        });
        t.start();
        new Thread(new MyRunnable()).start();
        System.out.println("Hello from main");
        
        //Feladat1();
        Feladat3();
    }
    
    private static class MyThread extends Thread {
        //ezt kell felül definiálni, nem a start()-ot!
        public void run(){
            System.out.println("Hello from my thread: " + Thread.currentThread().getName());
        }
    }
    
    //ez a legjobb megoldás általában, ha többet akarunk mint egy gyors lambda kifejezés
    private static class MyRunnable implements Runnable {
        @Override
        public void run() {
            System.out.println("Hello my thread: " + Thread.currentThread().getName());
            
        }        
    }
    
    static void sayHello(){
        System.out.println("Hello my thread: " + Thread.currentThread().getName());
    }
    
    
    //Készíts két szálat és futtasd őket.
    //A szálak írják ki a hello 1, hello 2, …, hello 100000 és world 1, …, world 100000 szövegeket.
    static void Feladat1(){
        Thread t1 = new Thread(() -> {
            for (int i = 1; i <= 100000; i++) {
                System.out.println("hello " + i);
            }
        });
        
        Thread t2 = new Thread(() -> {
            for (int i = 1; i <= 100000; i++) {
                System.out.println("world " + i);
            }
        });
        
        t1.start();
        t2.start();
        
        //Futtass három szálat, a harmadik other 1 stb. szövegeket írjon ki.
        Thread t3 = new Thread(() -> {
            for (int i = 1; i <= 100000; i++) {
                System.out.println("other " + i);
            }
        });
        
        t3.start();
    }
    
    //Egy tömb szövegeket tartalmaz, mindegyikhez készíts és futtass a fentiekhez hasonló szálakat.
    static void Feladat3(){
        String[] str_arr = {"ez", "egy", "halom", "szöveg"};
        for (String string : str_arr) {
            Thread t = new Thread(() -> {
                //note: ebben a lambda expressionban csak final változókat használhatunk kívülről
                //(amúgy ha olyat használnánk ami nem, változhat annak a mem. ter.nek az értéke egy másik szál futása közben
                //((big no no))
                for (int i = 1; i <= 100_000; i++) {
                    System.out.println(string + i);
                }
            });
            t.start();
        }
    }
    
    //alternatív megoldés
    static void Feladat1Alt(int number){
        new Thread(createLambda("Hello", number)).start();
        new Thread(createLambda("world", number)).start();
        new Thread(createLambda("other", number)).start();

    }
    
    
    static Runnable createLambda(String message, int num){
        return () -> {
            for (int i = 0; i < num; i++) {
                System.out.println(message + " " + num);
            }
        };
    }
    
}
