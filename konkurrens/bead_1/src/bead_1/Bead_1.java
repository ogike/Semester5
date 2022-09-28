/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package bead_1;

/**
 *
 * @author ogike
 */
public class Bead_1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int n = 5;
        if(args.length == 0){
            System.out.println("No arguments given for number of threads to run, using 5!");
        }
        else{
            n = Integer.parseInt(args[0]);
        }
        
        for (int i = 1; i <= n; i++) {
            final int myId = i;
            Thread t = new Thread(() -> {
                for (int j = 0; j < 10; j++) {
                    System.out.println(myId);
                }
            });
            t.start();
        }
        System.out.println("End of main");
    }
    
}
