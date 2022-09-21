package hu.elte.ik;

public class Elso {
    public static void main(String[] args) {
        if(args.length == 0) {
            System.out.println("Hello World!");
        } else {
            for(int i = 0; i<args.length; ++i) {
                System.out.println("Hello " + args[i] + "!");
            }
        }
        var c = new I3();
        System.out.println(c.countTires());
        System.out.println(c.getType());
    }
    public interface Car {
        int countTires();
    }
    public static abstract class Bmw implements Car {
        public abstract String getType();
    }
    public static class I3 extends Bmw {

        @Override
        public int countTires() {
            return 4;
        }

        @Override
        public String getType() {
            return this.getClass().getSimpleName();
        }
    }
}