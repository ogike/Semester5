package hu.elte.pp;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Locks {
    public static void main(String[] args) throws InterruptedException {
        Lock lock = new ReentrantLock(true);
        lock.lock();
        try {
            // tricky part comes here
        } finally {
            lock.unlock();
        }
        if(lock.tryLock()) {
            try {
            } finally {
                lock.unlock();
            }
        } else {
            // I don't have the lock
        }
        if(lock.tryLock(24, TimeUnit.HOURS)) {
            try {
            } finally {
                lock.unlock();
            }
        } else {

        }
        lock.lockInterruptibly();
        try {

        } finally {
            lock.unlock();
        }
    }
}
