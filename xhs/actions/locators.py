class XHSLocators:
    # ==========================================
    # 1. 首页与搜索 (Search & Navigation)
    # ==========================================
    HOME_TAB_TEXT = "首页"
    # 小红书首页右上角搜索放大镜
    SEARCH_BTN_DESC = '//*[@content-desc="搜索"]'
    SEARCH_BTN_ID = "com.xingin.xhs:id/ey5" # 此为示例，后续如果定位不到可依赖 xpath/desc 兜底
    SEARCH_BTN_DESC_FALLBACK = "搜索"
    SEARCH_CONFIRM_BTN = '//*[@text="搜索"]'
    
    # 搜索结果页顶部的分类页签 (默认是综合，我们要点最新)
    TAB_COMPREHENSIVE = '//*[@text="综合"]'
    TAB_LATEST = '//*[@text="最新"]'
    
    YOUTH_MODE_CLOSE_TEXT = "我知道了"
    
    # ==========================================
    # 2. 筛选面板 (Filters)
    # ==========================================
    FILTER_PANEL_BTN = '//*[@content-desc="筛选，按钮"]'
    FILTER_UNSEEN_BTN = '//*[@text="还未看过"]'
    FILTER_SORT_PANEL_INDICATOR = '//*[@text="还未看过" or @text="排序方式"]'
    
    # ==========================================
    # 3. 视频列表与特征 (Video/Note List)
    # ==========================================
    # 小红书瀑布流的双行文字标题，常通过特定的 Resource ID 或者 maxLines 特征定位
    # 这里的 TextView 通常用于展示笔记标题，有一定字数限制并支持换行
    NOTE_TITLE_ID = "com.xingin.xhs:id/g65" # 示例 ID，可能随版本变化
    NOTE_TITLE_XPATH = '//android.widget.TextView[string-length(@text)>7]' # 兜底 XPath，寻找文本长度大于7的 TextView
    
    # ==========================================
    # 4. 内容级互动 (Note Interaction)
    # ==========================================
    # --- 小红书专用 ---
    # 右上角关注按钮
    XHS_FOLLOW_BTN_TEXT = "关注"
    
    # 右上角分享按钮 (转发小箭头)
    XHS_SHARE_BTN_DESC = '//*[contains(@content-desc, "分享") or contains(@content-desc, "转发")]'
    XHS_COPY_LINK_TEXT = "复制链接"
    XHS_COPY_LINK_CANDIDATES = ("复制链接", "复制口令", "复制文案", "复制")
    XHS_COPY_LINK_XPATH = (
        '//*[contains(@text, "复制链接") or contains(@text, "复制口令") or '
        'contains(@text, "复制文案") or @text="复制" or '
        'contains(@content-desc, "复制链接") or contains(@content-desc, "复制口令") or '
        'contains(@content-desc, "复制文案") or @content-desc="复制"]'
    )
    
    # 底部互动栏
    # 收藏 (五角星)
    XHS_COLLECT_BTN_DESC = '//*[contains(@content-desc, "收藏")]'
    # 评论
    XHS_COMMENT_BTN_DESC = '//*[contains(@content-desc, "评论")]'
    XHS_COMMENT_INPUT_CLASS = "android.widget.EditText"
    XHS_COMMENT_SEND_BTN_TEXT = "发送"
    
    
    
    # ==========================================
    # 5. 评论区主入口 (Comment Section Entry)
    # ==========================================
    # 通过 content-desc 规律寻找主评论区按钮
    COMMENT_BTN_DYNAMIC = '//*[contains(@content-desc, "评论") and contains(@content-desc, "按钮")]'
    COMMENT_BTN_FALLBACK = '//*[contains(@content-desc, "评论") or contains(@text, "评论")]'
    COMMENT_INPUT_HINT_1 = "发条评论"
    COMMENT_INPUT_HINT_2 = "说说你的感受"
    COMMENT_INPUT_HINT_3 = "留下你的精彩评论"
    COMMENT_INPUT_HINT_4 = "评论"
    
    # ==========================================
    # 6. 评论列表与卡片解析 (Comment Cards)
    # ==========================================
    COMMENT_LIST_CONTAINER = "com.ss.android.ugc.aweme:id/rlp"
    COMMENT_NO_MORE_TEXT = '//*[@text="暂时没有更多了"]'
    
    # Compose 架构节点 (class_name == "androidx.compose.ui.platform.ComposeView")
    COMPOSE_TEXT_CLASS = "android.widget.TextView"
    
    # 原生 Android 架构节点 (FrameLayout / ViewGroup)
    NATIVE_TITLE_ID = "com.ss.android.ugc.aweme:id/title"
    NATIVE_CONTENT_ID = "com.ss.android.ugc.aweme:id/content"
    NATIVE_TIME_IP_ID = "com.ss.android.ugc.aweme:id/f_n"
    
    # ==========================================
    # 7. 评论发送 (Post Comment)
    # ==========================================
    COMMENT_EDIT_TEXT_CLASS = "android.widget.EditText"
    COMMENT_SEND_BTN_ID = "com.ss.android.ugc.aweme:id/ero"
    COMMENT_SEND_BTN_TEXT = "发送"
    COMMENT_SEND_BTN_XPATH = '//*[@text="发送" or @content-desc="发送"]'
