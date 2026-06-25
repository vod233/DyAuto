"""
诊断抖音作者主页 UI 结构
"""
import sys
import os
import time
import logging

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

from dy.main_controller import ScoutTaskRunner
from dy.actions.navigation import EnsureHomeAction, EnterSearchAction, EnterFirstVideoAction

# 连接设备
runner = ScoutTaskRunner(serial='10AE3M011A002C4', config_path='dy/config/user_settings.yaml')
runner.launch_app()

# 搜索并进入视频
runner.run_action(EnterSearchAction, "创业")
time.sleep(3)
runner.run_action(EnterFirstVideoAction)
time.sleep(3)

# 滑动到作者主页
import random
d = runner.device
w, h = d.window_size()
print(f"\n屏幕尺寸: {w}x{h}")
print("\n>>> 滑动到作者主页...")
d.swipe(int(w * 0.9), int(h / 2), int(w * 0.1), int(h / 2), duration=0.3)
time.sleep(3)

# dump 当前页面 UI
print("\n>>> 当前页面所有 TextView:")
try:
    xml = d.dump_hierarchy()
    # 保存 XML
    with open('dy_author_page.xml', 'w', encoding='utf-8') as f:
        f.write(xml)
    print(f"  UI 层级已保存到 dy_author_page.xml")
    
    # 解析关键信息
    import xml.etree.ElementTree as ET
    root = ET.fromstring(xml)
    
    print("\n>>> 所有 TextView 文本:")
    for node in root.iter('node'):
        text = node.get('text', '')
        desc = node.get('content-desc', '')
        cls = node.get('class', '')
        if text or desc:
            if 'TextView' in cls or 'Button' in cls:
                bounds = node.get('bounds', '')
                print(f"  text='{text}' desc='{desc}' bounds={bounds}")
    
    print("\n>>> 查找关注按钮:")
    for node in root.iter('node'):
        text = node.get('text', '')
        desc = node.get('content-desc', '')
        clickable = node.get('clickable', 'false')
        if '关注' in text or '关注' in desc or '已关注' in text:
            bounds = node.get('bounds', '')
            print(f"  text='{text}' desc='{desc}' clickable={clickable} bounds={bounds}")
    
    print("\n>>> 查找粉丝相关:")
    for node in root.iter('node'):
        text = node.get('text', '')
        if '粉丝' in text or '万' in text:
            bounds = node.get('bounds', '')
            print(f"  text='{text}' bounds={bounds}")

except Exception as e:
    print(f"  dump 失败: {e}")

# 返回
d.press("back")
time.sleep(1)
d.press("back")
time.sleep(1)

runner.shutdown()
