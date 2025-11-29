#!/bin/bash

# ===================== 简化判断函数：直接输出结果，不用 action =====================
if_success() {
    if [ $? -eq 0 ]; then
        echo -e "\033[32m✅ 成功：$1\033[0m"  # 绿色成功提示
    else
        echo -e "\033[31m❌ 失败：$2\033[0m"  # 红色失败提示
        exit 1
    fi
}

# ===================== 核心逻辑不变，精简冗余 =====================
Server_Dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
Conf_Dir="$Server_Dir/conf"
Temp_Dir="$Server_Dir/temp"
Log_Dir="$Server_Dir/logs"
URL='你的clash订阅url'

# 确保目录存在（首次运行自动创建）
mkdir -p $Conf_Dir $Temp_Dir $Log_Dir

# 检查 wget 是否安装
if ! command -v wget &> /dev/null; then
    echo -e "\033[31m❌ 错误：未找到 wget 命令，请先安装：sudo apt install wget\033[0m"
    exit 1
fi

# 临时取消环境变量
unset http_proxy
unset https_proxy

# 拉取订阅配置
echo "🔍 正在下载配置文件..."
wget -q -O $Temp_Dir/clash.yaml $URL 
if_success "配置文件下载完成" "配置文件下载失败，请检查网络或订阅地址"

# 提取代理节点（合并到模板）
echo "🔧 正在合并配置文件..."
sed -n '/^proxies:/,$p' $Temp_Dir/clash.yaml > $Temp_Dir/proxy.txt

# 检查模板文件是否存在
if [ ! -f $Temp_Dir/template_config.yaml ]; then
    echo -e "\033[31m❌ 错误：模板文件 $Temp_Dir/template_config.yaml 不存在！\033[0m"
    exit 1
fi

# 合并配置并覆盖到 conf 目录
cat $Temp_Dir/template_config.yaml > $Temp_Dir/config.yaml
cat $Temp_Dir/proxy.txt >> $Temp_Dir/config.yaml
\cp -f $Temp_Dir/config.yaml $Conf_Dir/
if_success "配置文件合并完成" "配置文件合并失败"

# 启动 Clash 服务
echo "🚀 正在启动 Clash 服务..."
# 确保二进制文件可执行
if [ ! -x $Server_Dir/clash-linux-amd64-v1.3.5 ]; then
    chmod +x $Server_Dir/clash-linux-amd64-v1.3.5
fi
# 后台启动并输出日志
nohup $Server_Dir/clash-linux-amd64-v1.3.5 -d $Conf_Dir &> $Log_Dir/clash.log &
sleep 3  # 等待服务初始化

# 验证服务是否启动（检查进程）
ps aux | grep clash-linux-amd64-v1.3.5 | grep -v grep > /dev/null
if_success "Clash 服务启动成功" "Clash 服务启动失败，请查看日志：$Log_Dir/clash.log"

# 设置系统代理环境变量
echo "⚙️ 正在配置系统代理..."
echo -e "export http_proxy=http://127.0.0.1:7890\nexport https_proxy=http://127.0.0.1:7890" > /etc/profile.d/clash.sh
chmod +x /etc/profile.d/clash.sh
if_success "系统代理配置完成" "系统代理配置失败"

# 最终提示
echo -e "\n🎉 所有操作完成！"
echo -e "请在当前窗口执行以下命令加载代理环境变量："
echo -e "\n\033[33msource /etc/profile.d/clash.sh\033[0m"
echo -e "\n测试代理是否生效："
echo -e "\033[33mcurl http://httpbin.org/ip\033[0m"