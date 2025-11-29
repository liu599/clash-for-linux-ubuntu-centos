<div align="center">
  <h1>Clash for Linux · 简单的 Linux 代理工具</h1>
  <img src="https://img.shields.io/badge/Shell-Bash-4EAA25.svg" alt="Shell" />
  <img src="https://img.shields.io/badge/Linux-Ubuntu%20%7C%20CentOS-E95420.svg" alt="Linux" />
  <img src="https://img.shields.io/badge/Clash-Core-blue.svg" alt="Clash" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
</div>

<div align="center">
  <p>🚀 基于 Clash 核心的 Linux 代理脚本，支持 Ubuntu 与 CentOS 系统</p>
  <p>⚡️ 解决服务器下载 GitHub 等国外资源速度慢的问题，一键启动，高速畅连</p>
</div>

---

## 📖 项目简介

本项目是通过集成开源项目 [Clash](https://github.com/Dreamacro/clash) 作为核心程序，结合 Shell 脚本实现简单的代理功能。旨在为 Linux 服务器环境提供便捷的代理服务，解决开发过程中遇到的网络瓶颈。

---

## 🚀 核心功能

- 🐧 **多系统支持**：专为 Ubuntu 和 CentOS 优化，提供独立的启动脚本。
- 🔧 **自动配置**：自动下载订阅配置，并与本地模板合并，无需手动繁琐配置。
- ⚡️ **一键启动**：简单的脚本命令即可完成服务启动与环境变量设置。
- 🧹 **优雅关闭**：提供关闭脚本，自动清理进程与环境变量。

---

## ⚙️ 快速开始

### 1. 下载项目

```bash
$ git clone https://github.com/Shane-u/clash-for-linux-ubuntu-centos.git
$ cd clash-for-linux-ubuntu-centos
```

### 2. 配置订阅地址

根据您的系统选择对应的启动脚本，编辑脚本文件，修改 `URL` 变量的值为您自己的 Clash 订阅地址。

**Ubuntu 用户:**
```bash
$ vim start-for-ubuntu.sh
# 修改 URL='你的clash订阅url'
```

**CentOS 用户:**
```bash
$ vim start-for-centos.sh
# 修改 URL='你的clash订阅url'
```

### 3. 启动程序

运行对应的启动脚本：

**Ubuntu:**
```bash
$ sudo bash start-for-ubuntu.sh
```

**CentOS:**
```bash
$ sudo bash start-for-centos.sh
```

脚本执行成功后，会提示加载环境变量。请在当前窗口执行提示的命令：

```bash
$ source /etc/profile.d/clash.sh
```

### 4. 验证服务

- **检查端口**：
```bash
$ netstat -tln | grep -E '9090|789.'
```
*正常情况下应看到 9090 (RESTful API), 7890 (HTTP), 7891 (SOCKS5) 等端口在监听。*

- **检查环境变量**：
```bash
$ env | grep -E 'http_proxy|https_proxy'
```
*应输出 http_proxy 和 https_proxy 指向 127.0.0.1:7890。*

---

## 🛑 停止程序

进入项目目录，运行关闭脚本：

```bash
$ sudo bash shutdown.sh
```

脚本执行后，请根据提示手动移除当前会话的环境变量（或者直接关闭终端窗口）：

```bash
$ unset http_proxy
$ unset https_proxy
```

---

## ⚠️ 使用须知

- **订阅地址**：本项目**不提供**任何订阅信息，请自行准备 Clash 订阅地址。
- **依赖检查**：脚本依赖 `wget` 进行文件下载，依赖 `netstat` (net-tools) 检查端口，请确保系统已安装这些工具。
- **权限**：建议使用 `root` 用户或 `sudo` 权限运行脚本，以确保能正确写入 `/etc/profile.d/` 和管理进程。
- **系统兼容**：已在 Ubuntu 和 CentOS (RHEL系列) 测试通过，其他 Linux 发行版可能需要微调脚本。

---

## 👨‍💻 维护者

| 姓名  | 角色       | 联系方式 |
|-------|------------|----------|
| Shane | 项目开发者 | 1554096735@qq.com |

> 欢迎 Issue / PR 参与共建！

---

## 📄 License

本项目基于 MIT License 开源，您可以自由使用、修改和分发本项目。
