# ⭐ LH Proxy Helper (High Contrast & Minimalist)

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)
![Version](https://img.shields.io/badge/version-v2.6-blueviolet)

🌐 语言: [English](README.md) | **简体中文**

> **为开发者打造的极简风、高对比度、注重隐私保护的 SSH 代理与映射辅助工具。**

---

## 🚀 这是什么？

**LH Proxy Helper** (命令前缀: `nx`) 是一个经过精心打磨的 Bash 脚本，旨在简化远程服务器上的网络工作流。它遵循 **Unix 哲学**：极简输出、专注做好一件事，并且在退出时自动清理痕迹。

它可以帮你轻松管理：
* **全局代理**：一键切换 `http_proxy` / `https_proxy`，内置 SSH 隧道检测。
* **隐私优先**：退出时自动从 `.bash_history` 中**擦除代理相关命令**，保持历史记录干净。
* **端口映射**：监控远程端口 (如 TensorBoard/WebUI) 并极速生成本地转发命令。
* **环境侦探**：一眼查看 Python 版本、CUDA 状态和 GPU 显存占用。

---

## ✨ 核心功能

* 🎨 **高对比度 UI**：使用 **亮紫 (未开启)** 和 **翠绿 (开启)** 区分状态，在任何背景下都清晰可见。
* 🛡️ **无痕清理**：执行 `nxoff` 或关闭功能时，自动清理 Shell 历史记录中的 `nx...` 命令。
* ⚡ **极简输出**：拒绝废话。只显示你需要的状态和命令。
* 🔌 **零依赖**：纯 Bash 编写，仅需标准工具 (`ssh`, `curl`, `ss`)。
* 🎯 **单次执行**：使用 `nxprun` 仅为单条命令挂载代理，不污染全局环境。
* 🌍 **双语支持**：无缝切换中英文提示 (`nxzh` / `nxen`)。

---

## 📥 安装指南

1.  **克隆仓库：**
    ```bash
    git clone [https://github.com/LiHang-CV/lh-proxy-helper.git](https://github.com/LiHang-CV/lh-proxy-helper.git)
    cd lh-proxy-helper
    ```

2.  **加载脚本：**
    建议将其添加到 shell 配置文件 (`~/.bashrc` 或 `~/.zshrc`) 中以获得持久化体验。
    ```bash
    source /path/to/lh-proxy-helper/nx_proxy.sh
    ```

3.  **生效配置：**
    ```bash
    source ~/.bashrc
    ```

---

## ⚙️ 配置说明

请打开 `nx_proxy.sh` 并修改文件顶部的 **用户配置 (User Configuration)** 区域：

```bash
# ==========================================
# User Configuration / 用户配置
# ==========================================
export NX_LANG="zh"                    # 默认语言: 'zh' (中文) 或 'en' (英文)
export NX_SSH_USER="your_user"         # 远程 SSH 用户名
export NX_SSH_HOST="192.168.1.100"     # 远程服务器 IP
export NX_SSH_PORT="22"                # 远程 SSH 端口
export NX_LOCAL_PROXY_HOST="127.0.0.1" # 本地机器 IP
export NX_LOCAL_PROXY_PORT="7890"      # 本地代理端口 (Clash/V2Ray)
export NX_REMOTE_PROXY_PORT="1080"     # 远程监听端口 (通过 SSH -R 转发)

```

---

## 🧭 使用指南

### 1. 代理控制

| 命令 | 说明 |
| --- | --- |
| **`nxpon`** | 开启代理 (自动检测最佳模式: socks5h > socks5 > http)。 |
| **`nxpon http`** | 强制开启 **HTTP** 模式 (兼容性更好)。 |
| **`nxproxy`** | **查看状态**：显示代理变量、隧道状态及 Google 连通性。 |
| **`nxpoff`** | **关闭代理**：清除环境变量并**擦除历史记录**。 |
| **`nxprun <cmd>`** | **单次执行**：带代理运行命令 (例: `nxprun curl google.com`)。 |

### 2. 端口映射 (远程 -> 本地)

想在本地浏览器查看运行在服务器上的 **TensorBoard** 或 **Jupyter**？

1. **开启监控**：告诉脚本你想映射哪个端口。
```bash
nxmon 6006          # 监控远程 6006 端口
# 或者
nxmon 8888 9000     # 将远程 8888 映射到本地 9000

```


2. **查看状态 & 获取命令**：
```bash
nxmap

```


*输出示例:*
> 映射    : 远端:6006 -> 本地:6006 | 状态: 运行中
> 命令    : ssh -N -L 6006:127.0.0.1:6006 user@host -p 22


3. **停止监控**：
```bash
nxmoff

```



### 3. 系统与诊断

| 命令 | 说明 |
| --- | --- |
| **`nxstatus`** | 显示综合状态报告 (代理 + 映射)。 |
| **`nxinfo`** | **深度巡检**：显示 OS、Python 版本/路径、NVIDIA GPU 显存及工具检查。 |
| **`nxoff`** | **全部重置**：关闭代理 + 关闭映射监控 + 清理历史记录。 |

---

## 💡 最佳实践 (避坑指南)

| 场景 / 工具 | 推荐方案 | 原因 |
| --- | --- | --- |
| **通用网页 (wget/curl)** | `nxpon` (SOCKS5H) | **最安全**。在远程解析 DNS，防止污染。 |
| **Python (`pip`)** | `nxpon` | pip 对 SOCKS5 支持良好。 |
| **Conda / HuggingFace** | `nxprun http ...` | Conda/HF 对 SOCKS 支持较差，HTTP 模式更稳定。 |
| **Git 操作** | `nxprun git pull` | 保持全局环境纯净，用完即走。 |
| **模型训练 (Training)** | **`nxoff`** | **极其重要**。避免代理导致 GPU 分布式通信故障。 |

---

## 👤 作者

**李航**

* 邮箱: lihang041011 [at] gmail.com
* GitHub: [@LiHang-CV](https://www.google.com/search?q=https://github.com/LiHang-CV)

## 📄 许可证

本项目基于 **MIT License** 开源。