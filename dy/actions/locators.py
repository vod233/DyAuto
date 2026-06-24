class TikTokLocators:
    # ==========================================
    # 1. 首页与搜索 (Search & Navigation)
    # ==========================================
    HOME_TAB_TEXT = "首页"
    SEARCH_BTN_DESC = '//*[@content-desc="搜索"]'
    SEARCH_BTN_ID = "com.ss.android.ugc.aweme:id/ki0"
    SEARCH_BTN_DESC_FALLBACK = "搜索"
    SEARCH_CONFIRM_BTN = '//*[@text="搜索"]'
    VIDEO_TAB = '//*[@text="视频"]'
    YOUTH_MODE_CLOSE_TEXT = "我知道了"
    
    # ==========================================
    # 2. 筛选面板 (Filters)
    # ==========================================
    FILTER_PANEL_BTN = '//*[@content-desc="筛选，按钮"]'
    FILTER_UNSEEN_BTN = '//*[@text="还未看过"]'
    FILTER_SORT_PANEL_INDICATOR = '//*[@text="还未看过" or @text="排序方式"]'
    
    # ==========================================
    # 3. 视频列表与特征 (Video List)
    # ==========================================
    VIDEO_DESC_TEXT_VIEW = "//android.widget.TextView"  # 模糊匹配用
    
    # ==========================================
    # 4. 视频级互动 (Video Interaction)
    # ==========================================
    PROFILE_FOLLOW_BTN = "关注"
    SHARE_BTN_DYNAMIC = '//*[starts-with(@content-desc, "分享") and contains(@content-desc, "按钮")]'
    SHARE_PANEL_CONTAINER = "com.ss.android.ugc.aweme:id/function_container"
    COPY_LINK_BTN = '//*[@text="分享链接" or @text="复制链接"]'
    
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
    COMMENT_EDIT_TEXT_XPATH = "//android.widget.EditText"
    COMMENT_SEND_BTN_ID = "com.ss.android.ugc.aweme:id/ero"
    COMMENT_SEND_BTN_IDS = (
        "com.ss.android.ugc.aweme:id/ero",
        "com.ss.android.ugc.aweme:id/btn_send",
        "com.ss.android.ugc.aweme:id/jc=",
        "com.ss.android.ugc.aweme:id/d_3",
        "com.ss.android.ugc.aweme:id/d_4",
    )
    COMMENT_SEND_BTN_TEXT = "发送"
    COMMENT_SEND_BTN_XPATH = '//*[@text="发送" or @content-desc="发送" or contains(@content-desc, "发送")]'
    COMMENT_TEXT_XPATH = "//android.widget.TextView"
    
    # ==========================================
    # 8. 私信功能 (Private Message)
    # ==========================================
    PM_BTN_DESC = '//*[contains(@content-desc, "私信")]'
    PM_BTN_TEXT = "私信"
    PM_EDIT_TEXT_CLASS = "android.widget.EditText"
    PM_SEND_BTN_IDS = (
        "com.ss.android.ugc.aweme:id/btn_send",
        "com.ss.android.ugc.aweme:id/ero",
        "com.ss.android.ugc.aweme:id/jc=",
    )
    PM_SEND_BTN_ID = PM_SEND_BTN_IDS[0]
    PM_SEND_BTN_XPATH = '//*[@text="发送" or @content-desc="发送" or contains(@content-desc, "发送")]'
    PM_CLICKABLE_XPATH = '//*[@clickable="true"]'
    PM_MESSAGE_TEXT_XPATH = "//android.widget.TextView"
