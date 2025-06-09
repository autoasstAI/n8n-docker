# n8n Docker 自动更新配置

这个仓库包含了用于部署n8n工作流自动化平台的Docker Compose配置，并集成了自动更新功能。

## 功能特点

- 使用官方n8n Docker镜像
- 配置了基本的身份验证
- 数据持久化存储
- 使用Watchtower实现自动更新n8n容器

## 前提条件

- 安装了Docker和Docker Compose
- 基本的命令行操作知识

## 快速开始

### 启动服务

```bash
docker-compose up -d
```

### 停止服务

```bash
docker-compose down
```

### 查看日志

```bash
docker-compose logs -f n8n
```

## 配置说明

### 环境变量

所有配置都存储在`.env`文件中，你可以直接编辑该文件来修改配置：

- `N8N_BASIC_AUTH_USER`: 登录用户名（默认：admin）
- `N8N_BASIC_AUTH_PASSWORD`: 登录密码（默认：password）
- `N8N_HOST`: 主机名（默认：localhost）
- `N8N_PORT`: 端口号（默认：5678）
- `N8N_PROTOCOL`: 协议（默认：http）
- `N8N_ENCRYPTION_KEY`: 加密密钥，用于加密敏感数据
- `GENERIC_TIMEZONE`: 时区设置（默认：Asia/Taipei，台北时区）

### 自动更新配置

Watchtower服务配置为自动检查n8n镜像的更新。如果发现新版本，它会自动下载并重启n8n容器。

你可以在`.env`文件中修改以下设置：

- `WATCHTOWER_INTERVAL`: 更新检查间隔（以秒为单位，默认为86400秒，即24小时）

## 访问n8n

服务启动后，可以通过以下地址访问n8n界面：

```
http://localhost:5678
```

使用在环境变量中设置的用户名和密码登录。

## 數據存儲與備份

n8n的所有數據都存儲在本地的`./data`資料夾中（相對於docker-compose.yml文件所在目錄）。這使得數據更容易訪問、備份和管理。

備份數據只需要複製`data`資料夾即可。

## 安全注意事项

- 在生产环境中，请务必更改默认的用户名、密码和加密密钥
- 考虑使用HTTPS进行安全访问
- 根据需要限制端口访问