"""
用用户提供的图片生成多分辨率图标，替换 APK 中的所有图标资源
"""
from PIL import Image
import os
import shutil

SRC_IMAGE = r'D:\Data\photo\9f466ee9-1e13-46b7-a9fe-2757c2211e33.png'
DECODED_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'decoded', 'res')

# Android 图标标准分辨率
ICON_SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

# 需要替换的所有图标文件
ICON_FILES = [
    'ic_launcher.png',
    'ic_notification.png',  # 通知栏图标
]

# drawable 目录中的图标
DRAWABLE_DIRS = ['drawable-mdpi', 'drawable-hdpi', 'drawable-xhdpi', 'drawable-xxhdpi', 'drawable-xxxhdpi']
DRAWABLE_SIZES = [48, 72, 96, 144, 192]


def generate_icons():
    src = Image.open(SRC_IMAGE).convert('RGBA')
    print(f'源图片: {src.size} {src.mode}')

    # 1. 替换 mipmap 目录中的 ic_launcher.png
    for dir_name, size in ICON_SIZES.items():
        dir_path = os.path.join(DECODED_DIR, dir_name)
        if not os.path.exists(dir_path):
            os.makedirs(dir_path)
            print(f'  创建目录: {dir_name}')

        # ic_launcher.png
        icon = src.resize((size, size), Image.LANCZOS)
        icon_path = os.path.join(dir_path, 'ic_launcher.png')
        icon.save(icon_path, 'PNG')
        print(f'  {dir_name}/ic_launcher.png -> {size}x{size} ({os.path.getsize(icon_path)} bytes)')

    # 2. 替换 drawable 目录中的 ic_notification.png
    for i, dir_name in enumerate(DRAWABLE_DIRS):
        dir_path = os.path.join(DECODED_DIR, dir_name)
        if not os.path.exists(dir_path):
            continue

        size = DRAWABLE_SIZES[i]
        # ic_notification.png
        notif_path = os.path.join(dir_path, 'ic_notification.png')
        if os.path.exists(notif_path):
            icon = src.resize((size, size), Image.LANCZOS)
            icon.save(notif_path, 'PNG')
            print(f'  {dir_name}/ic_notification.png -> {size}x{size}')

    # 3. 替换 drawable 目录中的 icon.png (通用图标)
    icon_path = os.path.join(DECODED_DIR, 'drawable', 'icon.png')
    if os.path.exists(icon_path):
        icon = src.resize((96, 96), Image.LANCZOS)
        icon.save(icon_path, 'PNG')
        print(f'  drawable/icon.png -> 96x96')

    print('\n所有图标替换完成!')


if __name__ == '__main__':
    generate_icons()
