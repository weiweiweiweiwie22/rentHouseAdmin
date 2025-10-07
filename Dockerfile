# --- 阶段1: 构建阶段 (Build Stage) ---
# 使用一个包含Node.js的环境来构建您的项目
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json (或 yarn.lock)
COPY package*.json ./

# 安装所有依赖
RUN npm install

# 复制您项目的所有源代码
COPY . .

# 执行构建命令，这会在 /app/dist 目录下生成静态文件
RUN npm run build


# --- 阶段2: 生产阶段 (Production Stage) ---
# 使用一个非常轻量级的 Nginx 镜像作为最终的运行环境
FROM nginx:alpine

# 将第一阶段构建好的 /app/dist 文件夹里的所有内容，
# 复制到 Nginx 的默认网站根目录 /usr/share/nginx/html
COPY --from=build /app/dist /usr/share/nginx/html

# (可选) 如果您需要自定义Nginx配置（例如处理路由history模式），
# 您可以在前端项目根目录创建一个 nginx.conf 文件，然后取消下面这行的注释
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 Nginx 默认的 80 端口
EXPOSE 80

# 容器启动时，以非后台模式启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]