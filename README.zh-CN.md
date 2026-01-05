# ⭐ LH Proxy Helper —— 面向开发者的轻量级 SSH 代理辅助脚本

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)
![Version](https://img.shields.io/badge/version-v0.1.0-blueviolet)

🌐 语言：简体中文 | [English](README.md)

> 一个面向开发者的轻量级 SSH 代理辅助脚本
> 
> 专注解决：代理开启混乱、环境污染、调试困难的问题

---

## 🚀 这是什么？

**LH Proxy Helper** 是一个 **单文件 Bash 脚本**，用于简化以下操作：

* 开启 / 关闭代理环境变量
* 管理 SSH 反向隧道代理
* 在 **SOCKS5H / SOCKS5 / HTTP** 代理模式间切换
* 对**单条命令**临时启用代理（不污染环境）
* 诊断 SSH 隧道与 HTTPS 连通性问题

它来源于**真实开发场景**，特别适用于：

* 🌐 网络受限环境
* 🖥️ 远程服务器 / 跳板机
* 📦 包管理器（pip / conda / git）
* 🐍 Python 脚本（requests / httpx / huggingface）

---

## ✨ 特性一览

* 🔌 一条命令开启 / 关闭代理
* 🧠 自动检测可用代理模式
* 🎯 单命令代理执行（`lhrun`，强烈推荐）
* 🔍 SSH 隧道 + HTTPS 联合诊断
* 🌍 支持 SOCKS5H / SOCKS5 / HTTP
* 🌐 中英文提示自由切换
* 🧪 内置自检与状态查看
* 📄 单文件、无额外依赖

---

## 🤔 为什么我写了这个脚本

我写 **LH Proxy Helper**，完全是被真实开发场景“逼出来的”。

在实际工作中，我经常需要在**网络受限的环境**或**远程服务器**上开发。
SSH 隧道本身并不复杂，但真正麻烦的是**代理环境的管理**：

- 忘记关闭代理，导致其他命令莫名其妙失败
- 不同工具对代理协议的支持差异很大
- 只想让某一条命令走代理，却污染了整个 shell 环境
- 出问题时，很难快速判断是隧道、代理还是工具本身的问题

我想要的是一个：

- **透明的**：不搞黑魔法，只操作环境变量
- **不侵入的**：只影响当前 shell，会话结束即恢复
- **实用的**：为 `pip`、`conda`、`git`、Python 脚本等真实工具优化
- **可诊断的**：能快速知道“到底哪里出了问题”

于是，与其每次手动 export / unset 一堆变量，
不如把这些重复、容易出错的步骤整理成一个可靠的小脚本。

**LH Proxy Helper 本质上就是我每天在用的工具的提炼版。**  
如果它能帮你少踩一次坑、少浪费几分钟排查时间，那它就已经完成使命了。

---

## 📦 运行环境要求

需要系统中存在以下工具（大多数 Linux 已默认安装）：

* `bash`
* `ssh`
* `curl`
* `ss`（来自 `iproute2`）

---

## 📥 安装

```bash
git clone https://github.com/LiHang-CV/lh-proxy-helper.git
cd lh-proxy-helper
chmod +x lh_proxy.sh
```

加载到当前 shell：

```bash
source /path/to/lh_proxy.sh
```

> 💡 建议把 `source` 写入 `~/.bashrc` 或 `~/.zshrc`，永久生效。

---

## ⚙️ 配置说明

编辑 `lh_proxy.sh` 中的 **User Configuration / 用户配置** 部分：

```bash
LH_LANG="<LANG>"                          # zh / en
LH_SSH_USER="<SSH_USER>"                  # SSH 用户名
LH_SSH_HOST="<SSH_HOST>"                  # SSH 主机地址或域名
LH_SSH_PORT="<SSH_PORT>"                  # 通常为 22
LH_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # 通常为 127.0.0.1
LH_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # 如 7890（Clash / V2Ray）
LH_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# 通常为 1080
LH_TEST_URL="<TEST_URL>"                  # 如 https://www.google.com
```

---

## 🔑 必须先启动 SSH 隧道

在开启代理前，需要先在本地启动 SSH 反向隧道：

```bash
ssh -N -R <REMOTE_PROXY_PORT>:<LOCAL_PROXY_HOST>:<LOCAL_PROXY_PORT> \
    <SSH_USER>@<SSH_HOST> -p <SSH_PORT>
```

---

## 🧭 使用示例

### 自动检测并开启代理（推荐）

```bash
lhon
```

### 指定代理模式

```bash
lhon socks5h
lhon http
```

### 单条命令使用代理（强烈推荐）

```bash
lhrun http python script.py
```

### 关闭代理并恢复环境

```bash
lhoff
```

### 查看当前代理环境变量

```bash
lhproxy
```

### 检查 SSH 隧道与 HTTPS

```bash
lhcheck
```

### 查看综合状态

```bash
lhstatus
```

---

## 🐍 Python / 包管理器使用建议

| 场景                  | 推荐方式                           |
| ------------------- | ------------------------------ |
| wget / curl / git   | `lhon`（默认 socks5h）             |
| pip install         | `lhon`                         |
| conda install       | `lhrun http conda install ...` |
| httpx / huggingface | `lhrun http python script.py`  |
| 长时间训练 / 推理          | `lhoff`（避免代理抖动）                |

---

## 🌐 语言切换

```bash
lhzh   # 中文
lhen   # 英文
```

---

## 🧪 自检与诊断

```bash
lhinfo
```

将显示：

* 当前 shell / 用户 / 主机
* 必要工具是否可用
* 代理与 SSH 隧道状态

---

## 🛡️ 安全说明与免责声明

本脚本具有以下安全特性：

* ❌ 不保存任何账号或密码
* ❌ 不修改系统级代理配置
* ❌ 不写入配置文件
* ✅ 仅作用于当前 shell 会话

请在遵守当地法律法规及网络使用规范的前提下使用。

---

## 👤 作者 & 联系方式

**Li Hang**

📧 [lihang041011@gmail.com](mailto:lihang041011@gmail.com)

---

## 📄 开源协议

本项目基于 **MIT License** 开源。

---

## ⭐ 为什么你可能会想 Star 这个项目？

* Bash 脚本结构清晰、可读性高
* 解决的是开发者真实会遇到的问题
* 不侵入、不“魔法”、不污染环境
* 非常适合 fork 后按自己需求定制

如果这个脚本对你有帮助，欢迎 ⭐ Star 支持 🙂

---
