import logging
import os
from xhs.task_runner import TikTokTaskFlow
from xhs.logger_config import setup_logger

setup_logger()

def run_test():
    print("="*60)
    print("🚀 开始测试：完整业务逻辑任务流 (搜索 -> 筛选 -> 互动)")
    print("="*60)
    
    # 指定我们刚才创建的测试配置文件
    config_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "xhs", "config", "test_settings.yaml"
    )
    
    if not os.path.exists(config_path):
        print(f"❌ 找不到测试配置文件: {config_path}")
        return
        
    # 实例化任务流并启动
    task_flow = TikTokTaskFlow(config_path=config_path)
    task_flow.start()

if __name__ == "__main__":
    run_test()
