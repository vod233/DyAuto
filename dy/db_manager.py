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

    def _get_daily_table_name(self):
        """获取当天的表名，格式：records_YYYYMMDD"""
        today_str = datetime.datetime.now().strftime("%Y%m%d")
        return f"records_{today_str}"

    def _init_daily_table(self):
        """初始化当天的统计表"""
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
                conn.commit()
            logger.info(f"已连接数据库并校验当日数据表: {table_name}")
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
