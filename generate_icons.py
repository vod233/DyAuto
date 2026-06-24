import urllib.request
import json
import os
import sys
from PIL import Image
from io import BytesIO

def generate_icon(prompt, size, output_path):
    url = f"https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt={urllib.parse.quote(prompt)}&image_size=square_hd"
    print(f"Generating {size}x{size} icon...")
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req, timeout=60) as resp:
        img_data = resp.read()
    
    img = Image.open(BytesIO(img_data))
    img = img.resize((size, size), Image.LANCZOS)
    img.save(output_path, "PNG")
    print(f"  Saved to {output_path}")

prompt = "Tech flat style app icon, minimalist robot head inside chat bubble, bar chart growth with upward arrow, blue to purple gradient, clean geometric design, square with smooth rounded corners, white background, high quality, professional UI design"

base_dir = r"d:\CodingTest\111\SocialAutoAgent-main\apk_tools\decoded\res"

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

for folder, size in sizes.items():
    folder_path = os.path.join(base_dir, folder)
    os.makedirs(folder_path, exist_ok=True)
    output_path = os.path.join(folder_path, "ic_launcher.png")
    generate_icon(prompt, size, output_path)

print("\nAll icons generated!")
