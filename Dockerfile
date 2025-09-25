# 使用官方 Node.js 18 作为基础镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制所有项目文件到工作目录
COPY . .

# 构建生产版本的应用
RUN npm run build

# 暴露端口
EXPOSE 80

# 运行应用的命令
CMD ["npm", "run", "preview"]