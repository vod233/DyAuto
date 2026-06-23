import os
import time
from contextlib import contextmanager

import uiautomator2 as u2


LOCK_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".uiautomator2_connect.lock")


@contextmanager
def uiautomator2_connect_lock(timeout=30):
    start = time.time()
    lock_file = open(LOCK_PATH, "a+b")
    locked = False
    try:
        if os.name == "nt":
            import msvcrt

            while not locked:
                try:
                    lock_file.seek(0)
                    msvcrt.locking(lock_file.fileno(), msvcrt.LK_NBLCK, 1)
                    locked = True
                except OSError:
                    if time.time() - start >= timeout:
                        raise TimeoutError("等待 UIAutomator2 连接锁超时")
                    time.sleep(0.2)
            yield
        else:
            import fcntl

            while not locked:
                try:
                    fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
                    locked = True
                except BlockingIOError:
                    if time.time() - start >= timeout:
                        raise TimeoutError("等待 UIAutomator2 连接锁超时")
                    time.sleep(0.2)
            yield
    finally:
        if locked:
            if os.name == "nt":
                lock_file.seek(0)
                msvcrt.locking(lock_file.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)
        lock_file.close()


def locked_u2_connect(serial):
    with uiautomator2_connect_lock():
        return u2.connect(serial)
