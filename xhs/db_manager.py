import sqlite3
import os
import datetime
import logging

logger = logging.getLogger(__name__)

class DBManager:
    """
    SQLite 数据库管理器
    负责管理按天建表，并记录每天处理的视频数量、点赞、评论和关注等数据。
    """
    def __init__(self):
        # 确定数据库存储路径
        project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.db_dir = os.path.join(project_root, "data")
        os.makedirs(self.db_dir, exist_ok=True)
        
        self.db_path = os.path.join(self.db_dir, "scout_records.db")
        self._init_daily_table()
        self._cleanup_legacy_audit_columns()

    def _get_daily_table_name(self):
        """获取当天的表名，格式：records_YYYYMMDD"""
        today_str = datetime.datetime.now().strftime("%Y%m%d")
        return f"records_{today_str}"

    def _init_daily_table(self):
        """初始化当天的统计表以及小红书专用的临时缓存表"""
        table_name = self._get_daily_table_name()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                # 创建每天的记录表
                cursor.execute(f'''
                    CREATE TABLE IF NOT EXISTS {table_name} (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        video_id TEXT NOT NULL,
                        keyword TEXT,
                        note_title TEXT DEFAULT '',
                        ai_reply TEXT DEFAULT '',
                        url TEXT,
                        liked INTEGER DEFAULT 0,
                        commented INTEGER DEFAULT 0,
                        followed INTEGER DEFAULT 0,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                ''')
                # 为 video_id 创建索引，加速查询
                cursor.execute(f'''
                    CREATE INDEX IF NOT EXISTS idx_{table_name}_video_id 
                    ON {table_name} (video_id)
                ''')
                self._ensure_record_columns(cursor, table_name)
                
                # 创建小红书专用的当前页内容缓存表 (每次刷新时清空或覆盖)
                cursor.execute('''
                    CREATE TABLE IF NOT EXISTS xhs_page_cache (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        title TEXT NOT NULL,
                        bounds_left INTEGER,
                        bounds_top INTEGER,
                        bounds_right INTEGER,
                        bounds_bottom INTEGER,
                        is_processed INTEGER DEFAULT 0,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                ''')
                
                conn.commit()
            # logger.info(f"已连接数据库并校验当日数据表: {table_name} 以及临时缓存表")
        except Exception as e:
            logger.error(f"初始化数据库表失败: {e}")

    def _ensure_record_columns(self, cursor, table_name):
        """为历史表补齐新增字段，避免旧库升级后读写失败。"""
        cursor.execute(f"PRAGMA table_info({table_name})")
        existing_columns = {row[1] for row in cursor.fetchall()}

        if "note_title" not in existing_columns:
            cursor.execute(f"ALTER TABLE {table_name} ADD COLUMN note_title TEXT DEFAULT ''")
        if "ai_reply" not in existing_columns:
            cursor.execute(f"ALTER TABLE {table_name} ADD COLUMN ai_reply TEXT DEFAULT ''")

    def _ensure_table(self):
        """确保执行操作前当天的表存在（应对跨天运行的情况）"""
        self._init_daily_table()
        return self._get_daily_table_name()

    def _cleanup_legacy_audit_columns(self):
        """清理历史记录表中的旧审核字段，保留现有业务数据。"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(
                    "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'records_%'"
                )
                table_names = [row[0] for row in cursor.fetchall()]
                for table_name in table_names:
                    self._migrate_record_table_without_audit_columns(cursor, table_name)
                conn.commit()
        except Exception as e:
            logger.error(f"清理旧审核字段失败: {e}")

    def _migrate_record_table_without_audit_columns(self, cursor, table_name):
        cursor.execute(f"PRAGMA table_info({table_name})")
        existing_columns = [row[1] for row in cursor.fetchall()]
        if "audit_status" not in existing_columns and "audit_reason" not in existing_columns:
            return

        migration_table = f"{table_name}_migration"
        cursor.execute(f"DROP TABLE IF EXISTS {migration_table}")
        cursor.execute(f'''
            CREATE TABLE {migration_table} (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                video_id TEXT NOT NULL,
                keyword TEXT,
                note_title TEXT DEFAULT '',
                ai_reply TEXT DEFAULT '',
                url TEXT,
                liked INTEGER DEFAULT 0,
                commented INTEGER DEFAULT 0,
                followed INTEGER DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        cursor.execute(f'''
            INSERT INTO {migration_table} (
                id, video_id, keyword, note_title, ai_reply,
                url, liked, commented, followed, created_at
            )
            SELECT
                id,
                video_id,
                keyword,
                COALESCE(note_title, ''),
                COALESCE(ai_reply, ''),
                url,
                COALESCE(liked, 0),
                COALESCE(commented, 0),
                COALESCE(followed, 0),
                created_at
            FROM {table_name}
        ''')
        cursor.execute(f"DROP TABLE {table_name}")
        cursor.execute(f"ALTER TABLE {migration_table} RENAME TO {table_name}")
        cursor.execute(
            f"CREATE INDEX IF NOT EXISTS idx_{table_name}_video_id ON {table_name} (video_id)"
        )
        logger.info(f"已清理历史表中的旧审核字段: {table_name}")

    def record_video(self, video_id, keyword, url="", note_title=""):
        """
        记录一个新视频
        返回 True 表示是新视频并成功插入，返回 False 表示今天已经处理过该视频
        """
        table_name = self._ensure_table()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                # 检查是否已存在
                cursor.execute(f"SELECT id FROM {table_name} WHERE video_id = ?", (video_id,))
                if cursor.fetchone():
                    return False
                
                # 插入新记录
                cursor.execute(f'''
                    INSERT INTO {table_name} (video_id, keyword, note_title, url)
                    VALUES (?, ?, ?, ?)
                ''', (video_id, keyword, note_title, url))
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"记录视频失败: {e}")
            return False

    def save_ai_reply(self, video_id, note_title="", ai_reply=""):
        """保存标题和 AI 回复，便于数据看板展示。"""
        table_name = self._ensure_table()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(f'''
                    UPDATE {table_name}
                    SET note_title = COALESCE(NULLIF(?, ''), note_title),
                        ai_reply = COALESCE(NULLIF(?, ''), ai_reply)
                    WHERE video_id = ?
                ''', (note_title, ai_reply, video_id))
                conn.commit()
                return cursor.rowcount > 0
        except Exception as e:
            logger.error(f"保存标题与 AI 回复失败: {e}")
            return False

    def update_interaction(self, video_id, action_type):
        """
        更新视频的互动状态
        :param action_type: 'like', 'comment', 'follow'
        """
        if action_type not in ('like', 'comment', 'follow'):
            logger.warning(f"未知的互动类型: {action_type}")
            return False
            
        table_name = self._ensure_table()
        field_map = {
            'like': 'liked',
            'comment': 'commented',
            'follow': 'followed'
        }
        field_name = field_map[action_type]
        
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(f'''
                    UPDATE {table_name} 
                    SET {field_name} = 1 
                    WHERE video_id = ?
                ''', (video_id,))
                conn.commit()
                return cursor.rowcount > 0
        except Exception as e:
            logger.error(f"更新视频互动状态 [{action_type}] 失败: {e}")
            return False

    def get_daily_stats(self):
        """获取当天的汇总统计数据"""
        table_name = self._ensure_table()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(f'''
                    SELECT 
                        COUNT(*) as total_videos,
                        SUM(liked) as total_likes,
                        SUM(commented) as total_comments,
                        SUM(followed) as total_follows
                    FROM {table_name}
                ''')
                row = cursor.fetchone()
                return {
                    "videos": row[0] or 0,
                    "likes": row[1] or 0,
                    "comments": row[2] or 0,
                    "follows": row[3] or 0
                }
        except Exception as e:
            logger.error(f"获取当天统计数据失败: {e}")
            return {"videos": 0, "likes": 0, "comments": 0, "follows": 0}

    def get_daily_records(self, limit=100):
        """获取当天的详细操作记录，按时间倒序排列"""
        table_name = self._ensure_table()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(f'''
                    SELECT 
                        video_id, keyword, note_title, ai_reply, url, liked, commented, followed, created_at 
                    FROM {table_name}
                    ORDER BY created_at DESC
                    LIMIT ?
                ''', (limit,))
                rows = cursor.fetchall()
                records = []
                for row in rows:
                    records.append({
                        "video_id": row[0],
                        "keyword": row[1],
                        "note_title": row[2] or "",
                        "ai_reply": row[3] or "",
                        "url": row[4],
                        "liked": bool(row[5]),
                        "commented": bool(row[6]),
                        "followed": bool(row[7]),
                        "created_at": row[8]
                    })
                return records
        except Exception as e:
            logger.error(f"获取当天详细记录失败: {e}")
            return []

    def clear_daily_records(self):
        """清空当天的处理记录，让每日统计从 0 开始重新累计"""
        table_name = self._ensure_table()
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute(f"DELETE FROM {table_name}")
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"清空当天处理记录失败: {e}")
            return False

    def reset_daily_progress(self):
        """重置当天统计，并清空当前页待处理缓存。"""
        records_cleared = self.clear_daily_records()
        cache_cleared = self.clear_page_cache()
        return records_cleared and cache_cleared

    # ==========================================
    # 小红书双列瀑布流专用：临时缓存表管理
    # ==========================================
    def clear_page_cache(self):
        """清空当前页的内容缓存"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute("DELETE FROM xhs_page_cache")
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"清空页面缓存失败: {e}")
            return False

    def save_page_items(self, items):
        """
        保存当前页抓取到的内容列表
        :param items: list of dict, [{'title': '...', 'bounds': {'left': 0, 'top': 0, 'right': 0, 'bottom': 0}}]
        """
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                for item in items:
                    b = item.get('bounds', {})
                    cursor.execute('''
                        INSERT INTO xhs_page_cache (title, bounds_left, bounds_top, bounds_right, bounds_bottom)
                        VALUES (?, ?, ?, ?, ?)
                    ''', (
                        item.get('title', ''),
                        b.get('left', 0),
                        b.get('top', 0),
                        b.get('right', 0),
                        b.get('bottom', 0)
                    ))
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"保存页面缓存失败: {e}")
            return False

    def save_single_page_item(self, title, bounds, processed=False):
        """保存单个笔记并标记状态"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute('''
                    INSERT INTO xhs_page_cache (title, bounds_left, bounds_top, bounds_right, bounds_bottom, is_processed)
                    VALUES (?, ?, ?, ?, ?, ?)
                ''', (
                    title,
                    bounds.get('left', 0),
                    bounds.get('top', 0),
                    bounds.get('right', 0),
                    bounds.get('bottom', 0),
                    1 if processed else 0
                ))
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"保存单条页面缓存失败: {e}")
            return False

    def is_item_processed_by_title(self, title):
        """根据标题判断该笔记是否已经点击过"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute('''
                    SELECT id FROM xhs_page_cache 
                    WHERE title = ? AND is_processed = 1
                ''', (title,))
                if cursor.fetchone():
                    return True
                return False
        except Exception as e:
            logger.error(f"查询页面缓存状态失败: {e}")
            return False

    def get_unprocessed_page_items(self):
        """获取当前页缓存中未处理过的内容。"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute('''
                    SELECT id, title, bounds_left, bounds_top, bounds_right, bounds_bottom
                    FROM xhs_page_cache
                    WHERE is_processed = 0
                    ORDER BY id ASC
                ''')
                rows = cursor.fetchall()
                items = []
                for row in rows:
                    items.append({
                        "id": row[0],
                        "title": row[1],
                        "bounds": {
                            "left": row[2],
                            "top": row[3],
                            "right": row[4],
                            "bottom": row[5]
                        }
                    })
                return items
        except Exception as e:
            logger.error(f"获取未处理页面缓存失败: {e}")
            return []

    def mark_item_processed(self, item_id):
        """标记某个缓存项为已处理"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                cursor = conn.cursor()
                cursor.execute("UPDATE xhs_page_cache SET is_processed = 1 WHERE id = ?", (item_id,))
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"标记页面缓存处理状态失败: {e}")
            return False
