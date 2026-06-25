"""
全面 review APK 修改状态
"""
import os
import hashlib
import zipfile

DECODED_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'decoded', 'res')
TECH_APK = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'app-uiautomator-tech.apk')
BACKUP_APK = r'C:\Users\abc\AppData\Local\Programs\Python\Python312\Lib\site-packages\uiautomator2\assets\app-uiautomator.apk.bak'
LIB_APK = r'C:\Users\abc\AppData\Local\Programs\Python\Python312\Lib\site-packages\uiautomator2\assets\app-uiautomator.apk'
SRC_IMG = r'D:\Data\photo\9f466ee9-1e13-46b7-a9fe-2757c2211e33.png'


def md5(path):
    h = hashlib.md5()
    with open(path, 'rb') as f:
        h.update(f.read())
    return h.hexdigest()


def section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")


# 1. 检查 APK 文件
section("1. APK 文件状态")
print(f"科技风APK存在: {os.path.exists(TECH_APK)}")
if os.path.exists(TECH_APK):
    print(f"  大小: {os.path.getsize(TECH_APK):,} bytes")
print(f"库APK存在: {os.path.exists(LIB_APK)}")
if os.path.exists(LIB_APK):
    print(f"  大小: {os.path.getsize(LIB_APK):,} bytes")
print(f"备份APK存在: {os.path.exists(BACKUP_APK)}")
if os.path.exists(BACKUP_APK):
    print(f"  大小: {os.path.getsize(BACKUP_APK):,} bytes")

if os.path.exists(TECH_APK) and os.path.exists(LIB_APK):
    match = md5(TECH_APK) == md5(LIB_APK)
    print(f"  库APK与科技风APK MD5匹配: {match}")

# 2. 检查 APK 内图标
section("2. APK 内图标文件")
if os.path.exists(TECH_APK):
    with zipfile.ZipFile(TECH_APK, 'r') as z:
        for name in sorted(z.namelist()):
            if 'ic_launcher' in name and 'mipmap' in name:
                info = z.getinfo(name)
                print(f"  {name}: {info.file_size:,} bytes")
        print()
        for name in sorted(z.namelist()):
            if 'ic_notification' in name and 'drawable' in name:
                info = z.getinfo(name)
                print(f"  {name}: {info.file_size:,} bytes")

# 3. 检查 APK 内 strings.xml 中的 app_name
section("3. 应用名称检查")
if os.path.exists(TECH_APK):
    with zipfile.ZipFile(TECH_APK, 'r') as z:
        for name in z.namelist():
            if name == 'resources.arsc':
                # 无法直接读取二进制 resources.arsc
                pass
        # 检查 AndroidManifest
        manifest = z.read('AndroidManifest.xml')
        # 二进制 XML 无法直接解析，检查是否有 label 引用
        print(f"  AndroidManifest.xml 大小: {len(manifest)} bytes (二进制格式)")

# 4. 检查源文件中的修改
section("4. 源文件修改检查")

# strings.xml
strings_path = os.path.join(DECODED_DIR, 'values', 'strings.xml')
if os.path.exists(strings_path):
    with open(strings_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if '聚兴助手' in content:
        print(f"  strings.xml: app_name = '聚兴助手' ✓")
    elif 'ATX' in content:
        print(f"  strings.xml: app_name 仍为 'ATX' ✗")
    else:
        # 搜索 app_name 行
        for line in content.split('\n'):
            if 'app_name' in line:
                print(f"  strings.xml: {line.strip()}")

# AndroidManifest.xml
manifest_path = os.path.join(os.path.dirname(DECODED_DIR), 'AndroidManifest.xml')
if os.path.exists(manifest_path):
    with open(manifest_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if '@mipmap/ic_launcher' in content:
        print(f"  AndroidManifest: icon = @mipmap/ic_launcher ✓")
    elif '@drawable/ic_notification' in content:
        print(f"  AndroidManifest: icon 仍为 @drawable/ic_notification ✗")

# colors.xml
colors_path = os.path.join(DECODED_DIR, 'values', 'colors.xml')
if os.path.exists(colors_path):
    with open(colors_path, 'r', encoding='utf-8') as f:
        content = f.read()
    tech_colors = [l.strip() for l in content.split('\n') if 'tech_' in l]
    print(f"  colors.xml: {len(tech_colors)} 个科技风颜色定义")
    for c in tech_colors[:3]:
        print(f"    {c}")

# styles.xml
styles_path = os.path.join(DECODED_DIR, 'values', 'styles.xml')
if os.path.exists(styles_path):
    with open(styles_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if 'Theme.AppCompat">' in content and 'tech_primary' in content:
        print(f"  styles.xml: AppTheme 已改为科技风深色主题 ✓")
    if 'tech_btn_selector' in content:
        print(f"  styles.xml: SelectButton 使用 tech_btn_selector ✓")

# 5. 检查 drawable 文件
section("5. 科技风 Drawable 文件")
drawable_files = [
    'tech_btn_normal.xml', 'tech_btn_pressed.xml', 'tech_btn_selector.xml',
    'tech_card_bg.xml', 'tech_section_title_bg.xml', 'tech_accent_line.xml'
]
for f in drawable_files:
    path = os.path.join(DECODED_DIR, 'drawable', f)
    exists = os.path.exists(path)
    print(f"  drawable/{f}: {'✓' if exists else '✗'}")

# 6. 检查布局文件
section("6. 布局文件")
layout_path = os.path.join(DECODED_DIR, 'layout', 'activity_main.xml')
if os.path.exists(layout_path):
    with open(layout_path, 'r', encoding='utf-8') as f:
        content = f.read()
    if 'tech_card_bg' in content:
        print(f"  activity_main.xml: 使用卡片式布局 ✓")
    if 'tech_section_title_bg' in content:
        print(f"  activity_main.xml: 使用科技风标题栏 ✓")
    if 'ScrollView' in content:
        print(f"  activity_main.xml: ScrollView 布局 ✓")
    # 检查关键 ID 是否保留
    ids = ['uiautomator_status', 'uiautomator_mode', 'development_settings',
           'accessibility', 'btn_identify', 'btn_finish', 'in_storage',
           'ip_address', 'app_version']
    missing_ids = [id for id in ids if id not in content]
    if missing_ids:
        print(f"  activity_main.xml: 缺少ID: {missing_ids} ✗")
    else:
        print(f"  activity_main.xml: 所有关键ID保留 ✓")

# 7. 检查图标源文件
section("7. 图标源文件")
from PIL import Image
src = Image.open(SRC_IMG)
print(f"  源图片: {src.size} {src.mode}")

mipmap_sizes = {
    'mipmap-mdpi': 48, 'mipmap-hdpi': 72, 'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144, 'mipmap-xxxhdpi': 192
}
for dir_name, expected_size in mipmap_sizes.items():
    path = os.path.join(DECODED_DIR, dir_name, 'ic_launcher.png')
    if os.path.exists(path):
        img = Image.open(path)
        match = img.size == (expected_size, expected_size)
        print(f"  {dir_name}/ic_launcher.png: {img.size} {'✓' if match else '✗ 尺寸错误'}")
    else:
        print(f"  {dir_name}/ic_launcher.png: 不存在 ✗")

# 8. 签名验证
section("8. APK 签名验证")
import subprocess
result = subprocess.run(
    ['java', '-jar', r'D:\AndroidSDK\build-tools\33.0.1\lib\apksigner.jar', 'verify', '--verbose', TECH_APK],
    capture_output=True, text=True
)
print(result.stdout.strip() if result.stdout else result.stderr.strip())

print(f"\n{'='*60}")
print("  Review 完成")
print(f"{'='*60}")
