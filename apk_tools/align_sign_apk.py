"""
Align and sign the customized uiautomator APK.

Android 11+ rejects targetSdk >= 30 APKs when resources.arsc is stored
uncompressed but not aligned on a 4-byte boundary. The required order is:
unsigned APK -> zipalign -> apksigner -> zipalign check.
"""
import os
import shutil
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BUILD_TOOLS = Path(os.environ.get("ANDROID_BUILD_TOOLS", r"D:\AndroidSDK\build-tools\33.0.1"))
ZIPALIGN = BUILD_TOOLS / "zipalign.exe"
APKSIGNER = BUILD_TOOLS / "apksigner.bat"
KEYSTORE = ROOT / "debug.keystore"
UNSIGNED_APK = ROOT / "app-uiautomator-tech-unsigned.apk"
ALIGNED_APK = ROOT / "app-uiautomator-tech-aligned.apk"
SIGNED_APK = ROOT / "app-uiautomator-tech.apk"


def run(cmd):
    print(" ".join(str(part) for part in cmd))
    result = subprocess.run(cmd, text=True, capture_output=True)
    if result.stdout:
        print(result.stdout.strip())
    if result.stderr:
        print(result.stderr.strip())
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def main():
    for path in (ZIPALIGN, APKSIGNER, KEYSTORE, UNSIGNED_APK):
        if not path.exists():
            raise SystemExit(f"missing required file: {path}")

    if SIGNED_APK.exists():
        backup = SIGNED_APK.with_suffix(f".apk.bak-align-{os.getpid()}")
        shutil.copy2(SIGNED_APK, backup)
        print(f"backup: {backup}")

    if ALIGNED_APK.exists():
        ALIGNED_APK.unlink()

    run([ZIPALIGN, "-f", "-p", "4", UNSIGNED_APK, ALIGNED_APK])
    run([
        APKSIGNER,
        "sign",
        "--ks", KEYSTORE,
        "--ks-key-alias", "androiddebugkey",
        "--ks-pass", "pass:android",
        "--key-pass", "pass:android",
        "--out", SIGNED_APK,
        ALIGNED_APK,
    ])
    run([ZIPALIGN, "-c", "-p", "4", SIGNED_APK])
    run([APKSIGNER, "verify", "--verbose", SIGNED_APK])
    print(f"ready: {SIGNED_APK}")


if __name__ == "__main__":
    main()
