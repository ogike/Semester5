package hu.elte.pp;

import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class RwLocks {
    private static class IntBox {
        private int boxed;
        private final ReadWriteLock lock = new ReentrantReadWriteLock();

        public IntBox(int boxed) {
            this.boxed = boxed;
        }

        public int getBoxed() {
            lock.readLock().lock();
            try {
                return boxed;
            } finally {
                lock.readLock().unlock();
            }
        }

        public void setBoxed(int boxed) {
            lock.writeLock().lock();
            try {
                this.boxed = boxed;
            } finally {
                lock.writeLock().unlock();
            }
        }
    }
}
