#!/usr/bin/env bash
#
# ================================================================
# Script Name: Nx Proxy Helper (High Contrast & Minimalist)
#
# Author: Li Hang
# Email: lihang041011 [at] gmail.com
# Created: 2026-01-05
# Last Modified: 2026-01-27 (V3.0)
#
# 作者：李航
# 邮箱: lihang041011 [at] gmail.com
# 创建时间：2026-01-05
# 最近修改：2026-01-27 (V3.0)
#
# ----------------------- Script (EN) ----------------------------
# This is a comprehensive SSH proxy and port mapping helper script
# featuring a high-contrast visual style and minimalist output.
#
# Key Features:
# 1. Proxy Management: Quickly toggle global proxy settings with
#    tunnel detection and automatic history cleaning (Privacy).
# 2. Port Mapping: Monitor and generate SSH commands for remote
#    port forwarding (Server -> Local), ideal for TensorBoard/WebUI.
# 3. System Diagnostics: Provide detailed system info, GPU status,
#    and tool checks.
# 4. Visuals: Optimized for readability with specific color codes
#    (Purple/Green) for clear status indication.
#
# ----------------------- 摘要（中文）---------------------------
# 这是一个采用高对比度配色和极简输出风格的 SSH 代理与端口映射
# 辅助脚本。
#
# 主要功能：
# 1. 代理管理：快速切换全局代理，包含 SSH 隧道检测，并具备
#    自动清理 Shell 历史记录的隐私保护功能。
# 2. 端口映射：监控并生成远程端口转发命令（服务端 -> 本地），
#    非常适合 TensorBoard、WebUI 等服务的调试。
# 3. 系统诊断：提供详细的系统信息、GPU 显存状态及开发工具检查。
# 4. 视觉优化：使用高辨识度颜色（紫/绿）区分状态，一目了然。
#
# -------------------- Disclaimer (EN) ---------------------------
# This script is provided for personal learning, research,
# and convenience purposes only.
#
# It is distributed "AS IS", without any warranty of any kind.
# The author shall not be held liable for any damages, data loss,
# security issues, or other consequences resulting from use.
#
# Users are responsible for complying with local network policies
# and laws when using SSH tunnels and proxy tools.
#
# -------------------- 免责声明（中文）----------------------------
# 本脚本仅供个人学习、研究与提高使用效率之目的。
#
# 脚本按“原样”提供，不作任何形式的保证。
# 因使用本脚本所导致的任何后果（如数据丢失、安全问题等），
# 作者概不负责。
#
# 使用者在使用 SSH 隧道或代理工具时，应自行遵守所在地的
# 法律法规及网络安全规定。
#
# -------------------- Functions (EN) -----------------------------
# nxzh            : Switch language to Chinese
# nxen            : Switch language to English
# nxpon           : Start proxy (Checks tunnel & sets env)
# nxpoff          : Stop proxy (Clears env & cleans history)
# nxproxy         : Check proxy status (Minimalist output)
# nxmon           : Monitor port mapping (Server -> Local)
# nxmap           : Check mapping status & show SSH command
# nxmoff          : Stop mapping monitor (Cleans history)
# nxrun           : Run single command with proxy enabled
# nxoff           : Reset ALL (Proxy + Map + History)
# nxstatus        : Show combined status report
# nxinfo          : System info, Python/GPU check & tools check
# nxhint          : Show quick usage hints
# nxhelp          : Display help menu
# _nx_clean_hist  : (Internal) Remove 'nx' commands from history
#
# -------------------- 功能（中文）-------------------------------
# nxzh            : 切换为中文提示
# nxen            : 切换为英文提示
# nxpon           : 开启代理（检测隧道并设置环境变量）
# nxpoff          : 关闭代理（清除环境并擦除历史记录）
# nxproxy         : 查看代理状态（极简输出）
# nxmon           : 监控端口映射（服务端 -> 本地）
# nxmap           : 查看映射状态及 SSH 连接命令
# nxmoff          : 停止映射监控（擦除历史记录）
# nxrun           : 单条命令在代理环境下运行
# nxoff           : 全部重置（关闭代理+映射+清理历史）
# nxstatus        : 显示综合状态报告
# nxinfo          : 显示系统、Python/GPU 信息及工具自检
# nxhint          : 显示常用操作提示
# nxhelp          : 显示帮助菜单
# _nx_clean_hist  : (内部) 从历史记录中删除 nx 开头的命令
#
# ---------------- Configuration (EN) ----------------------------
# NX_LANG              : Default language (zh / en)
# NX_SSH_USER          : Remote SSH username
# NX_SSH_HOST          : Remote SSH IP/Domain
# NX_SSH_PORT          : Remote SSH Port
# NX_LOCAL_PROXY_HOST  : Local proxy address (e.g., 127.0.0.1)
# NX_LOCAL_PROXY_PORT  : Local proxy port (e.g., 7890)
# NX_REMOTE_PROXY_PORT : Remote listening port (e.g., 1080)
# NX_TEST_URL          : Connectivity test URL (Google)
# NX_CUR_MAP_PORT      : Current monitored server port
# NX_CUR_MAP_TARGET    : Current mapped local port
#
# ---------------- 配置信息（中文）-------------------------------
# NX_LANG              : 默认提示语言 (zh / en)
# NX_SSH_USER          : 远程 SSH 用户名
# NX_SSH_HOST          : 远程主机地址
# NX_SSH_PORT          : 远程 SSH 端口
# NX_LOCAL_PROXY_HOST  : 本地代理监听地址
# NX_LOCAL_PROXY_PORT  : 本地代理监听端口 (Clash等)
# NX_REMOTE_PROXY_PORT : 远程转发监听端口
# NX_TEST_URL          : 连通性测试地址
# NX_CUR_MAP_PORT      : 当前监控的服务端端口
# NX_CUR_MAP_TARGET    : 当前映射的本地端口
#
# ================================================================

# --- 视觉配置 ---
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_GREEN='\033[1;32m'   # 成功/开启
C_RED='\033[1;31m'     # 失败/错误
C_CYAN='\033[1;36m'    # 标题/命令
C_YELLOW='\033[1;33m'  # 警告
C_WHITE='\033[1;37m'   # 正文
C_PURPLE='\033[1;35m'  # 关闭/空状态 (高亮可见)

# --- 用户配置 ---
export NX_LANG="<LANG>"                          # Default language for messages (zh / en)(usually en)|默认提示语言（通常为 zh）
export NX_SSH_USER="<SSH_USER>"                  # SSH username for remote host|远程 SSH 登录用户名
export NX_SSH_HOST="<SSH_HOST>"                  # Remote SSH host address or domain|远程 SSH 主机地址或域名
export NX_SSH_PORT="<SSH_PORT>"                  # Remote SSH port(usually 22)|远程 SSH 端口（通常为 22）
export NX_LOCAL_PROXY_HOST="<LOCAL_PROXY_HOST>"  # Local proxy listen address (usually 127.0.0.1)|本地代理监听地址（通常为 127.0.0.1）
export NX_LOCAL_PROXY_PORT="<LOCAL_PROXY_PORT>"  # Local proxy listen port (e.g. Clash / V2Ray)(usually 7890)|本地代理监听端口（如 Clash / V2Ray）（通常为 7890）
export NX_REMOTE_PROXY_PORT="<REMOTE_PROXY_PORT>"# Remote exposed proxy port via SSH tunnel(usually 1080)|通过 SSH 隧道暴露到远端的代理端口（通常为 1080）
export NX_TEST_URL="<TEST_URL>"                  # URL used to test proxy connectivity (HTTPS)(usually https://www.google.com)|用于测试代理连通性的 HTTPS 地址（通常为 https://www.google.com）

export NX_CUR_MAP_PORT=""
export NX_CUR_MAP_TARGET=""

# --- 基础函数 ---

nxzh() { export NX_LANG="zh"; echo -e "${C_GREEN}✔ 语言: 中文${C_RESET}"; }
nxen() { export NX_LANG="en"; echo -e "${C_GREEN}✔ Lang: English${C_RESET}"; }

_check_port() { ss -lnt | grep -q ":$1 "; }
_check_net()  { curl -Is --connect-timeout 2 --max-time 2 "$NX_TEST_URL" >/dev/null 2>&1; }

_nx_clean_hist() {
    local hist_file="$HOME/.bash_history"
    [ -f "$hist_file" ] && sed -i '/^nx/d' "$hist_file"
}

# --- 代理核心功能 ---

nxpon() {
    MODE="${1:-socks5h}"

    # 1. 检查隧道是否建立
    if ! _check_port "$NX_REMOTE_PROXY_PORT"; then
        if [ "$NX_LANG" = "zh" ]; then
            echo -e "${C_RED}错误: 隧道端口 $NX_REMOTE_PROXY_PORT 未开启${C_RESET}"
            echo -e "${C_WHITE}请在【本地电脑】执行以下命令建立隧道:${C_RESET}"
            # 生成反向代理命令 (-R)
            echo -e "${C_CYAN}ssh -N -R ${NX_REMOTE_PROXY_PORT}:${NX_LOCAL_PROXY_HOST}:${NX_LOCAL_PROXY_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}${C_RESET}"
        else
            echo -e "${C_RED}Error: Tunnel closed (Port $NX_REMOTE_PROXY_PORT)${C_RESET}"
            echo -e "${C_WHITE}Run this on [Local PC] to setup tunnel:${C_RESET}"
            echo -e "${C_CYAN}ssh -N -R ${NX_REMOTE_PROXY_PORT}:${NX_LOCAL_PROXY_HOST}:${NX_LOCAL_PROXY_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}${C_RESET}"
        fi
        return 1
    fi

    # 2. 备份环境变量
    export _OLD_HTTP_PROXY="$http_proxy"
    export _OLD_HTTPS_PROXY="$https_proxy"
    export _OLD_ALL_PROXY="$ALL_PROXY"

    # 3. 设置新变量
    case "$MODE" in
        socks5h) P_URL="socks5h://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
        socks5)  P_URL="socks5://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
        http)    P_URL="http://${NX_LOCAL_PROXY_HOST}:${NX_REMOTE_PROXY_PORT}" ;;
        *)
            if [ "$NX_LANG" = "zh" ]; then
                echo "未知模式: $MODE"
            else
                echo "Unknown mode: $MODE"
            fi
            return 1
            ;;
    esac

    export http_proxy="$P_URL"
    export https_proxy="$P_URL"
    export ALL_PROXY="$P_URL"

    # 4. 显示状态
    nxproxy
}

nxproxy() {
    local l_p="PROXY" l_t="TUNNEL" l_g="GOOGLE"
    local s_on="ON" s_off="OFF" s_ok="OK" s_down="DOWN" s_con="200 OK" s_fail="FAIL"

    if [ "$NX_LANG" = "zh" ]; then
        l_p="代理" l_t="隧道" l_g="谷歌"
        s_on="开启" s_off="关闭" s_ok="正常" s_down="断开" s_con="连通" s_fail="失败"
    fi

    [ -n "$http_proxy" ] && S_ENV="${C_GREEN}$s_on${C_RESET}" || S_ENV="${C_PURPLE}$s_off${C_RESET}"

    if _check_port "$NX_REMOTE_PROXY_PORT"; then
        S_TUN="${C_GREEN}$s_ok${C_RESET}"
    else
        S_TUN="${C_RED}$s_down${C_RESET}"
    fi

    S_NET="${C_PURPLE}-${C_RESET}"
    if [ -n "$http_proxy" ]; then
        if _check_net; then S_NET="${C_GREEN}$s_con${C_RESET}"; else S_NET="${C_RED}$s_fail${C_RESET}"; fi
    fi

    if [ "$NX_LANG" = "zh" ]; then
        printf "${C_CYAN}%-4s${C_RESET} : %b  (%s)\n" "$l_p" "$S_ENV" "${http_proxy:-无}"
        printf "${C_CYAN}%-4s${C_RESET} : %b  (:%s)\n" "$l_t" "$S_TUN" "$NX_REMOTE_PROXY_PORT"
        printf "${C_CYAN}%-4s${C_RESET} : %b\n" "$l_g" "$S_NET"
    else
        printf "${C_CYAN}%-6s${C_RESET} : %b  (%s)\n" "$l_p" "$S_ENV" "${http_proxy:-none}"
        printf "${C_CYAN}%-6s${C_RESET} : %b  (:%s)\n" "$l_t" "$S_TUN" "$NX_REMOTE_PROXY_PORT"
        printf "${C_CYAN}%-6s${C_RESET} : %b\n" "$l_g" "$S_NET"
    fi
}

nxpoff() {
    local was_active="no"

    if [ -n "$http_proxy" ]; then
        was_active="yes"
        [ -n "$_OLD_HTTP_PROXY" ] && export http_proxy="$_OLD_HTTP_PROXY" || unset http_proxy
        [ -n "$_OLD_HTTPS_PROXY" ] && export https_proxy="$_OLD_HTTPS_PROXY" || unset https_proxy
        [ -n "$_OLD_ALL_PROXY" ] && export ALL_PROXY="$_OLD_ALL_PROXY" || unset ALL_PROXY
        unset _OLD_HTTP_PROXY _OLD_HTTPS_PROXY _OLD_ALL_PROXY
    fi

    _nx_clean_hist

    if [ "$NX_LANG" = "zh" ]; then
        if [ "$was_active" = "yes" ]; then
            echo -e "${C_PURPLE}代理已清除${C_RESET}"
        else
            echo -e "${C_PURPLE}当前未开启代理${C_RESET}"
        fi
    else
        if [ "$was_active" = "yes" ]; then
            echo -e "${C_PURPLE}Proxy cleared.${C_RESET}"
        else
            echo -e "${C_PURPLE}No active proxy${C_RESET}"
        fi
    fi
}

# --- 映射核心功能 ---

nxmon() {
    if [ -z "$1" ]; then
        if [ "$NX_LANG" = "zh" ]; then
            echo "用法: nxmon <服务端端口> [本地端口]"
        else
            echo "Usage: nxmon <ServerPort> [LocalPort]"
        fi
        return 1
    fi
    export NX_CUR_MAP_PORT="$1"
    export NX_CUR_MAP_TARGET="${2:-$1}"
    nxmap
}

nxmap() {
    local l_m="MAP" l_c="CMD" l_svr="Server" l_loc="Local" l_app="App"
    local s_run="Running" s_stop="Stopped" msg_no="MAP:No mapping active."

    if [ "$NX_LANG" = "zh" ]; then
        l_m="映射" l_c="命令" l_svr="远端" l_loc="本地" l_app="状态"
        s_run="运行中" s_stop="已停止" msg_no="映射：当前无映射记录"
    fi

    if [ -z "$NX_CUR_MAP_PORT" ]; then
        echo -e "${C_PURPLE}$msg_no${C_RESET}"
        return
    fi

    if _check_port "$NX_CUR_MAP_PORT"; then
        APP_STAT="${C_GREEN}$s_run${C_RESET}"
    else
        APP_STAT="${C_RED}$s_stop${C_RESET}"
    fi

    if [ "$NX_LANG" = "zh" ]; then
        echo -e "${C_CYAN}$l_m${C_RESET}    : ${C_WHITE}$l_svr:${C_GREEN}${NX_CUR_MAP_PORT}${C_RESET} -> ${C_WHITE}$l_loc:${C_GREEN}${NX_CUR_MAP_TARGET}${C_RESET} | $l_app: $APP_STAT"
        echo -e "${C_CYAN}$l_c${C_RESET}    : ssh -N -L ${NX_CUR_MAP_TARGET}:127.0.0.1:${NX_CUR_MAP_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
    else
        echo -e "${C_CYAN}$l_m${C_RESET}    : $l_svr:${C_GREEN}${NX_CUR_MAP_PORT}${C_RESET} -> $l_loc:${C_GREEN}${NX_CUR_MAP_TARGET}${C_RESET} | $l_app: $APP_STAT"
        echo -e "${C_CYAN}$l_c${C_RESET}    : ssh -N -L ${NX_CUR_MAP_TARGET}:127.0.0.1:${NX_CUR_MAP_PORT} ${NX_SSH_USER}@${NX_SSH_HOST} -p ${NX_SSH_PORT}"
    fi
}

nxmoff() {
    local was_active="no"

    if [ -n "$NX_CUR_MAP_PORT" ]; then
        was_active="yes"
        unset NX_CUR_MAP_PORT NX_CUR_MAP_TARGET
    fi

    _nx_clean_hist

    if [ "$NX_LANG" = "zh" ]; then
        if [ "$was_active" = "yes" ]; then
            echo -e "${C_PURPLE}映射记录已清除${C_RESET}"
        else
            echo -e "${C_PURPLE}当前无映射记录${C_RESET}"
        fi
    else
        if [ "$was_active" = "yes" ]; then
            echo -e "${C_PURPLE}Map cleared.${C_RESET}"
        else
            echo -e "${C_PURPLE}No active map${C_RESET}"
        fi
    fi
}

# --- 辅助工具 ---

nxprun() {
    if [ -z "$1" ]; then
        if [ "$NX_LANG" = "zh" ]; then
            echo "用法: nxprun [mode] <命令>"
        else
            echo "Usage: nxprun [mode] <cmd>"
        fi
        return 1
    fi
    local mode="socks5h"
    case "$1" in socks5h|socks5|http) mode="$1"; shift ;; esac

    nxpon "$mode" >/dev/null

    if [ "$NX_LANG" = "zh" ]; then
        echo -e "${C_CYAN}执行:${C_RESET} $@"
    else
        echo -e "${C_CYAN}Exec:${C_RESET} $@"
    fi

    "$@"
    local ret=$?
    nxpoff
    return $ret
}

nxoff() {
    nxpoff >/dev/null
    nxmoff >/dev/null
    if [ "$NX_LANG" = "zh" ]; then
        echo -e "${C_GREEN}✔ 所有代理及映射设置已清除${C_RESET}"
    else
        echo -e "${C_GREEN}✔ All proxy & map settings cleared.${C_RESET}"
    fi
    nxstatus
}

nxstatus() {
    if [ "$NX_LANG" = "zh" ]; then
        echo -e "${C_BOLD}==== 状态报告 ====${C_RESET}"
    else
        echo -e "${C_BOLD}=== Status Report ===${C_RESET}"
    fi
    nxproxy
    echo -e "${C_BOLD}-------------------${C_BOLD}"
    nxmap
    echo -e "${C_BOLD}===================${C_BOLD}"
}

nxinfo() {
    local _os_name=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
    local _kernel=$(uname -r)
    local _ip=$(hostname -I | awk '{print $1}')

    local _py_ver="N/A"
    local _py_path="N/A"
    if command -v python3 >/dev/null 2>&1; then
        _py_ver=$(python3 -V 2>&1 | awk '{print $2}')
        _py_path=$(which python3)
    fi

    local _gpu_info="N/A"
    local _cuda_ver="N/A"
    if command -v nvidia-smi >/dev/null 2>&1; then
        _gpu_info=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | head -n 1 | awk -F', ' '{print $1 " (" $2 " MB)"}')
        _cuda_ver=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
    fi

    if [ "$NX_LANG" = "zh" ]; then
        echo -e "\n${C_CYAN}=== 系统概览 (System Info) ===${C_RESET}"
        printf "  %-10s: %s\n" "用户" "${C_BOLD}$(whoami)${C_RESET} @ ${C_BOLD}$(hostname)${C_RESET}"
        printf "  %-10s: %s\n" "系统" "${_os_name} ($_kernel)"
        printf "  %-10s: %s\n" "IP地址" "${C_GREEN}${_ip}${C_RESET}"

        echo -e "\n${C_CYAN}=== 计算环境 (Compute Env) ===${C_RESET}"
        printf "  %-10s: ${C_GREEN}%s${C_RESET} -> %s\n" "Python" "$_py_ver" "$_py_path"
        if [ "$_gpu_info" != "N/A" ]; then
            printf "  %-10s: ${C_GREEN}%s${C_RESET} (CUDA: $_cuda_ver)\n" "GPU" "$_gpu_info"
        else
            printf "  %-10s: ${C_PURPLE}未检测到 NVIDIA GPU${C_RESET}\n" "GPU"
        fi

        echo -e "\n${C_CYAN}=== 常用工具 (Tools) ===${C_RESET}"
    else
        echo -e "\n${C_CYAN}=== System Info ===${C_RESET}"
        printf "  %-10s: %s\n" "User" "${C_BOLD}$(whoami)${C_RESET} @ ${C_BOLD}$(hostname)${C_RESET}"
        printf "  %-10s: %s\n" "OS" "${_os_name} ($_kernel)"
        printf "  %-10s: %s\n" "IP" "${C_GREEN}${_ip}${C_RESET}"

        echo -e "\n${C_CYAN}=== Compute Env ===${C_RESET}"
        printf "  %-10s: ${C_GREEN}%s${C_RESET} -> %s\n" "Python" "$_py_ver" "$_py_path"
        if [ "$_gpu_info" != "N/A" ]; then
            printf "  %-10s: ${C_GREEN}%s${C_RESET} (CUDA: $_cuda_ver)\n" "GPU" "$_gpu_info"
        else
            printf "  %-10s: ${C_PURPLE}No NVIDIA GPU detected${C_RESET}\n" "GPU"
        fi

        echo -e "\n${C_CYAN}=== Tools Check ===${C_RESET}"
    fi

    local i=0
    for tool in ss curl ssh git docker htop vim tmux; do
        if command -v "$tool" >/dev/null 2>&1; then
            printf "  ${C_GREEN}✓${C_RESET} %-10s" "$tool"
        else
            printf "  ${C_PURPLE}✗${C_RESET} %-10s" "$tool"
        fi

        ((i++))
        if [ $((i % 4)) -eq 0 ]; then echo ""; fi
    done
    [ $((i % 4)) -ne 0 ] && echo "" # 补换行

    echo -e "\n"
    nxstatus
    nvidia-smi >/dev/null 2>&1 && nvidia-smi
}

nxhint() {
    if [ "$NX_LANG" = "zh" ]; then
         echo -e "${C_CYAN}💡 常用指南${C_RESET}"
         echo -e "  1. 下载/传数据 : ${C_GREEN}nxpon${C_RESET}"
         echo -e "  2. 跑Python代码: ${C_GREEN}nxprun http python xxx.py${C_RESET}"
         echo -e "  3. 映射 TensorBoard: ${C_CYAN}nxmon 6006${C_RESET}"
    else
         echo -e "${C_CYAN}💡 Quick Hints${C_RESET}"
         echo -e "  1. Download/Git: ${C_GREEN}nxpon${C_RESET}"
         echo -e "  2. Run Python  : ${C_GREEN}nxprun http python xxx.py${C_RESET}"
         echo -e "  3. Map TensorBoard: ${C_CYAN}nxmon 6006${C_RESET}"
    fi
}

nxhelp() {
    if [ "$NX_LANG" = "zh" ]; then
        echo -e "\n${C_CYAN}Nx 助手${C_RESET}"
        echo "-----------------------"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxpon" "开启代理"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxpoff" "关闭代理"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxproxy" "查看代理状态"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxmon" "监控端口映射"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxmap" "查看映射状态"
        printf "  ${C_YELLOW}%-10s${C_RESET} : %s\n" "nxoff" "全部关闭"
        printf "  ${C_WHITE}%-10s${C_RESET} : %s\n" "nxinfo" "环境信息检查"
        printf "  ${C_WHITE}%-10s${C_RESET} : %s\n" "nxhint" "常用场景提示"
    else
        echo -e "\n${C_CYAN}Nx Helper${C_RESET}"
        echo "-----------------------"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxpon" "Start Proxy"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxpoff" "Stop Proxy"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxproxy" "Check Proxy"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxmon" "Monitor Map"
        printf "  ${C_GREEN}%-10s${C_RESET} : %s\n" "nxmap" "Check Map"
        printf "  ${C_YELLOW}%-10s${C_RESET} : %s\n" "nxoff" "Reset All"
        printf "  ${C_WHITE}%-10s${C_RESET} : %s\n" "nxinfo" "Env Info"
        printf "  ${C_WHITE}%-10s${C_RESET} : %s\n" "nxhint" "Quick Hints"
    fi
    echo ""
}