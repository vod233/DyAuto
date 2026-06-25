from PIL import Image
import os

img_path = r'D:\Data\photo\9f466ee9-1e13-46b7-a9fe-2757c2211e33.png'
img = Image.open(img_path)
print(f'尺寸: {img.size}, 模式: {img.mode}, 格式: {img.format}')
print(f'文件大小: {os.path.getsize(img_path)} bytes')
