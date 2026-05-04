FROM python:3.12-slim

LABEL maintainer="MiAir"
LABEL description="DLNA/AirPlay receiver for Xiaomi AI Speaker"

# 保持官方默认源，仅安装必要的依赖（包含群友补充的 dnsutils）
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libportaudio2 \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml .
# 保持官方 pip 源进行安装
RUN pip install --no-cache-dir . --root-user-action=ignore

COPY miair.py ./
COPY miair/ ./miair/

# 保留群友的优秀修改：统一配置文件夹
RUN mkdir -p /app/conf

EXPOSE 8200 8300

# 启动命令指向新建的配置文件夹
ENTRYPOINT ["python", "miair.py", "--conf-path", "/app/conf"]