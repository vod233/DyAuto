import urllib.request
import os
import sys

url = "https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar"
output = r"d:\CodingTest\111\SocialAutoAgent-main\apk_tools\apktool.jar"

os.makedirs(os.path.dirname(output), exist_ok=True)

def progress(block_num, block_size, total_size):
    downloaded = block_num * block_size
    pct = downloaded * 100 / total_size if total_size > 0 else 0
    mb = downloaded / 1024 / 1024
    total_mb = total_size / 1024 / 1024
    sys.stdout.write(f"\rDownloading: {mb:.1f}MB / {total_mb:.1f}MB ({pct:.1f}%)")
    sys.stdout.flush()

print("Downloading apktool.jar...")
urllib.request.urlretrieve(url, output, progress)
print("\nDone!")
print("File size:", os.path.getsize(output), "bytes")
