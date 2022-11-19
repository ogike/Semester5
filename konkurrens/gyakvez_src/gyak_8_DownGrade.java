package hu.elte.pp;

import java.util.concurrent.Callable;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class DownGrade {

    private static class Triplet {
        int a;
        int b;
        boolean isHalf;
        final ReadWriteLock lock = new ReentrantReadWriteLock();

        public Triplet(int a, int b) {
            this.a = a;
            this.b = b;
            isHalf = calculateIsHalf();
        }

        public int getA() {
            return doInReadLock(()->a);
        }

        public void setA(int a) {
            doInWriteLock(()->this.a=a);
        }

        public int getB() {
            return doInReadLock(()->b);

        }

        public void setB(int b) {
            doInWriteLock(()->this.b=b);
        }

        public boolean isHalf() {
            return doInReadLock(()->isHalf);
        }

        public void setHalf(boolean half) {
            doInWriteLock(()->this.isHalf=isHalf);
        }

        /** Downgrade */
        public boolean setNums(int a, int b) {
            boolean localIsHalf = calculateIsHalf(a, b);
            boolean doIOwnWriteLock = false;
            lock.writeLock().lock();
            try {
                doIOwnWriteLock = true;
                this.a = a;
                this.b = b;
                if(isHalf == localIsHalf) {
                    lock.readLock().lock();
                    try {
                        lock.writeLock().unlock();
                        doIOwnWriteLock = false;
                        return isHalf;
                    } finally {
                        lock.readLock().unlock();
                    }
                } else {
                    isHalf = localIsHalf;
                    return isHalf;
                }
            } finally {
                if(doIOwnWriteLock) {
                    lock.writeLock().unlock();
                }
            }
        }

        public boolean setNumsUpgrade(int a, int b) {
            boolean doIOwnReadLock = false;
            lock.readLock().lock();
            try {
                doIOwnReadLock = true;
                boolean isSame = this.a == a && this.b == b;
                if (isSame) {
                    return isHalf;
                } else {
                    lock.readLock().unlock();
                    doIOwnReadLock = false;
                    lock.writeLock().lock();
                    try {
                        isSame = this.a == a && this.b == b;
                        if(!isSame) {
                            this.a = a;
                            this.b = b;
                            this.isHalf = calculateIsHalf();
                        }
                        return isHalf;
                    } finally {
                        lock.writeLock().unlock();
                    }
                }
            } finally {
                if(doIOwnReadLock) {
                    lock.readLock().unlock();
                }
            }
        }

        private boolean calculateIsHalf() {
            return calculateIsHalf(a, b);
        }

        private boolean calculateIsHalf(int a, int b) {
            return a == 2*b;
        }

        private <T> T doInReadLock(Callable<T> callable) {
            lock.readLock().lock();
            try {
                return callable.call();
            } catch (Exception e) {
                throw new RuntimeException(e);
            } finally {
                lock.readLock().unlock();
            }
        }
        private void doInWriteLock(Runnable task) {
            lock.writeLock().lock();
            try {
                task.run();
            } finally {
                lock.writeLock().unlock();
            }
        }
    }
}
