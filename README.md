# ⭐ LH Proxy Helper (High Contrast & Minimalist)

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)
![Version](https://img.shields.io/badge/version-v2.6-blueviolet)

🌐 Language: **English** | [简体中文](README.zh-CN.md)

> **A minimalist, high-contrast, and privacy-aware SSH proxy helper for developers.**
>
> 一个极简风、高对比度、注重隐私保护的 SSH 代理与映射辅助工具。

---

## 🚀 What is this?

**LH Proxy Helper** (command prefix: `nx`) is a refined Bash script designed to simplify network workflows on remote servers. It adopts the **Unix Philosophy**: minimalist output, do one thing well, and clean up after itself.

It helps you manage:
* **Global Proxy**: Toggle `http_proxy` / `https_proxy` with SSH tunnel detection.
* **Privacy First**: Automatically **cleans command history** (`.bash_history`) of proxy-related commands upon exit.
* **Port Mapping**: Monitor remote ports (TensorBoard/WebUI) and generate SSH forwarding commands instantly.
* **Environment Inspector**: Check Python versions, CUDA status, and GPU memory in one glance.

---

## ✨ Features

* 🎨 **High Contrast UI**: Uses **Purple** (Inactive) and **Green** (Active) for clear status visibility on any background.
* 🛡️ **Trace Cleaning**: `nxoff` automatically removes `nx...` commands from your shell history to keep it clean.
* ⚡ **Minimalist Output**: No noise. Just the status and the commands you need.
* 🔌 **Zero Dependencies**: Pure Bash. Requires only `ssh`, `curl`, `ss`.
* 🎯 **One-Shot Execution**: Run `git` or `pip` with proxy using `nxprun` without polluting global env.
* 🌍 **Bilingual**: Seamless switching between English and Chinese (`nxen` / `nxzh`).

---

## 📥 Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/LiHang-CV/lh-proxy-helper.git](https://github.com/LiHang-CV/lh-proxy-helper.git)
    cd lh-proxy-helper
    ```

2.  **Source the script:**
    Add this to your shell profile (`~/.bashrc` or `~/.zshrc`) for persistence.
    ```bash
    source /path/to/lh-proxy-helper/nx_proxy.sh
    ```

3.  **Apply changes:**
    ```bash
    source ~/.bashrc
    ```

---

## ⚙️ Configuration

Open `nx_proxy.sh` and edit the **User Configuration** section at the top:

```bash
# ==========================================
# User Configuration
# ==========================================
export NX_LANG="en"                    # Default: 'zh' or 'en'
export NX_SSH_USER="your_user"         # Remote SSH Username
export NX_SSH_HOST="192.168.1.100"     # Remote IP
export NX_SSH_PORT="22"                # Remote Port
export NX_LOCAL_PROXY_HOST="127.0.0.1" # Local Machine IP
export NX_LOCAL_PROXY_PORT="7890"      # Local Proxy Port (Clash/V2Ray)
export NX_REMOTE_PROXY_PORT="1080"     # Remote Listening Port (via SSH -R)

```

---

## 🧭 Usage Guide

### 1. Proxy Controls

| Command | Description |
| --- | --- |
| **`nxpon`** | Start proxy (Auto-detects mode: socks5h > socks5 > http). |
| **`nxpon http`** | Force enable **HTTP** mode. |
| **`nxproxy`** | **Check Status**: Shows Proxy Env, Tunnel Status, and Google Connectivity. |
| **`nxpoff`** | **Stop Proxy**: Clears env vars and **cleans history**. |
| **`nxprun <cmd>`** | **One-Shot**: Run a command with proxy (e.g., `nxprun curl google.com`). |

### 2. Port Mapping (Remote -> Local)

Useful for accessing services like **TensorBoard** or **Jupyter** running on the remote server.

1. **Start Monitoring**: Tell the script which port you want to map.
```bash
nxmon 6006          # Monitor remote port 6006
# OR
nxmon 8888 9000     # Map remote 8888 to local 9000

```


2. **Check Status & Get Command**:
```bash
nxmap

```


*Output:*
> MAP : Server:6006 -> Local:6006 | App: Running
> CMD : ssh -N -L 6006:127.0.0.1:6006 user@host -p 22


3. **Stop Monitoring**:
```bash
nxmoff

```



### 3. System & Diagnostics

| Command | Description |
| --- | --- |
| **`nxstatus`** | Combined report of Proxy and Map status. |
| **`nxinfo`** | **Deep Inspection**: Shows OS, Python version/path, NVIDIA GPU status, and tools check. |
| **`nxoff`** | **Reset All**: Stops Proxy + Map and cleans history. |

---

## 💡 Best Practices

| Tool / Scenario | Recommendation | Why? |
| --- | --- | --- |
| **General Web (wget/curl)** | `nxpon` (SOCKS5H) | **Safest.** Resolves DNS remotely. |
| **Python (`pip`)** | `nxpon` | Works well with default SOCKS5. |
| **Conda / HuggingFace** | `nxprun http ...` | Conda/HF often fail with SOCKS; HTTP is more stable. |
| **Git Operations** | `nxprun git pull` | Keep your global shell clean. |
| **Model Training** | **`nxoff`** | **Critical.** Ensure no proxy interference during GPU/Distributed communication. |

---

## 👤 Author

**Li Hang**

* Email: lihang041011 [at] gmail.com
* GitHub: [@LiHang-CV](https://www.google.com/search?q=https://github.com/LiHang-CV)

## 📄 License

This project is licensed under the **MIT License**.
