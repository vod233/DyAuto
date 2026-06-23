import os
from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env"))

import streamlit as st
from xhs.xhs_app import render_xhs_page
from douyin.douyin_app import render_douyin_page

st.set_page_config(page_title="全平台自动化群控系统", page_icon="📱", layout="wide")

def render_kuaishou_page():
    st.title("🎬 快手自动化群控")
    st.info("快手控制模块正在开发中，敬请期待...")

def render_sph_page():
    st.title("🟢 视频号自动化群控")
    st.info("视频号控制模块正在开发中，敬请期待...")

def main():
    st.sidebar.title("🌐 平台切换")
    platform = st.sidebar.selectbox(
        "请选择您要控制的社交平台", 
        ["🏠 系统主页", "🔴 小红书", "🎵 抖音", "🎬 快手", "🟢 视频号"]
    )
    
    st.sidebar.markdown("---")
    
    if platform == "🏠 系统主页":
        st.title("📱 全平台自动化群控系统")
        st.markdown('''
        欢迎使用自动化群控系统！目前支持将不同平台的自动化任务集成到同一个后台管理面板中。
        
        请在左侧边栏顶部的 **平台切换** 下拉菜单中选择您要进入的具体应用模块。
        
        ### 支持的平台：
        - 🔴 **小红书** (已上线：支持图文/视频全自动搜索、点赞、关注、AI 评论)
        - 🎵 **抖音** (开发中)
        - 🎬 **快手** (开发中)
        - 🟢 **视频号** (开发中)
        ''')
    elif platform == "🔴 小红书":
        render_xhs_page()
    elif platform == "🎵 抖音":
        render_douyin_page()
    elif platform == "🎬 快手":
        render_kuaishou_page()
    elif platform == "🟢 视频号":
        render_sph_page()

if __name__ == "__main__":
    main()
