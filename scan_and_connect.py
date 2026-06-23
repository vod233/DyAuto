import socket
import subprocess
import concurrent.futures
import ipaddress
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_local_ip():
    """获取本地局域网IP"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # 连接一个公共DNS以获取出网的本地IP
        s.connect(('8.8.8.8', 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception as e:
        logging.error(f"无法获取本地IP: {e}")
        return "192.168.1.100"  # 默认回退值

def check_port_and_connect(ip):
    """探测 5555 端口并在开放时连接 ADB"""
    port = 5555
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(1.0) # 设置1秒超时
    result = s.connect_ex((ip, port))
    s.close()
    
    if result == 0:
        logging.info(f"发现设备，IP: {ip}:{port} 端口开放，尝试连接 ADB...")
        # 后台执行系统命令 adb connect
        cmd = f"adb connect {ip}:{port}"
        try:
            process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = process.communicate(timeout=5)
            if b"connected" in stdout or b"already" in stdout:
                logging.info(f"成功连接设备: {ip}:{port}")
            else:
                logging.warning(f"执行返回: {stdout.decode('utf-8', errors='ignore').strip()}")
        except Exception as e:
            logging.error(f"执行 {cmd} 时出错: {e}")
    return result == 0

def scan_network():
    local_ip = get_local_ip()
    logging.info(f"本机 IP: {local_ip}")
    
    # 构造 /24 网段
    network_str = f"{local_ip.rsplit('.', 1)[0]}.0/24"
    network = ipaddress.IPv4Network(network_str, strict=False)
    
    # 剔除网络地址和广播地址
    ips_to_scan = [str(ip) for ip in network.hosts()]
    
    logging.info(f"开始扫描网段: {network_str}，共 {len(ips_to_scan)} 个 IP")
    
    # 开启 100 个线程快速扫描
    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = {executor.submit(check_port_and_connect, ip): ip for ip in ips_to_scan}
        for future in concurrent.futures.as_completed(futures):
            try:
                future.result()
            except Exception as e:
                pass
                
    logging.info("局域网扫描与 ADB 连接任务完成。")

if __name__ == "__main__":
    scan_network()