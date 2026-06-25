import streamlit as st
import requests
import pandas as pd
import time
API_BASE_URL = "http://127.0.0.1:8000/api"

def render_douyin_page():
    # --- 注入全局自定义 CSS 以美化和对齐 UI ---
    st.markdown("""
    <style>
        /* 统一按钮和输入框的高度 */
        div.stButton > button {
            height: 42px;
            margin-top: 1px; /* 微调与相邻输入框的水平对齐 */
        }
        div[data-baseweb="input"] {
            height: 42px;
        }

        /* 设备列表容器样式优化 */
        .device-row {
            padding: 10px;
            border-radius: 8px;
            background-color: #f8f9fa;
            margin-bottom: 10px;
            border: 1px solid #e9ecef;
        }

        /* 标题统一下边距 */
        h1, h2, h3 {
            margin-bottom: 1rem !important;
        }

        /* 数据看板卡片美化 */
        div[data-testid="stMetricValue"] {
            color: #1f77b4;
        }
    </style>
    """, unsafe_allow_html=True)

    # --- 全局状态管理 ---
    if "controlled_devices" not in st.session_state:
        st.session_state.controlled_devices = []
    if "task_status_data" not in st.session_state:
        st.session_state.task_status_data = {}
    if "terminal_logs" not in st.session_state:
        st.session_state.terminal_logs = ""

    def toggle_device(dev_id):
        if dev_id in st.session_state.controlled_devices:
            st.session_state.controlled_devices.remove(dev_id)
        else:
            st.session_state.controlled_devices.append(dev_id)

    # --- 侧边栏导航 ---
    st.sidebar.title("📱 抖音控制台")
    page = st.sidebar.radio("请选择功能模块", ["设备管理", "规则设置", "流程控制", "数据看板"])

    # ==========================================
    # 页面 1：设备管理
    # ==========================================
    if page == "设备管理":
        st.title("📱 设备管理与任务控制")
        st.markdown("在这里连接您的设备，并单独向它们下发自动化任务。")

        # 1. 设备连接控制台
        st.subheader("🔌 USB 一键检测")
        st.markdown("手机插入电脑并允许 USB 调试后，点击检测即可自动接入。")
        if st.button("检测 USB 设备", key="douyin_detect_usb", use_container_width=True):
            with st.spinner("正在检测 USB 设备并检查自动化引擎..."):
                try:
                    res = requests.post(f"{API_BASE_URL}/devices/usb/detect").json()
                    if res.get("success"):
                        st.success(res.get("message"))
                        for dev in res.get("devices", []):
                            if dev.get("u2_ready"):
                                st.info(f"可用设备: {dev.get('serial')} {dev.get('model') or ''}")
                        time.sleep(1)
                        st.rerun()
                    else:
                        st.warning(res.get("message"))
                        for dev in res.get("devices", []):
                            st.error(f"{dev.get('serial')} [{dev.get('status')}]: {dev.get('message')}")
                except Exception as e:
                    st.error(f"USB 检测失败: {e}")

        st.markdown("---")
        st.subheader("🔌 无线连接控制台")

        tab_connect, tab_pair = st.tabs(["🚀 立即连接 (已配对设备)", "🔗 配对新设备 (Android 11+)"])

        with tab_connect:
            with st.form("connect_form", border=True):
                st.markdown("输入手机无线调试主界面的 **连接 IP:端口**，例如 `192.168.1.100:43215`")
                col1, col2 = st.columns([4, 1])
                with col1:
                    ip_port_input = st.text_input("IP:端口", placeholder="192.168.x.x:端口", label_visibility="collapsed")
                with col2:
                    connect_btn = st.form_submit_button("⚡ 立即连接", use_container_width=True)

                if connect_btn:
                    if not ip_port_input:
                        st.warning("请输入 IP 地址和端口号")
                    else:
                        with st.spinner(f"正在尝试连接 {ip_port_input}..."):
                            try:
                                res = requests.post(f"{API_BASE_URL}/devices/connect", json={"ip_port": ip_port_input}).json()
                                if res.get("success"):
                                    st.success(res.get("message"))
                                    time.sleep(1) # 稍微等待让 ADB 刷新状态
                                    st.rerun() # 刷新页面以更新下方设备列表
                                else:
                                    st.error(res.get("message"))
                            except Exception as e:
                                st.error(f"请求连接失败: {e}")

        with tab_pair:
            with st.form("pair_form", border=True):
                st.markdown("点击手机上的「使用配对码配对设备」，输入屏幕上显示的 **配打 IP:端口** 和 **6位配对码**")
                col1, col2, col3 = st.columns([3, 2, 1])
                with col1:
                    pair_ip_input = st.text_input("配对 IP:端口", placeholder="192.168.x.x:配对端口", label_visibility="collapsed")
                with col2:
                    pair_code_input = st.text_input("6位配对码", placeholder="例如: 123456", label_visibility="collapsed")
                with col3:
                    pair_btn = st.form_submit_button("🔗 立即配对", use_container_width=True)

                if pair_btn:
                    if not pair_ip_input or not pair_code_input:
                        st.warning("请输入配对 IP 端口和配对码")
                    else:
                        with st.spinner(f"正在尝试配对 {pair_ip_input}..."):
                            try:
                                res = requests.post(f"{API_BASE_URL}/devices/pair", json={"ip_port": pair_ip_input, "code": pair_code_input}).json()
                                if res.get("success"):
                                    st.success(res.get("message") + "，请返回手机无线调试主界面，切换到上方「立即连接」标签进行连接！")
                                else:
                                    st.error(res.get("message"))
                            except Exception as e:
                                st.error(f"请求配对失败: {e}")

        st.markdown("---")

        # 2. 获取并展示设备列表
        st.subheader("📱 已接入设备列表")
        try:
            resp = requests.get(f"{API_BASE_URL}/devices")
            if resp.status_code == 200:
                devices = resp.json().get("devices", [])
            else:
                devices = []
                st.error("无法获取设备列表，请检查后端是否运行。")
        except Exception as e:
            devices = []
            st.error(f"后端连接失败: {e}")

        if not devices:
            st.warning("当前未检测到任何设备。请通过上方连接控制台进行无线连接，或通过 USB 连接手机。")
        else:
            st.success(f"✅ 检测到 {len(devices)} 台在线设备")

            # 3. 设备列表与单设备控制按钮
            for idx, dev in enumerate(devices):
                with st.container(border=True):
                    col_info, col_btn_ctrl, col_btn_del = st.columns([5, 2, 2])
                    is_controlled = dev in st.session_state.controlled_devices

                    with col_info:
                        if is_controlled:
                            st.markdown(f"<div style='padding-top: 8px; color: #28a745; font-weight: bold;'>✅ [已选中控制] 设备标识: {dev}</div>", unsafe_allow_html=True)
                        else:
                            st.markdown(f"<div style='padding-top: 8px; color: #6c757d; font-weight: bold;'>ℹ️ [未选中] 设备标识: {dev}</div>", unsafe_allow_html=True)

                    with col_btn_ctrl:
                        if is_controlled:
                            # 仅在此处渲染取消选中按钮，不再显示开始/暂停/继续/结束等任务按钮
                            if st.button("❌ 取消选中", key=f"cancel_{dev}", use_container_width=True):
                                toggle_device(dev)
                                st.rerun()
                        else:
                            if st.button("▶ 选择控制", key=f"select_{dev}", use_container_width=True):
                                toggle_device(dev)
                                st.rerun()

                    with col_btn_del:
                        if st.button("🗑️ 断开设备", key=f"del_{dev}", type="secondary", use_container_width=True):
                            with st.spinner(f"正在断开 {dev}..."):
                                try:
                                    res = requests.post(f"{API_BASE_URL}/devices/disconnect", json={"ip_port": dev}).json()
                                    if res.get("success"):
                                        # 如果该设备原本在控制列表中，一并移除
                                        if is_controlled:
                                            toggle_device(dev)
                                        st.success(res.get("message"))
                                        time.sleep(1)
                                        st.rerun()
                                    else:
                                        st.error(res.get("message"))
                                except Exception as e:
                                    st.error(f"请求断开设备失败: {e}")

        # 4. 实时任务状态展示
        st.markdown("---")
        st.subheader("🔄 实时任务监控")

        # 提取获取状态的逻辑
        def fetch_status():
            try:
                resp = requests.get(f"{API_BASE_URL}/tasks/status").json()
                st.session_state.task_status_data = resp.get("status", {})
            except Exception as e:
                st.error("无法获取任务状态。")

        st.button("刷新状态", use_container_width=True, on_click=fetch_status)

        # 从 session_state 中渲染
        status_data = st.session_state.task_status_data
        if not status_data:
            st.info("当前没有任务在运行。")
        else:
            for serial, info in status_data.items():
                state = info.get("status")
                if state == "queued":
                    st.info(f"🕒 设备 **{serial}**: 任务已提交，等待线程调度...")
                elif state == "starting":
                    st.info(f"🔄 设备 **{serial}**: 正在初始化设备连接并启动应用...")
                elif state == "running":
                    st.info(f"▶️ 设备 **{serial}**: 正在执行任务中...")
                elif state == "paused":
                    st.warning(f"⏸️ 设备 **{serial}**: 任务已暂停")
                elif state == "completed":
                    st.success(f"✅ 设备 **{serial}**: 任务已完成")
                elif state == "stopped":
                    st.error(f"🛑 设备 **{serial}**: 任务已被手动结束")
                elif state == "error":
                    st.error(f"❌ 设备 **{serial}**: 执行报错 - {info.get('error')}")

    # ==========================================
    # 页面 2：规则设置
    # ==========================================
    elif page == "规则设置":
        st.title("⚙️ 自动化规则设置")
        st.markdown("在此配置所有的业务逻辑参数。")

        # 读取当前配置
        current_config = {}
        try:
            resp = requests.get(f"{API_BASE_URL}/config?platform=douyin")
            if resp.status_code == 200:
                current_config = resp.json().get("config", {})
        except:
            st.warning("后端未启动，加载默认空配置。")

        with st.form("config_form", border=True):
            # 强制设置卡片高度对齐的 CSS 样式
            st.markdown(
                """
                <style>
                div[data-testid="stVerticalBlockBorderWrapper"] {
                    height: 100%;
                }
                div[data-testid="stVerticalBlock"] > div[data-testid="stVerticalBlockBorderWrapper"] > div {
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                }
                </style>
                """,
                unsafe_allow_html=True
            )

            # 将配置分为三大版块：左侧为搜索与基础控制，中间为 AI 截流策略，右侧为 AI 回复配置
            col1, col2, col3 = st.columns(3)

            with col1:
                with st.container(border=True, height=320):
                    st.subheader("🔍 搜索与基础控制")
                    keywords_str = st.text_area(
                        "搜索关键词 (每行一个)", 
                        value="\n".join(current_config.get("search_keywords", [])),
                        height=150
                    )
                    sort_by = st.selectbox(
                        "视频排序方式", 
                        options=["latest", "most_liked"], 
                        index=0 if current_config.get("sort_by") == "latest" else 1,
                        format_func=lambda x: "最新发布" if x == "latest" else "最多点赞"
                    )

                with st.container(border=True, height=360):
                    st.subheader("⏱️ 爬虫控制")
                    max_daily = st.number_input("【全局】每日处理视频总上限", value=current_config.get("max_daily_videos", 100), min_value=1, help="当天处理过的所有视频数达到此数量后，手机将自动停止任务")
                    max_videos = st.number_input("每个关键词最多刷多少个视频", value=current_config.get("max_videos_per_keyword", 5), min_value=1)
                    min_stay = st.number_input("视频最小停留时间(秒)", value=current_config.get("min_video_stay", 3), min_value=1)
                    max_stay = st.number_input("视频最大停留时间(秒)", value=current_config.get("max_video_stay", 6), min_value=1)

                with st.container(border=True, height=280):
                    st.subheader("✅ 执行功能选择")
                    enable_like = st.checkbox(
                        "点赞",
                        value=bool(current_config.get("enable_like", True)),
                        help="对进入的视频执行双击点赞"
                    )
                    enable_author_follow = st.checkbox(
                        "进作者主页，粉丝数判断成功，关注作者，私信作者",
                        value=bool(current_config.get("enable_author_follow", True)),
                        help="进入作者主页后按粉丝阈值判断，符合条件则关注，并按私信策略尝试发送私信"
                    )
                    enable_video_comment = st.checkbox(
                        "AI 生成视频评论，发布视频评论",
                        value=bool(current_config.get("enable_video_comment", True)),
                        help="根据视频标题生成评论并发布到当前视频"
                    )
                    enable_comment_lead = st.checkbox(
                        "打开评论区，AI 识别意向评论，楼中楼回复",
                        value=bool(current_config.get("enable_comment_lead", True)),
                        help="打开评论区，按上限识别意向评论并自动楼中楼回复"
                    )
                    st.caption("任务执行时会严格按本区域从上到下的顺序执行已勾选功能。")

            with col2:
                with st.container(border=True, height=700):
                    st.subheader("🎯 AI 截流获客策略")
                    max_ai_reviews = st.number_input(
                        "每个视频最多让 AI 识别多少条评论",
                        value=int(current_config.get("max_ai_comment_reviews", 20)),
                        min_value=1,
                        max_value=200,
                        step=1,
                        help="达到上限后停止继续扫描评论区，降低风控和设备压力"
                    )
                    max_swipes = st.number_input(
                        "评论区最大向下滑动次数",
                        value=current_config.get("max_comment_swipes", 2),
                        min_value=1,
                        max_value=30,
                        help="控制评论区翻页深度，和识别条数上限共同生效"
                    )
                    st.caption("系统会用 AI 判断评论是否有咨询、求推荐、想了解、求教程等意愿。命中后自动生成楼中楼回复，引导对方查看主页。")
                    
                    # 自定义意向关键词
                    st.markdown("---")
                    st.subheader("🔍 自定义意向关键词")
                    intent_keywords = st.text_input(
                        "额外意向触发词（逗号分隔）",
                        value=current_config.get("intent_keywords", ""),
                        placeholder="产品, 求购, 咨询, 价格, 怎么买",
                        help="当评论中包含这些词时，AI 会判定为意向客户并主动回复"
                    )
                    st.caption("💡 示例：输入「产品」后，评论区出现「这里想要什么产品」就会被识别为意向客户")

            with col3:
                with st.container(border=True, height=700):
                    st.subheader("🔐 软件授权与 AI 算力")
                    if st.session_state.get("license_save_msg"):
                        st.success(st.session_state.license_save_msg)
                        st.session_state.license_save_msg = None
                    ai_enabled = st.toggle(
                        "启用 AI 自动回复与截流",
                        value=current_config.get("ai_enabled", True),
                        help="用于视频标题评论、评论区意向识别和楼中楼回复"
                    )
                    if current_config.get("has_license_key"):
                        st.success(f"已保存授权码：{current_config.get('license_key_masked', '')}")
                    else:
                        st.warning("尚未配置授权码，无法启动任务。")

                    license_key = st.text_input(
                        "客户授权码",
                        value="",
                        type="password"
                    )
                    license_server_url = st.text_input(
                        "授权服务器",
                        value=current_config.get("license_server_url", "https://lcjx.yun/social-ai-credit-api"),
                        help="客户一般无需修改。脚本会通过该服务器验证授权码并扣减 AI Token 积分。"
                    )
                    if st.form_submit_button("🔎 验证授权码", use_container_width=True):
                        try:
                            verify_key = license_key.strip()
                            if not verify_key:
                                st.warning("请输入完整授权码后再验证。")
                            else:
                                verify_resp = requests.post(
                                    f"{API_BASE_URL}/license/save?platform=douyin",
                                    json={"license_key": verify_key, "license_server_url": license_server_url.strip()},
                                    timeout=20,
                                ).json()
                                if verify_resp.get("success"):
                                    info = verify_resp.get("data", {})
                                    st.session_state.license_save_msg = f"授权已保存：{info.get('customer_name', '')}，剩余积分 {info.get('balance_credits', 0)}"
                                    st.rerun()
                                else:
                                    st.error(verify_resp.get("message", "授权验证失败"))
                        except Exception as e:
                            st.error(f"验证失败: {e}")
                    ai_model = st.text_input(
                        "模型名称",
                        value=current_config.get("ai_model", "deepseek-v4-flash"),
                        disabled=True,
                        placeholder="deepseek-v4-flash"
                    )
                    ai_temperature = st.slider(
                        "生成随机度",
                        min_value=0.0,
                        max_value=1.5,
                        value=float(current_config.get("ai_temperature", 0.7)),
                        step=0.1
                    )
                    ai_max_tokens = st.number_input(
                        "最大输出 Token",
                        value=int(current_config.get("ai_max_tokens", 120)),
                        min_value=32,
                        max_value=512,
                        step=8
                    )
                    st.caption("DeepSeek API Key 统一保存在服务器，客户电脑只保存授权码；启动任务前会先校验授权码。")

            st.markdown("---")
            with st.container(border=True):
                st.subheader("📧 作者私信策略")
                pm_messages_str = st.text_area(
                    "私信话术输入框（每行一条，可自由增删）",
                    value="\n".join(current_config.get("pm_message_list", [])),
                    height=220,
                    help="任务执行时会从这里的非空行中随机抽取一条，作为私信内容发送。"
                )

                pm_messages_list = [m.strip() for m in pm_messages_str.split("\n") if m.strip()]
                if pm_messages_list:
                    st.caption(f"当前共 {len(pm_messages_list)} 条私信话术，执行时随机抽取其中一行。")
                else:
                    st.caption("提示：请至少填写一条私信话术，否则私信功能会自动跳过。")

                pm_col1, pm_col2, pm_col3 = st.columns(3)
                with pm_col1:
                    min_followers = st.number_input(
                        "最小关注粉丝阈值（万）",
                        value=float(current_config.get("min_followers_threshold", 0)),
                        min_value=0.0,
                        max_value=1000.0,
                        step=0.1,
                        help="作者粉丝数低于该值时跳过关注，0 表示不限制"
                    )
                with pm_col2:
                    enable_pm = st.toggle(
                        "启用作者私信",
                        value=bool(current_config.get("enable_private_message", True)),
                        help="仅在进入作者主页后，且粉丝数超过私信阈值时尝试发送"
                    )
                with pm_col3:
                    pm_threshold = st.number_input(
                        "私信粉丝阈值（万）",
                        value=float(current_config.get("pm_followers_threshold", 1)),
                        min_value=0.0,
                        max_value=1000.0,
                        step=0.1
                    )

            st.markdown("---")
            submitted = st.form_submit_button("💾 保存当前配置", type="primary", use_container_width=True)

            if submitted:
                # 组装 Payload
                payload = {
                    "search_keywords": [k.strip() for k in keywords_str.split("\n") if k.strip()],
                    "sort_by": sort_by,
                    "comments": [],
                    "target_keywords": [],
                    "reply_texts": [],
                    "max_daily_videos": max_daily,
                    "max_videos_per_keyword": max_videos,
                    "min_video_stay": min_stay,
                    "max_video_stay": max_stay,
                    "max_comment_swipes": max_swipes,
                    "max_ai_comment_reviews": max_ai_reviews,
                    "intent_keywords": [k.strip() for k in intent_keywords.split(",") if k.strip()],
                    "enable_like": enable_like,
                    "enable_author_follow": enable_author_follow,
                    "enable_video_comment": enable_video_comment,
                    "enable_comment_lead": enable_comment_lead,
                    "min_followers_threshold": min_followers,
                    "enable_private_message": enable_pm,
                    "pm_followers_threshold": pm_threshold,
                    "pm_message_list": [m.strip() for m in pm_messages_str.split("\n") if m.strip()],
                    "ai_enabled": ai_enabled,
                    "ai_base_url": license_server_url.strip(),
                    "ai_api_key": "",
                    "ai_model": ai_model.strip(),
                    "ai_temperature": ai_temperature,
                    "ai_max_tokens": ai_max_tokens,
                    "license_key": license_key.strip(),
                    "license_server_url": license_server_url.strip(),
                }

                try:
                    res = requests.post(f"{API_BASE_URL}/config?platform=douyin", json=payload).json()
                    if res.get("success"):
                        st.success("配置已成功保存到后端！")
                    else:
                        st.error(res.get("message"))
                except Exception as e:
                    st.error(f"保存失败，请检查后端状态: {e}")

    # ==========================================
    # 页面 3：流程控制
    # ==========================================
    elif page == "流程控制":
        st.title("🚀 流程控制")
        st.markdown("在确保配置保存完毕，且已在【设备管理】页面选中设备后，点击下方按钮开始群控执行。")

        if not st.session_state.controlled_devices:
            st.warning("⚠️ 您目前尚未选中任何要控制的设备，请先去【设备管理】页面选择。")
            st.button("启动自动化任务", disabled=True, use_container_width=True)
        else:
            st.info(f"✅ 当前已选中准备控制的设备: {', '.join(st.session_state.controlled_devices)}")

            col_start, col_pause, col_resume, col_stop = st.columns(4)

            def action_start():
                try:
                    res = requests.post(f"{API_BASE_URL}/tasks/start", json={"devices": st.session_state.controlled_devices, "platform": "douyin"}).json()
                    if res.get("success"): st.session_state.last_action_msg = res.get("message", "✅ 任务已提交！")
                    else: st.session_state.last_action_err = res.get("message")
                except Exception as e: st.session_state.last_action_err = f"请求开始任务失败: {e}"

            def action_pause():
                try:
                    res = requests.post(f"{API_BASE_URL}/tasks/pause", json={"devices": st.session_state.controlled_devices, "platform": "douyin"}).json()
                    if res.get("success"): st.session_state.last_action_msg = res.get("message")
                    else: st.session_state.last_action_err = res.get("message")
                except Exception as e: st.session_state.last_action_err = f"请求暂停任务失败: {e}"

            def action_resume():
                try:
                    res = requests.post(f"{API_BASE_URL}/tasks/resume", json={"devices": st.session_state.controlled_devices, "platform": "douyin"}).json()
                    if res.get("success"): st.session_state.last_action_msg = res.get("message")
                    else: st.session_state.last_action_err = res.get("message")
                except Exception as e: st.session_state.last_action_err = f"请求继续任务失败: {e}"

            def action_stop():
                try:
                    res = requests.post(f"{API_BASE_URL}/tasks/stop", json={"devices": st.session_state.controlled_devices, "platform": "douyin"}).json()
                    if res.get("success"): st.session_state.last_action_msg = res.get("message")
                    else: st.session_state.last_action_err = res.get("message")
                except Exception as e: st.session_state.last_action_err = f"请求结束任务失败: {e}"

            with col_start:
                st.button("🚀 开始任务", type="primary", use_container_width=True, on_click=action_start)
            with col_pause:
                st.button("⏸️ 暂停任务", use_container_width=True, on_click=action_pause)
            with col_resume:
                st.button("▶️ 继续任务", use_container_width=True, on_click=action_resume)
            with col_stop:
                st.button("🛑 结束任务", use_container_width=True, on_click=action_stop)

            # 显示操作提示信息
            if getattr(st.session_state, "last_action_msg", None):
                st.success(st.session_state.last_action_msg)
                st.session_state.last_action_msg = None
            if getattr(st.session_state, "last_action_err", None):
                st.error(st.session_state.last_action_err)
                st.session_state.last_action_err = None

        st.markdown("---")
        col_log_title, col_log_btn = st.columns([8, 2])
        with col_log_title:
            st.subheader("📝 终端操作日志")
            st.markdown("点击右上角按钮获取最新日志（可通过下方滚动条查看历史记录）")
        with col_log_btn:
            if st.button("🔄 刷新日志", use_container_width=True):
                pass # 按钮点击会触发 rerun，从而重新渲染下面的日志内容

        # 使用自定义 HTML 构建固定高度、可滚动的日志容器
        log_container = st.empty()

        def render_logs():
            try:
                logs_resp = requests.get(f"{API_BASE_URL}/logs").json()
                logs = logs_resp.get("logs", [])
                log_text = "\n".join(logs) if logs else "暂无日志输出..."
            except Exception:
                log_text = "无法连接到后端获取日志..."

            # 组装 HTML
            html_code = f"""
            <div style="
                background-color: #1e1e1e;
                color: #d4d4d4;
                font-family: 'Courier New', Courier, monospace;
                font-size: 14px;
                padding: 15px;
                border-radius: 8px;
                height: 400px;
                overflow-y: auto;
                white-space: pre-wrap;
                word-wrap: break-word;
                line-height: 1.5;
            ">
    {log_text}
            </div>
            """
            log_container.markdown(html_code, unsafe_allow_html=True)

        render_logs()

    # ==========================================
    # 页面 4：数据看板
    # ==========================================
    elif page == "数据看板":
        st.title("📊 获客数据看板")
        st.markdown("实时查看今日的自动化转化漏斗。")

        if st.button("🔄 刷新数据"):
            pass # Streamlit 点击按钮默认会重跑页面

        try:
            resp = requests.get(f"{API_BASE_URL}/stats")
            if resp.status_code == 200:
                stats = resp.json().get("data", {})

                # 使用大指标卡片展示
                col1, col2, col3, col4 = st.columns(4)
                col1.metric("今日处理视频总数", f"{stats.get('videos', 0)} 个", "自动防重过滤")
                col2.metric("自动点赞数", f"{stats.get('likes', 0)} 次", "活跃度提升")
                col3.metric("自动关注同行", f"{stats.get('follows', 0)} 人", "增加曝光")
                col4.metric("AI 自动回复", f"{stats.get('comments', 0)} 次", "标题驱动生成")

                st.markdown("---")
                st.subheader("📋 今日详细操作记录")

                try:
                    details_resp = requests.get(f"{API_BASE_URL}/stats/details?limit=100")
                    if details_resp.status_code == 200 and details_resp.json().get("success"):
                        records = details_resp.json().get("data", [])
                        if records:
                            for idx, record in enumerate(records, start=1):
                                liked_text = "✅ 已点赞" if record.get("liked") else "❌ 未点赞"
                                commented_text = "✅ 已回复" if record.get("commented") else "❌ 未回复"
                                followed_text = "✅ 已关注" if record.get("followed") else "❌ 未关注"
                                title_text = record.get("note_title") or "未抓取到标题"
                                reply_text = record.get("ai_reply") or "本条内容暂无可展示的 AI 回复内容"
                                header = f"{idx}. {title_text[:28]}{'...' if len(title_text) > 28 else ''}"

                                with st.expander(header, expanded=(idx == 1)):
                                    meta_cols = st.columns(4)
                                    meta_cols[0].markdown(f"**时间**：{record.get('created_at', '-')}")
                                    meta_cols[1].markdown(f"**关键词**：{record.get('keyword', '-') or '-'}")
                                    meta_cols[2].markdown(f"**标识**：`{record.get('video_id', '-')}`")
                                    if record.get("url"):
                                        meta_cols[3].markdown(f"**链接**：[打开原内容]({record.get('url')})")
                                    else:
                                        meta_cols[3].markdown("**链接**：-")

                                    st.markdown(f"**互动状态**：{liked_text} | {commented_text} | {followed_text}")
                                    st.markdown("**内容标题**")
                                    st.text_area(
                                        f"title_{idx}",
                                        value=title_text,
                                        height=80,
                                        disabled=True,
                                        label_visibility="collapsed"
                                    )
                                    st.markdown("**AI 生成回复**")
                                    st.text_area(
                                        f"reply_{idx}",
                                        value=reply_text,
                                        height=120,
                                        disabled=True,
                                        label_visibility="collapsed"
                                    )
                        else:
                            st.info("今日暂无操作记录。")
                    else:
                        st.error("获取详细记录失败。")
                except Exception as e:
                    st.error(f"加载详细记录出错: {e}")

                st.markdown("---")
                st.info("💡 提示：所有的详细操作记录已保存在后端的 SQLite 数据库 `data/scout_records.db` 以及 `logs` 文件夹中。")

            else:
                st.error("获取数据失败。")
        except Exception as e:
            st.error(f"后端连接失败: {e}")
