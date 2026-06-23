<p align="center">
  <h1 align="center">SocialAutoAgent</h1>
  <p align="center">多渠道智能群控 Agent · 小红书 | 抖音 | 快手 | 视频号</p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.11+-blue.svg" alt="Python">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-Windows-lightgrey.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Android-11+-brightgreen.svg" alt="Android">
</p>

---

## 项目简介

**SocialAutoAgent** 是一个基于 Python 的多渠道社交媒体智能群控系统，提供前后端分离的 Web 控制台，支持无线 ADB 连接 Android 设备，实现关键词搜索、点赞、收藏、关注、AI 评论生成、评论区截流等全自动互动操作。

### 支持平台

| 平台 | 状态 | 核心能力 |
|------|------|----------|
| 小红书 (XHS) | 已上线 | OpenCV 爱心识别、AI 智能评论、全自动互动 |
| 抖音 (Douyin) | 已上线 | 视频滑动、评论区截流、关键词拦截回复 |
| 快手 (Kuaishou) | 开发中 | — |
| 视频号 (Shipinhao) | 开发中 | — |

## 核心功能

- **无线群控连接** — 内置 ADB 无线配对模块，支持纯 WiFi 局域网批量连接 Android 设备，无需 USB 线缆
- **可视化任务调度** — Web 控制台支持多设备并行任务的启动、暂停、继续、终止，实时掌控运行状态
- **全自动互动引擎** — 按关键词搜索内容 → 自动进入内容页 → 执行关注、点赞、收藏、评论全流程
- **AI 智能评论** (小红书) — 基于 LangChain 对接大模型（阿里云百炼/OpenAI 兼容接口），根据内容标题生成自然合规评论
- **评论区截流** (抖音) — 模拟真人滑动评论区，命中目标关键词后自动回复，精准截取潜在客户
- **实时数据看板** — SQLite 持久化存储，交互式表格展示每日处理量、互动数据漏斗
- **虚拟终端日志** — Web 端实时同步底层运行日志，方便调试和监控

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Streamlit |
| 后端 | FastAPI + Pydantic + uvicorn |
| 自动化 | UIAutomator2 + adbutils |
| 图像识别 | OpenCV + NumPy |
| AI 对话 | LangChain + langchain-openai |
| 数据存储 | SQLite3 |
| 配置管理 | PyYAML + python-dotenv |

## 自动化流程

```
关键词搜索 → 内容列表识别(爱心/视频) → 进入内容页
    → 提取标题/链接 → 关注 → 点赞 → 收藏
    → AI生成评论/固定话术 → 发布评论
    → 抖音额外: 评论区滑动 → 关键词拦截 → 自动回复
    → 记录落库(SQLite) → 翻页/下一关键词
```

## 环境要求

- **操作系统**: Windows 10+
- **Python**: 3.11+
- **Android 设备**: Android 11+，已开启开发者选项及无线调试
- **网络**: 电脑与手机在同一局域网

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/your-username/SocialAutoAgent.git
cd SocialAutoAgent
```

### 2. 创建虚拟环境

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

> **注意**: 如遇到 `opencv-python` 与 `numpy` ABI 冲突，`requirements.txt` 已限制 `numpy<2`。

### 3. 配置 API 密钥

```powershell
# 复制环境变量模板
copy .env.example .env

# 编辑 .env 文件，填入你的阿里云百炼 API Key
# DASHSCOPE_API_KEY=你的密钥
```

获取 API Key: [阿里云百炼控制台](https://dashscope.console.aliyun.com/apiKey)

> 也可以在前端 Web 控制台的「规则设置」页面直接填写 API 配置（会写入 `xhs/config/api_settings.yaml`），但推荐使用 `.env` 方式避免密钥泄漏。

### 4. 启动服务

项目需要同时启动后端和前端两个服务。

**终端 1 — 启动后端 (FastAPI)**

```powershell
.\.venv\Scripts\Activate.ps1
python backend/main.py
```

后端地址: http://127.0.0.1:8000 | API 文档: http://127.0.0.1:8000/docs

**终端 2 — 启动前端 (Streamlit)**

```powershell
.\.venv\Scripts\Activate.ps1
streamlit run frontend/app.py
```

前端地址: http://localhost:8501

### 5. 使用步骤

1. 打开前端，进入 **设备管理** 页面
2. 通过无线调试配对连接 Android 手机（确保手机已开启无线调试）
3. 勾选要控制的设备
4. 进入 **规则设置**，配置搜索关键词、每日处理上限、AI 参数
5. 进入 **流程控制**，点击启动任务
6. 在 **数据看板** 查看实时统计

## AI 配置说明

项目使用 LangChain 对接 OpenAI 兼容接口，默认配置为阿里云百炼（DashScope）。

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `DASHSCOPE_BASE_URL` | `https://dashscope.aliyuncs.com/compatible-mode/v1` | API 地址 |
| `DASHSCOPE_MODEL` | `qwen3.5-flash` | 模型名称 |
| `DASHSCOPE_API_KEY` | — | API 密钥（必填） |

其他兼容的 API 提供商（如 OpenAI、DeepSeek 等）也可使用，只需修改对应的 `base_url` 和 `model` 即可。

## 目录结构

```text
SocialAutoAgent/
├── backend/                    # FastAPI 后端
│   ├── main.py                 # 入口: 设备管理、配置CRUD、任务调度、日志统计
│   └── schemas.py              # Pydantic 数据模型
├── frontend/                   # Streamlit 前端
│   ├── app.py                  # 主入口: 多平台路由
│   ├── xhs/xhs_app.py          # 小红书控制页
│   └── douyin/douyin_app.py    # 抖音控制页
├── xhs/                        # 小红书自动化引擎
│   ├── task_runner.py          # 业务流程编排
│   ├── main_controller.py      # 单设备控制器
│   ├── ai_reply_agent.py       # AI 评论生成 (LangChain)
│   ├── db_manager.py           # SQLite 数据管理
│   ├── multi_device.py         # 多设备发现
│   ├── actions/                # 原子动作 (导航/交互/定位)
│   ├── core/                   # 设备 & 应用管理
│   ├── config/                 # YAML 配置文件
│   └── assets/                 # 图像模板 (爱心识别)
├── dy/                         # 抖音自动化引擎 (结构同上)
├── .env.example                # 环境变量模板
├── .gitignore                  # Git 忽略规则
├── requirements.txt            # Python 依赖
└── README.md                   # 项目文档
```

## 命令行工具

| 脚本 | 用途 |
|------|------|
| `start_task.py` | 命令行交互式启动自动化任务 |
| `usb_connect.py` | USB 设备一键检测、授权状态识别、UIAutomator2 连通性检查 |
| `wireless_connect.py` | ADB 无线配对连接助手 |
| `scan_and_connect.py` | 局域网 ADB 设备扫描与自动连接 |
| `test_connection.py` | 测试设备连接和 UIAutomator2 状态 |
| `test_task.py` | 运行测试任务流程 |

## 常见问题

**Q: 前端页面打不开或没有数据？**
- 确认后端已正常启动（检查终端是否有 uvicorn 日志输出）
- 确认前端请求地址正确（默认 `http://127.0.0.1:8000/api`）

**Q: 设备连接失败？**
- 检查手机是否已开启 USB 调试 / 无线调试
- 电脑与手机是否在同一局域网
- 运行 `adb devices` 确认设备是否已识别

**Q: AI 评论调用失败？**
- 确认 `.env` 文件中 `DASHSCOPE_API_KEY` 已正确填写
- 或在 Web 控制台「规则设置」中配置 API Key
- 确认 `langchain-openai` 和 `openai` 已安装

**Q: 爱心识别不准确？**
- 检查 `xhs/assets/tpl_white_heart.png` 是否与设备实际 UI 一致
- 查看 `logs/` 目录下的调试截图 `debug_*.png`
- 根据实际情况微调模板匹配阈值和 HSV 色彩阈值

## 已知说明

- 部分历史类名仍保留 `TikTok` 命名（如 `TikTokTaskFlow`），当前业务已全面转向小红书/抖音
- 已移除旧的审核相关代码，AI 评论生成后直接按规则过滤和发布
- 内容进入逻辑优先依赖页面爱心（点赞图标）识别与缓存坐标顺序点击

## 免责声明

本项目仅供学习 Android 自动化、图像识别、接口联调和本地工具开发使用。使用者须遵守目标平台规则及相关法律法规，**不得用于**违规营销、骚扰、黑灰产或其他不当用途。使用本项目产生的任何后果由使用者自行承担。

---

<p align="center">
  <sub>Made with Python · Streamlit · FastAPI · LangChain · OpenCV</sub>
</p>
