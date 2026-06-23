import logging
import os
import datetime
import collections

# 全局内存日志缓存（保留最近 100 条）
MEMORY_LOGS = collections.deque(maxlen=100)

class MemoryHandler(logging.Handler):
    """自定义 Handler，将日志内容写入到内存队列中，供前端 API 读取"""
    def emit(self, record):
        try:
            msg = self.format(record)
            MEMORY_LOGS.append(msg)
        except Exception:
            self.handleError(record)

def setup_logger():
    """
    配置全局日志记录器
    将日志同时输出到控制台、以当前时间命名的文件中，以及内存队列中
    """
    # 1. 创建 logs 文件夹
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    logs_dir = os.path.join(project_root, "logs")
    os.makedirs(logs_dir, exist_ok=True)
    
    # 2. 生成以日期时间命名的日志文件路径 (如: 2026-04-23_15-30-45.log)
    current_time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log_filename = f"{current_time}.log"
    log_filepath = os.path.join(logs_dir, log_filename)
    
    # 3. 配置全局 logging
    # 清理已有的 handlers，防止重复记录
    root_logger = logging.getLogger()
    if root_logger.hasHandlers():
        root_logger.handlers.clear()
        
    root_logger.setLevel(logging.INFO)
    
    # 日志格式
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    
    # 文件 Handler (UTF-8 编码，防止中文乱码)
    file_handler = logging.FileHandler(log_filepath, encoding='utf-8')
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)
    
    # 控制台 Handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)
    
    # 内存 Handler (供前端展示)
    memory_handler = MemoryHandler()
    memory_handler.setLevel(logging.INFO)
    memory_handler.setFormatter(formatter)
    
    # 添加到全局 logger
    root_logger.addHandler(file_handler)
    root_logger.addHandler(console_handler)
    root_logger.addHandler(memory_handler)
    
    # 打印一条启动日志，告知文件位置
    logging.info(f"已初始化日志系统，当前日志文件: {log_filepath}")
    
    return log_filepath
